"MAIN for
			    DEADLINE
	Copyright 1982 Infocom, Inc.  All rights reserved.
"

<GLOBAL P-WON <>>

<CONSTANT M-FATAL 2>
 
<CONSTANT M-HANDLED 1>   
 
<CONSTANT M-NOT-HANDLED <>>   
 
<CONSTANT M-BEG 1>  
 
<CONSTANT M-END <>> 
 
<CONSTANT M-ENTER 2>
 
<CONSTANT M-LOOK 3> 
 
<CONSTANT M-FLASH 4>

<CONSTANT M-OBJDESC 5>

<GLOBAL P-HIM-HER <>>
<GLOBAL P-HIM-HER-LOC <>>

<ROUTINE GO ()
	 <PUTB ,P-LEXV 0 59>
	 <SETG LIT T>
	 <SETG SCORE 8>
	 <SETG WINNER ,PLAYER>
	 <SETG HERE ,SOUTH-LAWN>
	 <SETG P-IT-LOC ,HERE>
	 <SETG P-IT-OBJECT <>>
	 <SETG P-HIM-HER ,MRS-ROBNER>
	 <SETG P-HIM-HER-LOC ,FOYER>
	 <COND (<NOT <FSET? ,HERE ,TOUCHBIT>>
		<ENABLE <QUEUE I-START-INTERRUPTS 1>>
		<START-MOVEMENT>
	 	<V-VERSION>
		<CRLF>)>
	 <MOVE ,WINNER ,HERE>
	 <V-LOOK>
	 <MAIN-LOOP>
	 <AGAIN>>    

<ROUTINE I-START-INTERRUPTS ()
	 <ENABLE <QUEUE I-NEWSPAPER <+ 175 <RANDOM 40>>>>
	 <ENABLE <QUEUE I-MAIL <+ 70 <RANDOM 60>>>>
	 <ENABLE <QUEUE I-CALL <+ 60 <RANDOM 10>>>>
	 <ENABLE <QUEUE I-BAXTER-ARRIVE 115>>
	 <ENABLE <QUEUE I-COATES-ARRIVE <+ 230 <RANDOM 5>>>>
	 <RFALSE>>


<ROUTINE MAIN-LOOP ("AUX" ICNT OCNT NUM CNT OBJ TBL V PTBL OBJ1 TMP) 
   #DECL ((CNT OCNT ICNT NUM) FIX (V) <OR 'T FIX FALSE> (OBJ) <OR FALSE OBJECT>
	  (OBJ1) OBJECT (TBL) TABLE (PTBL) <OR FALSE ATOM>)
   <REPEAT ()
     <SET CNT 0>
     <SET OBJ <>>
     <SET PTBL T>
     <COND (<SETG P-WON <PARSER>>
	    <SET ICNT <GET ,P-PRSI ,P-MATCHLEN>>
	    <SET NUM
		 <COND (<0? <SET OCNT <GET ,P-PRSO ,P-MATCHLEN>>> .OCNT)
		       (<G? .OCNT 1>
			<SET TBL ,P-PRSO>
			<COND (<0? .ICNT> <SET OBJ <>>)
			      (T <SET OBJ <GET ,P-PRSI 1>>)>
			.OCNT)
		       (<G? .ICNT 1>
			<SET PTBL <>>
			<SET TBL ,P-PRSI>
			<SET OBJ <GET ,P-PRSO 1>>
			.ICNT)
		       (T 1)>>
	    <COND (<NOT <==? ,QCONTEXT-ROOM ,HERE>>
	           <SETG QCONTEXT <>>)>
	    <COND (<AND <NOT .OBJ> <1? .ICNT>> <SET OBJ <GET ,P-PRSI 1>>)>
	    <COND (<==? ,PRSA ,V?WALK>
		   <SET V <PERFORM ,PRSA ,PRSO>>)
		  (<0? .NUM>
		   <COND (<0? <BAND <GETB ,P-SYNTAX ,P-SBITS> ,P-SONUMS>>
			  <SET V <PERFORM ,PRSA>>
			  <SETG PRSO <>>)
			 (T
			  <TELL "There isn't anything to ">
			  <SET TMP <GET ,P-ITBL ,P-VERBN>>
			  <COND (,P-OFLAG
				 <PRINTB <GET .TMP 0>>)
				(T
				 <WORD-PRINT <GETB .TMP 2> <GETB .TMP 3>>)>
			  <TELL "!" CR>
			  <SET V <>>)>)
		  (<AND .PTBL <==? .NUM 2> <==? ,PRSA ,V?ARREST>>
		   <SET V <PERFORM ,PRSA ,OBJECT-PAIR>>)
		  (T
		   <REPEAT ()
			   <COND (<G? <SET CNT <+ .CNT 1>> .NUM> <RETURN>)
				 (T
				  <COND (.PTBL <SET OBJ1 <GET ,P-PRSO .CNT>>)
					(T <SET OBJ1 <GET ,P-PRSI .CNT>>)>
				  <COND (<G? .NUM 1>
					 <COND (<==? .OBJ1 ,PLAYER> <AGAIN>)
					       (<FSET? .OBJ1 ,DUPLICATE>
						<AGAIN>)>
					 <PRINTD .OBJ1>
					 <TELL ": ">)>
				  <SET V <QCONTEXT-CHECK <COND (.PTBL .OBJ1)
							       (T .OBJ)>>>
				  <SET V
				       <PERFORM ,PRSA
						<COND (.PTBL .OBJ1) (T .OBJ)>
						<COND (.PTBL .OBJ) (T .OBJ1)>>>
				  <COND (<==? .V ,M-FATAL> <RETURN>)>)>>)>
	    <COND (<==? .V ,M-FATAL> <SETG P-CONT <>>)>)
	   (T
	    <SETG P-CONT <>>)>
     <COND (,P-WON
	    <COND (<VERB? TELL BRIEF SUPER-BRIEF VERBOSE TIME SAVE SPACE
			  UNSPACE VERSION
			  QUIT RESTART SCORE SCRIPT UNSCRIPT RESTORE> T)
		  (T <SET V <CLOCKER>>)>)>>>
 
<ROUTINE QCONTEXT-CHECK (PRSO)
	 <COND (<AND ,QCONTEXT
		     <IN? ,QCONTEXT ,HERE>
		     <==? ,QCONTEXT-ROOM ,HERE>
		     <==? ,WINNER ,PLAYER>>
	        <COND (<OR <VERB? WHAT>
			   <VERB? FIND>
			   <AND <VERB? TELL-ME> <==? .PRSO ,PLAYER>>
			   <AND <VERB? SHOW> <==? .PRSO ,PLAYER>>>
		       <SETG WINNER ,QCONTEXT>
		       <TELL "(said to " D ,QCONTEXT ")" CR>)>)>>

<GLOBAL L-PRSA <>>  
 
<GLOBAL L-PRSO <>>  
 
<GLOBAL L-PRSI <>>  


<ROUTINE PERFORM (A "OPTIONAL" (O <>) (I <>) "AUX" V OA OO OI) 
	#DECL ((A) FIX (O) <OR FALSE OBJECT FIX> (I) <OR FALSE OBJECT> (V) ANY)
	<SET OA ,PRSA>
	<SET OO ,PRSO>
	<SET OI ,PRSI>
	<SETG PRSA .A>
	<COND (<AND <EQUAL? ,IT .I .O>
		    <NOT <EQUAL? ,P-IT-LOC ,HERE>>>
	       <TELL "I don't see what you are referring to." CR>
	       <RFATAL>)
	      (<AND <EQUAL? ,HIM-HER .I .O>
		    <NOT <EQUAL? ,P-HIM-HER-LOC ,HERE>>>
	       <SET V <GET ,GLOBAL-CHARACTER-TABLE
			   <GETP ,P-HIM-HER ,P?CHARACTER>>>
	       <COND (<==? ,HIM-HER .O> <SET O .V>)
		     (<==? ,HIM-HER .I> <SET I .V>)>)>
	<COND (<==? .O ,IT> <SET O ,P-IT-OBJECT>)
	      (<==? .O ,HIM-HER> <SET O ,P-HIM-HER>)>
	<COND (<==? .I ,IT> <SET I ,P-IT-OBJECT>)
	      (<==? .I ,HIM-HER> <SET I ,P-HIM-HER>)>
	<SETG PRSO .O>
	<COND (<AND ,PRSO <NOT <VERB? WALK>>>
	       <COND (<FSET? ,PRSO ,PERSON>
		      <SETG P-HIM-HER ,PRSO>
		      <SETG P-HIM-HER-LOC ,HERE>)
		     (T
		      <SETG P-IT-OBJECT ,PRSO>
		      <SETG P-IT-LOC ,HERE>)>)>
	<SETG PRSI .I>
	<COND (<NOT <==? .A ,V?AGAIN>>
	       <SETG L-PRSA .A>
	       <COND (<==? .A ,V?WALK> <SETG L-PRSO <>>)
		     (T <SETG L-PRSO .O>)>
	       <SETG L-PRSI .I>)>
	<COND (<SET V <APPLY <GETP ,WINNER ,P?ACTION>>> .V)
	      (<SET V <APPLY <GETP <LOC ,WINNER> ,P?ACTION> ,M-BEG>> .V)
	      (<SET V <APPLY <GET ,PREACTIONS .A>>> .V)
	      (<AND .I <SET V <APPLY <GETP .I ,P?ACTION>>>> .V)
	      (<AND .O
		    <NOT <==? .A ,V?WALK>>
		    <SET V <APPLY <GETP .O ,P?ACTION>>>>
	       .V)
	      (<SET V <APPLY <GET ,ACTIONS .A>>> .V)>
	<COND (<NOT <==? .V ,M-FATAL>>
	       <SET V <APPLY <GETP <LOC ,WINNER> ,P?ACTION> ,M-END>>)>
	<SETG PRSA .OA>
	<SETG PRSO .OO>
	<SETG PRSI .OI>
	.V>  
 
