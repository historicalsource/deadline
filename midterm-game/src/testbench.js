import { DeadlineGame } from "./engine.js";
import { chooseBaselineAction } from "../players/baseline.js";
import "./testbench.css";

const app = document.querySelector("#app");
const POISON_PATH = [
  "interview privately Dunbar", "search Dunbar", "return Dunbar",
  "go to garden", "search holes", "clean fragment", "analyze fragment", "compare new chemical with LoBlo",
];
const STAGES = [
  { id: "start", title: "Fresh start", note: "Initial player state.", actions: [] },
  { id: "library", title: "Library scene", note: "First entry to the crime scene.", actions: ["go to library"] },
  { id: "ebullion", title: "Ebullion / coroner", note: "Read the label and the case-file blood findings.", actions: ["go to library", "inspect Ebullion"] },
  { id: "letter", title: "Letter delivered", note: "Return to the Living Room and read the new letter.", actions: ["go to library", "go to living room", "read letter"] },
  { id: "china", title: "Tea service count", note: "Inspect and count the Kitchen china.", actions: ["go to kitchen", "inspect china", "count china"] },
  { id: "fragment", title: "Garden fragment analyzed", note: "Recover, clean, and submit the shard to the lab.", actions: ["go to garden", "inspect holes", "search holes", "clean fragment", "analyze fragment"] },
  { id: "loblo", title: "LoBlo recovered", note: "Search Dunbar during a private interview.", actions: ["interview privately Dunbar", "search Dunbar"] },
  { id: "poison", title: "Poison confirmed", note: "Run the evidence chain through the lab comparison.", actions: POISON_PATH },
  { id: "choice", title: "Post-accusation choice", note: "Any accusation opens the close-or-continue decision.", actions: [...POISON_PATH, "accuse Dunbar"] },
  { id: "weak", title: "Weak joint accusation", note: "Test the terminal outcome with key evidence groups missing.", actions: [...POISON_PATH, "accuse Baxter and Dunbar"] },
  { id: "complete", title: "Complete solution", note: "Let the baseline play from observation/action until it reaches an outcome.", baseline: true },
  { id: "limit", title: "Action limit", note: "A two-action test episode ends at its configured limit.", actions: ["go to library", "inspect body"], maxActions: 2 },
];

let game;
let stage = STAGES[0];
let presetError = "";
let lastResult = null;

const escapeHtml = (value) => String(value).replace(/[&<>"']/g, (char) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" })[char]);
const json = (value) => escapeHtml(JSON.stringify(value, null, 2));
const titleCase = (value) => value.replace(/\b\w/g, (letter) => letter.toUpperCase());

function loadStage(selected) {
  stage = selected;
  presetError = "";
  lastResult = null;
  game = new DeadlineGame({ maxActions: stage.maxActions ?? 30, maxCalls: 60 });
  game.reset(42);
  for (const action of stage.actions ?? []) {
    const result = game.step("detective", action);
    if (!result.valid) {
      presetError = `Fixture stopped at “${action}”: ${result.message}`;
      break;
    }
    lastResult = { ...result, action };
  }
  if (stage.baseline && !presetError) {
    let turns = 0;
    while (["ongoing", "choice"].includes(game.outcome().status) && turns < 45) {
      const action = chooseBaselineAction(game.observe("detective"));
      const result = game.step("detective", action);
      lastResult = { ...result, action };
      turns += 1;
      if (!result.valid) {
        presetError = `Baseline submitted “${action}”: ${result.message}`;
        break;
      }
    }
    if (!presetError && ["ongoing", "choice"].includes(game.outcome().status)) presetError = "The baseline did not reach a terminal outcome within 45 actions.";
  }
  render();
}

function submit(action) {
  lastResult = { ...game.step("detective", action), action };
  render();
}

function render() {
  const observation = game.observe("detective");
  const outcome = game.outcome();
  const legal = game.legal_actions("detective");
  app.innerHTML = `
    <main class="testbench-shell">
      <header class="tb-header"><div><h1>Engine Inspector</h1><p>Local development tool · full state and exact legal actions are visible on this page.</p></div><a href="/">Return to the game</a></header>
      <section class="tb-layout">
        <aside class="tb-control-panel">
          <h2>Jump to a stage</h2>
          <p>Each preset resets the engine and replays a fixed, valid sequence.</p>
          <div class="tb-stage-list">${STAGES.map((item) => `<button class="tb-stage ${item.id === stage.id ? "selected" : ""}" data-stage="${item.id}"><strong>${escapeHtml(item.title)}</strong><span>${escapeHtml(item.note)}</span></button>`).join("")}</div>
          <button class="tb-reset" id="tb-reset">Reset this stage</button>
          ${presetError ? `<p class="tb-error" role="alert">${escapeHtml(presetError)}</p>` : ""}
          <form class="tb-submit" id="tb-form"><label for="tb-action">Try any command</label><input id="tb-action" autocomplete="off" placeholder="e.g. inspect Ebullion" required><button type="submit">Submit to engine</button></form>
          <p class="tb-hint">Use this field to test both valid commands and rejected guesses. A rejected command does not consume an in-story action.</p>
        </aside>
        <section class="tb-center-panel">
          <div class="tb-current-stage"><div><span>STAGE</span><h2>${escapeHtml(stage.title)}</h2></div><span>${observation.successfulActions} / ${observation.actionLimit} actions</span></div>
          ${lastResult ? `<article class="tb-result ${lastResult.valid ? "" : "invalid"}"><div><b>${lastResult.valid ? "Accepted" : "Rejected"}</b><code>${escapeHtml(lastResult.action)}</code></div><p>${escapeHtml(lastResult.message)}</p></article>` : ""}
          <section class="tb-outcome"><h3>Current outcome</h3><pre>${json(outcome)}</pre></section>
          <section class="tb-legal"><h3>Legal actions right now (${legal.length})</h3>${legal.length ? `<div class="tb-action-list">${legal.map((action) => `<button data-command="${escapeHtml(action)}">${escapeHtml(action)}</button>`).join("")}</div>` : `<p>No commands are currently legal.</p>`}</section>
          <section class="tb-history"><h3>Action history (${observation.history.length})</h3>${observation.history.length ? `<ol>${observation.history.map((entry) => `<li><b>${escapeHtml(entry.room)}</b><code>${escapeHtml(entry.action)}</code><span>${escapeHtml(entry.message)}</span></li>`).join("")}</ol>` : `<p>No actions submitted in this stage.</p>`}</section>
        </section>
        <aside class="tb-inspector-panel">
          <section><h2>Player observation</h2><p>What a game player is allowed to receive.</p><pre>${json(observation)}</pre></section>
          <section><h2>Engine state</h2><p>Current full internal state, including clue flags and call counters.</p><pre>${json({ seed: game.seed, limits: game.limits, state: game.state })}</pre></section>
          <details><summary>All action heads in the design</summary><pre>${json(["go to", "inspect", "search", "read", "ask", "interview", "return", "shade", "open", "analyze", "clean", "count", "compare", "show", "accuse", "close", "continue"])}</pre></details>
        </aside>
      </section>
      <footer class="tb-footer">Presets cover key checkpoints and terminal outcomes; the full set of every combinatorial state is not enumerated. Load any checkpoint, inspect its complete current state, then submit additional commands.</footer>
    </main>`;

  app.querySelectorAll("[data-stage]").forEach((button) => button.addEventListener("click", () => loadStage(STAGES.find((item) => item.id === button.dataset.stage))));
  app.querySelector("#tb-reset").addEventListener("click", () => loadStage(stage));
  app.querySelector("#tb-form").addEventListener("submit", (event) => {
    event.preventDefault();
    submit(app.querySelector("#tb-action").value.trim());
  });
  app.querySelectorAll("[data-command]").forEach((button) => button.addEventListener("click", () => submit(button.dataset.command)));
}

loadStage(STAGES[0]);
