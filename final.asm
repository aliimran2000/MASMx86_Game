;>>GROUP NAME : MVG
;MUZZAMIL SHAKIR 18i-0645
;ALI IMRAN 18i-0847
;INSHA ZAHID 18L-1183

.model small
.stack 100h
include fmac.inc

.data
	playStr Db "Play" , '$'
	instructionStr DB "Instructions", "$"
	exitSTR DB "Exit", "$"
	message DB "HELLO",'$'
	error1 DB "Error1", "$"
	error2 DB "Error2", "$"
	error3 DB "Error3", "$"
	error4 DB "Error4", "$"
	file db "pi.txt", 0
	instructionsBuffer1 db 5000 dup("$")
	instructionsBuffer2 db 5000 dup("$")
	enterSTR db "Enter" , "$"
	val DB ?
    val2 db ?
	X dw ?
	Y dw ?
	valx dw 10 dup(0)
	valy dw 10 dup(0)
	bump_1X dw 0
	bump_1Y dw 178
	bump_2X dw 100
	bump_2Y dw 178
	bump_3X dw 200
	bump_3Y dw 178
	bump_4X dw 300
	bump_4Y dw 178
	dino_X dw 40
	dino_Y dw 140

	hurd_1X dw 250;250;200
	hurd_1Y dw 147;125
	hurd_1S dw 20;30

	hurd_2X dw 170
	hurd_2Y dw 145
	hurd_2S dw 17

	hurd_3X dw 230
	hurd_3Y dw 152
	hurd_3S dw 14

	heart_1X dw 15
	heart_1Y dw 5
	heart_2X dw 40
	heart_2Y dw 5
	heart_3X dw 65
	heart_3Y dw 5
    heart_4X dw 90
	heart_4Y dw 5
    

    LIFEC dw 3

	bird_1X dw 275
	bird_1Y dw 110

	bird_2X dw 300
	bird_2Y dw 110

    SUN_x dw 130
    SUN_y dw 50
    SUN_S dw 20

    boolc dw 0 ; 0 means not crouching 1 means crouching
    jumpc dw 0
    ground_X dw 0
    crouch dw 0
    
    score dw 0
    scoreSTR dw 5 DUP("0")
    hiScoreFile db "hi.txt", 0
    bufferHiScoreSTR db 24 DUP('$') 
    hiScoreSTR db 5 DUP("$")
    hiSCore dw ?
    timeSTR db 8 DUP('0')
    dateSTR db 10 DUP('0')
    year dw 0 
    month db 0 
    day db 0 
    hours db 0 
    minutes db 0
    seconds db 0
    defeatCheck dw 0
        
    gamestart dw  6
    GSTRT db "GAME STARTS IN ...",'$'

    GEND db "THANKS FOR PLAYING : )",'$'
    Gpause db "PAUSED" , '$' 
    DisBird dw 0
    RandArr dw  88,100,151,300,88,400,1000,1500,600,100
    index dw  0
    Birdbool dw 0

    HurdDelC dw 0
    RandHurd dw 30,40,20,10,89,60,50,40,20
    indHurd dw 0
    HurdBool dw 0

    restartSTR db "R-Restart!" , '$'
    tiredSTR db "T-Tired!" , '$'
    gameRestart db 0 

    dayNight dW 0
    counter dw 0
    maincounter dw 0
    MOON_x dw 80
    MOON_y dw 70
    Moon_S dw 20

	
.code
Main proc

	mov ax , @data
	mov ds , ax  

	instructionsReading
    
    mainMenu:   
		Menu 
		call mouseClickedMenu
		cmp ah, 0
		je playScreen
		cmp ah, 1 
		je instructScreen
		cmp ah, 2
		je exitScreen
		jmp errorMessage
	
	playScreen:
		call playMac
        mov al, gameRestart
        .IF al == 1
            mov dino_X, 40
            mov dino_Y, 140
            mov hurd_1X, 250
            mov hurd_1Y, 147
            mov hurd_1S, 20
            mov bump_1X , 0
            mov bump_1Y , 178
            mov bump_2X , 100
            mov bump_2Y , 178
            mov bump_3X , 200
            mov bump_3Y , 178
            mov bump_4X , 300
            mov bump_4Y , 178
            mov LIFEC, 3

            mov bird_1X , 275
	        mov bird_1Y , 110

            mov boolc, 0
            mov jumpc, 0
            mov ground_X, 0
            mov crouch, 0
            mov defeatCheck, 0
            mov DisBird, 0
            mov index, 0
            mov Birdbool, 0
            mov HurdDelC, 0
            mov indHurd, 0
            mov Hurdbool, 0
            mov gameRestart, 6
            mov score, 0
            mov cx, 5
            mov si, 0
            .WHILE cx > 0
                mov scoreSTR[si], "0"
                add si, 2 
                dec cx
            .ENDW
            jmp playScreen
        .ENDIF
        jmp exitScreen
	instructScreen:
		instructionsMac
		call mouseClickedInstructions
	jmp mainMenu
	errorMessage:
		SetCursor 20 , 5   ; SET POSITION OF CURSOR in order X and Y
		Stringout message ; OUTPUT STRING AT CURSOR
	jmp exitScreen
	
	exitScreen:
            setVideoMode
            SetBackground 23h
            SetCursor 160 , 30
            Stringout GEND
            ClrKeybuf
            mouseClick:
                mov al, 0
                mov ah, 01
                int 16h
                mov val, al
                mov x, 160
                mov y, 80
                mov ax , x
                mov bx , y
                mov dx , 5
                CALL drawHeart
                waitloop
                add y, 5
                mov ax , x
                mov bx , y
                mov dx , 4
                CALL drawHeart
                waitloop
                add y, 5
                mov ax , x
                mov bx , y
                mov dx , 3
                CALL drawHeart
                waitloop
                add y, 5 
                mov ax , x
                mov bx , y
                mov dx , 2
                CALL drawHeart
                waitloop
                add y, 5
                mov ax , x
                mov bx , y
                mov dx , 1
                CALL drawHeart
            mov al, val 
            .IF al != 13
                jmp mouseClick
            .ENDIF
        clearScreen
        mov ax, 0
		mov ah , 4ch
		int 21h
Main endp


playMac PROC
    pushALL
    setVideoMode ; y:22,
    call hiScoreReading
    infiniteLoop:
        mov ax, dayNight
        .IF ax < 200
            SetBackground 37H
            call Sunproc
        .ELSEIF ax < 401
            SetBackground 11h
            Call Moonproc
        .ELSEIF ax > 400
            mov dayNight, 1
            SetBackground 37H
        .ENDIF
        upperRow
        ;dojump
            .IF boolc == 2
                dojump 15
            .ENDIF
        ;Dino Drawing           
            mov ax, dino_X
            mov bx, dino_Y
            .IF boolc == 1 
                DrawDinC ax, bx
                inc crouch     
                mov boolc , 0                  
            .ELSE
                DrawDin ax, bx
            .ENDIF
        ;KeyBoard Interrupts
            .IF boolc == 0
                K_int
                .IF al == 's'  || al == 'c'
                    mov boolc , 1
                .ELSEIF al == 'w' || al == ' '
                    mov boolc , 2
                    
                .ELSEIF al == 'd'
                    
                    cmp dino_X , 100
                    JGE nodo
                    add dino_X , 2
                    nodo:
                .ELSEIF al == 'a' 
                    cmp dino_X , 40
                    JLE nodo1
                    sub dino_X , 2
                    nodo1:
                .ELSEIF al == 'p'
                    pushALL        
                    SetCursor 200 , 60 
                    Stringout Gpause
                    ClrKeybuf
                    mov ah, 0   
                    int 16h
                    popALL
                .ELSEIF al == 'q'
                    JMP playExit
                .ENDIF
            .ENDIF
            ClrKeybuf      
        ;Heart Drawing 
            CALL DisplayHeart ; for all hearts
        ; Hurdles Drawing
            pushALL 
            cmp HurdBool , 0
            JNE onlyDraw
            mov si , indHurd
            mov ax , RandHurd[si] 
            .IF HurdDelC == ax 
                mov Hurdbool , 1 ; show hrd
                mov HurdDelC , 0  ; hirdshow counter
                cmp indHurd , lengthof RandHurd
                JL Shakira
                inc indHurd
                inc indHurd
                Shakira:    
            .ENDIF
            inc HurdDelC              
            ;only use hurd1
            onlyDraw:
                cmp HurdBool ,0
                JE moveon
                mov ax , hurd_1X 
                mov bx , hurd_1Y
                mov cx , hurd_1S
                call Hurdproc
            moveon:    
            popALL
	    ;>>>>>>>>>>>>>>>>>>>>>>>>    
	    ; Birds Drawing 
            pushALL
            cmp Birdbool , 0
            JNE jumper
            mov si , index
            mov ax , RandArr[si] 
            .IF Disbird == ax 
                mov Birdbool , 1 ; show bird
                mov DisBird , 0  ; birdshow counter
                cmp index , lengthof RandArr
                JNL dono 
                inc index
                inc index    
                dono:
            .ENDIF   
            inc Disbird       
            jumper:
            popAll
            pushALL
            .IF Birdbool == 1
                mov si, bird_1X
                mov bx, bird_1Y
                mov dx, 2
                call drawBird
            .ENDIF
            popALL
        ;Lower Row Drawing    
            lowerRow
            call playBumps
            call drawGround
            waitloop
        ;Collosions
            mov ax, defeatCheck
            .IF ax == 0
                ;hurdle Collision
                cmp HurdBool , 0
                JE dontcheck
                call hurdleTouch
                dontcheck:

                ;>BIRD COLLISION
                cmp boolc , 1 
                JE go_on
                cmp Birdbool , 1
                JNE go_on
                call birdTouch
                go_on:

            .ELSEIF ax == 1
                mov defeatCheck, 2
            .ELSEIF ax == 2
                mov defeatCheck, 3
            .ELSEIF ax == 3
                mov defeatCheck, 4
            .ELSEIF ax == 4
                mov defeatCheck, 0
            .ENDIF
        ;Movements
            cmp Birdbool , 0
            JE nomov
            mov X, 5 ; bird speed
            call birdMovement
            nomov:
            mov X, 10 ; bump speed
            call bumpMovement
            cmp Hurdbool , 0
            JE wild
            mov X, 10 ; hurd speed
            call hurdleMovement 
            wild:            
        ;GameSatrt In Loop
            ;mov gamestart, 6
            .WHILE gamestart > 0
                dec gamestart
                mov ax , gamestart
                SetCursor 150 , 60 
                Stringout GSTRT
                SetCursor 170 , 60
                CALL DisplayNumber
                sec1
            .ENDW
        ;Other Movements    
            mov ax, ground_X
            sub ax, 20
            mov ground_X, ax
            mov ax, score
            inc ax 
            mov score, ax
            call hiscorecheck
            mov ax, dayNight
            inc ax
            mov dayNight, ax
            mov ax , LIFEC
            cmp ax, 0
    JL playExit
    JG infiniteLoop
    playExit:
    upperRow
    call DisplayHeart
    lowerRow
    call drawGround
    updateHiScore
    ClrKeybuf
    call exitPlay
    ClrKeybuf
    clearScreen
    
    popALL
	ret
playMac endp

birdTouch PROC
     pushALL
    mov ax, bird_1Y
    mov bx, bird_1Y
    add bx, 35

    mov dx, dino_Y
    .IF dx < bx
        .IF dx > ax
            JMP birdXCheck1
        .ENDIF
    .ENDIF
    continueBird:
    popALL
    ret
    birdXCheck1:
        pushALL
        mov ax, bird_1X
        sub ax, 15
        mov bx, bird_1X
        add bx, 40

        mov dx, dino_X
        sub dx, 30
        mov si, dino_X
        add dx, 20
        .IF si > ax 
            .IF si < bx
                ;call mouseClickedInstructions
                ;ClrKeybuf
                pushALL
                mov ax, LIFEC
                dec ax 
                mov LIFEC, ax
                mov defeatCheck, 1
                mov Birdbool, 0
                mov bird_1X, 270
                call Soundp
                popALL
            .ENDIF
        ;.ENDIF
        .ELSEIF dx < bx
            .IF dx > ax
                ;call mouseClickedInstructions
                ;ClrKeybuf
                pushALL
                mov ax, LIFEC
                dec ax 
                mov LIFEC, ax
                mov defeatCheck, 1
                mov Birdbool, 0
                mov bird_1X, 270
                call Soundp
                popALL
            .ENDIF
        .ENDIF
        popALL
    JMP continueBird
birdTouch endp 

hurdleTouch PROC
        pushALL
        mov dx, dino_X
        sub dx, 30
        mov si, dino_X
        add si, 20

        mov ax, hurd_1X
        sub ax, 10;12
        mov bx, hurd_1X
        add bx, 13;16
        ;Left to Right
        .IF ax < si
            .IF ax > dx
                JMP yAxisHurdle1
            .ENDIF
        ;.ENDIF
        ;right to Left
        .ELSEIF bx > si
            .IF bx < dx
                JMP yAxisHurdle1
            .ENDIF
        .ENDIF
        continueHURDLE:
        popALL
    ret
    yAxisHurdle1:
        
        pushALL
        mov ax, hurd_1Y
        mov bx, hurd_1Y
        add bx, hurd_1S
        add bx, hurd_1S

        mov dx, dino_Y
        mov si, dino_Y
        add si, 30
        ;Left to Right
        .IF dx > ax
            .IF dx < bx
                ;call mouseClickedInstructions
                ;ClrKeybuf
                pushALL
                mov ax, LIFEC
                dec ax 
                mov LIFEC, ax
                mov defeatCheck, 1
                mov HurdBool , 0
                mov hurd_1X , 290 
                call Soundp
                popALL
            .ENDIF
        ;.ENDIF
        ;right to Left
        .ELSEIF si > ax
            .IF si < bx
                ;call mouseClickedInstructions
                ;ClrKeybuf
                pushALL
                mov ax, LIFEC
                dec ax 
                mov LIFEC, ax
                mov defeatCheck, 1
                mov HurdBool , 0
                mov hurd_1X , 290
                call Soundp
                popALL
            .ENDIF
        .ENDIF
        popALL

    JMP continueHURDLE

hurdleTouch endp

hurdleMovement PROC
    pushALL
    mov ax, hurd_1X
   
    sub ax , x

    .IF ax < 10
        mov ax , 290
        mov HurdBool , 0
    .ENDIF    

    mov hurd_1X ,ax    
    popALL
    ret
hurdleMovement endp

drawBird PROC

    mov X, si
    mov Y, bx
    mov ax, si
        FOR birdl, <1,2> 
            drawPixBox2x2 ax, bx, 00h
            sub ax, dx
        endm 
    add bx, dx
    mov ax, si
        FOR birdl, <1,2,3> 
            drawPixBox2x2 ax, bx, 00h
            sub ax, dx
        endm
    add si, dx
    add si, dx
    add bx, dx
    mov ax, si
        FOR bordl, <1,2,3,4,5,6> 
            drawPixBox2x2 ax, bx, 00h
            sub ax, dx
        endm  
    add bx, dx
    mov ax, si
        FOR bordl, <1,2,3,4,5,6,7> 
            drawPixBox2x2 ax, bx, 00h
            sub ax, dx
        endm 
    add bx, dx
    mov ax, si
        FOR bordl, <1,2,3,4,5,6,7,8> 
            drawPixBox2x2 ax, bx, 00h
            sub ax, dx
        endm 
    add bx, dx
    add si, dx
    mov ax, si
        FOR bordl, <1,2,3,4,5,6,7,8,9,10> 
            drawPixBox2x2 ax, bx, 00h
            sub ax, dx
        endm 
    add bx, dx
    mov ax, si
        FOR bordl, <1,2> 
            drawPixBox2x2 ax, bx, 00h
            sub ax, dx
        endm 
    ;add si, dx
    add bx, dx
    mov ax, si
        FOR bordl, <1,2> 
            drawPixBox2x2 ax, bx, 00h
            add ax, dx
        endm 
    ;END
    sub bx, dx
    sub bx, dx
    add si, dx
    add si, dx
    mov ax, si
        FOR bordl, <1,2,3,4,5,6,7> 
            drawPixBox2x2 ax, bx, 00h
            add ax, dx
        endm 
    add bx, dx
    mov ax, si
        FOR bordl, <1,2,3,4,5,6,7,8> 
            drawPixBox2x2 ax, bx, 00h
            add ax, dx
        endm
    add bx, dx
    mov ax, si
        FOR bordl, <1,2,3,4,5,6,7,8,9,10,11,12,14,15,16,17> 
            drawPixBox2x2 ax, bx, 00h
            add ax, dx
        endm 
    add bx, dx
    mov ax, si
        FOR bordl, <1,2,3,4,5,6,7,8,9,10,11,12> 
            drawPixBox2x2 ax, bx, 00h
            add ax, dx
        endm
    add bx, dx
    mov ax, si
        FOR bordl, <1,2,3,4,5,6,7,8,9,10,11,12,13,14> 
            drawPixBox2x2 ax, bx, 00h
            add ax, dx
        endm

    add bx, dx
    mov ax, si
        FOR bordl, <1,2,3,4,5,6,7,8,9,10,11> 
            drawPixBox2x2 ax, bx, 00h
            add ax, dx
        endm
    add bx, dx
    mov ax, si
        FOR bordl, <1,2,3,4,5,6,7,8,9> 
            drawPixBox2x2 ax, bx, 00h
            add ax, dx
        endm
    add bx, dx
    mov ax, si
        FOR bordl, <1,2,3,4,5,6> 
            drawPixBox2x2 ax, bx, 00h
            add ax, dx
        endm
    add bx, dx
    mov ax, si
        FOR bordl, <1,2,3,4> 
            drawPixBox2x2 ax, bx, 00h
            add ax, dx
        endm
    add bx, dx
    mov ax, si
        FOR bordl, <1,2,3> 
            drawPixBox2x2 ax, bx, 00h
            add ax, dx
        endm
    add bx, dx
    mov ax, si
        FOR bordl, <1,2> 
            drawPixBox2x2 ax, bx, 00h
            add ax, dx
        endm
    add bx, dx
    mov ax, si
        FOR bordl, <1> 
            drawPixBox2x2 ax, bx, 00h
            add ax, dx
        endm
        FOR bordl, <1,2,3,4,5,6,7>
            sub si, dx
        endm
        FOR bordl, <1,2,3,4,5,6,7,8,9,10,11,12,13>
            sub bx, dx
        endm
    mov ax, si
    drawPixBox2x2 ax, bx, 07h
    
	ret
drawBird endp
drawHeart PROC
        drawPixBox2x2 ax, bx, 00h
        sub ax, dx
        sub bx, dx
        drawPixBox2x2 ax, bx, 00h
        sub ax, dx
        sub bx, dx
        drawPixBox2x2 ax, bx, 00h
        sub ax, dx
        drawPixBox2x2 ax, bx, 00h
        sub ax, dx
        drawPixBox2x2 ax, bx, 00h
        sub ax, dx
        drawPixBox2x2 ax, bx, 00h
        sub ax, dx
        add bx, dx
        drawPixBox2x2 ax, bx, 00h
        sub ax, dx
        add bx, dx
        drawPixBox2x2 ax, bx, 00h
        add bx, dx
        drawPixBox2x2 ax, bx, 00h
        add bx, dx
        drawPixBox2x2 ax, bx, 00h
        add bx, dx
        drawPixBox2x2 ax, bx, 00h
        add bx, dx
        drawPixBox2x2 ax, bx, 00h

        FOR heartl1, <1,2,3,4,5,6,7>
            add ax, dx
            add bx, dx
            drawPixBox2x2 ax, bx, 00h
        endm

        FOR heartl1, <1,2,3,4,5,6,7>
            add ax, dx
            sub bx, dx
            drawPixBox2x2 ax, bx, 00h
        endm

        sub bx, dx
        drawPixBox2x2 ax, bx, 00h
        sub bx, dx
        drawPixBox2x2 ax, bx, 00h
        sub bx, dx
        drawPixBox2x2 ax, bx, 00h
        sub bx, dx
        drawPixBox2x2 ax, bx, 00h
        sub ax, dx
        sub bx, dx
        drawPixBox2x2 ax, bx, 00h
        sub ax, dx
        sub bx, dx
        drawPixBox2x2 ax, bx, 00h
        sub ax, dx
        drawPixBox2x2 ax, bx, 00h
        sub ax, dx
        drawPixBox2x2 ax, bx, 00h
        sub ax, dx
        drawPixBox2x2 ax, bx, 00h
        add bx, dx
        sub ax, dx
        drawPixBox2x2 ax, bx, 00h

        ; Red Color
        FOR loopX, <1,2,3,4,5,6,7>
            sub ax, dx
        endm
        FOR looph, <1,2,3,4>
            add ax, dx
            drawPixBox2x2 ax, bx, 04h
        endm
        FOR loopX, <1,2,3>
            add ax, dx
        endm
        ;add ax, 12
        FOR looph, <1,2,3,4>
            add ax, dx
            drawPixBox2x2 ax, bx, 04h
        endm
        FOR loopX, <1,2,3,4,5,6,7,8,9,10,11,12>
            sub ax, dx
        endm
        ;sub ax, 48
        add bx, dx
        FOR looph, <1,2,3,4, 5, 6>
            add ax, dx
            drawPixBox2x2 ax, bx, 04h
        endm
        add ax, dx
        FOR looph, <1,2,3,4, 5, 6>
            add ax, dx
            drawPixBox2x2 ax, bx, 04h
        endm
        
        FOR loopOUT, <1,2,3,4>
            FOR loopX, <1,2,3,4,5,6,7,8,9,10,11,12,13>
                sub ax, dx
            endm
            ;sub ax, 52
            add bx, dx
            FOR loopIN, <1,2,3,4,5,6,7,8,9,10,11,12,13>
                add ax, dx
                drawPixBox2x2 ax, bx, 04h
            endm
        endm
        FOR loopX, <1,2,3,4,5,6,7,8,9,10,11,12>
            sub ax, dx
        endm
        ;sub ax, 48
        add bx, dx
        FOR looph, <1,2,3,4, 5, 6,7,8,9,10,11>
            add ax, dx
            drawPixBox2x2 ax, bx, 04h
        endm
        FOR loopX, <1,2,3,4,5,6,7,8,9,10>
            sub ax, dx
        endm
        ;sub ax, 40
        add bx, dx
        FOR looph, <1,2,3,4, 5, 6,7,8,9>
            add ax, dx
            drawPixBox2x2 ax, bx, 04h
        endm
        FOR loopX, <1,2,3,4,5,6,7,8>
            sub ax, dx
        endm
        ;sub ax, 32
        add bx, dx
        FOR looph, <1,2,3,4, 5, 6,7>
            add ax, dx
            drawPixBox2x2 ax, bx, 04h
        endm
        FOR loopX, <1,2,3,4,5,6>
            sub ax, dx
        endm
        ;sub ax, 24
        add bx, dx
        FOR looph, <1,2,3,4, 5>
            add ax, dx
            drawPixBox2x2 ax, bx, 04h
        endm
        FOR loopX, <1,2,3,4>
            sub ax, dx
        endm
        ;sub ax, 16
        add bx, dx
        FOR looph, <1,2,3>
            add ax, dx
            drawPixBox2x2 ax, bx, 04h
        endm
        sub ax , dx
        add bx, dx
        drawPixBox2x2 ax, bx, 04h
        FOR loopX, <1,2,3,4,5,6,7,8,9,10>
            sub bx, dx
        endm
        ;sub bx, 40
        FOR loopX, <1,2,3>
            sub ax, dx
        endm
        ;sub ax, 12
        drawPixBox2x2 ax, bx, 07h
        sub ax, dx
        drawPixBox2x2 ax, bx, 07h
        add bx, dx
        drawPixBox2x2 ax, bx, 07h
        sub ax, dx
        drawPixBox2x2 ax, bx, 07h
        add bx, dx
        drawPixBox2x2 ax, bx, 07h 
    ;popALL
    ret
drawHeart endp 

playBumps PROC
	pushALL
    
    mov si , bump_1X
    mov bx , bump_1Y
    CALL BumpP 
    
    
    mov si , bump_2X
    mov bx , bump_2Y
    CALL BumpP 
    
    mov si , bump_3X
    mov bx , bump_3Y
    CALL BumpP 
    
    mov si , bump_4X
    mov bx , bump_4Y
    CALL BumpP 
    
	popALL
	ret
playBumps endp


mouseClickedInstructions PROC
	pushALL
	mov ax, 01
	int 33h
	mouseClick:
		mov ax, 03
		int 33h
		CMP bx, 1
		JE mouseClicked
		mov al, 0
		mov ah, 01
		int 16h
		CMP al, 0
		JNE buttonPressed
	JMP mouseClick
	mouseClicked:
		mov ax, cx
		mov cl, 8
		div cl
		mov bh, al ; mouseX
		mov ax, dx
		mov cl, 8
		div cl
		mov bl, al ; mouseY
				;     Top  bottom   LEFT  RIGHT  SCROLL COLOR
		;DrawBox 19    , 21   ,  33 ,   41 ,   0 ,  10011111b
		cmp bh, 33
		jl mouseClick
		cmp bh, 41
		jg mouseClick
		cmp bl, 19
		jl mouseClick
		cmp bl, 21
		jg mouseClick
		popALL
		ret
	buttonPressed:
		cmp al, 13
		jne mouseClick
		mov ah, 08h
		int 21h
		popALL
		ret
mouseClickedInstructions endp
mouseClickedMenu PROC
	mov ax, 01
	int 33h
	mouseClick:
		mov ax, 03
		int 33h
		CMP bx, 1
		JE mouseClicked
        ;ClrKeybuf
		mov al, 0
		mov ah, 01
		int 16h
		CMP al, 0
		JNE buttonPressed
	JMP mouseClick
	mouseClicked:
		mov ax, cx
		mov cl, 8
		div cl
		mov bh, al ; mouseX
		mov ax, dx
		mov cl, 8
		div cl
		mov bl, al ; mouseY
	;Comparisons
	mov dl, 8
	cmp bl, dl
	jl mouseClick 
	mov dl, 10
	cmp bl, dl
	jle first
	mov dl, 13
	cmp bl, dl
	jle second
	mov dl, 16
	cmp bl, dl
	jle third
	jmp mouseClick 
	
	first:
		cmp bh, 36
		jl mouseClick 
		cmp bh, 41
		jg mouseClick 
	jmp firstPlay
	
	second:
		cmp bh, 32
		jl mouseClick 
		cmp bh, 45
		jg mouseClick 
		
	jmp secondInstruct
	
	third:
		mov dl , 36
		cmp bh, dl
		jl mouseClick 
		mov dl, 41
		cmp bh, dl
		jg mouseClick
	jmp thirdExit
	
	firstPlay:
		mov ah , 0
	ret
	secondInstruct:
		mov ah, 1
	ret
	thirdExit:
		mov ah, 2
	ret
    buttonPressed:
    .IF al == 'p' || al == 'P'
        mov ah, 0
    .ELSEIF al == 'i' || al == 'I'
        mov ah, 1
    .ELSEIF al == 'e' || al == 'E' 
        mov ah, 2
    .ELSE
        jmp mouseClick
    .ENDIF
    ClrKeybuf
    ret
mouseClickedMenu endp
bumpMovement PROC
    pushALL
    mov ax, bump_1X
    mov bx, bump_2X
    mov dx, bump_3X
    mov si, bump_4X
    sub ax, X
    sub bx, X
    sub dx, x
    sub si, x
    cmp ax, 10 
    jge carryOn
    mov ax, 310
    carryOn:
    cmp bx, 10
    jge carryOn1
    mov bx, 310
    carryOn1:
    cmp dx, 1 
    jge carryOn2
    mov dx, 300
    carryOn2:
    cmp si, 1
    jge carryOn3
    mov si, 300
    carryOn3:
    mov bump_1X, ax 
    mov bump_2X, bx
    mov bump_3X, dx
    mov bump_4X, si
    popALL
    ret
bumpMovement endp
birdMovement PROC 
    pushALL
    
    mov ax, bird_1X
    sub ax, X
    cmp ax, 10
    jge carryBM 
    mov ax, 270
    mov Birdbool , 0
    carryBM:
    mov bird_1X, ax 
    popALL
    ret
birdMovement endp 
drawGround PROC 
    pushALL
    mov si, 0
    mov bx, 184
    mov si, bx
    mov ax, ground_X
        cmp ax, 1
        jge carryGround
        mov ax, 300
        mov ground_X, 300
    carryGround:
    mov dx, 0
        .WHILE dx < 320
            drawPixBox2x2 ax, bx, 06h
            add bx , 8
            drawPixBox2x2 ax, bx, 06h
            add ax, 8
            add dx, 8
            sub bx, 10
            ;;;;;;;;;;;;;;;;;;;;
            drawPixBox2x2 ax, bx, 06h
            add bx, 8
            drawPixBox2x2 ax, bx, 06h
            add bx, 6
            drawPixBox2x2 ax, bx, 06h
            mov bx, si
            add ax, 8
            add dx, 8
        .ENDW
    popALL
    ret
drawGround endp

DisplayHeart proc
    pushALL

        cmp LIFEC , 1
        JE thrd
        cmp LIFEC , 2
        JE scnd
        cmp LIFEC , 3
        JE frst
        JNE lul 

        frst:
                    mov ax, heart_3X
                    mov bx, heart_3Y
                    mov dx, 1
                    call drawHeart
        scnd:    
                    mov ax, heart_2X
                    mov bx, heart_2Y
                    mov dx, 1
                    call drawHeart
        thrd:
                    mov ax, heart_1X
                    mov bx, heart_1Y
                    mov dx, 1
                    call drawHeart

        lul:
    popALL
    ret            
DisplayHeart endp




DisplayNumber PROC       
    MOV BX, 10     
    MOV DX, 0000H   
    MOV CX, 0000H    
    L1DD:  
    MOV DX, 0000H    
    div BX           
    PUSH DX         
    INC CX           
    CMP AX, 0       
    JNE L1DD           
    L2DD:  
    POP DX          
    ADD DX, 30H     
    MOV AH, 02H     
    INT 21H         
    LOOP L2DD   
    ret           
DisplayNumber  ENDP
hiScoreReading PROC 
    pushALL
    ; Opening the File
    mov dx, offset hiScoreFile
    mov al, 0
    mov ah, 3dh
    int 21H
    ; Extracting into bufferSTR
    mov bx, ax
    mov dx, offset bufferHiScoreSTR
    mov ah, 3fh
    int 21H
    ; Closing the File
    mov ah, 3eh
    int 21h

    mov cx, 5
    mov si, 0
    hiLoop:
        mov al, bufferHiScoreSTR[si]
        mov hiscoreSTR[si], al
        add si, 1
    loop hiLoop
    ;Hours 00:
    mov al, bufferHiScoreSTR[si]
    mov timeSTR[0], al
    inc si 
    mov al, bufferHiScoreSTR[si]
    mov timeSTR[1], al
    inc si
    mov al, bufferHiScoreSTR[si]
    mov timeSTR[2], al
    inc si 
    ;Minutes 00:
    mov al, bufferHiScoreSTR[si]
    mov timeSTR[3], al
    inc si 
    mov al, bufferHiScoreSTR[si]
    mov timeSTR[4], al
    inc si
    mov al, bufferHiScoreSTR[si]
    mov timeSTR[5], al
    inc si
    ;Seconds 00
    mov al, bufferHiScoreSTR[si]
    mov timeSTR[6], al
    inc si 
    mov al, bufferHiScoreSTR[si]
    mov timeSTR[7], al
    inc si
    ;Day 00-
    mov al, bufferHiScoreSTR[si]
    mov dateSTR[0], al
    inc si 
    mov al, bufferHiScoreSTR[si]
    mov dateSTR[1], al
    inc si
    mov al, bufferHiScoreSTR[si]
    mov dateSTR[2], al
    inc si
    ;Month 00-
    mov al, bufferHiScoreSTR[si]
    mov dateSTR[3], al
    inc si 
    mov al, bufferHiScoreSTR[si]
    mov dateSTR[4], al
    inc si
    mov al, bufferHiScoreSTR[si]
    mov dateSTR[5], al
    inc si
    ;Year 0000
    mov al, bufferHiScoreSTR[si]
    mov dateSTR[6], al
    inc si 
    mov al, bufferHiScoreSTR[si]
    mov dateSTR[7], al
    inc si 
    mov al, bufferHiScoreSTR[si]
    mov dateSTR[8], al
    inc si 
    mov al, bufferHiScoreSTR[si]
    mov dateSTR[9], al
    inc si
    call strtoint
    popALL
    ret
hiScoreReading endp  
intToSTR PROC
    pushALL
    mov ax, score       
    MOV BX, 10     
    MOV DX, 0000H   
    MOV CX, 0000H
    mov si, 8    
    L1DD:  
    MOV DX, 0000H    
    div BX  
    add dx, 30h
    mov scoreSTR[si], dx
    sub si, 2
    CMP AX, 0       
    JNE L1DD           
    popAll 
    ret        
intTOSTR  ENDP
intToSTRHI PROC
    pushALL
    mov ax, hiscore       
    MOV BX, 10     
    MOV DX, 0000H   
    MOV CX, 0000H
    mov si, 4    
    L1DD:  
    MOV DX, 0000H    
    div BX  
    add dx, 30h
    mov hiscoreSTR[si], dl
    sub si, 1
    CMP AX, 0       
    JNE L1DD           
    popAll 
    ret        
intTOSTRHI  ENDP

STRToint PROC 

    pushALL
    mov cx, 5
    mov si, 0
    mov hiSCore, 0
    L2:
        mov ax, hiSCore
        mov bx, 10
        mul bx
        mov dx, 0
        mov dl, hiScoreSTR[si]
        sub dx, 30h
        add ax, dx
        mov hiSCore, ax
        add si, 1 
    loop L2
    popAll
    ret
STRToint endp

exitPlay PROC 
    pushALL
    ;SetBackground 2Fh
        ;     Top  bottom   LEFT  RIGHT  SCROLL COLOR
    ;DrawBox 5    , 20   ,  10 ,   30 ,   0 ,  02h
    SetCursor 15,7 
    Stringout restartSTR
    SetCursor   16, 9
    Stringout tiredSTR
    push ax 
    push bx
        mov al , 13
        mov bl , 14
        call hiScoreOUTP 
    pop bx 
    pop ax
    dateTimeOut 15, 11
	mouseClick:
        ClrKeybuf
		mov al, 0
		mov ah, 01
		int 16h
		CMP al, 0
		JNE buttonPressed
	JMP mouseClick
	buttonPressed:
        .IF al == 'r' || al == 'R'
            mov gameRestart, 1
            jmp con 
        .ELSEIF al == 't' || al == 'T'
            mov gameRestart, 0
            jmp con
        .ELSEIF al == 13
            mov gameRestart, 0
            jmp con
        .ELSE
            jmp mouseClick
        .ENDIF
        con:
		mov ah, 08h
		int 21h
    popALL
    ret
exitPlay endp

Hurdproc proc
    pushALL
        mov hurd_1X , ax
        mov hurd_1Y , bx
        mov hurd_1S , cx
        
        DrawHurd1 hurd_1X , hurd_1Y , hurd_1S
    popALL
    ret
Hurdproc endp

PIXNEW proc
    pushAll
    ; 	 MOV Bl ,C
    ;    MOV CX, X
    ;    MOV DX, Y
    mov SI , CX
    FOR paramet1 , <1,2,3,4>
        FOR paramet2 ,<1,2,3,4>
            MOV AX , 0
            MOV Al, Bl 
            MOV ah, 0CH
            INT 10H
            INC CX		
        ENDM
        MOV CX, SI
        inc DX
    ENDM
    popALL
    ret
PIXNEW endp



PIXNEW2 proc
    pushAll
    ; 	 MOV Bl ,C
    ;    MOV CX, X
    ;    MOV DX, Y
    mov SI , CX
    FOR paramet1 , <1,2,3>
        FOR paramet2 ,<1,2,3>
            MOV AX , 0
            MOV Al, Bl 
            MOV ah, 0CH
            INT 10H
            INC CX		
        ENDM
        MOV CX, SI
        inc DX
    ENDM
    popALL
    ret
PIXNEW2 endp

hiScoreCheck PROC
    pushALL
    mov ax, hiscore 
    mov bx, score
    .IF bx > ax
        mov hiscore, bx
        call intToSTRTIME  
        call intToSTRDATE 
    .ENDIF
    popALL
    ret
hiscorecheck endp
intToSTRTIME PROC 
    ;pushALL
    mov ah, 2ch
    int 21H
    mov hours, ch 
    mov minutes, cl 
    mov seconds, dh
    mov cx, 8
    mov si, 0 
    .WHILE cx > 0
        mov timeSTR[si], '0'
        inc si 
        dec cx
    .ENDW
    ;Updating hours in timeSTR
        ;pushALL
        mov ax, 0
        mov al, hours       
        MOV BX, 10     
        MOV DX, 0000H   
        MOV CX, 0000H
        mov si, 1    
        L1DD1:  
        MOV DX, 0000H    
        div BX  
        add dx, 30h
        mov timeSTR[si], dl
        sub si, 1
        CMP AX, 0       
        JNE L1DD1           
        ;popAll
        mov timeSTR[2], ':'
    ;Updating minutes in timeSTR
        ;pushALL
        mov ax, 0
        mov al, minutes       
        MOV BX, 10     
        MOV DX, 0000H   
        MOV CX, 0000H
        mov si, 4    
        L1DD2:  
        MOV DX, 0000H    
        div BX  
        add dx, 30h
        mov timeSTR[si], dl
        sub si, 1
        CMP AX, 0       
        JNE L1DD2           
        ;popAll
        mov timeSTR[5], ':'
    ;Updating seconds in timeSTR
        ;pushALL
        mov ax, 0
        mov al, seconds       
        MOV BX, 10     
        MOV DX, 0000H   
        MOV CX, 0000H
        mov si, 7    
        L1DD3:  
        MOV DX, 0000H    
        div BX  
        add dx, 30h
        mov timeSTR[si], dl
        sub si, 1
        CMP AX, 0       
        JNE L1DD3           
        ;popAll
    ;popALL 
    ret        
intToSTRTIME  ENDP
intToSTRDATE PROC 
    ;pushALL
    mov ah, 2ah
    int 21H
    mov year, cx 
    mov month, dh 
    mov day, dl
    mov cx, 10
    mov si, 0 
    .WHILE cx > 0
        mov dateSTR[si], '0'
        inc si 
        dec cx
    .ENDW
    ;Updating DAy in DAteSTR
        ;pushALL
        mov ax, 0
        mov al, day       
        MOV BX, 10     
        MOV DX, 0000H   
        MOV CX, 0000H
        mov si, 1    
        L1DD1:  
        MOV DX, 0000H    
        div BX  
        add dx, 30h
        mov dateSTR[si], dl
        sub si, 1
        CMP AX, 0       
        JNE L1DD1           
        ;popAll
        mov dateSTR[2], '-'
    ;Updating months in DateSTR
        ;pushALL
        mov ax, 0
        mov al, month       
        MOV BX, 10     
        MOV DX, 0000H   
        MOV CX, 0000H
        mov si, 4    
        L1DD2:  
        MOV DX, 0000H    
        div BX  
        add dx, 30h
        mov dateSTR[si], dl
        sub si, 1
        CMP AX, 0       
        JNE L1DD2           
        ;popAll
        mov dateSTR[5], '-'
    ;Updating year in DAteSTR
        ;pushALL
        mov ax, year       
        MOV BX, 10     
        MOV DX, 0000H   
        MOV CX, 0000H
        mov si, 9    
        L1DD3:  
        MOV DX, 0000H    
        div BX  
        add dx, 30h
        mov dateSTR[si], dl
        sub si, 1
        CMP AX, 0       
        JNE L1DD3           
        ;popAll
    ;popALL 
    ret        
intToSTRDATE  ENDP

Soundp proc  
    pushALL
    mov dx , 30
    mov bx , 70
    MOV     AL, 1001001B;10110110B    
    OUT     43H, AL          
    NEXT_FREQUENCY:          
    MOV     AX, BX           
    OUT     42H, AL          
    MOV     AL, AH             
    OUT     42H, AL          
    IN      AL, 61H          
    OR      AL, 00000011B    
    OUT     61H, AL          
    waitloop
    INC     BX               
    DEC     DX               
    CMP     DX, 0            
    JNE     NEXT_FREQUENCY   
    IN      AL,61H           
    AND     AL,11111100B     
    OUT     61H,AL 
    popall
    ret 
Soundp endp


BumpP proc
    pushALL
    mov dx, 2
    mov ax, si
    ;Boundary
    drawPixBox2x2 ax, bx, 0eh

    sub bx, dx
    add ax, dx
    drawPixBox2x2 ax, bx, 0eh
    add ax, dx
    drawPixBox2x2 ax, bx, 0eh

    sub bx, dx
    add ax, dx
    drawPixBox2x2 ax, bx, 0eh
    add ax, dx
    drawPixBox2x2 ax, bx, 0eh

    sub bx, dx
    add ax, dx
    drawPixBox2x2 ax, bx, 0eh
    add ax, dx
    drawPixBox2x2 ax, bx, 0eh
    add ax, dx
    drawPixBox2x2 ax, bx, 0eh
    add ax, dx
    drawPixBox2x2 ax, bx, 0eh

    add bx, dx
    add ax, dx
    drawPixBox2x2 ax, bx, 0eh
    add ax, dx
    drawPixBox2x2 ax, bx, 0eh

    add bx, dx
    add ax, dx
    drawPixBox2x2 ax, bx, 0eh
    add ax, dx
    drawPixBox2x2 ax, bx, 0eh

    add bx, dx
    add ax, dx
    drawPixBox2x2 ax, bx, 0eh
    ;Inner 
    mov ax, si
        FOR bumploop, <1,2,3,4,5,6,7,8,9,10,11,12>
            add ax, dx
            drawPixBox2x2 ax, bx, 0eh
        endm
    sub bx, dx
    add si, dx
    add si, dx
    mov ax, si
        FOR bumploop, <1,2,3,4,5,6,7,8>
            add ax, dx
            drawPixBox2x2 ax, bx, 0eh
        endm
    sub bx, dx
    add si, dx
    add si, dx
    mov ax, si
        FOR bumploop, <1,2,3,4>
            add ax, dx
            drawPixBox2x2 ax, bx, 0eh
        endm
    popALL
ret
BumpP endp

hiScoreOUTP proc 
    pushALL
    call intToSTR
    call intToSTRHI
    SetCursor al, bl
    stringOutPix 'H'
    inc al
    SetCursor al, bl
    stringOutPix 'I'
    inc al
    inc al
    SetCursor al, bl
    stringOutPixB hiScoreSTR[0]
    inc al
    SetCursor al, bl
    stringOutPixB hiScoreSTR[1]
    inc al
    SetCursor al, bl
    stringOutPixB hiScoreSTR[2]
    inc al
    SetCursor al, bl
    stringOutPixB hiScoreSTR[3]
    inc al
    SetCursor al, bl
    stringOutPixB hiScoreSTR[4]
    inc al
    inc al

    SetCursor al, bl
    stringOutPix scoreSTR[0]
    inc al
    SetCursor al, bl
    stringOutPix scoreSTR[2]
    inc al
    SetCursor al, bl
    stringOutPix scoreSTR[4]
    inc al
    SetCursor al, bl
    stringOutPix scoreSTR[6]
    inc al
    SetCursor al, bl
    stringOutPix scoreSTR[8]
    popALL   
ret    
hiScoreOUTP endp

Sunproc proc
	pushALL
	mov cx,SUN_x
	mov dx, SUN_y
	mov bl,0EH
	mov counter,5
	.WHILE counter > 0
              dec counter
		call PIXNEW2
		add cx,3
	.ENDW

	mov bl,0DH
	mov counter,3
	.WHILE counter > 0
              dec counter
		call PIXNEW2
		add cx,3
	.ENDW
	mov bl,0EH
	mov counter,5
	.WHILE counter > 0
              dec counter
		call PIXNEW2
		add cx,3
	.ENDW


	mov cx,SUN_x
	mov dx, SUN_y
	mov bl,0EH
	sub dx,3
	mov counter,5
	.WHILE counter > 0
              dec counter
		call PIXNEW2
		add cx,3
	.ENDW

	mov bl,0DH
	mov counter,3
	.WHILE counter > 0
              dec counter
		call PIXNEW2
		add cx,3
	.ENDW
	mov bl,0EH
	mov counter,5
	.WHILE counter > 0
              dec counter
		call PIXNEW2
		add cx,3
	.ENDW
	 
   ;
   mov cx,SUN_x
	mov dx, SUN_y
	mov bl,0EH


	sub dx,6
	mov counter,13
	.WHILE counter > 0
                dec counter
                call PIXNEW2
				add cx,3
            .ENDW
	mov cx,SUN_x
	mov dx, SUN_y
	mov bl,0EH

	sub dx,9
	add cx,3
	mov counter,3
	.WHILE counter > 0
                dec counter
                call PIXNEW2
				add cx,3
            .ENDW
	mov counter,2
	.WHILE counter > 0
                dec counter
                mov bl,0FH
				call PIXNEW2
				add cx,3
				call PIXNEW2
				mov bl,0H
				call PIXNEW2
				add cx,3
				call PIXNEW2
				MOV BL,0EH
				call PIXNEW2
				add cx,3
	.ENDW
	mov counter,2
	.WHILE counter > 0
                dec counter
                call PIXNEW2
				add cx,3
            .ENDW

	;;;;;

			mov cx,SUN_x
	mov dx, SUN_y
	mov bl,0EH
			sub dx,12
	add cx,3
	mov counter,3
	.WHILE counter > 0
                dec counter
                call PIXNEW2
				add cx,3
            .ENDW
	mov counter,2
	.WHILE counter > 0
		dec counter
		mov bl,0FH
		call PIXNEW2
		add cx,3
		call PIXNEW2
		mov bl,0H
		call PIXNEW2
		add cx,3
		call PIXNEW2
		MOV BL,0EH
		call PIXNEW2
		add cx,3
	.ENDW
	mov counter,2
	.WHILE counter > 0
                dec counter
                call PIXNEW2
				add cx,3
            .ENDW
	;;;;
	mov cx,SUN_x
	mov dx, SUN_y
	mov bl,0EH
	sub dx,15
	add cx,6
	mov counter,2
	.WHILE counter > 0
		dec counter
		call PIXNEW2
		add cx,3
		.ENDW
	mov bl,0FH
	mov counter,2
	.WHILE counter > 0
		dec counter
		call PIXNEW2
		add cx,3
		.ENDW
	mov bl,0EH
	call PIXNEW2
	add cx,3
	mov bl,0FH
	mov counter,2
	.WHILE counter > 0
		dec counter
		call PIXNEW2
		add cx,3
		.ENDW
	mov bl,0EH
	call PIXNEW2
	ADD cx,3
	call PIXNEW2

	;;;;;;

	mov cx,SUN_x
	mov dx, SUN_y
	mov bl,0EH
	sub dx,18
	add cx,12
	mov counter,5
	.WHILE counter > 0
		dec counter
		call PIXNEW2
		add cx,3
		.ENDW

		;;;;
		mov cx,SUN_x
	mov dx, SUN_y
	mov bl,0EH
	add dx,3
	mov counter,4
	.WHILE counter > 0
		dec counter
		call PIXNEW2
		add cx,3
	.ENDW
	mov bl,00H
	call PIXNEW2
	add cx,3
	mov bl,0EH
	mov counter,3
	.WHILE counter > 0
		dec counter
		call PIXNEW2
		add cx,3
		.ENDW
	mov bl,00H
	call PIXNEW2
	add cx,3
	mov bl,0EH
	mov counter,4
	.WHILE counter > 0
		dec counter
		call PIXNEW2
		add cx,3
	.ENDW

	;;;;;;
	mov cx,SUN_x
	mov dx, SUN_y
	mov bl,0EH
	add dx,6
	mov counter,5
	.WHILE counter > 0
		dec counter
		call PIXNEW2
		add cx,3
	.ENDW
	mov bl,00H
	mov counter,3
	.WHILE counter > 0
		dec counter
		call PIXNEW2
		add cx,3
	.ENDW
	mov bl,0EH
	mov counter,5
	.WHILE counter > 0
		dec counter
		call PIXNEW2
		add cx,3
	.ENDW

	;;;;
	mov cx,SUN_x
	mov dx, SUN_y
	mov bl,0EH
	add dx,9
	add cx,3
	mov counter,11
	.WHILE counter > 0
		dec counter
		call PIXNEW2
		add cx,3
	.ENDW
	;;;;
	mov cx,SUN_x
	mov dx, SUN_y
	mov bl,0EH
	add dx,12
	add cx,3
	mov counter,11
	.WHILE counter > 0
		dec counter
		call PIXNEW2
		add cx,3
	.ENDW

	;;;;;
	mov cx,SUN_x
	mov dx, SUN_y
	mov bl,0EH
	add dx,15
	add cx,6
	mov counter,9
	.WHILE counter > 0
		dec counter
		call PIXNEW2
		add cx,3
	.ENDW
	;;;;
	mov cx,SUN_x
	mov dx, SUN_y
	mov bl,0EH
	add dx,18
	add cx,12
	mov counter,5
	.WHILE counter > 0
		dec counter
		call PIXNEW2
		add cx,3
	.ENDW

	;;; arrows for sun

	mov cx,SUN_x
	mov dx, SUN_y
	mov bl,0EH
	add cx,18
	sub dx, 24
	mov counter,6
	.WHILE counter > 0
		dec counter
		call PIXNEW2
		sub dx,3
	.ENDW
	;;;
	mov cx,SUN_x
	mov dx, SUN_y
	mov bl,0EH
	add cx,18
	add dx, 24
	mov counter,6
	.WHILE counter > 0
		dec counter
		call PIXNEW2
		add dx,3
	.ENDW
	;;;;

	mov cx,SUN_x
	mov dx, SUN_y
	mov bl,0EH
	sub cx,6
	mov counter,6
	.WHILE counter > 0
		dec counter
		call PIXNEW2
		sub cx,3
	.ENDW
	;;;;;

	mov cx,SUN_x
	mov dx, SUN_y
	mov bl,0EH
	add cx,42
	mov counter,6
	.WHILE counter > 0
		dec counter
		call PIXNEW2
		add cx,3
	.ENDW
	;;;

	mov cx,SUN_x
	mov dx, SUN_y
	mov bl,0EH
	add cx,39
	sub dx,21
	mov counter,4
	.WHILE counter > 0
		dec counter
		call PIXNEW2
		add cx,3
		sub dx,3
	.ENDW
	;;;;
	mov cx,SUN_x
	mov dx, SUN_y
	mov bl,0EH
	add cx,39
	add dx,21
	mov counter,4
	.WHILE counter > 0
		dec counter
		call PIXNEW2
		add cx,3
		add dx,3
	.ENDW
	;;;
	mov cx,SUN_x
	mov dx, SUN_y
	mov bl,0EH
	sub cx,3
	sub dx,21
	mov counter,4
	.WHILE counter > 0
		dec counter
		call PIXNEW2
		sub cx,3
		sub dx,3
	.ENDW
	;;;;;
	mov cx,SUN_x
	mov dx, SUN_y
	mov bl,0EH
	sub cx,3
	add dx,21
	mov counter,4
	.WHILE counter > 0
		dec counter
		call PIXNEW2
		sub cx,3
		add dx,3
	.ENDW


	popALL
ret
Sunproc endp

Moonproc proc
	pushAll
	mov cx,MOON_x
	mov dx, MOON_y
	mov bl,0FH
	mov maincounter,5
	.WHILE maincounter > 0
		dec maincounter
		mov counter,13
			.WHILE counter > 0
				dec counter
				call PIXNEW2
				add cx,3
			.ENDW
			sub dx,3
			mov cx,MOON_x
	.ENDW
	;;;;
	mov cx,MOON_x
	mov dx, MOON_y
	sub dx,15
	add cx,3
	mov maincounter,2
	.WHILE maincounter > 0
		dec maincounter
		mov counter,11
			.WHILE counter > 0
				dec counter
				call PIXNEW2
				add cx,3
			.ENDW
			sub dx,3
			mov cx,MOON_x
			add cx,3
	.ENDW
	;;;
	
	mov cx,MOON_x
	mov dx, MOON_y
	add cx,6
	sub dx,21
	mov counter,9
	.WHILE counter > 0
		dec counter
		call PIXNEW2
		add cx,3
	.ENDW
	;;
	mov cx,MOON_x
	mov dx, MOON_y
	add cx,12
	sub dx,24
	mov counter,5
	.WHILE counter > 0
		dec counter
		call PIXNEW2
		add cx,3
	.ENDW

	;;;
	mov cx,MOON_x
	mov dx, MOON_y
	add cx,3
	add dx,3
	mov maincounter,2
	.WHILE maincounter > 0
		dec maincounter
		mov counter,11
			.WHILE counter > 0
				dec counter
				call PIXNEW2
				add cx,3
			.ENDW
			add dx,3
			mov cx,MOON_x
			add cx,3
	.ENDW
	;;
	mov cx,MOON_x
	mov dx, MOON_y
	add cx,6
	add dx,9
	mov counter,9
	.WHILE counter > 0
		dec counter
		call PIXNEW2
		add cx,3
	.ENDW
	;;;;
	mov cx,MOON_x
	mov dx, MOON_y
	add cx,12
	add dx,12
	mov counter,5
	.WHILE counter > 0
		dec counter
		call PIXNEW2
		add cx,3
	.ENDW
popALL
ret
Moonproc endp
end main

