export const ROOMS = ["living room", "library", "kitchen", "garden"];
export const SUSPECTS = ["Baxter", "Dunbar", "George", "Mrs. Robner"];
const TOPICS = {
  Baxter: ["alibi", "concert", "Focus", "ladder", "Dunbar", "George", "Mrs. Robner", "death"],
  Dunbar: ["alibi", "concert", "LoBlo", "Baxter", "George", "Mrs. Robner", "new will", "death"],
  George: ["alibi", "new will", "inheritance", "Focus", "Baxter", "Mrs. Robner", "death"],
  "Mrs. Robner": ["alibi", "letter", "Steven", "Baxter", "George", "Dunbar", "death"],
};
const EVIDENCE = ["teacup", "saucer", "sugar bowl", "fragment", "LoBlo", "Focus papers", "new will", "letter"];
const clone = (v) => structuredClone(v);

export class DeadlineGame {
  constructor({ maxActions = 30, maxCalls = 60 } = {}) {
    this.limits = { maxActions, maxCalls };
    this.reset(0);
  }

  reset(seed = 0) {
    this.seed = seed;
    this.state = {
      room: "living room", roomEntries: 1, interviewee: null,
      letterDelivered: false, safeFound: false, safeOpen: false,
      found: {}, clues: {}, asked: {}, shown: {}, terminal: null,
      successfulActions: 0, submittedCalls: 0, log: [],
    };
    return this.observe("detective");
  }

  observe(playerId) {
    if (playerId !== "detective") throw new Error("Unknown player role.");
    const s = this.state;
    const knownEvidence = Object.keys(s.found).filter((key) => s.found[key]);
    const roomText = {
      "living room": "Four residents wait under the watch of a uniformed patrol officer. Mrs. Robner looks tense. The officer remains with the group while you investigate.",
      library: "Marshall Robner lies beside a tea service. A bottle of Ebullion and a writing desk are nearby.",
      kitchen: "The tea service is stored here. One place in the set looks oddly empty.",
      garden: "The flower beds below the Library window have been disturbed.",
    }[s.room];
    return {
      player: playerId, room: s.room, roomText,
      interviewee: s.interviewee,
      letterDelivered: s.letterDelivered,
      evidence: knownEvidence,
      clues: Object.entries(s.clues).filter(([, value]) => value).map(([key]) => key),
      history: clone(s.log),
      successfulActions: s.successfulActions,
      actionLimit: this.limits.maxActions,
      terminal: clone(s.terminal),
    };
  }

  legal_actions(playerId) {
    if (playerId !== "detective") throw new Error("Unknown player role.");
    if (this.state.terminal && !this.state.terminal.choice) return [];
    return this._candidates().filter((action) => this._isLegal(action));
  }

  outcome() {
    return clone(this.state.terminal || {
      status: "ongoing", reason: "investigation_open", score: null,
      successfulActions: this.state.successfulActions,
      submittedCalls: this.state.submittedCalls,
    });
  }

  end_episode(reason, message) {
    if (!this.state.terminal) this._finish(reason, message, 0);
    return this.outcome();
  }

  step(playerId, action) {
    if (playerId !== "detective") throw new Error("Unknown player role.");
    if (this.state.terminal && !this.state.terminal.choice) return { valid: false, message: "The case is already closed.", observation: this.observe(playerId), outcome: this.outcome() };
    this.state.submittedCalls += 1;
    if (this.state.submittedCalls > this.limits.maxCalls) {
      this._finish("model_call_limit", "The call limit was reached before the case could be concluded.", 0);
      return { valid: false, message: "The submitted-call limit has been reached.", observation: this.observe(playerId), outcome: this.outcome() };
    }
    if (!this._isLegal(action)) {
      const message = this._invalidReason(action);
      if (this.state.submittedCalls >= this.limits.maxCalls) {
        this._finish("model_call_limit", "The submitted-call limit was reached before the case could be concluded.", 0);
      }
      return { valid: false, message, observation: this.observe(playerId), outcome: this.outcome() };
    }
    this.state.successfulActions += 1;
    const message = this._apply(action);
    this.state.log.push({ action, message, room: this.state.room });
    if ((!this.state.terminal || this.state.terminal.choice) && this.state.successfulActions >= this.limits.maxActions) {
      this._finish("episode_limit", "The investigation ended at its successful-action limit.", 0);
    } else if (!this.state.terminal && this.state.submittedCalls >= this.limits.maxCalls) {
      this._finish("model_call_limit", "The submitted-call limit was reached before the case could be concluded.", 0);
    }
    return { valid: true, message, observation: this.observe(playerId), outcome: this.outcome() };
  }

  _candidates() {
    const out = [];
    for (const room of ROOMS) if (room !== this.state.room) out.push(`go to ${room}`);
    const add = (...a) => out.push(...a);
    if (this.state.terminal?.choice) return ["close the case", "continue investigating"];
    if (this.state.interviewee) {
      const person = this.state.interviewee;
      add(`return ${person} to living room`, `search ${person}`);
      for (const topic of TOPICS[person]) add(`ask ${person} about ${topic}`);
      for (const [evidence, who] of this._showPairs()) if (who === person) add(`show ${evidence} to ${person}`);
    } else {
      if (this.state.room === "living room") {
        add("inspect letter", "read letter");
        for (const person of SUSPECTS) {
          add(`inspect ${person}`, `search ${person}`, `interview ${person} privately`);
          for (const topic of TOPICS[person]) add(`ask ${person} about ${topic}`);
          for (const [evidence, who] of this._showPairs()) if (who === person) add(`show ${evidence} to ${person}`);
        }
      }
      if (this.state.room === "library") add(
        "inspect body", "inspect teacup", "search body", "inspect saucer", "inspect Ebullion", "inspect desk",
        "inspect notepad", "search desk", "shade notepad with pencil", "inspect bookcase", "search bookcase", "open safe",
        "read Focus papers", "read new will", "analyze teacup", "analyze saucer",
      );
      if (this.state.room === "kitchen") add("inspect china", "search china", "count china", "inspect sugar bowl", "analyze sugar bowl");
      if (this.state.room === "garden") add("inspect holes", "search holes", "inspect fragment", "clean fragment", "analyze fragment", "compare fragment with LoBlo");
      for (const suspect of ["Baxter", "George", "Mrs. Robner"]) add(`accuse ${suspect}`);
      add("accuse Baxter and Dunbar", "accuse Dunbar");
    }
    return [...new Set(out)];
  }

  _showPairs() {
    return [["LoBlo", "Dunbar"], ["fragment", "Dunbar"], ["fragment", "Baxter"], ["Focus papers", "Baxter"], ["new will", "George"], ["letter", "Mrs. Robner"]];
  }

  _isLegal(a) {
    const s = this.state;
    if (typeof a !== "string" || !a.trim() || s.terminal && !s.terminal.choice) return false;
    if (s.terminal?.choice) return a === "close the case" || a === "continue investigating";
    if (a.startsWith("go to ")) return ROOMS.includes(a.slice(6)) && a.slice(6) !== s.room && !s.interviewee;
    if (s.interviewee) {
      const p = s.interviewee;
      if (a === `return ${p} to living room`) return true;
      if (a === `search ${p}`) return true;
      if (a.startsWith(`ask ${p} about `)) return TOPICS[p].includes(a.slice(`ask ${p} about `.length));
      return this._showPairs().some(([e, who]) => who === p && a === `show ${e} to ${p}` && s.found[e]);
    }
    if (a === "inspect letter" || a === "read letter") return s.room === "living room" && s.letterDelivered;
    for (const p of SUSPECTS) {
      if (a === `inspect ${p}` || a === `search ${p}`) return s.room === "living room";
      if (a === `interview ${p} privately`) return s.room === "living room";
      if (a.startsWith(`ask ${p} about `)) return s.room === "living room" && TOPICS[p].includes(a.slice(`ask ${p} about `.length));
      if (a.startsWith("show ") && a.endsWith(` to ${p}`)) return s.room === "living room" && this._showPairs().some(([e, who]) => who === p && a === `show ${e} to ${p}` && s.found[e]);
    }
    const has = (key) => Boolean(s.found[key]);
    const clue = (key) => Boolean(s.clues[key]);
    const room = s.room;
    const library = ["inspect body", "inspect teacup", "search body", "inspect saucer", "inspect Ebullion", "inspect desk", "inspect notepad", "search desk", "shade notepad with pencil", "inspect bookcase", "search bookcase", "open safe", "read Focus papers", "read new will", "analyze teacup", "analyze saucer"];
    const kitchen = ["inspect china", "search china", "count china", "inspect sugar bowl", "analyze sugar bowl"];
    const garden = ["inspect holes", "search holes", "inspect fragment", "clean fragment", "analyze fragment", "compare fragment with LoBlo"];
    if (library.includes(a)) {
      if (room !== "library") return false;
      if (a === "shade notepad with pencil") return clue("notepad_inspected");
      if (a === "search bookcase") return clue("bookcase_disturbed");
      if (a === "open safe") return s.safeFound;
      if (a.startsWith("read ")) return s.safeOpen;
      if (a.startsWith("analyze ")) return has(a.slice(8));
      return true;
    }
    if (kitchen.includes(a)) return room === "kitchen" && (a !== "analyze sugar bowl" || has("sugar bowl"));
    if (garden.includes(a)) {
      if (room !== "garden") return false;
      if (a === "inspect fragment" || a === "clean fragment") return has("fragment");
      if (a === "analyze fragment") return has("fragment") && clue("fragment_cleaned");
      if (a === "compare fragment with LoBlo") return clue("fragment_analyzed") && has("LoBlo");
      return true;
    }
    if (a.startsWith("accuse ")) {
      if (!clue("poison_confirmed")) return false;
      if (a === "accuse Dunbar") return has("LoBlo");
      return ["accuse Baxter", "accuse George", "accuse Mrs. Robner", "accuse Baxter and Dunbar"].includes(a);
    }
    return false;
  }

  _invalidReason(a) {
    if (typeof a !== "string") return "Choose an action from the available list.";
    if (a.startsWith("go to ") && a.slice(6) === this.state.room) return "You are already in that room.";
    if (a.startsWith("search ") && SUSPECTS.includes(a.slice(7)) && !this.state.interviewee) return "A suspect can only be searched during a private interview.";
    if (a === "read letter" && !this.state.letterDelivered) return "The letter has not arrived yet.";
    if (a === "open safe" && !this.state.safeFound) return "You have not found the concealed safe.";
    if (a === "clean fragment" && !this.state.found.fragment) return "Find the porcelain fragment in the Garden first.";
    if (a === "compare fragment with LoBlo" && (!this.state.clues.fragment_analyzed || !this.state.found.LoBlo)) return "Analyze the fragment and find Dunbar's LoBlo first.";
    if (a.startsWith("ask ")) return "The person, topic, or scene does not match this action.";
    return "That action is unavailable here or its prerequisites are missing.";
  }

  _apply(a) {
    const s = this.state;
    const clue = (key) => { s.clues[key] = true; };
    const found = (key) => { s.found[key] = true; };
    if (a.startsWith("go to ")) {
      s.room = a.slice(6);
      if (s.room === "living room") { s.roomEntries += 1; if (s.roomEntries >= 2) s.letterDelivered = true; }
      return s.room === "living room" && s.letterDelivered ? "The delivered letter is now on the table." : `You enter the ${s.room}.`;
    }
    if (a.startsWith("interview ")) {
      s.interviewee = a.slice(10, -" privately".length);
      s.room = "library";
      return `${s.interviewee} agrees to speak privately in the Library. The officer stays with the others.`;
    }
    if (a.startsWith("return ")) {
      const p = s.interviewee; s.interviewee = null; s.room = "living room"; s.roomEntries += 1;
      if (s.roomEntries >= 2) s.letterDelivered = true;
      return `${p} returns to the officer and the group.${s.letterDelivered ? " A delivered letter is on the table." : ""}`;
    }
    if (a === "inspect body") { clue("body_inspected"); return "Robner is dead. Ebullion and a tea service sit nearby; the death could initially resemble suicide."; }
    if (a === "inspect teacup") { found("teacup"); return "The cup bears tea residue. Its placement beside the body seems deliberate."; }
    if (a === "inspect saucer") { found("saucer"); return "The saucer sits beneath the cup; both belong to the house tea service."; }
    if (a === "search body") return "Robner's clothing holds no additional clue in this case.";
    if (a === "inspect Ebullion") { found("Ebullion"); return "Robner used Ebullion, a medicine relevant to the cause of death."; }
    if (a === "inspect desk") { clue("desk_inspected"); return "The desk is orderly except for a blank-looking note pad."; }
    if (a === "inspect notepad") { clue("notepad_inspected"); return "The page looks blank, but shallow pressure marks remain in the paper."; }
    if (a === "search desk") return "The desk drawers contain no further evidence.";
    if (a === "shade notepad with pencil") { clue("baxter_motive"); return "Pencil shading brings out an impression mentioning Baxter and Focus."; }
    if (a === "inspect bookcase") { if (s.clues.baxter_motive) clue("bookcase_disturbed"); return s.clues.baxter_motive ? "One section of the bookcase has been disturbed; something may be concealed behind it." : "The books and shelves look ordinary at a glance."; }
    if (a === "search bookcase") { s.safeFound = true; return "Behind the shifted books you find a concealed safe."; }
    if (a === "open safe") { s.safeOpen = true; found("Focus papers"); found("new will"); return "The safe contains papers about Baxter's Focus dispute and a new will that cuts George out."; }
    if (a === "read Focus papers") { found("Focus papers"); clue("baxter_motive"); return "The papers describe a serious business dispute between Baxter and Robner over Focus."; }
    if (a === "read new will") { found("new will"); return "The will would leave George out of Robner's inheritance."; }
    if (["analyze teacup", "analyze saucer"].includes(a)) { found(a.slice(8)); return a === "analyze teacup" ? "The cup carries Robner's fingerprints." : "The saucer carries Robner and Dunbar's fingerprints; this proves handling, not guilt."; }
    if (a === "inspect china") return "The tea service has a gap where one cup should be.";
    if (a === "search china") { clue("china_counted"); return "There are six cups and seven saucers in the cabinet."; }
    if (a === "count china") { clue("china_counted"); return "There are six cups and seven saucers, suggesting a cup was removed or switched."; }
    if (a === "inspect sugar bowl") { found("sugar bowl"); return "The bowl belongs to the tea service and can be examined for fingerprints."; }
    if (a === "analyze sugar bowl") return "The bowl carries Robner and Dunbar's fingerprints; fingerprints do not show when it was handled.";
    if (a === "inspect holes") { clue("ladder_holes"); return "Compacted ladder holes and crushed flowers sit below the Library window."; }
    if (a === "search holes") { found("fragment"); return "A patterned porcelain fragment lies in the disturbed soil."; }
    if (a === "inspect fragment") return "The fragment's pattern matches the house tea service.";
    if (a === "clean fragment") { clue("fragment_cleaned"); return "Cleaning exposes tea and sugar residue with an unfamiliar chemical trace."; }
    if (a === "analyze fragment") { clue("fragment_analyzed"); return "The lab finds tea, sugar, and a poison-like chemical. Compare it with available medicines."; }
    if (a === "compare fragment with LoBlo") { clue("poison_confirmed"); return "The fragment contains LoBlo. In combination with Robner's Ebullion, it explains a fatal poisoning."; }
    if (a === "inspect letter") { found("letter"); clue("affair"); return "The letter points to a private relationship between Mrs. Robner and Steven."; }
    if (a === "read letter") { found("letter"); clue("affair"); return "The personal letter confirms Mrs. Robner's relationship with Steven, a possible motive but no proof of murder."; }
    if (a.startsWith("inspect ") && SUSPECTS.includes(a.slice(8))) return `${a.slice(8)} remains with the group; ${a.slice(8) === "Mrs. Robner" ? "she looks anxious." : "their expression is guarded."}`;
    if (a.startsWith("search ") && SUSPECTS.includes(a.slice(7))) {
      const p = a.slice(7);
      if (!s.interviewee) return `${p} refuses a public search. No search occurs.`;
      if (p === "Dunbar") { found("LoBlo"); return "Dunbar consents to the search. You find a bottle of LoBlo among her belongings."; }
      if (p === "Mrs. Robner") return "With her consent, you find ordinary allergy and cold medicines, not LoBlo.";
      return `With ${p}'s consent, you find no relevant item.`;
    }
    if (a.startsWith("ask ")) return this._answer(a);
    if (a.startsWith("show ")) return this._confront(a);
    if (a === "accuse Dunbar") { s.terminal = { status: "choice", reason: "dunbar_only_accusation", score: null, choice: true }; return "Dunbar denies murder. Decide whether to close this incomplete case or continue investigating."; }
    if (a === "continue investigating") { s.terminal = null; return "The investigation remains open with its evidence intact."; }
    if (a === "close the case") { this._finish("incomplete_dunbar_case", "Dunbar is the sole accused. A later newspaper reports her release on bail, a possible plea deal, then her staged-suicide death. Baxter killed her to prevent her naming him.", 0); return this.state.terminal.message; }
    if (a.startsWith("accuse ")) {
      if (a === "accuse Baxter and Dunbar") {
        const complete = s.clues.poison_confirmed && s.found.LoBlo && s.clues.concert_contradiction && s.clues.baxter_motive && s.clues.ladder_holes && s.clues.china_counted;
        this._finish(complete ? "complete_solution" : "weak_case", complete ? "The evidence supports a conspiracy: Dunbar administered LoBlo, and Baxter's motive and cover-up connect him to the murder." : "Both suspects are named, but key evidence groups are missing. The prosecution cannot establish the conspiracy beyond reasonable doubt.", complete ? 1 : 0);
      } else this._finish("unsupported_accusation", "The accusation does not fit the evidence assembled; the case remains unresolved.", 0);
      return this.state.terminal.message;
    }
    return "";
  }

  _answer(a) {
    const [, person, topic] = a.match(/^ask (.+) about (.+)$/) || [];
    const s = this.state, privateMode = s.interviewee === person;
    s.asked[`${person}:${topic}`] = true;
    if (privateMode) s.asked[`${person}:${topic}:private`] = true;
    if (s.asked["Baxter:concert:private"] && s.asked["Dunbar:concert:private"]) s.clues.concert_contradiction = true;
    const answers = {
      "Baxter:concert": privateMode ? "Dunbar became ill and left early; I took her home." : "Dunbar felt unwell and left the concert early.",
      "Dunbar:concert": privateMode ? "Baxter and I attended together, and he took me home afterward." : "I don't recall the evening clearly.",
      "Baxter:alibi": privateMode ? "I was at the concert with Dunbar before taking her home." : "I was out that evening.",
      "Dunbar:alibi": privateMode ? "I attended a concert with Baxter." : "I was away for part of the evening.",
      "Dunbar:LoBlo": privateMode && s.found.LoBlo ? "The bottle is mine. That does not mean I gave it to Robner." : "I have nothing to add about medicine.",
      "George:new will": privateMode ? "The will changes what I expected to inherit. I was angry, but I did not poison him." : "I have not seen any new will.",
      "George:inheritance": privateMode ? "I expected to inherit more than this will gives me." : "Family matters are private.",
      "Mrs. Robner:Steven": privateMode && s.clues.affair ? "Steven and I were close. I was afraid people would discover it." : "I will not discuss Steven here.",
      "Mrs. Robner:letter": privateMode && s.clues.affair ? "The letter is personal. It explains my anxiety, not Marshall's death." : "That is a private matter.",
      "Baxter:Focus": privateMode ? "Robner and I disagreed over the Focus business." : "Business matters are not relevant here.",
      "Baxter:ladder": privateMode ? "I know the grounds, but I did not use a ladder at that window." : "I have no comment about the garden.",
      "Dunbar:Baxter": privateMode ? "Baxter and I knew one another before that concert." : "I don't know what you mean.",
      "Baxter:Dunbar": privateMode ? "Dunbar and I were only acquaintances." : "I hardly know her.",
      "Dunbar:new will": privateMode ? "I knew George was worried about the will." : "I haven't seen it.",
      "Mrs. Robner:alibi": privateMode ? "I was in the house that evening." : "I was at home.",
    };
    return answers[`${person}:${topic}`] || (privateMode ? `${person} answers briefly but offers no corroborating evidence on ${topic}.` : `${person} gives a guarded answer about ${topic}.`);
  }

  _confront(a) {
    const match = a.match(/^show (.+) to (.+)$/); const [, evidence, person] = match;
    this.state.shown[`${evidence}:${person}`] = true;
    const privateMode = this.state.interviewee === person;
    const prefix = privateMode ? "In private, " : "In front of the group, ";
    const lines = {
      "LoBlo:Dunbar": privateMode ? "Dunbar acknowledges the medicine is hers, but denies using it on Robner." : "Dunbar says the bottle proves nothing and will not discuss it here.",
      "fragment:Dunbar": privateMode ? "Dunbar admits she could have handled the service, but denies poisoning Robner." : "Dunbar denies knowing anything about the fragment.",
      "fragment:Baxter": privateMode ? "Baxter says he knew the garden but denies using the ladder or switching a cup." : "Baxter dismisses the fragment as garden debris.",
      "Focus papers:Baxter": privateMode ? "Baxter confirms a business dispute with Robner, not a murder plan." : "Baxter calls the papers an old disagreement.",
      "new will:George": privateMode ? "George admits the will gives him a reason to be upset." : "George avoids answering about the will.",
      "letter:Mrs. Robner": privateMode ? "Mrs. Robner confirms the relationship with Steven." : "Mrs. Robner refuses to discuss Steven in front of the others.",
    };
    return prefix + lines[`${evidence}:${person}`];
  }

  _finish(reason, message, score) {
    this.state.terminal = { status: "terminal", reason, message, score,
      successfulActions: this.state.successfulActions, submittedCalls: this.state.submittedCalls };
  }
}
