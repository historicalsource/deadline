# Independent review findings

**Review date:** 2026-11-03
**Review version:** 2.0
**Overall result:** needs changes

This is a read-only review of the implementation under `deadline/midterm-game`. I treated `deadline/AGENTS.md`, `deadline/MIDTERM_STORY_RECONSTRUCTION_PLAN.md`, and `deadline/ACTION_DICTIONARY_AND_RULES.md` as the intended design. I used `SOURCE_FLOW_AUDIT.md` as the implementer's state-transition summary, then checked its claims against the code and tests. No game code or tests were changed.

## Findings ordered by severity

### 1. Private interview return can deliver the letter without leaving the Living Room

**File/line:** [`src/engine.js`](src/engine.js#L303), especially lines 305–307.
**Affected path:** Any private interview before the detective leaves the Living Room.

**Expected:** The letter arrives only after the detective leaves the group and later re-enters the Living Room. Starting presence is entry one. A private interview is a special scene and returning the interviewee to the group is not a room departure and re-entry. See `MIDTERM_STORY_RECONSTRUCTION_PLAN.md` lines 58–60 and `ACTION_DICTIONARY_AND_RULES.md` lines 22–26, 31–34.

**Actual:** `return <person>` increments `roomEntries`; the initial interview return therefore delivers the letter. This exposes the letter early and makes the stated “second Living Room entry” depend on interviewing rather than room movement.

**Reproduction:** Fresh game → `interview privately Baxter` → `return Baxter`. The resulting observation has `letterDelivered: true` and a pending arrival notice, although the detective did not leave the room.

**Coverage note:** `the letter is readable only after the second Living Room entry` tests actual room movement. Test `a letter notice persists alongside a private-interview return response...` at `tests/engine.test.js` lines 109–127 instead asserts that interview return produces a letter notice; it currently codifies the unintended transition.

### 2. Opening the safe gives away document conclusions before either document is read

**File/line:** [`src/engine.js`](src/engine.js#L321).
**Affected path:** Library safe and motive/red-herring evidence.

**Expected:** `open safe` makes the two documents available to read. `read Focus papers` gives Baxter’s embezzlement and cover-up facts; `read new will` establishes George’s inheritance motive. The design explicitly requires reading Focus papers to satisfy the motive evidence condition (`MIDTERM_STORY_RECONSTRUCTION_PLAN.md` lines 150–154; action dictionary lines 76–78).

**Actual:** The `open safe` response itself says the papers are about Baxter’s Focus involvement and that the will leaves George nothing and the estate to his wife. The player learns those conclusions without either read action. The strong-case flag still requires reading Focus papers, so the player-visible knowledge and evidence state diverge.

**Reproduction:** `go to library` → `inspect bookcase` → `search bookcase` → `open safe`.

**Coverage note:** `bookcase and safe can be discovered without shading the notepad` checks discovery and found evidence, but does not check the opening response for premature conclusions. This mismatch was verified by static inspection; the existing execution path is also in the suite.

### 3. A last-call accusation leaves a choice that cannot be resolved

**File/line:** [`src/engine.js`](src/engine.js#L165), with the submitted-call check at lines 167–169.
**Affected path:** Any accusation made on the final allowed model call.

**Expected:** At the configured call limit, the episode ends; otherwise an accusation choice is usable only if a call remains. The project instructions set a per-episode model-call limit, and the action dictionary defines precedence for the 30-successful-action limit.

**Actual:** The post-action model-call check is gated on `!this.state.terminal`. An accusation creates a `choice` terminal, so the engine remains in that choice after the limit is reached. The next attempt to choose close/continue is rejected as over-limit and then ends the episode, making the choice unusable.

**Reproduction:** `new DeadlineGame({maxCalls: 1})` → `accuse Dunbar`. At submitted call 1, outcome is still `status: "choice"` with both choices exposed.

**Coverage note:** The existing limit test uses two invalid calls and does not cover a terminal choice on the final allowed call. Reproduced directly against the engine.

## Branch outcome table

| Starting condition and key choices | Expected state change and ending | Verification |
|---|---|---|
| Accuse Dunbar; close immediately | Preserve Dunbar accusation; `incomplete_dunbar_case` with newspaper epilogue | Executed: test 512; code traced |
| Accuse Dunbar; continue; investigate or accuse again | Preserve Dunbar and all evidence; resume investigation; eventual closure uses the accumulated set | Executed: tests 419 and 512; code traced |
| Accuse Baxter only; close with weak evidence | `baxter_only`; DA declines | Executed: test 419 |
| Accuse Baxter only; close with motive and method | `baxter_only`; jury acquits | Static only; no test for this conditional subcase |
| Accuse George and/or Mrs. Robner only; close | `false_accusation_suicide` | Executed individually in test 419; pair case statically traced |
| Accuse Baxter and Dunbar; close without all five required clue groups | `weak_case` | Executed: tests 439 and 496 |
| Accuse Baxter and Dunbar; close after all required clues | `complete_solution` | Executed: tests 340 and 390 |
| Accuse both culprits plus one or both innocent suspects; close | `overinclusive_accusation`; extras dropped; evidence decides conviction versus unproved | One extra tested with weak and complete evidence in tests 458 and 469; two extras static only |
| Any accusation as successful action 30 | Immediate terminal `episode_limit`; no close/continue choice | Directly executed in this review; no exact boundary test |
| Accusation on final submitted call | Expected call-limit termination; actual pending choice cannot be resolved | Directly reproduced; defect 3 |

The case category is selected from the accumulated accusation set, and the code canonicalizes that set, so representative different orders produce the same outcome away from limits. The 30-action and model-call limits are separate boundary transitions and can supersede the ordinary accusation flow.

## Dependency and transition audit

The matrix groups actions that share one precondition and transition. “Executed” refers to a deterministic test or a targeted direct engine execution; “static” means checked from implementation logic and the listed test coverage, not every route executed. A rule marked mixed has some tested representatives and some code-only variants.

| Rule/action and exact design precondition | Enforcement and state change / player-visible result | Downstream dependency or outcome | Test/check status |
|---|---|---|---|
| Start/reset; no precondition. Begin in Living Room, entry count 1, no letter, no evidence or accusation. | `engine.js` 74–83 initializes these fields; `observe` exposes location and action words. | Sets initial room for public questions, interviews, accusations, and later letter entry counting. | Executed: `reset, observations, and legal actions preserve role boundaries` (test 7). |
| Move to a different one of four rooms; current room must differ; no movement during interview. | `_isLegal` 220 and `_apply` 292–297. Updates room; entering Living Room increments count and on count ≥2 delivers letter and queues notice. | Makes room-local actions available; room return can deliver letter. Interview-return version is defect 1. | Executed: legal movement/invalid state test (36); letter by room return (81). Interview boundary directly executed for finding 1. |
| Inspect/read letter; Living Room and letter delivered; read clears notice and records evidence. | `_isLegal` 238; `_apply` 336–337. `inspect` gives envelope/postmark; `read` adds `letter`, sets `letter_read`, clears pending notice. | `show letter` to Mrs. Robner; reading content gives relationship and red-herring context. | Executed for room-delivered letter, inspection, reading, notice clear, and no affair confession: test 81. Premature interview delivery separately reproduced. |
| Inspect exposed objects; correct room. Most checks only set clue or found flags; body/desk/notepad/bookcase/holes/china observations have separate results. | Candidate lists and room gates in `_candidates` 199–205, `_isLegal` 247–264; results in `_apply` 310–333. | Notepad inspection enables shade; bookcase inspection enables search; fragment must be found before inspection; china observation supports pattern comparison; holes/ladder are optional inference clues. | Mixed: Library descriptions and shading prerequisite in test 142; room descriptions/ladder in 156 and 167; clue wording in 298. Exact valid room gates and repeated inspections mostly static. |
| `shade notepad`; Library and prior `inspect notepad`. | `_isLegal` 252; `_apply` 318 sets `notepad_read` and Baxter motive, reports impressions naming Baxter/Focus. | Required for strong joint case; contributes motive for Baxter-only evidence condition. | Executed, including invalid before inspect only indirectly via legal list after inspect: test 142 checks availability then success; missing-prerequisite rejection is static. Strong outcome exercised by baseline. |
| `search bookcase`; Library and prior disturbed-section observation. `open safe`; Library and safe found. | `_isLegal` 253–254; `_apply` 319–322. Sets `safeFound`, then `safeOpen` and found docs. Opening response leaks document conclusions (finding 2). | Read actions need `safeOpen`; read Focus sets `focus_papers_read`; read will adds George motive evidence. | Executed discovery and open without notepad: test 287. `open safe` before search invalid is covered in test 235’s early read invalid, but not a direct early-open assertion in the displayed suite; gate is otherwise statically verified. Premature disclosure found by static and action reproduction. |
| Read Focus papers/new will; Library, safe open. `read papers` is the supported alias. | `_isLegal` 255; `_apply` 322–323. Reading Focus sets found evidence, `baxter_motive`, and `focus_papers_read`; will sets found `new will`. | Focus-read flag is required for complete joint evidence and contributes to Baxter-only motive branch; new will is red-herring context and confrontation pairing. | Executed: alias/evidence content at test 235; Focus topic/confrontation paths at 255 and 270; no direct test of read-new-will prerequisite/result. |
| Analyze teacup/saucer; Library and corresponding found item. | `_isLegal` 256; `_apply` 324 adds evidence and fingerprint result. | Optional corroboration only; neither item enters strong-case predicate. | Static only for prerequisite and both results; no located direct tests for these two lab actions. |
| Kitchen china inspection/search/count; Kitchen. | `_isLegal` 259; `_apply` 325–327 sets examined/counted flags and reports pattern/count. | Pattern comparison with cleaned fragment requires `china_examined`; count is optional, not a conviction prerequisite. | Executed description/count and no inference language in test 298; room/action in test 156. Exact repeated-action behavior is static. |
| Search Garden holes; Garden. It always finds the fragment in this bounded implementation. | `_isLegal` 260–264; `_apply` 330 sets found `porcelain fragment`, returns fragment/cut response. | Enables inspect/clean; fragment analysis and later comparison derive poison method. | Executed in multiple paths (tests 185, 298, 371, 404, 442); deterministic guaranteed-find behavior is covered by those paths. |
| Clean fragment; Garden and fragment found. Analyze fragment; Garden, fragment found, and cleaned. | `_isLegal` 262–263; `_apply` 332–333. Clean sets flag; analysis sets `fragment_analyzed` and found `new chemical`. | New chemical plus LoBlo/Allergone enables comparison; LoBlo comparison sets poison confirmation. | Executed fragment aliases and no chemical on clean in test 185; analyze/compare in tests 214, 298, 371, 404. Analyze-before-clean rejection is not directly asserted; statically verified in `_isLegal` 263. |
| Compare new chemical with LoBlo or Allergone; both items in evidence; any room; either argument order. | `_isLegal` 222–223 normalizes either order; `_apply` 334–335. LoBlo result sets `poison_confirmed`; Allergone reports no match and sets no clue. | LoBlo confirmation plus found LoBlo participates in Baxter-only and joint-case conditions. Allergone is optional exclusion. | Executed: both comparison orders with medicine-first and chemical-first paths in tests 214 and 404; missing Allergone reagent rejection in 404; missing LoBlo rejection in 185. General all-room behavior directly tested during interview in 185; all room variants otherwise statically equivalent. |
| Public questions; Living Room, allowed subject/topic. Private questions; only current interviewee and allowed topic. | `_isLegal` 231–243; `_answer` 412–456 records asked flags, returns quoted answer. Private Baxter/Dunbar `alibi` or `concert` sets concert contradiction once both accounts exist. | Concert contradiction is required for complete joint case; other topics provide red-herring/context; showing an item can condition some answers. | Executed: all public questions at test 354; private concert at 327 and alibi complete path at 340; evidence-conditioned Focus/Steven answers at 255, 270. Invalid topic/person/context cases partially covered in test 36 and static gates. |
| Start private interview; Living Room, present suspect, no current interview. Return; only current interviewee. | `_isLegal` 231–235 and Living Room check 241; `_apply` 299–308 changes `interviewee`, then clears it and returns suspect. Officer/group narrative is response. | Enables private questions, searches, shows, and single-person accusation; return restores group interactions. It incorrectly increments letter entry count (finding 1). | Executed across interview tests 109, 214, 255, 327, 340, 512; no direct test of a second interview being blocked while one is active, static only. |
| Search suspect publicly; Living Room. Refuse without searching. Search privately; only interviewee. | `_isLegal` 240, 234; `_apply` 341–347. Public refusal is valid and consumes a successful action but adds no evidence. Private Dunbar adds LoBlo; Mrs. Robner adds Allergone; Baxter/George add none. | LoBlo is required for complete joint case and Baxter method branch; Allergone enables optional comparison. | Executed public no-leak regression at test 381; private medicine search/order at 214, 404, 512. Baxter/George no-item responses static only. |
| Show evidence; allowed person/evidence pair, evidence found, target present (Living Room or that person’s interview). | `_showPairs` 210–212 and `_isLegal` 236/243; `_confront` 459–473 records shown flag and returns public/private response. | Shown letter conditions Mrs. Robner’s Steven answer; Focus papers condition Baxter answer; confrontations do not set conviction clues. | Executed Focus papers to Baxter and its alias in tests 255 and 270; other five pairings and invalid pairings mostly static. |
| Single accusation; person present in Living Room or is the interviewee. Joint accusations; Living Room only and supported combinations. No evidence prerequisite. | `_isLegal` 224–229; `_apply` 352–363 adds accusation names and creates choice. | `close` resolves accumulated set; `continue` preserves it. At successful action 30 the action-limit terminal overrides the choice. | Executed availability/context and accusation prompt at test 50; overbroad name canonicalization/extra suspect in 458; 30th action direct execution below. Other rejected joint forms statically checked. |
| Continue investigating; only in accusation choice. Preserve evidence/accusations and clear choice. Close; only in choice, then terminal. | `_isLegal` 218; `_apply` 350–351; `_closeCase` 368–409. Terminal states reject future actions (`step` 149). | Accumulated accusation set selects outcome; evidence flags select conditional joint/Baxter result. | Executed continuation/preservation in tests 419, 483, 512; post-terminal rejection in test 419 lines 427–429; remaining conditional branches below. |
| Close with innocent-only accusation(s); accuse George/Mrs. Robner without Baxter or Dunbar. | `_closeCase` 394–396 returns `false_accusation_suicide`. | Terminal suicide report. | Executed for George and Mrs. Robner individually in test 419; both together is static, with same `.every` predicate. |
| Close with Dunbar, without Baxter, optionally innocent extras. | `_closeCase` 390–393 returns `incomplete_dunbar_case`, dropping unsupported extras and including newspaper epilogue. No evidence predicate. | Terminal; Truth window’s Afterward section is conditional on exactly Dunbar in accusation record. | Executed Dunbar-only close and separate continuation in test 512; Dunbar plus extra innocent is static. |
| Close with Baxter, without Dunbar, optionally innocent extras. | `_closeCase` 381–389; if Focus papers + notepad and poison confirmation + found LoBlo, Baxter-only acquittal; otherwise DA declines. | Terminal `baxter_only`. | Executed only less-evidence/declined path in test 419. The complete motive+method Baxter-only acquittal branch has no located test; static condition and response verified. |
| Close with both true suspects, no innocent extra. | `_closeCase` 397–406; full predicate is poison confirmed + LoBlo found + concert contradiction + Focus papers read + notepad read. Missing clues produce weak case. | `complete_solution` vs `weak_case`. Missing-clue message selection prioritizes missing Focus, then missing note, then generic account gap. | Executed complete in tests 340 and 390; weak in 439 and missing Focus specifically in 496. Other isolated missing-predicate combinations are not each executed; predicate and branch text statically checked. |
| Close with both true suspects and innocent extras. | `_closeCase` 372–380 uses same evidence predicate; unsupported extra names dropped in report. | `overinclusive_accusation`, conviction or unproved outcome. | Executed weak and complete representatives in tests 458 and 469; both extras together and every evidence-missing variant static. |
| Successful-action limit; 30th valid action ends immediately, including accusation. Invalid action does not increment successful actions. | `step` 155–166 increments only legal actions and then finishes at limit, overriding accusation choice. | `episode_limit`; no further actions accepted. | Boundary directly executed: 29 successful `ask Baxter about alibi` actions then `accuse Baxter` ended at action 30 with `episode_limit`, terminal status, and zero choices. Existing test 549 only exercises a two-action non-accusation limit; exact default-limit accusation boundary lacks a test. Invalid no-state-change covered at test 36. |
| Submitted-call limit; every submitted call counts, including invalid calls; model-call cap configurable. | `step` 150–160 counts calls; 167–169 checks reached limit only if no terminal is pending. | `model_call_limit` when no pending choice; final-call accusation is stuck in unusable choice (finding 3). | Invalid-call limit executed in test 549. Accusation-at-limit directly reproduced. |

## Accusation order and boundary analysis

The design says accusation order does not matter and later accusations accumulate. In the code, `normalizeAction` canonicalizes a joint command into `SUSPECTS` order (engine lines 40–46), and `_apply` stores the union of previous and new names in that same fixed order (lines 352–357). `_closeCase` branches on membership and count, not chronology (lines 370–408). Therefore, absent an episode limit, the final accusation set determines the case category; order among accusation actions cannot change the ending or its evidence predicate.

Representative execution confirmed this: accusing Baxter then Dunbar, versus Dunbar then Baxter with a continue between them, produced the same `["Baxter","Dunbar"]` record and `weak_case` result. Existing test `continue investigating preserves earlier accusations...` (483–494) verifies accumulation across an innocent accusation and a joint command; test 458 submits a joint command in noncanonical order and verifies canonical handling. These results support equivalence by set membership; every permutation was not executed and was not needed to establish that code property.

Order and batching can still change whether the 30-action boundary is reached on an accusation: a joint command is one successful action, while separate accusation actions require an accusation and a continue choice for each additional accusation. The limit rule itself is uniform: any accusation as action 30 ends with `episode_limit` and no close/continue choice. That exact boundary was directly executed during this review. A new deterministic regression test should minimally put the game at 29 successful actions, accuse, and assert terminal status, `episode_limit`, preserved accused list, and no choices.

## Paths verified by execution

- All 33 existing deterministic tests passed in the previous review run (`npm test`: 33 passed, 0 failed).
- This review directly executed the 30-successful-action accusation boundary: action 30 produced terminal `episode_limit`, retained Baxter in the accusation record, and exposed no choices.
- This review directly compared two accusation orders (Baxter→Dunbar and Dunbar→Baxter); both resolved to the same canonical set and `weak_case` ending.
- Earlier direct reproduction confirmed letter delivery after interview return and the call-limit accusation choice.
- Existing tests execute representative room transitions, letter room-entry delivery, required clue path, both ingredient orders for comparisons, public/private search, clue-gated safe and fragment routes, full and weak joint cases, single-target endings, continuation, terminal rejection, invalid action behavior, and invalid-call limits. Individual entries are mapped in the dependency matrix.

## Paths verified only by static tracing

- Every unlisted pairing/order permutation of accumulated accusations. The code’s canonical-set storage and membership-based resolver establish order independence away from limits; only representative orders were executed.
- Some negative prerequisites and exact room variants where a shared `_isLegal` guard handles them (for example, analyze teacup before finding it, analyze fragment before cleaning, and invalid private-interview cross-target questions).
- Each separate missing-clue combination for the weak joint ending; the full predicate and representative missing Focus/missing notes behavior were checked, not all combinations executed.
- Baxter-only acquittal with both motive and method evidence; the less-evidence branch is tested.
- Joint innocent accusations, both innocent extras on an overbroad charge, some no-item search responses, and all evidence-confrontation pairings beyond tested examples.

## Paths still unverified and why they matter

- **Automated regression for the 30th-action accusation:** behavior was directly executed and is correct, but the suite does not lock the precedence rule. Add the minimal test described above.
- **Automated regression for final-call accusation:** a defect was directly reproduced. Add a test with `maxCalls: 1` and an accusation as call one; assert that the episode is terminal at the cap and that no unusable choice remains. The precise desired terminal reason should follow the project’s call-limit policy.
- **Letter entry count after interview return:** an existing test currently expects the defective delivery; the rule and implementation mismatch are confirmed. Correcting code/test behavior requires a separate implementation change authorization; this review did not make one.
- **Complete Baxter-only evidence threshold:** the branch condition is explicit and statically understood, but this particular ending subcase lacks deterministic coverage. The smallest test should establish both flags for motive and method, close after Baxter-only accusation, and assert the acquittal text; a paired missing-evidence case already exists.
- **Full invalid-prerequisite matrix:** not every invalid action was individually executed. The dependency matrix identifies those that rely on common static guards. Their importance is lower than the reproduced state-transition defects, but a future table-driven test can assert invalid actions leave evidence, location, clue flags, and successful-action count unchanged.

## Writing-style flag

Most prose is clear and concrete. Some passages lean toward compact evidence summaries rather than a detective story, especially the technical LoBlo/Ebullion comparison (`engine.js` 334) and evidence inventory during safe opening (`engine.js` 321). The latter also reveals document conclusions prematurely (finding 2). The short public answers are plain and understandable; I did not find prose so ornate that its meaning became unclear.

## Unsupported assumptions and other notes

- The engine deterministically finds the porcelain fragment on the first `search holes`; the bounded action dictionary specifies that action as finding it, so this is supported by the approved adaptation.
- Public suspect search is treated as a valid, successful interaction that consumes one successful action while revealing no inventory. This matches the specified refusal behavior.
- The `TRUE` window intentionally exposes the full case account, as the design explicitly refers to the truth window and gates only its `Afterward` section. I did not count that interface as an information-boundary defect.
- No further material mismatches were identified in the accusation categories, full-joint evidence predicate, conditional outcomes, or terminal rejection beyond the findings above.

## Implementation response (2026-11-03)

All three findings above were fixed in `src/engine.js` and covered by
deterministic regressions in `tests/engine.test.js`:

- Returning from a private interview no longer increments Living Room entry
  count or delivers the letter. The letter notice still persists across
  later actions until `read letter`.
- `open safe` now identifies the documents without stating their conclusions;
  those facts appear when the player reads each document.
- Reaching the submitted-call limit ends a pending accusation choice with
  `model_call_limit`, so the player is never left with an unusable choice.
- Additional regressions cover an accusation on successful action 30, the
  complete-evidence Baxter-only acquittal path, and representative invalid
  prerequisites preserving investigation state.

Verification: `npm test` passed all 38 tests on 2026-11-03. `npm run build`
was run after these fixes and completed successfully.

## Later configuration change (2026-11-04)

The successful-action limit was raised from 30 to 50 after this review. The
review findings and execution notes above describe the 30-action configuration
that was reviewed; the current limit is 50, with a regression test at action
50.
