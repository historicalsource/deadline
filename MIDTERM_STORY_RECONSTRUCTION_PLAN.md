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
| **Library** | Crime scene and Baxter motive | On entry, reveal Robner's body, the teacup/saucer, Ebullion, and desk. `inspect notepad` reveals faint pressure marks; `shade notepad with pencil` reveals an impression referring to Baxter and Focus. The hidden safe contains the Focus papers and new will. |
| **Kitchen** | Tea service / cup-switch trail | `count china` shows six cups and seven saucers, suggesting a cup is missing. The Garden fragment's pattern connects it to the service. |
| **Garden** | Physical route / discarded evidence | `inspect holes` reveals compacted ladder holes and crushed flowers. `search holes` finds the porcelain fragment; clean and analyze it, then compare it with LoBlo to confirm the poison trail. The garden stands in for the original rose-garden evidence. |
| **Living Room** | Supervised suspect group and shared evidence | All four suspects begin here. A uniformed patrol officer remains with the other three whenever the detective takes one suspect to the Library for a private interview; the interviewed suspect returns to the officer afterward. When the detective investigates another room, the officer continues supervising the group. Mrs. Robner appears anxious but does nothing until addressed. The delivered letter appears on a table at the player's second Living Room entry. |

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
are not being interviewed; the detective escorts one interviewee to the
Library and returns them to the officer afterward. The officer has no
dialogue or independent actions.
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
2. `interview <person> privately` — invites that one suspect to a private
   interview in the Library. The officer remains with the other three. The
   detective escorts the interviewee and returns them to the Living Room
   when the interview ends. This is a voluntary interview, not a formal
   arrest.
3. `ask <person> about <topic>` while the interview is private — yields the
   fuller account, including sensitive details.
4. `search <person>` during the private interview — yields relevant
   possessions, or confirms that no relevant item was found. Searches are
   consensual in the fiction; public searches are refused.
5. `return <person> to living room` — ends the private interview and returns
   the suspect to the officer's supervision with the group. If the player
   later accuses Dunbar on the poison evidence, offer a separate choice to
   close the case on her alone or continue investigating.

The medicine search is an intentional adaptation: searching Dunbar reveals
her LoBlo; searching Mrs. Robner reveals her ordinary allergy/cold
medications, which can look suspicious at first but have no link to the
poison. George and Baxter can carry ordinary personal effects unless we
choose a specific clue for them; don't invent a second hidden evidence system
for their pockets.

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
2. **The tea service is wrong:** library cup plus kitchen cup count suggest
   that a cup was swapped; the garden fragment connects the discarded china
   to the disturbance outside.
3. **The death was poisoning:** a simple lab result on the fragment identifies
   LoBlo and explains its interaction with Ebullion. The result identifies a
   method, not by itself who administered it.
4. **Dunbar had access:** her searched possession reveals LoBlo; her account
   of the concert conflicts with Baxter's. These connect her to the poison
   and Baxter.
5. **Baxter had motive and opportunity:** the note-pad impression and, if
   retained, the Focus papers tie him to Robner's business conflict; the
   ladder holes and cup-switch trail support his cover-up.
6. **Red herrings:** the new will gives George a motive; Steven's letter and
   the relationship it reveals suggest a possible motive for Mrs. Robner.
   Neither trail explains the tea/LoBlo evidence as well as the Baxter–Dunbar
   conspiracy.

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

- The note-pad impression or a visible oddity points to the bookcase.
- `inspect bookcase` shows a disturbed section; `search bookcase` finds the
  concealed safe.
- `open safe` reveals two readable items: Baxter's Focus papers and the new
  will disinheriting George.

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

After the player has found the LoBlo evidence and directly accuses Dunbar,
present exactly two choices:

- `close the case` — end the investigation with Dunbar as the sole accused.
  Baxter remains uncharged. The case goes forward on an incomplete,
  circumstantial theory. In a later newspaper report, Dunbar has been
  released on bail while awaiting trial; the prosecutor is considering a plea
  deal in exchange for information about an accomplice.
  Dunbar is subsequently found dead in a staged suicide. The epilogue makes
  clear that Baxter killed her to prevent her from implicating him. This is a
  failure ending caused by closing the case before investigating Baxter, not
  a branch the player must manage turn by turn.
- `continue investigating` — return to the investigation with no time jump.
  The player can follow the Baxter clues and later name both Dunbar and
  Baxter in the complete accusation.

The two choices should be neutral and should not announce that one prevents
Dunbar's death. The clue state and player decision, rather than NPC movement
simulation, determine the ending. The plea-deal and later death are reported
afterward, so the playable case needs no bail, custody, or escape mechanics.

## Episode boundary and player choices

Set the first-pass limit at 30 successful player actions:

- Four rooms, four suspects, and one bounded case.
- One visible lead per room plus a few optional follow-ups.
- Room changes, public questions, interviews, searches, evidence checks, and
  conclusion choices count toward the same limit. Invalid actions do not
  change game state or consume an in-story action, but do count as submitted
  model calls. Thirty successful actions leave room to visit all scenes and
  privately interview the suspects without requiring every optional clue.
- There is no real-time clock. The 30-successful-action limit is the only
  episode resource constraint.
- Terminal outcomes: strong Baxter–Dunbar conspiracy resolution; weak or
  inconclusive joint accusation when required clue groups are missing; the
  incomplete-Dunbar closure with its newspaper epilogue; incorrect single
  accusation; or episode limit.
- The complete solution requires one joint accusation naming **both** Baxter
  and Dunbar. Accusing Dunbar alone opens the `close the case` / `continue
  investigating` choice. Closing ends the episode; continuing leaves the case
  open. The player need not accuse the suspects in sequence.

The machine interface should return only player-visible evidence and
permitted actions. The engine, not the player prompt, owns hidden culprit
state, evidence validity, accusation checks, and the episode limit.

## Settled implementation defaults

Find the Garden fragment with `search holes`; omit the concert ticket;
describe Dunbar as released on bail in the post-case newspaper; use the
30-successful-action limit; and stage private interviews in the Library
while the patrol officer supervises the remaining suspects in the Living
Room. The action dictionary specifies the exact evidence actions and
accusation outcomes.

## Source references

This plan adapts the story summary and clue map in
`STORY_AND_SUSPECT_EVIDENCE.md`. Relevant source logic includes
`actions.zil` (`EPILOGUE`, `OBJECT-PAIR-F`, `DUNBAR-F`, `BAXTER-F`,
`I-DUNBAR-SEQ*`, and `I-BAXTER-SEQ`) and `dungeon.zil` (the evidence objects
listed in that reference). The original cup and saucer are not described as
visibly mismatched; the clue is the cup-switch inference from the count,
fragment, and lab results.
