# Action dictionary and context rules

This is the approved implementation-facing command contract for the bounded
midterm version. The game should accept these exact short commands (and
buttons may map to the same actions). Do not add synonyms, actions, or hidden
evidence steps unless Erica asks for them.

## State and movement

- The episode starts in the **Living Room**. This is Living Room entry 1.
- Baxter, Dunbar, George, and Mrs. Robner are present and stay there unless
  one person is invited to a private interview. Mrs. Robner seems anxious but
  does not initiate movement, speech, or other action.
- An unnamed **uniformed patrol officer** is already present as part of the
  initial response to Robner's apparent death. The residents have been asked
  to remain together while the detective checks the circumstances. This is
  temporary scene supervision, not a formal arrest. The officer stays with
  the group while the detective searches other rooms, watches the three
  suspects not being interviewed, and receives each interviewee back when
  the private interview ends. The officer has no dialogue or independent
  actions; Sergeant Duffy is not part of this version.
- The delivered letter is absent on entry 1. After the player leaves and
  enters the Living Room for the second time, the letter is placed on the
  table. It remains there afterward.
- Valid destinations are exactly `library`, `kitchen`, `garden`, and
  `living room`. `go to <room>` works from any other room. There are no
  directions, route choices, or travel-time steps. Going to the room the
  player already occupies is invalid and does not increment an entry count.
- A private interview is a special scene: the detective invites one suspect
  from the Living Room to speak in the Library; the patrol officer remains
  with the other three suspects. Ending the interview returns the detective
  and interviewee to the Living Room and the officer's supervision.

## Command forms

| Command | Valid context and result |
| --- | --- |
| `go to <room>` | Any different one of the four rooms. Changes the current room. |
| `inspect <object>` | Look at a named, exposed thing. Reports what is immediately visible and may point to a follow-up. |
| `search <object>` | Deliberately look through/under/inside a named searchable place or item for something not immediately visible. Only listed search targets are supported. |
| `read <document>` | A document that has been found and is accessible in the current scene. |
| `ask <person> about <topic>` | The person must be present. Public questions are made in the Living Room; private questions must be directed to the interviewee. Topic must be in the table below. |
| `interview <person> privately` | Living Room only; person must be one of the four suspects and present. The detective escorts them to the Library while the patrol officer stays with the other suspects. |
| `return <person> to living room` | Ends that person's active private interview and returns them to the group. |
| `close the case` | Available immediately after accusing Dunbar on the LoBlo/poison evidence. Ends the episode with Dunbar as the sole accused and shows the newspaper epilogue. |
| `continue investigating` | The second choice after accusing Dunbar. Keeps the current evidence and returns to investigation; the player can pursue Baxter and later accuse both suspects. |
| `shade notepad with pencil` | Library, after inspecting the note pad. Reveals the writing impression. |
| `open safe` | Library, only after `search bookcase` finds it. Opens the safe. |
| `clean fragment` | Garden, after finding the porcelain fragment. Reveals its pattern and residue. |
| `analyze <evidence>` | Only the lab-eligible evidence below, once found. Returns the specified result. |
| `show <evidence> to <person>` | Living Room with the person present, or in a private interview with that interviewee. Produces a guarded public or fuller private response, if that evidence/topic pairing is listed below. |
| `accuse Dunbar` | Becomes legal once the player has found Dunbar's LoBlo and confirmed LoBlo on the Garden fragment. Opens the two-choice prompt below. |
| `accuse Baxter` / `accuse George` / `accuse Mrs. Robner` | Become legal after the poison is confirmed. Each ends the episode with an unsupported single-suspect conclusion. |
| `accuse Baxter and Dunbar` | Becomes legal after the poison is confirmed. Names both co-suspects in one action and resolves the episode using the evidence criteria below. |

## Room-specific object actions

### Library

| Action | Result / follow-up |
| --- | --- |
| `inspect body` | Establishes that Robner died in the Library; introduces Ebullion and the tea service as leads. |
| `inspect teacup` | Notes the cup and visible residue. Valid **only in the Library**. |
| `search body` | Checks the body's clothing for personal effects; finds no additional evidence in this bounded version. |
| `inspect saucer` | Notes the saucer and its relationship to the cup. |
| `inspect Ebullion` | Establishes the medicine Robner took and the possible interaction question. |
| `inspect desk` | Shows the desk surface and points out the note pad. |
| `inspect notepad` | Shows the blank-looking page and faint pressure marks; suggests the pencil follow-up. |
| `search desk` | Checks the desk drawers; finds no additional clue. |
| `shade notepad with pencil` | Reveals an impression referring to Baxter and Focus. |
| `inspect bookcase` | Shows the books and visible shelves. After the note-pad/Baxter clue, also reveals a disturbed section that merits closer examination. |
| `search bookcase` | Valid after the disturbed section is noticed; finds the concealed safe. Before then, reports only ordinary books. |
| `open safe` | After the safe is revealed, opens it and makes the Focus papers and new will available to read. |
| `read Focus papers` | Establishes Baxter's business motive involving Focus. |
| `read new will` | Establishes that George would lose the inheritance, supporting his red-herring motive. |
| `analyze teacup` / `analyze saucer` | Lab reports Robner's fingerprints on the cup; Robner and Dunbar's fingerprints on the saucer and sugar bowl. This supports handling, not guilt by itself. |

### Kitchen

| Action | Result / follow-up |
| --- | --- |
| `inspect china` | Shows the tea service and that one space looks empty. |
| `search china` | Checks the cabinet and shelves; confirms the service has one fewer cup than expected. |
| `count china` | Reports six cups and seven saucers; points to a cup having been removed or switched. |
| `inspect sugar bowl` | Identifies the bowl used with the tea service; can be submitted for lab analysis. |
| `analyze sugar bowl` | Reports Robner and Dunbar's fingerprints. Fingerprints alone do not establish when it was handled. |

### Garden

| Action | Result / follow-up |
| --- | --- |
| `inspect holes` | Reveals compacted ladder holes and crushed flowers, suggesting a ladder was placed below the Library window. |
| `search holes` | Finds the porcelain fragment and makes it available to inspect/clean. |
| `inspect fragment` | Notes that it is patterned porcelain matching the house tea service. |
| `clean fragment` | Reveals tea/sugar residue and an unfamiliar chemical trace. |
| `analyze fragment` | Identifies tea/sugar residue and a poison-like chemical, prompting a comparison with available medicines. |
| `compare fragment with LoBlo` | Valid only after the fragment is analyzed and LoBlo has been found in Dunbar's possessions. Confirms LoBlo on the fragment and supports a dangerous interaction with Ebullion. |

### Living Room

| Action | Result / follow-up |
| --- | --- |
| `inspect letter` | Valid after entry 2. Identifies a private affair between Mrs. Robner and Steven and provides the affair clue. |
| `read letter` | Valid after entry 2. Reads the affair letter in full. It raises suspicion of Mrs. Robner but does not prove murder. |
| `inspect <suspect>` | Gives a brief visible impression only; it does not expose inventory or hidden state. Mrs. Robner is visibly anxious. |
| `search <suspect>` | In public, the suspect refuses and no search occurs. Search a suspect only during that person's private interview, framed as consensual. |

The letter cannot be read from another room and cannot be read before it is
delivered. The player can leave and return if they have not yet visited the
Living Room a second time.

## Suspect questions and interviews

The only question form is `ask <person> about <topic>`. “Alibi” is a topic,
not an inspectable object. Use the exact topic names in the table; a public
answer may be guarded, while a private answer gives the fuller account.

| Person | Allowed topics | Public answer | Private answer |
| --- | --- | --- | --- |
| **Baxter** | `alibi`, `concert`, `Focus`, `ladder`, `Dunbar`, `George`, `Mrs. Robner`, `death` | Gives a short account. On the concert, says Dunbar became ill and left early. Deflects questions that connect him to the cup switch. | Gives the same alibi with more detail; still denies the conspiracy. His account conflicts with Dunbar's. Evidence confrontation can expose the contradiction. |
| **Dunbar** | `alibi`, `concert`, `LoBlo`, `Baxter`, `George`, `Mrs. Robner`, `new will`, `death` | Gives a short account and is guarded about Baxter and her medicine. | Says she and Baxter attended the concert together and he took her home; acknowledges LoBlo is hers if it has been found. If accused after the poison evidence is established, she denies the murder and is formally named as the sole accused if the player closes the case. |
| **George** | `alibi`, `new will`, `inheritance`, `Focus`, `Baxter`, `Mrs. Robner`, `death` | Gives a short account; is evasive about the will. | Explains his reaction to the new will, but has no evidence tying him to the poison or cup switch. |
| **Mrs. Robner** | `alibi`, `letter`, `Steven`, `Baxter`, `George`, `Dunbar`, `death` | Gives a short account; avoids discussing Steven while the others are present. | Confirms the affair after the letter is read; the affair explains her anxiety and supplies a motive-shaped red herring, not proof of the murder. |

### Interview and search rules

1. `interview <person> privately` is valid only in the Living Room and only
   when no other private interview is active. It is an invitation to speak
   privately in the Library, not a formal arrest. The detective escorts the
   interviewee; the unnamed uniformed patrol officer remains with the other
   suspects in the Living Room.
2. During the interview, only `ask <interviewee> about <allowed topic>`,
   `show <evidence> to <interviewee>`, and `search <interviewee>` are valid
   suspect-directed actions. Asking a different suspect is invalid because
   that person is not in the private scene.
3. Private suspect searches are consensual in the fiction. Searching in
   public yields a refusal and no inventory; it does not secretly count as a
   search.
4. `search Dunbar` in her private interview finds LoBlo. `search Mrs. Robner`
   finds ordinary allergy/cold medicines (Allergone/Sneezo), a misleading
   but exculpatory lead. Searches of Baxter and George report no relevant
   item.
5. `return <interviewee> to living room` ends the interview and returns the
   person to the patrol officer's supervision with the others. Only the
   person currently in the interview can be returned.
6. After the player has established the poison/LoBlo connection and chooses
   `accuse Dunbar`, show exactly two choices: `close the case` or `continue
   investigating`. Closing ends the episode with Dunbar as the sole accused
   and displays the post-case newspaper report. Continuing returns to the
   investigation with the current evidence state intact. Do not frame either
   option as “safe” or reveal that Baxter will kill her in the epilogue.

### Evidence confrontation

`show <evidence> to <person>` is accepted only for these pairings:

- `show LoBlo to Dunbar`: public denial/deflection; private acknowledgment
  that it is her medicine, without automatically proving its use on Robner.
- `show fragment to Dunbar` or `show fragment to Baxter`: public denial;
  private responses acknowledge access or opportunity but do not confess.
- `show Focus papers to Baxter`: public deflection; private response confirms
  the business dispute, not the murder.
- `show new will to George`: public evasion; private response confirms the
  inheritance motive.
- `show letter to Mrs. Robner`: public refusal to discuss Steven; private
  response confirms the affair.

All other evidence/person combinations are invalid. Showing evidence never
changes its identity or makes a weak clue conclusive by itself.

## Accusation outcomes

- Accusation actions become available in any room once the player confirms
  LoBlo on the analyzed fragment. The two-name action is the only route to a
  complete solution. There is no separate hidden “conclusion prompt.”
- `accuse Dunbar` is available only after the player has both found LoBlo in
  Dunbar's possessions and confirmed LoBlo on the analyzed fragment. It offers
  exactly two choices: `close the case` and `continue investigating`.
- `close the case` ends the playable episode. Dunbar is charged as the sole
  accused; Baxter remains uncharged. The newspaper epilogue reports that
  Dunbar was released on bail while awaiting trial and that the prosecutor
  was considering a plea deal in exchange for information about an
  accomplice. Dunbar is later found dead in a staged suicide. The epilogue
  reveals that Baxter killed her to prevent her from implicating him. This is
  the incomplete-investigation ending; no in-game movement or bail mechanics
  are simulated.
- `continue investigating` returns to normal exploration with all collected
  evidence intact. The player can investigate Baxter and later use
  `accuse Baxter and Dunbar` for the complete solution.
- The complete-solution action names both suspects together; there is no
  required accusation order. A strong successful outcome requires all of
  these player-visible clues: (1) `compare fragment with LoBlo` confirms the
  poison mechanism; (2) `search Dunbar` finds her LoBlo; (3) both concert
  accounts have been heard and their contradiction is recorded; (4) Baxter's
  motive is found by either shading the notepad impression or reading the
  Focus papers; and (5) the player has inspected the ladder holes and counted
  the kitchen china. If the pair is accused without all five clue groups, end
  with an inconclusive/weak-case result rather than a full success.
- `accuse Baxter`, `accuse George`, or `accuse Mrs. Robner` as a single
  suspect ends with an unsupported-conclusion outcome. `accuse Dunbar` has
  the special two-choice flow above.

## Invalid commands and failure behavior

Invalid means the action is not in the command vocabulary or its context
requirements are unmet. The game should explain the missing condition in one
short sentence and leave evidence, location, suspect state, and clue flags
unchanged. A valid public question that gets a refusal is **not** invalid; it
returns the guarded/refusal response and changes no evidence state.

Examples:

- `inspect teacup` in the Library is valid; `inspect teacup` in the Kitchen,
  Garden, or Living Room is invalid.
- `ask Baxter about alibi` in the Living Room is valid; `inspect alibi` is
  invalid everywhere. An alibi is learned by asking its subject.
- `read letter` before the second Living Room entry or outside the Living
  Room is invalid.
- `open safe` before `search bookcase` finds it is invalid.
- `clean fragment` before `search holes` finds the fragment is invalid.
- `compare fragment with LoBlo` before both the analyzed fragment and
  Dunbar's LoBlo have been found is invalid.
- `interview George privately` while in the Library or while another person
  is already being interviewed is invalid.
- `ask Dunbar about LoBlo` while Baxter is the private interviewee is
  invalid; asking Dunbar publicly in the Living Room is valid but guarded.
- `return Baxter to living room` during Dunbar's interview is invalid.
- `close the case` or `continue investigating` before accusing Dunbar on the
  poison evidence is invalid.
- `accuse Dunbar` before both the LoBlo possession and fragment comparison
  are established is invalid.
- Any accusation before the fragment comparison establishes the poison is
  invalid.

Invalid actions never reveal hidden facts. The episode limit is exactly 30
successful player actions. Movement, questions, interviews, searches,
evidence checks, accusations, and the `close the case` / `continue
investigating` choice count toward the same limit. Malformed or
context-invalid calls do not consume an in-story action, but every submitted
call counts against the separate model-call limit. There is no real-time
clock.

## Decisions to make before implementation

All action names, evidence results, the omitted ticket item, accusation
requirements, and the 30-successful-action limit above are settled
implementation defaults. Do not add alternate ticket actions, extra endings,
different lab steps, or a real-time clock without Erica's direction.
