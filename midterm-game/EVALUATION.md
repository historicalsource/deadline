# Evaluation record

## Declared deterministic suite

Suite `robner-midterm-v1` was fixed on 2026-11-02 before any model prompt
tuning. The game is deterministic; the seeds identify repeatable trials and do
not change the case. Both players use the same engine and visible action
interface.

| Case | Seed | Intended check | Status |
| --- | ---: | --- | --- |
| Full evidence path | 11 | Establish all five clue groups and make the complete joint accusation | Baseline run recorded; model trial not run |
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
comparison. It uses only `observe`, `legal_actions`, and `step`. It is a strong
completion baseline for this fixed mystery and leaves little separation room
for an unconstrained model; the comparison should also report invalid moves,
calls, latency, tokens, and failures rather than only the ending.

## Results and traces

- Baseline, seed 1, implementation smoke run: `complete_solution`, 19
  successful actions, 0 model calls. See the checked-in
  [`baseline-seed-1.json`](traces/baseline-seed-1.json) trace.
- Deterministic tests: see command results in the implementation session and
  CI workflow when available. The regression is documented below.
- No live provider call has been made; no live-model success, latency, token
  count, or dated cost is claimed.
- No human playtest has been conducted in this implementation session.

## Observed regression

During development, a direct reproduction showed that the legal public action
`search Dunbar` incorrectly returned her private LoBlo inventory. The
regression test `observed regression: public suspect search must refuse
without revealing inventory` failed with the message revealing LoBlo. The
engine was changed to return a public refusal without inventory, and the same
test now passes. A second focused check found submitted-call exhaustion was
not terminal after invalid actions; the limit check now covers that path.

## Limits and next evidence

The model API runner defaults to 60 calls per episode and 60 seconds per call;
the episode itself is capped at 30 successful actions. `MAX_MODEL_CALLS` and
`MODEL_TIMEOUT_MS` change the runner defaults. Provider usage metadata is
stored in traces when returned; no cost is estimated until a live provider,
model, token usage, and dated price source are known. The single-case suite,
missing live trials, missing independent review, and missing peer playtest
notes are limitations, not passing evidence.
