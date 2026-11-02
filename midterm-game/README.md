# The Robner Case

A short, text-based investigation of Marshall Robner's death. The adaptation
uses four suspects and four rooms, a compact evidence chain, private
interviews, and several rule-driven endings. The interface is deliberately
quiet and text-first; all actions come from the engine's legal-action list.

## Run it

Requires Node.js 20 or newer and npm.

```sh
npm install
npm run dev
```

Open the local URL printed by Vite (normally `http://127.0.0.1:5173/`). The
browser game runs the authoritative engine locally. Select an available action
to investigate; use **New investigation** to reset.

## Engine and commands

`src/engine.js` exports `DeadlineGame` with the machine interface:

```js
game.reset(seed)
game.observe("detective")
game.legal_actions("detective")
game.step("detective", action)
game.outcome()
```

The engine owns the case state and validates every action. Invalid actions do
not consume a successful action or change evidence/location; submitted calls
still count toward the separate call cap. The investigation ends after 30
successful actions. The player runner allows at most 60 model calls by default
and 60 seconds for each request; set `MAX_MODEL_CALLS` or `MODEL_TIMEOUT_MS`
to change those runner limits. The story's 30-action limit is fixed.

The game starts in the Living Room. Room movement is `go to library`, `go to
kitchen`, `go to garden`, and `go to living room`. The engine exposes the full
currently legal command list, including the specified `inspect`, `search`,
`read`, `ask`, `interview`, `return`, `show`, lab, and accusation actions.
Private suspect searches occur only in a private interview. Public searches
are refused. Analyzed Garden-fragment evidence must be compared with LoBlo;
the complete conclusion additionally requires Dunbar's possession, the two
private concert accounts, a Baxter motive clue, ladder holes, and the kitchen
china count.

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

The model receives only its player observation and legal-action strings. The
model adapter has no filesystem, shell, engine-state, evaluator, or answer-key
interface. It must return one exact action string; the engine validates the
submitted action. Provider failures and timeouts are recorded as terminal
reasons, not silently replaced with a move.

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

For human playtesting in a terminal, the playtest agent lists current legal
actions and accepts an action number or exact action:

```sh
npm run playtest
```

The browser UI is also suitable for a human playtest. Record actual notes in a
separate artifact; none are inferred from automated runs.

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
private interviews, the evidence chain, optional hidden safe, the incomplete
Dunbar-case epilogue, and the complete joint accusation.

Excluded: the larger cast and timeline, real-time movement, formal arrests,
ticket-stub evidence, parser synonyms, the combination puzzle, separate
closet, and interactive simulation of the post-case murder. These cuts keep
the case finishable while preserving the approved clue logic.

| Rule group | Label | Evidence and locator |
| --- | --- | --- |
| Four suspects, four rooms, opening situation, patrol supervision | `design` | [Story plan: bounded cast and room model](../MIDTERM_STORY_RECONSTRUCTION_PLAN.md#bounded-cast-and-room-model); [action dictionary: state and movement](../ACTION_DICTIONARY_AND_RULES.md#state-and-movement) |
| Legal actions, contexts, entry-two letter, search and interview behavior | `design` | [Action dictionary: command forms and room actions](../ACTION_DICTIONARY_AND_RULES.md#command-forms); [suspect questions and interviews](../ACTION_DICTIONARY_AND_RULES.md#suspect-questions-and-interviews) |
| Evidence dependencies and lab results | `design` | [Action dictionary: Library, Kitchen, and Garden actions](../ACTION_DICTIONARY_AND_RULES.md#room-specific-object-actions) |
| Complete/weak accusations and Dunbar choice ending | `design` | [Action dictionary: accusation outcomes](../ACTION_DICTIONARY_AND_RULES.md#accusation-outcomes); [story plan: incomplete accusation](../MIDTERM_STORY_RECONSTRUCTION_PLAN.md#incomplete-accusation-and-post-case-newspaper-ending) |
| 30 successful-action episode, 60-call and 60-second runner defaults | `design` | [AGENTS.md settled implementation defaults](../AGENTS.md#design-specifications-and-their-purposes); enforced in `src/engine.js` and `players/run.js` |
| Role-scoped observation and model action boundary | `design` | [AGENTS.md source and implementation constraints](../AGENTS.md#how-to-work); exposed fields are in `src/engine.js`, inputs in `players/model-player.js` |
| Browser presentation and action ordering | `design` | This implementation's text-first responsive interface in `src/main.js` and `src/style.css` |
| Fixed-priority baseline policy | `design` | [EVALUATION.md](EVALUATION.md#baseline-and-comparison); `players/baseline.js` |

### Credit and reuse terms

The game is an original implementation and all player-facing prose is newly
written. The historical source collection identifies *Deadline* as a 1982
Infocom game written by Marc Blank and says the contributed source collection
is not under an open license ([collection README](../README.md), “What is this
Repository?” and “Purpose”). This project uses approved character names and
plot facts as an adaptation; it does not copy source code, exact dialogue,
compiled files, or assets. See the [story evidence notes](../STORY_AND_SUSPECT_EVIDENCE.md)
for the design's source context.

The approved story/action specifications are the authority for this bounded
adaptation. Rule-map entries use `design` because they are selected or adapted
rules, not claims that this implementation reproduces upstream code.
