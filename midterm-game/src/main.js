import { DeadlineGame } from "./engine.js";
import "./style.css";

const game = new DeadlineGame();
const app = document.querySelector("#app");

function section(title, actions) {
  if (!actions.length) return "";
  return `<section class="action-group"><h3>${title}</h3><div class="actions">${actions.map((action) => `<button class="action" data-action="${escapeHtml(action)}">${escapeHtml(action)}</button>`).join("")}</div></section>`;
}

function escapeHtml(value) {
  return String(value).replace(/[&<>"']/g, (char) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" })[char]);
}

function render(lastMessage = "") {
  const obs = game.observe("detective");
  const legal = game.legal_actions("detective");
  const groups = [
    ["Move between rooms", legal.filter((a) => a.startsWith("go to "))],
    ["Conclude", legal.filter((a) => a.startsWith("accuse ") || ["close the case", "continue investigating"].includes(a))],
    ["Interview and ask", legal.filter((a) => a.startsWith("interview ") || a.startsWith("ask ") || a.startsWith("show ") || a.startsWith("return "))],
    ["Investigate", legal.filter((a) => !a.startsWith("go to ") && !a.startsWith("accuse ") && !["close the case", "continue investigating"].includes(a) && !a.startsWith("interview ") && !a.startsWith("ask ") && !a.startsWith("show ") && !a.startsWith("return "))],
  ];
  const outcome = game.outcome();
  app.innerHTML = `
    <header class="topbar"><div class="brand"><span class="brand-mark">R</span><span>CASE FILE <b>01</b></span></div><button id="reset" class="quiet-button">New investigation</button></header>
    <main>
      <section class="intro"><p class="eyebrow">A bounded detective game inspired by Deadline</p><h1>The Robner Case</h1><p class="subtitle">A quiet house. A cup out of place. Four people with reasons to lie.</p></section>
      <div class="layout">
        <div class="main-column">
          <section class="scene card"><div class="card-head"><div><p class="eyebrow">CURRENT SCENE</p><h2>${titleCase(obs.room)}</h2></div><span class="scene-stamp">${obs.interviewee ? "PRIVATE INTERVIEW" : "CASE OPEN"}</span></div><p class="scene-copy">${escapeHtml(obs.roomText)}</p>${obs.interviewee ? `<p class="escort-note">${escapeHtml(obs.interviewee)} is speaking with you privately. The officer remains with the other three in the Living Room.</p>` : ""}</section>
          <section class="feedback card" aria-live="polite"><p class="eyebrow">LATEST DEVELOPMENT</p><p>${escapeHtml(lastMessage || "Choose an action to continue the investigation.")}</p>${outcome.status === "terminal" ? `<div class="ending"><strong>${escapeHtml(outcome.reason.replaceAll("_", " "))}</strong><p>${escapeHtml(outcome.message)}</p></div>` : ""}${outcome.status === "choice" ? `<p class="choice-note">The case is paused at a decision. Choose one of the two available actions.</p>` : ""}</section>
          <section class="choices card"><div class="card-head"><div><p class="eyebrow">AVAILABLE ACTIONS</p><h2>Your next move</h2></div><span class="step-count">${obs.successfulActions} / ${obs.actionLimit} actions</span></div>${groups.map(([title, actions]) => section(title, actions)).join("") || `<p class="muted">No actions are available.</p>`}</section>
          <section class="history card"><p class="eyebrow">CASE NOTES</p><div class="history-list">${obs.history.slice(-8).reverse().map((entry) => `<article><span>${escapeHtml(entry.room)}</span><p><b>${escapeHtml(entry.action)}</b><br>${escapeHtml(entry.message)}</p></article>`).join("") || `<p class="muted">Your notes will appear here as you investigate.</p>`}</div></section>
        </div>
        <aside class="side-column"><section class="card evidence"><div class="card-head"><div><p class="eyebrow">WHAT YOU HAVE</p><h2>Evidence & leads</h2></div><span class="evidence-count">${obs.evidence.length}</span></div>${obs.evidence.length ? `<ul>${obs.evidence.map((item) => `<li>${escapeHtml(item)}</li>`).join("")}</ul>` : `<p class="muted">No physical evidence logged yet.</p>`}<hr><p class="eyebrow">ESTABLISHED LEADS</p>${obs.clues.length ? `<ul class="leads">${obs.clues.map((item) => `<li>${escapeHtml(item.replaceAll("_", " "))}</li>`).join("")}</ul>` : `<p class="muted">Follow the visible clues from room to room.</p>`}</section><section class="card cast"><p class="eyebrow">PEOPLE OF INTEREST</p><ul>${["Baxter", "Dunbar", "George", "Mrs. Robner"].map((name) => `<li><span>${name}</span><small>${name === "Mrs. Robner" ? "Robner family" : "Resident"}</small></li>`).join("")}</ul><p class="muted small">The uniformed patrol officer stays with the group. They are not a suspect or a source of clues.</p></section><footer>Rules are enforced by the game engine. Choices shown here come from its legal-action interface.</footer></aside>
      </div>
    </main>`;
  app.querySelectorAll("[data-action]").forEach((button) => button.addEventListener("click", () => {
    const result = game.step("detective", button.dataset.action);
    render(result.message);
    window.scrollTo({ top: 0, behavior: "smooth" });
  }));
  app.querySelector("#reset").addEventListener("click", () => { game.reset(Date.now()); render(); });
}

function titleCase(text) { return text.replace(/\b\w/g, (letter) => letter.toUpperCase()); }

render();
