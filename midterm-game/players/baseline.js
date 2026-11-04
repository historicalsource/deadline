const hasAction = (observation, action) => observation.history.some((entry) => entry.action === action);

// A deterministic evidence-first investigator. It infers its next command from
// visible facts and prior responses; the engine is the only legality oracle.
export function chooseBaselineAction(observation) {
  if (observation.choices?.length) return observation.choices.find(({ action }) => action === "close the case")?.action || observation.choices[0].action;
  const done = (action) => hasAction(observation, action);
  const room = observation.room;
  const evidence = new Set(observation.evidence);

  if (observation.interviewee) {
    const person = observation.interviewee;
    if ((person === "Baxter" || person === "Dunbar") && !done(`ask ${person} about concert`)) return `ask ${person} about concert`;
    if (person === "Dunbar" && !evidence.has("LoBlo")) return "search Dunbar";
    return `return ${person}`;
  }

  if (!done("ask Baxter about concert") || !done("ask Dunbar about concert")) {
    const person = done("ask Baxter about concert") ? "Dunbar" : "Baxter";
    if (room !== "living room") return "go to living room";
    if (!done(`interview privately ${person}`)) return `interview privately ${person}`;
    return `interview privately ${person}`;
  }
  if (!evidence.has("LoBlo")) {
    if (room !== "living room") return "go to living room";
    return "interview privately Dunbar";
  }

  if (!done("shade notepad")) {
    if (room !== "library") return "go to library";
    if (!done("inspect notepad")) return "inspect notepad";
    return "shade notepad";
  }
  if (!done("read Focus papers")) {
    if (room !== "library") return "go to library";
    if (!done("inspect bookcase")) return "inspect bookcase";
    if (!done("search bookcase")) return "search bookcase";
    if (!done("open safe")) return "open safe";
    return "read Focus papers";
  }
  if (!done("count china")) return room === "kitchen" ? "count china" : "go to kitchen";
  if (!done("inspect holes")) return room === "garden" ? "inspect holes" : "go to garden";
  if (!done("compare new chemical with LoBlo")) {
    if (room !== "garden") return "go to garden";
    if (!evidence.has("porcelain fragment")) return "search holes";
    if (!done("clean fragment")) return "clean fragment";
    if (!done("analyze fragment")) return "analyze fragment";
    return "compare new chemical with LoBlo";
  }
  if (room !== "living room") return "go to living room";
  return "accuse Baxter and Dunbar";
}
