# Midterm story reconstruction plan — draft

**Status:** current approved design direction, subject to Erica's final
decisions. This is the narrative and scope specification, not the action-level
implementation contract. It uses the original *Deadline* names and story as
approved for the course, while leaving the game mechanics small and explicit.

## Working premise

Marshall Robner is found dead in the library. At first the death could be
suicide: he was depressed and took Ebullion. The detective investigates four
suspects—Baxter, Dunbar, George, and Mrs. Robner—through four scenes. The
truth is that Baxter planned the murder and later tried to hide evidence;
Dunbar put LoBlo in Robner's tea, where it interacted fatally with his
Ebullion.

The mystery should be solvable from a short chain of clear clues. The player
should not need to guess parser vocabulary, search arbitrary scenery, or
reconstruct a full-day schedule.

## Bounded cast and room model

### Suspects

- **Baxter:** business motive; concealed concert connection to Dunbar; used
  the ladder to switch the cup.
- **Dunbar:** had access to LoBlo and administered it; concealed the concert
  trip and her relationship with Baxter.
- **George:** apparent inheritance/business motive; his behavior around the
  new will makes him a credible red herring.
- **Mrs. Robner:** apparent inheritance/relationship motive; her private
  relationship with Steven creates a second credible red herring.
- **Marshall Robner:** victim; not an active suspect.

McNabb, Rourke, Coates, Steven, Duffy, and Klutz can be removed as active
characters. Their useful facts can be preserved as evidence or short written
accounts if needed. Rourke's gossip, for example, can be folded into a note
or a brief statement instead of requiring another NPC. Keep one unnamed,
uniformed patrol officer as background scene control only; the officer has no
interview, evidence, or ending branch and does not replace Duffy as a support
character.

### Four locations

| Location | Main purpose | Required evidence/interactions |
| --- | --- | --- |
| **Library** | Crime scene, tea objects, and Baxter motive | On entry, reveal Robner's body, the teacup/saucer, Ebullion, and desk. `inspect notepad` reveals faint pressure marks; `shade notepad` reveals an impression referring to Baxter and Focus. The hidden safe contains the Focus papers and new will. |
| **Kitchen** | Tea service / cup-switch trail | `count china` reports eight plates, seven saucers, and six cups; the player infers what the count may mean. The Garden fragment's pattern can be compared with the service. |
| **Garden** | Physical route / discarded evidence | `inspect holes` reports their dimensions and compacted soil without identifying their cause. `search holes` finds the porcelain fragment; clean and analyze it, then compare it with LoBlo to confirm the poison trail. The garden stands in for the original rose-garden evidence. |
| **Living Room** | Supervised suspect group and shared evidence | All four suspects begin here. A uniformed patrol officer remains with the other three during private interviews; the interview location is unspecified, and the suspect returns to the officer afterward. When the detective investigates another room, the officer continues supervising the group. Mrs. Robner appears anxious but does nothing until addressed. The delivered letter appears on a table after the player returns to the group for the second time. |

The navigation vocabulary is direct: `go to library`, `go to kitchen`,
`go to garden`, and `go to living room`. Any room can be selected from any
other room; there are no compass directions, exits to map, or pathfinding
steps. The engine can also expose these as buttons/actions while accepting
the same short command strings for a human playtest.

The game starts in the Living Room; that initial presence counts as entry
number one. When the player leaves and later enters it again (entry number
two), the letter is placed on the table and becomes readable. Mrs. Robner may
look tense when observed, but she does not approach, hide, move, speak, or
otherwise act until the player takes an action involving her or the letter.
An unnamed uniformed patrol officer is already present as part of the initial
response to Robner's apparent death. The residents have been asked to remain
together in the Living Room while the detective checks the circumstances.
This is temporary scene supervision, not a formal arrest. The officer keeps
the group in place during room searches and watches the three suspects who
are not being interviewed; no room is specified for a private interview. The
officer has no dialogue or independent actions.
The complete proposed command vocabulary, room checks, interview topics,
evidence follow-ups, and invalid-action behavior are in
`ACTION_DICTIONARY_AND_RULES.md`.

## Living Room investigation mechanic

All four suspects begin in the Living Room and remain under the patrol
officer's supervision there during normal play. Use the same small action
pattern for each:

1. `ask <person> about <topic>` in public — yields a short, guarded answer;
   some subjects may refuse or defer sensitive details while the others are
   present.
2. `interview privately <person>` — invites that one suspect to a private
   interview. Its location is unspecified. The officer remains with the other
   three. This is a voluntary interview, not a formal arrest.
3. `ask <person> about <topic>` while the interview is private — yields the
   fuller account, including sensitive details.
4. `search <person>` during the private interview — yields relevant
   possessions, or confirms that no relevant item was found. Searches are
   consensual in the fiction; public searches are refused.
5. `return <person>` — ends the private interview and returns the suspect to
   the officer's supervision with the group. Any accusation against a
   present suspect opens the choice to close the case or continue
   investigating; later accusations accumulate in the same case record.

The medicine search is an intentional adaptation: searching Dunbar reveals
her LoBlo; searching Mrs. Robner reveals one bottle labeled Allergone. The
original also includes Sneezo, which the bounded game omits. The search does
not interpret the medicine. After finding and analyzing the fragment, the
player can compare its chemical trace with the Allergone label. George
and Baxter have no relevant item in this bounded version.

Give each suspect one visible alibi answer. Preserve the meaningful source
contradiction between Baxter and Dunbar through their interviews: Baxter says
Dunbar became ill and left the concert early; Dunbar says she and Baxter went
together and he took her home. Omit the concert ticket as a separate object
to keep the evidence chain bounded. George's and Mrs. Robner's accounts can
be brief and consistent with the adaptation; their suspicion should come
mainly from the new will and Steven's letter, not fabricated hard proof. The
exact public/private question topics and valid actions are listed in
`ACTION_DICTIONARY_AND_RULES.md`.

## Evidence chain and likely suspicion

1. **Could be suicide:** Robner's depression and Ebullion make the initial
   death look explainable.
2. **The tea service count:** the kitchen reports six cups and seven saucers;
   the player can consider that alongside the Library cup and Garden
   fragment. The result itself does not announce a missing or switched cup.
3. **The death was poisoning:** a simple lab result on the fragment identifies
   LoBlo and explains its interaction with Ebullion. The result identifies a
   method, not by itself who administered it.
4. **Dunbar had access:** her searched possession reveals LoBlo; her account
   of the concert conflicts with Baxter's. These connect her to the poison
   and Baxter.
5. **Baxter had a motive:** the note-pad impression and Focus papers connect
   him to Robner's business conflict. The source's ladder/cup-switch account
   remains an author explanation; the bounded observations leave the player
   to infer what the Garden holes and china count mean.
6. **Red herrings:** the new will gives George a motive. Steven's letter
   mentions Robner's business and George's threats, promises Leslie will be
   provided for, and closes with a declaration of love and a shared future.

For ease of play, each room should expose a clue on entry or present one
obvious follow-up action. Avoid “search everything” as a required action.
Optional evidence may strengthen the theory, but the implementation should
use the exact required clue groups in `ACTION_DICTIONARY_AND_RULES.md` for
the strong-conclusion check. The observation and legal-action list should
always indicate the next available investigation step.

## Hidden safe: keep the bookshelf chain

Keep the safe and bookshelf discovery chain in the Library, but remove the
combination puzzle and the separate hidden-closet room.

Use a short, explicit interaction chain:

- The note-pad impression is a separate lead. Inspecting the bookcase reveals
  a disturbed section regardless of whether the notepad has been shaded.
- `inspect bookcase` shows a disturbed section; `search bookcase` finds the
  concealed safe.
- `open safe` reveals two readable items: Baxter's Focus papers and the new
  will disinheriting George. The strong-case requirement is to read the Focus
  papers, matching the source's checked paper/touch state.

This retains two useful story functions without adding a location or an
opaque puzzle: the Focus papers corroborate Baxter's motive, and the new will
makes George's suspicion credible. Keep the safe optional because the case
can already suggest Baxter's motive through the note-pad impression. It
strengthens the case without blocking all progress behind hidden-object
guessing.

## Incomplete accusation and post-case newspaper ending

Do not simulate Dunbar's later murder during the playable investigation. It
would require extra movement, timing, and security rules. Instead, make it a
short post-case outcome tied to one clear player choice.

Whenever the player accuses a suspect who is present, present two choices,
unless that call reaches the successful-action or submitted-call limit, in
which case the engine ends the episode immediately. This can happen before
the player has found any evidence:

- `close the case` — end the investigation using all names on the accusation
  record. If Dunbar is the only true culprit named, unsupported charges
  against others are dropped and Baxter remains uncharged. The case goes
  forward on an incomplete,
  circumstantial theory. In a later newspaper report, Dunbar has been
  released on bail while awaiting trial; the prosecutor is considering a plea
  deal in exchange for information about an accomplice.
  Dunbar is subsequently found dead in a staged suicide. The epilogue makes
  clear that Baxter killed her to prevent her from implicating him. This is a
  failure ending caused by closing the case before investigating Baxter, not
  a branch the player must manage turn by turn.
- `continue investigating` — return to the investigation with no time jump.
  Preserve every earlier accusation. Later accusations add names to the same
  public case record, which is visible in the human case notes and the
  machine observation. The next `close the case` resolves that accumulated
  list.

## Accusation case reports and truth window

The latest approved ending design has five accusation paths. Keep the
accusation and closure prose in a dedicated case report, not in the ordinary
Response area or as a duplicate history message:

1. Closing after naming George and/or Mrs. Robner, without naming either
   Baxter or Dunbar, closes the case as a suicide because the investigation does not connect
   those innocent suspects to the poisoning.
2. Closing after naming both Baxter and Dunbar together with George and/or
   Mrs. Robner produces an overbroad-charge ending. The unsupported charge is dropped;
   with the full evidence chain the true pair is convicted, while an
   incomplete chain leaves the murder unproved.
3. Closing with Baxter named and Dunbar absent produces a distinct
   Baxter-only outcome. Other unsupported names are cleared. If motive
   and method are present but Dunbar's role is absent, Baxter is acquitted;
   with less evidence the District Attorney declines to pursue the charge.
4. Closing with Dunbar named and Baxter absent produces the Dunbar-only
   outcome, even if unsupported names are cleared. It yields the detailed
   newspaper account of her release on bail, the contemplated plea deal, and
   Baxter's later staged murder of Dunbar.
5. Closing after naming Baxter and Dunbar alone yields the complete ending
   only when the required evidence groups are present; otherwise the case
   ends with a distinct weak joint-case report.

The `TRUTH` button opens a separate, player-requested window containing the
full account: Baxter's Focus motive, the Hartford concert and conflicting
accounts, Dunbar's use of LoBlo in Robner's tea, the fatal interaction with
Ebullion, and Baxter's ladder and cup switch. The `Afterward` section about
Baxter's later murder of Dunbar appears only when Dunbar is the sole person
named in the accusation record. This content stays out of the machine
player's observation and legal actions.

The two choices should be neutral and should not announce that one prevents
Dunbar's death. The clue state and player decision, rather than NPC movement
simulation, determine the ending. The plea-deal and later death are reported
afterward, so the playable case needs no bail, custody, or escape mechanics.

## Episode boundary and player choices

Set the first-pass limit at 50 successful player actions:

- Four rooms, four suspects, and one bounded case.
- One visible lead per room plus a few optional follow-ups.
- Room changes, public questions, interviews, searches, evidence checks, and
  conclusion choices count toward the same limit. Invalid actions do not
  change game state or consume an in-story action, but do count as submitted
  model calls. The engine ends the episode as soon as the 50th successful
  action is recorded; this takes precedence over an accusation's close/continue
  choice if the accusation is that final action. The separate submitted-call
  limit also ends the episode when reached, including on an accusation. If
  both limits coincide, the successful-action limit takes precedence. Thirty
  successful actions leave room to visit all scenes and privately interview
  the suspects without requiring every optional clue.
- There is no real-time clock. The 50-successful-action limit is the only
  in-story resource constraint; a separate configurable submitted-call limit
  is an engine safeguard.
- Terminal outcomes: strong Baxter–Dunbar conspiracy resolution; weak or
  inconclusive joint accusation when required clue groups are missing; the
  incomplete-Dunbar closure with its newspaper epilogue; incorrect single
  accusation; or episode limit.
- The complete solution requires a final accusation record naming **both**
  Baxter and Dunbar. Every accusation opens the `close the case` /
  `continue investigating` choice unless it reaches an episode limit. Closing
  ends the episode; continuing leaves the case open and preserves earlier
  accusations. Accusations are available whenever their targets are present,
  even before evidence is found; evidence gathered determines the case outcome.
  The player need not accuse the suspects in sequence.

The machine interface should return only player-visible evidence and
permitted actions. The engine, not the player prompt, owns hidden culprit
state, evidence validity, accusation checks, and the episode limit.

## Settled implementation defaults

Find the Garden fragment with `search holes`; omit the concert ticket;
describe Dunbar as released on bail in the post-case newspaper; use the
50-successful-action limit; and represent private interviews as a mode with
no specified room while the patrol officer supervises the remaining suspects
in the Living Room. The action dictionary specifies the exact evidence actions
and accusation outcomes.

## Source references

This plan adapts the story summary and clue map in
`STORY_AND_SUSPECT_EVIDENCE.md`. Relevant source logic includes
`actions.zil` (`EPILOGUE`, `OBJECT-PAIR-F`, `DUNBAR-F`, `BAXTER-F`,
`I-DUNBAR-SEQ*`, and `I-BAXTER-SEQ`) and `dungeon.zil` (the evidence objects
listed in that reference). The original cup and saucer are not described as
visibly mismatched; the clue is the cup-switch inference from the count,
fragment, and lab results.
