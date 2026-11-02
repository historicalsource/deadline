import test from "node:test";
import assert from "node:assert/strict";
import { DeadlineGame } from "../src/engine.js";
import { chooseBaselineAction } from "../players/baseline.js";
import { chooseModelAction } from "../players/model-player.js";

test("reset, observations, and legal actions preserve role boundaries", () => {
  const game = new DeadlineGame();
  const observation = game.reset(123);
  assert.equal(observation.room, "living room");
  assert.equal(observation.successfulActions, 0);
  assert.deepEqual(observation.evidence, []);
  assert.equal("culprit" in observation, false);
  assert.equal("state" in observation, false);
  const legal = game.legal_actions("detective");
  assert.ok(legal.includes("go to library"));
  assert.ok(legal.includes("ask Baxter about alibi"));
  assert.equal(legal.some((action) => action.startsWith("accuse ")), false);
  assert.throws(() => game.observe("evaluator"), /Unknown player role/);
});

test("legal action changes scene and an illegal action changes no game facts", () => {
  const game = new DeadlineGame();
  assert.equal(game.legal_actions("detective").includes("go to library"), true);
  assert.equal(game.step("detective", "go to library").valid, true);
  const before = game.observe("detective");
  const invalid = game.step("detective", "read letter");
  const after = game.observe("detective");
  assert.equal(invalid.valid, false);
  assert.equal(after.room, before.room);
  assert.deepEqual(after.evidence, before.evidence);
  assert.equal(after.successfulActions, before.successfulActions);
  assert.equal(game.outcome().status, "ongoing");
});

test("the letter is readable only after the second Living Room entry", () => {
  const game = new DeadlineGame();
  assert.equal(game.legal_actions("detective").includes("read letter"), false);
  game.step("detective", "go to library");
  game.step("detective", "go to living room");
  assert.equal(game.legal_actions("detective").includes("read letter"), true);
  assert.match(game.step("detective", "read letter").message, /relationship with Steven/);
});

test("observed regression: public suspect search must refuse without revealing inventory", () => {
  const game = new DeadlineGame();
  const result = game.step("detective", "search Dunbar");
  assert.equal(result.valid, true);
  assert.match(result.message, /refuses|no search occurs/i);
  assert.deepEqual(result.observation.evidence, []);
  assert.equal(result.observation.successfulActions, 1);
});

test("baseline completes the required evidence chain through legal actions", () => {
  const game = new DeadlineGame();
  game.reset(7);
  while (game.outcome().status === "ongoing" || game.outcome().status === "choice") {
    const observation = game.observe("detective");
    const actions = game.legal_actions("detective");
    const action = chooseBaselineAction(observation, actions);
    assert.ok(actions.includes(action), `baseline proposed illegal action ${action}`);
    const result = game.step("detective", action);
    assert.equal(result.valid, true);
  }
  assert.equal(game.outcome().reason, "complete_solution");
  assert.equal(game.outcome().score, 1);
  assert.ok(game.outcome().successfulActions < 30);
});

test("joint accusation without every clue group produces a weak terminal outcome", () => {
  const game = new DeadlineGame();
  game.reset(2);
  for (const action of ["go to garden", "search holes", "clean fragment", "analyze fragment", "go to living room"]) {
    assert.equal(game.step("detective", action).valid, true, action);
  }
  assert.equal(game.step("detective", "interview Dunbar privately").valid, true);
  assert.equal(game.step("detective", "search Dunbar").valid, true);
  assert.equal(game.step("detective", "return Dunbar to living room").valid, true);
  assert.equal(game.step("detective", "go to garden").valid, true);
  assert.equal(game.step("detective", "compare fragment with LoBlo").valid, true);
  assert.equal(game.step("detective", "accuse Baxter and Dunbar").valid, true);
  assert.equal(game.outcome().reason, "weak_case");
});

test("Dunbar closure has exactly its two choices and reaches its epilogue", () => {
  const game = new DeadlineGame();
  game.reset(3);
  for (const action of ["interview Dunbar privately", "search Dunbar", "return Dunbar to living room", "go to garden", "search holes", "clean fragment", "analyze fragment"]) {
    assert.equal(game.step("detective", action).valid, true, action);
  }
  assert.equal(game.step("detective", "go to living room").valid, true);
  assert.equal(game.step("detective", "accuse Dunbar").valid, false);
  assert.equal(game.step("detective", "go to garden").valid, true);
  assert.equal(game.step("detective", "compare fragment with LoBlo").valid, true);
  assert.equal(game.step("detective", "go to living room").valid, true);
  assert.equal(game.step("detective", "accuse Dunbar").valid, true);
  assert.deepEqual(game.legal_actions("detective"), ["close the case", "continue investigating"]);
  assert.equal(game.step("detective", "close the case").valid, true);
  assert.equal(game.outcome().reason, "incomplete_dunbar_case");
  assert.match(game.outcome().message, /Baxter killed her/);
});

test("successful-action and submitted-call episode limits end explicitly", () => {
  const steps = new DeadlineGame({ maxActions: 2, maxCalls: 10 });
  steps.step("detective", "go to library");
  steps.step("detective", "inspect body");
  assert.equal(steps.outcome().reason, "episode_limit");
  assert.equal(steps.outcome().successfulActions, 2);

  const calls = new DeadlineGame({ maxActions: 30, maxCalls: 2 });
  calls.step("detective", "not an action");
  calls.step("detective", "still not an action");
  assert.equal(calls.outcome().reason, "model_call_limit");
  assert.equal(calls.outcome().successfulActions, 0);
});

test("provider adapters receive only the visible observation and legal actions", async () => {
  const originalFetch = globalThis.fetch;
  const cases = [
    ["openai", (text) => ({ output: [{ content: [{ type: "output_text", text }] }] })],
    ["anthropic", (text) => ({ content: [{ type: "text", text }] })],
    ["gemini", (text) => ({ steps: [{ type: "model_output", content: [{ type: "text", text }] }] })],
  ];
  try {
    for (const [provider, response] of cases) {
      let requestBody;
      globalThis.fetch = async (_url, options) => {
        requestBody = JSON.parse(options.body);
        return { ok: true, json: async () => response('{"action":"go to library"}') };
      };
      const result = await chooseModelAction({
        provider, model: "example-model", apiKey: "test-key", timeoutMs: 100,
        observation: { room: "living room", evidence: [] }, legalActions: ["go to library"],
      });
      assert.equal(result.action, "go to library");
      assert.equal(JSON.stringify(requestBody).includes("answer_key"), false);
      assert.equal(JSON.stringify(requestBody).includes("hidden_state"), false);
      assert.equal("tools" in requestBody, false);
      const submittedData = JSON.stringify(requestBody);
      assert.match(submittedData, /living room/);
      assert.match(submittedData, /go to library/);
    }
  } finally { globalThis.fetch = originalFetch; }
});
