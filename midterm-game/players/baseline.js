const hasAction = (history, action) => history.some((entry) => entry.action === action);

// Evidence-first policy with a fixed, inspectable priority order. It uses only
// the same player observation and legal-action list available to the model.
export function chooseBaselineAction(observation, legalActions) {
  const legal = new Set(legalActions);
  const done = (action) => hasAction(observation.history, action);
  const choose = (...actions) => actions.find((action) => legal.has(action));
  const room = observation.room;
  const clues = new Set(observation.clues);
  const evidence = new Set(observation.evidence);

  if (observation.interviewee) {
    const person = observation.interviewee;
    const topic = person === "Baxter" || person === "Dunbar" ? "concert" : null;
    if (topic && !done(`ask ${person} about ${topic}`)) return choose(`ask ${person} about ${topic}`);
    if (person === "Dunbar" && !evidence.has("LoBlo")) return choose("search Dunbar");
    return choose(`return ${person} to living room`);
  }

  if (!clues.has("concert_contradiction")) {
    const person = done("interview Baxter privately") && done("ask Baxter about concert") ? "Dunbar" : "Baxter";
    if (room !== "living room") return choose("go to living room");
    if (!done(`interview ${person} privately`)) return choose(`interview ${person} privately`);
    if (!done(`ask ${person} about concert`)) return choose(`interview ${person} privately`);
  }
  if (!evidence.has("LoBlo")) {
    if (room !== "living room") return choose("go to living room");
    if (!done("interview Dunbar privately")) return choose("interview Dunbar privately");
  }

  if (!clues.has("baxter_motive")) {
    if (room !== "library") return choose("go to library");
    if (!clues.has("notepad_inspected")) return choose("inspect notepad");
    return choose("shade notepad with pencil");
  }
  if (!clues.has("china_counted")) {
    if (room !== "kitchen") return choose("go to kitchen");
    return choose("count china");
  }
  if (!clues.has("ladder_holes")) {
    if (room !== "garden") return choose("go to garden");
    return choose("inspect holes");
  }
  if (!clues.has("poison_confirmed")) {
    if (room !== "garden") return choose("go to garden");
    if (!evidence.has("fragment")) return choose("search holes");
    if (!clues.has("fragment_cleaned")) return choose("clean fragment");
    if (!clues.has("fragment_analyzed")) return choose("analyze fragment");
    return choose("compare fragment with LoBlo");
  }
  return choose("accuse Baxter and Dunbar");
}
