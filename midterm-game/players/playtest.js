import readline from "node:readline/promises";
import { stdin as input, stdout as output } from "node:process";
import { DeadlineGame } from "../src/engine.js";

const rl = readline.createInterface({ input, output });
const game = new DeadlineGame();
game.reset(Number(process.argv[2] || 1));
console.log("Robner Case playtest console. Choose by number; action words mirror the game UI.\n");
while (game.outcome().status === "ongoing" || game.outcome().status === "choice") {
  const observation = game.observe("detective");
  const actions = game.legal_actions("detective");
  console.log(`\n[${observation.room}] ${observation.roomText}`);
  console.log(`Evidence: ${observation.evidence.join(", ") || "none"} | Actions: ${observation.successfulActions}/${observation.actionLimit}`);
  actions.forEach((action, i) => console.log(`${String(i + 1).padStart(2, " ")}. ${action}`));
  const answer = await rl.question("\nAction number (or exact action): ");
  const index = Number(answer);
  const action = Number.isInteger(index) && index > 0 && index <= actions.length ? actions[index - 1] : answer;
  const result = game.step("detective", action);
  console.log(result.message);
}
console.log("\nOutcome:", game.outcome());
rl.close();
