import readline from "node:readline/promises";
import { stdin as input, stdout as output } from "node:process";
import { DeadlineGame } from "../src/engine.js";

const rl = readline.createInterface({ input, output });
const game = new DeadlineGame();
game.reset(Number(process.argv[2] || 1));
console.log("Robner Case playtest. Enter an action based on what you observe. The case engine will respond to each attempt.\n");
let lastMessage = "";
while (game.outcome().status === "ongoing" || game.outcome().status === "choice") {
  const observation = game.observe("detective");
  console.log(`\n[${observation.room}] ${observation.roomText}`);
  console.log(`Evidence: ${observation.evidence.join(", ") || "none"} | Actions: ${observation.successfulActions}/${observation.actionLimit}`);
  if (lastMessage) console.log(`\nLatest response: ${lastMessage}`);
  const action = await rl.question("\nWhat do you try? ");
  const result = game.step("detective", action);
  lastMessage = result.message;
  console.log(`\n${result.valid ? "The action succeeds." : "The action is refused."} ${result.message}`);
}
console.log("\nOutcome:", game.outcome());
rl.close();
