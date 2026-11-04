const SYSTEM = `You are an investigator playing a bounded text detective game. You receive what the detective can currently observe, a short guide to common actions, the action words currently available, and the response to your previous attempt. The action words are only command heads, not a list of legal commands or targets. Follow an action template in the guide when one is provided; otherwise infer a plausible completion from the scene, people, and evidence. If observation.choices is nonempty, choose one of its listed action values exactly. The game engine validates every action. Learn from refusals and continue investigating. You have no tools and no access to game files. Return only JSON of the form {"action":"your attempted action"}. Work toward a well-supported conclusion rather than accusing too early.`;

function parseAction(text) {
  try {
    const parsed = JSON.parse(text);
    if (typeof parsed.action === "string") return parsed.action;
  } catch { /* submit the unparsed answer so the engine records the invalid move */ }
  return String(text).trim();
}

async function request(url, headers, body, timeoutMs) {
  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(new Error("model_timeout")), timeoutMs);
  const started = Date.now();
  try {
    const response = await fetch(url, { method: "POST", headers, body: JSON.stringify(body), signal: controller.signal });
    const payload = await response.json();
    if (!response.ok) throw new Error(`Provider HTTP ${response.status}: ${JSON.stringify(payload).slice(0, 500)}`);
    return { payload, latencyMs: Date.now() - started };
  } catch (error) {
    if (controller.signal.aborted) {
      const timeout = new Error(`Model request exceeded ${timeoutMs} ms.`);
      timeout.code = "timeout_limit";
      throw timeout;
    }
    throw error;
  } finally { clearTimeout(timer); }
}

export async function chooseModelAction({ provider, model, apiKey, observation, lastFeedback = null, timeoutMs = 60_000, baseUrl }) {
  const input = JSON.stringify({ observation, previous_action_feedback: lastFeedback });
  const providers = {
    openai: async () => {
      const { payload, latencyMs } = await request(baseUrl || "https://api.openai.com/v1/responses", {
        Authorization: `Bearer ${apiKey}`, "Content-Type": "application/json",
      }, { model, instructions: SYSTEM, input }, timeoutMs);
      const text = payload.output?.flatMap((item) => item.content || []).find((part) => part.type === "output_text")?.text ?? payload.output_text ?? "";
      return { action: parseAction(text), latencyMs, usage: payload.usage || null, raw: text };
    },
    anthropic: async () => {
      const { payload, latencyMs } = await request(baseUrl || "https://api.anthropic.com/v1/messages", {
        "x-api-key": apiKey, "anthropic-version": process.env.ANTHROPIC_VERSION || "2023-06-01", "content-type": "application/json",
      }, { model, max_tokens: 300, system: SYSTEM, messages: [{ role: "user", content: input }] }, timeoutMs);
      const text = payload.content?.filter((part) => part.type === "text").map((part) => part.text).join("\n") || "";
      return { action: parseAction(text), latencyMs, usage: payload.usage || null, raw: text };
    },
    gemini: async () => {
      const { payload, latencyMs } = await request(baseUrl || "https://generativelanguage.googleapis.com/v1beta/interactions", {
        "x-goog-api-key": apiKey, "Content-Type": "application/json",
      }, { model, system_instruction: SYSTEM, input, store: false }, timeoutMs);
      const text = payload.steps?.filter((step) => step.type === "model_output").flatMap((step) => step.content || []).filter((part) => part.type === "text").map((part) => part.text).join("\n") || "";
      return { action: parseAction(text), latencyMs, usage: payload.usage || null, raw: text };
    },
  };
  if (!providers[provider]) throw new Error(`Unknown provider: ${provider}`);
  if (!apiKey || !model) throw new Error(`Set the ${provider.toUpperCase()} API key and model name in the environment.`);
  return providers[provider]();
}
