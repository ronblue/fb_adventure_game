#INCLUDE "fbgfx.bi"

TYPE locations
   AS STRING _location
   AS FB.Image PTR imge(1 TO 4)
END TYPE


TYPE position
   PRIVATE:
   DIM AS locations map(2 TO 4, 4 TO 6)
   AS STRING _direction(1 TO 4)
   PUBLIC:
   DECLARE CONSTRUCTOR()
   DECLARE DESTRUCTOR()
   DECLARE SUB centerPrint(row AS INTEGER, s AS STRING)
   DECLARE SUB display_screen(x AS INTEGER, y AS INTEGER, z AS INTEGER)
   DECLARE SUB main()
   
END TYPE

CONSTRUCTOR position
   DIM r AS STRING
   
   FOR x AS INTEGER = 1 TO 4
     READ r
     _direction(x) = r 
   NEXT
   
   
   'FOR ii AS INTEGER = 1 TO 5
   'READ r
   'map(ii)._location = r
   'NEXT
   
   
   FOR y AS INTEGER = 2 TO 4
      FOR yy AS INTEGER = 4 TO 6
         FOR i AS INTEGER = 1 TO 4
      'READ r
            map(y, yy)._view(i) = IMAGECREATE(800, 600)
            BLOAD("art\0" & y & "_0" & yy & "_" & i & ".bmp"), map(y, yy)._view(i)
         
         NEXT
      NEXT
   NEXT
END CONSTRUCTOR

'directions data
DATA "north", "east", "south", "west"


''locations data
'DATA "cell room", "hall way", "sterway up", "large chamber", "outside"
'
''cell room data
'DATA "brick wall infront of you"
'DATA "closed window with bars infront of you"
'DATA "a chair and a table in front of you"
'DATA "a closed door is infront of you"
'
''hall way data
'DATA "large wall with mirrors"
'DATA "an open door to a cell"
'DATA "long path forward"
'DATA "a wall with portraits"
'
''starway up data
'DATA "rows of candels on a long table"
'DATA "a large starway upwards"
'DATA "long dark path"
'DATA "a lock door with a sign saying 'death to the one who open this door!"
'
''large chamber data
'DATA "chairs and tables with durt on them"
'DATA "a gate half open ray of sunlight beems through"
'DATA "windows with bars on them"
'DATA "a starway downwards"
'
''outside data
'DATA "the sun light is so bright! ields of gold all around"
'DATA "a long road to a village"
'DATA "some trees and bushes"
'DATA "a gate open to a dark prison castel"

DESTRUCTOR position
   FOR y AS INTEGER = 2 TO 4
      FOR yy AS INTEGER = 4 TO 6
         FOR i AS INTEGER = 1 TO 4
      'READ r
            IMAGEDESTROY(map(y, yy)._view(i))
         NEXT
      NEXT
   NEXT
END DESTRUCTOR

Sub position.centerPrint(row AS INTEGER, s AS STRING)
   LOCATE row ,(LOWORD(width) - LEN(s)) Shr 1 : PRINT s
END SUB

SUB position.display_screen(x AS INTEGER, y AS INTEGER, z AS INTEGER)
   
   SCREENLOCK
   PUT (0,0), map(x, y)._view(z), TRANS
   centerprint 1, _direction(z)
   
   
   SCREENUNLOCK
   SLEEP 1
END SUB



SUB position.main()
   DIM direc AS STRING
   DIM z AS INTEGER = 1, y AS INTEGER = 1, x AS INTEGER = 1 
   DIM AS boolean isenter = FALSE 
   DO
   centerprint 15, "press any key to begin..."
   SLEEP
   DO
      CLS
      IF direc = "q" THEN END
     
      'centerprint 2, "you are in " & map(next_room)._location
      'centerprint 4, _direction(index)
      'centerprint 6, map(next_room)._view(index)
      display_screen(x,y,z)
            
      
      'IF next_room = 1 ANDalso index = 4 ANDalso direc = "open door" THEN
      '   centerprint 16, "cell door open! you can exit the cell!"
      '   isenter = TRUE
      '
      'ELSEIF next_room = 1 ANDALSO index = 4 THEN
      '   centerprint 15, "type 'open door' to open door"   
      '   isenter = FALSE
      '   IF direc = "f" then
      '      centerprint 14, "door closed you cannot move forwards"
      '   ENDIF
      'ENDIF
      'IF next_room = 3 ANDALSO index = 4 ANDALSO direc = "open door" THEN
      '   centerprint 16, "from the room an armed gurde come and stab you with a sward you die! - RIP"
      'ELSEIF next_room = 3 ANDALSO index = 4 THEN
      '   centerprint 15, "should we try to forcely open this door? if so type 'open door'"
      'ENDIF
      'IF next_room = 4 ANDALSO index = 2 ANDALSO direc = "open gate" THEN
      '   centerprint 16, "you made it! you are free! out of the prison cell!"
      '   isenter = TRUE 
      'ELSEIF next_room = 4 ANDALSO index = 2 THEN
      '   centerprint 15, "shell we try to open this gate? type 'open gate'"
      '   isenter = FALSE
      '   IF direc = "f" THEN
      '      centerprint 14, "first we most open the gate!"
      '   ENDIF
      '
      'ENDIF
      
      
      PRINT
      PRINT
      PRINT
      PRINT
      INPUT "choose direction('e' = east, 'w' = west, 'f' = forward, 'b' = backwards) or an action or key 'q' to quit: ", direc
      IF direc = "e" THEN z += 1
      IF direc = "w" THEN z -= 1
      IF direc = "f" ANDALSO isenter = TRUE THEN y += 1
      IF direc = "b" THEN y -= 1
      IF index < 1 THEN z = 4
      IF index > 4 THEN z = 1
      IF next_room < 4 THEN y = 4
      IF next_room > 6 THEN y = 6 
   LOOP
   
   LOOP UNTIL INKEY = CHR(27)
END SUB


SCREENRES 800, 600, 32

DIM game AS position
game.main()
