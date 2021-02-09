#INCLUDE "fbgfx.bi"
#INCLUDE ONCE "fbsound_dynamic.bi"

Const xk = Chr(255)
Const key_up = xk + "H"
Const key_dn = xk + "P"
Const key_rt = xk + "M"
Const key_lt = xk + "K"

CONST AS SHORT scr_w = 800, scr_h = 600 ' screen constants

TYPE item
   AS INTEGER id
   AS STRING item_name
   AS STRING state(1 TO 2)
   AS INTEGER place
END TYPE



TYPE locations
   AS STRING _location
   AS FB.Image PTR _view(1 TO 4)
   AS LONG enteries(1 TO 4)
   
END TYPE


TYPE position
   PRIVATE:
   AS STRING message
   AS locations map(1 TO 7)
   AS STRING _direction(1 TO 4)
   AS item key
   
   PUBLIC:
   DECLARE CONSTRUCTOR()
   DECLARE DESTRUCTOR()
   DECLARE SUB display_screen(x AS INTEGER,z AS INTEGER)
   DECLARE SUB main()
   DECLARE SUB make_sound(f AS STRING, hWave AS INTEGER,t AS INTEGER)
END TYPE

CONSTRUCTOR position
   key.place = 1
   key.id = 1
   key.item_name = "golden key"
   key.state(1) = "on the ground"
   key.state(2) = "inside your pocket"
   
   
   DIM r AS STRING
   
   FOR x AS INTEGER = 1 TO 4
     READ r
     _direction(x) = r 
   NEXT
   
   
   FOR ii AS INTEGER = 1 TO 7
   READ r
   map(ii)._location = r
   NEXT
   
   
   FOR m AS INTEGER = 1 TO 7
      
         FOR i AS INTEGER = 1 TO 4
      
            map(m)._view(i) = IMAGECREATE(800, 600)
            BLOAD("art\0" & m & "-" & i & ".bmp"), map(m)._view(i)
         
         NEXT
      
   NEXT
   
   map(1).enteries(1) = -1
   map(1).enteries(2) = -1 
   map(1).enteries(3) = 2
   map(1).enteries(4) = -1 
   map(2).enteries(1) = 1  
   map(2).enteries(2) = 3  
   map(2).enteries(3) = -1 
   map(2).enteries(4) = -1 
   map(3).enteries(1) = -1 
   map(3).enteries(2) = 4  
   map(3).enteries(3) = -1 
   map(3).enteries(4) = 2  
   map(4).enteries(1) = 5  
   map(4).enteries(2) = -1   
   map(4).enteries(3) = 6  
   map(4).enteries(4) = 3
   map(5).enteries(1) = -1
   map(5).enteries(2) = -1
   map(5).enteries(3) = 4  
   map(5).enteries(4) = -1
   map(6).enteries(1) = 4
   map(6).enteries(2) = -1 
   map(6).enteries(3) = -1 
   map(6).enteries(4) = 7
   map(7).enteries(1) = -1 
   map(7).enteries(2) = 6
   map(7).enteries(3) = -1
   map(7).enteries(4) = -1
   
END CONSTRUCTOR

'directions data
DATA "north", "east", "south", "west"


''locations data
DATA "stable", "outside - yard", "yard", "yard road", "yard road", "up-stairs", "up-stairs" 


DESTRUCTOR position
   FOR y AS INTEGER = 1 TO 7
      
         FOR i AS INTEGER = 1 TO 4
      
            IMAGEDESTROY(map(y)._view(i))
         NEXT
      
   NEXT
END DESTRUCTOR

Sub centerPrint(row AS INTEGER, s AS STRING)
   LOCATE row ,(LOWORD(width) - LEN(s)) Shr 1 : PRINT s
END SUB

'APPEND TO the STRING array the STRING item
SUB sAppend(arr() AS STRING , Item AS STRING)
	REDIM PRESERVE arr(LBOUND(arr) TO UBOUND(arr) + 1) AS STRING
	arr(UBOUND(arr)) = Item
END SUB


SUB upper(f AS STRING)
	CLS
	REDIM lines(0) AS STRING
	DIM h AS LONG = FREEFILE()
	DIM AS INTEGER r = 35 , c = 30
	DIM fline AS STRING
	OPEN f FOR INPUT AS #h
	WHILE NOT EOF(h)
        LINE INPUT #h , fline
        sAppend lines() , fline
    WEND
	CLOSE #h
	
	DIM AS INTEGER hi = HIWORD(WIDTH()) 'num columns ON display
	'PRINT closing credits
	FOR i AS INTEGER = 0 TO UBOUND(lines)
        LOCATE hi , 10
        PRINT lines(i)
        SLEEP 500
    NEXT
	'CLEAR SCREEN
	FOR i AS INTEGER = 1 TO hi
        PRINT
        SLEEP 500
    NEXT
	PRINT "END"
	GETKEY()
END SUB


SUB position.display_screen(x AS INTEGER, z AS INTEGER)
   
   SCREENLOCK
   PUT (0,0), map(x)._view(z), TRANS
   centerprint 1, _direction(z)
   CENTERPRINT 3, map(x)._location
   CENTERPRINT 2, "press arrows key to navigate, press arrow key down for making an action, 'q' to exit"
   CENTERPRINT 15, message
   SCREENUNLOCK
   SLEEP 1
END SUB

SUB position.make_sound(f AS STRING, hWave AS INTEGER, t AS INTEGER)
   if fbs_Get_PlayingSounds() = 0 THEN
   fbs_Load_WAVFile(f , @hWave)
   fbs_Play_Wave(hWave , t)
   ENDIF
END SUB

SUB position.main()
   DIM AS INTEGER harpWav, stepsWav, knockWav
   DIM direc AS STRING
   DIM z AS INTEGER = 1, x AS INTEGER = 1
   DIM AS boolean isOpen = FALSE 
   DIM k AS STRING
   DO
   centerprint 15, "press any key to begin..."
   SLEEP
   DO
      k = INKEY
      CLS
      IF k = "q" THEN
         fbs_Destroy_Wave(@harpWav)
         fbs_Destroy_Wave(@knockWav)
         fbs_Destroy_Wave(@stepsWav)
         EXIT sub
      ENDIF
      
      IF x = 1 ANDalso z = 3 ANDALSO direc = "open door" THEN
         isOpen = TRUE
         message = "YOU OPEN THE LOCKED DOOR WITH THE GOLDEN KEY - THE DOOR IS OPENED"      
      
      ELSEIF x = 1 AND direc = "pick up key" THEN
         message = key.item_name & " " & key.state(2)
      
      ELSEIF x = 1 AND direc = "look around" THEN
         message = key.item_name & " " & key.state(1)
      
      ELSEIF x = 1 ANDALSO isOpen = FALSE THEN
         message = "DOOR IS LOCKED TYPE 'look around' TO FIND KEY"
      ENDIF
      
      IF k = key_rt THEN z += 1
      IF k = key_lt THEN z -= 1
      IF k = key_up THEN
         IF map(x).enteries(z) <> -1 ANDALSO isOpen = TRUE then 
            'x += 1
            x = map(x).enteries(z)
            make_sound("sound\step_02.wav" ,stepsWav, 1)
            message = ""
         ELSE
            message = "PATH IS BLOCKED! OR YOU CANNOT GO THERE!"
         ENDIF
      ENDIF
      
      IF k = key_dn THEN
         display_screen(x,z)
         LOCATE 36, 1
         INPUT "choose action ", direc
      ENDIF
      
      IF z < 1 THEN z = 4
      IF z > 4 THEN z = 1
      IF x < 1 THEN x = 1
      IF x > 7 THEN x = 7 
      display_screen(x,z)
            
      IF x = 2 THEN
         make_sound("sound\harp.wav" ,harpWav, 1)
      ENDIF
    
      
      
      'LOCATE 36, 1
      'INPUT "choose direction('r' = right, 'l' = left, 'f' = forward) or an action or key 'q' to quit: ", direc
      
   LOOP
   
   LOOP UNTIL INKEY = CHR(27)
END SUB

IF fbs_Init()=false THEN
PRINT "error: FBS_INIT() " & FBS_Get_PlugError()
BEEP : SLEEP : END 1
END IF

SCREENRES scr_w, scr_h, 32
WIDTH scr_w \ 8, scr_h \ 16
DIM game AS position
game.main()
'UPPER("ending.txt")