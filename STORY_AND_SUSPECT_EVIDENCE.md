# Deadline: story and suspect evidence guide

**Spoilers.** This is a source-based reference for selecting and cutting story
material. It summarizes clues and implications; it is not a transcript. The
student reports that the instructor approved using the original names and
story for the course project.

## The central case

Marshall Robner is found dead in the estate library. It initially appears to
be suicide: Robner was depressed, took Ebullion for depression, and that drug
can be fatal in a large dose. The actual solution given in the source's
epilogue is a two-person conspiracy:

- **Baxter planned the murder.** He wanted to protect his position and
  business plans, and prevent Robner from exposing his role in the Focus
  financial scandal. He later used the garden ladder to get into the library
  and switch the incriminating teacup.
- **Dunbar administered the poison.** LoBlo, her blood-pressure medicine,
  was put in Robner's tea. Its interaction with Robner's Ebullion caused a
  fatal overdose effect.
- **Baxter and Dunbar were lovers and attended a concert together** on the
  night Robner died. They concealed this connection, which complicates their
  alibis.

The author's summary is in `actions.zil`, `EPILOGUE`. The game's strongest
confirmation is the lab report (`dungeon.zil`, `LAB-REPORT`), the Focus papers
and pressure-impression note (`dungeon.zil`, `BAXTER-PAPERS`; `actions.zil`,
`NOTE-PAPER-F`), and the concert-ticket questioning (`actions.zil`,
`DUNBAR-F`, `BAXTER-F`). The source's complete-conspiracy arrest branch
requires the player to have the Focus papers, lab report, read the note
impressions, and asked Dunbar about the ticket (`actions.zil`,
`OBJECT-PAIR-F`).

## People and how suspicious the source makes them

| Person | Source's role in the mystery | What can make the player suspect them | Assessment in the source |
| --- | --- | --- | --- |
| **Baxter** | Business partner; planner and cover-up participant | Motive in the Focus scandal; the note-pad impression; incriminating Focus papers; ladder route into the library; inconsistent account of Dunbar's concert trip; concealed relationship with Dunbar; evasiveness about the note, Focus, and ladder | **Guilty.** Planned the murder and changed the cup after the poisoning. |
| **Dunbar** | Robner's assistant; poisoner and Baxter's accomplice | Her bathroom contains LoBlo; the shard contains LoBlo; she has fingerprints on the saucer and sugar bowl; she concealed attending the concert with Baxter; her ticket is found during the outdoor sequence; nervous response when confronted | **Guilty.** Put LoBlo in the tea. |
| **George Robner** | Robner's son | The new will disinherits him; he has a history of financial demands and conflict with his father; Steven's letter mentions George's threats; he tries to find or destroy the new will; he may throw it into the lake; he knew about the hidden safe and, according to Dunbar, knew about her medicine | **Red herring / plausible suspect.** He has motive and suspicious behavior, but the source's final explanation does not make him part of the murder. |
| **Mrs. Leslie Robner** | Robner's wife | She inherits under the new will; the letter mentions Steven and says she will be provided for if the unthinkable happens; the separate phone-call sequence and later confrontation reveal her relationship with Steven and plans for a future together; she had access to the house and kitchen; Rourke gossips about her callers; she resists the inspector opening her mail | **Red herring / plausible suspect.** The source's affair and inheritance clues are suspicious, but it gives no evidence that she executed or planned the murder. The bounded game includes the letter but omits the phone-call sequence, so it does not establish the affair. |
| **Mrs. Rourke** | Housekeeper and gossip; witness to household relationships | Works in the kitchen and has broad access to the house; delivers Mrs. Robner's mail; knows about the residents' private relationships and openly dislikes Baxter | **Weak/ambient suspicion only.** The game treats her as one of the household suspects to ask about, but gives no concrete murder evidence against her. |
| **Steven** | Mrs. Robner's offstage lover; author of the letter | The letter suggests that he and Mrs. Robner planned to be together after a divorce, and the phone call confirms a private relationship. He might look like a potential accomplice or beneficiary. | **Offstage red herring.** No evidence links him to the poisoning, cup swap, or Focus motive. He is not a moving suspect character. |
| **Mr. McNabb, the gardener** | Witness to the rose-garden disturbance; owns/uses the ladder | The ladder is his gardening tool; he works near the holes and shard in the roses; he is angry about damage to the garden | **Incidental suspicion, not supported.** His observations lead the player to physical evidence; the source gives him no motive or link to the murder. |
| **Mr. Coates** | Robner's lawyer; will-reading participant | He knows about the wills and arrives shortly before the reading. | **Not meaningfully implicated.** The source does not provide a murder motive or crime evidence against him. |
| **Sergeant Duffy** | Police assistant who handles lab work and arrests | Appears wherever analysis or arrest is needed. | **Not a suspect.** He functions as an investigator's support character. |
| **Chief Inspector Klutz** | Appears if the deadline expires | Arrives at the 8 p.m. time limit. | **Not a suspect.** Ending-only character. |
| **Marshall Robner** | Victim | His medication, depression, business conflict, and will are relevant to how the death is interpreted. | Deceased before the playable investigation begins. |

The game's explicit “who might be a murderer?” response table includes Baxter,
Dunbar, George, Mrs. Robner, and Rourke (`actions.zil`, `MURDER-TABLE`).
Steven and McNabb are plausible player suspicions from the surrounding
story, but the source does not treat them as equally supported suspects.

## Evidence, by where it is found

### Library

| Evidence | What it says or suggests | Suspicion it can create | Source locator |
| --- | --- | --- | --- |
| Robner's body and Ebullion bottle | Robner took an antidepressant that can be fatal in a high dose. This supports the initial suicide explanation. | Could make the death appear self-inflicted and hide the poisoning. | `dungeon.zil`, `LIBRARY`, `EBULLION-BOTTLE`; `actions.zil`, `CORPSE-F` |
| Teacup on the floor | Contains tea and a brown discoloration. The cup itself yields Robner's fingerprints only. | Establishes the tea as a possible delivery route; the clean cup can conceal a swap. | `dungeon.zil`, `CUP`; `actions.zil`, `CUP-F`, `I-FINGERPRINT` |
| Saucer and sugar bowl on/near the tray | Lab analysis finds both Robner's and Dunbar's fingerprints; the sugar bowl contains ordinary sugar. | Shows Dunbar handled the tea service, but does not alone prove poisoning. | `dungeon.zil`, `TRAY`, `SAUCER`, `SUGAR-BOWL`; `actions.zil`, `I-FINGERPRINT` |
| Note pad on the desk, with pencil nearby | Careful shading/lighting reveals pressure impressions referring to Baxter and the Focus matter, though only fragments are legible. | Gives Baxter a concrete motive and links him to Robner's final business concerns. | `dungeon.zil`, `NOTE-PAPER`; `actions.zil`, `NOTE-PAPER-F`, `PAD-READ` |
| Desk calendar | July 7 lists a meeting with Baxter; July 8 records that Robner called Coates because the will was completed. | Points toward a recent business meeting and the new will; the latter also gives George a motive. | `dungeon.zil`, `DESK-CALENDAR`; `actions.zil`, `DESK-CALENDAR-F` |
| Hidden closet and safe behind/near the library | The safe contains Focus papers incriminating Baxter and a new will leaving the estate to Mrs. Robner and disinheriting George. | Strongly implicates Baxter in a separate financial crime; creates a strong inheritance motive for George and a benefit for Mrs. Robner. | `dungeon.zil`, `HIDDEN-CLOSET`, `SAFE`, `BAXTER-PAPERS`, `NEW-WILL`; `actions.zil`, `LIBRARY-BUTTON-F`, `GEORGE-HACK-3` |
| Crumpled papers in the wastebasket | Includes stock prices and an unfinished letter to the board, but the letter has too little information to identify its purpose. | Suggests business stress without resolving who acted. | `dungeon.zil`, `TRASH`; `actions.zil`, `TRASH-F` |

The source cup and saucer are both described as attractive, hand-painted
china; it does **not** establish that they visibly fail to match. The
important pattern is the cup-switch theory, the missing kitchen cup, the
shard, and the lab results.

### Kitchen

| Evidence | What it says or suggests | Suspicion it can create | Source locator |
| --- | --- | --- | --- |
| Cup and saucer counts | The china includes six cups and seven saucers, while the library scene has a cup and saucer. | Supports the idea that a cup was removed/replaced as part of a cover-up. | `dungeon.zil`, `CUPS`, `SAUCERS`, `CHINA`; `actions.zil`, `CUPS-F`, `SAUCERS-F`, `CHINA-F` |
| Household meal and tea service | Rourke and Mrs. Robner work in/visit the kitchen; the tea set offers ordinary access to the victim's drink. | Gives household staff or family opportunity, but is not person-specific proof. | `dungeon.zil`, `KITCHEN`; `goal.zil`, `MOVEMENT-GOALS`; `actions.zil`, `ROURKE-F`, `MRS-ROBNER-F` |

### Dunbar's bathroom

| Evidence | What it says or suggests | Suspicion it can create | Source locator |
| --- | --- | --- | --- |
| LoBlo bottle in Dunbar's cabinet | Label identifies it as Dunbar's blood-pressure medication and warns of dangerous interactions with other drugs. | Gives Dunbar access to the substance later found in the shard and Robner's blood. | `dungeon.zil`, `DUNBAR-CABINET`, `LOBLO-BOTTLE`, `LOBLO`; `actions.zil`, `DUNBAR-F` |
| Other medicine bottles | Aspirin and cough medicine are also stored there; they are not identified as the cause of death. | Can add noise if the game presents every bottle as equally important. | `dungeon.zil`, `ASPIRIN-BOTTLE`, `DUM-KOF-BOTTLE` |

### Master bathroom

| Evidence | What it says or suggests | Suspicion it can create | Source locator |
| --- | --- | --- | --- |
| Mrs. Robner's medicine | The bounded game finds one bottle labeled Allergone. Its source label warns against combining it with alcohol, but the source does not connect it to Robner's death. | A player may suspect that she had access to medication; this is a weak false lead. | Bounded selection from `dungeon.zil`, `ALLERGONE-BOTTLE`; `actions.zil`, `MRS-ROBNER-F`, `ANALYSIS-PRINT` |

### Rose garden and orchard route

| Evidence | What it says or suggests | Suspicion it can create | Source locator |
| --- | --- | --- | --- |
| Two compacted holes and crushed roses | McNabb says he found two deep holes in the garden that morning. They are consistent with a ladder having been planted there. | Shows recent ladder use and creates an opportunity route; does not identify who used it. | `dungeon.zil`, `HOLE`; `actions.zil`, `GARDENER-F`, `HOLE-F`, `SHOW-HOLE` |
| Porcelain fragment in the rose holes | Search around the holes can uncover a dirty shard. Cleaning it shows china like the kitchen set. | Connects the garden disturbance to the missing cup and possible cover-up. | `dungeon.zil`, `FRAGMENT`; `actions.zil`, `HOLE-F`, `FRAGMENT-F` |
| Lab results from the fragment | First analysis finds traces of tea and sugar plus an unidentified chemical, without useful fingerprints. Comparing it with LoBlo identifies Methsparin/LoBlo; the report explains its interaction with Robner's Ebullion. | Establishes murder by poisoning and links the tea/cup to Dunbar's medicine. | `dungeon.zil`, `LAB-REPORT`; `actions.zil`, `DO-FINGERPRINT`, `I-FINGERPRINT` |
| Ladder and balcony route | The ladder begins in the shed and can be positioned against a balcony. The library/house layout allows an intruder to reach the library from outside. | Supports Baxter's opportunity and cup-switching theory; ladder analysis does not produce a useful identifying fingerprint result. | `dungeon.zil`, `LADDER`; `actions.zil`, `LADDER-F`, `MASTER-BEDROOM-F`, `LIBRARY-BALCONY-F` |

### Dunbar's concert ticket and the alibi

| Evidence | What it says or suggests | Suspicion it can create | Source locator |
| --- | --- | --- | --- |
| Hartford Philharmonic ticket stub | The stub is dropped by Dunbar during the accusation/following sequence, rather than sitting in a fixed room at the start. It is for the concert on the night Robner died. | Dunbar first minimizes her concert connection, then says she attended with Baxter. Baxter's account says she became ill and left early. The mismatch and concealed relationship tie the pair together and weaken their alibi. | `dungeon.zil`, `STUB`; `actions.zil`, `I-DUNBAR-SEQ-D`, `DUNBAR-F`, `BAXTER-F` |
| Rourke's gossip about Dunbar and Robner | Rourke says Robner spent much time with Dunbar and Mrs. Robner may have been jealous. | Can redirect suspicion toward Dunbar or Mrs. Robner, but is gossip rather than direct proof. | `actions.zil`, `ROURKE-F` |

### Foyer, phone, and newspaper

| Evidence | What it says or suggests | Suspicion it can create | Source locator |
| --- | --- | --- | --- |
| Letter addressed to Mrs. Robner | Steven's letter comforts Leslie, refers to Marshall's business troubles and George's threats, promises Leslie will be provided for, and speaks of love and a future together. | Strongly suggests an intimate relationship between Steven and Leslie; it does not connect either of them to the poisoning. | `dungeon.zil`, `ENVELOPE`, `LETTER`; `actions.zil`, `I-MAIL`, `ENVELOPE-F`, `LETTER-F` |
| Telephone call with Steven | If overheard, Mrs. Robner and Steven discuss a private future together. Later, once the letter and call are confronted together, she admits they were lovers and had discussed marriage after a divorce. | Strongly suggests an affair and a possible motive for Mrs. Robner or Steven, but does not connect them to the poisoning or cup. | `actions.zil`, `I-CALL`, `TELEPHONE-F`, `MRS-ROBNER-F` |
| Newspaper's merger story | Reports that Baxter is arranging a merger and quotes him as saying Robner approved it. George says Robner opposed losing control of the company. | Strengthens the business motive against Baxter and exposes a disagreement about what Robner wanted. | `actions.zil`, `NEWSPAPER-F`, `READ-SECOND-SECTION`, `GEORGE-F` |

## Suspicion trails, summarized

- **Baxter:** Focus papers establish the scandal; the note impressions suggest
  Robner meant to act against him; the newspaper and interviews establish the
  merger conflict; the ladder and missing cup/shard establish opportunity and
  a cover-up; the ticket/alibi establishes a concealed connection to Dunbar.
- **Dunbar:** Her prescription bottle establishes access to LoBlo; the shard
  and lab report establish LoBlo in the tea and the fatal interaction; the
  saucer/sugar-bowl prints show contact with the service; the ticket and
  changing account connect her to Baxter on the night of death.
- **George:** The new will gives a motive; his search for the safe and attempt
  to remove the will look like concealment; the letter and Dunbar's accusation
  reinforce suspicion. These facts do not explain the poisoned tea and
  cup-switching as coherently as the Baxter/Dunbar theory.
- **Mrs. Robner / Steven:** The letter, inheritance, Rourke's gossip, and
  overheard call suggest a relationship and a possible benefit from Robner's
  death. There is no corresponding physical link to the cup or LoBlo.
- **Rourke / McNabb:** Household access and proximity create broad suspicion;
  Rourke's testimony and McNabb's garden observations actually help explain
  the evidence. Neither has a specific physical or motive link to the murder.

## Secondary murder and accusation branch

The case can continue dangerously if the player accuses Dunbar after
discovering the LoBlo connection. She starts looking for Baxter; the pair
meet near/in the shed. If the player does not interrupt them, Baxter later
shoots Dunbar, leaves her with a forged suicide note, and tries to escape via
the bedroom balcony/orchard route. The gun, note, Baxter's flight, and other
residents' reactions can create a second mystery or reveal the conspiracy.
This is conditional, not a fixed part of every playthrough. Evidence:
`actions.zil`, `DUNBAR-SEQUENCE`, `I-DUNBAR-SEQ*`, `HEAD-FOR-CLIMAX`,
`I-BAXTER-SEQ`, `I-BAXTER-ESCAPE`, `SHOT-FIRED-F`, and `I-SHOT`.

## Other story content that can be cut independently

The source also includes the will reading, George's hidden-safe/new-will
sequence, the newspaper arrival, Coates's visit, dynamic daily schedules,
the secret closet, and several alternative arrest/court outcomes. These
support red herrings and pacing but are not all required to explain the
poisoning, Baxter's Focus motive, or the cup-switch cover-up.

## Source map

- **Actual solution:** `actions.zil`, `EPILOGUE`.
- **Formal suspect set:** `actions.zil`, `MURDER-TABLE`; character identities
  and initial placements: `goal.zil`, `CHARACTER-TABLE`; `dungeon.zil`,
  `People`.
- **Object locations and descriptions:** `dungeon.zil`, objects named in the
  evidence tables above.
- **Interviews and contextual clues:** `actions.zil`, `BAXTER-F`, `DUNBAR-F`,
  `GEORGE-F`, `MRS-ROBNER-F`, `ROURKE-F`, `GARDENER-F`, and `COATES-F`.
- **Laboratory and final accusation logic:** `actions.zil`, `DO-FINGERPRINT`,
  `I-FINGERPRINT`, `OBJECT-PAIR-F`.
