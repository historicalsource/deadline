import { mkdir, writeFile } from "node:fs/promises";
import { join } from "node:path";
import { fileURLToPath } from "node:url";
import { DeadlineGame } from "../src/engine.js";
import { chooseBaselineAction } from "./baseline.js";
import { chooseModelAction } from "./model-player.js";

const arg = (name, fallback) => {
  const i = process.argv.indexOf(name);
  return i >= 0 ? process.argv[i + 1] : fallback;
};
const provider = arg("--provider", "baseline").toLowerCase();
const seed = Number(arg("--seed", "1"));
const maxCalls = Number(process.env.MAX_MODEL_CALLS || 60);
const timeoutMs = Number(process.env.MODEL_TIMEOUT_MS || 60_000);
const maxActions = 50;
const game = new DeadlineGame({ maxActions, maxCalls });
game.reset(seed);
const trace = { seed, provider, model: provider === "baseline" ? "fixed-evidence-policy" : process.env[`${provider.toUpperCase()}_MODEL`] || null, maxActions, maxCalls, timeoutMs, calls: [], startedAt: new Date().toISOString() };
let modelCalls = 0;
let lastFeedback = null;

while (game.outcome().status === "ongoing" || game.outcome().status === "choice") {
  const observation = game.observe("detective");
  let selected;
  if (provider === "baseline") {
    selected = { action: chooseBaselineAction(observation), latencyMs: 0, source: "baseline" };
  } else {
    if (modelCalls >= maxCalls) { game.end_episode("model_call_limit", "The configured model-call limit was reached."); break; }
    modelCalls += 1;
    try {
      selected = await chooseModelAction({
        provider, model: process.env[`${provider.toUpperCase()}_MODEL`],
        apiKey: process.env[`${provider.toUpperCase()}_API_KEY`], observation, lastFeedback,
        timeoutMs, baseUrl: process.env[`${provider.toUpperCase()}_BASE_URL`],
      });
      selected.source = "model";
    } catch (error) {
      const reason = error.code === "timeout_limit" ? "timeout_limit" : "model_error";
      game.end_episode(reason, error.message);
      trace.calls.push({ observation, previousActionFeedback: lastFeedback, source: "model", error: error.message, latencyMs: null });
      trace.error = error.message;
      break;
    }
  }
  const result = game.step("detective", selected.action);
  trace.calls.push({ observation, previousActionFeedback: lastFeedback, action: selected.action, rawOutput: selected.raw || null, source: selected.source, valid: result.valid, message: result.message, latencyMs: selected.latencyMs, usage: selected.usage || null, outcome: result.outcome });
  lastFeedback = { action: selected.action, valid: result.valid, message: result.message };
  if (provider === "baseline" && !result.valid) {
    game.end_episode("baseline_error", `Baseline submitted an illegal action: ${selected.action}`);
    break;
  }
}

trace.outcome = game.outcome();
trace.modelCalls = modelCalls;
trace.finishedAt = new Date().toISOString();
const projectDir = fileURLToPath(new URL("../", import.meta.url));
const traceDir = join(projectDir, "traces");
await mkdir(traceDir, { recursive: true });
const tracePath = join(traceDir, `${provider}-seed-${seed}-${Date.now()}.json`);
await writeFile(tracePath, JSON.stringify(trace, null, 2));
console.log(JSON.stringify({ outcome: trace.outcome, modelCalls, trace: tracePath }, null, 2));
