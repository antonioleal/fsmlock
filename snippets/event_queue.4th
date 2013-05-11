\ Event queue
\
\ ---------------------------------------------------\
\     (c) Copyright 2013  Rosetta Code.              \
\ http://rosettacode.org/wiki/Queue/Definition#Forth \
\ ---------------------------------------------------\

\ ---------------------------------------------------\
\ Code to create FIFO queue to manage events         \
\ ---------------------------------------------------\

1024 constant EVT-QUEUE-SIZE
create EVT-QUEUE-BUFFER EVT-QUEUE-SIZE cells allot
here constant EVT-QUEUE-END
variable EVT-QUEUE-HEAD      EVT-QUEUE-BUFFER EVT-QUEUE-HEAD !
variable EVT-QUEUE-TAIL      EVT-QUEUE-BUFFER EVT-QUEUE-TAIL !
variable EVT-QUEUE-USED      0 EVT-QUEUE-USED !
 
: EVT-QUEUE-EMPTY?  EVT-QUEUE-USED @ 0= ;
: EVT-QUEUE-FULL?   EVT-QUEUE-USED @ EVT-QUEUE-SIZE = ;
 
: EVT-QUEUE-NEXT ( ptr -- ptr )
  cell+  dup EVT-QUEUE-END = if drop EVT-QUEUE-BUFFER then ;
 
: EVT-QUEUE-PUT ( n -- )
  EVT-QUEUE-FULL? abort" EVT-QUEUE-BUFFER full"
  \ begin full? while pause repeat
  EVT-QUEUE-TAIL @ !  EVT-QUEUE-TAIL @ EVT-QUEUE-NEXT EVT-QUEUE-TAIL !   1 EVT-QUEUE-USED +! ;
 
: EVT-QUEUE-GET ( -- n )
  EVT-QUEUE-EMPTY? abort" EVT-QUEUE-BUFFER empty"
  \ begin empty? while pause repeat
  EVT-QUEUE-HEAD @ @  EVT-QUEUE-HEAD @ EVT-QUEUE-NEXT EVT-QUEUE-HEAD !  -1 EVT-QUEUE-USED +! ;


\ ---------------------------------------------------\
\ Event queue test code                              \
\ ---------------------------------------------------\

: test-the-event-queue ( -- | test the event queue )
    begin
      key dup 13 <> over 10 <> and
    while
      dup emit
      EVT-QUEUE-PUT
      ." -" EVT-QUEUE-USED @ . ." , "
    repeat drop
    cr cr
    begin
      EVT-QUEUE-EMPTY? not
    while
      EVT-QUEUE-GET emit
    repeat
;

page
S" test the event queue:" type cr 
test-the-event-queue
cr cr .s bye

