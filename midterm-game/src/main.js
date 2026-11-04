import { DeadlineGame, ROOMS } from "./engine.js";
import "./style.css";

const game = new DeadlineGame();
const app = document.querySelector("#app");
const ui = { screen: "briefing", feedback: "", valid: null, command: "", actionWord: "go to", remainder: "", askPerson: "", askTopic: "", personTarget: "", showPerson: "", showEvidence: "", compareA: "", compareB: "", dictionaryOpen: true };

const suspects = [
  { name: "Mr. Baxter", role: "Business partner", detail: "Robner's longtime business partner." },
  { name: "Ms. S. Dunbar", role: "Secretary", detail: "Robner's secretary; she has worked for him for about ten years." },
  { name: "George Robner", role: "Son", detail: "Robner's son." },
  { name: "Mrs. Leslie Phillips Robner", role: "Wife", detail: "Robner's wife." },
];

const trueStory = [
  ["Why Baxter acted", "Marshall Robner had built his life around Robner Corp. Baxter had diverted money from Focus Corporation, a Robner Corp. subsidiary, and feared that Robner would expose the scandal. Robner's notepad carried a warning about Baxter and the company. Baxter also wanted to advance his position through a proposed sale of the company, while concealing the extent of his wrongdoing."],
  ["The concert night", "Baxter and Dunbar attended a concert in Hartford together. They returned to the Robner estate afterward. Their accounts differed: Baxter said Dunbar became ill and left early, while Dunbar said Baxter took her home. They had kept their romantic relationship private."],
  ["Dunbar's part", "Dunbar had LoBlo, a medicine she used for high blood pressure. After returning to the estate, she put LoBlo into Robner's tea. Robner had taken Ebullion. Methsparin, the drug sold as LoBlo, interferes with Ebullion's protein binding; the resulting high level of free Ebullion caused fatal toxicity. Dunbar helped Baxter carry out the murder."],
  ["Baxter's part", "Baxter planned the murder and used Robner's known depression and use of Ebullion to make the death appear self-inflicted. After Robner died, Baxter used a ladder to reach the Library, exchanged the contaminated cup for a clean one, and descended toward the garden. A piece of the cup broke off and was left near the ladder holes. The ladder, holes, china count, and fragment preserve parts of that route."],
  ["Afterward", "When Dunbar risked revealing their part in the crime, Baxter killed her too. He entered through the bedroom balcony, shot her, left a forged suicide note and pistol, then returned to appear to have just heard the shot. The Dunbar-only case ending reports this later crime; the full account above explains the hidden story behind both deaths."],
];

const escapeHtml = (value) => String(value).replace(/[&<>"']/g, (char) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" })[char]);
const titleCase = (value) => value.replace(/\b\w/g, (letter) => letter.toUpperCase());

function renderBriefing() {
  app.innerHTML = `
    <main class="desktop-shell">
      <section class="briefing window-intro" aria-labelledby="window-title">
        <div class="briefing-content">
          <h1 id="window-title">The Robner Case</h1>
          <p class="opening-copy">Marshall Robner was found dead in the Library. His death appears to be suicide, but you, the investigating inspector, are not convinced. You will examine the scene and question the household. Robner had been taking a medicine called Ebullion.</p>
          <button class="primary-button" data-next="suspects">Meet the suspects <span aria-hidden="true">→</span></button>
        </div>
      </section>
    </main>`;
  app.querySelector("[data-next]").addEventListener("click", () => { ui.screen = "suspects"; render(); });
}

function renderSuspects() {
  app.innerHTML = `
    <main class="desktop-shell">
      <section class="briefing window-intro" aria-labelledby="window-title">
        <div class="briefing-content suspect-briefing">
          <h1 id="window-title">The suspects</h1>
          <p class="intro-copy">The residents have been asked to remain together while you check the circumstances of Robner's death. A uniformed patrol officer is supervising the group.</p>
          <div class="suspect-grid">${suspects.map((suspect) => `<article class="suspect-card"><h2>${escapeHtml(suspect.name)}</h2><p class="suspect-role">${escapeHtml(suspect.role)}</p><p>${escapeHtml(suspect.detail)}</p></article>`).join("")}</div>
          <button class="primary-button" data-next="game">Begin the investigation <span aria-hidden="true">→</span></button>
        </div>
      </section>
    </main>`;
  app.querySelector("[data-next]").addEventListener("click", () => { ui.screen = "game"; render(); });
}

function renderGame() {
  const obs = game.observe("detective");
  const outcome = game.outcome();
  if (!obs.actionWords.includes(ui.actionWord)) ui.actionWord = obs.actionWords[0] || "";
  const preview = ui.actionWord === "ask"
    ? `ask ${ui.askPerson.trim() || "[person]"} about ${ui.askTopic.trim() || "[topic]"}`
    : ui.actionWord === "interview privately"
      ? `interview privately ${ui.personTarget.trim() || "[person]"}`
      : ui.actionWord === "return"
        ? `return ${ui.personTarget.trim() || "[person]"}`
        : ui.actionWord === "show"
          ? `show ${ui.showPerson.trim() || "[person]"} ${ui.showEvidence.trim() || "[evidence]"}`
          : ui.actionWord === "compare"
            ? `compare ${ui.compareA.trim() || "[A]"} with ${ui.compareB.trim() || "[B]"}`
        : [ui.actionWord, ui.remainder.trim()].filter(Boolean).join(" ");
  app.innerHTML = `
    <main class="desktop-shell play-shell">
      <section class="game-window" aria-label="The Robner Case">
        <div class="game-toolbar"><div class="toolbar-start"><button class="dictionary-toggle" id="toggle-dictionary" type="button" aria-expanded="${ui.dictionaryOpen}">Dictionary</button><h1>The Robner Case</h1></div><div class="toolbar-end"><button class="truth-button" id="show-truth" type="button">TRUTH</button><button class="restart-button" id="reset">Restart</button></div></div>
        <div class="game-layout ${ui.dictionaryOpen ? "" : "dictionary-hidden"}">
          ${ui.dictionaryOpen ? `<aside class="action-reference" aria-label="Action descriptions">
            <h2>Action reference</h2>
            <dl>${obs.actionGuide.map((item) => `<div><dt>${escapeHtml(item.template || item.action)}</dt><dd>${escapeHtml(item.description)}</dd></div>`).join("")}</dl>
          </aside>` : ""}
          <section class="play-column">
            <div class="case-strip"><span>${escapeHtml(obs.room === "private interview" ? "Private interview" : titleCase(obs.room))}</span><span>${obs.successfulActions} / ${obs.actionLimit} actions</span></div>
            <section class="scene-panel">
              ${obs.interviewee ? `<p class="interview-state">Private interview: ${escapeHtml(obs.interviewee)}</p>` : ""}
              <p class="scene-copy">${escapeHtml(obs.roomText)}</p>
            </section>
            ${outcome.status === "ongoing" ? `<section class="development-panel" aria-live="polite"><h2>Response</h2>
              <p class="feedback-message ${ui.valid === false ? "invalid-feedback" : ""}">${escapeHtml(ui.feedback || "The case is open. Choose an action word, then complete it based on what you observe.")}</p>
              ${obs.pendingMessages?.length ? `<div class="pending-responses" aria-label="Messages to check"><h3>Still to check</h3>${obs.pendingMessages.map(({ message }) => `<p>${escapeHtml(message)}</p>`).join("")}</div>` : ""}
            </section>` : ""}
            ${outcome.status === "choice" ? `<section class="decision-panel"><h2>${escapeHtml(outcome.title)}</h2><p>${escapeHtml(outcome.message)}</p><div class="decision-buttons">${obs.choices.map((choice) => `<button class="decision-button" type="button" data-choice="${escapeHtml(choice.action)}">${escapeHtml(choice.label)}</button>`).join("")}</div></section>` : outcome.status === "terminal" ? `<section class="ending-panel ${outcome.reason === "complete_solution" ? "ending-solved" : ""}" aria-live="polite"><p class="ending-kicker">Case record</p><h2>${escapeHtml(outcome.title)}</h2><p class="ending-copy">${escapeHtml(outcome.message)}</p></section>` : `<section class="command-panel"><div class="panel-heading"><h2>What do you try?</h2></div>
              <form id="command-form"><div class="free-command"><label><span>Choose an action word</span><select name="actionWord">${obs.actionWords.map((word) => `<option value="${escapeHtml(word)}" ${ui.actionWord === word ? "selected" : ""}>${escapeHtml(word)}</option>`).join("")}</select></label>
                ${ui.actionWord === "ask" ? `<div class="ask-command"><label><span>Ask</span><input name="askPerson" value="${escapeHtml(ui.askPerson)}" placeholder="Person" autocomplete="off" autofocus required></label><span class="about-divider">about</span><label><span>About</span><input name="askTopic" value="${escapeHtml(ui.askTopic)}" placeholder="Subject" autocomplete="off" required></label></div>` : ui.actionWord === "interview privately" ? `<label><span>Interview privately</span><input name="personTarget" value="${escapeHtml(ui.personTarget)}" placeholder="Person" autocomplete="off" autofocus required></label>` : ui.actionWord === "return" ? `<label><span>Return</span><input name="personTarget" value="${escapeHtml(ui.personTarget)}" placeholder="Person" autocomplete="off" autofocus required></label>` : ui.actionWord === "show" ? `<div class="ask-command"><label><span>Show to</span><input name="showPerson" value="${escapeHtml(ui.showPerson)}" placeholder="Person" autocomplete="off" autofocus required></label><label><span>Evidence</span><input name="showEvidence" value="${escapeHtml(ui.showEvidence)}" placeholder="Evidence name" autocomplete="off" required></label></div>` : ui.actionWord === "compare" ? `<div class="compare-command"><span>compare</span><input name="compareA" aria-label="Evidence item A" value="${escapeHtml(ui.compareA)}" placeholder="Evidence item A" autocomplete="off" autofocus required><span>with</span><input name="compareB" aria-label="Evidence item B" value="${escapeHtml(ui.compareB)}" placeholder="Evidence item B" autocomplete="off" required></div>` : `<label><span>Complete the phrase</span><input name="remainder" value="${escapeHtml(ui.remainder)}" placeholder="Type the rest of the action…" autocomplete="off" autofocus required></label>`}</div>
                <div class="command-preview"><span>COMMAND PREVIEW</span><output id="command-preview">${escapeHtml(preview || "Choose an action word and finish the phrase.")}</output></div>
                <button class="submit-button" type="submit">Try this action <span aria-hidden="true">↗</span></button>
              </form><p class="dictionary-note">Only action words are provided. Infer the target and the rest of the phrasing from the scene, prior findings, and responses. The case engine checks the completed action.</p>
            </section>`}
            <section class="history-panel"><div class="panel-heading"><h2>Recent actions</h2></div>
              <div class="history-list">${obs.history.slice(-7).reverse().map((entry) => `<article><span>${escapeHtml(titleCase(entry.room))}</span><div><b>${escapeHtml(entry.action)}</b><p>${escapeHtml(entry.message)}</p></div></article>`).join("") || `<p class="muted">Your actions and their results will be recorded here.</p>`}</div>
            </section>
          </section>
          <aside class="case-notes">
            <section class="notes-section accusation-section"><h2>Accusations</h2>
              ${obs.accusations.length ? `<ul>${obs.accusations.map((person) => `<li>${escapeHtml(person)}</li>`).join("")}</ul>` : `<p class="muted">No one named yet.</p>`}
            </section>
            <section class="notes-section room-section"><h2>Rooms</h2>
              <ul class="room-list">${ROOMS.map((room) => `<li class="${room === obs.room ? "current-room" : ""}" ${room === obs.room ? 'aria-current="location"' : ""}><span>${escapeHtml(titleCase(room))}</span>${room === obs.room ? `<span class="room-here">YOU ARE HERE</span>` : ""}</li>`).join("")}</ul>
            </section>
            <section class="notes-section"><h2>Suspects</h2>
              <div class="roster-list">${suspects.map((suspect) => `<article><div><h3>${escapeHtml(suspect.name)}</h3><span>${escapeHtml(suspect.role)}</span></div><p>${escapeHtml(suspect.detail)}</p></article>`).join("")}</div>
            </section>
            <section class="notes-section evidence-section"><div class="notes-title"><h2>Evidence</h2></div>
              ${obs.evidence.length ? `<ul>${obs.evidence.map((item) => `<li>${escapeHtml(item)}</li>`).join("")}</ul>` : `<p class="muted">Nothing has been logged yet.</p>`}
            </section>
          </aside>
        </div>
      </section>
      <dialog class="truth-dialog" id="truth-dialog" aria-labelledby="truth-title">
        <div class="truth-heading"><div><p class="ending-kicker">Full case account</p><h2 id="truth-title">What happened to Marshall Robner</h2></div><button class="truth-close" id="close-truth" type="button" aria-label="Close truth window">×</button></div>
        <div class="truth-copy">${trueStory.filter(([heading]) => heading !== "Afterward" || (obs.accusations.length === 1 && obs.accusations[0] === "Dunbar")).map(([heading, text]) => `<section><h3>${escapeHtml(heading)}</h3><p>${escapeHtml(text)}</p></section>`).join("")}</div>
      </dialog>
    </main>`;

  const form = app.querySelector("#command-form");
  form?.elements.actionWord.addEventListener("change", () => {
    ui.actionWord = form.elements.actionWord.value;
    if (form.elements.remainder) ui.remainder = form.elements.remainder.value;
    if (form.elements.askPerson) ui.askPerson = form.elements.askPerson.value;
    if (form.elements.askTopic) ui.askTopic = form.elements.askTopic.value;
    if (form.elements.personTarget) ui.personTarget = form.elements.personTarget.value;
    if (form.elements.showPerson) ui.showPerson = form.elements.showPerson.value;
    if (form.elements.showEvidence) ui.showEvidence = form.elements.showEvidence.value;
    if (form.elements.compareA) ui.compareA = form.elements.compareA.value;
    if (form.elements.compareB) ui.compareB = form.elements.compareB.value;
    render();
    app.querySelector(ui.actionWord === "ask" ? '[name="askPerson"]' : ["interview privately", "return"].includes(ui.actionWord) ? '[name="personTarget"]' : ui.actionWord === "show" ? '[name="showPerson"]' : ui.actionWord === "compare" ? '[name="compareA"]' : '[name="remainder"]')?.focus();
  });
  form?.addEventListener("input", () => {
    if (form.elements.remainder) ui.remainder = form.elements.remainder.value;
    if (form.elements.askPerson) ui.askPerson = form.elements.askPerson.value;
    if (form.elements.askTopic) ui.askTopic = form.elements.askTopic.value;
    if (form.elements.personTarget) ui.personTarget = form.elements.personTarget.value;
    if (form.elements.showPerson) ui.showPerson = form.elements.showPerson.value;
    if (form.elements.showEvidence) ui.showEvidence = form.elements.showEvidence.value;
    if (form.elements.compareA) ui.compareA = form.elements.compareA.value;
    if (form.elements.compareB) ui.compareB = form.elements.compareB.value;
    const output = app.querySelector("#command-preview");
    output.textContent = ui.actionWord === "ask"
      ? `ask ${ui.askPerson.trim() || "[person]"} about ${ui.askTopic.trim() || "[topic]"}`
      : ui.actionWord === "interview privately"
        ? `interview privately ${ui.personTarget.trim() || "[person]"}`
        : ui.actionWord === "return"
          ? `return ${ui.personTarget.trim() || "[person]"}`
        : ui.actionWord === "show"
          ? `show ${ui.showPerson.trim() || "[person]"} ${ui.showEvidence.trim() || "[evidence]"}`
          : ui.actionWord === "compare"
            ? `compare ${ui.compareA.trim() || "[A]"} with ${ui.compareB.trim() || "[B]"}`
          : [ui.actionWord, ui.remainder.trim()].filter(Boolean).join(" ") || "Choose an action word and finish the phrase.";
  });
  form?.addEventListener("submit", (event) => {
    event.preventDefault();
    ui.actionWord = form.elements.actionWord.value;
    let action;
    if (ui.actionWord === "ask") {
      ui.askPerson = form.elements.askPerson.value;
      ui.askTopic = form.elements.askTopic.value;
      action = `ask ${ui.askPerson.trim()} about ${ui.askTopic.trim()}`;
    } else if (["interview privately", "return"].includes(ui.actionWord)) {
      ui.personTarget = form.elements.personTarget.value;
      action = ui.actionWord === "interview privately"
        ? `interview privately ${ui.personTarget.trim()}`
        : `return ${ui.personTarget.trim()}`;
    } else if (ui.actionWord === "show") {
      ui.showPerson = form.elements.showPerson.value;
      ui.showEvidence = form.elements.showEvidence.value;
      action = `show ${ui.showPerson.trim()} ${ui.showEvidence.trim()}`;
    } else if (ui.actionWord === "compare") {
      ui.compareA = form.elements.compareA.value;
      ui.compareB = form.elements.compareB.value;
      action = `compare ${ui.compareA.trim()} with ${ui.compareB.trim()}`;
    } else {
      ui.remainder = form.elements.remainder.value;
      action = [ui.actionWord, ui.remainder.trim()].filter(Boolean).join(" ");
    }
    ui.command = action;
    const result = game.step("detective", action);
    ui.feedback = result.valid ? result.message : `Command rejected: ${result.message} The case has not moved on.`;
    ui.valid = result.valid;
    if (result.valid) { ui.remainder = ""; ui.askPerson = ""; ui.askTopic = ""; ui.personTarget = ""; ui.showPerson = ""; ui.showEvidence = ""; ui.compareA = ""; ui.compareB = ""; }
    render();
  });
  app.querySelectorAll("[data-choice]").forEach((button) => button.addEventListener("click", () => {
    const result = game.step("detective", button.dataset.choice);
    ui.feedback = result.message;
    ui.valid = result.valid;
    ui.remainder = "";
    render();
  }));
  app.querySelector("#toggle-dictionary").addEventListener("click", () => {
    ui.dictionaryOpen = !ui.dictionaryOpen;
    render();
  });
  const truthDialog = app.querySelector("#truth-dialog");
  app.querySelector("#show-truth").addEventListener("click", () => truthDialog.showModal());
  app.querySelector("#close-truth").addEventListener("click", () => truthDialog.close());
  app.querySelector("#reset").addEventListener("click", () => {
    game.reset(0);
    ui.screen = "briefing";
    ui.command = "";
    ui.actionWord = "go to";
    ui.remainder = "";
    ui.askPerson = "";
    ui.askTopic = "";
    ui.personTarget = "";
    ui.feedback = "";
    ui.valid = null;
    render();
  });
}

function render() {
  if (ui.screen === "briefing") return renderBriefing();
  if (ui.screen === "suspects") return renderSuspects();
  return renderGame();
}

render();
