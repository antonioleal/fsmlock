(    Title:  Plain Structures
      File:  plainstruct.fs
   Adaptor:  David N. Williams
   Version:  1.0.4
   License:  Public Domain
 Test file:  plainstruct-test.fs
  Log file:  plainstruct.log
   Revised:  July 9, 2010

This library is based on the word set accepted as standard at
the 2007 Forth200x meeting:

  http://www.forth200x.org/structures.html

Words from the standard are marked "200x".

The "plain" in "plain structures" refers to the absence of
naming for definitions of structures.  Actually that's not quite
true.  The naming function of BEGIN-STRUCTURE ... END-STRUCTURE
from the standard is performed here by /STRUCT:, which names the
structure size explicitly instead of naming the structure and
having that name return the size.

There exist several implementations of structure field words
that do early binding to optimize offset calculation in
definitions, some included explicitly in Forth systems or
implicitly through their optimizing compilers.  Most avoid state
smartness.

The efficiency gain from early binding is often not important,
but this library does include a "plain" explicit scheme, based
on two syntax rules:

1. Make structure instances immediate.  For example, the words
   MAKE-IMM-STRUCT: and MAKE-IMM-FSTRUCT: do that.

2. In definitions, put offset words between [ and ]&.  See the
   MYIPOINT example below.

Syntax examples:

  \ structure definition
  STRUCT
    1 cells +FIELD >x
            field: >y
    1 chars +FIELD >plotchar
  /STRUCT: /point

  \ structure instance
  create mypoint /point allot
  15 mypoint >x !
  22 mypoint >y !
  char o mypoint >plotchar c!

  \ structure access
  15 mypoint >y !  \ stores 15
  mypoint >y @     \ fetches 15

  \ early binding structure instance
  /point MAKE-IMM-STRUCT: myipoint

  \ interpretive structure access
  15 myipoint >y !
  myipoint >y @

  \ early binding structure access
  : myipoint@  \ -- x y
    myipoint [ >x ]& @
    myipoint [ >y ]& @ ;

Field and structure size names are not reusable without special
name space management.  Structures are nestable.

Note that structure definitions that do not create an aligned
structure size word with /STRUCT: need to terminate with some
other word that removes the running offset from the stack, like
DROP.

See plainstruct-test.fs for more syntax examples.

This library is ANS Forth compatible up to case sensitivity.
)
decimal


\ *** WORDS
(
  STRUCT  /STRUCT:
  +FIELD
  CFIELD:  FIELD:  2FIELD:  SFIELD:  STRUCTFIELD:
  ]&
  MAKE-STRUCT:   MAKE-IMM-STRUCT:

  if floating point
  -----------------
  FFIELD:  SFFIELD:  DFFIELD:  FSTRUCTFIELD:
  MAKE-FSTRUCT:  MAKE-IMM-FSTRUCT:

    if MAXALIGNED undefined
    -----------------------
    MAXALIGNED  MAXALIGN
)


\ *** GLOSSARY
(
Notation for cell and floating-point alignment in stack
comments:  "a-offset", "fa-offset", "sfa-offset", "dfa-offset".

Define GFORTH externally to avoid redefinitions.  See
plainstruct-test.fs, which does that to test the gforth
implementation.
)

: STRUCT  ( -- 0 )  0 ; 

: /STRUCT:  ( u <"sizename"> -- )  aligned constant ;

[UNDEFINED] GFORTH [IF]

: +FIELD  ( offset size <"name"> -- offset+size )      \ 200x
  create over , +
DOES>  ( struc -- struc+offset )  @ + ;

: CFIELD:  ( offset <"name"> -- offset+1char )         \ 200x
\ Run:     ( struc -- struc+offset )
  1 chars +FIELD ;

: FIELD:  ( offset <"name">  -- a-offset+1cell )       \ 200x
\ Run:    ( struc -- struc+offset )
  aligned 1 cells +FIELD ;

: 2FIELD:  ( offset <"name">  -- a-offset+2cells )     \ gforth
\ Run:     ( struc -- struc+offset )    
  aligned 2 cells +FIELD ;

[THEN]  \ NOT GFORTH

: SFIELD:  ( offset <"name">  -- a-offset+2cells )
\ Run:     ( struc -- struc+offset )    
  aligned 2 cells +FIELD ;

: STRUCTFIELD: ( offset /struc <"name"> -- a-offset+/struc )
\ Run: ( struc -- struc+offset )
  swap aligned swap +FIELD ;

: MAKE-STRUCT:      ( /struc <"name"> -- )  create allot ;
: MAKE-IMM-STRUCT:  ( /struc <"name"> -- )  MAKE-STRUCT: immediate ;

: ]&  ( addr -- )  \ compilation                       \ cstruct
      ( -- addr )  \ run
  ] postpone literal ;

s" FLOATING-EXT" environment? [IF] ( flag) [IF]

[UNDEFINED] MAXALIGNED [IF]

: maxaligned  ( addr -- ma-addr )
\ Assume 2's complement and power of 2 alignment.
  [ 1 aligned faligned dfaligned ] literal
  >r r@ 1- + r> negate and ;

: maxalign  ( -- )  here dup maxaligned swap - allot ;

[THEN]  \ MAXALIGNED

[UNDEFINED] GFORTH [IF]

: FFIELD:  ( offset <"name"> -- fa-offset+1float )     \ 200x
\ Run:     ( struc -- struc+offset )
  faligned 1 floats +FIELD ;

: SFFIELD:  ( offset <"name"> -- sfa-offset+1sfloat )  \ 200x
\ Run:      ( struc -- struc+offset )
  sfaligned 1 sfloats +FIELD ;

: DFFIELD:  ( offset <"name"> -- dfa-offset+1dfloat )  \ 200x
\ Run:      ( struc -- struc+offset )
  dfaligned 1 dfloats +FIELD ;

[THEN]  \ NOT GFORTH

: FSTRUCTFIELD: ( offset /struc <"name"> -- maxa-offset+/struc )
\ Run: ( struc -- struc+offset )
  swap maxaligned swap +FIELD ;

: MAKE-FSTRUCT:  ( /struc <"name"> -- )
  maxalign here swap allot constant ;

: MAKE-IMM-FSTRUCT:  ( /struc <"name"> -- )  MAKE-FSTRUCT: immediate ;

[THEN] [THEN]  \ FLOATING-EXT






\ ----------------------------
\ tests
\ ----------------------------


\ structure definition
STRUCT
\ 1 cells +FIELD >x
        field: >x
        field: >y
1 chars +FIELD >plotchar
/STRUCT: /point

\ structure instance
create mypoint /point allot
15 mypoint >x !
22 mypoint >y !
char o mypoint >plotchar c!

create mypoint2 /point allot
16 mypoint2 >x !
17 mypoint2 >y !  \ stores 16

\ structure access
mypoint >x @ . mypoint >y @ . cr 
mypoint2 >x @ . mypoint2 >x @ . 

cr
.s
bye