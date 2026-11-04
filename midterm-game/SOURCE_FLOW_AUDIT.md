# Source-flow audit for the bounded game

This audit compares every player-reachable bounded route with the original
source scripts. Source paths refer to `../actions.zil`, `../dungeon.zil`, and
`../goal.zil`. The original is a timed, moving-NPC investigation; the bounded
game deliberately compresses that structure. This document distinguishes a
source match from a bounded substitute rather than presenting substitutes as
original rules.

## Route map

| Bounded route | Dependencies and result | Source alignment / bounded change |
| --- | --- | --- |
| Start → leave Living Room → return → inspect/read letter | The letter is unavailable before the second Living Room entry. `inspect letter` gives envelope facts; `read letter` summarizes what it says. | Source delivers a letter to Mrs. Robner (`I-MAIL`, `ENVELOPE-F`, `LETTER-F`). The letter alone does not confirm an affair. The lover confession requires the separate call sequence (`I-CALL`, `TELEPHONE-F`, `MRS-ROBNER-F`); the bounded case omits it. |
| Living Room → public questions | Only listed people/topics are accepted. Public replies use the source lines where the same subject exists. A public search is refused and finds nothing. | Original suspects can be addressed in a fuller parser and schedule. Fixed roster and topic interface are bounded adaptations. |
| Living Room → private interview mode → questions/search → return | Invite one suspect. No room is assigned to the interview. The officer stays with the others. Interviewee-only questions, evidence shows, and search are accepted. Returning restores the group scene without counting as a room departure or new Living Room entry. Dunbar's search finds LoBlo; Mrs. Robner's search finds one bottle labeled Allergone; Baxter/George have no relevant item. | Original NPCs move on schedules; Dunbar's LoBlo is in her bathroom (`DUNBAR-BATH`, `LOBLO-BOTTLE`); Mrs. Robner's bottles are in the master bathroom (`ALLERGONE-BOTTLE`, `SNEEZO-BOTTLE`). The bounded version retains Allergone only. The private interview, consensual person-search, officer supervision, and medicine-on-person search are bounded adaptations. The private concert topic uses the source ticket-questioning account but omits Baxter's ticket-stub setup because the bounded design has no ticket item. |
| Library → crime-scene examination and lab | Body, teacup, saucer, Ebullion, desk, and notepad can be inspected. Cup and saucer analysis reports their fingerprints and contents. The sugar bowl is not an interactive evidence action in the bounded case. Inspect notepad, then shade it to read the impression. | The source has these objects and note-pad mechanics (`NOTE-PAPER`, `NOTE-PAPER-F`, `PAD-READ`, `EBULLION-BOTTLE`, `CUP`, `SAUCER`, `SUGAR-BOWL`). The bounded wording compresses the source results and omits the sugar bowl interaction as it adds no required case evidence. Ebullion's source label directions and warning are preserved; the source provides no numeric blood-level or therapeutic-range figures. |
| Library → bookcase → safe → Focus papers/new will | Inspecting the bookcase allows searching it; opening the safe identifies two documents without summarizing them. Either `read papers` or `read Focus papers` gives the same Focus-paper result and satisfies the complete-case requirement. New will can be read independently. | Source bookcase discovery occurs after George moves books and exposes a button/closet/safe (`LIBRARY-BUTTON-F`, `HIDDEN-CLOSET-F`, `SAFE-F`). Notepad shading is not a source prerequisite. The always-available bounded bookcase route and removal of the hidden closet/combination are adaptations. Reading the Focus papers reveals Baxter's embezzlement and cover-up; reading the will reveals George's disinheritance (`BAXTER-PAPERS`, `NEW-WILL`). |
| Kitchen → tea service and count | China inspection describes the painted scenes; count reports eight plates, seven saucers, and six cups. | Source count is six hand-painted cups, seven hand-painted saucers, and eight large/small plates (`CUPS-F`, `SAUCERS-F`, `CHINA-F`). The player infers a missing cup; the result does not state that inference. |
| Garden → holes → fragment → clean → analyze | Inspect holes reports size/depth/compacted soil; search finds the fragment and cut finger. Cleaning reveals the design; analysis reports tea/sugar, another chemical, no clear prints, and not Ebullion. | Hole and fragment behavior derives from `HOLE-F` and `FRAGMENT-F`. Hole inspection alone does not label the holes as ladder prints. The source search has repeated digging and occasional empty results; bounded `search holes` always finds the shard. The bounded game omits the ladder, rose-garden schedule, crushed-rose witness, and physical entry route. Pattern comparison only becomes available after examining the Kitchen china and cleaning the fragment. |
| Garden → compare new chemical with LoBlo | Requires analyzed Garden chemical and found LoBlo. Either comparison order is accepted. Result identifies Methsparin/LoBlo, reports high blood level and protein-binding interaction, and gives the pathologist's cause-of-death conclusion. | Source lab report (`LAB-REPORT`) contains these facts. The bounded comparison action stands in for requesting and reading the report; it does not add a separate report item. |
| Garden chemical → compare with Mrs. Robner's Allergone | Requires analyzed fragment and prior private search that found Allergone; the evidence can be discovered in either order. The comparison alone reports no match. | User-requested bounded addition; source has no such comparison action or result. The search result does not characterize the medicine as safe or interpret the comparison for the player. |
| Show evidence to suspect | Only these pairings exist: LoBlo/Dunbar, fragment/Dunbar, fragment/Baxter, Focus papers/Baxter, new will/George, letter/Mrs. Robner. Replies are quoted as speech. | Text uses the corresponding source dialogue where present. The bounded fragment confrontation reuses the source lab-report response because the separate `LAB-REPORT` evidence item was omitted. Letter confrontation does not claim the affair confession that depends on the omitted phone call. |
| Accuse Dunbar → close or continue | Available whenever Dunbar is present, even before evidence is found. `close` ends with the incomplete-case newspaper story; `continue` preserves all evidence and lets the player pursue the joint accusation. | Source has an accusation/arrest sequence and a later plea-deal/staged-suicide branch (`DUNBAR-SEQUENCE`, `I-DUNBAR-SEQ*`). The two-button choice and immediate epilogue replace its timed sequence. |
| Accuse Baxter, George, or Mrs. Robner alone | Available whenever the named suspect is present. Each ends as an unsupported accusation unless later evidence rules change that result. | These single-target bounded endings collapse several source arrest/indictment branches into one outcome. The source has distinct Baxter, Mrs. Robner, and Baxter/George arrest outcomes, not this exact shared terminal action. |
| Accuse Baxter and Dunbar | Available in the Living Room, where both are present, at any point. A full result requires poison confirmation, found Dunbar LoBlo, both suspects' private alibi/concert accounts, read Focus papers, and shaded notepad. Without one or more, the ending is weak and names the missing source-style proof category. | Source complete branch (`OBJECT-PAIR-F`) requires the lab report, read Focus papers, note impressions, and Dunbar ticket questioning. The bounded version maps the report to the comparison action and the omitted ticket to the two private accounts, and retains found LoBlo as an additional bounded dependency. Either approved private topic (`alibi` or `concert`) records that suspect's account. China count and holes are optional, matching the source's complete-branch condition. |
| Episode ends | 50 successful actions or 60 submitted calls; calls are independently bounded. Either limit immediately overrides a pending accusation choice. | The source has an in-world time/deadline and NPC schedules, not this turn limit. Both limits are course-engine constraints, not *Deadline* mechanics. |

## Source details checked against player text

- The cup and saucer descriptions do not call them visibly mismatched. The
  source clue comes from the service count, fragment, and lab.
- Hole dimensions and compacted soil are reported without naming a ladder.
- Residues and chemical traces are revealed by analysis, not by cleaning.
- The initial lab result says the chemical is not Amitraxin/Ebullion; it does
  not identify LoBlo until the comparison/report.
- The original letter does not itself confirm an affair. The bounded game
  preserves its business, George, and provision details without importing the
  later phone-call confession.
- The source's strong arrest condition is checked from `OBJECT-PAIR-F`; the
  source's author explanation is `EPILOGUE`. Outcome text should keep those
  separate: the source's final explanation is not information the detective
  automatically receives from a single clue action.
- Suspect dialogue is direct speech in quotation marks. New connective
  narration remains outside quotes. Where a bounded topic has no source
  counterpart (for example, a generic alibi prompt), it is identified as an
  interface adaptation, not a source fact.
