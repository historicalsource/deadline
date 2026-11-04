export const ROOMS = ["living room", "library", "kitchen", "garden"];
export const SUSPECTS = ["Baxter", "Dunbar", "George", "Mrs. Robner"];
export const ACTION_GUIDE = [
  { action: "go to", description: "Move to another room." },
  { action: "inspect", description: "Look at a visible object, person, or document. The Garden's porcelain fragment may also be called fragment or porcelain." },
  { action: "search", description: "Search around objects for details, hidden items, or counts. Search a person's belongings during a private interview." },
  { action: "ask", template: "ask [person] about [topic]", description: "Question a suspect about a subject." },
  { action: "interview privately", template: "interview privately [person]", description: "Speak privately with a suspect; the officer stays with the others." },
  { action: "return", template: "return [person]", description: "End the private interview and return the suspect to the group." },
  { action: "show", template: "show [person] [evidence]", description: "Present found evidence to a suspect who is with you." },
  { action: "shade", description: "Shade a writing surface to bring out faint marks." },
  { action: "analyze", description: "Send found evidence for laboratory analysis." },
  { action: "compare", template: "compare [A] with [B]", description: "Compare two evidence items. Either order is accepted." },
  { action: "accuse", description: "Name a suspect who is present. If an episode limit does not end the game, choose to close the case or continue investigating." },
];
const TOPICS = {
  Baxter: ["alibi", "concert", "Focus", "Focus papers", "ladder", "Dunbar", "George", "Mrs. Robner", "death"],
  Dunbar: ["alibi", "concert", "LoBlo", "Baxter", "George", "Mrs. Robner", "new will", "death"],
  George: ["alibi", "new will", "inheritance", "Focus", "Baxter", "Mrs. Robner", "death"],
  "Mrs. Robner": ["alibi", "letter", "Steven", "Baxter", "George", "Dunbar", "death"],
};
const clone = (v) => structuredClone(v);

function normalizeShowAction(action) {
  if (typeof action !== "string" || !action.startsWith("show ")) return action;
  if (/^show .+ to .+$/.test(action)) return action;
  const body = action.slice(5).trim();
  for (const person of SUSPECTS) {
    if (!body.startsWith(`${person} `)) continue;
    let evidence = body.slice(person.length + 1).replace(/[()]/g, "").replace(/\s+/g, " ").trim();
    if (person === "Baxter" && evidence.toLowerCase() === "papers") evidence = "Focus papers";
    if (["porcelain", "fragment"].includes(evidence.toLowerCase())) evidence = "porcelain fragment";
    return `show ${evidence} to ${person}`;
  }
  return action;
}

function normalizeAction(action) {
  if (typeof action !== "string") return action;
  const accusation = action.match(/^accuse\s+(.+)$/i);
  if (accusation) {
    const names = accusation[1].replace(/,\s*and\s+/gi, ", ").split(/\s*(?:,|\band\b)\s*/i).filter(Boolean);
    const found = names.map((name) => SUSPECTS.find((person) => person.toLowerCase() === name.trim().toLowerCase()));
    if (found.length && found.every(Boolean) && new Set(found).size === found.length) {
      return `accuse ${SUSPECTS.filter((person) => found.includes(person)).join(" and ")}`;
    }
  }
  const comparison = action.match(/^compare (.+) with (.+)$/i);
  if (comparison) {
    const canonical = (item) => {
      const value = item.trim().toLowerCase();
      if (value === "new chemical") return "new chemical";
      if (value === "loblo") return "LoBlo";
      if (value === "allergone") return "Allergone";
      return null;
    };
    const [left, right] = [canonical(comparison[1]), canonical(comparison[2])];
    if (left === "new chemical" && ["LoBlo", "Allergone"].includes(right)) return `compare new chemical with ${right}`;
    if (right === "new chemical" && ["LoBlo", "Allergone"].includes(left)) return `compare new chemical with ${left}`;
  }
  const porcelainAction = action.match(/^(inspect|clean|analyze) (?:porcelain fragment|fragment|porcelain)(?=$| with )/);
  const normalized = porcelainAction
    ? action.replace(/^(inspect|clean|analyze|compare) (?:porcelain fragment|fragment|porcelain)/, "$1 fragment")
    : action;
  return normalizeShowAction(normalized);
}

export class DeadlineGame {
  constructor({ maxActions = 50, maxCalls = 60 } = {}) {
    this.limits = { maxActions, maxCalls };
    this.reset(0);
  }

  reset(seed = 0) {
    this.seed = seed;
    this.state = {
      room: "living room", roomEntries: 1, interviewee: null,
      letterDelivered: false, safeFound: false, safeOpen: false,
      found: {}, clues: {}, asked: {}, shown: {}, pendingMessages: [], terminal: null,
      accusations: [],
      successfulActions: 0, submittedCalls: 0, log: [],
    };
    return this.observe("detective");
  }

  observe(playerId) {
    if (playerId !== "detective") throw new Error("Unknown player role.");
    const s = this.state;
    const knownEvidence = Object.keys(s.found).filter((key) => s.found[key]);
    const roomText = s.interviewee
      ? `${s.interviewee} is speaking with you privately. The officer remains with the other residents.`
      : {
      "living room": "Four residents wait under the watch of a uniformed patrol officer. Mrs. Robner looks tense. The officer remains with the group while you investigate.",
      library: "Marshall Robner lies beside a teacup and a saucer. A bottle of Ebullion, a writing desk, and a bookcase are nearby.",
      kitchen: "The Robner family's hand-painted china is displayed on shelves: plates, teacups, and saucers.",
      garden: "Rows of yellow, red, pink, and white roses fill the garden beside the house. There are holes in the soft earth near your feet. A wooden ladder rests beside the rose beds.",
    }[s.room];
    return {
      player: playerId, room: s.interviewee ? "private interview" : s.room, roomText,
      actionWords: this.legal_action_words(playerId),
      actionGuide: clone(ACTION_GUIDE),
      choices: s.terminal?.choice ? [
        { label: "Close the case", action: "close the case" },
        { label: "Continue investigating", action: "continue investigating" },
      ] : [],
      interviewee: s.interviewee,
      letterDelivered: s.letterDelivered,
      pendingMessages: clone(s.pendingMessages),
      evidence: knownEvidence,
      accusations: [...s.accusations],
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

  legal_action_words(playerId) {
    if (playerId !== "detective") throw new Error("Unknown player role.");
    if (this.state.terminal?.choice) return [];
    return [...new Set(this.legal_actions(playerId).map((action) => {
      if (action.startsWith("go to ")) return "go to";
      if (action.startsWith("interview privately ")) return "interview privately";
      return action.split(" ")[0];
    }))];
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
    this.state.log.push({ action, message, room: this.state.interviewee ? "private interview" : this.state.room });
    if ((!this.state.terminal || this.state.terminal.choice) && this.state.successfulActions >= this.limits.maxActions) {
      this._finish("episode_limit", "The investigation ended at its successful-action limit.", 0);
    } else if ((!this.state.terminal || this.state.terminal.choice) && this.state.submittedCalls >= this.limits.maxCalls) {
      this._finish("model_call_limit", "The submitted-call limit was reached before the case could be concluded.", 0);
    }
    return { valid: true, message, observation: this.observe(playerId), outcome: this.outcome() };
  }

  _candidates() {
    const out = [];
    for (const room of ROOMS) if (room !== this.state.room) out.push(`go to ${room}`);
    const add = (...a) => out.push(...a);
    if (this.state.terminal?.choice) return ["close the case", "continue investigating"];
    add("compare new chemical with LoBlo", "compare new chemical with Allergone");
    if (this.state.interviewee) {
      const person = this.state.interviewee;
      add(`return ${person}`, `search ${person}`, `accuse ${person}`);
      for (const topic of TOPICS[person]) add(`ask ${person} about ${topic}`);
      for (const [evidence, who] of this._showPairs()) if (who === person) add(`show ${person} ${evidence}`);
    } else {
      if (this.state.room === "living room") {
        add("inspect letter", "read letter");
        for (const person of SUSPECTS) add(`accuse ${person}`);
        add("accuse George and Mrs. Robner");
        add("accuse Baxter and Dunbar");
        for (const george of [false, true]) for (const mrs of [false, true]) {
          if (george || mrs) add(`accuse Baxter and Dunbar${george ? " and George" : ""}${mrs ? " and Mrs. Robner" : ""}`);
        }
        for (const person of SUSPECTS) {
          add(`inspect ${person}`, `search ${person}`, `interview privately ${person}`);
          for (const topic of TOPICS[person]) add(`ask ${person} about ${topic}`);
          for (const [evidence, who] of this._showPairs()) if (who === person) add(`show ${person} ${evidence}`);
        }
      }
      if (this.state.room === "library") add(
        "inspect body", "inspect teacup", "search body", "inspect saucer", "inspect Ebullion", "inspect desk",
        "inspect notepad", "search desk", "shade notepad", "inspect bookcase", "search bookcase", "open safe",
        "read papers", "read Focus papers", "read new will", "analyze teacup", "analyze saucer",
      );
      if (this.state.room === "kitchen") add("inspect china", "search china", "count china");
      if (this.state.room === "garden") add("inspect holes", "search holes", "inspect ladder", "inspect fragment", "clean fragment", "analyze fragment");
    }
    return [...new Set(out)];
  }

  _showPairs() {
    return [["LoBlo", "Dunbar"], ["porcelain fragment", "Dunbar"], ["porcelain fragment", "Baxter"], ["Focus papers", "Baxter"], ["new will", "George"], ["letter", "Mrs. Robner"]];
  }

  _isLegal(a) {
    a = normalizeAction(a);
    const s = this.state;
    if (typeof a !== "string" || !a.trim() || s.terminal && !s.terminal.choice) return false;
    if (s.terminal?.choice) return a === "close the case" || a === "continue investigating";
    if (a === "read papers") a = "read Focus papers";
    if (a.startsWith("go to ")) return ROOMS.includes(a.slice(6)) && a.slice(6) !== s.room && !s.interviewee;
    const has = (key) => Boolean(s.found[key]);
    if (a === "compare new chemical with LoBlo") return has("new chemical") && has("LoBlo");
    if (a === "compare new chemical with Allergone") return has("new chemical") && has("Allergone");
    if (a.startsWith("accuse ")) {
      const names = a.slice(7).split(" and ");
      if (names.length === 1) return SUSPECTS.includes(names[0]) && (s.interviewee === names[0] || (!s.interviewee && s.room === "living room"));
      const jointTrueAccusation = names.includes("Baxter") && names.includes("Dunbar");
      const jointFalseAccusation = names.every((person) => ["George", "Mrs. Robner"].includes(person));
      return !s.interviewee && s.room === "living room" && (jointTrueAccusation || jointFalseAccusation);
    }
    if (s.interviewee) {
      const p = s.interviewee;
      if (a === `return ${p}`) return true;
      if (a === `search ${p}`) return true;
      if (a.startsWith(`ask ${p} about `)) return TOPICS[p].includes(a.slice(`ask ${p} about `.length));
      return this._showPairs().some(([e, who]) => who === p && a === `show ${e} to ${p}` && s.found[e]);
    }
    if (a === "inspect letter" || a === "read letter") return s.room === "living room" && s.letterDelivered;
    for (const p of SUSPECTS) {
      if (a === `inspect ${p}` || a === `search ${p}`) return s.room === "living room";
      if (a === `interview privately ${p}`) return s.room === "living room";
      if (a.startsWith(`ask ${p} about `)) return s.room === "living room" && TOPICS[p].includes(a.slice(`ask ${p} about `.length));
      if (a.startsWith("show ") && a.endsWith(` to ${p}`)) return s.room === "living room" && this._showPairs().some(([e, who]) => who === p && a === `show ${e} to ${p}` && s.found[e]);
    }
    const clue = (key) => Boolean(s.clues[key]);
    const room = s.room;
    const library = ["inspect body", "inspect teacup", "search body", "inspect saucer", "inspect Ebullion", "inspect desk", "inspect notepad", "search desk", "shade notepad", "inspect bookcase", "search bookcase", "open safe", "read papers", "read Focus papers", "read new will", "analyze teacup", "analyze saucer"];
    const kitchen = ["inspect china", "search china", "count china"];
    const garden = ["inspect holes", "search holes", "inspect ladder", "inspect fragment", "clean fragment", "analyze fragment"];
    if (library.includes(a)) {
      if (room !== "library") return false;
      if (a === "shade notepad") return clue("notepad_inspected");
      if (a === "search bookcase") return clue("bookcase_disturbed");
      if (a === "open safe") return s.safeFound;
      if (a.startsWith("read ")) return s.safeOpen;
      if (a.startsWith("analyze ")) return has(a.slice(8));
      return true;
    }
    if (kitchen.includes(a)) return room === "kitchen";
    if (garden.includes(a)) {
      if (room !== "garden") return false;
      if (a === "inspect fragment" || a === "clean fragment") return has("porcelain fragment");
      if (a === "analyze fragment") return has("porcelain fragment") && clue("fragment_cleaned");
      return true;
    }
    return false;
  }

  _invalidReason(a) {
    if (typeof a !== "string") return "The command is not written in a form this case can process.";
    a = normalizeAction(a);
    if (a.startsWith("go to ") && a.slice(6) === this.state.room) return "You are already in that room.";
    if (a.startsWith("accuse ")) return "The person you want to accuse is not with you.";
    if (a.startsWith("search ") && SUSPECTS.includes(a.slice(7)) && !this.state.interviewee) return "A suspect can only be searched during a private interview.";
    if (a.startsWith("show ")) return "Find the evidence and be with the person you want to show it to.";
    if (a === "read letter" && !this.state.letterDelivered) return "The letter has not arrived yet.";
    if (a === "open safe" && !this.state.safeFound) return "You have not found the concealed safe.";
    if (a === "clean fragment" && !this.state.found["porcelain fragment"]) return "Find the porcelain fragment in the Garden first.";
    if (a.startsWith("compare new chemical with ") && !this.state.found["new chemical"]) return "Analyze the porcelain fragment first.";
    if (a === "compare new chemical with LoBlo" && !this.state.found.LoBlo) return "Find Dunbar's LoBlo first.";
    if (a === "compare new chemical with Allergone" && !this.state.found.Allergone) return "Find Mrs. Robner's Allergone first.";
    if (a.startsWith("ask ")) return "The person, topic, or scene does not match this action.";
    return "That action is unavailable here or its prerequisites are missing.";
  }

  _apply(a) {
    const s = this.state;
    a = normalizeAction(a);
    if (a === "read papers") a = "read Focus papers";
    const clue = (key) => { s.clues[key] = true; };
    const found = (key) => { s.found[key] = true; };
    if (a.startsWith("go to ")) {
      const letterWasDelivered = s.letterDelivered;
      s.room = a.slice(6);
      if (s.room === "living room") { s.roomEntries += 1; if (s.roomEntries >= 2) s.letterDelivered = true; }
      if (!letterWasDelivered && s.letterDelivered) s.pendingMessages.push({ id: "letter-arrived", message: "The officer tells you a letter arrived while you were away. He left it on the table for you." });
      return `You enter the ${s.room}.`;
    }
    if (a.startsWith("interview privately ")) {
      s.interviewee = a.slice("interview privately ".length);
      return `${s.interviewee} agrees to speak with you privately. The officer stays with the others.`;
    }
    if (a.startsWith("return ")) {
      const p = s.interviewee; s.interviewee = null;
      return `The private interview with ${p} ends. ${p} returns to the officer and the group.`;
    }
    if (a === "inspect body") { clue("body_inspected"); return "Robner lies on the Library floor beside a teacup and a saucer."; }
    if (a === "inspect teacup") { found("teacup"); return "The overturned, hand-painted cup has a brown mark at the bottom and smells faintly of tea."; }
    if (a === "inspect saucer") { found("saucer"); return "The overturned saucer is hand-painted with a mythological scene and has small brown marks. It smells faintly of tea and matches the household service."; }
    if (a === "search body") return "Robner's clothing holds no additional clue in this case.";
    if (a === "inspect Ebullion") { found("Ebullion"); return "The bottle is labeled for Marshall Robner. Its 25 mg Ebullion tablets are prescribed for depression: one or two twice daily. The label warns that a sufficient dosage may be harmful or fatal."; }
    if (a === "inspect desk") { clue("desk_inspected"); return "The desk is orderly except for a blank-looking notepad."; }
    if (a === "inspect notepad") { clue("notepad_inspected"); return "The page looks blank, but shallow pressure marks remain in the paper."; }
    if (a === "search desk") return "The desk drawers contain no further evidence.";
    if (a === "shade notepad") { clue("baxter_motive"); clue("notepad_read"); return "Shading the page reveals impressions left by writing on the previous sheet. The writer pressed hard, but only fragments are legible: ‘Baxter,’ ‘merg...,’ ‘Omnidyne,’ ‘Focus,’ and ‘recons...’."; }
    if (a === "inspect bookcase") { clue("bookcase_disturbed"); return "The books are carefully arranged. One section is slightly out of line."; }
    if (a === "search bookcase") { s.safeFound = true; return "Behind the shifted books you find a concealed safe."; }
    if (a === "open safe") { s.safeOpen = true; found("Focus papers"); found("new will"); return "Inside the safe are two documents: a packet of papers and a new will."; }
    if (a === "read Focus papers") { found("Focus papers"); clue("baxter_motive"); clue("focus_papers_read"); return "Focus Corporation was a subsidiary of Robner Corp. These papers document funds Baxter embezzled from Focus and describe how the scandal was hushed up. Robner's records describe how the matter was handled."; }
    if (a === "read new will") { found("new will"); return "The new will disinherits George and leaves Robner's entire estate to his wife."; }
    if (["analyze teacup", "analyze saucer"].includes(a)) { found(a.slice(8)); return a === "analyze teacup" ? "The cup contains a trace of tea. Its fingerprints are Robner's." : "The saucer contains traces of tea and sugar. Its fingerprints are Robner's and Dunbar's."; }
    if (a === "inspect china") { clue("china_examined"); return "Each piece is hand-painted with a scene from Greek mythology."; }
    if (a === "search china") { clue("china_counted"); return "There are six hand-painted cups and seven hand-painted saucers in the cabinet."; }
    if (a === "count china") { clue("china_counted"); return "There are eight large and small plates, seven saucers, and six cups."; }
    if (a === "inspect ladder") return "The wooden ladder is about fifteen feet long and caked with dirt and dried mud. Its feet seem to fit the holes in the garden.";
    if (a === "inspect holes") { clue("ladder_holes"); return "There are two holes in the soft earth, each about two inches by four inches and at least three inches deep. The soil around them is compacted."; }
    if (a === "search holes") { found("porcelain fragment"); return "Digging in the soft earth, you cut your finger on a sharp edge and find a piece of porcelain covered in dirt and dried mud."; }
    if (a === "inspect fragment") return `The porcelain is filthy with dried mud. You can barely make out the design beneath it.${s.clues.fragment_cleaned && s.clues.china_examined ? " Its painted pattern matches the china you examined in the Kitchen." : ""}`;
    if (a === "clean fragment") { clue("fragment_cleaned"); return `As you wipe off the porcelain, its hand-painted design becomes visible${s.clues.china_examined ? ". The markings match the china you examined in the Kitchen" : ""}.`; }
    if (a === "analyze fragment") { clue("fragment_analyzed"); found("new chemical"); return "The lab finds traces of tea and sugar, along with another chemical not commonly used as medication. It is not Amitraxin (Ebullion). No clear fingerprints remain."; }
    if (a === "compare new chemical with LoBlo") { clue("poison_confirmed"); return "The lab identifies Methsparin, sold as LoBlo, on the fragment. A recheck finds a high level of Methsparin in Robner's blood. The report describes how Methsparin displaces Ebullion from protein binding, leaving more free Ebullion in the blood and simulating an overdose. The pathologist attributes death to Ebullion toxicity after ingestion of both medicines."; }
    if (a === "compare new chemical with Allergone") return "The comparison finds no match between the new chemical on the porcelain fragment and Mrs. Robner's Allergone label.";
    if (a === "inspect letter") return "The envelope is addressed to Mrs. Marshall Robner. It bears a July 6, 1982 postmark.";
    if (a === "read letter") { found("letter"); clue("letter_read"); s.pendingMessages = s.pendingMessages.filter(({ id }) => id !== "letter-arrived"); return `“Dear Leslie,\n\nI am sorry to hear that Marshall is despondent again. I know how much his troubles weigh on you, and I wish I could be there to comfort you. His despondency is tied to his business. He speaks of suicide when he is in this state, but the thought of what will happen to the company may keep him going.\n\nSo George has made his threats again? It is hard to believe he could cause Marshall so much pain. If the worst should happen, you will be provided for as you deserve.\n\nI look forward to Friday, when we can be together again. Until then, remember how much I love you and the life we hope to share.\n\nLove,\nSteven”`; }
    if (a.startsWith("inspect ") && SUSPECTS.includes(a.slice(8))) {
      return ({ Baxter: "Mr. Baxter is sitting quietly here.", Dunbar: "Ms. Dunbar is sitting on the sofa here.", George: "George is here, pacing around the room.", "Mrs. Robner": "Mrs. Robner is sitting here, knitting." })[a.slice(8)];
    }
    if (a.startsWith("search ") && SUSPECTS.includes(a.slice(7))) {
      const p = a.slice(7);
      if (!s.interviewee) return `${p} refuses a public search. No search occurs.`;
      if (p === "Dunbar") { found("LoBlo"); return "Dunbar consents to the search. You find a bottle of LoBlo among her belongings."; }
      if (p === "Mrs. Robner") { found("Allergone"); return "Among Mrs. Robner's belongings is a bottle labeled Allergone."; }
      return `With ${p}'s consent, you find no relevant item.`;
    }
    if (a.startsWith("ask ")) return this._answer(a);
    if (a.startsWith("show ")) return this._confront(a);
    if (a === "continue investigating") { s.terminal = null; return "The investigation remains open with the accusation record and evidence intact."; }
    if (a === "close the case") { this._closeCase(); return ""; }
    if (a.startsWith("accuse ")) {
      const accusedNow = a.slice(7).split(" and ");
      s.accusations = SUSPECTS.filter((person) => s.accusations.includes(person) || accusedNow.includes(person));
      const list = s.accusations.length > 2
        ? `${s.accusations.slice(0, -1).join(", ")}, and ${s.accusations.at(-1)}`
        : s.accusations.join(" and ");
      s.terminal = {
        status: "choice", reason: "accusation_pending", title: "Accusation on record",
        message: `The case record now names ${list}. Close the case on these accusations, or continue investigating.`,
        score: null, choice: true,
      };
      return "";
    }
    return "";
  }

  _closeCase() {
    const s = this.state;
    const accused = s.accusations;
    const namesBaxterAndDunbar = accused.includes("Baxter") && accused.includes("Dunbar");
    if (namesBaxterAndDunbar && accused.length > 2) {
      const extra = accused.filter((person) => !["Baxter", "Dunbar"].includes(person));
      const complete = s.clues.poison_confirmed && s.found.LoBlo && s.clues.concert_contradiction && s.clues.focus_papers_read && s.clues.notepad_read;
      const extraNames = extra.join(" and ");
      const extraSubject = extra.length === 1 ? `${extraNames} is cleared` : `${extraNames} are cleared`;
      const message = complete
        ? `The evidence against Baxter and Dunbar withstands review. The additional accusation against ${extraNames} is not supported, and ${extraSubject}. Baxter and Dunbar are convicted for Robner's murder; the overbroad charge delayed the case, but did not prevent the evidence from reaching the jury.`
        : `The additional accusation against ${extraNames} is withdrawn when it cannot be supported. The case against Baxter and Dunbar also fails to establish every link required for conviction. No one is convicted in Robner's death, and the prosecutor closes the investigation without the complete account.`;
      this._finish("overinclusive_accusation", message, complete ? 1 : 0, complete ? "The case survives an overbroad charge" : "Overbroad accusation; case unproved");
    } else if (accused.includes("Baxter") && !accused.includes("Dunbar")) {
      const additional = accused.filter((person) => person !== "Baxter");
      const hasMotive = s.clues.focus_papers_read && s.clues.notepad_read;
      const hasMethod = s.clues.poison_confirmed && s.found.LoBlo;
      const preface = additional.length ? `The accusations against ${additional.join(" and ")} are not supported and those suspects are cleared. ` : "";
      const message = hasMotive && hasMethod
        ? `${preface}Baxter is arrested, but the case names him without Dunbar and cannot explain how the poison reached Robner or establish who placed it in his tea. At trial the jury accepts that Baxter had a business motive, yet finds the account of the poisoning incomplete. He is acquitted of Robner's murder. Dunbar's role remains undiscovered in the case record.`
        : `${preface}The District Attorney declines to pursue the charge against Baxter. The investigation has not connected him to a proven method of poisoning Robner, and the evidence presented does not establish a complete case against him. The death remains officially unresolved.`;
      this._finish("baxter_only", message, 0, "Baxter accused alone");
    } else if (accused.includes("Dunbar") && !accused.includes("Baxter")) {
      const additional = accused.filter((person) => person !== "Dunbar");
      const preface = additional.length ? `The accusations against ${additional.join(" and ")} are unsupported and are dropped. ` : "";
      this._finish("incomplete_dunbar_case", `${preface}Dunbar is charged as the sole remaining suspect and released on bail while awaiting trial. The prosecutor considers offering a reduced sentence in exchange for information about an accomplice. Before she can give that account, Dunbar is found shot in her bedroom beside a pistol and a forged suicide note. The investigation later establishes that Baxter entered through the bedroom balcony and staged the scene to silence her.`, 0, "Dunbar's case");
    } else if (accused.every((person) => ["George", "Mrs. Robner"].includes(person))) {
      const named = accused.join(" and ");
      this._finish("false_accusation_suicide", `The inquiry finds no evidence connecting ${named} to a poisoning. The medicine and circumstances at the scene remain consistent with the initial suicide finding; without a supported accusation against the people responsible, the District Attorney closes the case as a suicide.`, 0, "The death is recorded as suicide");
    } else if (namesBaxterAndDunbar) {
      const complete = s.clues.poison_confirmed && s.found.LoBlo && s.clues.concert_contradiction && s.clues.focus_papers_read && s.clues.notepad_read;
      const missingFocus = !s.clues.focus_papers_read;
      const missingNote = !s.clues.notepad_read;
      const weakMessage = missingFocus
        ? "The grand jury declines to indict. The Focus papers were not read into evidence, leaving Baxter's business scandal unconnected to Robner's death in the case presented."
        : missingNote
          ? "The jury declines to convict. The Focus case was not connected directly to Robner's death in the evidence presented."
          : "The jury declines to convict. The evidence does not place Baxter near the grounds on the night of the murder; his symphony alibi was confirmed by several people.";
      this._finish(complete ? "complete_solution" : "weak_case", complete ? "The prosecution presents the poison report, Dunbar's possession of LoBlo, the conflicting concert accounts, and the Focus papers and notepad impression linking Baxter to Robner's business dispute. The jury convicts Baxter and Dunbar of Robner's murder. The case is closed with both roles established by the evidence." : weakMessage, complete ? 1 : 0, complete ? "Case solved" : "The joint case is not proved");
    } else {
      this._finish("unsupported_accusation", "This accusation combination does not establish a case. The investigation closes without a supported account of Robner's death.", 0, "The accusation is not proved");
    }
  }

  _answer(a) {
    const [, person, topic] = a.match(/^ask (.+) about (.+)$/) || [];
    const s = this.state, privateMode = s.interviewee === person;
    s.asked[`${person}:${topic}`] = true;
    if (privateMode) s.asked[`${person}:${topic}:private`] = true;
    const heardConcertAccount = (suspect) => ["alibi", "concert"].some((topic) => s.asked[`${suspect}:${topic}:private`]);
    if (heardConcertAccount("Baxter") && heardConcertAccount("Dunbar")) s.clues.concert_contradiction = true;
    const answers = {
      "Baxter:concert": privateMode ? "Ms. Dunbar was with me at the concert on the night that Marshall killed himself. She became ill at intermission and hired a car to take her back home. You see, Inspector, I know that Ms. Dunbar appreciates classical music, so I occasionally ask her along to my subscription series. I really should have told the other detective, but I didn't think it mattered." : "A marvelous concert! There were works by Beethoven, Sibelius, and Ravel. I never would've guessed you were interested in serious music, Inspector.",
      "Dunbar:concert": privateMode ? "Oh, I...well, I guess I should tell you. You see, Mr. Baxter and I, we go together to concerts, only occasionally, you understand. We went that night, the night Marshall died. Then he took me home and that's it. I should have said something before, but I just didn't think it was important, and, well, I didn't think that the others should know we were seeing each other socially. Our...nobody knows about it, you know. Please don't say anything!" : "I don't know what you are talking about. I don't go in for concerts much, you know.",
      "Baxter:alibi": privateMode ? "Ms. Dunbar was with me at the concert on the night that Marshall killed himself. She became ill at intermission and hired a car to take her back home. You see, Inspector, I know that Ms. Dunbar appreciates classical music, so I occasionally ask her along to my subscription series. I really should have told the other detective, but I didn't think it mattered." : "I can't help you there.",
      "Dunbar:alibi": privateMode ? "Oh, I...well, I guess I should tell you. You see, Mr. Baxter and I, we go together to concerts, only occasionally, you understand. We went that night, the night Marshall died. Then he took me home and that's it. I should have said something before, but I just didn't think it was important, and, well, I didn't think that the others should know we were seeing each other socially. Our...nobody knows about it, you know. Please don't say anything!" : "I'm sorry, but I can't help you with that.",
      "Dunbar:LoBlo": s.found.LoBlo ? "You found those in my bathroom, didn't you? I've been taking them for months for my blood pressure. Are they important?" : "I'm sorry, but I can't help you with that.",
      "George:new will": s.found["new will"] ? "You should know what it says." : "I don't know anything about any new will.",
      "George:alibi": "I haven't a clue.",
      "George:inheritance": "Dad always threatened to write a new will, but I guess he ran out of time.",
      "Mrs. Robner:Steven": s.shown["letter:Mrs. Robner"] ? "Steven is a close personal friend. We have known him for many years, and I visit his home frequently. Marshall knew of our friendship and didn't begrudge it in the slightest. My husband and I had a very trusting relationship. You may find the idea of trust difficult to understand, I suppose." : "I don't know who you mean. I have no friend named Steven.",
      "Mrs. Robner:letter": "I don't know much about that.",
      "Baxter:Focus": s.shown["Focus papers:Baxter"] ? "I told you already. There was no legal wrongdoing, only some reporters trying to stir up a fuss." : "I'm not sure what you mean. Focus Corporation has been a subsidiary of Robner Corp. for some years. I fail to see its import.",
      "Baxter:George": "I've known the boy for some time, and believe me, he's no good. He's wasted more money this year than you've probably earned. His father reprimanded him frequently, as you know. George even threatened his father from time to time.",
      "Baxter:Dunbar": "Ms. Dunbar is an efficient and tireless worker. She has been of tremendous help to Marshall and has been working quite hard for him lately. She had a great deal of respect for him, that's clear. She has a keen mind and is an exceptional strategic planner for the corporation.",
      "Baxter:Mrs. Robner": "Leslie is a fine woman from a distinguished family. She was much more outgoing than Marshall, but she seems to have become accustomed to the quiet life here. I am quite grieved for her.",
      "Baxter:ladder": "What ladder? You know, Inspector, your questions are becoming quite tiresome.",
      "Baxter:death": "Marshall was a truly great man...a brilliant manager; he started the corporation single-handedly about 25 years ago and is mostly responsible for its reputation. I owe him a great deal. He was also a great philanthropist and got the corporation involved in many charitable works. I am not given to shows of emotion, Inspector, but I will miss him greatly.",
      "Dunbar:George": "Nobody likes George much. He's always alone when he's here, and that's only when he can't get more money to waste. I think he's just been waiting for the day when his father's money would be his. I can't say I miss him when he's not here: A thoroughly obnoxious child.",
      "Dunbar:Mrs. Robner": "She's a lovely person. She and Marshall were always an odd couple: he was so quiet and reserved, and she's so lively and sociable. She's changed a lot over the last few years. She used to enjoy life here, but lately she's been restless and irritable, and now with Marshall's death, I'm worried about what may become of her.",
      "Dunbar:Focus": "Focus? There was once a subsidiary of Robner Corp. with that name. I can't recall much about it, though.",
      "Dunbar:new will": s.found["new will"] ? "I guess I'm not surprised that Marshall disinherited George. He's been asking for it." : "As far as I know, there was no new will written, although Marshall did threaten to disinherit George. I guess he could have written one without my knowledge. I'm not always with him, you know.",
      "Dunbar:death": "I've known him for years. He's been tremendously nervous and depressed lately about business. I don't think all was well in his personal life either. George has always been a problem for him. He even mentioned suicide once, although I never took it seriously. It shows you can never tell.",
      "George:Focus": "Focus...Focus...That name rings a bell. Something about the company, quite a while ago...what was it? I can't remember now. I don't pay much attention to business stuff: I've got better things to do.",
      "George:Baxter": "I don't know much about him, really. With Baxter, it's always business, and he's not here much except to discuss business with Dad. You might ask Ms. Dunbar about him, though. She handled lots of Dad's business matters herself, so they work together a lot. They probably know each other pretty well.",
      "George:Dunbar": "She's been here for about ten years, I guess. She knows a lot about Dad's business, and he lets her take care of a lot of stuff by herself. Other than that, I can't say. We don't get in each other's way. I think she's heard Dad lecture me too often.",
      "George:Mrs. Robner": "She's OK. Not as stuck up as Dad about money. We've always gotten along pretty well. I think she understands me better than Dad ever did.",
      "George:death": "We didn't get along too well. He was always riding me, giving me a hard time. Look, man. I'm not going to lie and say I loved him, right?",
      "Mrs. Robner:Baxter": "Baxter has been my husband's partner for a long time, but they're not close friends. Baxter has always had the head for making money, and Marshall had the creative spark for new products. The two of them were perfect for each other in the early days. Of course, things haven't been going well lately. I guess none of that matters much now.",
      "Mrs. Robner:George": "A child. He may be a man in age, but he still hasn't really grown up. He'll find himself someday, but in the meantime he can be a trial. I guess Marshall and I were too lenient. We probably still are, but he is our son, after all. We can't throw him out on the street.",
      "Mrs. Robner:Dunbar": "I've always thought she was a bit too smug in her relationships around here. A bit above herself, if you see my meaning. After all, she's really just a glorified secretary. She acts as though she's part of the family, and she does get along well with almost everyone here. I swear, though, Marshall spent more time with her than me, lately. Um...not that I'm trying to imply that anything went on between them. Quite the contrary.",
      "Mrs. Robner:death": "I loved my husband, no matter what you may think. I am very sorry to have lost him.",
      "Mrs. Robner:alibi": "I don't know much about that.",
      "Dunbar:Baxter": "Mr. Baxter? I see him often when he comes here on business, but I don't really know him that well. We keep to business when he comes around, and I hardly ever talk with him otherwise. He is, of course, an excellent executive, and poor Mr. Robner had every confidence in him.",
      "Dunbar:Mrs. Robner": "She's a lovely person. She and Marshall were always an odd couple: he was so quiet and reserved, and she's so lively and sociable. She's changed a lot over the last few years. She used to enjoy life here, but lately she's been restless and irritable, and now with Marshall's death, I'm worried about what may become of her.",
    };
    const answerTopic = person === "Baxter" && topic === "Focus papers" ? "Focus" : topic;
    const answer = answers[`${person}:${answerTopic}`];
    return `“${answer || "I can't help you there."}”`;
  }

  _confront(a) {
    const match = a.match(/^show (.+) to (.+)$/); const [, evidence, person] = match;
    this.state.shown[`${evidence}:${person}`] = true;
    const privateMode = this.state.interviewee === person;
    const lines = {
      "LoBlo:Dunbar": "They're my pills. You must have taken them from my bathroom. Well, what am I supposed to say?",
      "porcelain fragment:Dunbar": "He didn't commit suicide, then? But LoBlo, that's a pill I take for my blood pressure. I can tell what you're thinking, but I didn't, couldn't have done it. Why should I? Someone must have taken them, maybe George. He knew I used them.",
      "porcelain fragment:Baxter": "This is quite peculiar. It appears that Marshall was murdered. I wonder...I would have a word with George if I were you, Inspector.",
      "Focus papers:Baxter": `I'm afraid I haven't been entirely candid with you. There was some trouble a few years ago with Focus Corp. because of some, let us say, irresponsible dealings on my part. Marshall agreed to cover up my involvement to save the company any bad publicity.${this.state.clues.notepad_read ? " I can't understand why he would be insisting that I do this or that, though, as it says on that note you showed me. He must have changed his mind, since I never received the note." : ""}`,
      "new will:George": "You should know what it says.",
      "letter:Mrs. Robner": "You have certainly stooped to a new low, Inspector. Opening people's mail. I think there are laws against that, but I guess you wouldn't know. In any case, what of it? It's from a friend of mine, an old friend from school. We get together now and then to discuss old times. I don't suppose there is a law against that?",
    };
    const response = lines[`${evidence}:${person}`] || "I can't help you there.";
    return `${privateMode ? "In private, " : "In front of the group, "}“${response}”`;
  }

  _finish(reason, message, score, title = null) {
    this.state.terminal = { status: "terminal", reason, title: title || reason.replaceAll("_", " "), message, score,
      accusations: [...this.state.accusations],
      successfulActions: this.state.successfulActions, submittedCalls: this.state.submittedCalls };
  }
}
