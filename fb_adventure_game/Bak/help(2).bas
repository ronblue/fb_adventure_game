DIM count AS INTEGER = 0

FOR x AS integer = 1 TO 7
   'FOR y AS INTEGER = 4 TO 6
      FOR i AS INTEGER = 1 TO 4
         PRINT "art\0" & x & "-" & i & ".bmp"
         count += 1
         
      NEXT
   'NEXT
NEXT

PRINT count
sleep