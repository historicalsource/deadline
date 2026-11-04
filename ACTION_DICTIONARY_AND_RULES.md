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
- The delivered letter is absent on entry 1. After the player leaves the
  group and returns to it for the second time, the letter is placed on the
  table. Its arrival notice remains in the response area and engine
  observation until `read letter` is used; inspecting the envelope alone does
  not clear it.
- Valid destinations are exactly `library`, `kitchen`, `garden`, and
  `living room`. `go to <room>` works from any other room. There are no
  directions, route choices, or travel-time steps. Going to the room the
  player already occupies is invalid and does not increment an entry count.
- A private interview is a special scene: the detective invites one suspect
  from the Living Room to speak privately; the officer remains with the other
  three suspects. The interview has no specified room. Ending it returns the
  suspect to the group.

## Command forms

| Command | Valid context and result |
| --- | --- |
| `go to <room>` | Any different one of the four rooms. Changes the current room. |
| `inspect <object>` | Look at a named, exposed thing. Reports what is immediately visible and may point to a follow-up. |
| `search <object>` | Deliberately look through/under/inside a named searchable place or item for something not immediately visible. Only listed search targets are supported. |
| `read <document>` | A document that has been found and is accessible in the current scene. |
| `compare <A> with <B>` | Available in any room once `new chemical` and LoBlo or Allergone are both in evidence, regardless of discovery order. Either order is accepted: for example, `compare new chemical with LoBlo` and `compare LoBlo with new chemical`. |
| `ask <person> about <topic>` | The person must be present. Public questions are made in the Living Room; private questions must be directed to the interviewee. Topic must be in the table below. |
| `interview privately <person>` | Living Room only; person must be one of the four suspects and present. The interview location is unspecified; the patrol officer stays with the other suspects. |
| `return <person>` | Ends that person's active private interview and returns them to the group. |
| `close the case` | Available immediately after any accusation. Ends the episode using every suspect named so far. |
| `continue investigating` | The second choice after any accusation. Keeps the current evidence and all prior accusations on record, then returns to investigation. |
| `shade notepad` | Library, after inspecting the notepad. Reveals the writing impression. |
| `open safe` | Library, only after `search bookcase` finds it. Opens the safe. |
| `clean fragment` | Garden, after finding the porcelain fragment. Reveals its pattern and residue. |
| `analyze <evidence>` | Only the lab-eligible evidence below, once found. Returns the specified result. |
| `show <person> <evidence>` | Living Room with the person present, or in a private interview with that interviewee. Produces a guarded public or fuller private response, if that evidence/topic pairing is listed below. For Baxter's Focus papers, `show Baxter papers` is also accepted. |
| `accuse <person>` | Available at any time when that person is present: in the Living Room or as the current private interviewee. Opens the two-choice prompt below unless it reaches the 50-action or submitted-call limit, when the episode ends immediately. |
| `accuse Baxter and Dunbar [and <innocent suspect>...]` | In the Living Room, name both Baxter and Dunbar, optionally with George, Mrs. Robner, or both. Order does not matter. |
| `accuse George and Mrs. Robner` | In the Living Room, name either or both innocent suspects without naming Baxter or Dunbar. |

## Room-specific object actions

### Library

| Action | Result / follow-up |
| --- | --- |
| `inspect body` | Establishes that Robner died in the Library; describes the teacup and saucer beside him. |
| `inspect teacup` | Notes the cup and visible residue. Valid **only in the Library**. |
| `search body` | Checks the body's clothing for personal effects; finds no additional evidence in this bounded version. |
| `inspect saucer` | Notes the saucer and its relationship to the cup. |
| `inspect Ebullion` | Establishes the medicine Robner took and the possible interaction question. |
| `inspect desk` | Shows the desk surface and points out the notepad. |
| `inspect notepad` | Shows the blank-looking page and faint pressure marks; shading the notepad reveals the impressions. |
| `search desk` | Checks the desk drawers; finds no additional clue. |
| `shade notepad` | Reveals an impression referring to Baxter and Focus. |
| `inspect bookcase` | Shows the books and one section slightly out of line. This bounded discovery is independent of the note-pad clue; the original reveals the safe through a different book-moving event. |
| `search bookcase` | Valid after the disturbed section is noticed; finds the concealed safe. |
| `open safe` | After the safe is revealed, opens it and makes the Focus papers and new will available to read. |
| `read papers` / `read Focus papers` | Both commands explain that Focus Corporation was a Robner Corp. subsidiary, document Baxter's embezzlement of its funds, and describe the cover-up. Reading them, rather than merely opening the safe, satisfies the motive-evidence requirement. |
| `read new will` | Establishes that George would lose the inheritance, supporting his red-herring motive. |
| `analyze teacup` / `analyze saucer` | Lab reports Robner's fingerprints on the cup and Robner and Dunbar's fingerprints on the saucer. |

### Kitchen

| Action | Result / follow-up |
| --- | --- |
| `inspect china` | Examines the hand-painted household china displayed on the Kitchen shelves, including its plates, teacups, and saucers. |
| `search china` | Reports six hand-painted cups and seven hand-painted saucers in the cabinet. |
| `count china` | Reports eight large and small plates, seven saucers, and six cups. The player draws any inference about the count. |

### Garden

| Action | Result / follow-up |
| --- | --- |
| `inspect holes` | Examines the holes visible in the Garden's soft earth; reports their dimensions and the compacted soil. The original does not identify them as ladder holes from this observation alone. |
| `inspect ladder` | Reports the wooden ladder's length and dirt, and that its feet seem to fit the Garden holes. |
| `search holes` | Finds a porcelain fragment in the soft earth; the searcher cuts a finger on its edge. |
| `inspect fragment` | Describes porcelain covered in dried mud. If the Kitchen china was examined and the fragment cleaned, its painted pattern can be compared with that china. |
| `clean fragment` | Makes the hand-painted design visible. If the Kitchen china was examined, the player can compare the patterns. Residue and chemical findings require lab analysis. |
| `analyze fragment` | Adds `new chemical` to found evidence. The lab reports tea and sugar, another chemical not commonly used as medication, no clear fingerprints, and that the chemical is not Amitraxin (Ebullion). |
| `inspect porcelain`, `clean porcelain`, `analyze porcelain` | Accepted as exact aliases for the corresponding fragment actions. The recovered physical item remains `porcelain fragment`; lab analysis adds the separate evidence item `new chemical`, which is used in comparisons. |
| `compare new chemical with LoBlo` | Valid in any room once `new chemical` and LoBlo are both in evidence, in either discovery order. Reports Methsparin/LoBlo on the fragment, a high blood level, the protein-binding interaction with Ebullion, and the pathologist's conclusion of Ebullion toxicity after both medicines were ingested. `compare LoBlo with new chemical` also works. |
| `compare new chemical with Allergone` | Valid in any room once `new chemical` and Allergone are both in evidence, in either discovery order. Reports no match with the label. `compare Allergone with new chemical` also works. |

### Living Room

| Action | Result / follow-up |
| --- | --- |
| `inspect letter` | Valid after entry 2. Reports the addressee and July 6, 1982 postmark visible on the envelope. |
| `read letter` | Valid after entry 2. Presents Steven's letter to Leslie in his own words. It offers comfort, mentions Marshall's business troubles and George's threats, promises Leslie will be provided for, and closes with a declaration of love and a shared future. |
| `inspect <suspect>` | Gives a brief visible impression only; it does not expose inventory or hidden state. Mrs. Robner is visibly anxious. |
| `search <suspect>` | In public, the suspect refuses and no search occurs. Search a suspect only during that person's private interview, framed as consensual. |

The letter cannot be read from another room and cannot be read before it is
delivered. The player can leave and return if they have not yet visited the
Living Room a second time.

## Suspect questions and interviews

The only question form is `ask <person> about <topic>`. “Alibi” is a topic,
not an inspectable object. Use the exact topic names in the table; a public
answer may be guarded, while a private answer gives the fuller account.
In this bounded version, either private `alibi` or `concert` questioning
provides the relevant source account. It stands in for the source ticket
question; the ticket itself is omitted, so Baxter's ticket-specific opening
sentence is not used.

| Person | Allowed topics | Public answer | Private answer |
| --- | --- | --- | --- |
| **Baxter** | `alibi`, `concert`, `Focus`, `ladder`, `Dunbar`, `George`, `Mrs. Robner`, `death` | Uses source answers where available. His public concert answer names Beethoven, Sibelius, and Ravel but gives no account of Dunbar leaving. | Adapts the source ticket response to a private concert question: says Dunbar became ill at intermission and hired a car home. |
| **Dunbar** | `alibi`, `concert`, `LoBlo`, `Baxter`, `George`, `Mrs. Robner`, `new will`, `death` | Uses source answers where available. Publicly denies knowing what is meant by concerts. | Adapts the source ticket response to a private concert question: says they attended together and Baxter took her home. Acknowledges LoBlo if it has been found. |
| **George** | `alibi`, `new will`, `inheritance`, `Focus`, `Baxter`, `Mrs. Robner`, `death` | Gives a short account; is evasive about the will. | Explains his reaction to the new will, but has no evidence tying him to the poison or cup switch. |
| **Mrs. Robner** | `alibi`, `letter`, `Steven`, `Baxter`, `George`, `Dunbar`, `death` | Uses the source's brief answers where available. | When shown the letter, uses the source response about opening her mail and calls Steven an old school friend. The original lover confession depends on the omitted phone-call sequence, not this letter. |

### Interview and search rules

1. `interview privately <person>` is valid only in the Living Room and only
   when no other private interview is active. It is an invitation to speak
   privately, not a formal arrest. The interview location is unspecified; the
   unnamed uniformed patrol officer remains with the other suspects.
2. During the interview, only `ask <interviewee> about <allowed topic>`,
   `show <evidence> to <interviewee>`, and `search <interviewee>` are valid
   suspect-directed actions. Asking a different suspect is invalid because
   that person is not in the private scene.
3. Private suspect searches are consensual in the fiction. Searching in
   public yields a refusal and no inventory; it does not secretly count as a
   search.
4. `search Dunbar` in her private interview finds LoBlo. `search Mrs. Robner`
   finds a bottle labeled Allergone, without interpreting its
   significance. The bounded comparison action can then compare the fragment
   trace against those labels. Searches of Baxter and George report no
   relevant item.
5. `return <interviewee>` ends the interview and returns the
   person to the patrol officer's supervision with the others. Only the
   person currently in the interview can be returned.
6. After any valid accusation, show two choices: `close the case` or
   `continue investigating`, unless the accusation reaches either episode
   limit. The episode ends immediately and takes precedence over this choice;
   if both limits are reached together, the 50-action limit takes precedence.
   Closing resolves the full accusation record and ends the episode.
   Continuing returns to the investigation with the current evidence and all
   previously named suspects intact. Accusations made after continuing are
   added to the same record. Do not frame either option as “safe” or reveal
   that Baxter will kill Dunbar in the epilogue.

### Evidence confrontation

`show <person> <evidence>` is accepted only for these pairings:

- `show Dunbar LoBlo`: public denial/deflection; private acknowledgment
  that it is her medicine, without automatically proving its use on Robner.
- `show Dunbar fragment` or `show Baxter fragment`: public denial;
  private responses acknowledge access or opportunity but do not confess.
- `show Baxter Focus papers` or `show Baxter papers`: public deflection; private response confirms
  the business dispute, not the murder.
- `show George new will`: public evasion; private response confirms the
  inheritance motive.
- `show Mrs. Robner letter`: uses the source response about opening her
  mail and calls Steven an old school friend. The original affair confession
  requires the omitted phone call and is not established here.

All other evidence/person combinations are invalid. Showing evidence never
changes its identity or makes a weak clue conclusive by itself.

## Accusation outcomes

- Accusation actions are available whenever their target is present, whether
  or not the player has found evidence. Suspects are present together in the
  Living Room; during a private interview, only the interviewee is present.
  Joint accusations are available only in the Living Room. The only supported
  joint command forms are George and/or Mrs. Robner without either true
  culprit, or both Baxter and Dunbar with optional additional innocent
  suspects. Separate accusation actions can accumulate any combination over
  multiple investigate/continue cycles. No accusation combination is shown
  as a selectable list. There is no separate hidden “conclusion prompt.”
- Every accusation opens two choices: `close the case` and
  `continue investigating`, unless that accusation reaches the successful-
  action or submitted-call limit. At either limit, the episode ends immediately
  and takes precedence over the choice; if both limits are reached together,
  the successful-action limit takes precedence. Accused names remain visible
  in the case notes and machine observation. Continuing preserves those names;
  later accusations add to the same record. The prompt is not repeated in the
  ending report.
- `close the case` ends the playable episode using the accumulated accusation
  record. If Dunbar is the only true culprit named, any unsupported charges
  against other named people are dropped and she is charged as the sole
  remaining suspect; Baxter remains uncharged. The newspaper epilogue reports that
  Dunbar was released on bail while awaiting trial and that the prosecutor
  was considering a plea deal in exchange for information about an
  accomplice. Dunbar is later found shot in her bedroom beside a pistol and a
  forged suicide note. The epilogue explains that Baxter staged the scene to
  silence her. No in-game movement or bail mechanics are simulated.
- `continue investigating` returns to normal exploration with all collected
  evidence and previous accusations intact. The player can investigate
  further and add other suspects to the accusation record.
- Accusing George, Mrs. Robner, or both without naming either true culprit
  closes the case as a suicide for lack of evidence connecting those accused
  to the poisoning.
- If Baxter is named and Dunbar is not, the case follows the Baxter-only
  report. Any unsupported extra accusation is dropped. If the
  evidence gives the prosecution a motive and method but does not identify
  Dunbar's role, the jury acquits Baxter; with less evidence, the District
  Attorney declines to pursue the charge.
- If Dunbar is named and Baxter is not, the case follows the Dunbar-only
  newspaper ending. Any unsupported extra accusations are dropped; Dunbar is
  the sole remaining suspect charged, and Baxter remains uncharged.
- Accusing both Baxter and Dunbar together with George and/or Mrs. Robner
  closes the case as an overbroad accusation. Unsupported charges against the
  additional suspect are dropped. With the complete evidence chain, Baxter
  and Dunbar are convicted; without it, the murder case remains unproved.
- If both Baxter and Dunbar are named, with or without additional suspects,
  the case follows the joint-accusation path: the exact pair can be convicted
  with the full evidence chain, while additional unsupported charges are
  dropped. Without the evidence, the case remains unproved.
- The exact Baxter-and-Dunbar accusation is the route to the complete
  solution. There is no
  required accusation order. The original strong arrest branch requires the
  lab report, Baxter papers, read note-pad impressions, and Dunbar's ticket
  questioning (`OBJECT-PAIR-F` in `actions.zil`). This bounded version maps
  those to the LoBlo comparison, **reading** Focus papers, shading the note
  pad, and both private concert accounts (the ticket object is omitted). It
  additionally requires finding Dunbar's LoBlo, per the bounded evidence
  chain. Merely opening the safe does not satisfy the Focus-paper condition.
  Counting china and inspecting the holes are optional observations, not
  requirements for the original strong branch. Missing required groups
  produces a weak joint-case outcome. The five accusation paths above remain
  distinct in the case report; evidence determines whether a joint charge
  results in conviction.

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
- `compare new chemical with LoBlo` before both the analyzed Garden chemical and
  Dunbar's LoBlo have been found is invalid.
- `interview privately George` while in the Library or while another person
  is already being interviewed is invalid.
- `ask Dunbar about LoBlo` while Baxter is the private interviewee is
  invalid; asking Dunbar publicly in the Living Room is valid but guarded.
- `return Baxter` during Dunbar's interview is invalid.
- `close the case` or `continue investigating` before any accusation is
  invalid.
- `accuse Baxter` in the Library, when Baxter is not present, is invalid.
- `accuse Baxter` during Dunbar's private interview is invalid.
- `accuse Baxter and Dunbar` during a private interview is invalid because
  both suspects are not present together.

Invalid actions never reveal hidden facts. The episode limit is exactly 50
successful player actions. Movement, questions, interviews, searches,
evidence checks, accusations, and the `close the case` / `continue
investigating` choice count toward the same limit. Reaching the successful-
action limit ends the episode immediately, including when the 50th action is
an accusation that would otherwise open the close/continue choice. Malformed
or context-invalid calls do not consume an in-story action, but every
submitted call counts against the separate model-call limit. Reaching the
submitted-call limit also ends the episode immediately, including after an
accusation; if both limits are reached together, the successful-action limit
takes precedence. There is no real-time clock.

## Decisions to make before implementation

All action names, evidence results, the omitted ticket item, accusation
requirements, and the 50-successful-action limit above are settled
implementation defaults. Do not add alternate ticket actions, extra endings,
different lab steps, or a real-time clock without Erica's direction.
