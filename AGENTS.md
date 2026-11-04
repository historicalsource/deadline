# Midterm project instructions

Read this file before changing the project. The student owns the design and
final decisions. Treat this as a small playable detective game inspired by
part of the original *Deadline*.

## Project direction (current working scope)

Build a short, single-case, text-based investigation of Marshall Robner's
death. The approved bounded design has four suspects (Baxter, Dunbar, George,
and Mrs. Robner), four rooms (Living Room, Library, Kitchen, and Garden), a
short evidence chain, private interviews, and a clear accusation/ending. Do
not revert to the older three-suspect candidate or expand the game into a
full remake.

The student owns the design and final decisions. Implement the current design
in the two specifications below. If they conflict, use this order: the
student's latest explicit instruction; `ACTION_DICTIONARY_AND_RULES.md` for
action validity and state transitions; `MIDTERM_STORY_RECONSTRUCTION_PLAN.md`
for story, scope, and narrative intent; then this file for project and
implementation constraints. If a material conflict remains, report it and
ask before inventing a new story rule.

### Design specifications and their purposes

- [`MIDTERM_STORY_RECONSTRUCTION_PLAN.md`](MIDTERM_STORY_RECONSTRUCTION_PLAN.md)
  is the narrative and scope brief: cast, room purposes, evidence logic,
  private-interview setup, accusation outcomes, and intentional exclusions.
- [`ACTION_DICTIONARY_AND_RULES.md`](ACTION_DICTIONARY_AND_RULES.md) is the
  implementation-facing contract: accepted command forms, legal contexts,
  clue dependencies, interview/search rules, invalid-action behavior, and
  terminal transitions. Implement its named actions and state requirements
  exactly; do not invent extra commands or hidden puzzle steps.

Read both files before implementation. Treat their decisions as approved
working scope unless the student changes them. Settled defaults include:

- A uniformed patrol officer, unnamed and with no dialogue or clue branch,
  supervises the three suspects remaining in the Living Room while the
  detective searches other rooms or privately interviews one suspect. The
  interview has no specified location; the interviewee returns to the group
  afterward. This is temporary scene supervision, not a formal arrest;
  Sergeant Duffy is omitted.
- Every accusation opens `close the case` and `continue investigating`,
  unless that accusation reaches the 50-action or submitted-call limit.
  Continuing preserves all previously named suspects and
  evidence; later accusations accumulate in the case record. Closing resolves
  the accumulated accusation set. If Dunbar is the only true culprit named,
  the incomplete-case newspaper reports her release on bail and later murder
  by Baxter. In the truth window, the `Afterward` section appears only when
  Dunbar is the sole name in the accusation record. The later murder is
  epilogue text, not a simulated in-game movement branch.
- The Garden fragment is found with `search holes`. The concert relationship
  and alibi contradiction come from suspect interviews; do not implement a
  ticket-stub item. Use the exact lab actions and results in the action
  dictionary.
- Use a 50-successful-action episode limit. Invalid actions do not advance
  game state or consume an in-story action, but each submitted call still
  counts against the model-call limit. Reaching the action limit ends the
  episode immediately, even if the last successful action was an accusation
  that would otherwise offer the close/continue choice.
- Default the agent runner to 60 model calls per episode and a 60-second
  timeout per model call. Keep both configurable and report the effective
  values in the evaluation documentation.
- Private suspect searches are consensual within the fiction. Public searches
  are refused. Write new implementation code and player-facing prose; do not
  copy source code or exact dialogue.

The submitted game must be independently playable and machine-playable. It
must expose the equivalent of `reset(seed)`, `observe(player_id)`,
`legal_actions(player_id)`, `step(player_id, action)`, and `outcome()`. Keep
the game rules and state authoritative in the engine. Enforce legal actions,
information boundaries, and per-episode step/model-call limits in code.

## Source and publication boundary

The upstream repository README says this historical source collection is not
under an open license. The student reports that the instructor approved using
the original game's names and story for this course project. Agents may use
those plot facts and character names when helping design the adaptation. Do
not copy or adapt upstream code, exact dialogue, compiled game, assets, or
other expressive text into the course submission unless the student verifies
terms that permit publication in the public course repository. Write the
implementation and player-facing prose anew. Credit the game and all other
references in the project README, and record source evidence for each rule.
Label original rules `design`; use `code`, `manual`, `observed`, or `assumed`
only when the source and locator support those labels.

## How to work

- Before implementation, report a short plan listing the files to change, the
  intended playable result, and how the student can inspect it.
- Keep the game bounded and focus on a complete loop, meaningful decisions,
  clear termination, and an executable evaluation. Do not expand the project
  into a full remake of *Deadline*.
- Keep the model-driven player separate from the engine. It may receive only
  player-visible observations and allowed actions; it must not read project
  files, shell state, evaluator code, answer keys, or hidden game state.
- Implement one cheap scripted, heuristic, or search baseline. Use the same
  observations and action rules for both players.
- Keep the declared evaluation cases fixed before prompt tuning. Save traces
  and report failures as well as successes.
- Keep configuration, dependencies, and generated evidence inside this
  project folder. Do not add secrets, private playtester information, or
  copyrighted source material to the eventual public submission.
- Do not push, open a pull request, or change another repository without the
  student's explicit direction.

## Evidence to produce

As the project takes shape, help the student keep these separate artifacts
inspectable: the project README with setup, play, test, evaluation commands,
scope, and rule/source map; `EVALUATION.md` with the declared suite, results,
traces, CI evidence, and limitations; `AGENT-TEAM.md` with the student's own
account of each agent's access, work, recommendations, decisions, and
evidence; and independent reviewer findings in `review.md` or PR comments.
Use a separate read-only review session for independent review. The reusable
skill or prompt is another artifact and should be invoked in at least two
sessions.

The required deterministic CI checks include rule invariants, legal and
illegal actions, a successful path or terminal outcome, a real observed
regression, and episode limits. Do not claim these checks or live model trials
have run until evidence exists. Follow the midterm rubric for playtests,
recording, deadlines, and hand-in details.

## Git workflow

The working midterm branch is `erica-ll/midterm`. Continue on the current
branch unless the student asks to change it. Do not commit, push, or open a PR
without direction. The rubric's eventual submission is one PR to the course
repository; the student can use this branch as the working branch or transfer
the finished project into the required course-repository folder.
