"CLOCK for
			    DEADLINE
	Copyright 1982 Infocom, Inc.  All rights reserved.
"

<CONSTANT C-TABLELEN 300>

<GLOBAL C-TABLE <ITABLE NONE 300>>

<GLOBAL C-DEMONS 300>

<GLOBAL C-INTS 300>

<CONSTANT C-INTLEN 6>

<CONSTANT C-ENABLED? 0>

<CONSTANT C-TICK 1>

<CONSTANT C-RTN 2>

<ROUTINE DEMON (RTN TICK "AUX" CINT)
	 #DECL ((RTN) ATOM (TICK) FIX (CINT) <PRIMTYPE VECTOR>)
	 <PUT <SET CINT <INT .RTN T>> ,C-TICK .TICK>
	 .CINT>

<ROUTINE QUEUE (RTN TICK "AUX" CINT)
	 #DECL ((RTN) ATOM (TICK) FIX (CINT) <PRIMTYPE VECTOR>)
	 <PUT <SET CINT <INT .RTN>> ,C-TICK .TICK>
	 .CINT>

<ROUTINE INT (RTN "OPTIONAL" (DEMON <>) E C INT)
	 #DECL ((RTN) ATOM (DEMON) <OR ATOM FALSE> (E C INT) <PRIMTYPE
							      VECTOR>)
	 <SET E <REST ,C-TABLE ,C-TABLELEN>>
	 <SET C <REST ,C-TABLE ,C-INTS>>
	 <REPEAT ()
		 <COND (<==? .C .E>
			<SETG C-INTS <- ,C-INTS ,C-INTLEN>>
			<AND .DEMON <SETG C-DEMONS <- ,C-DEMONS ,C-INTLEN>>>
			<SET INT <REST ,C-TABLE ,C-INTS>>
			<PUT .INT ,C-RTN .RTN>
			<RETURN .INT>)
		       (<==? <GET .C ,C-RTN> .RTN> <RETURN .C>)>
		 <SET C <REST .C ,C-INTLEN>>>>

<GLOBAL CLOCK-WAIT <>>

;"SCORE INDICATES HOURS / MOVES = MINUTES"

<GLOBAL SCORE 8>
<GLOBAL MOVES 0>

<ROUTINE CLOCKER ("AUX" C E TICK (FLG <>))
	 #DECL ((C E) <PRIMTYPE VECTOR> (TICK) FIX (FLG) <OR FALSE ATOM>)
	 <COND (,CLOCK-WAIT <SETG CLOCK-WAIT <>> <RFALSE>)>
	 <SETG PRESENT-TIME <+ ,PRESENT-TIME 1>>
	 <COND (<G? ,PRESENT-TIME 1199>
		<TELL
"Chief Inspector Klutz walks up to you, seemingly from out of nowhere.
\"I'm sorry, Inspector, but your time is up here.  I'm sorry that you
didn't have any more time to investigate the case.  Maybe next time...\"
He escorts you to a waiting police car, in which  you go off into the
sunset." CR>
		<QUIT>)>
	 <COND (<G? <SETG MOVES <+ ,MOVES 1>> 59>
		<SETG MOVES 0>
		<COND (<G? <SETG SCORE <+ ,SCORE 1>> 23>
		       <SETG SCORE 0>)>)>
	 <SET C <REST ,C-TABLE <COND (,P-WON ,C-INTS) (T ,C-DEMONS)>>>
	 <SET E <REST ,C-TABLE ,C-TABLELEN>>
	 <REPEAT ()
		 <COND (<==? .C .E> <RETURN .FLG>)
		       (<NOT <0? <GET .C ,C-ENABLED?>>>
			<SET TICK <GET .C ,C-TICK>>
			<COND (<0? .TICK>)
			      (T
			       <PUT .C ,C-TICK <- .TICK 1>>
			       <COND (<AND <NOT <G? .TICK 1>>
				           <APPLY <GET .C ,C-RTN>>>
				      <SET FLG T>)>)>)>
		 <SET C <REST .C ,C-INTLEN>>>>
