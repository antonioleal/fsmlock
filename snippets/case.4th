\ Miser's CASE
\
\ A general purpose Forth case statement.
\
\ Revision 4  2011-11-17
\
\ -------------------------------------------------------------
\ History
\ - RANGE changed to use recent BETWEEN proposal.
\   Add CONTINUE for C-style switching.
\ - Examples revised. Minor text changes.
\ - Added THENS END-CASE.
\ -------------------------------------------------------------
\
\ Sample implementation only.
\
\ The provided code is NOT portable. It makes assumptions
\ about the control flow stack which may not be applicable
\ to your forth.
\
\ Run-time code should be replaced by machine-code primitives
\ for maximum performance.
\
\ COND THENS is per Wil Baden. It provides the mechanism for
\ resolving nested conditionals and may be used independently
\ of CASE...ENDCASE.
\
\ END-CASE  Like ENDCASE but does not DROP the selector from
\ the stack. END-CASE is a synonym for THENS.
\
\ Tested on SwiftForth, VFX, Win32Forth, Gforth and others.
\
\ This code is public domain. Use at your own risk.
\
\ Keywords:
\
\   CASE ENDCASE COND WHEN EQUAL RANGE CONTINUE IF ELSE
\   END-CASE THENS
\
\   OF ENDOF ( for Forth-94 compatibility )
\
\ Syntax:
\
\   CASE ( x1 )
\      COND <tests> WHEN    ... ELSE
\           <test>  IF DROP ... ELSE
\           x2      OF      ... ENDOF
\                   DROP ... ( default )
\   END-CASE
\
\ All clauses are optional.
\
\ <tests> may consist of one or more of the following:
\
\    x2    EQUAL  ( test if x1 x2 equal )
\    x2 x3 RANGE  ( test if x1 in the range x2..x3 )
\
\ <test> can be any code that leaves x1 and a zero|non-zero
\ value.
\
\ CONTINUE may be placed anywhere within:
\
\   WHEN ... ELSE
\   IF ( DROP ) ... ELSE
\   OF ... ENDOF
\
\ CONTINUE redirects program flow from previously matched
\ clauses that would otherwise pass to ENDCASE. It provides
\ "fall-through" capability akin to C's switch statement.
\
\ IF ... ELSE is for expansion allowing user-defined tests.
\
\ OF ... ENDOF is largely obsolete but is retained for
\ backward compatibility with Forth-94.
\

0 constant COND  immediate

: THENS
  begin  ?dup while  postpone then  repeat ; immediate

0 constant CASE  immediate

\ Like ENDCASE but does not DROP
: END-CASE
  postpone thens ; immediate

\ Forth-94
: ENDCASE
  postpone drop  postpone end-case ; immediate

cr .( Are you using SwiftForth or VFX? Y/N )
\ key dup emit cr dup char Y = swap char y = or
true \ **handk** aleal

[if]

: WHEN
  postpone else  >r  postpone thens  r>  postpone drop ;
  immediate

: CONTINUE
  >r  postpone thens  0  r> ; immediate

[else]

cr .( Are you using gForth Y/N )
key dup emit cr dup char Y = swap char y = or
[if]

: WHEN
  postpone else  >r >r >r  thens  r> r> r>  postpone drop ;
  immediate

: CONTINUE
  >r >r >r  postpone thens  0  r> r> r> ; immediate

[else]

: WHEN
  postpone else  2>r  postpone thens  2r>  postpone drop ;
  immediate

: CONTINUE
  2>r  postpone thens  0  2r> ; immediate

[then]
[then]

: EQUAL
  postpone over  postpone -  postpone if ; immediate

\ Range is based on  : BETWEEN over - -rot - u< 0= ;
\ Values may be signed or unsigned.
: (range)
  2>r dup 2r> over - -rot - u< ;

: RANGE
  postpone (range)  postpone if ; immediate

\ OF ENDOF provided for Forth-94 compatibility
: ENDOF  postpone else ; immediate

: OF  postpone over  postpone =  postpone if
  postpone drop ; immediate



\ --------------------------------------------\
\ Test the case                               \
\ --------------------------------------------\

hex

: TEST1 ( n )  space
  case
    cond
          00 1F range
          7F    equal  when  ." Control char "       else
    cond
          20 2F range
          3A 40 range
          5B 60 range
          7B 7E range  when  ." Punctuation "        else
    cond  30 39 range  when  ." Digit "              else
    cond  41 5A range  when  ." Upper case letter "  else
    cond  61 7A range  when  ." Lower case letter "  else
      drop ." Not a character "
  end-case ;

decimal

cr cr .( Running TEST1...)

cr  char a  .(   ) dup emit  test1
cr  char ,  .(   ) dup emit  test1
cr  char 8  .(   ) dup emit  test1
cr  char ?  .(   ) dup emit  test1
cr  char K  .(   ) dup emit  test1
cr  0              dup 3 .r  test1
cr  127            dup 3 .r  test1
cr  128            dup 3 .r  test1

\ end

cr
.s
bye