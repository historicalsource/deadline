# Evaluation record

## Declared deterministic suite

Suite `robner-midterm-v1` was fixed on 2026-11-02 before any model prompt
tuning. The game is deterministic; the seeds identify repeatable trials and do
not change the case. Both players use the same engine and observations,
including currently available action-word heads only. They infer targets and
submit complete commands, and the engine reports whether each attempt is
valid.

| Case | Seed | Intended check | Status |
| --- | ---: | --- | --- |
| Full evidence path | 11 | Establish source-mapped lab, possession, private account, Focus-paper, and note-impression evidence before the joint accusation | Baseline run recorded; model trial not run |
| Repeated full evidence path | 23 | Repeat the same deterministic case to expose action selection variance | Not run |
| Held-out repeat | 47 | Keep this seed out of prompt iteration and run after the first two cases | Not run |

These seeds do not create new story situations. The case has one approved
opening, so this is a narrow repeatability suite, not evidence that the model
generalizes across different cases. The initial declaration should be expanded
only with Erica's approval if more game situations are desired.

## Implemented baseline

The baseline is a deterministic evidence-first policy, not a random mover. It
prioritizes private concert interviews and Dunbar's medicine, then Baxter's
motive, the china count, ladder holes, fragment analysis, and the final
comparison. It chooses from the observation and history alone; the engine
validates each submitted guess. The comparison should report invalid moves,
calls, latency, tokens, and failures rather than only the ending.

## Results and traces

- Baseline, seed 1: `complete_solution`, 23 successful actions, 0 model calls.
  See [`baseline-seed-1-1793664458403.json`](traces/baseline-seed-1-1793664458403.json).
- Baseline, seed 11: `complete_solution`, 23 successful actions, 0 model calls.
  See [`baseline-seed-11-1793664458511.json`](traces/baseline-seed-11-1793664458511.json).
- On 2026-11-02, `npm test` passed all 21 deterministic tests and
  `npm run build` completed. The source-to-bounded route comparison is in
  [`SOURCE_FLOW_AUDIT.md`](SOURCE_FLOW_AUDIT.md).
- On 2026-11-03, fixes from the independent review were verified with
  `npm test`: all 38 deterministic tests passed. Coverage now includes the
  private-interview letter-entry boundary, neutral safe opening, final-call
  accusation termination, the then-configured 30th-action accusation
  boundary, and the evidence-supported Baxter-only acquittal branch.
  Representative invalid prerequisite actions are also checked for state
  preservation.
- On 2026-11-04, Erica raised the successful-action limit from 30 to 50.
  The engine and player runner now use 50 by default, and the boundary
  regression test exercises an accusation as action 50.
- No live provider call has been made; no live-model success, latency, token
  count, or dated cost is claimed.
- No human playtest has been conducted in this implementation session.

## Observed regression

During development, a direct reproduction showed that the legal public action
`search Dunbar` incorrectly returned her private LoBlo inventory. The
regression test `observed regression: public suspect search must refuse
without revealing inventory` failed with the message revealing LoBlo. The
engine was changed to return a public refusal without inventory, and the same
test now passes. During the source audit, the Mrs. Robner medicine comparison
was offered in the Garden but rejected by the engine. Its legality condition
was added and the regression test now passes. A separate focused check found
submitted-call exhaustion was not terminal after invalid actions; the limit
check now covers that path.

## Limits and next evidence

The model API runner defaults to 60 calls per episode and 60 seconds per call;
the episode itself is capped at 50 successful actions. `MAX_MODEL_CALLS` and
`MODEL_TIMEOUT_MS` change the runner defaults. Provider usage metadata is
stored in traces when returned; no cost is estimated until a live provider,
model, token usage, and dated price source are known. The single-case suite,
missing live trials, missing independent review, and missing peer playtest
notes are limitations, not passing evidence.
