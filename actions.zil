"ACTIONS for
			    DEADLINE
	Copyright 1982 Infocom, Inc.  All rights reserved.
"

<ROUTINE DDESC (STR1 DOOR STR2)
	 #DECL ((STR1) STRING (DOOR) OBJECT (STR2) <OR FALSE STRING>)
	 <TELL .STR1>
	 <COND (<FSET? .DOOR ,OPENBIT> <TELL "open">)
	       (T <TELL "closed">)>
	 <TELL .STR2 CR>>

<ROUTINE WEST-DOOR-F ("OPTIONAL" (RARG <>))
	 <COND (<AND <==? .RARG ,M-BEG>
		     <VERB? WALK>
		     <EQUAL? ,PRSO ,P?NE ,P?NORTH>
		     <IN? ,LADDER ,PLAYER>>
		<TELL ,NO-LADDERS CR>)>>

<GLOBAL NO-LADDERS 
"You've got to be crazy, carrying that ladder inside the house!">

<ROUTINE FRONT-PATH-F ("OPTIONAL" (RARG <>))
	 <COND (<AND <==? .RARG ,M-BEG>
		     <VERB? WALK>
		     <==? ,PRSO ,P?NORTH>
		     <IN? ,LADDER ,PLAYER>>
		<TELL ,NO-LADDERS CR>)
	       (<==? .RARG ,M-LOOK>
		<DDESC
"You are at the Robners' front door, which is "
		       ,FRONT-DOOR ".">
		<TELL
"You can walk around the house from here to the east or west. To the south a
rolling lawn leads to the entrance of the estate." CR>)>>

<ROUTINE ROSE-GARDEN-F ("OPTIONAL" (RARG <>))
	 <COND (<==? .RARG ,M-LOOK>
		<TELL
"You are at the edge of a large rose garden, meticulously maintained by the
gardener, Mr. McNabb. He is said to be exceedingly proud of this particular
garden, which is the envy of the neighbors. Rows of roses are neatly arranged
and the sweet fragrance of the flowers is worth a trip here in itself. An
orchard to the east contains many varieties of fruit trees and wide lawns lie
to the west and north. The roses themselves are to the south, filling the area
between you and the back of the house." CR>)>>

<ROUTINE IN-ORCHARD-F ("OPTIONAL" (RARG <>))
	 <COND (<==? .RARG ,M-LOOK>
		<TELL
"You are amidst lovely trees bearing apples, pears, peaches, and other fruits.
A grape arbor and several berry bushes may also be seen. The kitchen window
and east side of the house are just to your south, and a path skirts the
orchard to your north." CR>
		<COND (,LADDER-FLAG-2
		       <TELL
"A ladder is leaning against the balcony above." CR>)
		      (T
		       <TELL
"There is no way into the house from here." CR>)>)>>

<ROUTINE IN-ROSES-F ("OPTIONAL" (RARG <>))
	 <COND (<==? .RARG ,M-LOOK>
		<TELL
"You are among rows of roses. The ground is soft, and your footsteps leave
a rather bad impression as many poor seedlings are trampled underfoot. A
safer place to admire the flowers lies to the north. A window to the south
allows a view into the house." CR>
		<COND (<NOT ,LADDER-FLAG>
		       <TELL
"There is no way into the house from here." CR>)
		      (T
		       <TELL
"A ladder is leaning against the house, its upper end against a balcony
above." CR>)>
		<COND (<NOT <FSET? ,HOLE ,INVISIBLE>>
		       <TELL
"There are holes in the soft dirt near your feet." CR>)>
		<RTRUE>)
	       (<AND <==? .RARG ,M-ENTER>
		     <NOT ,GARDENER-ANGRY>
		     <NOT ,GARDENER-SHOW>
		     <EQUAL? <LOC ,GARDENER>
			     ,ROSE-GARDEN ,NORTH-LAWN ,WEST-LAWN>>
		<TELL
"In the distance you hear \"Hey! WHAT? You, there!\" and other choice words
muffled by a strong Scottish burr and a stiff breeze. Now, standing at the
edge of the garden, can be seen the person of Mr. Angus McNabb, the gardener.
He advances, looking crazed and gesticulating wildly. With each carefully
chosen step in your direction, a barely visible wince of pain comes to his
deeply-lined face. He regards you as you would regard the man whose car
just ran over your little puppy dog." CR>
		<COND (,G-I-G
		       <TELL "\"I canna believe it! I've already spent
an hour fixing up the ground here where some fool was walkin' aboot--and
now you! I canna believe it!\"" CR>)>
		<SETG GARDENER-ANGRY T>
		<SETG GARDENER-NO-REPLY T>
		<ENABLE <QUEUE I-GARDENER-CALM 90>>
		<MOVE ,GARDENER ,HERE>)>>

<ROUTINE I-GARDENER-CALM ()
	 <SETG GARDENER-NO-REPLY <>>>

<GLOBAL GARDENER-NO-REPLY <>>
<GLOBAL GARDENER-ANGRY <>>
<GLOBAL G-I-G <>>

<GLOBAL PRESENT-TIME 480>		;"9AM"

<ROUTINE FOYER-F ("OPTIONAL" (RARG <>))
	 <COND (<==? .RARG ,M-ENTER>
		<COND (<AND <NOT ,WELCOMED> <L? ,PRESENT-TIME 700>>
		       <TELL
"Mrs. Robner appears, walking down a hallway from the north." CR>
		       <WELCOME>)>)
	       (<==? .RARG ,M-LOOK>
		<DDESC
"This is the foyer of the Robner house, beautifully appointed with a fine
crystal chandelier, marble floors, and a large marble-topped table. The front
door, to the south, is " ,FRONT-DOOR ". The foyer continues north.">)>>

<ROUTINE SHALL-1-F ("OPTIONAL" (RARG <>))
	 <COND (<==? .RARG ,M-LOOK>
		<DDESC
"You are in an east-west hallway south of the staircase. A door to the south
is " ,ROURKE-DOOR ".">)>>

<ROUTINE SHALL-2-F ("OPTIONAL" (RARG <>))
	 <COND (<==? .RARG ,M-LOOK>
		<DDESC
"This is the end of the east-west hallway. To the south a small door
is " ,SOUTH-CLOSET-DOOR ".">
		<DDESC
"Another door, to the east, is " ,ROURKE-BATH-DOOR ".">)>>

<ROUTINE ROURKE-ROOM-F ("OPTIONAL" (RARG <>))
	 <COND (<==? .RARG ,M-LOOK>
		<DDESC
"This is the bedroom of the housekeeper, Mrs. Rourke, and is very simply
furnished. A single bed, flanked by bare wooden end tables, sits below a
closed window on the south end of the room. The floor is hardwood, with no
rug. The only exit is a door to the north, which is " ,ROURKE-DOOR ".">)>>

<ROUTINE ROURKE-BATH-F ("OPTIONAL" (RARG <>))
	 <COND (<==? .RARG ,M-LOOK>
		<DDESC
"This is Mrs. Rourke's bathroom. Aside from the usual bathroom fixtures
are two shelves affixed to the wall. The door at the west side of the
room is " ,ROURKE-BATH-DOOR ".">)>>

<ROUTINE LIVING-ROOM-F ("OPTIONAL" (RARG <>))
	 <COND (<==? .RARG ,M-LOOK>
		<SETG WELCOMED T>
		<DDESC
"This is a large and impressive room, whose furnishings bespeak the great
personal wealth of the Robners. The south side of the room is a large bay
window, now " ,BAY-WINDOW", which looks out onto the front yard.">
		<TELL
"A wood pile sits beside a huge fieldstone fireplace. A double doorway leading
to the main hall is the only exit. Pictures of Mrs. Robner's colonial ancestors
line one wall. The room contains formal seating for at least fifteen people,
in several groups of chairs and couches. Tables and cabinets, all of the
finest mahogany and walnut, complete the furnishings. On one of the tables is
a telephone." CR>)>>

<GLOBAL WILL-TIME 0>

<GLOBAL LAWN-ACTIVITIES
	<LTABLE "picking weeds"
		"mowing the grass"
		"wiping his brow"
		"examining his work">>

<GLOBAL GARDEN-ACTIVITIES
	<LTABLE "planting seeds"
		"cutting fresh flowers"
		"pruning stems">>

<ROUTINE CORRIDOR-1-F ("OPTIONAL" (RARG <>))
	 <COND (<==? .RARG ,M-LOOK>
		<TELL
"You are just west of the staircase. There are doors on both sides (north and
south) of the hallway, which continues west. ">
		<COND (<FSET? ,DUNBAR-DOOR ,OPENBIT>
		       <COND (<FSET? ,MASTER-BEDROOM-DOOR ,OPENBIT>
			      <TELL "Both doors are open." CR>)
			     (T <TELL "The door to the south is open." CR>)>)
		      (<FSET? ,MASTER-BEDROOM-DOOR ,OPENBIT>
		       <TELL "The door to the north is open." CR>)
		      (T <TELL "Both doors are closed." CR>)>)>>

<ROUTINE CORRIDOR-3-F ("OPTIONAL" (RARG <>))
	 <COND (<==? .RARG ,M-LOOK>
		<DDESC
"This section of hallway is near the west end. Through the window at the end
of the hall you can see some trees and the lake beyond. The hallway continues
east and west, and a door to the south is " ,GEORGE-DOOR ".">)>>

<ROUTINE CORRIDOR-4-F ("OPTIONAL" (RARG <>))
	 <COND (<AND <==? .RARG ,M-ENTER>
		     <==? ,PRESENT-TIME <+ ,GEORGE-RUN 1>>>
		<TELL
"As you enter the hallway, you catch a glimpse of George
running down the stairs." CR>
		<RFALSE>)
	       (<==? .RARG ,M-LOOK>
		<TELL
"This is the west end of the upstairs hall. To the north is the library,
where Mr. Robner was found. Its solid oak door has been knocked down and
is lying just inside the entrance to the library. A window which cannot
be opened is at the end of the hallway." CR>)>>

<ROUTINE LIBRARY-F ("OPTIONAL" (RARG <>))
	 <SETG WELCOMED T>
	 <COND (<==? .RARG ,M-LOOK>
		<TELL
"This is the library where Mr. Robner's body was found. It is decorated in a
simple but comfortable style. Mr. Robner obviously spent a great deal of time
here. A wide executive desk sits before tall balcony windows which lie at the
north of the room. A telephone is sitting on the desk. The east side of the
room is composed of three large bookshelf units containing numerous volumes
on many topics. The floor is carpeted from wall to wall. The massive oak door
which blocked the entrance has been forcibly knocked off its hinges and is
lying by the doorway." CR>
		<COND (<FSET? ,LIBRARY-BALCONY-DOOR ,OPENBIT>
		       <TELL
"The window to the balcony has been opened." CR>)>
		<COND (<FSET? ,HIDDEN-DOOR-L ,OPENBIT>
		       <TELL
"The bookshelf unit on the far left has been swung open,
revealing a room behind it!" CR>)>
		<RTRUE>)>>

<ROUTINE LIBRARY-BALCONY-F ("OPTIONAL" (RARG <>))
	 <COND (<==? .RARG ,M-LOOK>
		<DDESC
"The balcony is bare of furniture, though it has a beautiful view of the rose
garden, the north lawn and the lake. A metal railing around the balcony 
prevents an accidental drop to the thorny roses below. The window between the
balcony and the library is " ,LIBRARY-BALCONY-DOOR ".">
		<COND (,LADDER-FLAG
		       <TELL
"The top of a ladder is resting on the metal railing." CR>)>
		<COND (<IN? ,GARDENER ,ROSE-GARDEN>
		       <TELL
"Mr. McNabb is tending to the roses." CR>)
		      (<IN? ,GARDENER ,NORTH-LAWN>
		       <TELL
			  "Away to the north, Mr. McNabb can be seen "
			  <PICK-ONE ,LAWN-ACTIVITIES> "." CR>)>
		<RTRUE>)>>

<ROUTINE HIDDEN-CLOSET-F ("OPTIONAL" (RARG <>))
	 <COND (<==? .RARG ,M-LOOK>
		<TELL
"This is a secret room situated between the library and the master bedroom.
The room is bare and somewhat dusty, as if it were not often used. An
unmarked switchplate surrounds two buttons, one blue and one red. A formidable
safe is embedded in the south wall.">
		<COND (<FSET? ,SAFE ,OPENBIT>
		       <TELL " The heavy safe door is wide open.">)>
		<CRLF>
		<COND (<FSET? ,HIDDEN-DOOR-L ,OPENBIT>
		       <TELL
"The library can be seen through a door to the west." CR>)
		      (<FSET? ,HIDDEN-DOOR-B ,OPENBIT>
		       <TELL
"The master bedroom can be seen through a door to the east." CR>)>
		<RTRUE>)>>

<ROUTINE RED-BUTTON-F ()
	 <COND (<VERB? PUSH>
		<COND (<FSET? ,HIDDEN-DOOR-L ,OPENBIT>
		       <FCLEAR ,HIDDEN-DOOR-L ,OPENBIT>
		       <TELL "The wall to the west silently closes." CR>)
		      (T
		       <FSET ,HIDDEN-DOOR-L ,OPENBIT>
		       <TELL
"The wall to the west swings open, revealing the library on the other
side." CR>)>)>>

<GLOBAL HC-ROBNER <>>

<ROUTINE BLUE-BUTTON-F ()
	 <COND (<VERB? PUSH>
		<COND (<FSET? ,HIDDEN-DOOR-B ,OPENBIT>
		       <FCLEAR ,HIDDEN-DOOR-B ,OPENBIT>
		       <TELL "The wall to the east swings closed." CR>)
		      (T
		       <FSET ,HIDDEN-DOOR-B ,OPENBIT>
		       <TELL
"The wall to the east swings open, revealing the master bedroom on the
other side." CR>
		       <COND (<AND <NOT ,HC-ROBNER>
				   <IN? ,MRS-ROBNER ,MASTER-BEDROOM>>
			      <TELL
"Mrs. Robner, sitting on her bed, appears stunned. She walks over and peeks
in, speaks of her complete surprise at the presence of such a place, and
returns to her bed, somewhat shaken." CR>
			      <SETG HC-ROBNER T>)>
		       <RTRUE>)>)>>

<ROUTINE MASTER-BEDROOM-F ("OPTIONAL" (RARG <>))
	 <COND (<AND <==? .RARG ,M-ENTER>
		     <==? ,BAXTER-SEQ-LOC ,MASTER-BEDROOM>>
		<TELL
"As you walk through the door, there is an explosion from in front of you!
The impact of the bullet knocks you to the ground, stunned. You struggle,
trying to look up. Another explosion! You fall back, into a long silence." CR>
		<QUIT>)
	       (<==? .RARG ,M-LOOK>
		<DDESC
"This is the Robners' master bedroom, decorated in the Queen Anne style. A
large four-poster bed with paired end tables fills the south end of the room.
On one of the end tables is a telephone. Dressers, a small chair, and a lounge
are against the walls. The north wall contains a balcony window, which is
" ,BEDROOM-BALCONY-DOOR ". An open doorway leads east to the bathroom. A large
mirror with a gilt frame hangs on the west wall.">
		<COND (<FSET? ,HIDDEN-DOOR-B ,OPENBIT>
		       <TELL
"Part of the west wall has been swung away, revealing a hidden closet." CR>)>
		<RTRUE>)>>

<ROUTINE BEDROOM-BALCONY-F ("OPTIONAL" (RARG <>))
	 <COND (<AND <==? .RARG ,M-ENTER>
		     <==? ,BAXTER-SEQ-LOC ,BEDROOM-BALCONY>>
		<TELL
"As you enter the balcony, there is an explosion and a burst of flame from
your left. The pain freezes you for a moment as everything becomes black.
While you await a choir of angels, a short chuckle and the sound of running
feet are the last you hear." CR>
		<QUIT>)
	       (<==? .RARG ,M-LOOK>
		<DDESC
"This balcony is atop the orchard, with the tallest of the fruit trees rising
to about the level of the balcony. A metal railing surrounds the balcony,
preventing a precipitous descent. A glass door leading to the master bedroom
is " ,BEDROOM-BALCONY-DOOR ".">
		<COND (,LADDER-FLAG-2
		       <TELL
"The top of a ladder is visible here, leaning on the railing." CR>)>
		<RTRUE>)>>

<ROUTINE SHALL-11-F ("OPTIONAL" (RARG <>))
	 <COND (<==? .RARG ,M-LOOK>
		<DDESC
"The hallway turns a corner here and continues east. To the north is the
head of the stairs. A door to the south is " ,DUNBAR-BATH-DOOR ".">)>>

<ROUTINE DUNBAR-BATH-F ("OPTIONAL" (RARG <>))
	 <COND (<==? .RARG ,M-LOOK>
		<TELL
"This bathroom contains the usual sink, toilet, and bath. A medicine
cabinet, ">
		<COND (<FSET? ,DUNBAR-CABINET ,OPENBIT>
		       <TELL "lying partially open">)
		      (T <TELL "closed">)>
		<DDESC ", is above the sink. A door to the north
is " ,DUNBAR-BATH-DOOR ".">)>>

<GLOBAL CORPSE-SEEN <>>

<ROUTINE DUNBAR-ROOM-F ("OPTIONAL" (RARG <>))
	 <COND (<AND <==? .RARG ,M-ENTER> ,DUNBAR-DEAD>
		<SETG CORPSE-SEEN T>)
	       (<==? .RARG ,M-LOOK>
		<DDESC
"This is Ms. Dunbar's room. It is furnished in the usual style, with a few
additions indicative of Ms. Dunbar's taste. The bedroom door
is " ,DUNBAR-DOOR ".">)>>

<ROUTINE GEORGE-BATH-F ("OPTIONAL" (RARG <>))
	 <COND (<==? .RARG ,M-LOOK>
		<DDESC
"This is George's bathroom, with all the appropriate fixtures. Shaving gear
sits near the sink. The door, to the west, is " ,GEORGE-BATH-DOOR ".">)>>

<ROUTINE GEORGE-ROOM-F ("OPTIONAL" (RARG <>))
	 <COND (<==? .RARG ,M-LOOK>
		<TELL
"This is George's bedroom. In addition to the normal furnishings, there
is a small liquor cabinet, and a stereo with records and tapes. The door,
leading to the hallway to the north, is ">
		<COND (<FSET? ,GEORGE-DOOR ,OPENBIT>
		       <TELL "open">)
		      (T <TELL "closed">)>
		<DDESC
". Another door, to the east, is " ,GEORGE-BATH-DOOR ".">
		<COND (,TUNE-ON
		       <TELL
"Playing on the stereo is a " ,TUNE-ON "." CR>)>
		<RTRUE>)>>

"Local Global Functions"

<ROUTINE LAWN-F ()
	 <COND (<VERB? EXAMINE>
		<TELL "The lawn is well manicured." CR>)>>

<ROUTINE BAY-WINDOW-F ()
	 <COND (<VERB? LOOK-INSIDE>
		<COND (<==? ,HERE ,WEST-OF-DOOR>
		       <TELL
"You see the living room through the window." CR>)
		      (<IN? ,GARDENER ,SOUTH-LAWN>
		       <TELL
"Through the bay windows the gardener, Mr. McNabb, can be seen ">
		       <TELL <PICK-ONE ,LAWN-ACTIVITIES>>
		       <TELL " on the south lawn." CR>)
		      (T
		       <TELL "You can see the south lawn." CR>)>)
	       (<AND <VERB? OPEN> <NOT <FSET? ,FOYER ,TOUCHBIT>>>
		<TELL "The window seems to be latched from the inside." CR>)>>

<ROUTINE ROSE-F ()
	 <COND (<VERB? SMELL>
		<TELL "They smell nice." CR>)
	       (<VERB? EXAMINE>
		<TELL
"There are rows of yellow, red, pink, and white roses here." CR>)
	       (<VERB? TAKE>
		<TELL
"Taking a rose would be most ungracious, and possibly dangerous if Mr. McNabb
found out." CR>)>>

<ROUTINE HOUSE-F ()
	 <COND (<VERB? FIND>
		<TELL
"It's right here. Some inspector you are." CR>)
	       (<VERB? THROUGH>
		<COND (<AND <EQUAL? ,HERE ,FRONT-PATH>
		            <FSET? ,FRONT-DOOR ,OPENBIT>>
		       <GOTO ,FOYER>)
		      (<AND <EQUAL? ,HERE ,EAST-OF-DOOR>
			    <FSET? ,BAY-WINDOW ,OPENBIT>>
		       <GOTO ,LIVING-ROOM>)
		      (T
		       <TELL "You might try the front door." CR>)>)
	       (<VERB? EXAMINE>
		<TELL
"The house is a magnificent New England colonial, like many other houses
around the lake. It is painted slate gray with white trim." CR>)>>

<ROUTINE GROUND-F ()
	 <COND (<AND <VERB? BRUSH>
		     <IN? ,FRAGMENT ,PLAYER>
		     <NOT ,FRAGMENT-CLEANED>>
		<PERFORM ,V?BRUSH ,FRAGMENT>
		<RTRUE>)
	       (<VERB? EXAMINE SEARCH SEARCH-AROUND>
		<COND (<==? ,HERE ,ROURKE-ROOM>
		       <TELL "The floor is hardwood." CR>)
		      (<==? ,HERE ,FOYER>
		       <TELL "The floor is marble." CR>)
		      (<==? ,HERE ,IN-ROSES>
		       <COND (<NOT <FSET? ,HOLE ,INVISIBLE>>
			      <PERFORM ,V?SEARCH-AROUND ,HOLE>
			      <RTRUE>)
			     (<AND <VERB? SEARCH-GROUND-UNDER>
				   <==? ,PRSI ,BALCONY>>
			      <TELL
"The balcony above is very large. Searching the entire area beneath it
would take a great deal of time." CR>)
			     (T
			      <TELL
"There are rows upon rows of roses here. It would take you the best part of
a day to search the ground in great detail." CR>)>)
		      (T <TELL "You don't find anything new there." CR>)>)>>

<ROUTINE AIR-F ()
	 <COND (<VERB? SMELL>
		<COND (<EQUAL? ,HERE ,ROSE-GARDEN ,IN-ROSES>
		       <TELL
"The smell of roses permeates everything." CR>)
		      (<EQUAL? ,HERE ,NORTH-LAWN ,EAST-LAWN ,WEST-LAWN>
		       <TELL
"A breeze carries the faint smell of roses through the air." CR>)
		      (<==? <GETP ,HERE ,P?LINE> ,OUTSIDE-LINE-C>
		       <TELL "The air is clear and fresh here." CR>)
		      (<FRESH-AIR? ,HERE> <RTRUE>)
		      (T <TELL "The air is rather musty here." CR>)>)>>

<ROUTINE FRESH-AIR? (RM "AUX" P L T O)
	 #DECL ((RM O) OBJECT (P L) FIX)
	 <SET P 0>
	 <REPEAT ()
		 <COND (<0? <SET P <NEXTP ,HERE .P>>>
			<RFALSE>)
		       (<NOT <L? .P ,LOW-DIRECTION>>
			<SET T <GETPT ,HERE .P>>
			<SET L <PTSIZE .T>>
			<COND (<AND <EQUAL? .L ,DEXIT>
				    <FSET? <SET O <GETB .T ,DEXITOBJ>>
					   ,OPENBIT>>
			       <TELL
"There is a pleasant breeze coming through the " D .O "." CR>
			       <RETURN>)>)>>>

<ROUTINE LAKE-F ()
	 <COND (<VERB? SWIM LEAP THROUGH>
		<TELL
"You're not on vacation, but with ideas like that you will probably be given
a rather long one." CR>)
	       (<VERB? LOOK-INSIDE EXAMINE>
		<COND (<AND <==? ,HERE ,NORTH-LAWN>
			    <IN? ,SOGGY-WILL ,LAKE>>
		       <TELL
"A crumpled piece of paper is floating on the water a few feet from shore.
With an uncommonly agile motion, you retrieve the drenched paper." CR>
		       <MOVE ,SOGGY-WILL ,WINNER>)
		      (T
		       <TELL
"Surely you don't suspect the fish also?" CR>)>)>>

<ROUTINE SHED-F ()
	 <COND (<VERB? THROUGH>
		<COND (<EQUAL? ,HERE ,EAST-LAWN ,BEHIND-SHED>
		       <GOTO ,SHED-ROOM>
		       <RTRUE>)
		      (T <TELL "Senility strikes!" CR>)>)
	       (<VERB? LISTEN>
		<COND (<NOT <0? ,SECRET-MEETING>>
		       <TELL
"You hear two muffled voices inside the shed." CR>)>)
	       (<VERB? HIDE-BEHIND>
		<COND (<==? ,HERE ,EAST-LAWN>
		       <TELL
"You carefully sneak behind the shed. It seems that no one saw you." CR>)
		      (T
		       <TELL
"You leave the shed and quietly slip behind it. Nobody appears to have seen
you." CR>)>
		<GOTO ,BEHIND-SHED>
		<RTRUE>)>>

"People Functions"

<ROUTINE PLAYER-F () <>>

<GLOBAL HOLE-SHOWN <>>
<GLOBAL HOLE-TELL <>>

<ROUTINE SHOW-HOLE ()
	 <TELL
"McNabb grabs your arm and leads you to a spot deep within the garden and
near the house. You might never have found this place alone. He points at
the ground, where you see two holes in the soft earth." CR>
	 <FCLEAR ,HOLE ,INVISIBLE>
	 <SETG HOLE-SHOWN T>>

<ROUTINE HOLE-F ()
	 <COND (<NOT ,HOLE-TELL>
		<TELL "What hole?" CR>)
	       (<VERB? ASK-ABOUT> <RFALSE>)
	       (<VERB? FIND>
		<COND (<NOT <==? ,HERE ,IN-ROSES>>
		       <TELL
"They're among the roses, or have you forgotten?" CR>)
		      (<NOT <FSET? ,HOLE ,INVISIBLE>>
		       <TELL "They're right here!" CR>)
		      (<AND <NOT ,HOLE-SHOWN> <PROB 80>>
		       <TELL
"The rose garden is vast and full of thorny roses. You might look
for the rest of the day before you find them." CR>)
		      (T
		       <TELL
"The garden is rather big, even just the area you are searching now, and the
holes were small. They're not here, but are probably nearby." CR>)>)
	       (<EQUAL? ,HOLE ,PRSI ,PRSO>
		<COND (<VERB? EXAMINE LOOK-INSIDE>
		       <TELL
"There are two holes here, each about two inches by four inches. They are at
least three inches deep and the soil is compacted around them." CR>)
		      (<OR <AND <VERB? SEARCH-GROUND-AROUND>
			        <==? ,PRSO ,GROUND>>
			   <VERB? SEARCH-AROUND>>
		       <COND (<==? <LOC ,GARDENER> ,HERE>
			      <TELL
"Mr. McNabb watches you with ill-concealed irritation." CR>)>
		       <COND (,FRAGMENT-FOUND
			      <TELL
"Aside from dirt, organic fertilizer, and small crawly creatures, you turn
up nothing but roses." CR>)
			     (<OR <G? <SETG RST <+ ,RST 1>> 2>
				  <PROB 30>>
			      <TELL
"Ouch! You cut your finger on a sharp edge as you dig. You search carefully
in the dirt, now that you are sure something is there, and pull up a piece
of porcelain, covered with dirt and dried mud." CR>
			      <THIS-IS-IT ,FRAGMENT>
			      <MOVE ,FRAGMENT ,WINNER>
			      <FCLEAR ,FRAGMENT ,INVISIBLE>
			      <SETG FRAGMENT-FOUND T>
			      <SETG FRAGMENT-FELT T>)
			     (T
			      <TELL <GET ,ROSE-DIGS ,RST> CR>)>)>)
	       (T <TELL "There is no hole here." CR>)>>

<GLOBAL RST 0>

<GLOBAL ROSE-DIGS
	<LTABLE
"You are making quite a mess, but you do run across some tiny pieces of a
hard, shiny substance, which drop from your fingers and back onto the ground."
"Although everything is coming up roses, you haven't found anything unusual
except for a few pieces of a hard substance which fall back to the ground.">>

<GLOBAL FRAGMENT-FLAG <>>

<ROUTINE FRAGMENT-F ()
	 <COND (<VERB? EXAMINE>
		<COND (,FRAGMENT-CLEANED
		       <TELL
"The fragment is beautifully hand-painted">
		       <SETG FRAGMENT-FLAG T>
		       <COND (,CHINA-EXAMINED
			      <TELL ", exactly like those you
saw in the kitchen">)>
		       <TELL "." CR>)
		      (T
		       <TELL
"The piece of porcelain is filthy, coated with dried mud. You can barely
make out some design underneath the dirt." CR>)>)
	       (<VERB? FINGERPRINT>
		<TELL
"It's covered with dirt and mud. You realize that there would be no good
fingerprints on it." CR>)
	       (<VERB? ANALYZE> <DO-ANALYZE>)
	       (<VERB? BRUSH>
		<SETG FRAGMENT-CLEANED T>
		<TELL
"As you wipe off the piece of porcelain, you notice that it is a fragment of
some very beautiful piece, handsomely painted.">
		<COND (,CHINA-EXAMINED
		       <TELL "  The markings are identical
to those you saw on the china in the kitchen.">)>
		<CRLF>)>>

<GLOBAL FRAGMENT-CLEANED <>>
<GLOBAL FRAGMENT-FELT <>>
<GLOBAL FRAGMENT-FOUND <>>
<GLOBAL GARDENER-SHOW <>>

<ROUTINE GARDENER-F ("OPTIONAL" (RARG <>))
	 <COND (<==? .RARG ,M-OBJDESC>
		<COND (<IN-MOTION? ,GARDENER> <RTRUE>)
		      (<==? <LOC ,GARDENER> ,ORCHARD>
		       <TELL "Mr. McNabb is here, pruning the trees.">)
		      (<OR <EQUAL? <LOC ,GARDENER> ,NORTH-LAWN ,EAST-LAWN>
			   <EQUAL? <LOC ,GARDENER> ,SOUTH-LAWN ,WEST-LAWN>>
		       <TELL "Mr. McNabb is here, ">
		       <TELL <PICK-ONE ,LAWN-ACTIVITIES>>
		       <TELL ".">)
		      (<IN? ,GARDENER ,ROSE-GARDEN>
		       <TELL "Mr. McNabb is here, ">
		       <TELL <PICK-ONE ,GARDEN-ACTIVITIES>>
		       <TELL ".">)
		      (T <TELL "Mr. McNabb is here.">)>
		<COND (,G-I-G
		       <TELL " He seems quite worked up and is talking aloud
to himself.">)
		      (,GARDENER-ANGRY
		       <TELL " He seems pretty angry about something.">)>
		<CRLF>
		<CARRY-CHECK ,GARDENER>)
	       (<VERB? HELLO GOODBYE>
		<COND (,GARDENER-ANGRY
		       <TELL
"McNabb grunts briefly in your direction." CR>)
		      (,G-I-G
		       <TELL
"He answers absently and starts to mumble quietly about the roses." CR>)
		      (T
		       <TELL
"He replies with a brief nod, and then starts mumbling to himself
about the " <PICK-ONE ,GARDEN-MUMBLES> "." CR>)>)
	       (<==? ,WINNER ,GARDENER>
		<COND (<AND <VERB? SHOW>
			    <OR <EQUAL? ,PRSI ,GLOBAL-HOLE ,HOLE>
				<EQUAL? ,PRSI ,GLOBAL-ROSES ,ROSE>>>
		       <COND (<AND <NOT ,HOLE-TELL> <NOT ,G-I-G>>
			      <TELL
"\"I don't know what you're-a talkin' aboot.\"" CR>)
			     (,NO-SHOW
			      <TELL
"\"I don't think I remember where it was. Now go away,\" he says. He looks a
bit annoyed at you, probably for asking him before and then running off." CR>)
			     (,HOLE-SHOWN
			      <TELL
"\"I've already shown you plenty. Now, git!\"" CR>)
			     (<==? ,HERE ,IN-ROSES>
			      <SETG GARDENER-SHOW T>
			      <SETG HOLE-TELL T>
			      <SHOW-HOLE>)
			     (T
			      <ESTABLISH-GOAL ,GARDENER ,IN-ROSES T>
			      <SETG GARDENER-SHOW T>
			      <SETG HOLE-TELL T>
			      <TELL
"\"Follow me!\" he says, and starts walking toward the roses." CR>)>)
		      (<VERB? FIND> <RFALSE>)
		      (<COM-CHECK ,GARDENER> <RTRUE>)
		      (T <TELL <PICK-ONE ,WHY-ME> CR>)>)
	       (<VERB? LISTEN>
		<COND (,G-I-G
		       <TELL
"You can't make out everything, but he seems to be complaining about weeks
of work on the roses ruined by someone stomping around in the garden. There
are references to elephants and holes. When he's worked up, as now, he
doesn't always make much sense." CR>
		       <SETG HOLE-TELL T>)
		      (T
		       <TELL
"He seems to be mumbling about the " <PICK-ONE ,GARDEN-MUMBLES> "." CR>)>)
	       (<AND <VERB? ASK-ABOUT> <==? ,PRSO ,GARDENER>>
		<COND (<AND ,GARDENER-NO-REPLY <NOT ,GARDENER-SHOW>>
		       <TELL
"\"I dinna give a hoot about you or your questions! Now, begone! Steppin' all
o'er me roses. A crime, it is! I'll call the police is what!\" He seems pretty
angry." CR>)
		      (<AND <EQUAL? ,PRSI ,GLOBAL-HOLE> ,HOLE-TELL>
		       <TELL
"\"I've already told you. There's holes in my garden!\"" CR>)
		      (<AND <EQUAL? ,PRSI ,GLOBAL-WEATHER> <NOT ,G-I-G>>
		       <TELL
"\"Beautiful! What a fine day. Except for the rain Wednesday night, I ha'ent
had such a fine week in a long spell. Not that I'm complainin'. You see, with
my roses...\" He goes on and on about his roses." CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-LADDER ,LADDER>
		       <TELL
"\"What aboot it? I use it for cleanin' the gutters 'n prunin' the
trees.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-ROSES ,ROSE ,GLOBAL-WEATHER>
		       <COND (,G-I-G
			      <TELL
"He tells you his story. He was tending to the roses this morning when he
noticed two deep holes in the garden, with a few roses crushed nearby. He
doesn't know when he'll be able to repair the damage." CR>
			      <SETG HOLE-TELL T>)
			     (T
			      <TELL
"McNabb goes on for some time about the exquisite nature of the garden in
general and mentions, for your benefit, some of the finer points of his
gardening technique." CR>)>)
		      (<EQUAL? ,PRSI ,LAWN>
		       <TELL
"McNabb tells a long tale of woe and hardship, of days and nights
sweating with the lawn mower, roller, and weed puller." CR>)
		      (<OR <EQUAL? ,PRSI ,GEORGE ,GLOBAL-GEORGE>
			   <EQUAL? ,PRSI ,BAXTER ,GLOBAL-BAXTER>
			   <EQUAL? ,PRSI ,DUNBAR ,GLOBAL-DUNBAR>
			   <EQUAL? ,PRSI ,MRS-ROBNER ,GLOBAL-MRS-ROBNER>
			   <EQUAL? ,PRSI ,ROURKE ,GLOBAL-ROURKE>>
		       <TELL
"\"I don't care much aboot any of them from in the house. I barely even know
which is which.\" He shakes his head and continues with his work." CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-MR-ROBNER>
		       <TELL
"\"Too bad aboot Mr. Robner. He was a good man, liked to talk aboot the
garden. He told me 'McNabb', he says, 'this here's the finest garden I've
seen.' We'd talk for hours about planting and gardening. None of the others
knows between a rose and a sunflower.\" He shakes his head sadly and
continues his work." CR>)
		      (T
		       <TELL
"\"I dinna know nothin' aboot that.\"" CR>)>)>>

<GLOBAL GARDEN-MUMBLES
	<LTABLE "rose garden"
		"fruit trees"
		"weather"
		"snootiness of city slickers"
		"intricacies of weeding">>

<GLOBAL WHY-ME
	<LTABLE "\"You can do that yourself.\""
		"\"Do it yourself!\""
		"\"Why not do it yourself?\"">>

<GLOBAL PEN-SEEN <>>

<ROUTINE BAXTER-F ("OPTIONAL" (RARG <>))
	 <COND (<==? .RARG ,M-OBJDESC>
		<COND (<IN-MOTION? ,BAXTER> T)
		      (<AND <IN? ,BAXTER ,SHED> <NOT <0? ,SECRET-MEETING>>>
		       <TELL
"Mr. Baxter and Ms. Dunbar are here talking rapidly with each other. They
haven't noticed you yet." CR>)
		      (,DUNBAR-BAXTER-MEET
		       <SETG DUNBAR-BAXTER-MEET <>>
		       <TELL
"Mr. Baxter is in one corner, talking to Ms. Dunbar. He notices you and
motions Dunbar to stop talking." CR>)
		      (<IN? ,BAXTER ,LIVING-ROOM>
		       <COND (,POST-WILL
			      <TELL
"Mr. Baxter is offering his sympathies to Mrs. Robner." CR>)
			     (<IN? ,RECURSIVE-BOOK ,BAXTER>
			      <FSET ,RECURSIVE-BOOK ,NDESCBIT>
			      <TELL
"Mr. Baxter is sitting here reading a book." CR>)
			     (T <TELL
"Mr. Baxter is sitting quietly here." CR>)>)
		      (T <TELL "Mr. Baxter is here." CR>)>
		<CARRY-CHECK ,BAXTER>)
	       (<VERB? EXAMINE>
		<COND (,SHOT-FIRED
		       <COND (<IN? ,BAXTER ,DUNBAR-ROOM>
			      <TELL
"Baxter seems out of breath. His hair is disheveled and his hands are
somewhat soiled." CR>)
			     (T
			      <TELL
"Mr. Baxter has recovered his composure and looks calm. His hair is a bit
disheveled and his hands are dirty." CR>)>)>) 
	       (<VERB? HELLO>
		<TELL "Mr. Baxter returns your salutation." CR>)
	       (<VERB? GOODBYE>
		<TELL "Mr. Baxter nods." CR>)
	       (<==? ,WINNER ,BAXTER>
		<COND (<VERB? FIND> <RFALSE>)
		      (<COM-CHECK ,BAXTER> <RTRUE>)
		      (T <TELL <PICK-ONE ,WHY-ME> CR>)>)
	       (<VERB? SEARCH SEARCH-OBJECT-FOR>
		<TELL
"Mr. Baxter pushes you away abruptly. \"I don't know what game you're playing,
Inspector, and frankly I'm not interested. You have been invited here to
investigate, not molest innocent persons.\"" CR>)
	       (<AND <VERB? ACCUSE> <==? ,PRSI ,GLOBAL-MURDER>>
		<COND (,PEN-SEEN
		       <TELL
"Mr. Baxter turns to run away, but notices Sergeant Duffy by the door. He
stops abruptly and faces you." CR>)>)
	       (<VERB? ARREST>
		<COND (<OR ,PEN-SEEN ,BAXTER-SEEN>
		       <COND (<IN? ,BAXTER ,HERE>
			      <TELL
"Sergeant Duffy enters the room solemnly. He places a pair of handcuffs
on Mr. Baxter, who is stiff and unspeaking.  \"Let's not have any
trouble, now.\" Duffy remarks to Baxter.">)
			     (T
			      <TELL
"A few moments pass and Sergeant Duffy appears, escorting a handcuffed
Mr. Baxter.">)>
		       <TELL " With that, he leads him from
your view and into a police car waiting near the south lawn.|
|">
		       <END-HEADER "August 10">
		       <TELL
"Congratulations on your work in the Robner case. As I'm sure you
are aware, Mr. Baxter was found guilty ">
		       <COND (<AND <FSET? ,BAXTER-PAPERS ,TOUCHBIT> ,NOTE-READ>
			      <TELL
"of two counts of first-degree murder and has been sentenced to two
consecutive terms of life imprisonment.  My only regret is that Dunbar
couldn't stand trial with him. We may never know the complete story behind
the Robner murder. But once again, thanks.|
|">)
			     (T
			      <TELL
"of first-degree murder in the death of Ms. Dunbar. Unfortunately, Baxter
remained tight-lipped throughout the proceedings, and except for the
revelation that Baxter and Dunbar were lovers, there was no motive established
for her murder. The jury acquitted Mr. Baxter in the murder of Mr. Robner,
as a motive had not been established. I am indeed sorry that a proper
conclusion to the case could not have been made.|
|">)>
		       <CASE-OVER>)
		      (<IN? ,CORPSE ,DUNBAR-ROOM>
		       <TELL
"Trusty Sergeant Duffy enters and places Mr. Baxter under arrest.
They leave, Baxter remaining calm.|
|">
		       <END-HEADER "August 13">
		       <TELL
"I heard today that the jury in the Robner case has voted to
acquit Mr. Baxter of both murders at the Robner house." CR>
		       <COND (<FSET? ,BAXTER-PAPERS ,TOUCHBIT>
			      <TELL
"While it was clear that Baxter had committed numerous crimes in the Focus
case, the jury was unconvinced of the relation between that and the murders.
They felt that Ms. Dunbar had committed the first murder, although I can't
imagine any scenario in which that would be possible, and had committed
suicide in desperation. These explanations leave much to be desired, but
what's done is done. I can't help feeling that there is more to this case than
has been discovered. Thank you for your work.|
|">
			      <CASE-OVER>)
			     (T
			      <TELL
"The jury believed the more probable story: that Ms. Dunbar committed the
first murder and then committed suicide when her guilt became clear to you.
I don't really believe this any more than you do, but the evidence is vague,
you must agree. Thanks again for handling the case.|
|">
			      <CASE-OVER>)>)
		      (<FSET? ,BAXTER-PAPERS ,TOUCHBIT>
		       <COND (<FSET? ,LAB-REPORT ,TOUCHBIT>
			      <TELL
"Trusty Sergeant Duffy enters and places Mr. Baxter under arrest.
They leave, Baxter remaining calm.|
|">
			      <END-HEADER "August 11">
			      <TELL
"I am sorry to report that Mr. Baxter was acquitted yesterday of the murder
of Mr. Robner. In speaking to the District Attorney, I gathered that the jury
was almost convinced of Baxter's guilt, given that he had both motive and a
means to enter the house using the ladder. However, the theory had a number of
serious flaws, including the means by which Baxter could have administered the
drug either without Robner's knowledge or without a struggle. I must confess
that I too am baffled. I am convinced that Baxter is guilty, but I fear we
will never know for certain.|
|">
			      <CASE-OVER>)
			     (T
			      <MURDER-NOT-PROVEN ,BAXTER T>)>)
		      (<FSET? ,LAB-REPORT ,TOUCHBIT>
		       <TELL
"Duffy enters and places Mr. Baxter under arrest, then leads him away without
fuss.|
|">
		       <END-HEADER "August 11">
		       <TELL
"I am indeed sorry that Mr. Baxter was acquitted yesterday of the murder of
Mr. Robner. From the District Attorney, I gather that the jury was completely
unconvinced by the our case. They found neither sufficient motive nor any
plausible means of introducing the fatal medicine into Mr. Robner's drink. I
must confess to being baffled by this case. Perhaps we shall never know the
true story of Mr. Robner's murder.|
|">
		       <CASE-OVER>)
		      (T
		       <MURDER-NOT-PROVEN ,BAXTER <>>)>)
	       (<AND <VERB? ASK-FOR>
		     <IN? ,CORPSE ,DUNBAR-ROOM>
		     <==? ,PRSI ,GLOBAL-PEN>>
		<TELL
"Baxter reaches instinctively into his jacket and starts to pull out a pen.
He hesitates suddenly, pen in hand." CR>
		<MOVE ,PEN ,BAXTER>
		<SETG PEN-SEEN T>)
	       (<AND <VERB? ASK-ABOUT> <==? ,PRSO ,BAXTER>>
		<COND (<NOT <GRAB-ATTENTION ,BAXTER>> <RTRUE>)
		      (<==? ,PRSI ,RECURSIVE-BOOK>
		       <TELL
"\"A fascinating story, Inspector. A man is found dead behind a locked door,
a clear suicide. Yet the detective seems bent on proving that a murder has
occured. Rather odd, wouldn't you say?\"" CR>)
		      (<==? ,PRSI ,GLOBAL-CONCERT>
		       <TELL
"\"A marvelous concert! There were works by Beethoven, Sibelius, and Ravel. I
never would've guessed you were interested in serious music, Inspector.\"" CR>)
		      (<==? ,PRSI ,STUB>
		       <COND (,STUB-DX
			      <TELL
"\"My dear Inspector, it is just as Ms. Dunbar told you.\"" CR>)
			     (T
			      <SETG STUB-B T>
			      <COND (<IN? ,DUNBAR ,HERE>
				     <SETG STUB-BX T>)>
			      <COND (,STUB-D
				     <SETG CONTRADICTION T>)>
			      <TELL
"\"Ah, that must be Ms. Dunbar's ticket stub. I should have told you earlier.
Ms. Dunbar was with me at the concert on the night that Marshall killed
himself. She became ill at intermission and hired a car to take her back home.
You see, Inspector, I know that Ms. Dunbar appreciates classical music, so I
occasionally ask her along to my subscription series. I really should
have told the other detective, but I didn't think it mattered.\"" CR>)>)
		      (<==? ,PRSI ,GLOBAL-LADDER>
		       <TELL
"\"What ladder? You know, Inspector, your questions are becoming
quite tiresome.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-MERGER ,GLOBAL-OMNIDYNE>
		       <TELL
"\"I didn't realize you had an interest in finance. Before Marshall died, we
agreed that the only reasonable way to protect our interests was to be bought
out by a larger company which could then provide us with capital for
expansion. I had been talking to people at Omnidyne and we agreed in
principle on the terms for such an agreement last week. I'm hopeful that we
can close the deal quickly.\"" CR>)
		      (<==? ,PRSI ,GLOBAL-NEW-WILL>
		       <COND (<G? ,WILL-TIME 0>
			      <TELL
"\"It's fortunate for George that Marshall died when he did. It must be quite
a relief to know that he'll have plenty of money.\" He chuckles softly.">
			      <COND (,AT-READING
				     <TELL
" \"I guess that explains his reaction at the reading.\"">)>
			      <CRLF>)
			     (T
			      <TELL
"\"I don't know much about the family's affairs. Marshall threatened
to make a new will, but it certainly appears that he never did.\"" CR>)>)
		      (<==? ,PRSI ,GLOBAL-FOCUS>
		       <COND (,B-FOCUS
			      <TELL
"\"I told you already. There was no legal wrongdoing, only
some reporters trying to stir up a fuss.\" He appears quite nervous." CR>)
			     (,B-NOTE
			      <TELL
"\"I understand the note no more than you do.\" He turns away." CR>)
			     (T
			      <TELL
"There is a flicker of surprise on Baxter's face. \"I'm not sure
what you mean. Focus Corporation has been a subsidiary of Robner
Corp. for some years. I fail to see its import.\"" CR>)>)
		      (<EQUAL? ,PRSI ,GEORGE ,GLOBAL-GEORGE>
		       <DISCRETION ,BAXTER ,GEORGE>
		       <TELL
"\"I've known the boy for some time, and believe me, he's no good. He's
wasted more money this year than you've probably earned. His father
reprimanded him frequently, as you know. George even threatened his father
from time to time.\"" CR>)
		      (<EQUAL? ,PRSI ,CORPSE ,DUNBAR ,GLOBAL-DUNBAR>
		       <TELL
"\"Ms. Dunbar is an efficient and tireless worker. She has been of tremendous
help to Marshall and has been working quite hard for him lately. She had a
great deal of respect for him, that's clear. She has a keen mind and is an
exceptional strategic planner for the corporation.\"" CR>)
		      (<EQUAL? ,PRSI ,MRS-ROBNER ,GLOBAL-MRS-ROBNER>
		       <TELL
"\"Leslie is a fine woman from a distinguished family. She was much more
outgoing than Marshall, but she seems to have become accustomed to the quiet
life here. I am quite grieved for her.\"" CR>)
		      (<OR <EQUAL? ,PRSI ,ROURKE ,GLOBAL-ROURKE>
			   <EQUAL? ,PRSI ,GARDENER ,GLOBAL-GARDENER>>
		       <TELL
"\"I don't know much about " D ,PRSI "\"." CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-OLD-WILL>
		       <TELL
"\"I really don't know anything about the old will.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-MR-ROBNER>
		       <TELL
"\"Marshall was a truly great man...a brilliant manager; he started the
corporation single-handedly about 25 years ago and is mostly responsible for
its reputation. I owe him a great deal. He was also a great philanthropist
and got the corporation involved in many charitable works. I am not given to
shows of emotion, Inspector, but I will miss him greatly.\"" CR>)
		      (T
		       <TELL
"\"I can't help you there.\"" CR>)>)
	       (<VERB? CONFRONT SHOW>
		<COND (<NOT <GRAB-ATTENTION ,BAXTER>> <RTRUE>)
		      (<==? ,PRSI ,LAB-REPORT>
		       <TELL
"Baxter studies the report carefully. \"This is quite peculiar. It appears
that Marshall was murdered. I wonder...I would have a word with George if I
were you, Inspector.\"" CR>)
		      (<==? ,PRSI ,STUB>
		       <PERFORM ,V?ASK-ABOUT ,BAXTER ,STUB>
		       <RTRUE>)
		      (<AND <==? ,PRSI ,NOTE-PAPER>
			    ,NOTE-READ
			    <NOT ,B-NOTE>>
		       <SETG B-NOTE T>
		       <TELL
"He reads it carefully against the light, then speaks: \"I really don't know
what to make of this. Marshall seems to be insisting that I do something. I'm
afraid we will never know, since I never got the note.\"" CR>)
		      (<AND <==? ,PRSI ,BAXTER-PAPERS> <NOT ,B-FOCUS>>
		       <SETG B-FOCUS T>
		       <TELL
"He reads slowly and leafs through the pages. \"I'm afraid I haven't been
entirely candid with you. There was some trouble a few years ago with Focus
Corp. because of some, let us say, irresponsible dealings on my part. Marshall
agreed to cover up my involvement to save the company any bad publicity.\"" CR>
		       <COND (,B-NOTE
			      <TELL
"\"I can't understand why he would be insisting that I do this or that,
though, as it says on that note you showed me. He must have changed his
mind, since I never received the note.\"" CR>)>
		       <RTRUE>)
		      (<==? ,PRSI ,LETTER>
		       <TELL
"\"Very interesting, Inspector, but I assure you that this fellow is quite
off base about the business. Marshall and I were in complete agreement when
it came to those matters. I can't imagine where he got that idea.\"" CR>)
		      (T
		       <TELL
"\"I can't understand why you are showing this to me. Have
you nothing better to do than " <PICK-ONE ,BAXTER-ANNOYED> "?\"" CR>)>)>>

<ROUTINE MURDER-NOT-PROVEN (PERSON "OPTIONAL" (ARG T))
	 <TELL
"Sergeant Duffy dutifully appears and escorts " D .PERSON " from the
grounds.|
|">
	 <END-HEADER "July 26">
	 <TELL
"I am sorry to inform you that the District Attorney's office has declined
to seek an indictment against " D .PERSON " in the case of the death of Mr.
Robner, against your recommendation. It is still not clear that Mr. Robner
was murdered, although, as you point out, there are a number of suspicious
characters in the Robner household.">
	 <COND (<NOT .ARG>
		<TELL "  Additionally, Mr. Baxter seems to have
had no clear motive for killing Mr. Robner.">)>
	 <CRLF>
	 <COND (<==? .PERSON ,BAXTER>
		<TELL
"Mr. Baxter has threatened to sue the department for malicious
arrest, but we feel that he will prefer to avoid the publicity." CR>)>
	 <TELL "     Please be more careful in the future!|
|">
	 <CASE-OVER>>

<GLOBAL BAXTER-ANNOYED
	<LTABLE "show me useless items"
		"pick up every item in the house and show it to me">>

<ROUTINE GLOBAL-PERSON ()
	 <COND (<OR <AND <VERB? ASK-ABOUT>
			 <FSET? ,PRSO ,PERSON>
			 <NOT <IN? ,PRSO ,GLOBAL-OBJECTS>>>
		    <VERB? WHAT FIND WAIT-FOR FOLLOW CALL CALL-LOSE>>
		<RFALSE>)
	       (<VERB? TELL>
		<TELL "It's not clear to whom you are referring." CR>
		<SETG P-CONT <>>
		<RTRUE>)
	       (T
		<COND (<FSET? ,PRSO ,PERSON>
		       <TELL D ,PRSO>)
		      (T <TELL D ,PRSI>)>
		<COND (<AND <VERB? ASK-ABOUT TELL>
			    <NOT <==?
				   <BAND
				     <GETP
				       <LOC <GET ,CHARACTER-TABLE
						 <GETP ,PRSO ,P?CHARACTER>>>
				       ,P?CORRIDOR>
				     <GETP ,HERE ,P?CORRIDOR>> 0>>>
		       <TELL " can't hear you." CR>)
		      (<AND <==? ,PRSO ,GLOBAL-MRS-ROBNER>
			    <==? ,HERE ,MASTER-BATH>
			    <IN? ,MRS-ROBNER ,MASTER-BEDROOM>>
		       <TELL " can't hear you." CR>)
		      (T <TELL " isn't here!" CR>)>
		<SETG P-CONT <>>
		<RTRUE>)>>

<ROUTINE GEORGE-F ("OPTIONAL" (RARG <>))
	 <COND (<==? .RARG ,M-OBJDESC>
		<COND (<IN-MOTION? ,GEORGE> <RTRUE>)
		      (<IN? ,GEORGE ,KITCHEN>
		       <TELL "George is here, preparing a snack."
			     CR>)
		      (<IN? ,GEORGE ,DINING-ROOM>
		       <TELL
"George is sitting at the table, eating some red herrings."
			     CR>)
		      (<IN? ,GEORGE ,LIVING-ROOM>
		       <COND (,POST-WILL
			      <TELL
"George is staring contentedly out the bay window." CR>)
			     (T
			      <TELL
"George is here, pacing around the room." CR>)>)
		      (<IN? ,GEORGE ,NORTH-LAWN>
		       <TELL "George is here, staring out over the lake." CR>)
		      (<AND <IN? ,GEORGE ,GEORGE-ROOM> <NOT ,GEORGE-WAIT>>
		       <COND (,TUNE-ON
			      <TELL
"George is lying on his bed, listening intently to a " ,TUNE-ON "." CR>)
			     (T 
			      <TELL
"George is sitting on his bed, deep in thought." CR>)>)
		      (T <TELL "George is here." CR>)>
		<CARRY-CHECK ,GEORGE>)
	       (<VERB? HELLO GOODBYE>
		<TELL "George looks up and grunts disinterestedly." CR>)
	       (<==? ,WINNER ,GEORGE>
		<COND (<VERB? FIND> <RFALSE>)
		      (<COM-CHECK ,GEORGE> <RTRUE>)
		      (T <TELL <PICK-ONE ,WHY-ME> CR>)>)
	       (<AND <VERB? CALL> <G? ,GEORGE-RUN 0>>
		<TELL "\"Don't bother me!\" he shouts, and continues on." CR>)
	       (<VERB? SEARCH SEARCH-OBJECT-FOR>
		<COND (<==? <GET <GET ,GOAL-TABLES ,GEORGE-C> ,GOAL-S>
			    ,NORTH-LAWN>
		       <TELL
"George points accusingly at you. \"Don't come near me! I'm getting sick and
tired of your accusing tone. Get lost!\"" CR>)
		      (T
		       <TELL
"\"Buzz off! Don't come back until you get a search warrant!\" He chuckles in
contempt." CR>)>)
	       (<VERB? ACCUSE>
		<TELL
"George sneers at you. \"What an ass! Go on, try to prove it!\"" CR>)
	       (<VERB? ARREST>
		<COND (<OR ,NEW-WILL-SEEN ,GEORGE-RUN>
		       <TELL
"Faithful Sergeant Duffy enters and handcuffs George, who spits at you. \"You
filthy, stinking...\" is all you hear as George is carted off struggling.|
|">
		       <END-HEADER "August 4">
		       <TELL
"I am sorry to inform you that George Robner was acquitted in the death of
his father today. It seems the evidence, consisting mainly of a new will
which George admitted under pressure that he was trying to destroy, was
insufficient for the jury to return a guilty verdict. Although I suspect that
George may have committed the crime, his arrest was a bit premature.|
|">
		       <CASE-OVER>)
		      (T <RFALSE>)>)
	       (<VERB? CONFRONT SHOW>
		<COND (<NOT <GRAB-ATTENTION ,GEORGE>> <RTRUE>)
		      (<==? ,PRSI ,LAB-REPORT>
		       <TELL
"George scans the report. \"Killed, eh? I wonder who might have wanted...\" He
cocks his head in thought. \"I'm sorry, Inspector, I really should act a bit
better with you. I thought you were just snooping about, digging up dirt about
the family. I'm not sure...I can't believe Mom would have anything to do with
it, although...Baxter, now there's a worm for you. He'd do anything, maybe
even murder, to get ahead. I just don't know.\"" CR>)
		      (<==? ,PRSI ,LETTER>
		       <TELL
"George reads the letter quickly. \"Pompous ass! What does he know about
it?\" He pauses. \"I thought Mom was having an affair. How nice for the
lovebirds that Dad is dead! They can finish their honeymoon plans without
worrying. It's perfect!\" With a bitter laugh, he throws the letter to the
ground." CR>
		       <SETG G-LETTER T>
		       <MOVE ,LETTER ,HERE>)
		      (<AND <==? ,PRSI ,DESK-CALENDAR>
			    <==? ,CALENDAR-PAGE 8>
			    <NOT ,GEORGE-SEQUENCE>>
		       <SETG G-CALENDAR T>
		       <COND (<G? ,WILL-TIME 0>
			      <TELL
"\"I...uh...I don't really know what to say. I guess that Dad...but there is
no other...I can't help you...sorry.\" George seems to be quite agitated." CR>
			      <GEORGE-HACK>)
			     (T
			      <TELL
"George tilts his head in thought (or perhaps surprise) but recovers quickly.
\"All I know is that Coates is my father's personal attorney.\"" CR>)>)
		      (<AND <==? ,PRSI ,NEWSPAPER> ,NEWSPAPER-READ>
		       <DISCRETION ,GEORGE ,BAXTER>
		       <TELL
"\"So Baxter's arranged the merger. I'll be damned. That's strange, since
Dad was opposed to the whole thing. He's worried about losing control of
the company ever since he had to sell off most of his interest. I bet he
doesn't even own enough shares to prevent the deal.\"
He shakes his head in disbelief." CR>)>)
	       (<AND <VERB? ASK-ABOUT> <==? ,PRSO ,GEORGE>>
		<COND (<NOT <GRAB-ATTENTION ,GEORGE>> <RTRUE>)
		      (<==? ,PRSI ,GLOBAL-HIDDEN-CLOSET>
		       <COND (<OR ,SAFE-SEEN ,NEW-WILL-SEEN>
			      <TELL
"\"What of it? Dad's safe is there. I don't think anyone knows about it
except Dad and me.\"" CR>)
			     (T
			      <TELL
"\"Hidden closet, you say? Hmm. I think I'd know if there was one, but there
isn't!\"" CR>)>)
		      (<==? ,PRSI ,GLOBAL-MERGER>
		       <TELL
"\"I've heard talk of a merger between Dad's company and another one,
but I don't think it's happened yet. Dad would be furious if it did,
though. I can tell you that!\"" CR>)
		      (<==? ,PRSI ,GLOBAL-STEVEN>
		       <COND (,G-LETTER
			      <TELL
"\"He's a little worm who's been coming by lately. He's one of those fancy
ski-instructor types, if you know what I mean. From what I've seen, it
wouldn't surprise me if he and Mom are having an affair.\"" CR>)
			     (T
			      <DISCRETION ,GEORGE ,MRS-ROBNER>
			      <TELL
"\"Steven? Oh, you must mean the guy who comes around for Mom now and
then. I don't know much about him. Dresses a bit above himself, I'll say
that much.\"" CR>)>)
		      (<EQUAL? ,PRSI ,BAXTER ,GLOBAL-BAXTER>
		       <TELL
"\"I don't know much about him, really. With Baxter, it's always business,
and he's not here much except to discuss business with Dad. You might ask Ms.
Dunbar about him, though. She handled lots of Dad's business matters herself,
so they work together a lot. They probably know each other pretty well.\"" CR>)
		      (<EQUAL? ,PRSI ,CORPSE ,DUNBAR ,GLOBAL-DUNBAR>
		       <TELL
"\"She's been here for about ten years, I guess. She knows a lot about Dad's
business, and he lets her take care of a lot of stuff by herself. Other than
that, I can't say. We don't get in each other's way. I think she's heard Dad
lecture me too often.\"" CR>)
		      (<EQUAL? ,PRSI ,MRS-ROBNER ,GLOBAL-MRS-ROBNER>
		       <TELL
"\"She's OK. Not as stuck up as Dad about money. We've always gotten
along pretty well. I think she understands me better than Dad ever
did.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-SAFE>
		       <COND (,NEW-WILL-SEEN
			      <TELL
"\"Let's not go into it, ok? You caught me looking for the will. Well, what of
it? I didn't kill Dad, if that's what you're thinking. Leave me alone!\"" CR>)
			     (,SAFE-SEEN
			      <TELL
"\"You mean my father's safe? Yeah, if he brings important papers home he puts
them in there. He keeps most important stuff at the office at the bank. You
really startled me in there. I thought I might be able to get it open. Dad
always acted like it was a big secret, something out of a spy story. Anyway,
it turns out I don't remember the combination. It was a long time ago.\"" CR>)
			     (,GEORGE-SEQUENCE
			      <TELL
"George turns toward you with rage in his eyes. \"I don't know anything about
any damn safe! Now leave me alone or I'll have you kicked out of here!\" He
turns away." CR>)
			     (T
			      <TELL
"George looks briefly toward the ceiling, as if recalling something. \"Oh, I'm
sorry. A safe? No, I don't know about any safe...except at the office, that
is. I think there's one there.\"" CR>)>)
		      (<EQUAL? ,PRSI ,GARDENER ,GLOBAL-GARDENER>
		       <TELL
"\"McNabb, that old bore? Always talking about the damn roses and weeds. Don't
ask him about them, unless you have all day.\"" CR>)
		      (<EQUAL? ,PRSI ,ROURKE ,GLOBAL-ROURKE>
		       <DISCRETION ,GEORGE ,ROURKE>
		       <TELL
"\"She's nice but awfully nosy. She acts like she knows everything that goes
on around here, but she doesn't know the half of it.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-OLD-WILL>
		       <TELL
"\"I know what you know.\"" CR>)
		      (<EQUAL? ,PRSI ,NEW-WILL ,GLOBAL-NEW-WILL>
		       <COND (<G? ,PRESENT-TIME ,WILL-TIME>
			      <COND (<FSET? ,NEW-WILL ,TOUCHBIT>
				     <TELL
"\"You should know what it says.\"" CR>)
				    (,NEW-WILL-SEEN
				     <TELL
"\"I don't know what you're talking about. There's no new will. Dad never
wrote one! He would just threaten me when I asked for spending money.\"" CR>)
				    (,GEORGE-SEQUENCE
				     <TELL
"\"Look. I know the same as you. There's no new will. I'm sure of it. Dad
would have rubbed my nose in it: you can be sure of that!\"" CR>)
				    (,AT-READING
				     <TELL
"\"You were there when I was. Coates says there's no new will.\"" CR>)
				    (<0? ,WILL-TIME>
				     <TELL
"\"Dad always threatened to write a new will, but I guess he ran out
of time.\" He chuckles disturbingly." CR>)
				    (T
				     <TELL
"\"Oh, yeah. You skipped out on the will reading. Anyhow, Coates says there's
no new will, and he should know, right?\"" CR>)>)
			     (,G-CALENDAR
			      <TELL
"\"I know what you're getting at...the desk calendar. Look, I've heard nothing
about a new will. Maybe the old man just wanted to change something.\"" CR>)
			     (T
			      <TELL
"\"I don't know anything about any new will.\"" CR>)>)
		      (<==? ,PRSI ,GLOBAL-MR-ROBNER>
		       <TELL
"\"Like I told your detective friend yesterday, we didn't get along too well.
He was always riding me, giving me a hard time.\" George gets worked up
talking about it.\"Look, man. I'm not going to lie and say I loved him, right?
He got what...\" He stops in mid-sentence." CR>)
		      (<==? ,PRSI ,GLOBAL-FOCUS>
		       <TELL
"\"Focus...Focus...That name rings a bell. Something about the company, quite
a while ago...what was it? I can't remember now. I don't pay much attention to
business stuff: I've got better things to do.\"" CR>)
		      (T <TELL "\"I haven't a clue.\"" CR>)>)>>

<GLOBAL HO-HUMS
	<LTABLE " is standing here.">>

"Global Flags"

<GLOBAL NOTE-READ <>>

<GLOBAL B-NOTE <>>

<GLOBAL B-FOCUS <>>

<GLOBAL G-CALENDAR <>>

<CONSTANT WILL-READING 720>

<GLOBAL LADDER-FLAG <>>

<GLOBAL WILL-READY <>>

<GLOBAL YUKS
	<LTABLE "Don't be ridiculous."
		"Surely you jest."
		"You can't be serious!">>

<GLOBAL G-LETTER <>>

"Object functions"

<GLOBAL CALENDAR-PAGE 7>

<ROUTINE DESK-CALENDAR-F ("OPTIONAL" (RARG <>) "AUX" PAG)
	 <COND (<AND <VERB? READ EXAMINE> <==? ,PRSI ,INTNUM>>
		<COND (<OR <0? ,P-NUMBER> <G? ,P-NUMBER 30>>
		       <TELL "Why?  Is it your birthday?" CR>)
		      (T
		       <TELL
"You flip the pages until you find the page." CR>
		        <SETG CALENDAR-PAGE ,P-NUMBER>)>)>
	 <COND (<VERB? CLOSE> <TELL "It's not worth the effort." CR>)
	       (<AND <VERB? TURN> <NOT ,PRSI>>
		<COND (<==? ,CALENDAR-PAGE 31>
		       <TELL
"You have reached the end of the book." CR>
		       <RTRUE>)
		      (T <SETG CALENDAR-PAGE <+ ,CALENDAR-PAGE 1>>)>
		<SETG PRSA ,V?READ>)>
	 <SET PAG ,CALENDAR-PAGE>
	 <COND (<==? .RARG ,M-OBJDESC>
		<TELL
"A desk calendar is here, open to July " N ,CALENDAR-PAGE "." CR>)
	       (<VERB? READ EXAMINE>
		<TELL
"It is open to July " N ,CALENDAR-PAGE "." CR>
		<COND (<==? .PAG 8>
		       <TELL
"There is only one notation here, in the 9AM spot:
\"Call Coates: Will completed\"." CR>)
		      (<==? .PAG 7>
		       <TELL
"The only listing here is an appointment with Baxter at 2PM
at the Robner Corp. office." CR>)
		      (T
		       <TELL
"Nothing of interest is scheduled on this date." CR>)>)
	       (<VERB? TURN>
		<COND (<NOT <==? ,PRSI ,INTNUM>>
		       <TELL "Huh?" CR>)
		      (<G? ,P-NUMBER 30>
		       <TELL
"Thirty days hath September,|
April, June, and November,|
All the rest have " N ,P-NUMBER "???" CR>)
		      (<0? ,P-NUMBER>
		       <TELL "Do you suppose that would be June 30?" CR>)
		      (T
		       <SETG CALENDAR-PAGE ,P-NUMBER>
		       <TELL
"The calendar is now open to July " N ,P-NUMBER "." CR>)>)>>

<ROUTINE NOTE-PAPER-F ()
	 <COND (<VERB? READ EXAMINE>
		<COND (,NOTE-READ
		       <PAD-READ "Examination of the paper">)
		      (<==? ,P-ADVERB ,W?CAREFULLY>
		       <TELL
"There are some indentations on the paper. Something may have been
written on the previous sheet." CR>)
		      (T 
		       <TELL
"There doesn't seem to be anything written on the pad." CR>)>)
	       (<VERB? RUB>
		<COND (<NOT ,PRSI>
		       <TELL
"You should try rubbing or shading the pad with something." CR>)
		      (<==? ,PRSI ,PENCIL>
		       <PAD-READ "Shading the paper with the pencil">)>)
	       (<AND <VERB? RUN-OVER> <==? ,PRSO ,PENCIL>>
		<PAD-READ "Running the pencil over the paper">)
	       (<AND <VERB? HOLD-UP> <==? ,PRSI ,GLOBAL-LIGHT>>
		<PAD-READ "Looking at the pad against the light">)>>

<ROUTINE PAD-READ (STR)
	 <SETG NOTE-READ T>
	 <TELL .STR
" reveals impressions left by writing on the previous sheet. The writer must
borne down heavily, but only a few words come out clearly:|
|
  Baxter,|
|
                  st time|
 nsist             op       merg|
       mnidy               Oth|
          forc|
         ocumen     y poss|
  plica     y      Focus s|
          recons|
late!|
                              rsha|" CR>>

<GLOBAL P-ADVERB <>>

<GLOBAL NEWSPAPER-READ <>>

<ROUTINE READ-SECOND-SECTION ()
	 <SETG NEWSPAPER-READ T>
	 <TELL
"In your study of the second section, a small item in the financial section
catches your eye. A merger between Robner Corp. and Omnidyne is set to be
concluded shortly. There is a picture of Mr. Baxter with Omnidyne president
Starkwell, both smiling broadly. Baxter is quoted as saying that the deal
will enable the financially ailing Robner Corp. to continue to produce the
highest-quality products. The article points out that Marshall Robner, who
founded Robner Corp. but is no longer its major stockholder, had been found
dead yesterday morning, an apparent suicide victim. Baxter is quoted as
saying that Robner was in full agreement with the terms of the merger." CR>>

<ROUTINE NEWSPAPER-F ()
	 <COND (<VERB? EXAMINE READ OPEN>
		<COND (<EQUAL? ,P-ADVERB ,W?CAREFULLY ,W?SLOWLY>
		       <READ-SECOND-SECTION>)
		      (T
		       <TELL
"The Daily Herald is a local paper in two sections. In your cursory look at
the first, you find a brief obituary for Mr. Robner. It details his career,
including the formation of Robner Corp. A few years ago, Mr. Robner and the
Robner Corp. were given a prestigious award for works in the community. At
that time Robner said \"I am proud to accept this award for the Corporation.
Robner Corp is my whole life, and I will continue to guide it for the public
interest as long as I live.\" Robner himself had won great public acclaim for
his charitable works." CR>)>)>>

<ROUTINE SECOND-SECTION-F ()
	 <COND (<VERB? TAKE>
		<COND (<IN? ,NEWSPAPER ,WINNER>
		       <TELL "You already have the whole newspaper." CR>)
		      (T
		       <PERFORM ,V?TAKE ,NEWSPAPER>
		       <RTRUE>)>)
	       (<NOT <IN? ,NEWSPAPER ,WINNER>>
		<TELL "You don't have the newspaper." CR>)
	       (<VERB? EXAMINE READ>
		<READ-SECOND-SECTION>
		<RTRUE>)
	       (<VERB? DROP>
		<TELL
"You shouldn't leave pieces of the paper lying around. At least
leave the whole thing." CR>)>>

"Interrupt handlers"

<ROUTINE I-MAIL ()
	 <COND (<OR <EQUAL? ,HERE ,FRONT-PATH>
		    <AND <EQUAL? ,HERE ,FOYER>
			 <FSET? ,FRONT-DOOR ,OPENBIT>>>
		<TELL
"A mailman walks briskly up to you, hands you an envelope,
and departs." CR>
		<MOVE ,ENVELOPE ,WINNER>
		<FSET ,ENVELOPE ,TOUCHBIT>
		<RTRUE>)
	       (<EQUAL? ,HERE ,FOYER>
		<TELL
"There is a short rap on the front door.  A moment later, a thin
envelope appears under the door." CR>
		<MOVE ,ENVELOPE ,FOYER>
		<PUTP ,ENVELOPE
		      ,P?FDESC
		      "Partially exposed under the front door is an envelope.">
		<ENABLE <QUEUE I-MAIL-2 60>>
		<RTRUE>)
	       (T
		<MOVE ,ENVELOPE ,FOYER-TABLE>
		<ENABLE <QUEUE I-MAIL-2 60>>
		<COND (<EQUAL? ,HERE ,SOUTH-LAWN ,WEST-OF-DOOR ,EAST-OF-DOOR>
		       <TELL
"You notice a mailman stop by the house briefly and depart." CR>
		       <RTRUE>)
		      (T <RFALSE>)>)>>

<ROUTINE I-MAIL-2 ()
	 <COND (<EQUAL? <LOC ,ENVELOPE> ,FOYER ,FOYER-TABLE>
		<ESTABLISH-GOAL ,ROURKE ,FOYER T>
		<ENABLE <QUEUE I-MAIL-3 -1>>
		<RFALSE>)>>

<ROUTINE I-MAIL-3 ()
	 <COND (,ROURKE-MAIL
		<COND (<IN? ,ROURKE <LOC ,MRS-ROBNER>>
		       <QUEUE I-MAIL-3 0>
		       <ESTABLISH-GOAL ,ROURKE ,ROURKE-ROOM T>
		       <COND (<AND <IN? ,ENVELOPE ,WINNER>
				   <IN? ,WINNER <LOC ,MRS-ROBNER>>>
			      <TELL
"Mrs. Rourke walks up to Mrs. Robner. \"I'm sorry, Ma'am, but this gentleman
has a letter that just arrived for you.\" Mrs. Robner grabs the letter from
you. \"That is none of your business!\"" CR>)
			     (<NOT <IN? ,ENVELOPE ,ROURKE>>
			      <RTRUE>)>
		       <COND (<==? ,HERE <LOC ,ROURKE>>
			      <COND (<IN? ,ENVELOPE ,ROURKE>
				     <TELL
"Mrs. Rourke hands an envelope to Mrs. Robner.">)>
			      <MOVE ,ENVELOPE ,MRS-ROBNER>
			      <COND (,ENVELOPE-OPENED
				     <TELL " Mrs. Robner examines the
envelope, then turns to you. \"You did this, I suppose.\" she says. \"You had
no right! I expected better treatment than this. You would think I were
suspected of wrongdoing!\"" CR>)
				    (T
				     <TELL " Mrs. Robner examines
the envelope briefly, then puts it in her pocket." CR>
				     <REMOVE ,ENVELOPE>)>
			      <RTRUE>)
			     (T <REMOVE ,ENVELOPE>)>
		       <RFALSE>)
		      (T <RFALSE>)>)
	       (<IN? ,ROURKE ,FOYER>
		<COND (<EQUAL? <LOC ,ENVELOPE> ,FOYER-TABLE ,FOYER>
		       <MOVE ,ENVELOPE ,ROURKE>
		       <FSET ,ENVELOPE ,TOUCHBIT>
		       <ESTABLISH-GOAL ,ROURKE <LOC ,MRS-ROBNER> T>
		       <SETG ROURKE-MAIL T>
		       <COND (<==? ,HERE ,FOYER>
			      <TELL
"Mrs. Rourke takes the envelope and starts to walk away." CR>
			      <RTRUE>)
			     (T <RFALSE>)>)
		      (T <UNPRIORITIZE ,ROURKE> <RFALSE>)>)>>

<GLOBAL ROURKE-MAIL <>>

<ROUTINE I-NEWSPAPER ()
	 <MOVE ,NEWSPAPER ,FRONT-PATH>
	 <COND (<EQUAL? ,HERE ,SOUTH-LAWN ,FRONT-PATH>
		<TELL
"The local paperboy, in an amazing athletic feat, throws a newspaper toward
the house from a distance of at least 100 feet. It even lands beside the front
door, rather than in the bushes." CR>
		<RTRUE>)>>

<GLOBAL WILL-WAIT 0>

<GLOBAL WILL-HOLD <>>

<ROUTINE I-WILL-READING ()
	 <COND (<AND <L? ,PRESENT-TIME 760>
		     <OR <NOT <IN? ,MRS-ROBNER ,LIVING-ROOM>>
			 <NOT <IN? ,DUNBAR ,LIVING-ROOM>>
			 <NOT <IN? ,BAXTER ,LIVING-ROOM>>
			 <NOT <IN? ,GEORGE ,LIVING-ROOM>>>>
		<SETG WILL-HOLD T>
		<QUEUE I-WILL-READING -1>
		<COND (<==? ,HERE ,LIVING-ROOM>
		       <COND (<PROB 70> <RFALSE>)
			     (<PROB 50>
			      <TELL
"Mr. Coates asks everyone to be patient, as not everyone is present." CR>)
			     (T
			      <TELL
"Mr. Coates appears distracted, looking frequently toward the door." CR>)>
		       <RTRUE>)>
		<RFALSE>)
	       (<NOT <==? ,HERE ,LIVING-ROOM>>
		<COND (<G? <SETG WILL-WAIT <+ ,WILL-WAIT 1>> 15>
		       <ENABLE <QUEUE I-WILL-MISSED -1>>
		       <WILL-HACK>
		       <RFALSE>)
		      (T
		       <QUEUE I-WILL-READING -1>
		       <RFALSE>)>)>
	 <COND (<==? ,HERE ,LIVING-ROOM>
		<SETG AT-READING T>
		<COND (<AND <G? ,PRESENT-TIME 720> <G? ,WILL-WAIT 3>>
		       <TELL
"The people present turn to look at you. Mrs. Robner glares at you. \"You
might at least have the courtesy to be here on time! Haven't you caused enough
disruption already? We should have started without you. Mr. Coates, please
proceed.\"" CR>)
		      (<G? ,PRESENT-TIME 760>
		       <TELL
"\"It's late, so let's begin!\" Coates says." CR>)
		      (,WILL-HOLD
		       <TELL
"\"Ah!\" Mr. Coates says, \"Everybody's here now.\"" CR>)>
		<TELL
"Mr. Coates begins: \"This is an awkward situation. Mr. Robner told me five
days ago that he wanted to execute a new will, and promised to call me when
it was completed. As I never heard from him, I must assume that he either
changed his mind or did not complete the new will. Therefore, the one in my
possession must be considered the most recent testament.\"" CR>
                <COND (,G-CALENDAR
		       <TELL
"You notice that George, who was not initially paying close attention, now
perks up and begins to look about anxiously." CR>)
		      (T
		       <TELL
"From the corner of your eye, you catch George nodding his head, as
if in approval, and smiling broadly." CR>)>
		<TELL
"Continuing, Mr. Coates says: \"Naturally, should a more recent will exist
and be found within a reasonable period, the present one will be voided.
I will proceed with reading the will here in my hands, which was executed
three years ago last month.\" He reads the will, simply written and direct,
leaving equal parts of the estate to his son, George Arthur Robner, and
his wife, Mrs. Leslie Phillips Robner." CR>
		<TELL
"There is some discussion, understated congratulations and overstated
sympathy, which Mr. Coates cuts short by clearing his throat. \"I must
leave now, I'm afraid. If you have any questions, I can be contacted
tomorrow.\" He picks up the phone, dials his office, and asks to be
picked up at the Robner estate." CR>
		<COND (,G-CALENDAR
		       <TELL
"George, now looking quite upset, starts for the door." CR>)>
		<WILL-HACK>
		<RTRUE>)>
	 <WILL-HACK>
	 <RFALSE>>

<ROUTINE WILL-HACK ()
	 <ESTABLISH-GOAL ,COATES ,SOUTH-LAWN T>
	 <SETG WILL-TIME ,PRESENT-TIME>
	 <SETG POST-WILL T>
	 <QUEUE I-WILL-READING 0>
	 <COND (,G-CALENDAR <GEORGE-HACK>)>>

<GLOBAL POST-WILL <>>

<ROUTINE GEORGE-HACK ("AUX" (GL <LOC ,GEORGE>))
	 #DECL ((GL) OBJECT)
	 <COND (<==? .GL ,HERE>
		<COND (<==? .GL ,GEORGE-ROOM>
		       <TELL
"George paces around. \"I just remembered,\" he says, \"I've got some personal
business to attend to. Would you mind?\" He shows you to the door." CR>)
		      (<==? <GETP .GL ,P?LINE> ,TOP-OF-THE-LINE-C>
		       <TELL
"\"I'm...I really have some business to do in my room. I'll speak
to you later,\" George says. He starts off toward his room." CR>)
		      (T
		       <TELL
"\"I've...got to be going now. I'll see you later,\" George says.
He starts to leave." CR>)>)>
	 <COND (<NOT <==? .GL ,GEORGE-ROOM>>
		<ESTABLISH-GOAL ,GEORGE ,GEORGE-ROOM T>)>
	 <SETG GEORGE-SEQUENCE T>
	 <ENABLE <QUEUE I-GEORGE-HACK -1>>>

<GLOBAL GEORGE-SEQUENCE <>>
<GLOBAL GEORGE-WAIT <>>
<GLOBAL GEORGE-READY <>>
<GLOBAL GEORGE-SCREAM <>>

<ROUTINE I-GEORGE-HACK ("AUX" (GL <LOC ,GEORGE>) GT (TMP <>))
	 <SET GT <GET ,GOAL-TABLES <GETP ,GEORGE ,P?CHARACTER>>>
	 <COND (,GEORGE-READY
		<COND (<==? ,HERE .GL>
		       <SETG GEORGE-READY <>>
		       <SETG GEORGE-SCREAM <>>
		       <SETG GEORGE-WAIT 1>
		       <TELL
"\"I don't understand you, Inspector. I asked to be alone so I can take care
of some business. I...I don't see why you have to snoop around here like I was
some sort of suspect.\"" CR>
		       <COND (,GEORGE-SCREAM
			      <TELL
"\"I said to close that door and not to come in! You must be deaf as well as
stupid!\"" CR>)>
		       <RTRUE>)
		      (<AND <FSET? ,GEORGE-DOOR ,OPENBIT>
			    <NOT ,GEORGE-SCREAM>>
		       <TELL
"As the door opens, you hear George say \"Close that door! I'm working!\"" CR>
		       <SETG GEORGE-SCREAM T>
		       <RTRUE>)>)
	       (,GEORGE-WAIT
		<COND (<==? ,HERE .GL>
		       <TELL
"George paces around the room, awaiting your departure with ill-concealed
impatience." CR>
		       <COND (<G? <SETG GEORGE-WAIT <+ ,GEORGE-WAIT 1>> 12>
			      <TELL
"\"I can't take this. You get on my nerves. I'm leaving.\"" CR>
			      <COND (<==? ,HERE <GET .GT ,GOAL-QUEUED>>
				     <PUT .GT ,GOAL-QUEUED ,LIVING-ROOM>)>
			      <UNPRIORITIZE ,GEORGE>
			      <SETG GEORGE-WAIT <>>
			      <QUEUE I-GEORGE-HACK 0>
			      <ENABLE <QUEUE GEORGE-HACK 30>>)>
		       <RTRUE>)
		      (T
		       <SETG GEORGE-WAIT <>>
		       <FCLEAR ,GEORGE-DOOR ,OPENBIT>
		       <COND (<EQUAL? ,HERE ,LIBRARY ,CORRIDOR-4 ,CORRIDOR-3>
			      <TELL
"You hear George's door close." CR>)>)>)
	       (<==? .GL ,GEORGE-ROOM>
		<COND (<==? ,HERE .GL>
		       <TELL
"\"I have business to attend to. Would you mind leaving?\"" CR>
		       <SETG GEORGE-WAIT 1>)
		      (T
		       <ENABLE <QUEUE I-GEORGE-HACK-2 5>>
		       <SETG GEORGE-READY T>
		       <COND (<AND <EQUAL? ,HERE ,CORRIDOR-4 ,CORRIDOR-3>
				   <FSET? ,GEORGE-DOOR ,OPENBIT>>
			      <FCLEAR ,GEORGE-DOOR ,OPENBIT>
			      <SET TMP T>
			      <TELL
"You hear George's door close." CR>)>
		       <FCLEAR ,GEORGE-DOOR ,OPENBIT>
		       .TMP)>)
	       (<==? ,HERE .GL>
		<COND (<NOT ,GEORGE-FOLLOW>
		       <SETG GEORGE-FOLLOW T>
		       <RFALSE>)
		      (<PROB 50>
		       <TELL
"\"Please stop following me around like this. Can I have no privacy? I'm
simply trying to take care of something personal.\"" CR>)
		      (T
		       <TELL
"\"Stop following me. My business is private.\"" CR>)>)
	       (<==? .GL ,CORRIDOR-4>
		<COND (<==? <BAND <GETP ,HERE ,P?CORRIDOR> 1> 1>
		       <TELL
"George glances in your direction, then enters his room." CR>
		       <MOVE ,GEORGE ,GEORGE-ROOM>)>)
	       (<AND <EQUAL? .GL ,CORRIDOR-3 ,CORRIDOR-2>
		     <EQUAL? ,HERE ,CORRIDOR-1 ,STAIR-TOP>>
		<TELL
"George glances back at you briefly, then continues on his way." CR>)>>

<GLOBAL GEORGE-FOLLOW <>>

"At this point, George is in his room having waited for some
time for his moment to try to enter the library secretly.
I-GEORGE-HACK is still enabled and running every move to
detect the chomper entering the room."

<ROUTINE I-GEORGE-HACK-2 ()
	 <COND (,GEORGE-READY
		<COND (<OR <==? <BAND <GETP ,HERE ,P?CORRIDOR> 1> 1>
			   <==? ,HERE ,LIBRARY>>
		       <QUEUE I-GEORGE-HACK-2 <RANDOM 9>>
		       <COND (<EQUAL? ,HERE ,CORRIDOR-2 ,CORRIDOR-1 ,STAIR-TOP>
			      <COND (<PROB 30>
				     <TELL
"A door opens down the hall. George steps out, spots you, and looks briefly
toward the window. After a moment he steps back into his room and shuts the
door." CR>)
				    (T
				     <TELL
"You faintly hear a door open and then close near the end of the hall." CR>)>)
			     (<EQUAL? ,HERE ,CORRIDOR-4 ,LIBRARY>
			      <TELL
"You hear George's door open and ">
			      <COND (<PROB 30>
				     <TELL "you catch a brief glimpse of his
head darting back into the doorway. You watch as the door closes again." CR>)
				    (T
				     <TELL "close again immediately." CR>)>)
			     (<FSET? ,GEORGE-DOOR ,OPENBIT>
			      <FCLEAR ,GEORGE-DOOR ,OPENBIT>
			      <TELL
"George walks up to his door and slams it in your face." CR>)
			     (<EQUAL? ,HERE ,CORRIDOR-3>
			      <TELL
"George opens his door and peeks out. He is startled by your presence,
excuses himself, and closes the door sharply in your face before you can
utter a word." CR>)>)
		      (T
		       <QUEUE I-GEORGE-HACK 0>
		       <MOVE ,GEORGE ,LIBRARY>
		       <FSET ,GEORGE-DOOR ,OPENBIT>
		       <QUEUE I-GEORGE-HACK-2 0>
		       <ENABLE <QUEUE I-GEORGE-HACK-3 -1>>
		       <COND (<==? ,HERE ,UPSTAIRS-CLOSET>
			      <TELL
"You hear George's door open and you see his head poke out briefly, scanning
the hallway. He apparently didn't see you, and darts across the hall to the
library." CR>)
			     (<==? ,HERE ,LIBRARY-BALCONY>
			      <TELL
"You see George through the doorway, looking down the hallway, then darting
into the library." CR>)>)>)
	       (T
		<QUEUE I-GEORGE-HACK-2 <RANDOM 9>>
		<RFALSE>)>>

<GLOBAL GEORGE-SEARCH 0>
<GLOBAL GEORGE-RUN 0>
<GLOBAL BOOKS-MOVED <>>

<ROUTINE I-GEORGE-HACK-3 ("AUX" (FLG <>))
	 <COND (<0? ,GEORGE-SEARCH>
		<COND (<==? ,HERE ,LIBRARY-BALCONY>
		       <TELL
"George walks purposefully toward the bookshelves. He looks around, but you
react before he can see you. When you peek out again, George is fiddling with
the shelves. His right arm reaches into the shelf and, to your amazement, the
unit of bookshelves on the left rotates away from the wall, revealing a
darkened room behind. George enters it, trembling with barely controlled fear
and excitement." CR>
		       <SET FLG T>
		       <SETG BOOKS-MOVED T>
		       <SETG GEORGE-MOVES-BOOKS T>
		       <MOVE ,GEORGE ,HIDDEN-CLOSET>)
		      (<==? ,HERE ,LIBRARY>
		       <TELL
"George hears you walk through the balcony doors and recoils in horror. He
runs across the hall to his own bedroom, slamming his door shut." CR>
		       <SET FLG T>
		       <SETG GEORGE-READY <>>
		       <SETG GEORGE-WAIT <>>
		       <FCLEAR ,GEORGE-DOOR ,OPENBIT>
		       <MOVE ,GEORGE ,GEORGE-ROOM>
		       <QUEUE I-GEORGE-HACK-3 0>
		       <QUEUE I-GEORGE-HACK-2 10>)
		      (T
		       <MOVE ,GEORGE ,HIDDEN-CLOSET>
		       <SETG BOOKS-MOVED T>)>)
	       (<1? ,GEORGE-SEARCH>
		<COND (<EQUAL? ,HERE ,LIBRARY ,LIBRARY-BALCONY>
		       <TELL
"A dim light in the hidden closet comes on. In the faint light, you can see
George motioning with his right hand. All at once, the shelf swings shut!" CR>
		       <SET FLG T>)>)
	       (<L? ,GEORGE-SEARCH 10>
		<COND (<FSET? ,HIDDEN-DOOR-L ,OPENBIT>
		       <TELL
"As the bookshelf swings open, you see George carefully dialing a combination
into a large wall safe. He turns in panic and, with an exclamation, knocks you
down and bolts out of the library." CR>
		       <SET FLG T>
		       <SETG SAFE-SEEN T>
		       <SETG GEORGE-SEARCH 0>
		       <QUEUE I-GEORGE-HACK-3 0>
		       <MOVE ,GEORGE ,CORRIDOR-1>
		       <ESTABLISH-GOAL ,GEORGE ,EAST-LAWN T>)>)
	       (<L? ,GEORGE-SEARCH 16>
		<COND (<FSET? ,HIDDEN-DOOR-L ,OPENBIT>
		       <FSET ,SAFE ,OPENBIT>
		       <SETG SAFE-SEEN T>
		       <TELL
"As the shelf swings open, George spins to face you. His expression, first
seemingly wild with happiness, changes to one of panic and horror. He jerks
around, trying feebly to conceal a piece of paper in his hands. He jumps
toward you, then recoils in fear. Finally, sobbing, he crumples to the floor,
clutching the paper beneath him. A large combination safe, imbedded in a wall,
is lying open. You enter the hidden closet." CR>
		       <SET FLG T>
		       <QUEUE I-GEORGE-HACK-3 0>
		       <MOVE ,NEW-WILL ,GEORGE>
		       <GOTO ,HIDDEN-CLOSET>
		       <ENABLE <QUEUE I-GEORGE-LEAVE-CLOSET 10>>
		       <SETG HERE ,HIDDEN-CLOSET>
		       <SETG NEW-WILL-SEEN T>)>)
	       (<==? ,GEORGE-SEARCH 16>
		<FCLEAR ,SAFE ,OPENBIT>
		<COND (<==? ,HERE ,LIBRARY>
		       <TELL
"Suddenly, the bookshelves swing out, forming an opening to a dark area
behind. George starts to emerge but stops suddenly as he notices you! With
jack-rabbit reflexes, he darts back inside.  Before you can act, the
shelves close again." CR>
		       <SET FLG T>
		       <MOVE ,GEORGE ,NORTH-LAWN>
		       <MOVE ,SOGGY-WILL ,LAKE>
		       <REMOVE ,NEW-WILL>
		       <QUEUE I-GEORGE-HACK-3 0>
		       <SETG GEORGE-RUN ,PRESENT-TIME>)
		      (T
		       <MOVE ,GEORGE ,LIBRARY>
		       ;<MOVE ,NEW-WILL ,GEORGE>
		       <QUEUE I-GEORGE-HACK-3 0>
		       <UNPRIORITIZE ,GEORGE>
		       <ESTABLISH-GOAL ,GEORGE ,NORTH-LAWN T>
		       <COND (<==? ,HERE ,LIBRARY-BALCONY>
			      ;<SETG NEW-WILL-SEEN T>
			      <TELL
"Suddenly, the shelf swings out, and George emerges. He walks over to a
special place in the shelves and reaches behind some books. The bookshelves
silently assume their normal position." ;"You notice that George is carrying a
piece of paper." CR>
			      <SET FLG T>)>)>)>
	 <SETG GEORGE-SEARCH <+ ,GEORGE-SEARCH 1>>
	 .FLG>

<GLOBAL SAFE-SEEN <>>

<GLOBAL NEW-WILL-SEEN <>>

<GLOBAL CALL-RING <>>

<GLOBAL GEORGE-MOVES-BOOKS <>>

<ROUTINE I-GEORGE-LEAVE-CLOSET ()
	 <COND (<IN? ,GEORGE ,HIDDEN-CLOSET>
		<ESTABLISH-GOAL ,GEORGE ,GEORGE-ROOM>
		<RFALSE>)>>

<ROUTINE I-CALL ("AUX" (MRL <LOC ,MRS-ROBNER>))
	 <COND (,CALL-RING
		<COND (<==? .MRL ,LIVING-ROOM>
		       <SETG CALL-RING <>>
		       <COND (<==? ,HERE ,LIVING-ROOM>
			      <TELL
"Mrs. Robner picks up the phone. \"Oh, hi. Look, I can't talk now. I'll call
you later, okay? Bye, then.\" She hangs up the phone." CR>
			      <ROBNER-CALL-MOVE>
			      <RTRUE>)>
		       <ROBNER-CALL-MOVE>
		       <RFALSE>)
		      (T
		       <TELL "The phone rings again." CR>
		       <COND (<GLOBAL-IN? ,TELEPHONE ,HERE>
			      <THIS-IS-IT ,TELEPHONE>)>
		       <RTRUE>)>)>
	 <COND (,CALL-IN-PROGRESS
		<COND (<G? <SETG CALL-IN-PROGRESS <+ ,CALL-IN-PROGRESS 1>> 15>
		       <SETG CALL-IN-PROGRESS <>>
		       <QUEUE I-CALL 0>
		       <UNPRIORITIZE ,MRS-ROBNER>
		       <RFALSE>)
		      (<OR <FSET? ,MASTER-BEDROOM-DOOR ,OPENBIT>
			   <==? ,HERE ,MASTER-BEDROOM>>
		       <TELL
"Mrs. Robner speaks quietly into the phone and hangs up." CR>
		       <SETG CALL-IN-PROGRESS <>>
		       <QUEUE I-CALL 0>
		       <UNPRIORITIZE ,MRS-ROBNER>
		       <RTRUE>)>)
	       (,CALL-WAITING
		<COND (<EQUAL? ,HERE .MRL ,MASTER-BATH ,BEDROOM-BALCONY>
		       <COND (<NOT <G? <SETG CALL-WAITING <+ ,CALL-WAITING 1>>
				       3>>
			      <TELL
"Mrs. Robner glares at you, holding the phone in one hand. \"Would you
mind terribly?\", she asks." CR>)
			     (,CALL-MOVE
			      <TELL
"\"I can't understand why you won't let me use the phone. Can't I talk to
my best friend? Hummph...I suppose it can wait, since you are being
so...uh...unhelpful.\" She puts down the receiver, rises from her bed, and
starts to leave." CR>
			      <SETG CALL-MOVE <>>
			      <SETG CALL-WAITING <>>
			      <QUEUE I-CALL 0>
			      <UNPRIORITIZE ,MRS-ROBNER>)
			     (T
			      <TELL
"\"I give up. What IS your problem, anyway?,\" Mrs. Robner asks, in a
barely controllable rage. \"I'll call you back,\" she says, and slams down
the receiver." CR>
			      <SETG CALL-MOVE <>>
			      <QUEUE I-CALL 0>
			      <UNPRIORITIZE ,MRS-ROBNER>)>)
		      (T
		       <ESTABLISH-CALL>
		       <RFALSE>)>)
	       (,CALL-MOVE
		<COND (<==? .MRL ,MASTER-BEDROOM>
		       <COND (<EQUAL? ,HERE ,BEDROOM-BALCONY ,MASTER-BATH
				      ,MASTER-BEDROOM>
			      <COND (<NOT <EQUAL? ,HERE ,MASTER-BEDROOM>>
				     <TELL
"Mrs. Robner enters her bedroom and spots you." CR>)>
			      <TELL
"\"I'd like to make a private phone call, if you have no objection,\" she
says. She motions toward the door." CR>
			      <SETG CALL-WAITING 1>)
			     (T
			      <ESTABLISH-CALL>
			      <RFALSE>)>)>)
	       (<EQUAL? ,HERE ,LIBRARY ,LIVING-ROOM ,MASTER-BEDROOM>
		<TELL "The telephone rings." CR>
		<THIS-IS-IT ,TELEPHONE>
		<ESTABLISH-GOAL ,MRS-ROBNER ,LIVING-ROOM T>
		<SETG CALL-RING T>
		<QUEUE I-CALL -1>)
	       (<==? ,HERE .MRL>
		<TELL
"You can hear a telephone ringing in a nearby room. Mrs. Robner
says \"Pardon me\" and starts for the door." CR>
		<SETG CALL-RING T>
		<QUEUE I-CALL -1>
		<ESTABLISH-GOAL ,MRS-ROBNER ,LIVING-ROOM T>)
	       (T
		<COND (<NOT <==? <GETP ,HERE ,P?LINE> ,OUTSIDE-LINE-C>>
		       <TELL
"You hear a phone ringing in a nearby room." CR>
		       <SETG CALL-RING T>
		       <QUEUE I-CALL -1>
		       <ESTABLISH-GOAL ,MRS-ROBNER ,LIVING-ROOM T>)
		      (<PROB 50>
		       <TELL
"You notice a very faint ringing sound coming from the house." CR>
		       <ROBNER-CALL-MOVE>
		       <RTRUE>)>)>>

<ROUTINE THIS-IS-IT (OBJ)
	 <SETG P-IT-OBJECT .OBJ>
	 <SETG P-IT-LOC ,HERE>>

<ROUTINE ESTABLISH-CALL ("AUX" COR)
	 <SETG CALL-MOVE <>>
	 <SETG CALL-IN-PROGRESS 1>
	 <FCLEAR ,MASTER-BEDROOM-DOOR ,OPENBIT>
	 <COND (<EQUAL? ,HERE ,CORRIDOR-1>
		<TELL
"Mrs. Robner shuts the door to the master bedroom." CR>)
	       (<EQUAL? ,HERE ,CORRIDOR-2 ,STAIR-TOP>
		<TELL
"You hear the master bedroom door shut." CR>)>>

<ROUTINE MASTER-BEDROOM-DOOR-F ()
	 <COND (<AND <VERB? LISTEN> ,CALL-IN-PROGRESS>
		<TELL
"You can hear the muffled voice of Mrs. Robner through the door." CR>)
	       (<VERB? KNOCK>
		<COND (,CALL-IN-PROGRESS
		       <TELL
"Mrs. Robner's calls out. \"Wait just one minute!\"" CR>)
		      (T <DOOR-F>)>)>>

<ROUTINE DOOR-F ()
	<COND (<VERB? LISTEN>
	       <TELL "You can't hear anything through the door." CR>)
	      (<VERB? KNOCK>
	       <COND (<AND <==? ,PRSO ,FRONT-DOOR>
			   <NOT ,WELCOMED>
			   <L? ,PRESENT-TIME 700>
			   <==? ,HERE ,FRONT-PATH>>
		      <TELL
"You hear footsteps inside the house. Mrs. Robner, dressed in black,
opens the door and greets you." CR>
		      <WELCOME>)
		     (<INHABITED? <DOOR-ROOM>>
		      <TELL "A muffled voice says, \"Come in!\"" CR>)
		     (T <TELL
"There is no answer at the door." CR>)>)>>

<ROUTINE WELCOME ()
	 <TELL
"\"Hello,\" she says, \"I'm Mrs. Robner. Please come in. I'm afraid I really
can't help you much. This is surely a terrible waste of time, not to mention
upsetting, having all these police marching around the house. This has been a
trying time, as I suppose you can understand. As I told Mr. Coates and the
other detective, you may look around but you must be out by 8 o'clock at the
latest. Oh, I almost forgot...Mr. Coates will be reading my husband's will at
noon in the living room. You may attend if you wish.\"">
	 <SETG WELCOMED T>
	 <REMOVE ,MRS-ROBNER>
	 <COND (<==? ,HERE ,FRONT-PATH>
		<CRLF>
		<TELL
"Mrs. Robner leads you into the house and closes the door behind you." CR>
		<CRLF>
		<GOTO ,FOYER>)>
	 <MOVE ,MRS-ROBNER ,FOYER>
	 <TELL
"\"I'm going to make myself some breakfast now. I'll be around all day if you
need anything. I'll do what I can to help. Good day!\"" CR>
	 <FCLEAR ,FRONT-DOOR ,OPENBIT>
	 <ESTABLISH-GOAL ,MRS-ROBNER ,KITCHEN>>

<GLOBAL WELCOMED <>>
<GLOBAL AT-READING <>>
<GLOBAL LOBLO-FLAG <>>

<ROUTINE INHABITED? (RM "AUX" F)
	 <COND (<NOT <SET F <FIRST? .RM>>> <RFALSE>)>
	 <REPEAT ()
		 <COND (<FSET? .F ,PERSON> <RTRUE>)>
		 <SET F <NEXT? .F>>
		 <COND (<NOT .F> <RFALSE>)>>>

<ROUTINE DOOR-ROOM ()
	 <COND (<==? ,PRSO ,MASTER-BEDROOM-DOOR>
		,MASTER-BEDROOM)
	       (<==? ,PRSO ,GEORGE-DOOR>
		,GEORGE-ROOM)
	       (<==? ,PRSO ,DUNBAR-DOOR>
		,DUNBAR-ROOM)
	       (<==? ,PRSO ,ROURKE-DOOR>
		,ROURKE-ROOM)>>

<GLOBAL CALL-IN-PROGRESS <>>

<GLOBAL CALL-WAITING <>>

<GLOBAL CALL-MOVE <>>

<GLOBAL CALL-OVERHEARD <>>

<GLOBAL ROBNER-OLD-LOC <>>

<ROUTINE ROBNER-CALL-MOVE ()
	 <SETG ROBNER-OLD-LOC <LOC ,MRS-ROBNER>>
	 <ESTABLISH-GOAL ,MRS-ROBNER ,MASTER-BEDROOM T>
	 <SETG CALL-MOVE T>
	 <QUEUE I-CALL -1>>

<ROUTINE TELEPHONE-F ()
	 <COND (<NOT <EQUAL? ,HERE ,LIBRARY ,MASTER-BEDROOM ,LIVING-ROOM>>
		<TELL "There's no telephone here." CR>)
	       (<VERB? FIND>
		<TELL "You are the detective, after all." CR>)
	       (<VERB? TAKE LISTEN REPLY>
		<COND (,CALL-RING
		       <TELL
"You take the phone and hear an unfamiliar man's voice
say \"Hello?  Is Leslie there?\"  You start to reply, but Mrs. Robner">
		       <COND (<==? ,HERE ,LIVING-ROOM>
			      <TELL "
enters and takes the phone from you. \"Thank you, inspector,\" she says, and
then into the telephone: \"Hello? Oh, hi. I can't really talk now. I'll call
you back soon, OK? Bye.\" She hangs up and starts toward the door." CR>)
			     (T
			      <TELL "
picks up the phone from another extension and hears you. \"I've got it,
inspector,\" she says. \"Hello? Oh, it's you. I can't talk now. I'll call
you back soon. Bye!\" You hear two clicks and the line goes dead." CR>)>
		       <SETG CALL-RING <>>
		       <MOVE ,MRS-ROBNER ,LIVING-ROOM>
		       <ROBNER-CALL-MOVE>)
		      (,CALL-IN-PROGRESS
		       <TELL
"You can hear Mrs. Robner and a man whose voice you don't recognize.
Robner: \"...much too early to consider it.\"|
Man's Voice: \"But we couldn't have planned it better. You're free.\"|
Robner: \"Yes, but it will...Wait a second...I think...\"|
\"Click.\" You realize that the call has been disconnected." CR>
		       <SETG CALL-OVERHEARD T>
		       <SETG CALL-IN-PROGRESS <>>
		       <QUEUE I-CALL 0>
		       <UNPRIORITIZE ,MRS-ROBNER>)
		      (T
		       <TELL
"All you hear is a dial tone." CR>)>)>>

<GLOBAL ENVELOPE-OPENED <>>

<ROUTINE ENVELOPE-F ()
	 <COND (<VERB? OPEN>
		<COND (<==? <LOC ,MRS-ROBNER> ,HERE>
		       <TELL
"Mrs. Robner grabs the envelope from you. \"That,\" she
says, \"is none of your business!\"" CR>
		       <MOVE ,ENVELOPE ,MRS-ROBNER>
		       <RTRUE>)>
		<SETG ENVELOPE-OPENED T>
		<COND (<AND <NOT <IN? ,ENVELOPE ,WINNER>> <ITAKE <>>>
		       <TELL "(Taken)" CR>)>
		<RFALSE>)
	       (<AND <VERB? CLOSE> ,ENVELOPE-OPENED>
		<TELL
"You close the envelope carefully, but it still looks like it has been
opened." CR>
		<FCLEAR ,ENVELOPE ,OPENBIT>
		<RTRUE>)>>

<ROUTINE IN-MOTION? (PERSON "AUX" GT)
	 <SET GT <GET ,GOAL-TABLES <GETP .PERSON ,P?CHARACTER>>>
	 <COND (<AND <GET .GT ,GOAL-ENABLE>
		     <GET .GT ,GOAL-S>
		     <NOT <==? <LOC .PERSON> <GET .GT ,GOAL-F>>>>
		<RTRUE>)
	       (T <RFALSE>)>>

<ROUTINE MRS-ROBNER-F ("OPTIONAL" (RARG <>))
	 <COND (<AND <NOT .RARG> <VERB? GIVE> <==? ,PRSO ,ENVELOPE>>
		<PERFORM ,V?SHOW ,MRS-ROBNER ,ENVELOPE>
		<RTRUE>)>
	 <COND (<==? .RARG ,M-OBJDESC>
		<COND (<IN-MOTION? ,MRS-ROBNER>
		       <COND (,CALL-MOVE
		              <TELL "Mrs. Robner appears to be in a hurry."
				    CR>)>
		       T)
		      (,CALL-WAITING
		       <TELL "Mrs. Robner is staring at you." CR>)
		      (<IN? ,MRS-ROBNER ,KITCHEN>
		       <TELL "Mrs. Robner is preparing a meal." CR>)
		      (<IN? ,MRS-ROBNER ,DINING-ROOM>
		       <TELL "Mrs. Robner is eating breakfast here." CR>)
		      (<IN? ,MRS-ROBNER ,LIVING-ROOM>
		       <COND (,POST-WILL <RTRUE>)
			     (T
			      <TELL
 "Mrs. Robner is sitting here, knitting." CR>)>)
		      (<IN? ,MRS-ROBNER ,MASTER-BEDROOM>
		       <TELL "Mrs. Robner is sitting on her bed." CR>)
		      (T <TELL "Mrs. Robner is here." CR>)>
		<CARRY-CHECK ,MRS-ROBNER>)
	       (<VERB? HELLO GOODBYE>
		<TELL "Mrs. Robner says a curt \"">
		<COND (<VERB? HELLO> <TELL "Hello">)
		      (T <TELL "Bye">)>
		<TELL "\"." CR>)
	       (<==? ,WINNER ,MRS-ROBNER>
		<COND (<VERB? FIND> <RFALSE>)
		      (<AND <VERB? OPEN> <==? ,PRSO ,ENVELOPE>>
		       <COND (,ENVELOPE-OPENED
			      <TELL
"\"You seem to have taken care of that already.\"" CR>)
			     (T
			      <TELL
"\"I believe there are laws protecting the privacy of mail. I will not
open the envelope for you or anyone else.\"" CR>)>)  
		      (<COM-CHECK ,MRS-ROBNER> <RTRUE>)
		      (T <TELL <PICK-ONE ,WHY-ME> CR>)>)
	       (<AND <VERB? ARREST> <OR ,ENVELOPE-OPENED ,CALL-OVERHEARD>>
		<COND (<NOT <FSET? ,LAB-REPORT ,TOUCHBIT>>
		       <MURDER-NOT-PROVEN ,MRS-ROBNER>
		       <RTRUE>)>
		<TELL
"Sergeant Duffy enters and leads Mrs. Robner away.|
|">
		<END-HEADER "August 2">
		<TELL
"I am sorry to inform you that the grand jury investigating the murder charge
against Mrs. Robner declined to indict her, citing a lack of evidence linking
her with the execution of the crime. Please try to be more cautious when
making arrests in the future.|
|" CR>
		<CASE-OVER>)
	       (<AND <VERB? ASK-ABOUT> <==? ,PRSO ,MRS-ROBNER>>
		<COND (<NOT <GRAB-ATTENTION ,MRS-ROBNER>> <RTRUE>)
		      (<==? ,PRSI ,GLOBAL-HIDDEN-CLOSET>
		       <COND (,HC-ROBNER
			      <TELL
"\"I'm quite shocked about it. I really had no idea!\"" CR>)
			     (T
			      <TELL
"\"I don't know what you're talking about, Inspector. I know of
no such closet.\"" CR>)>)
		      (<EQUAL? ,PRSI ,GLOBAL-ALLERGONE ,ALLERGONE
			       	     ,ALLERGONE-BOTTLE>
		       <TELL
"\"I have some allergies, Inspector. Simply dreadful in the fall and spring.
That's what the Allergone is for. I don't use them much this time of year,
though.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-SNEEZO ,SNEEZO ,SNEEZO-BOTTLE>
		       <TELL
"\"Sneezo is a wonderful cold remedy. Whenever I get a cold, I just take
a few, and I usually feel much better before long.\"" CR>)
		      (<==? ,PRSI ,GLOBAL-CALL>
		       <COND (<AND ,CALL-OVERHEARD ,MR-ENVELOPE>
			      <TELL
"\"I guess you know it was Steven. I admit we were lovers, and we planned to
marry if I could get a divorce from Marshall. He refused to consider it, the
divorce I mean, even though he had no time for me anymore.  He was married to
the company, and he refused to see my side of things. Steven was suggesting
that now we could marry. I told him I thought the timing was poor, or at least
I would have if you hadn't eavesdropped.\"" CR>)
			     (,CALL-OVERHEARD
			      <TELL
"\"I was talking to a good friend of mine. We were discussing some plans we
made; of course they had to be changed, under the circumstances. They are none
of your business. They don't concern my husband's suicide at all, I assure
you.\"" CR>)
			     (T
			      <TELL
"\"It was just a friend of mine, offering his condolences.\"" CR>)>)
		      (<==? ,PRSI ,GLOBAL-STEVEN>
		       <COND (<NOT ,MR-ENVELOPE>
			      <TELL
"\"I don't know who you mean. I have no friend named Steven.\"" CR>)
			     (<AND ,CALL-OVERHEARD ,MR-ENVELOPE>
			      <TELL
"\"I might as well tell you. Steven and I were lovers and we were going to be
married if I could divorce Marshall. I asked Marshall about it, but he became
angry and refused. I didn't know what to do. Don't look at me that way. I had
nothing to do with my husband's death. Driving him to it with talk of divorce?
You didn't know Marshall, that's for sure! I should've told the police
earlier, I suppose, but it's really none of your business.\"" CR>)
			     (,MR-ENVELOPE
			      <TELL
"\"Steven is a close personal friend. We have known each other for many
years, and I visit his home frequently. Marshall knew of our friendship
and didn't begrudge it in the slightest. My husband and I had a very
trusting relationship. You may find the idea of trust difficult to understand,
I suppose.\"" CR>)>)
		      (<==? ,PRSI ,GLOBAL-MR-ROBNER>
		       <TELL
"\"I loved my husband, no matter what you may think. I am very sorry to have
lost him.\" The speech is almost a set piece, and not too convincing." CR>)
		      (<EQUAL? ,PRSI ,GEORGE ,GLOBAL-GEORGE>
		       <DISCRETION ,MRS-ROBNER ,GEORGE>
		       <TELL
"\"A child. He may be a man in age, but he still hasn't really grown up. He'll
find himself someday, but in the meantime he can be a trial.  I guess Marshall
and I were too lenient. We probably still are, but he is our son, after all.
We can't throw him out on the street.\"" CR>)
		      (<EQUAL? ,PRSI ,BAXTER ,GLOBAL-BAXTER>
		       <TELL
"\"Baxter has been my husband's partner for a long time, but they're not close
friends. Baxter has always had the head for making money, and Marshall had the
creative spark for new products. The two of them were perfect for each other
in the early days. Of course, things haven't been going well lately. I guess
none of that matters much now.\"" CR>)
		      (<EQUAL? ,PRSI ,CORPSE ,DUNBAR ,GLOBAL-DUNBAR>
		       <DISCRETION ,MRS-ROBNER ,DUNBAR>
		       <TELL
"\"I've always thought she was a bit too smug in her relationships around
here. A bit above herself, if you see my meaning. After all, she's really
just a glorified secretary. She acts as though she's part of the family, and
she does get along well with almost everyone here. I swear, though, Marshall
spent more time with her than me, lately. Um...not that I'm trying to imply
that anything went on between them. Quite the contrary.\"" CR>)
		      (<EQUAL? ,PRSI ,ROURKE ,GLOBAL-ROURKE>
		       <DISCRETION ,MRS-ROBNER ,ROURKE>
		       <TELL
"\"She's an excellent housekeeper and sometimes even helps with the cooking
For all her good qualities, though, she's too much of a snoop and a gossip.
She tires to keep track of everyone around here. It's unnerving sometimes.
But, as servants go these days, she's quite extraordinary.\"" CR>)
		      (<EQUAL? ,PRSI ,GARDENER ,GLOBAL-GARDENER>
		       <TELL
"\"I don't pay much attention to him. He's worked out well; the grounds are
in excellent condition. You must take a look at his roses while you're here.
They're really spectacular.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-OLD-WILL>
		       <COND (<G? ,WILL-TIME 0>
			      <TELL
"\"It's what I expected, really.\"" CR>)
			     (T
			      <TELL
"\"Marshall takes care of that sort of thing. The will, I suppose, leaves
the estate to George and me, but I can't be sure.\"" CR>)>)
		      (<EQUAL? ,PRSI ,NEW-WILL>
		       <TELL
"\"What do you know? Marshall changed the will, after all. Where did you ever
find this? What? George was trying to destroy it? I'm shocked. You don't think
George had anything to do...\" She stops short." CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-NEW-WILL>
		       <TELL
"\"If there is a new will, I certainly don't know where it is.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-FOCUS>
		       <TELL
"\"Oh, you mean the \"scandal\"? Focus Corporation was a subsidiary of Robner
Corp. some years ago. There was a big to-do about misuse of funds or some such
thing, but Marshall kept it pretty quiet. He told me that the people
responsible were forced out of the company, but that charges weren't pressed
to avoid bad publicity. I didn't realize anyone remembered that.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-SAFE>
		       <TELL
"\"I don't know of a safe in the house, although it's perfectly
believable that Marshall has one hidden somewhere. It would appeal
to his childish side, I think.\"" CR>)
		      (T
		       <TELL
"\"I don't know much about that.\"" CR>)>)
	       (<VERB? CONFRONT SHOW>
		<COND (<NOT <GRAB-ATTENTION ,MRS-ROBNER>> <RTRUE>)
		      (<==? ,PRSI ,LAB-REPORT>
		       <TELL
"Mrs. Robner reads the report with shocked disbelief. \"I...I don't know what
to say. Who would want to kill Marshall? He was so well liked and...\" She
breaks down, sobbing." CR>)
		      (<==? ,PRSI ,NEW-WILL>
		       <TELL
"Mrs. Robner reads the will. \"That's that, then,\" she says.
\"I guess Marshall was pushed too far.\"" CR>)
		      (<EQUAL? ,PRSI ,ENVELOPE ,LETTER>
		       <COND (<NOT ,ENVELOPE-OPENED>
			      <TELL
"\"Thank you, Inspector. The envelope is for me.\" She takes the
envelope from you and examines it briefly." CR>
			      <MOVE ,ENVELOPE ,MRS-ROBNER>
			      <RTRUE>)>
		       <SETG MR-ENVELOPE T>
		       <TELL
"\"You have certainly stooped to a new low, Inspector. Opening people's mail.
I think there are laws against that sort of thing, but I guess you wouldn't
know.">
		       <COND (,CALL-OVERHEARD
			      <TELL " I suppose you also know that Steven is
my lover and that we were planning to marry. Don't look so melodramatic: I
didn't kill my husband. You think my talk of divorce may have driven him to
it? Why don't you leave me alone!\"" CR>)
			     (T
			      <TELL
" In any case, what of it? It's from a friend of mine, an old friend from
school. We get together now and then to discuss old times. I don't suppose
there is a law against that?\"" CR>)>)>)>>

<GLOBAL MR-ENVELOPE <>>

<ROUTINE BOOKSHELVES-F ()
	 <COND (<AND <VERB? TAKE> <==? ,PRSI ,BOOKSHELVES>>
		<TELL
"That would make an ungodly pile of books on the floor and take most of
the day." CR>)
	       (<VERB? TAKE>
		<TELL
"You have better things to do than taking books from the shelves." CR>)
	       (<VERB? READ>
		<TELL
"Reading, while educational, will not help you solve this case." CR>)
	       (<VERB? LOOK-BEHIND>
		<TELL
"It would take all day to look behind all of the books." CR>)
	       (<VERB? EXAMINE SEARCH>
		<TELL
"The shelves contain many books and manuscripts covering a wide range of
subjects. They are meticulously arranged." CR>
		<COND (<OR ,GEORGE-MOVES-BOOKS
			   <AND ,BOOKS-MOVED <==? ,P-ADVERB ,W?CAREFULLY>>>
		       <TELL
"One book is out of place, however, leaving a gap in one row. On closer
inspection, a small black button can be seen at the back of this gap." CR>
		       <SETG BUTTON-REVEALED T>
		       <FCLEAR ,LIBRARY-BUTTON ,INVISIBLE>)>
		<RTRUE>)>>

<GLOBAL BUTTON-REVEALED <>>

<ROUTINE LIBRARY-BUTTON-F ()
	 <COND (<VERB? PUSH>
		<COND (<FSET? ,HIDDEN-DOOR-L ,OPENBIT>
		       <TELL
"The bookshelf on the left quietly swings shut." CR>
		       <FCLEAR ,HIDDEN-DOOR-L ,OPENBIT>)
		      (T
		       <TELL
"The leftmost shelf quietly swings out against the balcony window." CR>
		       <FSET ,HIDDEN-DOOR-L ,OPENBIT>)>)>>

<GLOBAL COR-1
	<TABLE P?WEST P?EAST
	       CORRIDOR-4 CORRIDOR-3 CORRIDOR-2 CORRIDOR-1 STAIR-TOP 0>>

<GLOBAL COR-2
	<TABLE P?NORTH P?SOUTH
	       STAIR-TOP SHALL-11 0>>

<GLOBAL COR-4
	<TABLE P?WEST P?EAST
	       SHALL-11 SHALL-12 0>>

<GLOBAL COR-8
	<TABLE P?SOUTH P?NORTH
	       FOYER NFOYER CORNER 0>>

<GLOBAL COR-16
	<TABLE P?NORTH P?SOUTH
	       STAIR-BOTTOM SHALL-1 0>>

<GLOBAL COR-32
	<TABLE P?WEST P?EAST
	       WEST-LAWN WEST-OF-DOOR FRONT-PATH EAST-OF-DOOR EAST-LAWN 0>>

<GLOBAL COR-64
	<TABLE P?NORTH P?SOUTH
	       EAST-SIDE EAST-OF-DOOR SOUTH-LAWN 0>>

<GLOBAL COR-128
	<TABLE P?NW P?SE
	       NORTH-LAWN ORCHARD EAST-LAWN 0>>

<GLOBAL COR-256
	<TABLE P?WEST P?EAST
	       NFOYER STAIR-BOTTOM STAIRS 0>>

<GLOBAL COR-512
	<TABLE P?WEST P?EAST
	       GUEST-ROOM EAST-LAWN 0>>

<GLOBAL COR-1024
	<TABLE P?NORTH P?SOUTH
	       UPSTAIRS-CLOSET CORRIDOR-2 0>>

<GLOBAL COR-2048
	<TABLE P?WEST P?EAST
	       ROSE-GARDEN ORCHARD 0>>

<GLOBAL CHINA-EXAMINED <>>

<ROUTINE CSCP ()
	 <COND (<VERB? TAKE RUB MOVE>
		<TELL
"These items are very rare and delicate, and were used only by Mr.
Robner himself.  You shouldn't even be touching them." CR>)
	       (<VERB? EXAMINE>
		<TELL
"Each one is hand-painted and depicts a scene from Greek mythology." CR>
		<SETG CHINA-EXAMINED T>)
	       (<VERB? MUNG>
		<COND (<PROB 75>
		       <TELL
"As you reach for the " D ,PRSO ", you think of the pension awaiting you
upon retirement. \"Is it worth it?\" you think, to be booted off the force
for an impulse of anger and stupidity. Fortunately, you calm your temper." CR>)
		      (T
		       <TELL
"With a sweep of your hand, you smash all of them!
Mrs. Rourke runs into the room, screaming." CR>
		       <GONE-CRAZY>)>)>>

<ROUTINE GONE-CRAZY ()
	 <TELL
"Your mind becomes confused amidst strange screaming, yelling, and the pangs
of your conscience. \"How could I have done it?\" you ask yourself, as you
hear the distant sound of police sirens. Sergeant Duffy and two other officers
enter and grab you rather unceremoniously. They take you to a waiting car,
where, forlorn and disgusted, you begin to ponder prison life. \"Perhaps,\"
you think, \"I shouldn't have done that.\"" CR>
	 <CASE-OVER>>

<ROUTINE CUPS-F ()
	 <COND (<VERB? TAKE RUB MOVE EXAMINE MUNG>
		<CSCP>)
	       (<VERB? COUNT>
		<TELL "There are six hand-painted cups." CR>)>>

<ROUTINE SAUCERS-F ()
	 <COND (<VERB? TAKE RUB MOVE EXAMINE MUNG>
		<CSCP>)
	       (<VERB? COUNT>
		<TELL "There are seven hand-painted saucers." CR>)>>

<ROUTINE CHINA-F ()
	 <COND (<VERB? TAKE RUB MOVE EXAMINE MUNG>
		<CSCP>)
	       (<VERB? COUNT>
		<TELL
"There are eight large and small plates, seven saucers, and six cups." CR>)>>

<ROUTINE PLATES-F ()
	 <COND (<VERB? TAKE RUB MOVE EXAMINE MUNG>
		<CSCP>)
	       (<VERB? COUNT>
		<TELL
"There are eight of both the large and the small plates." CR>)>>

<GLOBAL LADDER-POSITIONED <>>

<ROUTINE LADDER-F ()
	 <COND (<AND <VERB? PUT> <==? ,PRSI ,HOLE>>
		<TELL
"The ladder fits perfectly in the holes! You slowly release the
ladder and it rests on the railing of the balcony above." CR>
		<SETG LADDER-FLAG T>
		<MOVE ,LADDER ,HERE>
		<SETG LADDER-POSITIONED T>
		<FSET ,LADDER ,NDESCBIT>)
	       (<AND <VERB? CLIMB-UP>
		     <NOT ,LADDER-FLAG>
		     <NOT ,LADDER-FLAG-2>>
		<TELL
"Climbing a ladder while it is horizontal is, at best, a contradiction
in terms." CR>)
	       (<AND <VERB? LEAN> <EQUAL? ,PRSI ,HOUSE ,BALCONY>>
		<COND (<==? ,HERE ,IN-ROSES>
		       <SETG LADDER-FLAG T>
		       <SETG LADDER-FLAG-2 <>>
		       <SETG LADDER-POSITIONED T>
		       <MOVE ,LADDER ,HERE>
		       <TELL
"The ladder is now leaning against the railing of a balcony above." CR>)
		      (<==? ,HERE ,IN-ORCHARD>
		       <SETG LADDER-FLAG <>>
		       <SETG LADDER-FLAG-2 T>
		       <MOVE ,LADDER ,HERE>
		       <TELL
"The ladder, firmly planted in the soil of the orchard, is now leaning
against the balcony above." CR>)
		      (T
		       <TELL
"There is no good spot to lean it against here." CR>
		       <RTRUE>)>
		<FSET ,LADDER ,NDESCBIT>)
	       (<VERB? TAKE MOVE>
		<FCLEAR ,LADDER ,NDESCBIT>
		<SETG LADDER-FLAG <>>
		<SETG LADDER-FLAG-2 <>>
		<RFALSE>)
	       (<VERB? EXAMINE>
		<TELL
"The ladder is a typical gardening ladder, about fifteen feet long and caked
with dirt and dried mud." CR>)>>

<ROUTINE CUP-F ()
	 <COND (<VERB? EXAMINE LOOK-INSIDE>
		<TELL
"The cup is painted with a scene from Greek mythology and has a brown
discoloration at the bottom." CR>)
	       (<VERB? SMELL>
		<TELL "The cup smells faintly of tea." CR>)
	       (<VERB? FINGERPRINT>
		<TELL
"There don't seem to be any fingerprints on the cup." CR>)
	       (<AND <VERB? ANALYZE> <==? ,CUP ,PRSO>> <DO-ANALYZE>)>>

<GLOBAL ANALYSIS-GOAL <>>

<ROUTINE DO-FINGERPRINT ("OPTIONAL" (AN <>))
	 <COND (,FINGERPRINT-OBJ
		<TELL
"Sergeant Duffy is already at the lab running a previous errand.
You will have to wait for him to return." CR>
		<RTRUE>)>
	 <COND (<NOT .AN>
		<TELL
"You look at the " D ,PRSO " closely. It appears to have good
fingerprints on it, so you call for Sergeant Duffy." CR>)>
	 <COND (<AND .AN ,PRSI>
		<SETG ANALYSIS-GOAL ,PRSI>)
	       (T <SETG ANALYSIS-GOAL <>>)>
	 <SETG FINGERPRINT-OBJ ,PRSO>
	 <SETG ANALYSIS-OBJ .AN>
	 <COND (<==? ,PRSO ,LADDER>
		<COND (<G? ,PRESENT-TIME 720>
		       <TELL
"Sergeant Duffy arrives and shakes his head sadly. \"I'm sorry, sir, but
the Ladder Analysis Department closes at noon.\" He leaves." CR>
		       <SETG FINGERPRINT-OBJ <>>
		       <RFALSE>)>
		<SETG LADDER-FLAG <>>
		<SETG LADDER-FLAG-2 <>>
		<FCLEAR ,LADDER ,NDESCBIT>)>
	 <ENABLE <QUEUE I-FINGERPRINT <+ 15 <RANDOM 15>>>>
	 <REMOVE ,PRSO>
	 <FSET ,PRSO ,TOUCHBIT>
	 <TELL
"Sergeant Duffy walks up as quietly as a mouse. He takes the " D ,PRSO " from
you. \"I'll return soon with the results,\" he says, and leaves as silently as
he entered." CR>>

<GLOBAL ANALYSIS-OBJ <>>

<ROUTINE DO-ANALYZE () <DO-FINGERPRINT T>>

<ROUTINE I-FINGERPRINT ()
	 <TELL "Sergeant Duffy ">
	 <COND (<==? ,FINGERPRINT-OBJ ,LADDER>
		<TELL
"comes onto the scene. ">)
	       (<PROB 30>
		<TELL
"appears before you, holding the " D ,FINGERPRINT-OBJ
" carefully in his hands. His quiet efficiency and youthful vigor impress you
quite a bit. ">)
	       (<PROB 50>
		<TELL
"seems to arrive from nowhere, holding the " D ,FINGERPRINT-OBJ
" in his hands. ">)
	       (T
		<TELL
"returns with the " D ,FINGERPRINT-OBJ ".  For a moment you muse on his almost
magical entrances. ">)>
	 <COND (<NOT ,ANALYSIS-OBJ>
		<TELL "\"The fingerprints,\" he begins,
\"belong to ">
		<COND (<==? ,FINGERPRINT-OBJ ,CUP>
		       <TELL "Mr. Robner">)
		      (<EQUAL? ,FINGERPRINT-OBJ ,SAUCER ,SUGAR-BOWL>
		       <TELL "Mr. Robner and Ms. Dunbar">)>)
	       (,ANALYSIS-GOAL
		<COND (<AND <==? ,FINGERPRINT-OBJ ,FRAGMENT>
			    <EQUAL? ,ANALYSIS-GOAL ,LOBLO
				    ,LOBLO-BOTTLE ,GLOBAL-LOBLO>>
		       <TELL
"\"The fragment did contain LoBlo. Here is the full report.\"
He hands you a slip of paper, and departs." CR>
		       <MOVE ,LAB-REPORT ,PLAYER>
		       <FSET ,LAB-REPORT ,TOUCHBIT>
		       <MOVE ,FINGERPRINT-OBJ ,PLAYER>
		       <SETG FINGERPRINT-OBJ <>>
		       <RTRUE>)
		      (T
		       <TELL "\"The " D ,FINGERPRINT-OBJ
			     " analysis yielded nothing useful">)>)
	       (<==? ,FINGERPRINT-OBJ ,FRAGMENT>
		<TELL "\"The fragment,\" he begins,
\"contains traces of tea and sugar.">
		<TELL " In addition, there seems to be some other chemical
present that is not a common medication. It could take weeks to determine
exactly what it is. It is definitely not Amitraxin (Ebullion), though. There
are no clear fingerprints">)
	       (<==? ,FINGERPRINT-OBJ ,CUP>
		<TELL "\"The cup,\" he begins,
\"contains a trace of tea. The fingerprints are those of Mr. Robner">)
	       (<==? ,FINGERPRINT-OBJ ,SAUCER>
		<TELL "\"The saucer,\" he begins,
\"contains traces of tea and sugar. The fingerprints are
those of Mr. Robner and Ms. Dunbar">)
	       (<==? ,FINGERPRINT-OBJ ,SUGAR-BOWL>
		<TELL "\"The bowl,\" he begins,
\"has the fingerprints of Mr. Robner and Ms. Dunbar. The bowl
contains common table sugar only.">)
	       (T
		<TELL "\"I am sorry,\" he begins,
\" but the lab found nothing of interest.">)>
	 <COND (<AND <EQUAL? ,FINGERPRINT-OBJ ,LADDER>
		     <NOT <==? <GETP ,HERE ,P?LINE> ,OUTSIDE-LINE-C>>>
		<TELL " In the interests of
civility, I have left the ladder outside the house.\" He leaves." CR>
		<MOVE ,LADDER ,FRONT-PATH>)
	       (T
		<TELL "\".
With that, he leaves, handing you the " D ,FINGERPRINT-OBJ
					" as he whisks away." CR>
		<MOVE ,FINGERPRINT-OBJ ,PLAYER>)>
	 <SETG FINGERPRINT-OBJ <>>
	 <RTRUE>>

<ROUTINE ANALYSIS-PRINT (OBJ)
	 <COND (<EQUAL? .OBJ ,GLOBAL-LOBLO ,LOBLO ,LOBLO-BOTTLE>
		<TELL "LoBlo">)
	       (<EQUAL? .OBJ ,ASPIRIN ,ASPIRIN-BOTTLE>
		<TELL "aspirin">)
	       (<EQUAL? .OBJ ,EBULLION ,EBULLION-BOTTLE ,GLOBAL-EBULLION>
		<TELL "Ebullion">)
	       (<EQUAL? .OBJ ,DUM-KOF ,DUM-KOF-BOTTLE>
		<TELL "Dum-Kof">)
	       (<EQUAL? .OBJ ,ALLERGONE ,ALLERGONE-BOTTLE ,GLOBAL-ALLERGONE>
		<TELL "Allergone">)
	       (T <TELL D .OBJ>)>
	 <TELL "\". ">>

<ROUTINE SAUCER-F ()
	 <COND (<VERB? EXAMINE>
		<TELL
"The saucer is hand-painted with a mythological scene. It has a couple of
small areas of brown discoloration." CR>)
	       (<VERB? SMELL>
		<TELL "There is a faint smell of tea." CR>)
	       (<VERB? FINGERPRINT> <DO-FINGERPRINT>)
	       (<VERB? ANALYZE> <DO-ANALYZE>)>>

<ROUTINE SHOWER-F ()
	 <COND (<VERB? TAKE THROUGH>
		<TELL
"Being unusually grubby, even for a police detective, this is one of your
better ideas so far on this case. However, your attire isn't suitable, and
you probably have better things to do." CR>)>>

<ROUTINE TOILET-F ("OPTIONAL" (RARG 100))
	 <COND (<NOT <==? .RARG 100>> <RFALSE>)
	       (<VERB? EXAMINE LOOK-INSIDE>
		<TELL
"You have stooped to a new low, snooping around toilet bowls. Wait! Something
catches your eye--was it the Tidy-Bowl man? Is he the murderer?  Naw..." CR>)
	       (<VERB? FLUSH>
		<TELL "Whhoooossshhhhh!" CR>)>>

<ROUTINE SINK-F ()
	 <COND (<VERB? LAMP-ON>
		<TELL
"You turn the handle and lo! Water starts to run. Impressed, you turn the
handle again, and the water stops running! Bravo!" CR>)>>

<ROUTINE RANDOM-PSEUDO ()
	 <TELL "You can't do anything with that." CR>>

<ROUTINE WINDOW-F ()
	 <COND (<VERB? MUNG>
		<TELL
"Vandalism is not the answer! Think of your position. How would
it look for a famous police inspector to be arrested?" CR>)
	       (<VERB? BRUSH>
		<TELL
"You think you're clever, don't you? The window is so dirty that
it isn't easily cleaned." CR>)
	       (<VERB? LOOK-INSIDE>
		<TELL
"The window is dirty and impossible to see through clearly." CR>)>>

<ROUTINE WINDOW-KNOCK (RM)
	 <COND (<INHABITED? .RM>
		<TELL "Someone looks up at you disgustedly." CR>)>>

<ROUTINE KITCHEN-WINDOW-F ()
	 <COND (<VERB? MUNG BRUSH> <WINDOW-F>)
	       (<VERB? OPEN>
		<TELL "The window can't be opened." CR>)
	       (<VERB? KNOCK>
		<WINDOW-KNOCK <COND (<==? ,HERE ,KITCHEN> ,ORCHARD)
				    (T ,KITCHEN)>>)
	       (<VERB? LOOK-INSIDE>
		<COND (<==? ,HERE ,KITCHEN>
		       <TELL
"You can barely see through the thick leaves of the grape arbor,
but a lawn and lake can be seen in the distance." CR>)
		      (T
		       <TELL
"You can see the kitchen beyond the tangle of trees and branches.">
		       <WINDOW-SHOP ,KITCHEN "kitchen">)>)>>

<ROUTINE POPULATION (RM "OPTIONAL" (PR <>) "AUX" (CNT 0) OBJ)
	 #DECL ((RM) OBJECT (CNT) FIX)
	 <COND (<NOT <SET OBJ <FIRST? .RM>>> <RETURN .CNT>)>
	 <REPEAT ()
		 <COND (<FSET? .OBJ ,PERSON>
			<SET CNT <+ .CNT 1>>
			<COND (.PR <DESCRIBE-PERSON .OBJ "there">)>)>
		 <SET OBJ <NEXT? .OBJ>>
		 <COND (<NOT .OBJ> <RETURN .CNT>)>>>

<ROUTINE SHED-WINDOW-F ()
	 <COND (<VERB? MUNG BRUSH> <WINDOW-F>)
	       (<VERB? OPEN> <TELL "The window can't be opened." CR>)
	       (<AND <VERB? LISTEN> <G? ,SECRET-MEETING 0>>
		<TELL "You can't make out any of the words." CR>)
	       (<VERB? LOOK-INSIDE>
		<COND (<==? ,HERE ,SHED-ROOM>
		       <TELL
"Although the window is grimy, you can make out the lawn outside. ">
		       <WINDOW-SHOP ,EAST-LAWN "east lawn">)
		      (<==? ,SECRET-MEETING 4>
		       <TELL
"Mr. Baxter seems furious and about to strike Ms. Dunbar, then calms himself.
Ms. Dunbar starts to cry and is embraced by Mr. Baxter." CR>)
		      (<G? ,SECRET-MEETING 2>
		       <TELL
"Mr. Baxter and Ms. Dunbar are inside. Although you can't hear them, it's
clear from their gestures that a serious argument is occurring. Dunbar appears
very upset and breaks into tears. Baxter remains composed, but tense and 
perhaps angry -- you can't be sure." CR>)
		      (<G? ,SECRET-MEETING 0>
		       <TELL
"Through the grimy window you see Mr. Baxter and Ms. Dunbar talking. Dunbar
is doing most of the talking, barely restraining tears. Baxter is listening,
nodding grimly, and occassionally saying a few words. Unfortunately, you can't
make any of them out." CR>)
		      (T
		       <TELL
"You can vaguely make out the inside of the shed through the grime. ">
		       <WINDOW-SHOP ,SHED-ROOM "shed">)>)>>


<ROUTINE DINING-ROOM-WINDOW-F ()
	 <COND (<VERB? MUNG> <WINDOW-F>)
	       (<VERB? OPEN> <TELL "The window can't be opened." CR>)
	       (<VERB? LOOK-INSIDE>
		<COND (<==? ,HERE ,ROSE-GARDEN>
		       <TELL
"You can see the dining room through the window.">
		       <WINDOW-SHOP ,DINING-ROOM "dining room">
		       <RTRUE>)
		      (<==? ,HERE ,IN-ROSES>
		       <TELL
"You can see the dining room pretty clearly through the window." CR>
		       <POPULATION ,DINING-ROOM T>
		       <RTRUE>)
		      (T
		       <TELL
"Through the window, the rose garden can be seen, and, off to
the north, a wide lawn ending on a blue lake." CR>)>)>>

<ROUTINE WINDOW-SHOP (RM STR "AUX" (P <POPULATION .RM>))
	 <COND (<0? .P> <CRLF> <RTRUE>)
	       (T <TELL "
You can vaguely see ">)>
	 <COND (<1? .P>
		<TELL "someone">)
	       (T
		<PRINTN .P>
		<TELL " people">)>
	 <TELL " inside the " .STR "." CR>>

<ROUTINE DESCRIBE-PERSON (PERSON "OPTIONAL" (STR <>))
	 <TELL D .PERSON " is "
	       <COND (<NOT .STR> "here")
		     (T .STR)> "." CR>>

<ROUTINE MASTER-BEDROOM-DRESSER-F ()
	 <COND (<VERB? EXAMINE>
		<TELL
"The dresser is a beautiful piece of cabinetry." CR>)
	       (<VERB? LOOK-INSIDE SEARCH OPEN>
		<TELL
"You open all of the drawers, but find only a variety of stockings,
undergarments, and handkerchiefs." CR>)>>

<ROUTINE BED-F ("OPTIONAL" (RARG 100))
	 <COND (<NOT <==? .RARG 100>> <RFALSE>)
	       (<VERB? LOOK-UNDER>
		<TELL
"No doubt you are looking for the bogeyman, but you are out of luck." CR>)>>

<ROUTINE SUGAR-BOWL-F ()
	 <COND (<VERB? TASTE>
		<TELL "The powder tastes like sugar." CR>)
	       (<VERB? SMELL>
		<TELL "There is no high from sniffing this powder." CR>)
	       (<VERB? EAT>
		<TELL
"You eat some, but it is cloyingly sweet, so you stop." CR>)
	       (<VERB? FINGERPRINT> <DO-FINGERPRINT>)
	       (<VERB? ANALYZE> <DO-ANALYZE>)>>

<ROUTINE TOOLS-F ()
	 <COND (<VERB? TAKE>
		<TELL
"The tools are standard gardening tools, in excellent condition. You have no
use for them, unless you are looking for a new profession." CR>)>>

<ROUTINE DUNBAR-F ("OPTIONAL" (RARG <>))
	 <COND (<==? .RARG ,M-OBJDESC>
		<COND (<IN-MOTION? ,DUNBAR> <RTRUE>)
		      (<AND <IN? ,BAXTER ,SHED> <NOT <0? ,SECRET-MEETING>>>
		       <RTRUE>)
		      (,DUNBAR-BAXTER-MEET <RTRUE>)
		      (<IN? ,DUNBAR ,DUNBAR-BATH>
		       <TELL
"Ms. Dunbar is here, brushing her hair.">)
		      (<IN? ,DUNBAR ,DUNBAR-ROOM>
		       <TELL
"Ms. Dunbar is lying on her bed.">)
		      (<IN? ,DUNBAR ,LIVING-ROOM>
		       <COND (,POST-WILL
			      <TELL
"Ms. Dunbar is standing in the corner, looking pensive.">)
			     (T
			      <TELL
"Ms. Dunbar is sitting on the sofa here.">)>)
		      (T <TELL "Ms. Dunbar is here.">)>
		<CRLF>
		<CARRY-CHECK ,DUNBAR>
	        <RTRUE>)
	       (<==? ,WINNER ,DUNBAR>
		<COND (<VERB? FIND> <RFALSE>)
		      (<COM-CHECK ,DUNBAR> <RTRUE>)
		      (<VERB? HELLO GOODBYE>
		       <TELL "Ms. Dunbar nods at you." CR>
		       <RTRUE>)
		      (T <TELL <PICK-ONE ,WHY-ME> CR> <RTRUE>)>)
	       (<AND <VERB? HELLO ASK-ABOUT SHOW>
		     <NOT <GRAB-ATTENTION ,DUNBAR>>>
		<RTRUE>)>
	 <COND (<VERB? HELLO>
		<TELL "Ms. Dunbar nods at you." CR>)
	       (<AND <VERB? ASK-ABOUT> <==? ,PRSO ,DUNBAR>>
		<COND (<==? ,PRSI ,GLOBAL-CONCERT>
		       <COND (<OR ,STUB-D ,STUB-DX>
			      <TELL
"\"It was an excellent concert, Inspector, but I don't see why you're asking
about it.\"" CR>)
			     (T <TELL
"\"I don't know what you are talking about. I don't go in for concerts much,
you know.\"" CR>)>)
		      (<==? ,PRSI ,STUB>
		       <COND (,STUB-BX
			      <TELL
"\"Why, it's just as Mr. Baxter said.\"" CR>)
			     (T
			      <SETG STUB-D T>
			      <COND (<IN? ,BAXTER ,HERE>
				     <SETG STUB-DX T>)>
			      <COND (,STUB-B
				     <SETG CONTRADICTION T>)>
			      <TELL
"\"Oh, I...well, I guess I should tell you. You see, Mr. Baxter and I, we go
together to concerts, only occasionally, you understand. We went that night,
the night Marshall died. Then he took me home and that's it. I should have
said something before, but I just didn't think it was important, and, well,
I didn't think that the others should know we were seeing each other socially.
Our...nobody knows about it, you know. Please don't say anything!\"" CR>)>)
		      (<EQUAL? ,PRSI ,BAXTER ,GLOBAL-BAXTER>
		       <TELL
"\"Mr. Baxter? I see him often when he comes here on business, but I don't
really know him that well. We keep to business when he comes around, and I
hardly ever talk with him otherwise. He is, of course, an excellent executive,
and poor Mr. Robner had every confidence in him.\"" CR>)
		      (<EQUAL? ,PRSI ,LOBLO ,GLOBAL-LOBLO ,LOBLO-BOTTLE>
		       <COND (,LOBLO-FLAG
			      <TELL
"Ms. Dunbar is taken aback. \"I...I don't really know what to say. I take the
tablets for my blood pressure. I have for a few months now. I know what you're
thinking. I can't understand. Someone must have taken my pills and poisoned Mr.
Robner. That's it. It's probably George. He knew about my pills. He's always
snooping around. He used to talk about how half the money would be his
someday.\"" CR>)
			     (T
			      <TELL
"Ms. Dunbar seems a bit surprised. \"You found those in my bathroom, didn't
you? I've been taking them for months for my blood pressure. Are they
important?\" she asks." CR>)>)
		      (<EQUAL? ,PRSI ,GEORGE ,GLOBAL-GEORGE>
		       <DISCRETION ,DUNBAR ,GEORGE>
		       <TELL
"\"Nobody likes George much. He's always alone when he's here, and that's only
when he can't get more money to waste. I think he's just been waiting for the
day when his father's money would be his. I can't say I miss him when he's not
here: A thoroughly obnoxious child.\"" CR>)
		      (<EQUAL? ,PRSI ,MRS-ROBNER ,GLOBAL-MRS-ROBNER>
		       <TELL
"\"She's a lovely person. She and Marshall were always an odd couple: he was
so quiet and reserved, and she's so lively and sociable. She's changed a lot
over the last few years. She used to enjoy her life here, but lately she's
been restless and irritable, and now with Marshall's death, I'm worried about
what may become of her.\"" CR>)
		      (<EQUAL? ,PRSI ,ROURKE ,GLOBAL-ROURKE>
		       <TELL
"\"Mrs. Rourke is a very good servant. Always helpful, and always
nearby when needed.\"" CR>)
		      (<EQUAL? ,PRSI ,GARDENER ,GLOBAL-GARDENER>
		       <TELL
"\"He seems nice, if you can talk to him. You usually can't, really.\" She
laughs briefly. \"Don't ever disturb his roses, or you'll learn the meaning
of temper.\" She giggles again." CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-OLD-WILL>
		       <TELL
"\"I really don't know too much about Marshall's personal business.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-NEW-WILL>
		       <COND (<G? ,WILL-TIME 0>
			      <TELL
"\"I don't know anything about it. I suppose Marshall could have written a new
will, but I probably would have seen signs of it around the library.\"" CR>)
			     (T
			      <TELL
"\"As far as I know, there was no new will written, although Marshall did
threaten to disinherit George. I guess he could have written one without my
knowledge. I'm not always with him, you know.\"" CR>)>)
		      (<EQUAL? ,PRSI ,NEW-WILL>
		       <TELL
"Ms. Dunbar reads the will carefully, nodding slowly. \"I guess I'm not
surprised that Marshall disinherited George. He's been asking for it.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-MR-ROBNER>
		       <TELL
"Ms. Dunbar looks down at the ground and sniffles softly. \"I've known him
for years. He's been tremendously nervous and depressed lately about business.
I don't think all was well in his personal life either. George has always been
a problem for him. He even mentioned suicide once, although I never took it
seriously. It shows you can never tell.\" She wipes her eyes with her
hands." CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-FOCUS>
		       <TELL
"\"Focus? There was once a subsidiary of Robner Corp. with that name. I can't
recall much about it, though.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-SAFE>
		       <TELL
"\"A safe? I don't think there's one in the house, although there's one at
the office.\"" CR>)
		      (T
		       <TELL
"\"I'm sorry, but I can't help you with that.\"" CR>)>)
	       (<VERB? SHOW CONFRONT>
		<COND (<==? ,PRSI ,STUB>
		       <PERFORM ,V?ASK-ABOUT ,DUNBAR ,STUB>
		       <RTRUE>)
		      (<EQUAL? ,PRSI ,LOBLO>
		       <TELL
"She glances at the pills. \"They're my pills. You must have taken them from
my bathroom. Well, what am I supposed to say?\" She looks away." CR>)
		      (<EQUAL? ,PRSI ,LAB-REPORT>
		       <TELL
"She seems stunned but recovers quickly. \"He didn't commit suicide, then?\"
she says. \"But LoBlo, that's a pill I take for my blood pressure.\" She
pauses. \"I can tell what you're thinking, but I didn't, couldn't have done
it. Why should I? Someone must have taken them, maybe George. He knew I used
them.\"" CR>
		       <ENABLE <QUEUE I-DUNBAR-ACTIVATE <+ 5 <RANDOM 15>>>>
		       <SETG LOBLO-FLAG T>)>)
	       (<VERB? ACCUSE>
		<COND (,LOBLO-FLAG
		       <TELL
"\"No! I didn't do it! I've worked for Mr. Robner for years. What possible
motive could I have?\" With that, Ms. Dunbar begins to cry and move about
the room quite nervously." CR>
		       <DUNBAR-SEQUENCE>)
		      (T
		       <TELL
"\"What?\" she cries. \"Murder?\" She regains her composure and asks, \"I
thought he committed suicide, with his medicine.\"" CR>)>)
	       (<VERB? ARREST>
		<COND (<NOT <FSET? ,LAB-REPORT ,TOUCHBIT>>
		       <MURDER-NOT-PROVEN ,DUNBAR>
		       <RTRUE>)>
	        <TELL
"Sergeant Duffy enters the room solemnly. He places handcuffs on Ms. Dunbar
and leads her off. She is sobbing hysterically.|
|">
		<END-HEADER "August 10">
		<COND (,MEETING-INTERRUPTED
		       <TELL
"What a tragedy! Ms. Dunbar, released on bail during her trial for the murder
of Mr. Robner, was found dead this morning, the victim of an apparent suicide.
Her death is all the more distressing as the district attorney was trying to
arrange some plea-bargaining deal with her in exchange for information
implicating an unnamed accomplice. I am sorry to be the one to let you know.
Thanks for your hard work on the Robner case.|
|">)
		      (T <TELL
"I wanted to let you know the disposition of the Robner case. Ms. Dunbar was
acquitted today, the jury citing a lack of motive and only circumstantial
evidence. I am extremely sorry.|
|">)>
		<CASE-OVER>)>>

<GLOBAL STUB-D <>>
<GLOBAL STUB-B <>>
<GLOBAL STUB-DX <>>
<GLOBAL STUB-BX <>>

<ROUTINE I-DUNBAR-ACTIVATE ()
	 <COND (<NOT ,DUNBAR-ACCUSED>
		<DUNBAR-SEQUENCE>
		<RFALSE>)>>

<ROUTINE ROURKE-F ("OPTIONAL" (RARG <>))
	 <COND (<==? .RARG ,M-OBJDESC>
		<COND (<IN-MOTION? ,ROURKE> <RTRUE>)
		      (<IN? ,ROURKE ,KITCHEN>
		       <TELL
"Mrs. Rourke is here, cleaning the kitchen." CR>)
		      (<IN? ,ROURKE ,DINING-ROOM>
		       <TELL "Mrs. Rourke is cleaning the table here." CR>)
		      (<IN? ,ROURKE ,LIVING-ROOM>
		       <TELL "Mrs. Rourke is dusting the room." CR>)
		      (<IN? ,ROURKE ,ROURKE-ROOM>
		       <TELL "Mrs. Rourke is resting here." CR>)
		      (T <TELL "Mrs. Rourke is here, tidying up." CR>)>
		<CARRY-CHECK ,ROURKE>
		<RTRUE>)
	       (<==? ,WINNER ,ROURKE>
		<COND (<VERB? FIND> <RFALSE>)
		      (<COM-CHECK ,ROURKE> <RTRUE>) 
		      (<VERB? HELLO GOODBYE>
		       <TELL "Mrs. Rourke looks up from her work and nods."
			     CR>
		       <RTRUE>)
		      (T <TELL <PICK-ONE ,WHY-ME> CR> <RTRUE>)>)
	       (<AND <VERB? HELLO ASK-ABOUT SHOW>
		     <NOT <GRAB-ATTENTION ,ROURKE>>>
		<RTRUE>)>
	 <COND (<VERB? HELLO GOODBYE>
		<TELL "Mrs. Rourke looks up from her work and nods." CR>)
	       (<AND <VERB? ASK-ABOUT> <==? ,PRSO ,ROURKE>>
		<COND (<AND <==? ,PRSI ,ENVELOPE> <IN? ,ENVELOPE ,ROURKE>>
		       <TELL
"\"It's a letter just arrived for Mrs. Robner. I was going to bring
it to her.\"" CR>)
		      (<EQUAL? ,PRSI ,BAXTER ,GLOBAL-BAXTER>
		       <DISCRETION ,ROURKE ,BAXTER>
		       <TELL
"\"Baxter! Hmmmph. Stuffiest person I ever met! I don't mind telling you I've
never liked him much. So serious, businesslike. Thinks he's hot stuff, I
imagine. I really shouldn't be telling you this, though, I suppose.
\"Rourke,\" they tell me, \"stop your gossiping.\" Not that I'm a gossip,
mind you, but I do have my opinions.\"" CR>)
		      (<EQUAL? ,PRSI ,GEORGE ,GLOBAL-GEORGE>
		       <DISCRETION ,ROURKE ,GEORGE>
		       <TELL
"\"George is something, I tell you. The black sheep of the family, is what I'd
say. Never met nobody with less respect for money. You'd think it grew on
trees; not that it don't around here. Well, there I go, shooting off my mouth
again.\"" CR>)
		      (<EQUAL? ,PRSI ,CORPSE ,DUNBAR ,GLOBAL-DUNBAR>
		       <TELL
"\"Ms. Dunbar is nice; the best of the lot, I think. She's always been real
friendly to me, and helps out when I have a problem. Mr. Robner, he really
liked her too. I don't think Mrs. Robner did, though. He's been so busy lately
with the business and Ms. Dunbar that I don't think the Mrs. hardly saw him
much. Kind of jealous, maybe, of the two of them, I mean.\"" CR>)
		      (<EQUAL? ,PRSI ,MRS-ROBNER ,GLOBAL-MRS-ROBNER>
		       <DISCRETION ,ROURKE ,MRS-ROBNER>
		       <TELL
"\"Now she's a strange sort. Real lively when she moved here, but I don't
think she ever liked the life here. Her people are from Boston, one of those
old families, and she never got used to Mr. Robner's ways. She goes out a lot,
and sometimes she doesn't even come back at night. Not that I'm spying on her.
But I know about these things. She has callers here, a number of men. One in
particular comes more than others. A widower, I think, a real live wire. Not
what it's any of my business, but I think someone with a sharp tongue could do
her a lot of damage if she doesn't watch herself.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-STEVEN>
		       <DISCRETION ,ROURKE ,MRS-ROBNER>
		       <TELL
"\"Ah, that's it! He's the one who's been coming around, taking Mrs. Robner
out. I don't like the look of it. I mean, I think it looks kind of funny, what
with she's a married woman. Mr. Robner takes no notice, of course, always
busy. Oh, well. I shouldn't be telling you this. Now that Mr. Robner's dead,
I don't suppose it matters, but what do you think people were saying! I tell
you, gossip is fierce around here!\"" CR>)
     		      (<EQUAL? ,PRSI ,GARDENER ,GLOBAL-GARDENER>
		       <TELL
"\"Oh, don't let him frighten you. Let him alone and don't bother his roses.
Gets positively livid about that. Got the green thumb, that's for sure.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-MR-ROBNER>
		       <TELL
"\"A fine man, but his head was always in the clouds. Just the opposite of
Mrs. Robner. Her feet were always on the ground. He's been so worried, it
makes me sick. I don't understand these business things, but he said something
about them taking his business away from him just two nights ago. I guess the
pressure was too much. He was a fine man, full of good works, though charity
does begin at home, as the saying goes. Not that I have anything to complain
about. He always treated me right.\"" CR>)
		      (T
		       <TELL
"\"I don't know nothing about no " D ,PRSI "\"." CR>)>)
	       (<VERB? SHOW CONFRONT>
		<COND (<==? ,PRSI ,LAB-REPORT>
		       <TELL
"\"Well, if that don't beat all! A murder here, right under my nose! You've
got your work cut out for you, Inspector, all right. There's some pretty
strange people around here, and I wouldn't put it past hardly any of 'em to
do it. What do you know!\"" CR>)
		      (T <TELL "Mrs. Rourke seems uninterested in it." CR>)>)>>

<ROUTINE DISCRETION (P1 P2)
	 <COND (<IN? .P2 ,HERE>
	        <TELL D .P1 " looks briefly toward " D .P2 " and then speaks
in a low whisper." CR>)>>

<ROUTINE CARRY-CHECK (PERSON)
	 <COND (<FIRST? .PERSON>
		<PRINT-CONT .PERSON T 0>)>
	 T>

<ROUTINE DUM-KOF-F ()
	 <COND (<VERB? DRINK>
		<TELL
"You drink the remaining cough syrup. Yuk! That was awful!" CR>
		<REMOVE ,DUM-KOF>)
	       (<VERB? TASTE>
		<TELL
"Yuk! It tastes like cough medicine!" CR>)>>

<ROUTINE LOBLO-F ()
	 <COND (<VERB? TASTE>
		<TELL "The pills are virtually tasteless." CR>)
	       (<VERB? SMELL>
		<TELL "The pills are odorless." CR>)
	       (<VERB? EAT>
		<TELL
"Nervous? Blood Pressure high? See a doctor." CR>)
	       (<VERB? EXAMINE>
		<TELL "These are small, yellow pills." CR>)>>

<ROUTINE SNEEZO-F ()
	 <COND (<VERB? TASTE>
		<TELL "The pills are virtually tasteless." CR>)
	       (<VERB? SMELL>
		<TELL "The pills are odorless." CR>)
	       (<VERB? EAT>
		<TELL "You must realize that you aren't sick." CR>)
	       (<VERB? EXAMINE>
		<TELL "These are small, white pills." CR>)>>

<ROUTINE MEDICINE-BOTTLE-F ()
	 <COND (<VERB? COUNT>
		<TELL "It's hard to tell with the bottle closed." CR>)>>

<ROUTINE ALLERGONE-F ()
	 <COND (<VERB? TASTE>
		<TELL "The pills are bitter on the tongue." CR>)
	       (<VERB? SMELL>
		<TELL "The pills are odorless." CR>)
	       (<VERB? EAT>
		<TELL"The only allergy you seem to have is to work." CR>)
	       (<VERB? EXAMINE>
		<TELL "These are tiny red pills." CR>)>>

<ROUTINE EBULLION-F ()
	 <COND (<VERB? TASTE>
		<TELL "The pills are quite bitter." CR>)
	       (<VERB? SMELL>
		<TELL "The pills have a faint pungent aroma." CR>)
	       (<VERB? EAT>
		<TELL
"Are you depressed? Given your performance on this case, that isn't
surprising. In any event, you shouldn't take other people's medicine!" CR>)
	       (<VERB? EXAMINE>
		<TELL "These are little white pills." CR>)>>


"This is the sequence which starts with accusing Dunbar of
murder after having gotten the 'goods' on her, i.e. showing
her the report about the pills.

Basically, she runs around looking for Baxter and talks to him
briefly.  They agree to meet in the shed at a later time.  There,
they have a long and heated argument, which can be watched from
the outside."

<GLOBAL D-S-BAXTER-LOC <>>
<GLOBAL DUNBAR-ACCUSED <>>

<ROUTINE DUNBAR-SEQUENCE ("AUX" (BL <LOC ,BAXTER>))
	 <COND (,DUNBAR-ACCUSED <RFALSE>)>
	 <COND (<NOT <IN? ,DUNBAR .BL>>
		<ESTABLISH-GOAL ,DUNBAR .BL T>)>
	 <SETG DUNBAR-ACCUSED T>
	 <SETG D-S-BAXTER-LOC .BL>
	 <ENABLE <QUEUE I-DUNBAR-SEQ -1>>>

<GLOBAL DUNBAR-BAXTER-MEET <>>

<ROUTINE I-DUNBAR-SEQ ("AUX" (BL <LOC ,BAXTER>))
	 <COND (<NOT <==? .BL ,D-S-BAXTER-LOC>>
		<DUNBAR-SEQUENCE>
		<RFALSE>)
	       (<==? <LOC ,DUNBAR> .BL>
		<PUT <GET ,GOAL-TABLES ,BAXTER-C> ,GOAL-ENABLE <>>
		<COND (<==? ,HERE .BL>
		       <TELL
"Ms. Dunbar glances at Baxter and then at you." CR>)
		      (T
		       <SETG DUNBAR-BAXTER-MEET T>
		       <PUT <GET ,GOAL-TABLES ,BAXTER-C> ,GOAL-ENABLE T>
		       <QUEUE I-DUNBAR-SEQ 0>
		       <ENABLE <QUEUE I-DUNBAR-SEQ-2 5>>
		       <RFALSE>)>)>>

<ROUTINE I-DUNBAR-SEQ-2 ()
	 <SETG DUNBAR-BAXTER-MEET <>>
	 <ESTABLISH-GOAL ,DUNBAR ,SHED-ROOM T>
	 <ENABLE <QUEUE I-DUNBAR-SEQ-D -1>>
	 <ENABLE <QUEUE I-DUNBAR-SEQ-3 10>>
	 <RFALSE>>

<ROUTINE I-DUNBAR-SEQ-3 ()
	 <ESTABLISH-GOAL ,BAXTER ,NORTH-LAWN T>
	 <ENABLE <QUEUE I-DUNBAR-SEQ-B -1>>
	 <RFALSE>>

<ROUTINE I-DUNBAR-SEQ-D ("AUX" GT)
	 <SET GT <GET ,GOAL-TABLES ,DUNBAR-C>>
	 <COND (<==? <LOC ,DUNBAR> ,SHED-ROOM>
		<COND (<==? <LOC ,BAXTER> ,SHED-ROOM>
		       <ENABLE <QUEUE I-DUNBAR-SEQ-4 -1>>
		       <QUEUE I-DUNBAR-SEQ-D 0>)
		      (<==? ,HERE ,SHED-ROOM>
		       <COND (<PROB 50>
			      <TELL
"Dunbar paces around the shed nervously. If she was looking for something,
she would have found it by now." CR>)
			     (T
			      <TELL
"Ms. Dunbar seems to be looking around for something." CR>)>
		       <RTRUE>)>
		<RFALSE>)
	       (<AND <==? <GETP ,HERE ,P?LINE> ,OUTSIDE-LINE-C>
		     <FOLLOWED? ,DUNBAR>>
		<COND (<GET .GT ,GOAL-ENABLE>
		       <PUT .GT ,GOAL-ENABLE <>>)
		      (<PROB 28>
		       <TELL
"Ms. Dunbar eyes you nervously." CR>
		       <RTRUE>)
		      (<PROB 50>
		       <TELL
"Ms. Dunbar stares off toward the south." CR>
		       <RTRUE>)
		      (T
		       <TELL
"Ms. Dunbar seems to be deep in thought." CR>
		       <RTRUE>)>
		<COND (<AND <NOT ,STUB-DROPPED>
			    <==? <GETP ,HERE ,P?LINE> ,OUTSIDE-LINE-C>>
		       <TELL
"Ms. Dunbar spots you and stops. She reaches into her pocket and pulls out a
cigarette. As she does so, what appears to be a ticket stub falls out of her
pocket and floats to the ground. She checks her pocket again, apparently for
a match, but finds none and puts the cigarette back in her pocket." CR>
		       <MOVE ,STUB <LOC ,DUNBAR>>
		       <SETG STUB-DROPPED T>)
		      (<PROB 15>
		       <TELL
"Ms. Dunbar glances around as she walks. She takes a quick glance in your
direction, but it doesn't seem like she noticed you." CR>
		       <PUT .GT ,GOAL-ENABLE T>)
		      (<PROB 50>
		       <TELL
"Ms. Dunbar looks around as she walks and does a brief double-take
when she looks in your direction. She slows down and stops." CR>)
		      (T
		       <TELL
"Ms. Dunbar, who has been looking from side to side as she goes,
comes to a stop. She spins around, looking in all directions." CR>)>)
	       (T
		<PUT .GT ,GOAL-ENABLE T>
		<RFALSE>)>>

<GLOBAL STUB-DROPPED <>>

<ROUTINE I-DUNBAR-SEQ-B ()
	 <COND (<OR <==? <LOC ,BAXTER> ,NORTH-LAWN>
		    <==? <GETP ,HERE ,P?LINE> ,TOP-OF-THE-LINE-C>>
		<QUEUE I-DUNBAR-SEQ-B 0>
		<ESTABLISH-GOAL ,BAXTER ,SHED-ROOM T>
		<ENABLE <QUEUE I-DUNBAR-SEQ-B-2 -1>>)>
	 <RFALSE>>

<ROUTINE I-DUNBAR-SEQ-B-2 ("AUX" GT)
	 <SET GT <GET ,GOAL-TABLES ,BAXTER-C>>
	 <COND (<==? <LOC ,BAXTER> ,SHED-ROOM>
		<QUEUE I-DUNBAR-SEQ-B-2 0>
		<RFALSE>)
	       (<FOLLOWED? ,BAXTER>
		<COND (<GET .GT ,GOAL-ENABLE>
		       <PUT .GT ,GOAL-ENABLE <>>
		       <RFALSE>)
		      (<PROB 50>
		       <TELL
"Baxter draws a deep breath and looks about contentedly." CR>
		       <RTRUE>)
		      (T
		       <TELL
"Baxter stares out over the lake." CR>
		       <RTRUE>)>
		<COND (<PROB 50>
		       <TELL
"Baxter walks slowly, but with determination. He looks around often, as
if he were a prospective buyer of the property. He stops now, staring
up at the sky." CR>)
		      (T
		       <TELL
"Baxter stops, bends down, and ties his shoe.">
		       <COND (<PROB 30>
			      <TELL "  As he finishes, he takes stands up,
and stares at some distant trees." CR>)
			     (T
			      <TELL " He stands up and stares off to the
south." CR>)>)>)
	       (T
		<PUT .GT ,GOAL-ENABLE T>
		<RFALSE>)>>

<GLOBAL SECRET-MEETING 0>
<GLOBAL MEETING-INTERRUPTED <>>

<ROUTINE I-DUNBAR-SEQ-4 ()
	 <COND (<==? ,HERE ,SHED-ROOM>
		<COND (<OR <L? ,SECRET-MEETING 2>
			   <G? ,SECRET-MEETING 5>>
		       <TELL
"You seem to have walked in on some sort of get-together, although from the
look on Ms. Dunbar's face, you are not the guest of honor. She is aghast, and
she continually looks back and forth between Mr. Baxter and yourself." CR>)
		      (T
		       <TELL
"As you enter the shed, Mr. Baxter and Ms. Dunbar, who were in the midst of a
quiet but heated argument, stop at once. Ms. Dunbar is quite upset and
clutches Mr. Baxter. Baxter, who has retained his composure throughout,
attempts to comfort Dunbar. She pushes him away and runs out of the shed." CR>
		       <MOVE ,DUNBAR ,EAST-LAWN>
		       <PUT <GET ,WHERE-TABLES ,DUNBAR-C> 0 ,PRESENT-TIME>
		       <PUT <GET ,WHERE-TABLES 0> ,DUNBAR-C ,PRESENT-TIME>)>
		<HEAD-FOR-CLIMAX>
		<RTRUE>)
	       (<==? <LOC ,BAXTER> ,SHED-ROOM>
		<COND (<G? <SETG SECRET-MEETING <+ ,SECRET-MEETING 1>> 5>
		       <HEAD-FOR-CLIMAX>)>
		<RFALSE>)>>

<ROUTINE FOLLOWED? (PERSON "AUX" (L <LOC .PERSON>))
	 <COND (<==? .L ,HERE> <RTRUE>)
	       (<==? ,HERE ,GUEST-ROOM> <RFALSE>)
	       (<NOT <==? <BAND <GETP .L ,P?CORRIDOR>
				<GETP ,HERE ,P?CORRIDOR>> 0>>
		<RTRUE>)
	       (T <RFALSE>)>>

;"Ok, folks.  We have just caused Dunbar to run into the house
toward her room.  It occurs to Baxter that she may well talk.  He
then plans to kill her using a similar plan to his original one,
this time entering the house through the master bedroom.  He
shoots Dunbar at close range, leaves a forged suicide note, and
runs outside.  He then runs to the house, 'having heard the shot'."

<ROUTINE HEAD-FOR-CLIMAX ()
	 <COND (<EQUAL? ,HERE ,EAST-LAWN ,EAST-SIDE ,EAST-OF-DOOR>
		<TELL
"Baxter and Dunbar both leave the shed, heading off in
different directions." CR>)
	       (<==? ,HERE ,BEHIND-SHED>
		<TELL
"The voices stop and you hear sets of footsteps leaving the shed." CR>)>
	 <ESTABLISH-GOAL ,DUNBAR ,DUNBAR-ROOM T>
	 <ESTABLISH-GOAL ,BAXTER ,NORTH-LAWN T>
	 <ENABLE <QUEUE I-BAXTER-SEQ -1>>
	 <QUEUE I-DUNBAR-SEQ-4 0>
	 <SETG MEETING-INTERRUPTED ,SECRET-MEETING>
	 <SETG SECRET-MEETING 0>>

<GLOBAL BAXTER-SEQ-LOC <>>
<GLOBAL LADDER-FLAG-2 <>>
<GLOBAL DUNBAR-DEAD <>>

<ROUTINE I-BAXTER-SEQ ()
	 <COND (<==? ,BAXTER-SEQ-LOC ,MASTER-BEDROOM>
		<COND (<AND <NOT <==? <BAND <GETP ,HERE ,P?CORRIDOR> 1> 1>>
		            <NOT <EQUAL? ,HERE ,STAIRS ,STAIR-BOTTOM
					 ,DUNBAR-ROOM>>>
		       <SETG BAXTER-SEQ-LOC ,BEDROOM-BALCONY>
		       <MOVE ,BAXTER ,BEDROOM-BALCONY>
		       <REMOVE ,DUNBAR>
		       <SETG DUNBAR-DEAD T>
		       <DISABLE <INT I-DUNBAR>>
		       <MOVE ,PISTOL ,DUNBAR-ROOM>
		       <MOVE ,SUICIDE-NOTE ,DUNBAR-ROOM>
		       <MOVE ,CORPSE ,DUNBAR-ROOM>
		       <QUEUE I-BAXTER-SEQ 0>
		       <ENABLE <QUEUE I-BAXTER-ESCAPE -1>>
		       <COND (<==? <GETP ,HERE ,P?LINE> ,TOP-OF-THE-LINE-C>
			      <SETG SHOT-FIRED T>
			      <TELL
"You hear a pistol shot close by." CR>)
			     (<==? <GETP ,HERE ,P?LINE> ,OUTSIDE-LINE-C>
			      <TELL
"You hear what sounds like a pistol shot from inside the house." CR>)
			     (T
			      <TELL
"From upstairs, you hear a single explosion like a pistol shot." CR>)>
		       <SHOT-FIRED-F>
		       <RTRUE>)>)
	       (<==? ,BAXTER-SEQ-LOC ,BEDROOM-BALCONY>
		<COND (<AND <NOT <==? ,HERE ,MASTER-BEDROOM>>
			    <NOT <==? <LOC ,MRS-ROBNER> ,MASTER-BEDROOM>>>
		       <MOVE ,BAXTER ,MASTER-BEDROOM>
		       <SETG BAXTER-SEQ-LOC ,MASTER-BEDROOM>)>
		<RFALSE>)
	       (<==? ,BAXTER-SEQ-LOC ,NORTH-LAWN>
		<COND (<AND <IN? ,DUNBAR ,DUNBAR-ROOM>
			    <NOT <==? <GETP ,HERE ,P?LINE> ,OUTSIDE-LINE-C>>
			    <NOT <==? ,HERE ,BEDROOM-BALCONY>>>
		       <SETG LADDER-FLAG-2 T>
		       <SETG LADDER-FLAG <>>
		       <MOVE ,LADDER ,ORCHARD>
		       <FCLEAR ,LADDER ,NDESCBIT>
		       <FSET ,LADDER ,TOUCHBIT>
		       <MOVE ,BAXTER ,BEDROOM-BALCONY>
		       <SETG BAXTER-SEQ-LOC ,BEDROOM-BALCONY>)>
		<RFALSE>)
	       (<IN? ,BAXTER ,NORTH-LAWN>
		<SETG BAXTER-SEQ-LOC ,NORTH-LAWN>
		<RFALSE>)>>

<GLOBAL SHOT-FIRED <>>
<GLOBAL BAXTER-SEEN <>>

<ROUTINE I-BAXTER-ESCAPE ("AUX" (FLG <>))
	 <COND (,SHOT-FIRED
		<SETG SHOT-FIRED <>>
		<COND (<EQUAL? ,HERE ,CORRIDOR-4 ,CORRIDOR-3>
		       <TELL
"As you enter the hallway, you catch a glimpse of someone running across the
eastern end of the hallway from south to north." CR>
		       <SET FLG T>)
		      (<==? ,HERE ,MASTER-BEDROOM>
		       <TELL
"As you walk into the bedroom, you see Baxter running past you to the balcony.
He doesn't seem to have noticed you." CR>
		       <SET FLG T>
		       <SETG BAXTER-SEEN T>)
		      (<==? <BAND <GETP ,HERE ,P?CORRIDOR> 1> 1>
		       <TELL
"As you enter the hallway, you see Baxter running from Dunbar's
room across the hall to the master bedroom." CR>
		       <SET FLG T>
		       <SETG BAXTER-SEEN T>)>)>
	 <SETG BAXTER-SEQ-LOC ,BEDROOM-BALCONY>
	 <COND (<EQUAL? ,HERE ,ORCHARD ,EAST-LAWN ,NORTH-LAWN>
		.FLG)
	       (T
		<MOVE ,BAXTER ,IN-ORCHARD>
		<SETG LADDER-FLAG-2 <>>
		<ESTABLISH-GOAL ,BAXTER ,DUNBAR-ROOM T>
		<QUEUE I-BAXTER-ESCAPE 0>
		<SETG BAXTER-SEQ-LOC <>>
		.FLG)>>

<ROUTINE I-BAXTER-END-1 ()
	 <UNPRIORITIZE ,BAXTER>
	 <RFALSE>>

<ROUTINE SHOT-FIRED-F ()
	 <ESTABLISH-GOAL ,MRS-ROBNER ,DUNBAR-ROOM T>
	 <ESTABLISH-GOAL ,ROURKE ,CORRIDOR-1 T>
	 <ESTABLISH-GOAL ,GEORGE ,DUNBAR-ROOM T>
	 <ENABLE <QUEUE I-SHOT -1>>>

<GLOBAL SHOT-COUNT 0>

<ROUTINE I-SHOT ("AUX" (FLG <>))
	 <COND (<IN? ,MRS-ROBNER ,DUNBAR-ROOM>
		<COND (<==? ,HERE ,DUNBAR-ROOM>
		       <TELL
"Mrs. Robner, standing quietly by the body, starts sobbing and
leaves the room." CR>)>
		<UNPRIORITIZE ,MRS-ROBNER>
		<MOVE ,MRS-ROBNER ,CORRIDOR-1>
		<SET FLG T>)
	       (<IN? ,GEORGE ,DUNBAR-ROOM>
		<COND (<==? ,HERE ,DUNBAR-ROOM>
		       <TELL
"George says something like \"My God\" under his breath." CR>)>
		<UNPRIORITIZE ,GEORGE>)
	       (<IN? ,ROURKE ,CORRIDOR-1>
		<COND (<==? ,HERE ,CORRIDOR-1>
		       <TELL
"Mrs. Rourke peeks in the door and looks sick. \"I'm leaving this
house,\" she says, and pops out again." CR>)>
		<MOVE ,ROURKE ,STAIR-TOP>
		<ESTABLISH-GOAL ,ROURKE ,ROURKE-ROOM T>
		<SET FLG T>)>
	 <COND (<G? <SETG SHOT-COUNT <+ ,SHOT-COUNT 1>> 20>
		<QUEUE I-SHOT 0>)>
	 .FLG>

<ROUTINE PISTOL-F ()
	 <COND (<VERB? EXAMINE>
		<COND (<FSET? ,PISTOL ,TOUCHBIT>
		       <TELL
"The pistol is bloody and has clearly been used recently." CR>)
		      (T
		       <TELL
"The pistol has bloodstains on it. It has recently been fired." CR>)>)>>

<ROUTINE CORPSE-F ()
	 <COND (<VERB? EXAMINE>
		<TELL
"The corpse is most gruesome. Ms. Dunbar was apparently shot in the
head at close range, leaving a most distasteful mess." CR>)
	       (<VERB? RUB>
		<TELL
"The body is still quite warm.">)>>

<ROUTINE GLOBAL-PEN-F ()
	 <COND (<VERB? FIND>
		<COND (<==? ,HERE ,DUNBAR-ROOM>
		       <TELL
"It doesn't seem to be around here." CR>)
		      (T
		       <TELL
"There isn't one here." CR>)>)
	       (<VERB? ASK-FOR ASK-ABOUT> <RFALSE>)
	       (T <TELL "There is no pen to be seen here." CR>)>>

<ROUTINE PEN-F ()
	 <COND (<VERB? WRITE>
		<TELL
"The pen makes a mark in a fine blue line." CR>)>>

<GLOBAL SHOW-WAIT 0>
<GLOBAL NO-SHOW <>>

<ROUTINE I-SHOW-HOLE ()
	 <COND (<G? <SETG SHOW-WAIT <+ ,SHOW-WAIT 1>> 4>
		<SETG NO-SHOW T>
		<QUEUE I-SHOW-HOLE 0>
		<RFALSE>)
	       (<==? ,HERE ,IN-ROSES>
		<COND (<NOT <==? ,SHOW-WAIT 1>>
		       <TELL
"McNabb gives you a sideways glance. \"What kept you?\" he asks." CR>)>
		<SHOW-HOLE>
		<QUEUE I-SHOW-HOLE 0>)>>

<ROUTINE TODAY-F ()
	 <COND (<VERB? WHAT>
		<TELL "Today is Friday, July 10." CR>)>>

<ROUTINE GLOBAL-WARRANT-F ()
	 <COND (<VERB? TAKE FIND>
		<TELL
"Knowing the courts, it would take weeks to get one." CR>)>>

<ROUTINE CORRIDOR-WINDOW-F ()
	 <COND (<VERB? LOOK-INSIDE>
		<TELL "You can see the west lawn through the window." CR>)>>

<ROUTINE I-BAXTER-ARRIVE ()
	 <MOVE ,BAXTER ,SOUTH-LAWN>
	 <COND (<==? ,HERE ,SOUTH-LAWN>
		<TELL
"A limosine pulls up the drive. Mr. Baxter exits and the limo pulls away.
Baxter takes a deep breath and looks around." CR>)
	       (<OR <EQUAL? ,HERE ,FRONT-PATH ,EAST-LAWN ,WEST-LAWN>
		    <EQUAL? ,HERE ,EAST-OF-DOOR ,WEST-OF-DOOR>>
		<TELL
"A car pulls up the drive to the south, and Mr. Baxter steps out onto
the lawn." CR>)>>

<ROUTINE I-COATES-ARRIVE ()
	 <MOVE ,COATES ,SOUTH-LAWN>
	 <ESTABLISH-GOAL ,COATES ,LIVING-ROOM T>
	 <COND (<==? ,HERE ,SOUTH-LAWN>
		<TELL
"A large automobile pulls up the drive. Mr. Coates, the lawyer, steps out of
the car. \"Oh, hello! You must be the Inspector. I'll be reading the will at
noon, you know. Don't be late!\" he says." CR>)
	       (<OR <EQUAL? ,HERE ,FRONT-PATH ,EAST-LAWN ,WEST-LAWN>
		    <EQUAL? ,HERE ,EAST-OF-DOOR ,WEST-OF-DOOR>>
		<TELL
"A car pulls up the drive to the south, and Mr. Coates steps out onto
the lawn." CR>)>>

<ROUTINE TRASH-F ()
	 <COND (<VERB? TAKE READ EXAMINE>
		<FSET ,TRASH ,TOUCHBIT>
		<FSET ,TRASH-BASKET ,TOUCHBIT>
		<RFALSE>)>>

<ROUTINE GLOBAL-DUFFY-F ()
	 <COND (<VERB? FIND>
		<TELL
"Like a lurking grue in the dark places of the earth, Sergeant Duffy is always
near the scene of a crime. If you want something analyzed, he will arrive in
an instant to take the evidence to the lab. When the results are available,
he rushes them back to you. If you wish to arrest someone, Duffy will be there
with the handcuffs. A more dedicated civil servant cannot be found." CR>)>>

<ROUTINE L-RAILING-F ()
	 <COND (<VERB? EXAMINE>
		<TELL
"The railing is made of a sturdy metal and helps prevent nasty falls. There is
a small area of paint scraped off the outside edge." CR>)>>

<ROUTINE B-RAILING-F ()
	 <COND (<VERB? EXAMINE>
		<TELL
"This sturdy railing protects people on the balcony from being impaled upon
the exotic plants below. The railing itself is uniformly painted." CR>)>>

<ROUTINE L-BALCONY-F ()
	 <COND (<VERB? EXAMINE>
		<TELL
"The balcony itself is made of wood, except the railing which is metal. The
balcony is in good repair, but a few spots of dried mud soil the floor." CR>)>>

<ROUTINE B-BALCONY-F ()
	 <COND (<VERB? EXAMINE>
		<TELL
"The balcony is wooden, excepting the metal railing surrounding it.
It is in good repair and is quite clean." CR>)>>

<ROUTINE GLOBAL-ROOM-F ("AUX" TIM)
	 <COND (<VERB? KNOCK>
		<COND (<==? ,HERE ,UPSTAIRS-CLOSET>
		       <TELL
"The wall to the north here sounds unusually hollow." CR>)
		      (<==? <GETP ,HERE ,P?LINE> ,OUTSIDE-LINE-C>
		       <TELL "You're acting very strangely!" CR>)
		      (T
		       <TELL
"Knocking on the walls reveals nothing unusual." CR>)>)
	       (<AND <VERB? LOOK-INSIDE>
		     <==? ,HERE ,CORRIDOR-2>>
		<TELL "From here, it looks quite ordinary." CR>)
	       (<VERB? SEARCH EXAMINE>
		<COND (<==? <GETP ,HERE ,P?LINE> ,OUTSIDE-LINE-C>
		       <SET TIM 10>)
		      (<NOT <0? <GETP ,HERE ,P?CORRIDOR>>>
		       <SET TIM 3>)
		      (T <SET TIM <+ 2 <GETP ,HERE ,P?SIZE>>>)>
		<TELL
"An exhaustive search of even a single room would take hours. A more
productive approach would be to examine or search various items of interest
within the room. A cursory search would take on the order of " N .TIM "
minutes, but it wouldn't reveal much. Would you like to do it anyway? (Y/N)">
		<COND (<YES?>
		       <COND (<INT-WAIT .TIM>
			      <TELL
"Your brief search revealed nothing that was not obvious before." CR>)
			     (T
			      <TELL
"You didn't get a chance to finish looking over the room." CR>)>)
		      (T <TELL "Ok." CR>)>)>>

<ROUTINE COATES-F ("OPTIONAL" (RARG <>))
	 <COND (<==? .RARG ,M-OBJDESC>
		<COND (<IN-MOTION? ,COATES> T)
		      (T <TELL "Mr. Coates is here." CR>)>
		<CARRY-CHECK ,COATES>)
	       (<==? ,WINNER ,COATES>
		<COND (<VERB? FIND> <RFALSE>)
		      (<COM-CHECK ,COATES> <RTRUE>)
		      (T <TELL <PICK-ONE ,WHY-ME> CR>)>)
	       (<VERB? PHONE>
		<TELL D ,PRSO>
		<COND (<G? ,PRESENT-TIME 710>
		       <TELL
"'s office phone rings. His secretary answers and informs you that
he will be out for the rest of the day." CR>)
		      (<G? ,PRESENT-TIME 650>
		       <TELL
"'s secretary answers and informs you that Mr. Coates is on his way
to the Robner estate." CR>)
		      (T
		       <TELL
"'s secretary informs you that Mr. Coates is in a very important
meeting and can't be disturbed. She reminds you that he
will be at the Robner estate before noon." CR>)>)
	       (<AND <VERB? ASK-ABOUT> <==? ,PRSO ,COATES>>
		<COND (<OR <EQUAL? ,PRSI ,GLOBAL-OLD-WILL ,GLOBAL-NEW-WILL>
			   <EQUAL? ,PRSI ,GLOBAL-FOCUS ,GLOBAL-OMNIDYNE>>
		       <TELL
"\"I am not at liberty to discuss Mr. Robner's legal matters. That is
privileged information between attorney and client.\"" CR>)
		      (T
		       <TELL
"\"I am sorry, but I can't help you there.\"" CR>)>)>>

<ROUTINE LETTER-F ()
	 <COND (<VERB? TAKE>
		<FSET ,ENVELOPE ,TOUCHBIT>
		<RFALSE>)>>

<ROUTINE OBJECT-PAIR-F ()
	 <COND (<VERB? ARREST>
		<COND (<L? ,PRESENT-TIME 600>
		       <TELL
"It is rather early in the case to be making hasty judgments." CR>)
		      (<OR <AND <EQUAL? <1 ,P-PRSO> ,BAXTER ,GLOBAL-BAXTER>
				<EQUAL? <2 ,P-PRSO> ,DUNBAR ,GLOBAL-DUNBAR>>
			   <AND <EQUAL? <1 ,P-PRSO> ,DUNBAR ,GLOBAL-DUNBAR>
				<EQUAL? <2 ,P-PRSO> ,BAXTER ,GLOBAL-BAXTER>>>
		       <COND (,CORPSE-SEEN
			      <TELL "Ms. Dunbar is dead!" CR>)
			     (,DUNBAR-DEAD
			      <TELL
"Sergeant Duffy rushes into view. \"Ms. Dunbar is dead! She has
shot herself in her room! Come quickly!\" He dashes off." CR>)
			     (<AND <FSET? ,BAXTER-PAPERS ,TOUCHBIT>
				   <FSET? ,LAB-REPORT ,TOUCHBIT>
				   ,NOTE-READ
				   ,STUB-D>
			      <CRLF>
			      <END-HEADER "September 5">
			      <TELL
"Congratulations on your superb handling of the Robner case. As you have
probably heard, a jury convicted Mr. Baxter and Ms. Dunbar today of the
murder of Mr. Robner. Thanks to you, the murderers will be behind bars,
possibly for the rest of their lives. Thanks for a job brilliantly done.
Which reminds me of another fascinating case I would like to assign you to...|
|
Coming soon: Another INTERLOGIC Mystery from Infocom|
" CR>
			      <EPILOGUE>)
			     (<L? ,PRESENT-TIME 700>
			      <TELL
"You realize the arrest would be a trifle premature, since you're not even
sure that a murder was committed." CR>)
			     (<NOT <FSET? ,LAB-REPORT ,TOUCHBIT>>
			      <CRLF>
			      <END-HEADER "August 19">
			      <TELL
"The District Attorney has decided not to seek an indictment in the Robner
case. He points out that it has never been proven that a murder was committed,
despite the deep suspicions to the contrary. Thanks for your help on this
case. It's too bad we couldn't find out more about the circumstances
surrounding the death of Mr. Robner.|
|">)
			     (<NOT <FSET? ,BAXTER-PAPERS ,TOUCHBIT>>
			      <CRLF>
			      <END-HEADER "September 2">
			      <TELL
"A grand jury looking into the death of Mr. Robner has decided not to indict
the accused. They felt that the lack of motive as well as the contorted
hypothesis involving the actual mechanism of the murder of Mr. Robner was not
convincing. Personally, I think you're on the right track, but I must admit
that the evidence is meager. Thank you for helping in the case.|
|">)
			     (<NOT ,NOTE-READ>
			      <CRLF>
			      <END-HEADER "October 4">
			      <TELL
"The jury in the Robner case has declined to convict Mr. Baxter and Ms.
Dunbar. Appearances indicate that the verdict was difficult, and that several
jury members were convinced that the two were guilty. However, no evidence
was presented directly relating the Focus case with the murder of Mr. Robner.
This left the question of motive unresolved. I appreciate your efforts in the
case and am sorry to report this outcome to you.|
|">)
			      (T
			       <CRLF>
			       <END-HEADER "October 6">
			       <TELL
"The jury in the Robner case has declined to convict Mr. Baxter and Ms. Dunbar.
Although most of the jury was convinced of their guilt, it seems that one or
two felt there was some reasonable doubt about the proposed conspiracy. Their
main concern was the lack of evidence that Baxter was near the grounds on the
night of the murder. His alibi of having been to the symphony was confirmed by
several people. Although this doesn't mean that he didn't go back to the
Robner estate later, it nevertheless was not convincing. Thank you for your
excellent efforts. It is sad to think that we may have let the murderers slip
between our fingers.|
|">)>
		       <CASE-OVER>)
		      (<OR <AND <EQUAL? <1 ,P-PRSO> ,BAXTER ,GLOBAL-BAXTER>
				<EQUAL? <2 ,P-PRSO> ,GEORGE ,GLOBAL-GEORGE>>
			   <AND <EQUAL? <1 ,P-PRSO> ,GEORGE ,GLOBAL-GEORGE>
				<EQUAL? <2 ,P-PRSO> ,BAXTER ,GLOBAL-BAXTER>>>
		       <COND (<NOT <FSET? ,LAB-REPORT ,TOUCHBIT>>
			      <TELL
"You realize that there is no evidence that a murder has been committed
and decide not to go ahead with the arrest." CR>)
			     (<AND <OR ,NEW-WILL-SEEN ,GEORGE-RUN>
				   <FSET? ,BAXTER-PAPERS ,TOUCHBIT>
				   ,NOTE-READ>
			      <CRLF>
			      <END-HEADER "November 12">
			      <TELL "
The district attorney, after extensive interrogation of George Robner and Mr.
Baxter, has declined to seek an indictment against them. He agrees that there
has been foul play in the death of Mr. Robner and that both suspects have
motives for the crime. However, no coherent theory could be proposed which
involved the two of them conspiring to murder Mr. Robner. On the other hand,
it seems unlikely that either of them alone could have committed the crime.
I am sorry that your work has gone for naught.|
|">
			      <CASE-OVER>)
			     (T
			      <CRLF>
			      <END-HEADER "August 1">
			      <TELL
"The district attorney has declined to indict George Robner and Mr. Baxter
in the death of Marshall Robner, noting that there is no link between the
accused, except hatred, and that all of the evidence is circumstantial.
I wish you luck on your future cases.|
|">
			      <CASE-OVER>)>)
		      (T
		       <TELL
"You realize that this arrest is quite farfetched and would result
only in your humiliation." CR>)>)>>

<GLOBAL CONTRADICTION <>> 

<ROUTINE EPILOGUE ()
	 <CRLF>
	 <TELL
"You have solved the case! If you would like, you may see the author's summary
of the story. We would advise you to come up with your own first! Would you
like to see the author's summary? (Y/N)">
	 <COND (<YES?>
		<CRLF>
		<TELL
"Mr. Robner's work was his life, as pointed out by a number of the principals.
George knew that his father had lost control of the company, and a story in
the newspaper indicated that Baxter intended to sell the company to a
multi-national conglomerate, presumably to advance his career. Baxter admitted
to the merger plans, but indicated that Mr. Robner was in complete agreement.
This is contrary to what George and Mrs. Robner said. The note pad found in
the library was Robner's last, desperate attempt to save the company, in which
Robner threatened to expose Baxter's involvement in the Focus scandal. Baxter
denied getting the note, but it was not in the trash. The papers detailing
Baxter's criminality in the scandal were kept locked in a safe in a hidden
closet near the library. Only George and Marshall Robner knew the whereabouts
of the safe.|
  Baxter planned to murder his partner, aided by the fact that Robner was
known to be depressed, even suicidal. He enlisted the help of his lover,
Dunbar, one of whose medicines was found to interact fatally with the pills
Robner was taking. The relationship of Baxter and Dunbar was kept quiet,
although Mrs. Rourke had an inkling of it. After the concert in Hartford which
both Baxter and Dunbar attended, they returned to the Robner estate. Dunbar
placed some LoBlo in Robner's tea. After Robner died, Baxter used the ladder
from the shed to enter the library and exchange the incriminating cup for a
clean one (counting the china in the kitchen reveals that a cup is missing).
Coming down the ladder, Baxter presumably dropped the cup and inadvertently
left one piece on the ground in the rose garden, near the ladder holes that
McNabb found while tending his roses.|
|">)>
	 <QUIT>>

<ROUTINE COM-CHECK (PERSON)
 	 <COND (<VERB? WHAT>
		<SETG WINNER ,PLAYER>
	        <PERFORM ,V?ASK-ABOUT .PERSON ,PRSO>
		<RTRUE>)
	       (<VERB? EXAMINE>
		<SETG WINNER ,PLAYER>
		<PERFORM ,V?SHOW .PERSON ,PRSO>
		<RTRUE>)
	       (<AND <VERB? TELL-ME> <==? ,PRSO ,PLAYER>>
		<SETG WINNER ,PLAYER>
		<PERFORM ,V?ASK-ABOUT .PERSON ,PRSI>
		<RTRUE>)
	       (<AND <VERB? SHOW> <==? ,PRSO ,PLAYER>>
		<TELL "\"I'm sure you can find it, Inspector.\"" CR>
		<RTRUE>)
	       (<AND <VERB? FOLLOW> <==? ,PRSO ,PLAYER>>
		<TELL "\"I would rather not.\"" CR>
		<RTRUE>)>>

<ROUTINE PORTRAITS-F ()
	 <COND (<VERB? EXAMINE>
		<TELL
"There are five portraits: two on each side of and one above the bay window.
The fading portraits are of members of the Phillips family, among the oldest
in New England." CR>)
	       (<VERB? TAKE> <NO-TOUCH>)>> 

<ROUTINE LR-CABINETS-F ()
	 <COND (<VERB? EXAMINE>
		<TELL
"The cabinets are beautifully handworked walnut and mahogany." CR>)>>

<ROUTINE SEURAT-F ()
	 <COND (<VERB? EXAMINE>
		<TELL
"The painting by Seurat is a cheerful design which suits the bright decor of
the dining room. It must be worth a fortune." CR>)
	       (<VERB? TAKE> <NO-TOUCH>)>>

<ROUTINE PAINTINGS-F ()
	 <COND (<VERB? EXAMINE>
		<TELL
"The paintings are by various artists. They are brightly colored (but not
overly loud) works of cheerful outdoor scenes and still-lifes. They give the
room a light and pleasant feel." CR>)
	       (<VERB? TAKE> <NO-TOUCH>)>>

<ROUTINE APPLIANCE-F ()
	 <COND (<VERB? TAKE USE>
		<TELL
"The appliances here are useful in preparing meals, cleaning dishes, and the
like. It is unlikely that Mrs. Rourke would like you using them." CR>)>>

<ROUTINE K-CABINETS-F () <>>

<ROUTINE SILVERWARE-F ()
	 <COND (<VERB? TAKE>
		<TELL
"Although the set would make a fine addition to your home, you resist the
temptation. You would never get away with it anyway, as Mrs. Robner will no
doubt count the silverware upon your departure." CR>)
	       (<VERB? COUNT>
		<TELL "There are 16 complete sets of silver." CR>)
	       (<VERB? EXAMINE>
		<TELL "The silver is of the finest quality and design." CR>)>>

<ROUTINE GLASSES-F ()
	 <COND (<VERB? COUNT> <TELL "There are at least two dozen." CR>)
	       (<VERB? TAKE> <NO-TOUCH>)>>

<ROUTINE NO-TOUCH ()
	 <TELL
"You would be an impolite guest to fool with these things without cause." CR>>

<ROUTINE FOODS-F ()
	 <COND (<VERB? EAT>
		<TELL
"Although manners are not taught at the Academy, surely your mother must have
given you some sense of proper behavior." CR>)>>

<ROUTINE FRUIT-TREES-F ()
	 <COND (<VERB? PICK EAT TAKE>
		<TELL
"The fruits are not abundant, and those within reach are far from ripe." CR>)>>

<ROUTINE BERRY-BUSH-F ()
	 <COND (<VERB? PICK EAT TAKE>
		<TELL
"You pick a few berries and pop them into your mouth. Delicious!" CR>)>>

<ROUTINE BATHROOM-MIRROR-F ()
	 <COND (<VERB? MUNG>
		<TELL
"Don't you know it's bad luck to break mirrors?" CR>)
	       (<VERB? LOOK-INSIDE>
		<TELL
"A weary Police Inspector looks back at you, with
a look that seems to be saying \"Look what the cat dragged in.\"" CR>)>>

<ROUTINE TREE-TOPS-F ()
	 <TELL "You can't reach the tree tops from here." CR>>

<GLOBAL DRUNK-FLAG <>>

<ROUTINE LIQUOR-F ()
	 <COND (<VERB? DRINK>
		<COND (,DRUNK-FLAG
		       <TELL
"It's one thing to take a bracer on occasion, but you must resist
the temptation to indulge too often." CR>)
		      (T
		       <TELL
"You take a small swig of the golden fluid, which burns as it goes
down." CR>
		       <SETG DRUNK-FLAG T>)>)>>

<GLOBAL STEREO-ON <>>
<GLOBAL TUNE-ON <>>

<ROUTINE STEREO-F ()
	 <COND (<VERB? LAMP-ON>
		<TELL
"The stereo is now on." CR>
		<SETG STEREO-ON T>)
	       (<VERB? LAMP-OFF>
		<COND (<AND ,TUNE-ON <IN? ,GEORGE ,HERE>>
		       <TELL
"George turns toward you in disgust as you turn off the " ,TUNE-ON "." CR>)
		      (T <TELL "The stereo is now off." CR>)>
		<SETG STEREO-ON <>>
		<SETG TUNE-ON <>>
		<RTRUE>)
	       (<VERB? TURN-UP>
		<COND (,TUNE-ON
		       <TELL
"The " ,TUNE-ON " is already quite loud. Any louder would probably
disturb the rest of the house." CR>)
		      (T <TELL "It's not on!" CR>)>)
	       (<VERB? TURN-DOWN>
		<COND (,TUNE-ON
		       <COND (<IN? ,GEORGE ,HERE>
			      <TELL
"George stops you from turning down the volume. He is practically
addicted to the " ,TUNE-ON "." CR>)
			     (T <TELL "You can't." CR>)>)
		      (T <TELL "It's not on!" CR>)>)
	       (<VERB? LISTEN>
		<COND (,TUNE-ON
		       <TELL
"You can hardly avoid it." CR>)
		      (T
		       <TELL
"Nothing's playing." CR>)>)>>

<ROUTINE RECORDS-F ()
	 <COND (<VERB? PLAY LISTEN>
		<TELL
"You pick a record at random and start it playing. It is a ">
		<SETG TUNE-ON <PICK-ONE ,RECORD-TABLE>>
		<TELL ,TUNE-ON "." CR>
		<ENABLE <QUEUE I-TUNE-OFF 20>>)
	       (<VERB? EXAMINE>
		<TELL
"This is a large collection, with many different types of music represented.
George is evidently not very particular when it comes to music." CR>)>>

<ROUTINE TAPES-F ()
	 <COND (<VERB? PLAY LISTEN>
		<TELL
"You pick one at random and start it up. What you hear is a ">
		<SETG TUNE-ON <PICK-ONE ,TAPE-TABLE>>
		<ENABLE <QUEUE I-TUNE-OFF 30>>
		<TELL ,TUNE-ON "." CR>)
	       (<VERB? EXAMINE>
		<TELL
"George's collection of tapes is large and quite odd in its variety of
music." CR>)>>

<GLOBAL RECORD-TABLE
	<LTABLE "Hungarian Rhapsody"
		"march by Sir Edward Elgar"
		"chorus of African tribal music"
		"Hebrew prayer service"
		"Pretenders concert"
		"cacophonous electronic jumble"
		"bluegrass tune">>

<GLOBAL TAPE-TABLE
	<LTABLE "Wagnerian opera"
		"New Orleans jazz band"
		"Bulgarian shepherdess song"
		"Navajo night chant"
		"simulated rain shower"
		"risque Russian drinking song">>

<ROUTINE I-TUNE-OFF ("AUX" TBL)
	 <COND (<==? ,HERE ,GEORGE-ROOM>
		<TELL
"The " ,TUNE-ON " has ended (and not soon enough)." CR>
		<COND (<IN? ,GEORGE ,HERE>
		       <TELL
"George walks over to his stereo and returns the music to its
proper place. He then chooses a ">
		       <COND (<PROB 50>
			      <TELL "record">
			      <SET TBL ,RECORD-TABLE>)
			     (T
			      <TELL "tape">
			      <SET TBL ,TAPE-TABLE>)>
		       <TELL " from his large collection
and starts it up. Dear Lord! It's a ">
		       <SETG TUNE-ON <PICK-ONE .TBL>>
		       <TELL ,TUNE-ON "." CR>
		       <ENABLE <QUEUE I-TUNE-OFF 25>>)>
		<RTRUE>)
	       (<IN? ,GEORGE ,GEORGE-ROOM>
		<SETG TUNE-ON <PICK-ONE ,TAPE-TABLE>>
		<ENABLE <QUEUE I-TUNE-OFF 35>>
		<RFALSE>)>>
		 
<ROUTINE CLOSET-STUFF-F ()
	 <COND (<VERB? TAKE MOVE USE>
		<TELL
"You have no need for them." CR>)
	       (<VERB? SEARCH EXAMINE>
		<TELL
"You go through the" PRSO " and find nothing of interest." CR>)>>

<ROUTINE LIBRARY-CARPET-F ()
	 <COND (<VERB? LOOK-UNDER>
		<TELL
"The carpeting is wall-to-wall so you can't look under it." CR>)
	       (<VERB? EXAMINE>
		<TELL
"The carpet is an expensive affair, and quite clean, except for
a few small areas of dried mud in the vicinity of the desk.
There are no other stains or markings that you can see." CR>
		<FCLEAR ,MUD-SPOT ,INVISIBLE>)>>

;"Handler for both MURDER and SUICIDE"

<ROUTINE GLOBAL-MURDER-F ("AUX" STR)
	 <COND (<VERB? ASK-ABOUT>
		<COND (<==? ,PRSI ,GLOBAL-MURDER>
		       <COND (<==? <SET STR
					<GET ,MURDER-TABLE
					     <GETP ,PRSO ,P?CHARACTER>>> 0>
			      <RFALSE>)
			     (T <TELL .STR CR>)>)
		      (T
		       <TELL
"\"I told everything I know about it to the other detectives.\"" CR>)>)>>

<GLOBAL MURDER-TABLE
	<TABLE 0
	       0
"\"Murder? My dear inspector, I believe you are reading too many bad detective
stories. It's clear that he committed suicide.\""
"Ms. Dunbar turns toward you, looking quite confused. \"Murder? But...but how
do you know it was murder? I'm sure...\" She stops short, looking frightened."
"\"My father killed himself, as everyone knows. Please leave me alone.\""
"\"That's odd that you should say murder. Surely you don't suspect foul play,
Inspector. My husband was devoted to his business, and its decline led him to
take his life. The whole affair is tragic enough without your melodramatic
insinuations.\""
"\"Was it a murder, then?\" She bounces with excitement. \"In the book I've
been reading, the jealous wife did it, but I don't know about this. A whole
batch of suspects, this group here. What do you know? A murder. Here!\" Her
enjoyment is barely concealed."
	      0>>

<ROUTINE GUEST-WINDOW-F ()
	 <COND (<VERB? LOOK-INSIDE>
		<TELL
"From here you have a good view of the east lawn, a shed, and the
lake in the background." CR>
		<PUTP ,GUEST-ROOM ,P?CORRIDOR 512>
		<CORRIDOR-LOOK>
		<ENABLE <QUEUE I-WINDOW-LOOK 2>>
		<RTRUE>)
	       (<VERB? OPEN>
		<TELL "This window cannot be opened." CR>)>>

<ROUTINE I-WINDOW-LOOK ()
	 <PUTP ,GUEST-ROOM ,P?CORRIDOR 0>
	 <RFALSE>>

<ROUTINE I-WILL-MISSED ()
	 <COND (<IN? ,MRS-ROBNER ,HERE>
		<TELL
"Mrs. Robner turns to you. \"I don't understand why you missed the will
reading. You seem so interested in everything else that goes on around
here.\"" CR>
		<QUEUE I-WILL-MISSED 0>)
	       (<IN? ,COATES ,HERE>
		<TELL
"Mr. Coates says, in passing, \"To tell you the truth, Inspector, my
suspicions about this case are not quite allayed. I wish you had been
at the will reading. Good day.\"" CR>
		<QUEUE I-WILL-MISSED 0>)>> 

<ROUTINE S-SHELVES-F ()
	 <COND (<VERB? EXAMINE>
		<TELL
"The shelves contain various garden tools." CR>)>>

<ROUTINE END-HEADER (STR)
	 <TELL "Text of a letter from Police Commissioner Klutz dated ">
	 <TELL .STR>
	 <TELL ":|
|
Dear Inspector,|
|     ">>

<ROUTINE GLOBAL-HERE-F ("AUX" (FLG <>) F)
	 <COND (<VERB? WHAT ASK-ABOUT>
		<SET F <FIRST? ,HERE>>
		<REPEAT ()
			<COND (<NOT .F> <RETURN>)
			      (<AND <FSET? .F ,PERSON> <NOT <==? .F ,PLAYER>>>
			       <SET FLG T>
			       <DESCRIBE-OBJECT .F T 0>)>
			<SET F <NEXT? .F>>>
		<COND (<NOT .FLG> <TELL "There's nobody else here." CR>)>
		<RTRUE>)>>
			      
<ROUTINE BALCONY-DOOR-F ()
	 <COND (<VERB? HIDE-BEHIND>
		<COND (<NOT <FSET? ,PRSO ,OPENBIT>>
		       <TELL "You open the balcony door carefully." CR>
		       <FSET ,PRSO ,OPENBIT>)>
		<COND (<==? ,HERE ,LIBRARY>
		       <GOTO ,LIBRARY-BALCONY>)
		      (<==? ,HERE ,LIBRARY-BALCONY>
		       <GOTO ,LIBRARY>)
		      (<==? ,HERE ,MASTER-BEDROOM>
		       <GOTO ,BEDROOM-BALCONY>)
		      (T <GOTO ,MASTER-BEDROOM>)>
		<RTRUE>)
	       (<VERB? LOOK-INSIDE>
		<COND (<EQUAL? ,HERE ,MASTER-BEDROOM ,LIBRARY>
		       <TELL
"You can see the balcony, but not much beyond." CR>)
		      (<EQUAL? ,HERE ,LIBRARY-BALCONY>
		       <TELL
"You can see into the library from here." CR>)
		      (T <TELL "You can see the bedroom from here." CR>)>)>>

<ROUTINE GLOBAL-RED-HERRINGS-F ()
	 <COND (<IN? ,GEORGE ,DINING-ROOM>
		<COND (<VERB? EAT TAKE MOVE>
		       <TELL
"You reach for the juicy herrings, but George forces you away. He
is a killer where herrings are concerned." CR>)
		      (<VERB? FIND>
		       <TELL
"There are more in this room than elsewhere." CR>)>)
	       (<VERB? FIND>
		<TELL "They're all around you." CR>)
	       (<VERB? WHAT>
		<TELL "That would be telling." CR>)>>
		
<ROUTINE LIBRARY-DESK-F ()
	 <COND (<VERB? LOOK-INSIDE>
		<TELL "There's nothing of interest in the desk." CR>)>>

<ROUTINE RECURSIVE-BOOK-F ()
	 <COND (<AND <VERB? ASK-FOR> <==? ,PRSO ,BAXTER>>
		<FCLEAR ,PRSI ,NDESCBIT>
		<RFALSE>)
	       (<AND <VERB? TAKE> <IN? ,RECURSIVE-BOOK ,BAXTER>>
		<FCLEAR ,PRSO ,NDESCBIT>
		<RFALSE>)
	       (<VERB? EXAMINE>
		<TELL
"This is a novelization of DEADLINE, a classic work of computer fiction." CR>)
	       (<VERB? READ OPEN>
		<TELL
"The book is a novelization of DEADLINE. You start to read it, and it seems
oddly familiar, as if you had lived it." CR>)>> 

<ROUTINE GLOBAL-ENDING-F ()
	 <COND (<IN? ,RECURSIVE-BOOK ,PLAYER>
		<COND (<VERB? READ WHAT TURN>
		       <TELL
"You thumb to the last page and start to read the ending, in which the
protagonist reads the plot of the story and kills himself in disgust.
Disgustedly, you reach into your pocket, remove a gun, and end your life." CR>
		       <QUIT>)>)
	       (<VERB? WHAT> <TELL "That's up to you!" CR>)
	       (T <TELL "You don't have the book that tells the ending." CR>)>>

<ROUTINE CASE-OVER ()
	 <CRLF>
	 <CRLF>
	 <TELL
"The case has ended.  Would you like to start your investigation over
from scratch? (Y/N)">
	 <COND (<YES?> <RESTART>)
	       (T <QUIT>)>>

<ROUTINE SAFE-F ()
	 <COND (<AND <VERB? OPEN> <NOT <FSET? ,SAFE ,OPENBIT>>>
		<TELL "The safe is locked." CR>)
	       (<AND <VERB? CLOSE LOCK> <FSET? ,SAFE ,OPENBIT>>
		<TELL "The safe closes and locks." CR>
		<FCLEAR ,SAFE ,OPENBIT>)
	       (<VERB? LOCK>
		<TELL "It already is." CR>)
	       (<VERB? UNLOCK>
		<TELL "You don't know the combination." CR>)
	       (<VERB? LOOK-INSIDE EXAMINE>
		<FCLEAR ,BAXTER-PAPERS ,INVISIBLE>
		<RFALSE>)>>

<ROUTINE SUICIDE-NOTE-F ()
	 <COND (<VERB? ANALYZE>
		<TELL
"The handwriting is very shaky and would be impossible to compare with samples
on file. The blood makes the finding of fingerprints impossible." CR>)>>

<ROUTINE GLOBAL-MR-ROBNER-F ()
	 <COND (<VERB? FOLLOW>
		<TELL "Is this what they call a death wish?" CR>)
	       (<VERB? CALL>
		<TELL "You are, for the moment, not with him." CR>)>>

<ROUTINE RANDOM-MEAL-F ()
	 <COND (<VERB? EAT FIND>
		<TELL
"Although rather hungry, you realize that the case is too important
for you to be eating meals." CR>)
	       (T <TELL "What a strange notion!" CR>)>>

<ROUTINE GLOBAL-HOUSE-F ()
	 <COND (<VERB? WALK-AROUND>
		<TELL "Use directions to move around inside the house." CR>)>>

<ROUTINE GRAPE-ARBOR-F ()
	 <COND (<VERB? EAT>
		<TELL "You pick a few grapes and eat them. Mmmm!" CR>)>>

<ROUTINE GLOBAL-CALL-F ()
	 <COND (<AND <VERB? LISTEN>
		     <NOT <0? ,SECRET-MEETING>>
		     <EQUAL? ,HERE ,BEHIND-SHED ,EAST-LAWN>>
		<TELL
"The voices from within the shed are too quiet to make out." CR>)
	       (<AND <VERB? LISTEN>
		     ,CALL-IN-PROGRESS
		     <==? ,HERE ,CORRIDOR-1>>
		<TELL
"You can't make out the conversation through the door." CR>)
	       (<VERB? LISTEN>
		<TELL
"You can't hear any conversation." CR>)>>

<ROUTINE GLOBAL-FINGERPRINTS-F ()
	 <COND (<AND <VERB? TAKE> <==? ,PRSO ,GLOBAL-FINGERPRINTS>>
		<COND (<NOT ,PRSI>
		       <TELL
 "You must specify what to take the fingerprints from." CR>)
		      (T
		       <PERFORM ,V?FINGERPRINT ,PRSI>
		       <RTRUE>)>)>>

<ROUTINE GLOBAL-LADDER-F ()
	 <COND (<OR <AND <==? ,HERE ,LIBRARY-BALCONY> ,LADDER-FLAG>
		    <AND <==? ,HERE ,BEDROOM-BALCONY> ,LADDER-FLAG-2>>
		<COND (<VERB? TAKE>
		       <TELL "It's too difficult from here." CR>)
		      (<VERB? RUB> <RFALSE>)
		      (<VERB? EXAMINE>
		       <TELL
"The top of the ladder is visible, but the rest is hard to see." CR>)
		      (T
		       <TELL "You can't do that from here." CR>)>)>>