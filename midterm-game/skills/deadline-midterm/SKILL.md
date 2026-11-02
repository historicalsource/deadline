---
name: deadline-midterm
description: Implement or review the bounded Deadline midterm game while preserving its approved action contract, information boundaries, and evidence requirements.
---

# Deadline midterm implementation skill

Use this skill when building or reviewing `deadline/midterm-game/`.

## Read first

Read these project documents before changing rules or narrative:

1. `deadline/AGENTS.md`
2. `deadline/ACTION_DICTIONARY_AND_RULES.md`
3. `deadline/MIDTERM_STORY_RECONSTRUCTION_PLAN.md`
4. `midterm_rubric.md`

Apply precedence in `deadline/AGENTS.md`: latest student instruction, then the
action dictionary for action validity and transitions, then the story plan for
scope and narrative, then implementation instructions. Stop and ask Erica if
a material story-rule conflict remains. Do not add verbs, puzzle steps,
characters, endings, clues, or changed conditions on your own.

## Implementation checklist

- Keep the implementation inside `deadline/midterm-game/`.
- Keep all authoritative state in the engine. Expose equivalents of
  `reset(seed)`, `observe(player_id)`, `legal_actions(player_id)`,
  `step(player_id, action)`, and `outcome()`.
- Invalid actions return a brief reason and leave game state and successful
  action count unchanged. Count submitted calls separately; cap successful
  actions at 30, model calls at a configurable 60 by default, and each model
  request at a configurable 60 seconds by default.
- Implement the four specified rooms, four suspects, exact command forms,
  clue dependencies, interviews, evidence confrontations, accusation choices,
  and endings from the action dictionary. The complete joint accusation needs
  every listed clue group.
- Keep observations and legal actions player-visible. Do not return hidden
  truth, evaluator state, source files, or answer-key fields to a player.
- Keep model-player code separate from engine code. The model may submit only
  a selected member of the supplied legal-action list and receive only the
  supplied observation and actions. No file, shell, or evaluator tools.
- Use the same engine interface for the deterministic baseline.
- Write all narrative anew. Credit the source game; do not copy its code,
  dialogue, compiled game, assets, or expressive text.
- Verify claims by running commands. Do not claim tests, live provider trials,
  CI, regression observations, or human playtests without evidence.

## During work

Before implementation, provide a file-by-file staged plan and inspection
commands. After each stage, report changed files, commands actually run and
their results, plus remaining work. When a real defect is observed, retain a
reproduction test and record the behavior before and after the fix. Do not
write the student's personal reflections or invent playtest notes.

## Reuse

In a later Codex session, open this project and say: “Use the
`deadline-midterm` skill at `deadline/midterm-game/skills/deadline-midterm/SKILL.md`
and follow its read-first checklist before making changes.”
