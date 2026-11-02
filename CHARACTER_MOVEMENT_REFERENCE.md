# Deadline: character movement reference

This is a design reference for deciding what to keep in a bounded adaptation.
It summarizes the source's people, scheduled destinations, and major
story-triggered movement. It does not reproduce dialogue or describe every
room-to-room step.

## How to read the schedule

- The episode begins at **8:00 a.m.** (`PRESENT-TIME = 480`). A normal player
  action advances the game clock by one minute. See `actions.zil` (global
  `PRESENT-TIME`) and `clock.zil` (`CLOCKER`).
- The movement table gives each person a sequence of destination goals and a
  delay before each goal. Delays have random variation (usually ±10, ±15,
  ±20, or ±30 minutes). The game routes the person through the house/grounds;
  the table's time is when a goal is set, not a guarantee of exact arrival.
- Player actions, conversation/attention, locked doors, story events, and
  interruptions can delay, replace, or cancel a goal. Treat the windows below
  as approximate intended timing, not a deterministic timetable.
- A dash means the source does not give that person a regular timetable.

Primary evidence: `goal.zil`, `MOVEMENT-GOALS`, `IMOVEMENT`, and each
character's `I-*` routine; starting placements are in `dungeon.zil` under
`People`; arrival and plot interrupts are in `main.zil` and `actions.zil`.

## Main cast and their routine movement

| Person | Starting state at 8:00 | Approximate schedule of destination goals | Notes |
| --- | --- | --- | --- |
| Inspector (player) | South Lawn, outdoors | Player-controlled; no autonomous route. | The investigation clock advances as actions are taken, with the case ending at 8:00 p.m. |
| Mr. McNabb, the gardener | North Lawn | Around 9–10: North Lawn; 10–11: East Lawn; 11–1: Rose Garden; 1–2: Orchard; 2–3: South Lawn; 3–5: West Lawn. | At Rose Garden he may talk about damaged roses. At Orchard he may move the ladder. If the player investigates the rose holes, he can divert to the rose area and show them. |
| Mr. Baxter | Offstage until arrival around **9:55**; enters at South Lawn. | Around 10:00: Living Room; around 4:00 p.m.: South Lawn, then he leaves in a limousine. | The Living Room visit can transfer a book to him. Later he may leave early or be rerouted by the accusation/secret-meeting plot. |
| Ms. Dunbar | Living Room | Around 9:00: Dunbar's Bathroom; 9:30–11:30: Dunbar's Room; 11:30–2:00: Living Room; after about 2:00: Dunbar's Room. | The scheduled route is overridden by the accusation/secret-meeting sequence. |
| George Robner | George's Room | Around 9:20: Kitchen; 9:50–11:00: Dining Room; 11:00–11:45: George's Room; 11:45–12:30: Living Room; 12:30–2:00: East Lawn; 2:00–3:00: Living Room; after 3:00: George's Room. | At George's Room, he may turn on the stereo. At North Lawn, a separate story event can cause the new will to end up in the lake. The will reading can trigger him to leave for his room. |
| Mrs. Leslie Robner | Living Room initially; after welcoming the inspector, she goes to the Kitchen. | Morning: Dining Room twice; late morning/noon: Living Room; early afternoon: Master Bedroom; later: Living Room. The source comments describe intended windows of about 8:30–9:00, 10:10–11:10, 11:10–12:40, 12:40–1:50, then back to the Living Room. | These comments are approximate; the actual schedule has random offsets. Telephone events can draw her to the Living Room or send her to the Master Bedroom. |
| Mrs. Rourke, the housekeeper | Kitchen | Around 9–10: Kitchen; 10–11: Dining Room; 11–1: Kitchen; 1–2: Living Room; 2–3: Rourke's Room. | She can be diverted to retrieve mail for Mrs. Robner and then return to her room. Her room is her resting destination. |
| Mr. Coates, the lawyer | Offstage until arrival around **11:50–11:54**; enters at South Lawn. | Goes to the Living Room for the will reading; leaves by car after the reading. | The reading may wait for key attendees and for the player to come to the Living Room. Late/missed-reading branches alter the timing. |

Other named people do not have normal daily routes:

| Person | Movement / appearance |
| --- | --- |
| Marshall Robner | Already dead before the investigation begins. His body is found in the Library; he has no movement during the episode. In the conditional late-game sequence, Dunbar's body is separately moved to her room and a corpse object is placed there. |
| Sergeant Duffy | An off-map police assistant rather than a character with a simulated location. The source treats him as immediately available for lab work and arrests; he appears in specific arrest endings and investigation events. |
| Chief Inspector Klutz | Has no ordinary route. If the clock passes 8:00 p.m., he appears to end the episode and escort the player away. |
| Mailman and paperboy | Brief offstage delivery events only; neither has a persistent location or route. |
| Drivers / limousine | Vehicles and drivers are described at arrivals and pickups, but are not modeled as characters with independent movement. |

The gardener through Rourke schedules are encoded as destination intervals in
`goal.zil` under `MOVEMENT-GOALS`. The table comments there are the source for
the human-readable schedule labels. The character start locations and
Coates's initial offstage state are in `dungeon.zil`.

## Timed arrivals and offstage people

These are clock-triggered events, relative to the 8:00 a.m. start:

| Approximate time | Event / movement |
| --- | --- |
| About 9:00–9:10 | A telephone call rings. Depending on where Mrs. Robner is and what the player does, she may move toward the Living Room, take a private call in the Master Bedroom, or resume her route. |
| About 9:10–10:10 | Mail is delivered. The mailman appears only as a brief event; the envelope is placed with the player, in the Foyer, or on the Foyer Table depending on location. Mrs. Rourke may then be sent to retrieve it and take it to Mrs. Robner. |
| 9:55 | Baxter arrives by limousine at the South Lawn. |
| About 10:55–11:35 | A newspaper is thrown to the Front Path by an offstage paperboy; the paperboy does not enter the playable map. |
| About 11:50–11:55 | Coates arrives by car at the South Lawn and heads for the Living Room. |

The random arrival offsets are set in `main.zil` (`I-START-INTERRUPTS`). The
events are implemented in `actions.zil` (`I-CALL`, `I-MAIL`, `I-NEWSPAPER`,
`I-BAXTER-ARRIVE`, `I-COATES-ARRIVE`). The mailman and paperboy have no
persistent character location or route in the source.

## Will-reading movement and convergence

Coates starts the reading when he reaches the Living Room. If it is before
12:40 p.m. and Mrs. Robner, Dunbar, Baxter, or George is elsewhere, he waits
for them. This means their scheduled goals and the player's movement can
change when the reading begins. After the reading, Coates heads back to the
South Lawn for pickup. If the player is not in the Living Room, a wait/missed
reading branch can occur. See `actions.zil`, `I-COATES`, `I-WILL-READING`,
and `WILL-HACK`.

## Conditional routes and plot branches

These routes are not part of a fixed clock schedule. They depend on player
actions, presence, and other story state.

### Telephone route for Mrs. Robner

- A call can make her head to the Living Room, or return to the Master
  Bedroom for a private call. Blocking or interrupting the call can change
  her next destination.
- If the player picks up or overhears the call, the call state changes and
  she may be moved immediately or have her normal goal restored.
- Evidence: `actions.zil`, `I-CALL`, `ROBNER-CALL-MOVE`, `TELEPHONE-F`, and
  `ESTABLISH-CALL`.

### Mail route for Rourke and Mrs. Robner

- When the envelope is left in the Foyer or on its table, Rourke is directed
  to the Foyer. She takes it toward Mrs. Robner's current location. This can
  produce a handoff and then send Rourke back to her room.
- If the player already has or moves the envelope, the route and handoff
  differ.
- Evidence: `actions.zil`, `I-MAIL`, `I-MAIL-2`, and `I-MAIL-3`.

### Accusation and secret meeting

- A consequential accusation of Dunbar can start a sequence that redirects
  her and Baxter toward the same location. Their meeting is staged in/around
  the shed, with detours dependent on where Baxter is and whether the player
  follows or interrupts them.
- If the meeting proceeds to its climax, Dunbar runs toward her room and
  Baxter is routed via the North Lawn and bedroom balcony. A later gunshot
  causes Baxter to flee; Mrs. Robner, George, and Rourke are redirected
  toward the scene and then react or leave it.
- This is a chain of event checks and short queued delays, not a fixed
  time-of-day schedule. Evidence: `actions.zil`, `DUNBAR-SEQUENCE`,
  `I-DUNBAR-SEQ*`, `HEAD-FOR-CLIMAX`, `I-BAXTER-SEQ`, `I-BAXTER-ESCAPE`,
  `SHOT-FIRED-F`, and `I-SHOT`.

## Implications for a bounded adaptation

The source has seven autonomous non-player characters, multiple room/grounds
routes, random timing, attention pauses, telephone/mail diversions, a
will-reading convergence, and a conditional late-game murder sequence. A
small adaptation does not need all of these. A coherent cut could retain two
or three suspects, one meeting location, three clue-bearing destinations,
and a short fixed sequence of visits; make the culprit's route inferable from
clues rather than reproduce every original schedule. Keep only those
characters and movements that create a decision or reveal evidence.
