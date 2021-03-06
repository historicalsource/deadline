"COMPILE FILE for
			    DEADLINE
	Copyright 1982 Infocom, Inc.  All rights reserved.
"

;<SNAME "INFOCOM.DEADLINE">

<COND (<GASSIGNED? PREDGEN>
       <PRINC "Compiling">
       <ID 0>)
      (T <PRINC "Loading">)>

<PRINC " DEADLINE: An INTERLOGIC Mystery
">

<BLOAT 90000 0 0 3500 0 0 0 0 0 512>

<SET REDEFINE T>

<GLOBAL BIGFIX 10000>

<OR <GASSIGNED? ZILCH>
    <SETG WBREAKS <STRING !\" !,WBREAKS>>>

<OR <GASSIGNED? INSERT-CRUFTY>
    <DEFINE INSERT-CRUFTY (STR) <IFILE .STR T>>>

<DEFINE IFILE (STR "OPTIONAL" (FLOAD? <>) "AUX" (TIM <TIME>))
	<INSERT-FILE .STR .FLOAD?>>

<IFILE "DUNGEON" T>

<PROPDEF SIZE 5>
<PROPDEF CAPACITY 0>

<IFILE "SYNTAX" T>
<ENDLOAD>
<IFILE "MACROS" T>
<IFILE "CLOCK" T>
<IFILE "MAIN" T>
<IFILE "PARSER" T>
<INSERT-CRUFTY "CRUFTY">
<IFILE "VERBS" T>
<IFILE "ACTIONS" T>
<IFILE "GOAL" T>

<GC-MON T>
<GC 0 T 5>





