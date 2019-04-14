"VERBS for
			    DEADLINE
	Copyright 1982 Infocom, Inc.  All rights reserved.
"

"SUBTITLE DESCRIBE THE UNIVERSE"

"SUBTITLE SETTINGS FOR VARIOUS LEVELS OF DESCRIPTION"

<GLOBAL VERBOSE <>>
<GLOBAL SUPER-BRIEF <>>
<GDECL (VERBOSE SUPER-BRIEF) <OR ATOM FALSE>>

<ROUTINE V-VERBOSE ()
	 <SETG VERBOSE T>
	 <SETG SUPER-BRIEF <>>
	 <TELL "OK, you will get verbose descriptions." CR>>

<ROUTINE V-BRIEF ()
	 <SETG VERBOSE <>>
	 <SETG SUPER-BRIEF <>>
	 <TELL "OK, you will get brief descriptions." CR>>

<ROUTINE V-SUPER-BRIEF ()
	 <SETG SUPER-BRIEF T>
	 <TELL
"OK, you will get super-brief descriptions.  Remember that objects
and people are not mentioned; only the name of the place you are in." CR>>

\

"SUBTITLE DESCRIBERS"

<ROUTINE V-LOOK ()
	 <COND (<DESCRIBE-ROOM T>
		<DESCRIBE-OBJECTS T>)>>

<ROUTINE V-FIRST-LOOK ()
	 <COND (<DESCRIBE-ROOM>
		<COND (<NOT ,SUPER-BRIEF> <DESCRIBE-OBJECTS>)>)>>

<ROUTINE ROOM-CHECK ()
	 <COND (<IN? ,PRSO ,ROOMS>
		<COND (<==? ,PRSO ,HERE>
		       <SETG PRSO ,GLOBAL-ROOM>
		       <RFALSE>)
		      (T
		       <TELL "You aren't in that room!" CR>
		       <RTRUE>)>)
	       (T <RFALSE>)>>

<ROUTINE PRE-SEARCH ()
	 <COND (<ROOM-CHECK> <RTRUE>)
	       (T <RFALSE>)>>

<ROUTINE PRE-EXAMINE ()
	 <COND (<ROOM-CHECK> <RTRUE>)
	       (<AND <==? ,P-ADVERB ,W?CAREFULLY>
		     <NOT <INT-WAIT 3>>>
		<TELL
"You never got to finish looking over the " D ,PRSO "." CR>)>>

<ROUTINE V-EXAMINE ()
	 <COND (<IN? ,PRSO ,GLOBAL-OBJECTS>
		<NOT-HERE ,PRSO>
		<RTRUE>)
	       (<GETP ,PRSO ,P?TEXT>
		<TELL <GETP ,PRSO ,P?TEXT> CR>)
	       (<OR <FSET? ,PRSO ,CONTBIT>
		    <FSET? ,PRSO ,DOORBIT>>
		<V-LOOK-INSIDE>)
	       (<FSET? ,PRSO ,PERSON>
		<TELL <GET ,CHARACTER-DESCS <GETP ,PRSO ,P?CHARACTER>> CR>)
	       (ELSE
		<TELL "There's nothing special about the" PRSO "." CR>)>>

<GLOBAL LIT <>>

<ROUTINE DESCRIBE-ROOM ("OPTIONAL" (LOOK? <>) "AUX" V? STR)
	 <SET V? <OR .LOOK? ,VERBOSE>>
	 <COND (<NOT <FSET? ,HERE ,TOUCHBIT>>
		<FSET ,HERE ,TOUCHBIT>
		<SET V? T>)>
	 <COND (<IN? ,HERE ,ROOMS> <TELL D ,HERE CR>)>
	 <COND (<OR .LOOK? <NOT ,SUPER-BRIEF>>
		<COND (<FSET? <LOC ,WINNER> ,VEHBIT>
		       <TELL "(You are ">
		       <COND (<FSET? <LOC ,WINNER> ,SURFACEBIT>
			      <TELL "sitting o">)
			     (T <TELL "standing i">)>
		       <TELL "n the " D <LOC ,WINNER> ".)" CR>)>
		<COND (<AND .V? <APPLY <GETP ,HERE ,P?ACTION> ,M-LOOK>>
		       <RTRUE>)
		      (<AND .V? <SET STR <GETP ,HERE ,P?LDESC>>>
		       <TELL .STR CR>)
		      (T <APPLY <GETP ,HERE ,P?ACTION> ,M-FLASH>)>
		<COND (<NOT <==? ,HERE <LOC ,WINNER>>>
		       <APPLY <GETP <LOC ,WINNER> ,P?ACTION> ,M-LOOK>)>)>
	 <COND (<GETP ,HERE ,P?CORRIDOR> <CORRIDOR-LOOK>)>
	 T>

<ROUTINE DESCRIBE-OBJECTS ("OPTIONAL" (V? <>))
	 <COND (,LIT
		<COND (<FIRST? ,HERE>
		       <PRINT-CONT ,HERE <SET V? <OR .V? ,VERBOSE>> -1>)>)
	       (ELSE
		<TELL "You can't see anything in the dark." CR>)>>

"DESCRIBE-OBJECT -- takes object and flag.  if flag is true will print a
long description (fdesc or ldesc), otherwise will print short."

<ROUTINE DESCRIBE-OBJECT (OBJ V? LEVEL "AUX" (STR <>) AV)
	 <COND (<AND <0? .LEVEL>
		     <APPLY <GETP .OBJ ,P?DESCFCN> ,M-OBJDESC>>
		<RTRUE>)
	       (<AND <0? .LEVEL>
		     <OR <AND <NOT <FSET? .OBJ ,TOUCHBIT>>
			      <SET STR <GETP .OBJ ,P?FDESC>>>
			 <SET STR <GETP .OBJ ,P?LDESC>>>>
		<TELL .STR>)
	       (<0? .LEVEL>
		<TELL "There is a " D .OBJ " here.">)
	       (ELSE
		<TELL <GET ,INDENTS .LEVEL>>
		<TELL "A " D .OBJ>)>
	 <COND (<AND <0? .LEVEL>
		     <SET AV <LOC ,WINNER>>
		     <FSET? .AV ,VEHBIT>>
		<TELL " (outside the " D .AV ")">)>
	 <CRLF>
	 <COND (<AND <SEE-INSIDE? .OBJ> <FIRST? .OBJ>>
		<PRINT-CONT .OBJ .V? .LEVEL>)>>

<ROUTINE PRINT-CONT (OBJ "OPTIONAL" (V? <>) (LEVEL 0)
		     "AUX" Y 1ST? AV STR (PV? <>) (INV? <>))
	 #DECL ((OBJ) OBJECT (LEVEL) FIX)
	 <COND (<NOT <SET Y <FIRST? .OBJ>>> <RTRUE>)>
	 <COND (<AND <SET AV <LOC ,WINNER>> <FSET? .AV ,VEHBIT>>
		T)
	       (ELSE <SET AV <>>)>
	 <SET 1ST? T>
	 <COND (<EQUAL? ,WINNER .OBJ <LOC .OBJ>>
		<SET INV? T>)
	       (ELSE
		<REPEAT ()
			<COND (<NOT .Y> <RETURN <NOT .1ST?>>)
			      (<==? .Y .AV> <SET PV? T>)
			      (<==? .Y ,WINNER>)
			      (<AND <NOT <FSET? .Y ,INVISIBLE>>
				    <NOT <FSET? .Y ,TOUCHBIT>>
				    <SET STR <GETP .Y ,P?FDESC>>>
			       <COND (<NOT <FSET? .Y ,NDESCBIT>>
				      <SET 1ST? <>>
				      <SET LEVEL 0>
				      <TELL .STR CR>)>
			       <COND (<AND <SEE-INSIDE? .Y>
					   <NOT <GETP <LOC .Y> ,P?DESCFCN>>
					   <FIRST? .Y>>
				      <PRINT-CONT .Y .V? 0>)>)>
			<SET Y <NEXT? .Y>>>)>
	 <SET Y <FIRST? .OBJ>>
	 <REPEAT ()
		 <COND (<NOT .Y>
			<COND (<AND .PV? .AV <FIRST? .AV>>
			       <PRINT-CONT .AV .V? .LEVEL>)>
			<RETURN <NOT .1ST?>>)
		       (<EQUAL? .Y .AV ,PLAYER>)
		       (<AND <NOT <FSET? .Y ,INVISIBLE>>
			     <OR .INV?
				 <FSET? .Y ,TOUCHBIT>
				 <NOT <GETP .Y ,P?FDESC>>>>
			<COND (<NOT <FSET? .Y ,NDESCBIT>>
			       <COND (.1ST?
				      <COND (<FIRSTER .OBJ .LEVEL>
					     <COND (<L? .LEVEL 0>
						    <SET LEVEL 0>)>)>
				      <SET LEVEL <+ 1 .LEVEL>>
				      <SET 1ST? <>>)>
			       <DESCRIBE-OBJECT .Y .V? .LEVEL>)
			      (<AND <FIRST? .Y> <SEE-INSIDE? .Y>>
			       <PRINT-CONT .Y .V? .LEVEL>)>)>
		 <SET Y <NEXT? .Y>>>>

<ROUTINE FIRSTER (OBJ LEVEL)
	 <COND (<==? .OBJ ,WINNER>
		<TELL "You are carrying:" CR>)
	       (<NOT <IN? .OBJ ,ROOMS>>
		<COND (<G? .LEVEL 0>
		       <TELL <GET ,INDENTS .LEVEL>>)>
		<COND (<FSET? .OBJ ,SURFACEBIT>
		       <TELL "Sitting on the " D .OBJ
			     " is:" CR>)
		      (<FSET? .OBJ ,PERSON>
		       <TELL D .OBJ " is holding:" CR>)
		      (ELSE
		       <TELL "The " D .OBJ
			     " contains:" CR>)>)>>

\

"SUBTITLE SCORING"

<ROUTINE V-SCORE ("OPTIONAL" (ASK? T))
	 #DECL ((ASK?) <OR ATOM FALSE>)
	 <TELL
"You are an amateur inspector, at best." CR>>

<ROUTINE V-QUIT ("OPTIONAL" (ASK? T) "AUX" SCOR)
	 #DECL ((ASK?) <OR ATOM <PRIMTYPE LIST>> (SCOR) FIX)
	 <COND (<OR <AND .ASK?
			 <TELL
"Do you wish to stop your investigation (Y/N)">
			 <YES?>>
		    <NOT .ASK?>>
		<QUIT>)
	       (ELSE <TELL "Ok." CR>)>>

<ROUTINE YES? ()
	 <PRINTI " >">
	 <READ ,P-INBUF ,P-LEXV>
	 <COND (<0? <GETB ,P-LEXV ,P-LEXWORDS>>
		<RFALSE>)
	       (<EQUAL? <GET ,P-LEXV 1> ,W?YES ,W?Y>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE V-VERSION ("AUX" (CNT 17))
	 <TELL
"DEADLINE|
Infocom interactive fiction - a mystery story|
Copyright (c) 1982, 1983 by Infocom, Inc.  All rights reserved.|
DEADLINE is a registered trademark of Infocom, Inc.|
Release ">
	 <PRINTN <BAND <GET 0 1> *3777*>>
	 <TELL " / Serial number ">
	 <REPEAT ()
		 <COND (<G? <SET CNT <+ .CNT 1>> 23>
			<RETURN>)
		       (T
			<PRINTC <GETB 0 .CNT>>)>>
	 <CRLF>>

<ROUTINE V-AGAIN ("AUX" OBJ)
	 <SET OBJ
	      <COND (<AND ,L-PRSO <NOT <LOC ,L-PRSO>>>
		     ,L-PRSO)
		    (<AND ,L-PRSI <NOT <LOC ,L-PRSI>>>
		     ,L-PRSI)>>
	 <COND (.OBJ
		<TELL "You can't see the " D .OBJ " any more." CR>
		<RFATAL>)
	       (T
		<PERFORM ,L-PRSA ,L-PRSO ,L-PRSI>)>>

\

"SUBTITLE DEATH AND TRANSFIGURATION"

<GLOBAL DEAD <>>

<ROUTINE V-RESTORE ()
	 <COND (<RESTORE>
		<TELL "Ok." CR>
		<V-FIRST-LOOK>)
	       (T
		<TELL "Failed." CR>)>>

<ROUTINE V-SAVE ()
	 <COND (<SAVE>
	        <TELL "Ok." CR>)
	       (T
		<TELL "Failed." CR>)>>

<ROUTINE V-RESTART ()
	 <TELL
"Do you wish to restart your investigation (Y/N)">
	 <COND (<YES?>
		;<TELL CR "Not much like real life, eh? ... Restarting ..." CR>
		<RESTART>
		<TELL "Failed." CR>)>>

<CONSTANT REXIT 0>
<CONSTANT UEXIT 1>
<CONSTANT NEXIT 2>
<CONSTANT FEXIT 3>
<CONSTANT CEXIT 4>
<CONSTANT DEXIT 5>

<CONSTANT NEXITSTR 0>
<CONSTANT FEXITFCN 0>
<CONSTANT CEXITFLAG 1>
<CONSTANT CEXITSTR 1>
<CONSTANT DEXITOBJ 1>
<CONSTANT DEXITSTR 1>

<ROUTINE V-WALK-AROUND ()
	 <TELL "Use directions for movement here." CR>>

<ROUTINE GO-NEXT (TBL "AUX" VAL)
	 #DECL ((TBL) TABLE (VAL) ANY)
	 <COND (<SET VAL <LKP ,HERE .TBL>>
		<GOTO .VAL>)>>

<ROUTINE LKP (ITM TBL "AUX" (CNT 0) (LEN <GET .TBL 0>))
	 #DECL ((ITM) ANY (TBL) TABLE (CNT LEN) FIX)
	 <REPEAT ()
		 <COND (<G? <SET CNT <+ .CNT 1>> .LEN>
			<RFALSE>)
		       (<==? <GET .TBL .CNT> .ITM>
			<COND (<==? .CNT .LEN> <RFALSE>)
			      (T
			       <RETURN <GET .TBL <+ .CNT 1>>>)>)>>>

<ROUTINE V-WALK ("AUX" PT PTS STR OBJ RM)
	 #DECL ((PT) <OR FALSE TABLE> (PTS) FIX (STR) <OR STRING FALSE>
		(OBJ) OBJECT (RM) <OR FALSE OBJECT>)
	 <COND (<==? ,PRSO ,GLOBAL-CALL>
		<PRE-TURN>
		<RTRUE>)
	       (<NOT ,PRSO> <TELL "You can't go that way." CR>)
	       (<SET PT <GETPT ,HERE ,PRSO>>
		<COND (<==? <SET PTS <PTSIZE .PT>> ,UEXIT>
		       <SET RM <GETB .PT ,REXIT>>
		       <COND (<AND <EQUAL? ,STAIRS ,HERE .RM>
				   <EQUAL? ,P-ADVERB ,W?QUIETLY ,W?SLOWLY>>
			      <TELL
"The stairs are still quite noisy even when walking up very slowly." CR>)>
		       <GOTO .RM>)
		      (<==? .PTS ,NEXIT>
		       <TELL <GET .PT ,NEXITSTR> CR>
		       <RFATAL>)
		      (<==? .PTS ,FEXIT>
		       <COND (<SET RM <APPLY <GET .PT ,FEXITFCN>>>
			      <GOTO .RM>)
			     (T
			      <RFATAL>)>)
		      (<==? .PTS ,CEXIT>
		       <COND (<VALUE <GETB .PT ,CEXITFLAG>>
			      <GOTO <GETB .PT ,REXIT>>)
			     (<SET STR <GET .PT ,CEXITSTR>>
			      <TELL .STR CR>
			      <RFATAL>)
			     (T
			      <TELL "You can't go that way." CR>
			      <RFATAL>)>)
		      (<==? .PTS ,DEXIT>
		       <COND (<FSET? <SET OBJ <GETB .PT ,DEXITOBJ>> ,OPENBIT>
			      <GOTO <GETB .PT ,REXIT>>)
			     (<FSET? .OBJ ,INVISIBLE>
			      <TELL "You can't go that way." CR>)
			     (<SET STR <GET .PT ,DEXITSTR>>
			      <TELL .STR CR>
			      <RFATAL>)
			     (T
			      <TELL "The " D .OBJ " is closed." CR>
			      <SETG P-IT-LOC ,HERE>
			      <SETG P-IT-OBJECT .OBJ>
			      <RFATAL>)>)>)
	       (<==? ,PRSO ,P?IN>
		<TELL "In which direction do you want to go?" CR>
		<RFATAL>)
	       (T
		<TELL "You can't go that way." CR>
		<RFATAL>)>>

<ROUTINE V-INVENTORY ()
	 <COND (<FIRST? ,WINNER> <PRINT-CONT ,WINNER>)
	       (T <TELL "You are empty-handed." CR>)>>

<GLOBAL INDENTS
	<TABLE ""
	       "  "
	       "    "
	       "      "
	       "        "
	       "          ">>

\

<ROUTINE PRE-TAKE ()
	 <COND (<EQUAL? ,PRSO ,SECOND-SECTION
			,GLOBAL-FINGERPRINTS ,GLOBAL-LADDER> <RFALSE>)
	       (<EQUAL? ,PRSO ,GLOBAL-WARRANT ,GLOBAL-RED-HERRINGS> <RFALSE>)
	       (<IN? ,PRSO ,GLOBAL-OBJECTS>
		<NOT-HERE ,PRSO>)
	       (<IN? ,PRSO ,WINNER> <TELL "You already have it." CR>)
	       (<AND <FSET? <LOC ,PRSO> ,CONTBIT>
		     <NOT <FSET? <LOC ,PRSO> ,OPENBIT>>>
		<TELL "You can't reach that." CR>
		<RTRUE>)
	       (,PRSI
		<COND (<==? ,PRSI ,BOOKSHELVES> <RFALSE>)
		      (<NOT <==? ,PRSI <LOC ,PRSO>>>
		       <TELL "It's not in that!" CR>)
		      (T
		       <SETG PRSI <>>
		       <RFALSE>)>)
	       (<==? ,PRSO <LOC ,WINNER>> <TELL "You are in it, loser!" CR>)>>

<ROUTINE V-TAKE ()
	 <COND (<==? <ITAKE> T>
		<TELL "Taken." CR>)>>

<GLOBAL FUMBLE-NUMBER 7>
<GLOBAL FUMBLE-PROB 8>

<ROUTINE ITAKE ("OPTIONAL" (VB T) "AUX" CNT OBJ)
	 #DECL ((VB) <OR ATOM FALSE> (CNT) FIX (OBJ) OBJECT)
	 <COND (<NOT <FSET? ,PRSO ,TAKEBIT>>
		<COND (.VB
		       <TELL <PICK-ONE ,YUKS> CR>)>
		<RFALSE>)
	       (<AND <NOT <IN? <LOC ,PRSO> ,WINNER>>
		     <G? <+ <WEIGHT ,PRSO> <WEIGHT ,WINNER>> ,LOAD-ALLOWED>>
		<COND (.VB
		       <TELL "Your load is too heavy">
		       <COND (<L? ,LOAD-ALLOWED ,LOAD-MAX>
			      <TELL ", especially in light of your condition.">)
			     (ELSE <TELL ".">)>
		       <CRLF>)>
		<RFATAL>)
	       (<AND <G? <SET CNT <CCOUNT ,WINNER>> ,FUMBLE-NUMBER>
		     <PROB <* .CNT ,FUMBLE-PROB>>>
		<SET OBJ <FIRST? ,WINNER>>
		<SET OBJ <NEXT? .OBJ>>
		;"This must go!  Chomping compiler strikes again"
		<TELL "Oh, no. The " D .OBJ
		      " slips from your arms while you are taking the "
		      D ,PRSO ",
and both tumble to the ground." CR>
		<PERFORM ,V?DROP .OBJ>
		<RFATAL>)
	       (T
		<MOVE ,PRSO ,WINNER>
		<FSET ,PRSO ,TOUCHBIT>
		<RTRUE>)>>

<ROUTINE PRE-PUT ()
	 <COND (<OR <IN? ,PRSO ,GLOBAL-OBJECTS>
		    <NOT <FSET? ,PRSO ,TAKEBIT>>>
		<TELL "Nice try." CR>)>>

<ROUTINE V-PUT ()
	 <COND (<OR <FSET? ,PRSI ,OPENBIT>
		    <OPENABLE? ,PRSI>
		    <FSET? ,PRSI ,VEHBIT>> T)
	       (T
		<TELL "You can't do that." CR>
		<RTRUE>)>
	 <COND (<NOT <FSET? ,PRSI ,OPENBIT>>
		<TELL "The" PRSI " isn't open." CR>)
	       (<==? ,PRSI ,PRSO>
		<TELL "How can you do that?" CR>)
	       (<IN? ,PRSO ,PRSI>
		<TELL "The " D ,PRSO " is already in the " D ,PRSI "." CR>)
	       (<G? <- <+ <WEIGHT ,PRSI> <WEIGHT ,PRSO>>
		       <GETP ,PRSI ,P?SIZE>>
		    <GETP ,PRSI ,P?CAPACITY>>
		<TELL "There's no room." CR>)
	       (<AND <NOT <HELD? ,PRSO>>
		     <NOT <ITAKE>>>
		<RTRUE>)
	       (T
		<MOVE ,PRSO ,PRSI>
		<FSET ,PRSO ,TOUCHBIT>
		<TELL "Done." CR>)>>

<ROUTINE HELD? (OBJ)
	 <REPEAT ()
		 <COND (<EQUAL? <LOC .OBJ> ,ROOMS ,GLOBAL-OBJECTS> <RFALSE>)
		       (<IN? .OBJ ,WINNER> <RTRUE>)
		       (T <SET OBJ <LOC .OBJ>>)>>>

<ROUTINE PRE-DROP ()
	 <COND (<==? ,PRSO <LOC ,WINNER>>
		<PERFORM ,V?DISEMBARK ,PRSO>
		<RTRUE>)>>

<ROUTINE PRE-GIVE ()
	 <COND (<AND <NOT <HELD? ,PRSO>> <NOT <EQUAL? ,PRSI ,PLAYER>>>
		<TELL 
"That's easy for you to say, since you don't even have it." CR>)>>

<ROUTINE PRE-SGIVE ()
	 <PERFORM ,V?GIVE ,PRSI ,PRSO>
	 <RTRUE>>

<ROUTINE V-GIVE ()
	 <COND (<NOT <FSET? ,PRSI ,PERSON>>
		<TELL "You can't give a " D ,PRSO " to a " D ,PRSI "!" CR>)
	       (T <TELL D ,PRSI " refuses your offer." CR>)>>

<ROUTINE V-SGIVE ()
	 <TELL "FOOOO!!" CR>>

<ROUTINE V-DROP ()
	 <COND (<IDROP>
		<TELL "The " D ,PRSO " is now on the ">
		<COND (<==? <GETP ,HERE ,P?LINE> ,OUTSIDE-LINE-C>
		       <TELL "ground">)
		      (T <TELL "floor">)>
		<TELL "." CR>)>>

<ROUTINE V-THROW () <COND (<IDROP> <TELL "Thrown." CR>)>>

<ROUTINE V-THROW-THROUGH ()
	 <COND (<NOT <FSET? ,PRSO ,PERSON>>
		<TELL "Let's not resort to violence, please." CR>)
	       (T <V-THROW>)>>

<ROUTINE V-THROW-AT ()
	 <COND (<NOT <IDROP>> <RTRUE>)
	       (<FSET? ,PRSI ,PERSON>
		<TELL D ,PRSI
		      ", puzzled by your unorthodox methods, ducks as the "
		      D ,PRSO " flies by." CR>)
	       (T <TELL "Perhaps you aren't feeling well?" CR>)>>

<ROUTINE IDROP
	 ()
	 <COND (<FSET? ,PRSO ,PERSON>
		<TELL "It's not likely that " D ,PRSO " would enjoy that." CR>
		<RFALSE>)
	       (<AND <NOT <IN? ,PRSO ,WINNER>> <NOT <IN? <LOC ,PRSO> ,WINNER>>>
		<TELL "You're not carrying the" PRSO "." CR>
		<RFALSE>)
	       (<AND <NOT <IN? ,PRSO ,WINNER>>
		     <NOT <FSET? <LOC ,PRSO> ,OPENBIT>>>
		<TELL "The " D ,PRSO " is closed." CR>
		<RFALSE>)
	       (T <MOVE ,PRSO <LOC ,WINNER>> <RTRUE>)>>

\

<ROUTINE V-OPEN ("AUX" F STR)
	 <COND (<NOT <FSET? ,PRSO ,CONTBIT>>
		<TELL "You must be very clever to do that to the" PRSO "." CR>)
	       (<OR <FSET? ,PRSO ,DOORBIT>
		    <NOT <==? <GETP ,PRSO ,P?CAPACITY> 0>>>
		<COND (<FSET? ,PRSO ,OPENBIT> <TELL "It is already open." CR>)
		      (T
		       <FSET ,PRSO ,OPENBIT>
		       <COND (<FSET? ,PRSO ,DOORBIT>
			      <TELL "The " D ,PRSO " is now open." CR>)
			     (<OR <NOT <FIRST? ,PRSO>> <FSET? ,PRSO ,TRANSBIT>>
			      <TELL "Opened." CR>)
			     (<AND <SET F <FIRST? ,PRSO>>
				   <NOT <NEXT? .F>>
				   <SET STR <GETP .F ,P?FDESC>>>
			      <TELL "The " D ,PRSO " opens." CR>
			      <TELL .STR CR>)
			     (T
			      <TELL "Opening the " D ,PRSO " reveals ">
			      <PRINT-CONTENTS ,PRSO>
			      <TELL "." CR>)>)>)
	       (T <TELL "The" PRSO " cannot be opened." CR>)>>

<ROUTINE PRINT-CONTENTS (OBJ "AUX" F N (1ST? T))
	 #DECL ((OBJ) OBJECT (F N) <OR FALSE OBJECT>)
	 <COND (<SET F <FIRST? .OBJ>>
		<REPEAT ()
			<SET N <NEXT? .F>>
			<COND (.1ST? <SET 1ST? <>>)
			      (ELSE
			       <TELL ", ">
			       <COND (<NOT .N> <TELL "and ">)>)>
			<TELL "a " D .F>
			<SET F .N>
			<COND (<NOT .F> <RETURN>)>>)>>

<ROUTINE V-CLOSE ()
	 <COND (<NOT <FSET? ,PRSO ,CONTBIT>>
		<TELL "You must be very clever to do that to the" PRSO "." CR>)
	       (<FSET? ,PRSO ,DOORBIT>
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <TELL "The " D ,PRSO " is now closed." CR>
		       <FCLEAR ,PRSO ,OPENBIT>)
		      (T <TELL "It is already closed." CR>)>)
	       (<AND <NOT <FSET? ,PRSO ,SURFACEBIT>>
		     <NOT <==? <GETP ,PRSO ,P?CAPACITY> 0>>>
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <FCLEAR ,PRSO ,OPENBIT>
		       <TELL "Closed." CR>)
		      (T <TELL "It is already closed." CR>)>)
	       (ELSE
		<TELL "You cannot close that." CR>)>>

<ROUTINE CCOUNT (OBJ "AUX" (CNT 0) X)
	 <COND (<SET X <FIRST? .OBJ>>
		<REPEAT ()
			<SET CNT <+ .CNT 1>>
			<COND (<NOT <SET X <NEXT? .X>>>
			       <RETURN>)>>)>
	 .CNT>

"WEIGHT:  Get sum of SIZEs of supplied object, recursing to the nth level."

<ROUTINE WEIGHT
	 (OBJ "AUX" CONT (WT 0))
	 #DECL ((OBJ) OBJECT (CONT) <OR FALSE OBJECT> (WT) FIX)
	 <COND (<SET CONT <FIRST? .OBJ>>
		<REPEAT ()
			<SET WT <+ .WT <WEIGHT .CONT>>>
			<COND (<NOT <SET CONT <NEXT? .CONT>>> <RETURN>)>>)>
	 <+ .WT <GETP .OBJ ,P?SIZE>>>

<ROUTINE V-BUG ()
	 <TELL
"If there is a problem here, it is unintentional. You may report
your problem to the address provided in your documentation." CR>>

<GLOBAL COPR-NOTICE
" a transcript of interaction with DEADLINE.|
DEADLINE is a registered trademark of Infocom, Inc.|
Copyright (c) 1982 Infocom, Inc.  All rights reserved.|
">

<ROUTINE V-SCRIPT ()
	<PUT 0 8 <BOR <GET 0 8> 1>>
	<TELL "Here begins" ,COPR-NOTICE CR>>

<ROUTINE V-UNSCRIPT ()
	<TELL "Here ends" ,COPR-NOTICE CR>
	<PUT 0 8 <BAND <GET 0 8> -2>>
	<RTRUE>>

<ROUTINE PRE-MOVE ()
	 <COND (<HELD? ,PRSO>
		<TELL "Juggling isn't one of your talents." CR>)>>

<ROUTINE V-MOVE ()
	 <COND (<FSET? ,PRSO ,TAKEBIT>
		<TELL "Moving the" PRSO " reveals nothing." CR>)
	       (T <TELL "You can't move the" PRSO "." CR>)>>

<ROUTINE V-LAMP-ON ()
	 <COND (<FSET? ,PRSO ,PERSON>
		<TELL
"Ahem!  You may or may not realize this, but you are on a case.  You
shouldn't be wasting your time attempting to flirt with the suspects.
In any event, it's unlikely that you are person enough to do it." CR>)
	       (T <TELL "You can't turn that on." CR>)>>

<ROUTINE V-LAMP-OFF ()
	 <COND (<FSET? ,PRSO ,PERSON>
		<TELL "Your uncouth manner is certain to turn anyone off." CR>)
	       (T <TELL "You can't turn that off." CR>)>>

;"V-WAIT has three modes, depending on the arguments:
1) If only one argument is given, it will wait for that mnay moves
2) If a second argument is given, it will wait the least of the first
   argument number of moves and the time at which the second argument
   (an object) is in the room with the player.
3) If the third argument is given, the second should be FALSE.  It will
   wait <first argument> number of moves (or at least try to...).  The
   third argument means that an 'internal wait' is happening (e.g. for
   a 'careful' search)."

<GLOBAL WHO-WAIT 0>

<ROUTINE V-WAIT ("OPTIONAL" (NUM 3) (WHO <>) (INT <>) "AUX" VAL)
	 #DECL ((NUM) FIX)
	 <SETG WHO-WAIT 0>
	 <COND (<NOT .INT> <TELL "Time passes..." CR>)>
	 <REPEAT ()
		 <COND (<L? <SET NUM <- .NUM 1>> 0> <RETURN>)
		       (<SET VAL <CLOCKER>>
			<COND (<==? .VAL ,M-FATAL> <RETURN>)
			      (<AND <==? .WHO ,GLOBAL-DUFFY>
				    <NOT ,FINGERPRINT-OBJ>>
			       <RETURN>)
			      (<AND .WHO <IN? .WHO ,HERE>>
			       <TELL D .WHO
", for whom you are waiting, has arrived." CR>
			       <RETURN>)
			      (T
			       <SETG WHO-WAIT <+ ,WHO-WAIT 1>>
			       <COND (<NOT <==? <BAND <GETB 0 1> 16> 0>>
				      <TELL "(">
				      <TIME-PRINT ,PRESENT-TIME>
				      <TELL ") ">)>
			       <COND (.INT
				      <TELL
"Do you want to continue what you were doing? (Y/N)">)
				     (T
				      <TELL
"Do you want to keep waiting? (Y/N)">)>
			       <COND (<NOT <YES?>> <RETURN>)
				     (T <USL>)>)>)
		       (<AND <==? .WHO ,GLOBAL-DUFFY>
			     <NOT ,FINGERPRINT-OBJ>>
			<RETURN>)
		       (<AND .WHO <IN? .WHO ,HERE>>
			<TELL D .WHO
", for whom you are waiting, has arrived." CR>
			<RETURN>)
		       (<AND .WHO <G? <SETG WHO-WAIT <+ ,WHO-WAIT 1>> 30>>
			<TELL D .WHO
" still hasn't arrived.  Do you want to keep waiting? (Y/N) ">
			<COND (<NOT <YES?>> <RETURN>)>
			<SETG WHO-WAIT 0>
			<USL>)
		       (T <USL>)>>
	 <SETG CLOCK-WAIT T>
	 <COND (<NOT .INT> <V-TIME>)>
	 <RTRUE>>

<ROUTINE INT-WAIT (N "AUX" TIM REQ)
	 <SET TIM ,PRESENT-TIME>
	 <V-WAIT <SET REQ <RANDOM <* .N 2>>> <> T>
	 <COND (<NOT <L? <- ,PRESENT-TIME .TIM> .REQ>>
		<RTRUE>)
	       (T <RFALSE>)>>

<ROUTINE V-WAIT-FOR ("AUX" WHO)
	 <COND (<==? ,PRSO ,INTNUM>
		<COND (<G? ,P-NUMBER ,PRESENT-TIME> <V-WAIT-UNTIL> <RTRUE>)
		      (<G? ,P-NUMBER 180>
		       <TELL "That's too long to wait." CR>)
		      (T <V-WAIT ,P-NUMBER>)>)
	       (<==? ,PRSO ,NOON> <V-WAIT-UNTIL> <RTRUE>)
	       (<==? ,PRSO ,GLOBAL-DUFFY>
		<COND (,FINGERPRINT-OBJ
		       <V-WAIT 10000 ,PRSO>)
		      (T
		       <TELL
"You would wait quite a while, since Sergeant Duffy is always
nearby, but never approaches you unless requested." CR>)>)
	       (<FSET? ,PRSO ,PERSON>
		<SET WHO <GET ,CHARACTER-TABLE
			      <GETP ,PRSO ,P?CHARACTER>>>
		<COND (<IN? .WHO ,HERE>
		       <TELL "That person is already here!" CR>)
		      (T <V-WAIT 10000 .WHO>)>)
	       (T <TELL "Not a good idea. You might wait all day." CR>)>>

<ROUTINE V-WAIT-UNTIL ()
	 <COND (<==? ,PRSO ,NOON>
		<SETG P-NUMBER 720>
		<SETG PRSO ,INTNUM>)
	       (<L? ,P-NUMBER 8>
		<SETG P-NUMBER <* <+ ,P-NUMBER 12> 60>>)
	       (<L? ,P-NUMBER 13>
		<SETG P-NUMBER <* ,P-NUMBER 60>>)>
	 <COND (<==? ,PRSO ,INTNUM>
		<COND (<G? ,P-NUMBER ,PRESENT-TIME>
		       <V-WAIT <- ,P-NUMBER ,PRESENT-TIME>>)
		      (T <TELL
"You are clearly ahead of your time." CR>)>)
	       (T <TELL "Your sanity is coming into question." CR>)>>

;<ROUTINE PRE-BOARD
	 ("AUX" AV)
	 <SET AV <LOC ,WINNER>>
	 <COND (<FSET? ,PRSO ,VEHBIT>
		<COND (<NOT <IN? ,PRSO ,HERE>>
		       <TELL "The "
			     D
			     ,PRSO
			     " must be on the ground to be boarded." CR>)
		      (<FSET? .AV ,VEHBIT>
		       <TELL "You are already in the " D .AV ", cretin!" CR>)
		      (T <RFALSE>)>)
	       (<FSET? ,PRSO ,FURNITURE>
		<TELL
"You should be solving the case, not sitting down on the job!" CR>)
	       (T
		<TELL "You no doubt have a theory on boarding a "
		      D
		      ,PRSO
		      "." CR>)>
	 <RFATAL>>

;<ROUTINE V-BOARD
	 ("AUX" AV)
	 #DECL ((AV) OBJECT)
	 <TELL "You are now in the " D ,PRSO "." CR>
	 <MOVE ,WINNER ,PRSO>
	 <APPLY <GETP ,PRSO ,P?ACTION> ,M-ENTER>
	 <RTRUE>>

<ROUTINE V-STAND ()
	 <COND (<OR <FSET? <LOC ,WINNER> ,SURFACEBIT>
		    <FSET? <LOC ,WINNER> ,FURNITURE>>
		<TELL "You are on your own feet again." CR>
		<MOVE ,WINNER ,HERE>)
	       (T
		<TELL "You're already standing up!" CR>)>>

<ROUTINE V-DISEMBARK ()
	 <COND (<NOT <==? <LOC ,WINNER> ,PRSO>>
		<TELL "You're not in that!" CR>
		<RFATAL>)
	       (T ;<FSET? ,HERE ,RLANDBIT>
		<TELL "You are on your own feet again." CR>
		<MOVE ,WINNER ,HERE>)
	       ;(T
		<TELL
"You realize, just in time, that getting out here would probably be fatal." CR>
		<RFATAL>)>>

<ROUTINE GOTO (RM "OPTIONAL" (V? T) "AUX" F WT)
	 #DECL ((RM) OBJECT)
	 <COND (<NOT <IN? <LOC ,WINNER> ,ROOMS>>
		<TELL "You are seated, if you remember." CR>)
	       (T
		<SET F <FIRST? ,HERE>>
		<SET WT <GET ,WHERE-TABLES 0>>
		<REPEAT ()
			<COND (<NOT .F> <RETURN>)
			      (<AND <FSET? .F ,PERSON>
			            <NOT <==? .F ,PLAYER>>>
			       <PUT .WT <GETP .F ,P?CHARACTER> ,PRESENT-TIME>)>
			<SET F <NEXT? .F>>>
		<MOVE ,WINNER .RM>
		<SETG HERE .RM>
		<SETG LIT T>
		<APPLY <GETP ,HERE ,P?ACTION> ,M-ENTER>
		<COND (.V? <V-FIRST-LOOK>)>)>>

<ROUTINE PRE-POUR-ON ()
	 <TELL "You can't pour that on anything." CR>>

<ROUTINE V-POUR-ON
	 ()
	 <REMOVE ,PRSO>
	 <COND (<FLAMING? ,PRSI>
		<TELL "The " D ,PRSI " is extinguished." CR>)
	       (T
		<TELL "The water spills over the "
		      D
		      ,PRSI
		      " and to the floor where it evaporates." CR>)>>

<ROUTINE V-SQUEEZE
	 ()
	 <COND (<FSET? ,PRSO ,PERSON>
		<TELL "It's unclear how " D ,PRSO
		      " would take this, so you defer until after hours.">)
	       (ELSE <TELL "How singularly useless.">)>
	 <CRLF>>

<ROUTINE PRE-FILL ("AUX" TX)
	 <COND (<AND <NOT ,PRSI> <SET TX <GETPT ,HERE ,P?GLOBAL>>>
		<COND (<ZMEMQB ,GLOBAL-WATER .TX <PTSIZE .TX>>
		       <SETG PRSI ,GLOBAL-WATER>
		       <RFALSE>)
		      (T
		       <TELL "There's nothing to fill it with." CR>
		       <RTRUE>)>)>
	 <COND (<NOT <EQUAL? ,PRSI ,GLOBAL-WATER>>
		<PERFORM ,V?PUT ,PRSI ,PRSO>
		<RTRUE>)>>

<ROUTINE V-FILL ()
	 <COND (<NOT ,PRSI>
		<COND (<GLOBAL-IN? ,GLOBAL-WATER ,HERE>
		       <PERFORM ,V?FILL ,PRSO ,GLOBAL-WATER>)
		      (T
		       <TELL "There's nothing to fill it with." CR>)>)
	       (T <TELL "You can't do that." CR>)>>

<ROUTINE V-BRUSH ()
	 <TELL
"Cleanliness is next to Godliness, although in this case it seems to be
next to Uselessness." CR>>

<ROUTINE V-RING () <TELL "How, exactly, does one ring that?" CR>>

<ROUTINE V-DRINK ()
	 <V-EAT>>

<ROUTINE V-EAT ("AUX" (EAT? <>) (DRINK? <>) (NOBJ <>))
	 #DECL ((NOBJ) <OR OBJECT FALSE> (EAT? DRINK?) <OR ATOM FALSE>)
	 <COND (<AND <SET EAT? <FSET? ,PRSO ,FOODBIT>> <IN? ,PRSO ,WINNER>>
		<COND (<VERB? DRINK> <TELL "How does one drink that?" CR>)
		      (ELSE
		       <TELL "Mmm. That really hit the spot." CR>
		       <REMOVE ,PRSO>)>
		<CRLF>)
	       (<SET DRINK? <FSET? ,PRSO ,DRINKBIT>>
		<COND (<OR <IN? ,PRSO ,GLOBAL-OBJECTS>
			   <AND <SET NOBJ <LOC ,PRSO>>
				<IN? .NOBJ ,WINNER>
				<FSET? .NOBJ ,OPENBIT>>>
		       <TELL
"Mmm. That really hit the spot." CR>
		       <REMOVE ,PRSO>)
		      (T <TELL "You can't get to it." CR>)>)
	       (<NOT <OR .EAT? .DRINK?>>
		<TELL "The"
		      PRSO
		      " wouldn't agree with you." CR>)>>

<ROUTINE V-CURSES ()
	 <COND (,PRSO
		<COND (<FSET? ,PRSO ,PERSON>
		       <TELL "Insults of this nature won't help you." CR>)
		      (T
		       <TELL "What a loony!" CR>)>)
	       (T
		<TELL <PICK-ONE ,OFFENDED> CR>)>>

<ROUTINE V-LISTEN ()
	 <COND (<NOT <FSET? ,PRSO ,PERSON>>
		<TELL "The ">)>
	 <TELL D ,PRSO " makes no sound." CR>>

<ROUTINE V-FOLLOW ("AUX" CN CHR COR PCOR L)
	 <SET CN <GETP ,PRSO ,P?CHARACTER>>
	 <SET CHR <GET ,CHARACTER-TABLE .CN>>
	 <SET L <LOC .CHR>>
	 <COND (<==? ,PRSO ,PLAYER>
		<TELL
"It's not clear whom you are talking to." CR>)
	       (<NOT <FSET? ,PRSO ,PERSON>>
		<TELL
"How tragic to see a formerly great detective stalking a " D ,PRSO "." CR>)
	       (<==? ,HERE .L>
		<TELL
"You're in the same place as " D .CHR "!" CR>)
	       (<NOT .L>
		<TELL D .CHR " has left the grounds." CR>)
	       (<==? <GET <GET ,WHERE-TABLES 0> .CN> ,PRESENT-TIME>
		<GOTO .L>)
	       (<AND <SET COR <GETP ,HERE ,P?CORRIDOR>>
		     <SET PCOR <GETP .L ,P?CORRIDOR>>
		     <NOT <==? <BAND .COR .PCOR> 0>>>
		<SETG PRSO <COR-DIR ,HERE .L>>
		<V-WALK>)
	       (T <TELL "You seem to have lost track of " D .CHR "." CR>)>>

<GLOBAL OFFENDED
	<LTABLE "You ought to be ashamed of yourself."
		"One must try to avoid locker-room talk while working.">>

<ROUTINE V-LEAP ("AUX" TX S)
	 <COND (,PRSO
		<COND (<IN? ,PRSO ,HERE>
		       <COND (<FSET? ,PRSO ,PERSON>
			      <TELL "The "
				    D
				    ,PRSO
				    " is too big to jump over." CR>)
			     (T <V-SKIP>)>)
		      (T <TELL "That would be a good trick." CR>)>)
	       (<SET TX <GETPT ,HERE ,P?DOWN>>
		<SET S <PTSIZE .TX>>
		<COND (<OR <==? .S 2>					 ;NEXIT
			   <AND <==? .S 4>				 ;CEXIT
				<NOT <VALUE <GETB .TX 1>>>>>
		       <TELL
"For a brief moment, you feel the exhilaration of free fall.  A thought
hits you: the ground is moving toward me.  It is your last thought." CR>
		       <QUIT>)
		      (T <V-SKIP>)>)
	       (ELSE <V-SKIP>)>>

<ROUTINE V-SKIP () <TELL "Wheeeeeeeeee!!!!!" CR>>

<ROUTINE V-LEAVE () <PERFORM ,V?WALK ,P?OUT>>

<ROUTINE V-GOODBYE () <V-HELLO <>>>

<ROUTINE V-HELLO ("OPTIONAL" (HELL T))
	 <COND (,PRSO
		<COND (<FSET? ,PRSO ,PERSON>
		       <TELL D
			     ,PRSO
			     " returns the salutation." CR>)
		      (ELSE
		       <TELL
"Only schizophrenics say \"">
		       <COND (.HELL "Hello") (T "Goodbye")>
		       <TELL "\" to a "
			     D
			     ,PRSO
			     "." CR>)>)
	       (ELSE <TELL "Good day." CR>)>>

<ROUTINE NOT-HERE (OBJ)
	 <TELL "You can't see ">
	 <COND (<FSET? .OBJ ,PERSON>
		<TELL D .OBJ>)
	       (T <TELL "that">)>
	 <TELL " here." CR>>

<ROUTINE PRE-READ ()
	 <COND (<NOT ,LIT> <TELL "It is impossible to read in the dark." CR>)
	       (<EQUAL? ,PRSO ,GLOBAL-ENDING ,SECOND-SECTION> <RFALSE>)
	       (<IN? ,PRSO ,GLOBAL-OBJECTS>
		<NOT-HERE ,PRSO>)
	       (<FSET? ,PRSO ,DRUGBIT>
		<TELL "You examine one of the handful of pills:" CR>
		<RFALSE>)
	       (<AND ,PRSI
		     <NOT <FSET? ,PRSI ,TRANSBIT>>
		     <NOT <==? ,PRSI ,INTNUM>>>
		<TELL "How does one look through the" PRSI "?" CR>)
	       (<AND <==? ,P-ADVERB ,W?CAREFULLY>
		     <NOT <INT-WAIT 3>>>
		<TELL "You never got to finish reading the " D ,PRSO "." CR>)>>

<ROUTINE V-READ ()
	 <COND (<NOT <FSET? ,PRSO ,READBIT>>
		<TELL "You cannot read the " D ,PRSO "." CR>)
	       (ELSE <TELL <GETP ,PRSO ,P?TEXT> CR>)>>

<ROUTINE V-LOOK-UNDER ()
	 <COND (<FSET? ,PRSO ,FURNITURE>
		<TELL
"You twist your head to look under the" PRSO " but find nothing." CR>)
	       (<FSET? ,PRSO ,PERSON>
		<TELL "Nope.  Nothing hiding under " D ,PRSO "." CR>)
	       (<EQUAL? <LOC ,PRSO> ,HERE ,LOCAL-GLOBALS ,GLOBAL-OBJECTS>
		<TELL "There is nothing but dust there." CR>)
	       (T
		<TELL "That's not so useful." CR>)>>

<ROUTINE V-LOOK-BEHIND ()
	 <TELL "There is nothing behind ">
	 <COND (<FSET? ,PRSO ,PERSON>
		<TELL D ,PRSO>)
	       (T <TELL "the" PRSO>)>
	 <TELL "." CR>>

<ROUTINE V-LOOK-INSIDE
	 ()
	 <COND (<FSET? ,PRSO ,RLANDBIT>
		<ROOM-PEEK>)
	       (<FSET? ,PRSO ,DOORBIT>
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <TELL "The "
			     D
			     ,PRSO
			     " is open, but you can't tell what's beyond it.">)
		      (ELSE <TELL "The " D ,PRSO " is closed.">)>
		<CRLF>)
	       (<FSET? ,PRSO ,CONTBIT>
		<COND (<SEE-INSIDE? ,PRSO>
		       <COND (<AND <FIRST? ,PRSO> <PRINT-CONT ,PRSO>>
			      <RTRUE>)
			     (<FSET? ,PRSO ,SURFACEBIT>
			      <TELL "There is nothing on the" PRSO "." CR>)
			     (T
			      <TELL "The " D ,PRSO " is empty." CR>)>)
		      (ELSE <TELL "The " D ,PRSO " is closed." CR>)>)
	       (ELSE <TELL "One can't look inside the" PRSO "." CR>)>>

<ROUTINE SEE-INSIDE? (OBJ)
	 <AND <NOT <FSET? .OBJ ,INVISIBLE>>
	      <OR <FSET? .OBJ ,TRANSBIT> <FSET? .OBJ ,OPENBIT>>>>

<ROUTINE PRE-BURN ()
	 <COND (<FLAMING? ,PRSI> <RFALSE>)
	       (T <TELL "With the" PRSI "??!?" CR>)>>

<ROUTINE V-BURN
	 ()
	 <TELL "You can't burn the " D ,PRSO "." CR>
	 ;<COND (<FSET? ,PRSO ,BURNBIT>
		<COND (<IN? ,PRSO ,WINNER>
		       <REMOVE ,PRSO>
		       <TELL "The " D ,PRSO " catches fire." CR>
		       <TELL
"Unfortunately, you were holding it at the time." CR>
		       <QUIT>)
		      (T
		       <REMOVE ,PRSO>
		       <TELL "The " D ,PRSO
			     " catches fire and is consumed." CR>)
		      (ELSE <TELL "You don't have that." CR>)>)
	       (T )>>

<ROUTINE PRE-TURN ()
	 <COND (<==? ,PRSO ,GLOBAL-CALL>
		<TELL "Specify a direction if you want to move around." CR>)
	       (<NOT <FSET? ,PRSO ,TURNBIT>>
		<TELL "You can't turn that!" CR>)>>

<ROUTINE V-TURN () <TELL "This has no effect." CR>>

<ROUTINE V-PUMP ()
	 <TELL "It's not awfully clear how." CR>>

<ROUTINE V-LOCK () <TELL "It doesn't seem to work." CR>>

<ROUTINE V-PICK () <TELL "You can't pick that." CR>>

<ROUTINE V-UNLOCK () <TELL "It doesn't seem to work." CR>>

<ROUTINE V-CUT ()
	 <COND (<FSET? ,PRSO ,PERSON>
		<PERFORM ,V?KILL ,PRSO ,PRSI>)
	       (<AND <FSET? ,PRSO ,BURNBIT>
		     <FSET? ,PRSI ,WEAPONBIT>>
		<REMOVE ,PRSO>
		<TELL "Your skillful "
		      D
		      ,PRSI
		      "smanship slices the "
		      D
		      ,PRSO
		      " into innumerable
slivers that evaporate instantaneously."
		      CR>)
	       (<NOT <FSET? ,PRSI ,WEAPONBIT>>
		<TELL
"You find that the \"cutting edge\" of the" PRSI " is inadequate." CR>)
	       (T
		<TELL "That's a strange concept, cutting the" PRSO "." CR>)>>

<ROUTINE V-KILL ()
	 <IKILL "kill">>

<ROUTINE IKILL (STR)
	 #DECL ((STR) STRING)
	 <COND (<NOT ,PRSO> <TELL "There is nothing here to " .STR "." CR>)
	       (<NOT <FSET? ,PRSO ,PERSON>>
		<TELL "No doubt you need a refresher course at the academy "
		      "in the martial arts, but the "
		      D
		      ,PRSO
		      " is hardly a likely target." CR>)
	       (<==? ,PRSI ,PISTOL>
		<TELL
"A shot rings out and " D ,PRSO " falls to the ground, dead.  Good shot." CR>
		<GONE-CRAZY>)
	       (<PROB 50>
		<TELL "You rethink your planned action." CR>)
	       (T
		<TELL
"With a lethal blow of your hand, " D ,PRSO " falls dead." CR>
		<GONE-CRAZY>)>>

<ROUTINE V-ATTACK () <IKILL "attack">>

<ROUTINE V-SWING ()
	 <COND (<NOT ,PRSI>
		<TELL "Whoosh!" CR>)
	       (T <PERFORM ,V?ATTACK ,PRSI ,PRSO>)>>

<ROUTINE V-KICK ()
	 <COND (<FSET? ,PRSO ,PERSON>
		<TELL "This sort of shabby behavior is disgusting." CR>)
	       (T <HACK-HACK "Kicking the ">)>>

<ROUTINE V-WAVE () <HACK-HACK "Waving the ">>

<ROUTINE V-RAISE () <HACK-HACK "Playing in this way with the ">>

<ROUTINE V-LOWER () <HACK-HACK "Playing in this way with the ">>

<ROUTINE V-RUB () <HACK-HACK "Fiddling with the ">>

<ROUTINE V-PUSH () <HACK-HACK "Pushing the ">>

<ROUTINE V-MUNG ()
	 <HACK-HACK "Trying to destroy the ">>

<ROUTINE HACK-HACK
	 (STR)
	 #DECL ((STR) STRING)
	 <TELL .STR D ,PRSO <PICK-ONE ,HO-HUM> CR>>

<GLOBAL HO-HUM
	<LTABLE
	 " isn't particularly useful."
	 " has no effect.">>

<ROUTINE WORD-TYPE
	 (OBJ WORD "AUX" SYNS)
	 #DECL ((OBJ) OBJECT (WORD SYNS) TABLE)
	 <ZMEMQ .WORD
		<SET SYNS <GETPT .OBJ ,P?SYNONYM>>
		<- </ <PTSIZE .SYNS> 2> 1>>>

<ROUTINE V-KNOCK
	 ()
	 <COND (<WORD-TYPE ,PRSO ,W?DOOR>
		<TELL "It appears that nobody's home." CR>)
	       (ELSE <TELL "Why knock on a " D ,PRSO "?" CR>)>>

\

<ROUTINE V-SHAKE ("AUX" X)
	 <COND (<NOT <FSET? ,PRSO ,TAKEBIT>>
		<TELL "You can't take it; thus, you can't shake it!" CR>)
	       (<AND <NOT <FSET? ,PRSO ,OPENBIT>>
		     <FIRST? ,PRSO>>
		<TELL "It sounds as though there is something inside the "
		      D
		      ,PRSO
		      "."
		      CR>)
	       (<AND <FSET? ,PRSO ,OPENBIT> <FIRST? ,PRSO>>
		<REPEAT ()
			<COND (<SET X <FIRST? ,PRSO>>
			       <MOVE .X ,HERE>
			       <FSET .X ,TOUCHBIT>)
			      (ELSE <RETURN>)>>
		<TELL "Everything in it spills onto the floor." CR>)
	       (T <TELL "Well, what did you expect to happen?" CR>)>>

<ROUTINE PRE-DIG
	 ()
	 <COND (<FSET? ,PRSI ,TOOLBIT>
		<TELL "Digging with the" PRSI " is slow and tedious." CR>)
	       (ELSE
		<TELL "Digging with a " D ,PRSI " is silly." CR>)>>

<ROUTINE V-SEARCH-OBJECT-FOR ()
	 <COND (<FSET? ,PRSO ,PERSON>
		<TELL D ,PRSO
		      " resignedly allows you to perform the search." CR>
		<COND (<IN? ,PRSI ,PRSO>
		       <TELL "Indeed, " D ,PRSO " has the " D ,PRSI "." CR>)
		      (T <TELL D ,PRSO " doesn't have that." CR>)>)
	       (<IN? ,PRSI ,PRSO>
		<TELL "How observant you are!  There it is!" CR>)
	       (T <TELL "You don't find the" PRSI " there." CR>)>>

<ROUTINE V-DIG () <TELL "What a silly idea!" CR>>

<ROUTINE V-SMELL () <TELL "It smells just like a" PRSO "." CR>>

<ROUTINE GLOBAL-IN? (OBJ1 OBJ2 "AUX" TX)
	 <COND (<SET TX <GETPT .OBJ2 ,P?GLOBAL>>
		<ZMEMQB .OBJ1 .TX <- <PTSIZE .TX> 1>>)>>

<ROUTINE V-SWIM ()
	 <TELL "Swimming isn't possible ">
	 <COND (,PRSO
	        <TELL "in the " D ,PRSO>)
	       (<==? <GETP ,HERE ,P?LINE> ,OUTSIDE-LINE-C>
		<TELL "on the grounds">)
	       (T <TELL "right on the floor, Sherlock">)>
	 <TELL "." CR>>

<ROUTINE PRE-UNTIE ()
	 <TELL "This cannot be tied, so it cannot be untied!" CR>>

<ROUTINE V-UNTIE () <TELL "Foo!" CR>>

<ROUTINE PRE-TIE
	 ()
	 <COND (<==? ,PRSI ,WINNER>
		<TELL "You can't tie it to yourself." CR>)>>

<ROUTINE V-TIE () <TELL "You can't tie the" PRSO " to that." CR>>

<ROUTINE V-TIE-UP () <TELL "You could certainly never tie it with that!" CR>>

<ROUTINE V-MUMBLE
	 ()
	 <TELL "It has been a long day, hasn't it?" CR>>

<ROUTINE V-ALARM ()
	 <COND (<FSET? ,PRSO ,PERSON>
		<TELL "He's wide awake, or haven't you noticed?" CR>)
	       (ELSE
		<TELL "The" PRSO " doesn't sleep." CR>)>>

<ROUTINE V-ZORK ()
	 <TELL
"A series of fantasy simulation games and a registered trademark of Infocom,
Inc." CR>>

\

;<ROUTINE MUNG-ROOM (RM STR)
	 #DECL ((STR) STRING)
	 <FSET .RM ,RMUNGBIT>
	 <PUTP .RM ,P?LDESC .STR>>

<ROUTINE V-CLIMB-ON ()
	 <COND (<AND <FSET? ,PRSO ,FURNITURE> <FSET? ,PRSO ,VEHBIT>>
		<MOVE ,PLAYER ,PRSO>
		<TELL "You are now seated on the " D ,PRSO "." CR>)
	       (<FSET? ,PRSO ,FURNITURE>
		<TELL "This isn't the kind of thing to sit on!" CR>)
	       (T
		<TELL "You can't climb onto the " D ,PRSO "." CR>)>>

<ROUTINE V-CLIMB-FOO () <V-CLIMB-UP ,P?UP T>>

<ROUTINE V-CLIMB-UP ("OPTIONAL" (DIR ,P?UP) (OBJ <>) "AUX" X)
	 #DECL ((DIR) FIX (OBJ) <OR ATOM FALSE> (X) TABLE)
	 <COND (<GETPT ,HERE .DIR>
		<PERFORM ,V?WALK .DIR>
		<RTRUE>)
	       (<NOT .OBJ>
		<TELL "You can't go that way." CR>)
	       (<AND .OBJ
		     <ZMEMQ ,W?WALL
			    <SET X <GETPT ,PRSO ,P?SYNONYM>>
			    <- </ <PTSIZE .X> 2> 1>>>
		<TELL "Climbing the walls is to no avail." CR>)
	       (ELSE <TELL "Bizarre!" CR>)>>

<ROUTINE V-CLIMB-DOWN ()
	 <COND (<AND <FSET? ,PRSO ,FURNITURE> <FSET? ,PRSO ,VEHBIT>>
		<V-CLIMB-ON>
		<RTRUE>)
	       (T <V-CLIMB-UP ,P?DOWN>)>>

<ROUTINE V-SEND ()
	 <COND (<FSET? ,PRSO ,PERSON>
		<TELL "Why would you send for the" PRSO "?" CR>)
	       (ELSE <TELL "Sigh." CR>)>>

<ROUTINE V-COUNT ("AUX" (CNT <GETP ,PRSO ,P?COUNT>))
    #DECL ((CNT) FIX)
    <COND (<FSET? ,PRSO ,DRUGBIT>
	   <TELL "There ">
	   <COND (<1? .CNT> <TELL "is ">)
		 (T <TELL "are ">)>
	   <PRINTN .CNT>
	   <TELL " of them." CR>)
	  (<==? ,PRSO ,END-TABLE>
	   <TELL "There are two in a pair, or have you forgotten?" CR>)
	  (T
	   <TELL "Unless you are drunk, one." CR>)>>

<ROUTINE V-PUT-UNDER ()
         <TELL "There's not enough room." CR>>

<ROUTINE V-ENTER ()
	<PERFORM ,V?WALK ,P?IN>>

<ROUTINE V-EXIT ()
	 <PERFORM ,V?WALK ,P?OUT>>

<ROUTINE V-CROSS ()
	 <TELL "You can't cross that!" CR>>

<ROUTINE V-SEARCH ()
	 <COND (<FSET? ,PRSO ,PERSON>
		<TELL D ,PRSO
		      " grudgingly allows you to search.  You find nothing
whatsoever of interest." CR>)
	       (T <TELL "You find nothing unusual." CR>)>>

<GLOBAL PRON-HIM "him">
<GLOBAL PRON-HE "he">
<GLOBAL PRON-HER "her">
<GLOBAL PRON-SHE "she">

<ROUTINE PRE-FIND ("AUX" PRON PRON1 CHR NUM)
	 <SET PRON ,PRON-HIM>
	 <SET PRON1 ,PRON-HE>
	 <COND (<IN? ,PRSO ,ROOMS>
		<COND (<==? ,PRSO ,HERE>
		       <TELL "You're already here!" CR>)
		      (<FSET? ,PRSO ,TOUCHBIT>
		       <TELL "You should know - you've been there!" CR>)
		      (T <TELL "You're the detective!" CR>)>)
	       (<==? ,PRSO ,GLOBAL-MR-ROBNER>
		<TELL
"He's in the morgue, no doubt." CR>)
	       (<FSET? ,PRSO ,PERSON>
		<SET NUM <GET <GET ,WHERE-TABLES <GETP ,WINNER ,P?CHARACTER>>
			      <SET CHR <GETP ,PRSO ,P?CHARACTER>>>>
		<COND (<IN? ,PRSO ,GLOBAL-OBJECTS>
		       <SETG PRSO <GET ,CHARACTER-TABLE .CHR>>)>
		<COND (<EQUAL? .CHR ,MRS-ROBNER-C ,ROURKE-C ,DUNBAR-C>
		       <SET PRON ,PRON-HER>
		       <SET PRON1 ,PRON-SHE>)>
		<COND (<AND <NOT <==? ,WINNER ,PLAYER>>
			    <NOT <GRAB-ATTENTION ,WINNER>>>
		       <RTRUE>)>
		<COND (<==? <LOC ,WINNER> <LOC ,PRSO>>
		       <COND (<==? ,WINNER ,PLAYER>
			      <TELL "Are you blind?" CR>)
			     (T
			      <TELL "\"Ahem...\"" CR>)>)
		      (<0? .NUM>
		       <COND (<==? ,WINNER ,PLAYER>
			      <TELL
"You haven't seen " .PRON " yet." CR>)
			     (T
			      <TELL
"\"I haven't seen " .PRON " today.\"" CR>)>)
		      (T
		       <SET NUM <- ,PRESENT-TIME .NUM>>
		       <COND (<==? ,WINNER ,PLAYER>
			      <TELL
"You last saw " .PRON " ">)
			     (T
			      <TELL
"\"I last saw " .PRON " ">)>
		       <COND (<G? .NUM 120>
			      <TELL "a few hours ago">)
			     (<G? .NUM 80>
			      <TELL "an hour or two ago">)
			     (<G? .NUM 45>
			      <TELL "about an hour ago">)
			     (<G? .NUM 20>
			      <TELL "about half an hour ago">)
			     (<G? .NUM 10>
			      <TELL "about 15 minutes ago">)
			     (<G? .NUM 5>
			      <TELL "less than 10 minutes ago">)
			     (T
			      <TELL "just a minute ago">)>
		       <COND (<NOT <==? ,WINNER ,PLAYER>>
			      <TELL ".  I don't know where ">
			      <TELL .PRON1 " went, though.\"" CR>)
			     (T <TELL "." CR>)>)>
		<RTRUE>)>>

<ROUTINE V-FIND ("AUX" (L <LOC ,PRSO>))
	 <COND (<==? ,PRSO ,PLAYER>
		<TELL "You're around here somewhere..." CR>)
	       (<NOT <==? ,PLAYER ,WINNER>>
		<TELL "\"I don't know.\"" CR>)
	       (<EQUAL? .L ,GLOBAL-OBJECTS>
		<TELL "You're the detective." CR>)
	       (<IN? ,PRSO ,WINNER>
		<TELL "You have it." CR>)
	       (<OR <IN? ,PRSO ,HERE>
		    <==? ,PRSO ,PSEUDO-OBJECT>>
		<TELL "It's right here." CR>)
	       (<FSET? .L ,PERSON>
		<TELL D .L " has it." CR>)
	       (<FSET? .L ,CONTBIT>
		<TELL "It's ">
		<COND (<FSET? .L ,SURFACEBIT> <TELL "o">)
		      (T <TELL "i">)>
		<TELL "n the " D .L "." CR>)
	       (ELSE
		<TELL "Who knows?" CR>)>>

<GLOBAL QCONTEXT <>>
<GLOBAL QCONTEXT-ROOM <>>

<ROUTINE V-TELL ()
	 <COND (<==? ,PRSO ,PLAYER>
		<TELL
"Talking to yourself is said to be a sign of impending mental
collapse." CR>)
	       (<FSET? ,PRSO ,PERSON>
		<COND (,P-CONT
		       <SETG WINNER ,PRSO>)
		      (T
		       <TELL
D ,PRSO " is listening." CR>)>
		<SETG QCONTEXT ,PRSO>
		<SETG QCONTEXT-ROOM ,HERE>)
	       (T
		<TELL "You can't talk to the" PRSO "!" CR>
		<SETG QUOTE-FLAG <>>
		<SETG P-CONT <>>
		<RFATAL>)>>

<ROUTINE V-ANSWER ()
	 <TELL "Nobody seems to be awaiting your answer." CR>
	 <SETG P-CONT <>>
	 <SETG QUOTE-FLAG <>>
	 <RTRUE>>

<ROUTINE V-REPLY ()
	 <TELL "It is hardly likely that the " D ,PRSO " is interested." CR>
	 <SETG P-CONT <>>
	 <SETG QUOTE-FLAG <>>
	 <RTRUE>>

<ROUTINE V-WHAT ()
	 <COND (<FSET? ,PRSO ,PERSON>
		<TELL "Surely you have read the interviews." CR>)
	       (T <TELL "Are you talking to yourself again?" CR>)>>

<ROUTINE V-KISS ()
	 <COND (<FSET? ,PRSO ,PERSON>
		<TELL
"Section 204D, Paragraph 7.6 of the Connecticut Police Code of
Conduct specifically prohibits kissing suspects." CR>)
	       (T <TELL "What a (ahem!) strange idea!" CR>)>>

<ROUTINE V-RAPE ()
	 <COND (<FSET? ,PRSO ,PERSON>
		<COND (<PROB 75>
		       <TELL
"Section 29A of the United States Criminal Code, whose provisions
come to your unhealthy mind, tut-tuts this sort of thing.  A pity." CR>)
		      (T <GONE-CRAZY>)>)
	       (T <TELL "What a (ahem!) strange idea!" CR>)>>

<ROUTINE V-DIAGNOSE ()
	 <TELL "You're OK for now." CR>>

<ROUTINE V-SAY ("AUX" V)
	 <SETG QUOTE-FLAG <>>
	 <SETG P-CONT <>>
	 <TELL
"To talk to someone, try 'SAY TO someone \"something\"'." CR>>

<ROUTINE PRE-SSHOW ()
	 <SETG P-MERGED T>
	 <PERFORM ,V?SHOW ,PRSI ,PRSO>
	 <RTRUE>>

<ROUTINE V-SSHOW () <RTRUE>>

<ROUTINE V-SHOW ()
	 <COND (<==? ,PRSO ,PLAYER>
		<TELL "Do you often talk to yourself?" CR>)
	       (<NOT <FSET? ,PRSO ,PERSON>>
		<TELL "Do you expect applause from the" PRSO "?" CR>)
	       (T
		<TELL D ,PRSO <PICK-ONE ,WHO-CARES> "." CR>)>>

<GLOBAL WHO-CARES
	<LTABLE " doesn't appear interested"
		" seems not to care"
		" lets out a loud yawn"
		" seems to be getting impatient">>

<ROUTINE V-TELL-ME ()
	 <V-CONFRONT>>

<ROUTINE V-CONFRONT ()
	 <COND (<==? ,PRSO ,PLAYER>
		<TELL "You aren't talking to anyone!" CR>)
	       (<NOT <FSET? ,PRSO ,PERSON>>
		<TELL "That ought to put a scare into the" PRSO "." CR>)
	       (T
		<TELL D ,PRSO <PICK-ONE ,WHO-CARES> "." CR>)>>

<ROUTINE V-SEND-FOR ("AUX" REAL)
	 <COND (<NOT <FSET? ,PRSO ,PERSON>>
		<TELL "You can only send for a person." CR>)
	       (T
		<SET REAL <COND (<IN? ,PRSO ,GLOBAL-OBJECTS>
				 <GET ,CHARACTER-TABLE
				      <GETP ,PRSO ,P?CHARACTER>>)
				(T ,PRSO)>>
		<COND (<IN? .REAL ,HERE>
		       <TELL D .REAL " is already here." CR>)
		      (T <TELL "You can't send for people." CR>)>)>>

<ROUTINE V-ANALYZE ()
	 <COND (<==? ,PRSI ,GLOBAL-FINGERPRINTS>
		<PERFORM ,V?FINGERPRINT ,PRSO>
		<RTRUE>)
	       (<FSET? ,PRSO ,TAKEBIT>
		<DO-ANALYZE>)
	       (,FINGERPRINT-OBJ
		<TELL "Duffy is already occupied with another errand." CR>)
	       (<IN? ,PRSO ,GLOBAL-OBJECTS>
		<TELL
"Duffy appears in an instant. \"Well, I might be able to analyze the "
D ,PRSO ",
but you don't even have it with you!\"  With that, he discreetly leaves." CR>)
	       (T
		<TELL
"Sergeant Duffy appears with a puzzled look on his face. \"With all
respect, I don't think I can take THAT to the laboratory! I'll
be nearby if you need me.\" He leaves, shaking his head slowly." CR>)>>

<ROUTINE PRE-ACCUSE ()
	 <COND (<NOT ,PRSI>
		<SETG PRSI ,GLOBAL-MURDER>)>
	 <COND (<NOT <==? ,PRSI ,GLOBAL-MURDER>>
		<TELL "What an accusation!" CR>)
	       (<NOT <FSET? ,PRSO ,PERSON>>
		<TELL "What a detective!  Quick, Sergeant!  Arrest that "
		      D ,PRSO "!" CR>)>>

<ROUTINE V-ACCUSE ()
	 <TELL D ,PRSO " shrugs off your suggestion." CR>>

<ROUTINE V-ARREST ()
	 <COND (<FSET? ,PRSO ,PERSON>
		<TELL 
"You realize that you don't have enough evidence to convict " D ,PRSO>
		<TELL " so
you resolve to continue the investigation." CR>)
	       (<==? ,PRSO ,GLOBAL-DUFFY>
		<TELL "Oh, come on now!  Not trusty " D ,PRSO "!" CR>)
	       (T
		<TELL
"Sergeant Duffy enters, strokes his chin, and in a rather puzzled voice
says \"Excuse me, sir, but it would cause quite a stir at the station
to be charging a " D ,PRSO " with murder!\"  He leaves quietly." CR>)>> 

<ROUTINE V-ASK-ABOUT ()
	 <COND (<==? ,PRSO ,PLAYER>
		<TELL
"Talking to yourself is said to be a sign of impending mental
collapse." CR>)
	       (<==? ,PRSO ,GLOBAL-STEVEN>
		<TELL "Steven isn't in the area." CR>)
	       (<NOT <FSET? ,PRSO ,PERSON>>
		<TELL "Do you often talk to a " D ,PRSO "?" CR>)
	       (T
		<TELL D ,PRSO " doesn't seem to know about that." CR>)>>

<ROUTINE V-ASK-FOR ()
	 <COND (<AND <FSET? ,PRSO ,PERSON> <NOT <==? ,PRSO ,PLAYER>>>
	        <COND (<EQUAL? ,PRSI ,SAFE ,GLOBAL-SAFE>
		       <PERFORM ,V?ASK-ABOUT ,PRSO ,PRSI>
		       <RTRUE>)>
		<TELL D ,PRSO>
		<COND (<IN? ,PRSI ,PRSO>
		       <TELL " hands you the " D ,PRSI "." CR>
		       <MOVE ,PRSI ,WINNER>)
		      (T <TELL " doesn't have that." CR>)>)
	       (T <TELL "Be serious!" CR>)>>

<ROUTINE V-HOLD-UP ()
	 <TELL "That doesn't seem to help at all." CR>>

"Routines to do looking down corridors"

<ROUTINE CORRIDOR-LOOK ("OPTIONAL" (ITM <>) "AUX" C Z COR VAL (FOUND <>))
	 <COND (<SET C <GETP ,HERE ,P?CORRIDOR>>
		<REPEAT ()
			<COND (<NOT <L? <SET Z <- .C 2048>> 0>>
			       <SET COR ,COR-2048>)
			      (<NOT <L? <SET Z <- .C 1024>> 0>>
			       <SET COR ,COR-1024>)
			      (<NOT <L? <SET Z <- .C 512>> 0>>
			       <SET COR ,COR-512>)
			      (<NOT <L? <SET Z <- .C 256>> 0>>
			       <SET COR ,COR-256>)
			      (<NOT <L? <SET Z <- .C 128>> 0>>
			       <SET COR ,COR-128>)
			      (<NOT <L? <SET Z <- .C 64>> 0>>
			       <SET COR ,COR-64>)
			      (<NOT <L? <SET Z <- .C 32>> 0>>
			       <SET COR ,COR-32>)
			      (<NOT <L? <SET Z <- .C 16>> 0>>
			       <SET COR ,COR-16>)
			      (<NOT <L? <SET Z <- .C 8>> 0>>
			       <SET COR ,COR-8>)
			      (<NOT <L? <SET Z <- .C 4>> 0>>
			       <SET COR ,COR-4>)
			      (<NOT <L? <SET Z <- .C 2>> 0>>
			       <SET COR ,COR-2>)
			      (<NOT <L? <SET Z <- .C 1>> 0>>
			       <SET COR ,COR-1>)
			      (T <RETURN>)>
			<SET VAL <CORRIDOR-CHECK .COR .ITM>>
			<COND (<NOT .FOUND> <SET FOUND .VAL>)>
			<SET C .Z>>
		.FOUND)>>

<ROUTINE CORRIDOR-CHECK (COR ITM "AUX" (CNT 2) (PAST 0) (FOUND <>) RM OBJ)
	 #DECL ((COR) <PRIMTYPE VECTOR> (CNT PAST) FIX)
	 <REPEAT ()
		 <COND (<==? <SET RM <GET .COR .CNT>> 0>
			<RFALSE>)
		       (<==? .RM ,HERE> <SET PAST 1>)
		       (<SET OBJ <FIRST? .RM>>
			<REPEAT ()
				<COND (.ITM
				       <COND (<==? .OBJ .ITM>
					      <SET FOUND <GET .COR .PAST>>
					      <RETURN>)>)
				      (<AND <FSET? .OBJ ,PERSON>
					    <NOT <IN-MOTION? .OBJ>>>
				       <TELL D .OBJ " is ">
				       <COND (<==? <GETP .RM ,P?LINE>
						   ,OUTSIDE-LINE-C>
					      <TELL "off">)
					     (T <TELL "down the hall">)>
				       <TELL " to ">
				       <DIR-PRINT <GET .COR .PAST>>
				       <TELL "." CR>)>
				<SET OBJ <NEXT? .OBJ>>
				<COND (<NOT .OBJ> <RETURN>)>>
			<COND (.FOUND <RETURN .FOUND>)>)>
		 <SET CNT <+ .CNT 1>>>>

<ROUTINE V-LEAN ()
	 <TELL "You can't do that!" CR>>

<GLOBAL FINGERPRINT-OBJ <>>

<ROUTINE V-FINGERPRINT ()
	 <TELL
"Upon looking over and dusting the" PRSO " you notice that there are no
good fingerprints to be found." CR>>

<ROUTINE V-FLUSH ()
	 <TELL "Whatever do you have in mind?" CR>>

<ROUTINE V-DIG-AROUND ()
	 <TELL "You can't do that." CR>>

<ROUTINE V-SEARCH-AROUND ()
	 <TELL "You don't find anything interesting." CR>>

<ROUTINE V-SEARCH-GROUND-AROUND ()
	 <COND (<==? ,PRSO ,GROUND>
		<TELL "You don't find anything interesting." CR>)
	       (T <TELL "Huh?" CR>)>>

<ROUTINE V-SEARCH-GROUND-UNDER ()
	 <V-SEARCH-GROUND-AROUND>>

<ROUTINE V-TASTE ()
	 <TELL "That's ridiculous!" CR>>

<ROUTINE ROOM-PEEK ("AUX" OHERE)
	 <SET OHERE ,HERE>
	 <COND (<SEE-INTO? ,PRSO>
		<SETG HERE ,PRSO>
		<TELL
		 "You take a quick peek into the " D ,PRSO ":" CR>
		<DESCRIBE-OBJECTS>
		<SETG HERE .OHERE>)>>

 <ROUTINE SEE-INTO? (THERE "AUX" P L TX O)
	 <SET P 0>
	 <REPEAT ()
		 <COND (<0? <SET P <NEXTP ,HERE .P>>>
			<TELL
"You can't seem to find that room." CR>
			<RFALSE>)
		       (<EQUAL? .P ,P?IN ,P?OUT> T)
		       (<NOT <L? .P ,LOW-DIRECTION>>
			<SET TX <GETPT ,HERE .P>>
			<SET L <PTSIZE .TX>>
			<COND (<AND <==? .L ,UEXIT>
				    <==? <GETB .TX ,REXIT> .THERE>>
			       <RTRUE>)
			      (<AND <==? .L ,DEXIT>
				    <==? <GETB .TX ,REXIT> .THERE>>
			       <COND (<FSET? <GETB .TX ,DEXITOBJ> ,OPENBIT>
				      <RTRUE>)
				     (T
				      <TELL
"The door to that room is closed." CR>
				      <RFALSE>)>)
			      (<AND <==? .L ,CEXIT>
				    <==? <GETB .TX ,REXIT> .THERE>>
			       <COND (<VALUE <GETB .TX ,CEXITFLAG>>
				      <RTRUE>)
				     (T
				      <TELL
"You can't seem to find that room." CR>
				      <RFALSE>)>)>)>>>

<ROUTINE V-WRITE ()
	 <TELL "You're nuts." CR>>

<ROUTINE V-THROUGH ("OPTIONAL" (OBJ <>) "AUX" M DIR PT PTS)
	#DECL ((OBJ) <OR OBJECT FALSE> (M) <PRIMTYPE VECTOR>)
	<COND (<IN? ,PRSO ,ROOMS>
	       <COND (<==? ,HERE ,PRSO>
		      <TELL "Duuuhhh!" CR>)
		     (<SET DIR <DIR-FROM ,HERE ,PRSO>>
		      <PERFORM ,V?WALK .DIR>
		      <RTRUE>)
		     (T <TELL
"You can't go directly from here to there." CR>)>)
	      (<AND <NOT .OBJ> <NOT <FSET? ,PRSO ,TAKEBIT>>>
	       <TELL "You hit your head against the" PRSO
		     " as you attempt this feat." CR>)
	      (.OBJ <TELL "You can't do that!" CR>)
	      (<IN? ,PRSO ,WINNER>
	       <TELL "That would involve quite a contortion!" CR>)
	      (ELSE <TELL <PICK-ONE ,YUKS> CR>)>>

<GLOBAL PRESENT-TIME 480>

<ROUTINE V-TIME ()
	 <TELL "It is now ">
	 <TIME-PRINT ,PRESENT-TIME>
	 <TELL "." CR>>

<ROUTINE TIME-PRINT (NUM "AUX" HR (PM <>))
	 #DECL ((NUM HR) FIX (PM) <OR FALSE ATOM>)
	 <COND (<G? <SET HR </ .NUM 60>> 12>
		<SET HR <- .HR 12>>
		<SET PM T>)
	       (<==? .HR 12> <SET PM T>)>
	 <PRINTN .HR>
	 <TELL ":">
	 <COND (<L? <SET HR <MOD .NUM 60>> 10>
		<TELL "0">)>
	 <TELL N .HR " ">
	 <TELL <COND (.PM "pm") (T "am")>>>

<ROUTINE V-USE ()
	 <TELL "You should be more specific with what you want to do." CR>>

<ROUTINE V-PLAY ()
	 <TELL "You are adept only at playing the fool." CR>>

<ROUTINE V-TURN-UP ()
	 <TELL "That is silly." CR>>

<ROUTINE V-TURN-DOWN ()
	 <TELL "That is silly." CR>>

<ROUTINE V-HIDE-BEHIND ()
	 <TELL "There's no room to hide behind the" PRSO "." CR>>

<ROUTINE V-HIDE ()
	 <COND (<EQUAL? ,HERE ,EAST-LAWN>
		<TELL "You might hide behind the shed." CR>)
	       (<EQUAL? ,HERE ,LIBRARY>
		<TELL "You might hide on the balcony." CR>)
	       (T <TELL "There's no good hiding place here." CR>)>>

<ROUTINE V-CALL-LOSE ()
	 <TELL "You must supply a verb!" CR>>

<ROUTINE V-CALL ("AUX" PER (MOT <>))
	 <COND (<FSET? ,PRSO ,PERSON>
		<SET PER <GET ,CHARACTER-TABLE <GETP ,PRSO ,P?CHARACTER>>>
		<COND (<IN-MOTION? .PER> <SET MOT T>)>
		<COND (<OR <IN? .PER ,HERE> <CORRIDOR-LOOK .PER>>
		       <TELL D .PER>
		       <COND (<GRAB-ATTENTION .PER>
			      <COND (.MOT
				     <TELL " stops and turns toward you." CR>)
			      	    (T <TELL " is facing you." CR>)>)
			     (T
			      <TELL " takes no notice of your call." CR>)>)
		      (T <TELL "You don't see " D .PER " here." CR>)>)
	       (T <V-CALL-LOSE>)>>

<ROUTINE V-RUN-OVER ()
	 <TELL "That doesn't make much sense." CR>>

<ROUTINE PRE-RUB-OVER ()
	 <PERFORM ,V?RUB ,PRSI ,PRSO>
	 <RTRUE>>

<ROUTINE V-RUB-OVER ()
	 <TELL "Do you really expect that to help?" CR>>

<GLOBAL P-SPACE 1>

<ROUTINE V-SPACE ()
	 <SETG P-SPACE 1>
	 <TELL "Spacing." CR>>

<ROUTINE V-UNSPACE ()
	 <SETG P-SPACE 0>
	 <TELL "No spacing." CR>> 

<ROUTINE V-LOOK-ON ()
	 <COND (<FSET? ,PRSO ,SURFACEBIT>
		<V-LOOK-INSIDE>)
	       (T <TELL "There's no surface on the" PRSO "." CR>)>>

<ROUTINE V-LOOK-UP ()
	 <COND (<FSET? ,PRSO ,PERSON>
		<TELL "What a pervert!" CR>
		<RTRUE>)
	       (<NOT <==? ,PRSO ,ROOMS>>
		<TELL "Your sanity is in question." CR>
		<RTRUE>)
	       (<EQUAL? ,HERE ,IN-ROSES ,IN-ORCHARD>
		<TELL "You can see a balcony directly above you." CR>)
	       (<==? ,HERE ,SHED-ROOM>
		<TELL "There's nothing up there." CR>)
	       (<==? <GETP ,HERE ,P?LINE> ,OUTSIDE-LINE-C>
		<TELL "There is blue sky above you." CR>)
	       (T
		<TELL
"You can see the ceiling.  It's not the Sistine Chapel, but it's
nicely painted." CR>)>>

<ROUTINE V-LOOK-DOWN ()
	 <COND (<==? ,PRSO ,ROOMS>
		<COND (<==? <GETP ,HERE ,P?LINE> ,OUTSIDE-LINE-C>
		       <TELL "There's dirt there, mostly.  And grass." CR>)
		      (T
		       <TELL "Nothing's interesting about the floor." CR>)>)
	       (T <TELL "Your sanity is in question." CR>)>>

<ROUTINE V-YN ()
	 <COND (,QCONTEXT
		<TELL D ,QCONTEXT " ignores you completely." CR>)
	       (T <TELL "Did you say something?" CR>)>>

<ROUTINE V-THANKS ()
	 <COND (<OR ,PRSO ,QCONTEXT>
		<TELL D <OR ,PRSO ,QCONTEXT> " acknowledges your thanks." CR>)
	       (T <TELL "Whatever do you have to be thankful for?" CR>)>>

<ROUTINE V-PHONE ()
	 <COND (<NOT <FSET? ,PRSO ,PERSON>>
		<TELL "Perhaps it's time for you to rest...." CR>)
	       (<IN? ,PRSO ,HERE>
		<TELL D ,PRSO " is here!" CR>)
	       (<NOT <EQUAL? ,HERE ,LIVING-ROOM ,LIBRARY ,MASTER-BEDROOM>>
		<TELL "There's no phone here." CR>)
	       (T <TELL "There's no sense in phoning " D ,PRSO "." CR>)>>

<ROUTINE V-$VERIFY ()
	 <TELL "Verifying game..." CR>
	 <COND (<VERIFY> <TELL "Game correct." CR>)
	       (T <TELL CR "** Game File Failure **" CR>)>>