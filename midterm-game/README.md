# The Robner Case

A short, text-based investigation of Marshall Robner's death. This quick start
is for classmates who want to install the project and play the game themselves.

## Quick start: play the game yourself

Requires Node.js 20 or newer and npm. From the repository root, run:

```sh
cd deadline/midterm-game
npm ci
npm run dev
```

Open the local address Vite prints, usually <http://127.0.0.1:5173/>. Click
**Begin the investigation** after the introduction. On each turn, choose an
available action word, fill in the rest of the command using the scene and
clues, then press **Try this action**. The game does not show a list of valid
targets or complete commands: guessing is part of the investigation. If a
command is invalid, read the response and try another; it will not advance the
case. Use the notes on the right to review suspects, rooms, and evidence.

After accusing someone, choose **Close the case** to see the result or
**Continue investigating** to keep playing. **Restart** begins a new case.
**TRUTH** reveals the full solution and contains spoilers.

This is a manual playtest: play through the browser at your own pace and try
actions based on the story and clues. You do not need to run a script or set up
a model API. For feedback, note what you tried, what happened, and anything
that was unclear; keep those notes separate from automated test results.
The automated-player instructions below are for optional project evaluation;
they are not part of the manual playtest.

## Inspect and test the engine

While `npm run dev` is running, open
[`http://127.0.0.1:5173/test`](http://127.0.0.1:5173/test). The local Engine
Inspector can jump to named checkpoints, show the complete current engine
state alongside the player observation, list and submit every currently legal
command, accept arbitrary command guesses, and display the resulting feedback,
history, and terminal outcome. Presets include the major evidence stages,
the accusation outcomes, the baseline's complete solution, and an action-limit
episode. It does not enumerate every combinatorial state; load a checkpoint
and continue testing from there. This developer page exposes hidden state and
full legal actions, so it is for local inspection only, not part of player
observations or the game interface.

## Engine and commands

`src/engine.js` exports `DeadlineGame` with the machine interface:

```js
game.reset(seed)
game.observe("detective")
game.legal_actions("detective")
game.step("detective", action)
game.outcome()
```

The engine owns the case state and validates every action. `legal_actions()`
is available for engine-level rule checks and deterministic tests; it is not
provided to a human or machine player. The observation's `actionWords` field
contains available command heads only. Invalid actions do
not consume a successful action or change evidence/location; submitted calls
still count toward the separate call cap. The investigation ends after 50
successful actions. The player runner allows at most 60 model calls by default
and 60 seconds for each request; set `MAX_MODEL_CALLS` or `MODEL_TIMEOUT_MS`
to change those runner limits. The story's 50-action limit is fixed.

The game starts in the Living Room. Movement, investigation, conversation,
evidence handling, and conclusions are available where the story permits.
The exact target vocabulary and context rules remain authoritative in the
engine and project action specification, but player interfaces do not
enumerate currently valid command combinations. Private suspect searches occur
only in a private interview. Public searches are refused. Analyzed
Garden-fragment evidence must be compared with LoBlo. A strong joint
conclusion also requires Dunbar's LoBlo, both private alibi/concert accounts, a
shaded notepad, and reading the Focus papers. The Garden-hole inspection and
Kitchen count are optional observations, not outcome prerequisites.
Private interviews do not move the detective to a named room; the engine marks
the interview as a separate scene and returns to the prior room when it ends.
Unresolved story notices are included in `observation.pendingMessages` and
remain visible until their related action is completed; the delivered-letter
notice clears when `read letter` is used.

## Play and evaluate the players

Run the deterministic evidence-first baseline and save a JSON trace under
`traces/`:

```sh
npm run play:baseline -- --seed 11
```

Run the model player with an OpenAI API key and a model name supported by your
account:

```sh
OPENAI_API_KEY=... OPENAI_MODEL=... npm run play:model -- --seed 11
```

The model receives only its player observation (including currently available
action words but no targets or complete commands) and the response to its
previous attempt. It has no legal-action list, filesystem, shell, engine-state,
evaluator, or answer-key interface. It must infer the rest of one action
string; the engine validates the submitted action. Provider failures and
timeouts are recorded as terminal reasons, not silently replaced with a move.

The same adapter supports Anthropic and Gemini; choose provider/model/key
through these environment variables and the direct runner command:

```sh
ANTHROPIC_API_KEY=... ANTHROPIC_MODEL=... node players/run.js --provider anthropic --seed 11
GEMINI_API_KEY=... GEMINI_MODEL=... node players/run.js --provider gemini --seed 11
```

`OPENAI_BASE_URL`, `ANTHROPIC_BASE_URL`, and `GEMINI_BASE_URL` can point to
compatible API endpoints. Provider endpoint formats are documented in the
[OpenAI Responses API](https://developers.openai.com/api/reference/resources/responses/methods/create),
[Anthropic Messages API](https://platform.claude.com/docs/en/api/messages), and
[Gemini Interactions API](https://ai.google.dev/api/interactions-api).
API keys are read from the environment and are not stored in this project.

## Tests and CI

```sh
npm test
npm run build
```

The course workflow is [`../.github/workflows/setup-check.yml`](../.github/workflows/setup-check.yml).
It runs `npm ci`, the deterministic tests, and the production build on pushes
and pull requests. Check recent GitHub workflow runs from the `deadline/`
repository root with:

```sh
gh run list --workflow setup-check.yml --limit 5
```

Local tests do not make a live model API request. A workflow run is only
reported as green after GitHub provides that evidence.

## Scope and source map

Included: one case, four suspects (Baxter, Dunbar, George, Mrs. Robner), four
rooms (Living Room, Library, Kitchen, Garden), a supervised group, voluntary
private interviews, the evidence chain, optional hidden safe, five distinct
accusation paths, the incomplete Dunbar-case epilogue, and the
evidence-dependent joint accusation.

Excluded: the larger cast and timeline, real-time movement, formal arrests,
ticket-stub evidence, parser synonyms, the combination puzzle, separate
closet, and interactive simulation of the post-case murder. These cuts keep
the case finishable while preserving the approved clue logic.

| Rule group | Label | Evidence and locator |
| --- | --- | --- |
| Four suspects, four rooms, opening situation, patrol supervision | `design` | [Story plan: bounded cast and room model](../MIDTERM_STORY_RECONSTRUCTION_PLAN.md#bounded-cast-and-room-model); [action dictionary: state and movement](../ACTION_DICTIONARY_AND_RULES.md#state-and-movement) |
| Legal actions, contexts, entry-two letter, search and interview behavior | `design` | [Action dictionary: command forms and room actions](../ACTION_DICTIONARY_AND_RULES.md#command-forms); [suspect questions and interviews](../ACTION_DICTIONARY_AND_RULES.md#suspect-questions-and-interviews) |
| Evidence dependencies and lab results | `design` | [Action dictionary: Library, Kitchen, and Garden actions](../ACTION_DICTIONARY_AND_RULES.md#room-specific-object-actions) |
| Five accusation paths, close/continue choice after each accusation, and truth window | `design` | [Action dictionary: accusation outcomes](../ACTION_DICTIONARY_AND_RULES.md#accusation-outcomes); [story plan: accusation case reports and truth window](../MIDTERM_STORY_RECONSTRUCTION_PLAN.md#accusation-case-reports-and-truth-window) |
| 50 successful-action episode, 60-call and 60-second runner defaults | `design` | [AGENTS.md settled implementation defaults](../AGENTS.md#design-specifications-and-their-purposes); enforced in `src/engine.js` and `players/run.js` |
| Role-scoped observation and model action boundary | `design` | [AGENTS.md source and implementation constraints](../AGENTS.md#how-to-work); exposed fields are in `src/engine.js`, inputs in `players/model-player.js` |
| Browser presentation and action ordering | `design` | This implementation's text-first responsive interface in `src/main.js` and `src/style.css` |
| Fixed-priority baseline policy | `design` | [EVALUATION.md](EVALUATION.md#baseline-and-comparison); `players/baseline.js` |

### Credit and reuse terms

The game is an original implementation. The historical source collection
identifies *Deadline* as a 1982 Infocom game written by Marc Blank and says
the contributed source collection is not under an open license ([collection
README](../README.md), “What is this Repository?” and “Purpose”). The student
confirmed publication permission for source dialogue used in this course
adaptation. This project does not copy source code, compiled files, or assets.
See the [story evidence notes](../STORY_AND_SUSPECT_EVIDENCE.md) and [bounded
route audit](SOURCE_FLOW_AUDIT.md) for source locations and intentional
differences.

The approved story/action specifications are the authority for this bounded
adaptation. Rule-map entries use `design` because they are selected or adapted
rules, not claims that this implementation reproduces upstream code.
