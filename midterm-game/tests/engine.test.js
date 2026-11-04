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
  assert.ok(Array.isArray(observation.actionGuide));
  assert.ok(observation.actionGuide.some(({ action, description }) => action === "search" && /private interview/.test(description) && !/public searches are refused/i.test(description)));
  assert.equal(observation.actionGuide.find(({ action }) => action === "ask").template, "ask [person] about [topic]");
  for (const obviousAction of ["read", "open", "count", "clean"]) assert.equal(observation.actionGuide.some(({ action }) => action === obviousAction), false);
  assert.ok(observation.actionGuide.some(({ action }) => action === "compare"));
  assert.equal(observation.actionGuide.find(({ action }) => action === "compare").template, "compare [A] with [B]");
  assert.ok(observation.actionGuide.every(({ description }) => !/Baxter|Dunbar|killed|murder|guilty|culprit/i.test(description)));
  assert.deepEqual(observation.evidence, []);
  assert.ok(observation.actionWords.includes("go to"));
  assert.ok(observation.actionWords.includes("inspect"));
  assert.equal(observation.actionWords.includes("go to library"), false);
  assert.equal(JSON.stringify(observation).includes('"go to library"'), false);
  assert.equal("culprit" in observation, false);
  assert.equal("state" in observation, false);
  assert.equal("clues" in observation, false);
  const legal = game.legal_actions("detective");
  assert.ok(legal.includes("go to library"));
  assert.ok(legal.includes("ask Baxter about alibi"));
  assert.ok(legal.includes("accuse Baxter"));
  assert.ok(legal.includes("accuse Baxter and Dunbar"));
  assert.ok(observation.actionWords.includes("accuse"));
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

test("accuse is always available for suspects who are present", () => {
  const livingRoom = new DeadlineGame();
  assert.equal(livingRoom.observe("detective").actionWords.includes("accuse"), true);
  assert.equal(livingRoom.step("detective", "accuse George").valid, true);
  assert.equal(livingRoom.outcome().status, "choice");
  assert.deepEqual(livingRoom.observe("detective").choices, [
    { label: "Close the case", action: "close the case" },
    { label: "Continue investigating", action: "continue investigating" },
  ]);
  assert.equal(livingRoom.step("detective", "close the case").valid, true);
  assert.equal(livingRoom.outcome().reason, "false_accusation_suicide");

  const library = new DeadlineGame();
  assert.equal(library.step("detective", "go to library").valid, true);
  assert.equal(library.observe("detective").actionWords.includes("accuse"), false);
  assert.equal(library.step("detective", "accuse Baxter").valid, false);

  const evidenceButNoSuspect = new DeadlineGame();
  for (const action of ["interview privately Dunbar", "search Dunbar", "return Dunbar", "go to garden", "search holes", "clean fragment", "analyze fragment", "compare new chemical with LoBlo", "go to library"]) {
    assert.equal(evidenceButNoSuspect.step("detective", action).valid, true, action);
  }
  assert.equal(evidenceButNoSuspect.observe("detective").actionWords.includes("accuse"), false);
  assert.equal(evidenceButNoSuspect.step("detective", "accuse Baxter").valid, false);

  const privateInterview = new DeadlineGame();
  assert.equal(privateInterview.step("detective", "interview privately Dunbar").valid, true);
  assert.equal(privateInterview.observe("detective").actionWords.includes("accuse"), true);
  assert.equal(privateInterview.step("detective", "accuse Baxter").valid, false);
  assert.equal(privateInterview.step("detective", "accuse Dunbar").valid, true);
});

test("the letter is readable only after the second Living Room entry", () => {
  const game = new DeadlineGame();
  assert.equal(game.legal_actions("detective").includes("read letter"), false);
  game.step("detective", "go to library");
  const arrival = game.step("detective", "go to living room");
  assert.match(arrival.message, /You enter the living room/i);
  assert.equal(arrival.observation.pendingMessages[0].id, "letter-arrived");
  assert.match(arrival.observation.pendingMessages[0].message, /officer tells you a letter arrived while you were away/i);
  assert.match(arrival.observation.pendingMessages[0].message, /left it on the table for you/i);
  assert.equal(game.legal_actions("detective").includes("read letter"), true);
  game.step("detective", "go to library");
  const laterArrival = game.step("detective", "go to living room");
  assert.doesNotMatch(laterArrival.message, /letter arrived|delivered letter/i);
  assert.equal(laterArrival.observation.pendingMessages.length, 1);
  const envelope = game.step("detective", "inspect letter").message;
  assert.match(envelope, /Mrs. Marshall Robner/);
  assert.doesNotMatch(envelope, /Steven/);
  const letter = game.step("detective", "read letter").message;
  assert.equal(game.observe("detective").pendingMessages.length, 0);
  assert.match(letter, /“Dear Leslie,/);
  assert.match(letter, /His despondency is tied to his business/);
  assert.match(letter, /George has made his threats again/);
  assert.match(letter, /how much I love you and the life we hope to share/);
  assert.match(letter, /Love,\nSteven”/);
  assert.doesNotMatch(letter, /Baxter/i);
  assert.doesNotMatch(game.step("detective", "ask Mrs. Robner about Steven").message, /lovers|planned to marry/);
});

test("private-interview return does not count as leaving and re-entering the Living Room", () => {
  const game = new DeadlineGame();
  assert.equal(game.step("detective", "interview privately Baxter").valid, true);
  const returned = game.step("detective", "return Baxter");
  assert.match(returned.message, /private interview with Baxter ends/i);
  assert.doesNotMatch(returned.message, /letter arrived/i);
  assert.equal(returned.observation.letterDelivered, false);
  assert.deepEqual(returned.observation.pendingMessages, []);
  assert.equal(game.legal_actions("detective").includes("read letter"), false);

  assert.equal(game.step("detective", "go to library").valid, true);
  const arrival = game.step("detective", "go to living room");
  assert.equal(arrival.observation.letterDelivered, true);
  assert.equal(arrival.observation.pendingMessages[0].id, "letter-arrived");

  assert.equal(game.step("detective", "interview privately Baxter").valid, true);
  const returnedWithNotice = game.step("detective", "return Baxter");
  assert.match(returnedWithNotice.message, /private interview with Baxter ends/i);
  assert.equal(returnedWithNotice.observation.pendingMessages.length, 1);
  assert.equal(returnedWithNotice.observation.pendingMessages[0].id, "letter-arrived");

  const otherResponse = game.step("detective", "inspect George");
  assert.equal(otherResponse.valid, true);
  assert.match(otherResponse.message, /pacing around the room/i);
  assert.equal(otherResponse.observation.pendingMessages.length, 1);

  assert.equal(game.step("detective", "inspect letter").valid, true);
  assert.equal(game.observe("detective").pendingMessages.length, 1);
  assert.equal(game.step("detective", "read letter").valid, true);
  assert.equal(game.observe("detective").pendingMessages.length, 0);
});

test("opening the safe reveals the documents without summarizing their contents", () => {
  const game = new DeadlineGame();
  for (const action of ["go to library", "inspect bookcase", "search bookcase"]) {
    assert.equal(game.step("detective", action).valid, true, action);
  }
  const opened = game.step("detective", "open safe");
  assert.equal(opened.valid, true);
  assert.match(opened.message, /two documents: a packet of papers and a new will/i);
  assert.doesNotMatch(opened.message, /Baxter|Focus|George|inherit|estate|disinherit|embezzl/i);
  assert.ok(opened.observation.evidence.includes("Focus papers"));
  assert.ok(opened.observation.evidence.includes("new will"));
  assert.equal(game.step("detective", "read Focus papers").valid, true);
  assert.match(game.observe("detective").history.at(-1).message, /funds Baxter embezzled/i);
  assert.equal(game.step("detective", "read new will").valid, true);
  assert.match(game.observe("detective").history.at(-1).message, /disinherits George/i);
});

test("representative invalid prerequisites leave investigation state unchanged", () => {
  const cases = [
    { setup: ["go to library"], action: "analyze teacup" },
    { setup: ["go to garden", "search holes"], action: "analyze fragment" },
    { setup: ["go to library"], action: "shade notepad" },
    { setup: ["go to library", "inspect bookcase"], action: "open safe" },
    { setup: ["go to library"], action: "interview privately George" },
    { setup: ["interview privately Dunbar"], action: "return Baxter" },
    { setup: ["interview privately Baxter"], action: "ask Dunbar about LoBlo" },
    { setup: ["go to library"], action: "inspect holes" },
  ];
  for (const { setup, action } of cases) {
    const game = new DeadlineGame();
    for (const setupAction of setup) assert.equal(game.step("detective", setupAction).valid, true, setupAction);
    const before = game.observe("detective");
    const invalid = game.step("detective", action);
    assert.equal(invalid.valid, false, action);
    const after = invalid.observation;
    for (const key of ["room", "interviewee", "letterDelivered", "pendingMessages", "evidence", "accusations", "successfulActions", "history"]) {
      assert.deepEqual(after[key], before[key], `${action} changed ${key}`);
    }
  }
});

test("Ebullion inspection reports source-supported label details", () => {
  const game = new DeadlineGame();
  game.step("detective", "go to library");
  const result = game.step("detective", "inspect Ebullion");
  assert.equal(result.valid, true);
  assert.match(result.message, /25 mg/);
  assert.match(result.message, /depression/);
  assert.match(result.message, /one or two twice daily/);
  assert.match(result.message, /harmful or fatal/);
  assert.doesNotMatch(result.message, /27 mg%|therapeutic range|fatal levels/i);
  assert.doesNotMatch(result.message, /alone|does not show|does not establish/i);
});

test("Library descriptions name the teacup, saucer, bookcase, and notepad consistently", () => {
  const game = new DeadlineGame();
  game.step("detective", "go to library");
  const roomText = game.observe("detective").roomText;
  assert.match(roomText, /teacup and a saucer/);
  assert.match(roomText, /bookcase/);
  assert.match(game.step("detective", "inspect desk").message, /blank-looking notepad/);
  assert.equal(game.step("detective", "inspect notepad").valid, true);
  assert.ok(game.legal_actions("detective").includes("shade notepad"));
  assert.ok(!game.legal_actions("detective").includes("shade notepad with pencil"));
  assert.equal(game.step("detective", "shade notepad with pencil").valid, false);
  assert.equal(game.step("detective", "shade notepad").valid, true);
});

test("Kitchen describes the household china and its pieces without action instructions", () => {
  const game = new DeadlineGame();
  game.step("detective", "go to kitchen");
  const scene = game.observe("detective").roomText;
  assert.match(scene, /hand-painted china/);
  assert.match(scene, /plates, teacups, and saucers/);
  assert.doesNotMatch(scene, /inspect/i);
  assert.equal(game.step("detective", "inspect china").valid, true);
  assert.match(game.observe("detective").history.at(-1).message, /Greek mythology/);
});

test("Garden introduction keeps the roses and describes the holes plainly", () => {
  const game = new DeadlineGame();
  game.step("detective", "go to garden");
  const scene = game.observe("detective").roomText;
  assert.match(scene, /yellow, red, pink, and white roses/);
  assert.match(scene, /holes in the soft earth near your feet/i);
  assert.match(scene, /wooden ladder rests beside the rose beds/i);
  assert.doesNotMatch(scene, /inspect|search/i);
  assert.equal(game.legal_actions("detective").includes("inspect holes"), true);
  assert.equal(game.legal_actions("detective").includes("search holes"), true);
  const ladder = game.step("detective", "inspect ladder");
  assert.equal(ladder.valid, true);
  assert.match(ladder.message, /fifteen feet long/);
  assert.match(ladder.message, /dirt and dried mud/);
  assert.match(ladder.message, /seem to fit the holes/);
  assert.equal(game.step("detective", "put ladder in holes").valid, false);
});

test("porcelain and fragment are interchangeable Garden action targets", () => {
  const game = new DeadlineGame();
  for (const action of ["go to garden", "search holes"]) assert.equal(game.step("detective", action).valid, true, action);
  assert.equal(game.step("detective", "inspect porcelain").valid, true);
  assert.equal(game.step("detective", "clean porcelain").valid, true);
  assert.equal(game.observe("detective").evidence.includes("new chemical"), false);
  const analysis = game.step("detective", "analyze porcelain");
  assert.equal(analysis.valid, true);
  assert.ok(game.observe("detective").evidence.includes("porcelain fragment"));
  assert.ok(analysis.observation.evidence.includes("new chemical"));
  assert.equal(game.step("detective", "compare new chemical with LoBlo").valid, false);
  for (const action of ["go to living room", "interview privately Dunbar", "search Dunbar"]) {
    assert.equal(game.step("detective", action).valid, true, action);
  }
  assert.equal(game.observe("detective").room, "private interview");
  assert.doesNotMatch(game.observe("detective").roomText, /Library|Living Room/);
  assert.equal(game.observe("detective").actionWords.includes("accuse"), true);
  assert.ok(game.legal_actions("detective").includes("accuse Dunbar"));
  assert.equal(game.legal_actions("detective").includes("accuse Baxter"), false);
  assert.equal(game.observe("detective").history.at(-1).room, "private interview");
  const comparison = game.step("detective", "compare new chemical with LoBlo");
  assert.equal(comparison.valid, true);
  assert.match(comparison.message, /Methsparin/);
  assert.equal(comparison.observation.room, "private interview");
  assert.equal(game.step("detective", "compare LoBlo with new chemical").valid, true);
  for (const action of ["return Dunbar", "interview privately Baxter"]) assert.equal(game.step("detective", action).valid, true, action);
  assert.equal(game.step("detective", "show Baxter fragment").valid, true);
});

test("medicine-first findings remain available for comparison when the Garden chemical is found", () => {
  const game = new DeadlineGame();
  for (const action of ["interview privately Dunbar", "search Dunbar", "return Dunbar", "interview privately Mrs. Robner", "search Mrs. Robner"]) {
    assert.equal(game.step("detective", action).valid, true, action);
  }
  const medicineEvidence = game.observe("detective").evidence;
  assert.ok(medicineEvidence.includes("LoBlo"));
  assert.ok(medicineEvidence.includes("Allergone"));
  assert.equal(medicineEvidence.includes("Sneezo"), false);
  assert.equal(game.step("detective", "return Mrs. Robner").valid, true);
  for (const action of ["go to garden", "search holes", "clean porcelain", "analyze porcelain"]) {
    assert.equal(game.step("detective", action).valid, true, action);
  }
  assert.ok(game.observe("detective").evidence.includes("new chemical"));
  for (const action of ["compare LoBlo with new chemical", "compare new chemical with Allergone"]) {
    assert.equal(game.step("detective", action).valid, true, action);
  }
  assert.equal(game.step("detective", "compare Allergone with new chemical").valid, true);
  assert.equal(game.step("detective", "compare new chemical with Sneezo").valid, false);
});

test("read papers and read Focus papers produce the same evidence", () => {
  const game = new DeadlineGame();
  assert.equal(game.step("detective", "read papers").valid, false);
  for (const action of ["go to library", "inspect notepad", "shade notepad", "inspect bookcase", "search bookcase", "open safe"]) {
    assert.equal(game.step("detective", action).valid, true, action);
  }
  assert.ok(game.legal_actions("detective").includes("read papers"));
  assert.ok(game.legal_actions("detective").includes("read Focus papers"));
  const result = game.step("detective", "read papers");
  assert.match(result.message, /Focus Corporation was a subsidiary of Robner Corp\./);
  assert.match(result.message, /funds Baxter embezzled from Focus/);
  assert.match(result.message, /scandal was hushed up/);
  assert.match(result.message, /Robner's records describe how the matter was handled/);
  const otherGame = new DeadlineGame();
  for (const action of ["go to library", "inspect notepad", "shade notepad", "inspect bookcase", "search bookcase", "open safe"]) otherGame.step("detective", action);
  const alias = otherGame.step("detective", "read Focus papers");
  assert.equal(alias.message, result.message);
  assert.ok(alias.observation.evidence.includes("Focus papers"));
});

test("Focus papers can be shown to Baxter during his private interview", () => {
  const game = new DeadlineGame();
  for (const action of ["go to library", "inspect bookcase", "search bookcase", "open safe", "go to living room", "interview privately Baxter"]) {
    assert.equal(game.step("detective", action).valid, true, action);
  }
  assert.ok(game.legal_actions("detective").includes("show Baxter Focus papers"));
  const result = game.step("detective", "show Baxter Focus papers");
  assert.equal(result.valid, true);
  assert.match(result.message, /In private/);
  assert.match(result.message, /trouble a few years ago with Focus Corp/);
  const shorthand = game.step("detective", "show Baxter papers");
  assert.equal(shorthand.valid, true);
  assert.match(shorthand.message, /In private/);
});

test("Baxter accepts Focus papers as an ask topic, and action phrase forms are consistent", () => {
  const game = new DeadlineGame();
  for (const action of ["go to library", "inspect bookcase", "search bookcase", "open safe", "read Focus papers", "go to living room"]) {
    assert.equal(game.step("detective", action).valid, true, action);
  }
  assert.ok(game.observe("detective").actionWords.includes("interview privately"));
  assert.ok(game.legal_actions("detective").includes("interview privately Baxter"));
  assert.equal(game.step("detective", "interview privately Baxter").valid, true);
  const question = "ask Baxter about Focus papers";
  assert.ok(game.legal_actions("detective").includes(question));
  const answer = game.step("detective", question);
  assert.equal(answer.valid, true);
  assert.match(answer.message, /Focus Corporation has been a subsidiary of Robner Corp\./);
  assert.ok(game.legal_actions("detective").includes("return Baxter"));
  assert.equal(game.step("detective", "return Baxter").valid, true);
});

test("bookcase and safe can be discovered without shading the notepad", () => {
  const game = new DeadlineGame();
  game.step("detective", "go to library");
  const inspection = game.step("detective", "inspect bookcase");
  assert.match(inspection.message, /section is slightly out of line/);
  assert.equal(game.step("detective", "search bookcase").valid, true);
  assert.equal(game.step("detective", "open safe").valid, true);
  assert.equal(game.observe("detective").evidence.includes("Focus papers"), true);
  assert.equal("clues" in game.observe("detective"), false);
});

test("bounded clue descriptions report source observations without naming their inference", () => {
  const game = new DeadlineGame();
  for (const action of ["go to kitchen", "inspect china", "count china", "search china", "go to garden", "inspect holes", "search holes", "inspect fragment", "clean fragment"]) {
    assert.equal(game.step("detective", action).valid, true, action);
  }
  assert.match(game.observe("detective").history.findLast((entry) => entry.action === "count china").message, /eight large and small plates, seven saucers, and six cups/i);
  assert.doesNotMatch(game.observe("detective").history.findLast((entry) => entry.action === "count china").message, /missing|switch/i);
  assert.match(game.observe("detective").history.findLast((entry) => entry.action === "search china").message, /six hand-painted cups and seven hand-painted saucers/i);
  const holes = game.observe("detective").history.findLast((entry) => entry.action === "inspect holes").message;
  assert.match(holes, /two holes/);
  assert.doesNotMatch(holes, /ladder|crushed flowers/i);
  const clean = game.observe("detective").history.findLast((entry) => entry.action === "clean fragment").message;
  assert.match(clean, /markings match the china you examined in the Kitchen/i);
  assert.doesNotMatch(clean, /tea|sugar|chemical|LoBlo/i);
});

test("the sugar bowl is not an interactive evidence action in either room", () => {
  const game = new DeadlineGame();
  assert.equal(game.legal_actions("detective").includes("inspect sugar bowl"), false);
  assert.equal(game.legal_actions("detective").includes("analyze sugar bowl"), false);
  game.step("detective", "go to library");
  assert.equal(game.legal_actions("detective").includes("inspect sugar bowl"), false);
  assert.equal(game.legal_actions("detective").includes("analyze sugar bowl"), false);
  assert.equal(game.step("detective", "inspect sugar bowl").valid, false);
  game.step("detective", "go to kitchen");
  assert.equal(game.legal_actions("detective").includes("inspect sugar bowl"), false);
  assert.equal(game.legal_actions("detective").includes("analyze sugar bowl"), false);
});

test("private concert accounts expose the hired-car versus ride-home mismatch", () => {
  const game = new DeadlineGame();
  game.step("detective", "interview privately Baxter");
  const baxter = game.step("detective", "ask Baxter about concert").message;
  game.step("detective", "return Baxter");
  game.step("detective", "interview privately Dunbar");
  const dunbar = game.step("detective", "ask Dunbar about concert").message;
  assert.match(baxter, /hired a car/);
  assert.doesNotMatch(baxter, /ticket stub/i);
  assert.match(dunbar, /he took me home/);
  assert.match(dunbar, /Then he took me home/);
});

test("private alibi topic reaches the same bounded source-account route as concert", () => {
  const game = new DeadlineGame();
  const actions = [
    "interview privately Baxter", "ask Baxter about alibi", "return Baxter",
    "interview privately Dunbar", "ask Dunbar about alibi", "search Dunbar", "return Dunbar",
    "go to library", "inspect notepad", "shade notepad", "inspect bookcase", "search bookcase", "open safe", "read Focus papers",
    "go to kitchen", "count china", "go to garden", "inspect holes", "search holes", "clean fragment", "analyze fragment", "compare new chemical with LoBlo", "go to living room", "accuse Baxter and Dunbar",
  ];
  for (const action of actions) assert.equal(game.step("detective", action).valid, true, action);
  assert.equal(game.outcome().status, "choice");
  assert.equal(game.step("detective", "close the case").valid, true);
  assert.equal(game.outcome().reason, "complete_solution");
});

test("interview replies distinguish quoted speech from narration and cover every public topic", () => {
  const game = new DeadlineGame({ maxActions: 100 });
  const questions = game.legal_actions("detective").filter((action) => action.startsWith("ask "));
  for (const question of questions) {
    const response = game.step("detective", question).message;
    assert.doesNotMatch(response, /offers no corroborating evidence|answers briefly/i, question);
    if (/\b(?:I|I'm|I've|we|my|me|our|Dad|Mom)\b/i.test(response)) {
      assert.match(response, /^“.*”$/s, question);
    }
  }
  game.step("detective", "interview privately George");
  const george = game.step("detective", "ask George about Baxter").message;
  assert.match(george, /^“I don't know much about him, really.*”$/);
});

test("LoBlo lab comparison explains the interaction and its medical result", () => {
  const game = new DeadlineGame();
  for (const action of ["interview privately Dunbar", "search Dunbar", "return Dunbar", "go to garden", "search holes", "clean fragment", "analyze fragment"]) {
    assert.equal(game.step("detective", action).valid, true, action);
  }
  const result = game.step("detective", "compare new chemical with LoBlo");
  assert.match(result.message, /Methsparin/);
  assert.match(result.message, /displaces Ebullion from protein binding/);
  assert.match(result.message, /death to Ebullion toxicity/);
  assert.doesNotMatch(result.message, /not who put it in the tea/i);
});

test("observed regression: public suspect search must refuse without revealing inventory", () => {
  const game = new DeadlineGame();
  const result = game.step("detective", "search Dunbar");
  assert.equal(result.valid, true);
  assert.match(result.message, /refuses|no search occurs/i);
  assert.deepEqual(result.observation.evidence, []);
  assert.equal(result.observation.successfulActions, 1);
});

test("baseline completes the evidence chain using only observations and engine validation", () => {
  const game = new DeadlineGame();
  game.reset(7);
  while (game.outcome().status === "ongoing" || game.outcome().status === "choice") {
    const observation = game.observe("detective");
    const action = chooseBaselineAction(observation);
    const result = game.step("detective", action);
    assert.equal(result.valid, true, `baseline guessed an invalid action: ${action}`);
  }
  assert.equal(game.outcome().reason, "complete_solution");
  assert.equal(game.outcome().score, 1);
  assert.ok(game.outcome().successfulActions < 50);
});

test("observed regression: Allergone comparison is legal after both discoveries", () => {
  const game = new DeadlineGame();
  assert.equal(game.step("detective", "compare new chemical with Allergone").valid, false);
  for (const action of ["go to garden", "search holes", "clean fragment", "analyze fragment", "go to living room", "interview privately Mrs. Robner", "search Mrs. Robner"]) {
    assert.equal(game.step("detective", action).valid, true, action);
  }
  const search = game.observe("detective").history.at(-1).message;
  assert.doesNotMatch(search, /safe|ordinary|not LoBlo|no match/i);
  game.step("detective", "return Mrs. Robner");
  game.step("detective", "go to garden");
  const result = game.step("detective", "compare new chemical with Allergone");
  assert.equal(result.valid, true);
  assert.match(result.message, /finds no match/);
});

test("single-suspect accusations reach their distinct case paths", () => {
  for (const [suspect, reason] of [["Baxter", "baxter_only"], ["George", "false_accusation_suicide"], ["Mrs. Robner", "false_accusation_suicide"]]) {
    const game = new DeadlineGame();
    for (const action of ["go to garden", "search holes", "clean fragment", "analyze fragment", "go to living room", "interview privately Dunbar", "search Dunbar", "return Dunbar", "go to garden", "compare new chemical with LoBlo", "go to living room", `accuse ${suspect}`]) {
      assert.equal(game.step("detective", action).valid, true, action);
    }
    assert.equal(game.outcome().status, "choice");
    assert.deepEqual(game.observe("detective").choices.map(({ action }) => action), ["close the case", "continue investigating"]);
    assert.equal(game.step("detective", "close the case").valid, true);
    assert.equal(game.outcome().reason, reason);
    assert.equal(game.step("detective", "inspect George").message, "The case is already closed.");
  }
  const dunbar = new DeadlineGame();
  for (const action of ["go to garden", "search holes", "clean fragment", "analyze fragment", "go to living room", "interview privately Dunbar", "search Dunbar", "return Dunbar", "go to garden", "compare new chemical with LoBlo", "go to living room", "accuse Dunbar", "continue investigating"]) {
    assert.equal(dunbar.step("detective", action).valid, true, action);
  }
  assert.equal(dunbar.outcome().status, "ongoing");
  assert.equal(dunbar.observe("detective").evidence.includes("LoBlo"), true);
});

test("Baxter-only closure with motive and method evidence reaches the acquittal branch", () => {
  const game = new DeadlineGame();
  const actions = [
    "go to library", "inspect notepad", "shade notepad", "inspect bookcase",
    "search bookcase", "open safe", "read Focus papers", "go to garden",
    "search holes", "clean fragment", "analyze fragment", "go to living room",
    "interview privately Dunbar", "search Dunbar", "return Dunbar", "go to garden",
    "compare new chemical with LoBlo", "go to living room", "accuse Baxter", "close the case",
  ];
  for (const action of actions) assert.equal(game.step("detective", action).valid, true, action);
  assert.equal(game.outcome().reason, "baxter_only");
  assert.match(game.outcome().message, /jury accepts that Baxter had a business motive/i);
  assert.match(game.outcome().message, /He is acquitted of Robner's murder/i);
});

test("closing a weak joint accusation produces an unproved-case outcome", () => {
  const game = new DeadlineGame();
  game.reset(2);
  for (const action of ["go to garden", "search holes", "clean fragment", "analyze fragment", "go to living room"]) {
    assert.equal(game.step("detective", action).valid, true, action);
  }
  assert.equal(game.step("detective", "interview privately Dunbar").valid, true);
  assert.equal(game.step("detective", "search Dunbar").valid, true);
  assert.equal(game.step("detective", "return Dunbar").valid, true);
  assert.equal(game.step("detective", "go to garden").valid, true);
  assert.equal(game.step("detective", "compare new chemical with LoBlo").valid, true);
  assert.equal(game.step("detective", "go to living room").valid, true);
  assert.equal(game.step("detective", "accuse Baxter and Dunbar").valid, true);
  assert.equal(game.outcome().status, "choice");
  assert.equal(game.step("detective", "close the case").valid, true);
  assert.equal(game.outcome().reason, "weak_case");
  assert.match(game.outcome().title, /not proved/i);
});

test("overinclusive accusation names both culprits, clears the extra suspect, and has its own outcome", () => {
  const game = new DeadlineGame();
  assert.equal(game.step("detective", "accuse George and Baxter and Dunbar").valid, true);
  assert.equal(game.outcome().status, "choice");
  assert.equal(game.step("detective", "close the case").valid, true);
  assert.equal(game.outcome().reason, "overinclusive_accusation");
  assert.match(game.outcome().message, /additional accusation against George is withdrawn/i);
  assert.match(game.outcome().title, /overbroad accusation/i);
  assert.equal(game.outcome().status, "terminal");
});

test("complete evidence can still convict the true pair after an extra accusation is dropped", () => {
  const game = new DeadlineGame();
  while (game.outcome().status === "ongoing" || game.outcome().status === "choice") {
    const observation = game.observe("detective");
    let action = chooseBaselineAction(observation);
    if (action === "accuse Baxter and Dunbar") action = "accuse Baxter and Dunbar and George";
    assert.equal(game.step("detective", action).valid, true, action);
  }
  assert.equal(game.outcome().reason, "overinclusive_accusation");
  assert.equal(game.outcome().score, 1);
  assert.match(game.outcome().message, /Baxter and Dunbar are convicted/i);
  assert.match(game.outcome().message, /George is cleared/i);
});

test("continue investigating preserves earlier accusations for the eventual case report", () => {
  const game = new DeadlineGame();
  assert.equal(game.step("detective", "accuse George").valid, true);
  assert.deepEqual(game.observe("detective").accusations, ["George"]);
  assert.equal(game.step("detective", "continue investigating").valid, true);
  assert.deepEqual(game.observe("detective").accusations, ["George"]);
  assert.equal(game.step("detective", "accuse Baxter and Dunbar").valid, true);
  assert.deepEqual(game.observe("detective").accusations, ["Baxter", "Dunbar", "George"]);
  assert.equal(game.step("detective", "close the case").valid, true);
  assert.equal(game.outcome().reason, "overinclusive_accusation");
  assert.deepEqual(game.outcome().accusations, ["Baxter", "Dunbar", "George"]);
});

test("opening the safe without reading Focus papers does not satisfy the strong-case requirement", () => {
  const game = new DeadlineGame();
  const actions = [
    "interview privately Baxter", "ask Baxter about concert", "return Baxter",
    "interview privately Dunbar", "ask Dunbar about concert", "search Dunbar", "return Dunbar",
    "go to library", "inspect notepad", "shade notepad", "inspect bookcase", "search bookcase", "open safe",
    "go to garden", "search holes", "clean fragment", "analyze fragment", "compare new chemical with LoBlo", "go to living room",
    "accuse Baxter and Dunbar",
  ];
  for (const action of actions) assert.equal(game.step("detective", action).valid, true, action);
  assert.equal(game.outcome().status, "choice");
  assert.equal(game.step("detective", "close the case").valid, true);
  assert.equal(game.outcome().reason, "weak_case");
  assert.match(game.outcome().message, /Focus papers were not read into evidence/);
});

test("Dunbar closure has exactly its two choices and reaches its epilogue", () => {
  const game = new DeadlineGame();
  game.reset(3);
  for (const action of ["interview privately Dunbar", "search Dunbar", "return Dunbar"]) {
    assert.equal(game.step("detective", action).valid, true, action);
  }
  const accusation = game.step("detective", "accuse Dunbar");
  assert.equal(accusation.valid, true);
  assert.equal(accusation.message, "");
  assert.equal(game.outcome().status, "choice");
  assert.match(game.outcome().message, /continue investigating/i);
  assert.equal(game.step("detective", "continue investigating").valid, true);
  assert.equal(game.step("detective", "go to garden").valid, true);
  assert.equal(game.step("detective", "search holes").valid, true);
  assert.equal(game.step("detective", "clean fragment").valid, true);
  assert.equal(game.step("detective", "analyze fragment").valid, true);
  assert.equal(game.step("detective", "compare new chemical with LoBlo").valid, true);
  assert.equal(game.step("detective", "go to living room").valid, true);
  assert.equal(game.step("detective", "accuse Dunbar").valid, true);
  assert.deepEqual(game.legal_actions("detective"), ["close the case", "continue investigating"]);
  const choiceObservation = game.observe("detective");
  assert.deepEqual(choiceObservation.actionWords, []);
  assert.deepEqual(choiceObservation.choices, [
    { label: "Close the case", action: "close the case" },
    { label: "Continue investigating", action: "continue investigating" },
  ]);
  assert.equal(chooseBaselineAction(choiceObservation), "close the case");
  const closure = game.step("detective", "close the case");
  assert.equal(closure.valid, true);
  assert.equal(closure.message, "");
  assert.equal(game.outcome().reason, "incomplete_dunbar_case");
  assert.equal(game.outcome().title, "Dunbar's case");
  assert.match(game.outcome().message, /released on bail/i);
  assert.match(game.outcome().message, /forged suicide note/i);
  assert.match(game.outcome().message, /Baxter entered through the bedroom balcony/i);
});

test("successful-action and submitted-call episode limits end explicitly", () => {
  const steps = new DeadlineGame({ maxActions: 2, maxCalls: 10 });
  steps.step("detective", "go to library");
  steps.step("detective", "inspect body");
  assert.equal(steps.outcome().reason, "episode_limit");
  assert.equal(steps.outcome().successfulActions, 2);

  const calls = new DeadlineGame({ maxActions: 50, maxCalls: 2 });
  calls.step("detective", "not an action");
  calls.step("detective", "still not an action");
  assert.equal(calls.outcome().reason, "model_call_limit");
  assert.equal(calls.outcome().successfulActions, 0);
});

test("the 50th successful action accusation ends before exposing a choice", () => {
  const game = new DeadlineGame({ maxActions: 50, maxCalls: 100 });
  for (let i = 0; i < 49; i += 1) {
    const result = game.step("detective", "ask Baxter about alibi");
    assert.equal(result.valid, true);
  }
  const accusation = game.step("detective", "accuse Baxter");
  assert.equal(accusation.valid, true);
  assert.equal(accusation.observation.successfulActions, 50);
  assert.deepEqual(accusation.observation.accusations, ["Baxter"]);
  assert.equal(accusation.outcome.reason, "episode_limit");
  assert.deepEqual(accusation.observation.choices, []);

  const simultaneousLimits = new DeadlineGame({ maxActions: 1, maxCalls: 1 });
  assert.equal(simultaneousLimits.step("detective", "accuse Baxter").outcome.reason, "episode_limit");
});

test("a final-call accusation ends instead of leaving an unusable choice", () => {
  const game = new DeadlineGame({ maxActions: 50, maxCalls: 1 });
  const accusation = game.step("detective", "accuse Dunbar");
  assert.equal(accusation.valid, true);
  assert.deepEqual(accusation.observation.accusations, ["Dunbar"]);
  assert.equal(accusation.outcome.reason, "model_call_limit");
  assert.equal(accusation.outcome.status, "terminal");
  assert.deepEqual(accusation.observation.choices, []);
  assert.deepEqual(game.legal_actions("detective"), []);
});

test("provider adapters receive observations, action words, and feedback but no command list", async () => {
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
      const observation = new DeadlineGame().reset();
      observation.choices = [
        { label: "Close the case", action: "close the case" },
        { label: "Continue investigating", action: "continue investigating" },
      ];
      const result = await chooseModelAction({
        provider, model: "example-model", apiKey: "test-key", timeoutMs: 100,
        observation, lastFeedback: { valid: false, message: "Nothing changes." },
      });
      assert.equal(result.action, "go to library");
      assert.equal(JSON.stringify(requestBody).includes("answer_key"), false);
      assert.equal(JSON.stringify(requestBody).includes("hidden_state"), false);
      assert.equal(JSON.stringify(requestBody).includes("legal_actions"), false);
      assert.equal(JSON.stringify(requestBody).includes('"go to library"'), false);
      assert.ok(JSON.stringify(requestBody).includes("go to"));
      const searchDescription = observation.actionGuide.find(({ action }) => action === "search").description;
      assert.ok(JSON.stringify(requestBody).includes(searchDescription));
      assert.ok(JSON.stringify(requestBody).includes("ask [person] about [topic]"));
      assert.ok(JSON.stringify(requestBody).includes("continue investigating"));
      assert.equal("tools" in requestBody, false);
      const submittedData = JSON.stringify(requestBody);
      assert.match(submittedData, /living room/);
      assert.match(submittedData, /Nothing changes/);
    }
  } finally { globalThis.fetch = originalFetch; }
});
