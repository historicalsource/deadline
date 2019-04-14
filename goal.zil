"GOAL for
			    DEADLINE
	Copyright 1982 Infocom, Inc.  All rights reserved.
"

"This code is the local T system.  There are four transit lines:
  TOP-OF-THE-LINE, BOTTOM-LINE, FOOD-LINE, and OUTSIDE-LINE,
  corresponding to upstairs, downstairs, kitchen area, and outside.
  There are routes for each of these lines and transfer points.  Much of
  this is done for the  general case, except transfers.  Sigh."

<GLOBAL DIR-STRINGS
	<TABLE  P?NORTH "north" P?SOUTH "south"
		P?EAST "east" P?WEST "west"
		P?NW "northwest" P?NE "northeast"
		P?SW "southwest" P?SE "southeast"
		P?DOWN "downstairs" P?UP "upstairs"
		P?IN "in" P?OUT "out">>

<GLOBAL TOP-OF-THE-LINE
	<TABLE	0 LIBRARY-BALCONY P?SOUTH
		P?NORTH LIBRARY P?SOUTH
		P?NORTH CORRIDOR-4 P?EAST
	        P?WEST CORRIDOR-3 P?EAST
		P?WEST CORRIDOR-2 P?EAST
		P?WEST CORRIDOR-1 P?EAST
		P?WEST STAIR-TOP P?SOUTH
		P?NORTH SHALL-11 P?EAST
		P?WEST SHALL-12 0 >>

<GLOBAL BOTTOM-LINE
	<TABLE  0 FOYER P?NORTH
		P?SOUTH NFOYER P?NORTH
		P?WEST STAIR-BOTTOM P?SOUTH
		P?NORTH SHALL-1 P?EAST
		P?WEST SHALL-2 P?EAST
		P?WEST SHALL-3 0>>

<GLOBAL OUTSIDE-LINE
	<TABLE  0 FRONT-PATH P?EAST
		P?WEST EAST-OF-DOOR P?NE
		P?SOUTH EAST-SIDE P?EAST
		P?WEST EAST-LAWN P?NW
		P?SE ORCHARD P?NORTH
		P?SE NORTH-LAWN P?SOUTH
		P?NORTH ROSE-GARDEN P?WEST
		P?NE WEST-LAWN P?EAST
		P?WEST WEST-SIDE P?SOUTH
		P?NW WEST-OF-DOOR P?SOUTH
		P?NORTH SOUTH-LAWN 0>>

<GLOBAL FOOD-LINE
	<TABLE  0 DINING-ROOM P?EAST
		P?WEST CORNER P?NORTH
		P?SOUTH KITCHEN P?EAST
		P?WEST PANTRY 0>>

"Rapid Transit Line Identifiers"

<CONSTANT TOP-OF-THE-LINE-C 0>
<CONSTANT BOTTOM-LINE-C 1>
<CONSTANT OUTSIDE-LINE-C 2>
<CONSTANT FOOD-LINE-C 3>

<ROUTINE UNPRIORITIZE (PERSON "AUX" GT)
	 <SET GT <GET ,GOAL-TABLES <GETP .PERSON ,P?CHARACTER>>>
	 <PUT .GT ,GOAL-PRIORITY <>>
	 <COND (<GET .GT ,GOAL-QUEUED>
		<ESTABLISH-GOAL .PERSON <GET .GT ,GOAL-QUEUED>>
		<PUT .GT ,GOAL-QUEUED <>>)>>

<ROUTINE ESTABLISH-GOAL (PERSON GOAL "OPTIONAL" (PRIORITY <>)
			 	     "AUX" (HERE <LOC .PERSON>) HL GL GT)
	 #DECL ((PERSON GOAL HERE) OBJECT (HL GL) FIX
		(PRIORITY) <OR FALSE ATOM>)
	 <SET GT <GET ,GOAL-TABLES <GETP .PERSON ,P?CHARACTER>>>
	 <COND (.PRIORITY
		<PUT .GT ,GOAL-ENABLE T>
		<PUT .GT ,GOAL-PRIORITY T>
		<PUT .GT ,GOAL-QUEUED .HERE>)>
	 <COND (<==? <SET HL <GETP .HERE ,P?LINE>>
		     <SET GL <GETP .GOAL ,P?LINE>>>
		<PUT .GT ,GOAL-I <>>)
	       (<==? .HL ,TOP-OF-THE-LINE-C>
		<PUT .GT ,GOAL-I ,STAIR-TOP>)
	       (<==? .HL ,OUTSIDE-LINE-C>
		<PUT .GT ,GOAL-I ,FRONT-PATH>)
	       (<==? .HL ,FOOD-LINE-C>
		<PUT .GT ,GOAL-I ,CORNER>)
	       (<==? .GL ,TOP-OF-THE-LINE-C>
		<PUT .GT ,GOAL-I ,STAIR-BOTTOM>)
	       (<==? .GL ,FOOD-LINE-C>
		<PUT .GT ,GOAL-I ,NFOYER>)
	       (T
		<PUT .GT ,GOAL-I ,FOYER>)>
	 <PUT .GT ,GOAL-S <GETP .GOAL ,P?STATION> ;CHOMP>
	 <PUT .GT ,GOAL-F .GOAL>
	 <LOC .PERSON>>

<ROUTINE FOLLOW-GOAL (PERSON "AUX" (HERE <LOC .PERSON>) LINE LN RM GT GOAL FLG
		      		   (GOAL-FLAG <>) (IGOAL <>) LOC (CNT 1) DIR)
	 #DECL ((PERSON HERE LOC RM) OBJECT (LN CNT) FIX
		(GOAL-FLAG IGOAL) <OR ATOM FALSE>)
	 <SET GT <GET ,GOAL-TABLES <GETP .PERSON ,P?CHARACTER>>>
	 <COND (<==? .HERE <GET .GT ,GOAL-F>>
		<SET FLG <GOAL-REACHED .PERSON>>
		<PUT .GT ,GOAL-S <>>
		<RETURN .FLG>)
	       (<NOT <GET .GT ,GOAL-ENABLE>> <RFALSE>)>
	 <COND (<NOT <==? <SET LOC <GETP .HERE ,P?STATION> ;CHOMP> .HERE>>
		<RETURN <MOVE-PERSON .PERSON .LOC>>)>
	 <COND (<SET GOAL <GET .GT ,GOAL-I>>
		<SET IGOAL T>)
	       (T <SET GOAL <GET .GT ,GOAL-S>>)>
	 <COND (<NOT .GOAL> <RFALSE>)
	       (<==? .HERE ,STAIRS>
		<RETURN <TRANSFER .PERSON .HERE <GET .GT ,GOAL-F>>>)
	       (<==? .HERE .GOAL>
		<COND (.IGOAL
		       <RETURN <TRANSFER .PERSON .GOAL <GET .GT ,GOAL-F>>>)
		      (<NOT <==? .HERE <GET .GT ,GOAL-F>>>
		       <SET FLG <MOVE-PERSON .PERSON <GET .GT ,GOAL-F>>>
		       <PUT .GT ,GOAL-S <>>
		       <COND (.FLG <GOAL-REACHED .PERSON>)
			     (T <SET FLG <GOAL-REACHED .PERSON>>)>
		       <RETURN .FLG>)
		      (T
		       <PUT .GT ,GOAL-S <>>
		       <RETURN <GOAL-REACHED .PERSON>>)>)>
	 <SET LN <GETP .GOAL ,P?LINE>>
	 <SET LINE
	      <COND (<==? .LN ,TOP-OF-THE-LINE-C> ,TOP-OF-THE-LINE)
		    (<==? .LN ,BOTTOM-LINE-C> ,BOTTOM-LINE)
		    (<==? .LN ,FOOD-LINE-C> ,FOOD-LINE)
		    (T ,OUTSIDE-LINE)>>
	 <REPEAT ()
		 <COND (<==? <SET RM <GET .LINE .CNT>> .HERE>
		        <COND (.GOAL-FLAG
			       <SET LOC <GET .LINE <- .CNT 3>>>)
			      (T
			       <SET LOC <GET .LINE <+ .CNT 3>>>)>
			<RETURN <MOVE-PERSON .PERSON .LOC>>)
		       (<==? .RM .GOAL>
			<SET GOAL-FLAG T>)>
		 <SET CNT <+ .CNT 3>>>>

<ROUTINE GOAL-REACHED (PERSON)
	 #DECL ((PERSON) OBJECT)
	 <APPLY <GET <GET ,GOAL-TABLES <GETP .PERSON ,P?CHARACTER>>
		     ,GOAL-FUNCTION> ,G-REACHED>> 

<ROUTINE MOVE-PERSON (PERSON WHERE "AUX" DIR GT OL COR PCOR CHR NC WT (CNT 0)
		      			 (FLG <>) EX)
	 #DECL ((PERSON WHERE) OBJECT)
	 <SET GT <GET ,GOAL-TABLES <SET CHR <GETP .PERSON ,P?CHARACTER>>>>
	 <SET NC .CHR>
	 <SET OL <LOC .PERSON>>
	 <SET DIR <DIR-FROM .OL .WHERE>>
	 <COND (<==? <PTSIZE <SET EX <GETPT .OL .DIR>>> ,DEXIT>
		<COND (<NOT <FSET? <SET EX <GETB .EX ,DEXITOBJ>> ,OPENBIT>>
		       <FSET .EX ,OPENBIT>)
		      (T <SET EX <>>)>)
	       (T <SET EX <>>)>
	 <PUT .GT ,GOAL-LDIR .DIR>
	 <COND (<==? .OL ,HERE>
		<SET FLG T>
		<TELL D .PERSON>
		<COND (<==? .DIR ,P?OUT>
		       <TELL " walks out of the room." CR>)
		      (<EQUAL? .DIR ,P?DOWN> <TELL " is going downstairs." CR>)
		      (<EQUAL? .DIR ,P?UP> <TELL " is going upstairs." CR>)
		      (<EQUAL? .DIR ,P?IN>
		       <COND (.EX <TELL " opens the " D .EX " and">)>
		       <TELL " goes into another room.">)
		      (T
		       <COND (.EX <TELL " opens the " D .EX " and">)>
		       <TELL " heads off to ">
		       <DIR-PRINT .DIR>
		       <TELL "." CR>)>)
	       (<==? .WHERE ,HERE>
		<SET FLG T>
		<TELL D .PERSON>
		<COND (<NOT <==? ,HERE <GET .GT ,GOAL-F>>>
		       <TELL " is walking past you." CR>)
		      (<==? <GETP ,HERE ,P?LINE> ,OUTSIDE-LINE-C>
		       <TELL " stops here." CR>)
		      (T <TELL " steps into the room." CR>)>)
	       (<SET COR <GETP ,HERE ,P?CORRIDOR>>
		<COND (<AND <SET PCOR <GETP .OL ,P?CORRIDOR>>
			    <NOT <==? <BAND .COR .PCOR> 0>>>
		       <SET FLG T>
		       <COND (<==? .WHERE ,STAIRS>
			      <TELL D .PERSON
				    " steps onto the stairs." CR>)
			     (<NOT <GETP .WHERE ,P?CORRIDOR>>
			      <TELL D .PERSON ", off to ">
			      <DIR-PRINT <COR-DIR ,HERE .OL>>
			      <TELL ",">
			      <COND (.EX
				     <TELL " opens a door and">)>
			      <COND (<==? <GETP ,HERE ,P?LINE>
					  ,OUTSIDE-LINE-C>
				     <TELL " leaves your view">)
				    (<==? .WHERE ,SHED-ROOM>
				     <TELL " darts into the shed">)
				    (T
				     <TELL " ducks into a room">)>
			      <TELL " to ">
			      <DIR-PRINT <DIR-FROM .OL .WHERE>>
			      <TELL "." CR>)
			     (<0? <BAND .COR <GETP .WHERE ,P?CORRIDOR>>>
			      <TELL D .PERSON
				    ", off to ">
			      <DIR-PRINT <COR-DIR ,HERE .OL>>
			      <TELL ", disappears from sight ">
			      <SET PCOR <DIR-FROM .OL .WHERE>>
			      <COND (<==? .PCOR ,P?UP>
				     <TELL "up the stairs">)
				    (<==? .PCOR ,P?DOWN>
				     <TELL "down the stairs">)
				    (T
				     <TELL "to ">
				     <DIR-PRINT .PCOR>)>
			      <TELL "." CR>)
			     (T
			      <TELL D .PERSON " is to ">
			      <DIR-PRINT <COR-DIR ,HERE .WHERE>>
			      <TELL ", heading toward ">
			      <DIR-PRINT <DIR-FROM .OL .WHERE>>
			      <TELL "." CR>)>)
		      (<AND <SET PCOR <GETP .WHERE ,P?CORRIDOR>>
			    <NOT <==? <BAND .COR .PCOR> 0>>>
		       <SET FLG T>
		       <TELL "To ">
		       <DIR-PRINT <COR-DIR ,HERE .WHERE>>
		       <TELL " " D .PERSON>
		       <COND (<OR <==? <GETP .WHERE ,P?LINE> ,OUTSIDE-LINE-C>
				  <==? .WHERE ,STAIRS>>
			      <TELL " comes into view from ">)
			     (T
			      <TELL " enters the hallway from ">)>
		       <DIR-PRINT <DIR-FROM .WHERE .OL>>
		       <TELL "." CR>)>)>
	 <SET WT <GET ,WHERE-TABLES .CHR>>
	 <REPEAT ()
		 <COND (<G? .CNT ,CHARACTER-MAX> <RETURN>)
		       (T
			<COND (<==? <SET CHR <GET ,CHARACTER-TABLE .CNT>>
				    .PERSON> T)
			      (<OR <AND <0? .CNT> .FLG>
				   <IN? <GET ,CHARACTER-TABLE .CNT> .OL>>
			       <PUT .WT .CNT ,PRESENT-TIME>
			       <PUT <GET ,WHERE-TABLES .CNT>
				    .NC
				    ,PRESENT-TIME>)>
			<SET CNT <+ .CNT 1>>)>>
	 <MOVE .PERSON .WHERE>
	 .FLG>

<ROUTINE DIR-FROM (HERE THERE "AUX" P L TX O)
	 <SET P 0>
	 <REPEAT ()
		 <COND (<0? <SET P <NEXTP .HERE .P>>>
			<RFALSE>)
		       (<EQUAL? .P ,P?IN ,P?OUT> T)
		       (<NOT <L? .P ,LOW-DIRECTION>>
			<SET TX <GETPT .HERE .P>>
			<SET L <PTSIZE .TX>>
			<COND (<AND <EQUAL? .L ,DEXIT ,UEXIT ,CEXIT>
				    <==? <GETB .TX ,REXIT> .THERE>>
			       <RETURN .P>)>)>>>

<ROUTINE COR-DIR (HERE THERE "AUX" COR RM (PAST 0) (CNT 2))
	 <SET COR <GET-COR <BAND <GETP .THERE ,P?CORRIDOR>
				 <GETP .HERE ,P?CORRIDOR>>>>
	 <REPEAT ()
		 <COND (<==? <SET RM <GET .COR .CNT>> .HERE>
			<SET PAST 1>
			<RETURN>)
		       (<==? .RM .THERE>
			<RETURN>)>
		 <SET CNT <+ .CNT 1>>>
	 <GET .COR .PAST>>

<ROUTINE GET-COR (NUM)
	 #DECL ((NUM) FIX)
	 <COND (<==? .NUM 1> ,COR-1)
	       (<==? .NUM 2> ,COR-2)
	       (<==? .NUM 4> ,COR-4)
	       (<==? .NUM 8> ,COR-8)
	       (<==? .NUM 16> ,COR-16)
	       (<==? .NUM 32> ,COR-32)
	       (<==? .NUM 64> ,COR-64)
	       (<==? .NUM 128> ,COR-128)
	       (<==? .NUM 256> ,COR-256)
	       (<==? .NUM 512> ,COR-512)
	       (<==? .NUM 1024> ,COR-1024)
	       (T ,COR-2048)>>

<ROUTINE TRANSFER (PERSON IGOAL FGOAL "AUX" V (FLG <>))
	 #DECL ((PERSON IGOAL FGOAL) OBJECT)
	 <COND (<==? .IGOAL ,STAIR-TOP>
		<COND (<OR <EQUAL? ,HERE ,STAIR-BOTTOM ,NFOYER ,ROURKE-ROOM>
			   <EQUAL? ,HERE ,LIVING-ROOM ,FOYER ,CORNER>>
		       <TELL
"You can hear footsteps on the staircase." CR>
		       <SET FLG T>)>
		<OR <MOVE-PERSON .PERSON ,STAIRS> .FLG>)
	       (<==? .IGOAL ,STAIR-BOTTOM>
		<COND (<OR <EQUAL? ,HERE ,STAIR-TOP ,CORRIDOR-1>
			   <EQUAL? ,HERE ,CORRIDOR-2 ,CORRIDOR-3>>
		       <TELL
"You can hear footsteps on the staircase." CR>
		       <SET FLG T>)>
		<OR <MOVE-PERSON .PERSON ,STAIRS> .FLG>) 
	       (T
		<SET V 
		     <COND (<==? .IGOAL ,STAIRS>
		            <COND (<==? <GETP .FGOAL ,P?LINE> 0>
		                   <MOVE-PERSON .PERSON ,STAIR-TOP>)
		                  (T <MOVE-PERSON .PERSON ,STAIR-BOTTOM>)>)
		           (<==? .IGOAL ,FRONT-PATH>
		            <FSET ,FRONT-DOOR ,OPENBIT>
			    <MOVE-PERSON .PERSON ,FOYER>)
	                   (<==? .IGOAL ,FOYER>
		            <FSET ,FRONT-DOOR ,OPENBIT>
			    <MOVE-PERSON .PERSON ,FRONT-PATH>)
		           (<==? .IGOAL ,NFOYER>
		            <MOVE-PERSON .PERSON ,CORNER>)
		           (T
		            <MOVE-PERSON .PERSON ,NFOYER>)>>
		<ESTABLISH-GOAL .PERSON .FGOAL>
		.V)>>

<ROUTINE DIR-PRINT (DIR "AUX" (CNT 0))
	 #DECL ((DIR CNT) FIX)
	 <REPEAT ()
		 <COND (<==? <GET ,DIR-STRINGS .CNT> .DIR>
			<COND (<NOT <EQUAL? .DIR ,P?UP ,P?DOWN>>
			       <TELL "the ">)>
			<PRINT <GET ,DIR-STRINGS <+ .CNT 1>>>
			<RTRUE>)>
		 <SET CNT <+ .CNT 1>>>>

"Here is the code for goal motivation for the various characters.
Each character has a tendency to move from one place to another
at certain times.  They all converge on the living room at about
noon."

"Constants used as table offsets for each character, including
the player."

<CONSTANT PLAYER-C 0>
<CONSTANT GARDENER-C 1>
<CONSTANT BAXTER-C 2>
<CONSTANT DUNBAR-C 3>
<CONSTANT GEORGE-C 4>
<CONSTANT MRS-ROBNER-C 5>
<CONSTANT ROURKE-C 6>
<CONSTANT COATES-C 7>
<CONSTANT CHARACTER-MAX 7>

<GLOBAL CHARACTER-DESCS
	<TABLE 0
"Mr. McNabb is an elderly Scottish man with a deeply lined face.
He is wearing overalls."
"Baxter is an immaculately dressed middle-aged man with rugged good
looks."
"Ms. Dunbar, wearing a fashionable pants suit, is a rather attractive
woman in her early thirties."
"George is a young man in his mid-twenties.  He is poorly dressed in
that each item he is wearing clashes with the others.  His attire is
of the highest quality, however.  He is wearing various pieces of
jewelry." 
"Mrs. Robner is a middle-aged woman of great beauty.  She is dressed
in black."
"Mrs. Rourke is a short woman, more than a bit overweight.  She is
wearing a maid's outfit."
"Mr. Coates is a rather homely man of advancing years.">>
 
"Goal tables for the 8 characters (including PLAYER), offset
by the preceding constants, which, for a given character,
is the P?CHARACTER property of the object."

<GLOBAL GOAL-TABLES
	<TABLE <TABLE <> <> <> <> 1 <> <> I-FOLLOW 4 4>
	       <TABLE <> <> <> <> 1 <> <> I-GARDENER 3 3>
	       <TABLE <> <> <> <> 1 <> <> I-BAXTER 4 4>
	       <TABLE <> <> <> <> 1 <> <> I-DUNBAR 3 3>
	       <TABLE <> <> <> <> 1 <> <> I-GEORGE 2 2>
	       <TABLE <> <> <> <> 1 <> <> I-MRS-ROBNER 4 4>
	       <TABLE <> <> <> <> 1 <> <> I-ROURKE 6 6>
	       <TABLE <> <> <> <> 1 <> <> I-COATES 2 2>>>

<GLOBAL ATTENTION-TABLE <TABLE 0 0 0 0 0 0 0 0>>

"Offsets into GOAL-TABLEs"

<CONSTANT GOAL-F 0>
<CONSTANT GOAL-S 1>
<CONSTANT GOAL-I 2>
<CONSTANT GOAL-LDIR 3>
<CONSTANT GOAL-ENABLE 4>
<CONSTANT GOAL-PRIORITY 5>
<CONSTANT GOAL-QUEUED 6>
<CONSTANT GOAL-FUNCTION 7>
<CONSTANT ATTENTION-SPAN 8>
<CONSTANT ATTENTION 9>
 
"Goal-function constants, similar to M-xxx in MAIN"

<CONSTANT G-REACHED 1>
<CONSTANT G-ENROUTE 2>

"Here's how the movement goals are done:  For each player is
a table which consists of triplets, a number of minutes until
the next movement (an clock interrupt number), a number of
minutes allowed variation (for a bit of randomness), and a
room toward which to start.  All movement is controlled by
the GOAL-ENABLE flag in the GOAL-TABLE for a character."

"Time starts at 8AM.  Characters are at that point in their
starting positions, as reflected in DUNGEON."

<GLOBAL CHARACTER-TABLE
	<TABLE PLAYER GARDENER BAXTER DUNBAR GEORGE MRS-ROBNER ROURKE
	       COATES>> 

<GLOBAL GLOBAL-CHARACTER-TABLE
	<TABLE PLAYER GLOBAL-GARDENER GLOBAL-BAXTER GLOBAL-DUNBAR GLOBAL-GEORGE
	       GLOBAL-MRS-ROBNER GLOBAL-ROURKE GLOBAL-COATES>>

<GLOBAL MOVEMENT-GOALS <TABLE
	;"PLAYER"
	<TABLE 0 0 0>
	;"GARDENER"
	<TABLE 0
	       60 10 NORTH-LAWN 	;"9-10AM"
	       60 10 EAST-LAWN		;"10-11AM"
	       60 10 ROSE-GARDEN	;"11AM-1PM"
	       60 10 ORCHARD		;"1-2PM"
	       60 15 SOUTH-LAWN		;"2-3PM"
	       120 15 WEST-LAWN		;"3-5PM"
	       0>
	;"BAXTER"
	<TABLE 0
	       120 2 LIVING-ROOM	;"Arrival at 9:55"
	       360 10 SOUTH-LAWN	;"Leave at 4PM"
	       0>
	;"DUNBAR"
	<TABLE 0
	       60 10 DUNBAR-BATH	;"9-9:30AM"
	       30 10 DUNBAR-ROOM	;"9:30-11:30AM"
	       135 20 LIVING-ROOM	;"11:30AM-2PM"
	       135 20 DUNBAR-ROOM	
	       0>
	;"GEORGE"
	<TABLE 0
	       80 10 KITCHEN		;"9:20-9:50AM"
	       30 10 DINING-ROOM	;"9:50-11AM"
	       70 20 GEORGE-ROOM	;"11-11:45AM"
	       45 15 LIVING-ROOM	;"11:45AM-12:30PM"
	       60 10 EAST-LAWN		;"12:30-2PM"
	       75 20 LIVING-ROOM	;"2-3PM"
	       60 15 GEORGE-ROOM
	       0>
	;"MRS-ROBNER"
	<TABLE 0
	       30 10 DINING-ROOM	;"8:30-9AM"
	       100 15 DINING-ROOM	;"10:10-11:10"
	       60 20 LIVING-ROOM	;"11:10-12:40"
	       90 20 MASTER-BEDROOM	;"12:40-1:50"
	       70 30 LIVING-ROOM
	       0>
	;"ROURKE"
	<TABLE 0
	       60 10 KITCHEN		;"9-10AM"
	       60 20 DINING-ROOM	;"10-11AM"
	       60 10 KITCHEN		;"11AM-1PM"
	       120 20 LIVING-ROOM	;"1PM-2PM"
	       60 30 ROURKE-ROOM	
	       0>>>

<ROUTINE START-MOVEMENT ()
	 <ENABLE <QUEUE I-GARDENER 1>>
	 <ENABLE <QUEUE I-BAXTER 1>>
	 <ENABLE <QUEUE I-DUNBAR 1>>
	 <ENABLE <QUEUE I-GEORGE 1>>
	 <ENABLE <QUEUE I-MRS-ROBNER 1>>
	 <ENABLE <QUEUE I-ROURKE 1>>
	 <ENABLE <QUEUE I-FOLLOW -1>>
	 <ENABLE <QUEUE I-ATTENTION -1>>>

<ROUTINE I-G-I-G ()
	 <SETG G-I-G ,PRESENT-TIME>
	 <COND (<AND <==? ,HERE ,ROSE-GARDEN> <NOT ,HOLE-SHOWN>>
		<SETG HOLE-TELL T>
		<TELL
"All of a sudden, Mr. McNabb starts talking to himself quite
loudly about his poor roses being ruined.  He walks up to you and
says \"You canna believe the holes someone's made. Crushed my
roses.  It'll take me plenty a time to set it right.  I just
canna believe it!\"  He shakes his head dejectedly." CR>)>>
  
<ROUTINE I-GARDENER ("OPTIONAL" (GARG <>) "AUX" (GL <LOC ,GARDENER>))
	 <COND (<NOT .GARG> <IMOVEMENT ,GARDENER I-GARDENER>)
	       (<==? .GARG ,G-REACHED>
		<COND (<==? .GL ,ROSE-GARDEN>
		       <ENABLE <QUEUE I-G-I-G <+ 2 <RANDOM 10>>>>
		       <RFALSE>)
		      (<==? .GL ,ORCHARD>
		       <COND (<NOT <IN? ,LADDER ,ORCHARD>>
			      <FCLEAR ,LADDER ,NDESCBIT>
			      <SETG LADDER-FLAG <>>
			      <SETG LADDER-FLAG-2 <>>
			      <FSET ,LADDER ,TOUCHBIT>
			      <COND (<IN? ,LADDER ,WINNER>
			             <MOVE ,LADDER ,ORCHARD>
				     <TELL
"McNabb comes over to you and takes the ladder.  He walks off
toward the orchard." CR>
				     <RTRUE>)
				    (<IN? ,LADDER ,HERE>
				     <MOVE ,LADDER ,ORCHARD>
				     <TELL
"McNabb picks up the ladder and walks away toward the orchard." CR>
				     <RTRUE>)
				    (<==? ,HERE ,ORCHARD>
				     <MOVE ,LADDER ,ORCHARD>
				     <TELL
"McNabb places the ladder he was carrying on the ground." CR>
				     <RTRUE>)>
			      <MOVE ,LADDER ,ORCHARD>
			      <RFALSE>)>)
		      (<==? .GL ,IN-ROSES>
		       <UNPRIORITIZE ,GARDENER>
		       <COND (<==? ,HERE .GL>
			      <GRAB-ATTENTION ,GARDENER>
			      <SHOW-HOLE>
			      <RTRUE>)
			     (T
			      <ENABLE <QUEUE I-SHOW-HOLE -1>>
			      <RFALSE>)>)>)>>

<ROUTINE I-BAXTER ("OPTIONAL" (GARG <>) "AUX" (BL <LOC ,BAXTER>))
	 <COND (<NOT .GARG> <IMOVEMENT ,BAXTER I-BAXTER>)
	       (<AND <==? .GARG ,G-REACHED> <==? .BL ,LIVING-ROOM>>
		<COND (<IN? ,RECURSIVE-BOOK ,LIVING-ROOM>
		       <MOVE ,RECURSIVE-BOOK ,BAXTER>
		       <FSET ,RECURSIVE-BOOK ,NDESCBIT>
		       <RFALSE>)>)
	       (<AND <==? .GARG ,G-REACHED>
		     <==? .BL ,DUNBAR-ROOM>
		     <==? ,HERE ,DUNBAR-ROOM>>
		<TELL
"Baxter looks at the body of Ms. Dunbar, lying on the floor, and
falls to his knees.  He starts to sob.  \"I knew she would do this,\"
he says, sobbing, \"but I couldn't stop her.  She killed Marshall.
She just told me a few minutes ago.  She said that he was going to fire her,
just like that, after all of these years.  She was so hysterical,
I couldn't understand everything she said, something about having
stolen some money.  I don't know.\"  With that, he breaks down again." CR>
		<ENABLE <QUEUE I-BAXTER-END-1 10>>)
	       (<AND <==? .GARG ,G-REACHED> <==? .BL ,SHED-ROOM>>
		<COND (<==? ,HERE ,BEHIND-SHED>
		       <TELL
"The sound of quick footsteps precedes someone into the shed.
You can make out two voices in rapid conversation.  The voices
are muffled, however, and cannot be made out." CR>)>)
	       (<AND <==? .GARG ,G-REACHED> <==? .BL ,SOUTH-LAWN>>
		<COND (<==? ,HERE ,SOUTH-LAWN>
		       <REMOVE ,BAXTER>
		       <TELL
"A limousine comes up the drive and picks up Mr. Baxter." CR>
		       <RTRUE>)
		      (<EQUAL? ,HERE ,FRONT-PATH ,EAST-OF-DOOR ,WEST-OF-DOOR>
		       <REMOVE ,BAXTER>
		       <TELL
"To the south, you observe a limousine picking up Mr. Baxter." CR>
		       <RTRUE>)>
		<REMOVE ,BAXTER>
		<RFALSE>)>>

<ROUTINE I-DUNBAR ("OPTIONAL" (GARG <>) "AUX" (DL <LOC ,DUNBAR>))
	 <COND (<NOT .GARG> <IMOVEMENT ,DUNBAR I-DUNBAR>)
	       (<AND <==? .GARG ,G-REACHED> <==? .DL ,SHED-ROOM>>
		<COND (<==? ,HERE ,BEHIND-SHED>
		       <TELL
"You hear soft footsteps approaching.  Someone has entered the shed!" CR>)>)>>

<ROUTINE I-GEORGE ("OPTIONAL" (GARG <>) "AUX" (GL <LOC ,GEORGE>))
	 <COND (<AND <==? .GARG ,G-REACHED> <==? .GL ,EAST-LAWN>>
		<UNPRIORITIZE ,GEORGE>
		<RFALSE>)
	       (<AND <==? .GARG ,G-REACHED> <==? .GL ,GEORGE-ROOM>>
		<SETG STEREO-ON T>
		<SETG TUNE-ON <PICK-ONE ,RECORD-TABLE>>
		<ENABLE <QUEUE I-TUNE-OFF 25>>
		<COND (<==? ,HERE .GL>
		       <TELL
"George walks over to his stereo and puts on a record.  He turns
to you. \"I naturally assume that you would like to hear a
" ,TUNE-ON ".\" he says, barely concealing his clear distaste
for you and your profession." CR>)>)
	       (<AND <==? .GARG ,G-REACHED> <==? .GL ,NORTH-LAWN>>
		<REMOVE ,NEW-WILL>
		<MOVE ,SOGGY-WILL ,LAKE>
		<SETG GEORGE-RUN 0>
		<UNPRIORITIZE ,GEORGE>
		<COND (<==? ,HERE ,NORTH-LAWN>
		       <TELL
"You catch, out of the corner of one eye, George motioning with
his arm toward the lake." CR>)>)
	       (<NOT .GARG> <IMOVEMENT ,GEORGE I-GEORGE>)>> 

<ROUTINE I-ROURKE ("OPTIONAL" (GARG <>))
	 <COND (<AND <==? .GARG ,G-REACHED> <IN? ,ROURKE ,ROURKE-ROOM>>
		<UNPRIORITIZE ,ROURKE>
		<RFALSE>)
	       (<NOT .GARG> <IMOVEMENT ,ROURKE I-ROURKE>)>>

<ROUTINE I-MRS-ROBNER ("OPTIONAL" (GARG <>) "AUX" (ML <LOC ,MRS-ROBNER>))
	 <COND (<AND <==? .GARG ,G-REACHED> <==? .ML ,MASTER-BEDROOM>>
		<COND (<AND <NOT ,HC-ROBNER>
			    <FSET? ,HIDDEN-DOOR-B ,OPENBIT>>
		       <SETG HC-ROBNER T>
		       <COND (<EQUAL? ,HERE ,HIDDEN-CLOSET ,MASTER-BEDROOM>
			      <TELL
"Mrs. Robner stares in complete surprise at the hidden closet. \"I had
no idea that such a place existed!\"  She sits down on her bed." CR>)>)>)
	       (<NOT .GARG> <IMOVEMENT ,MRS-ROBNER I-MRS-ROBNER>)>>

;"This routine does the interrupt-driven goal establishment
for the various characters, using the MOVEMENT-GOALS table."

<CONSTANT MG-ROOM 0>
<CONSTANT MG-TIME 1>
<CONSTANT MG-VARIATION 2>
<CONSTANT MG-LENGTH <* 3 2>>
<CONSTANT MG-NEXT 4>

<ROUTINE IMOVEMENT (PERSON INT "AUX" TB VAR DIS TIM ID RM GT)
	 #DECL ((PERSON) OBJECT (TB) <PRIMTYPE VECTOR> (ID VAR DIS TIM) FIX)
	 <SET TB <GET ,MOVEMENT-GOALS <SET ID <GETP .PERSON ,P?CHARACTER>>>>
	 <SET GT <GET ,GOAL-TABLES .ID>>
	 <COND (<NOT <==? <SET RM <GET .TB ,MG-ROOM>> 0>>
		<COND (<GET .GT ,GOAL-PRIORITY>
		       <PUT .GT ,GOAL-QUEUED .RM>)
		      (T
		       <ESTABLISH-GOAL .PERSON .RM>)>)>
	 <COND (<NOT <==? <SET TIM <GET .TB ,MG-TIME>> 0>>
		<SET VAR <GET .TB ,MG-VARIATION>>
		<SET DIS <RANDOM <* .VAR 2>>>
	        <QUEUE .INT <+ .TIM <- .DIS .VAR>>>
		<PUT ,MOVEMENT-GOALS .ID <REST .TB ,MG-LENGTH>>
		<COND (<NOT <==? <GET .TB ,MG-NEXT> 0>>
		       <PUT .TB
			    ,MG-NEXT
			    <+ <GET .TB ,MG-NEXT> <- .VAR .DIS>>>)>)>
	 <RFALSE>>

<ROUTINE I-FOLLOW ("AUX" (FLG <>) (CNT 0) GT)
	 <REPEAT ()
		 <COND (<G? <SET CNT <+ .CNT 1>> ,CHARACTER-MAX>
			<RETURN>)
		       (<AND <GET <SET GT <GET ,GOAL-TABLES .CNT>> ,GOAL-S>
			     <OR <GET .GT ,GOAL-ENABLE>
				 <0? <GET .GT ,ATTENTION>>>>
			<PUT .GT ,GOAL-ENABLE T>
			<COND (<FOLLOW-GOAL <GET ,CHARACTER-TABLE .CNT>>
			       <SET FLG T>)>)>>
	 .FLG>
		       
<ROUTINE I-ATTENTION ("AUX" (FLG <>) (CNT 0) ATT)
	 <REPEAT ()
		 <COND (<G? <SET CNT <+ .CNT 1>> ,CHARACTER-MAX> <RETURN>)
	       	       (<==? <SET ATT <- <GET ,ATTENTION-TABLE .CNT> 1>> 1>
			<COND (<IN? <GET ,CHARACTER-TABLE .CNT> ,HERE>
			       <TELL D <GET ,CHARACTER-TABLE .CNT>
			             " starts to move about distractedly." CR>
			       <SET FLG T>)>)
		       (<==? .ATT 0>
			<PUT <GET ,GOAL-TABLES .CNT> ,GOAL-ENABLE T>)>
	 	 <PUT ,ATTENTION-TABLE .CNT .ATT>>
	 .FLG>
	 
<ROUTINE GRAB-ATTENTION (PERSON "AUX" (CHR <GETP .PERSON ,P?CHARACTER>) GT ATT)
	 #DECL ((PERSON) OBJECT (ATT) FIX)
	 <SET GT <GET ,GOAL-TABLES .CHR>>
	 <COND (<GET .GT ,GOAL-S>
		<PUT ,ATTENTION-TABLE .CHR <SET ATT <GET .GT ,ATTENTION-SPAN>>>
		<COND (<==? .ATT 0>
		       <PUT .GT ,GOAL-ENABLE T>
		       <RFALSE>)
		      (<GET .GT ,GOAL-ENABLE>
		       <PUT .GT ,GOAL-ENABLE <>>)>)>
	 <SETG QCONTEXT .PERSON>
	 <SETG QCONTEXT-ROOM ,HERE>
	 <RTRUE>>

<GLOBAL WHERE-TABLES
        <TABLE <TABLE 0 0 0 0 0 0 0 0>
	       <TABLE 0 0 0 0 0 0 0 0>
	       <TABLE 0 0 0 0 0 0 0 0>
	       <TABLE 0 0 0 0 0 0 0 0>
	       <TABLE 0 0 0 0 0 0 0 0>
	       <TABLE 0 0 0 0 0 0 0 0>
	       <TABLE 0 0 0 0 0 0 0 0>
	       <TABLE 0 0 0 0 0 0 0 0>>>

<ROUTINE I-COATES ("OPTIONAL" (RARG <>))
	 <COND (<==? .RARG ,G-REACHED>
		<COND (<IN? ,COATES ,SOUTH-LAWN>
		       <REMOVE ,COATES>
		       <SETG POST-WILL <>>
		       <COND (<OR <EQUAL? ,HERE ,SOUTH-LAWN ,FRONT-PATH
				          ,EAST-OF-DOOR>
				  <EQUAL? ,HERE ,WEST-OF-DOOR ,EAST-LAWN
					  ,WEST-LAWN>>
			      <TELL
"A car pulls up the drive.  Coates enters the vehicle, motions
to the driver, and the car starts up and leaves the grounds." CR>)>)
		      (<IN? ,COATES ,LIVING-ROOM>
		       <COND (<==? ,HERE ,LIVING-ROOM>
			      <TELL
"Mr. Coates shakes your hand.  \"I'm glad you're here, Inspector.
We'll begin the reading soon.\"" CR>)>
		       <ENABLE <QUEUE I-WILL-READING 0>>
		       <I-WILL-READING>)>)>>