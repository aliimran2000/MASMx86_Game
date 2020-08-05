pushALL macro 
    push ax
    push bx
    push cx
    push dx
    push si
endm
popALL macro
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
endm
setVideoMode macro 
    pushALL
    mov ah, 0
    mov al, 13h
    int 10h 
    popALL 
endm
SetBackground macro P1
    ; Background
    mov ah, 06h
    mov al, 0
    mov cx, 0
    mov dh, 80
    mov dl, 80 
    mov bh, P1
    int 10h 
endm
drawPixel macro X, Y, C 
    pushALL
    mov ah, 0ch
    mov al, C
    mov cx, X
    mov dx, Y
    int 10h
    popALL
endm
SetCursor macro X,Y 
    pushALL
    mov dx, 0
    mov bh , 00h
    mov ah,02h
    mov dh , Y  ;y
    add dl,  X   ;x
    INT 10h
    popALL
endm
DrawBox macro   T , B , L , R , S , C
    mov ah,06h   ;CONSTANT VALUE FOR OUTPUT
    mov ch,T    ;top 
    mov dh,B    ;bottom 
    mov cl,L     ;left
    mov dl,R     ;right
    mov al,S   ;lines to scroll     
    mov bh,C   ; color is HEX VALUE
    int 10H      ; interupt
endm

Stringout macro P1
    pushALL
    mov dx , 0
    mov dx , offset P1
    mov ah , 09h
    int 21h
    popALL
endm
stringOutPix macro C 
    pushALL
        mov ax, C
        mov bh, 00h 
        mov bl, 07h 
        mov cx, 1
        mov ah, 0ah
        int 10h
    popALL
endm
stringOutPixB macro C 
    pushALL
        mov al, C
        mov bh, 00h 
        mov bl, 07h 
        mov cx, 1
        mov ah, 0ah
        int 10h
    popALL
endm

; Menu Macro returns the Clicked menu in ah
; ah = 0 for Play
; ah = 1 for Instructions
; ah = 2 for Exit
Menu macro 
    ;SetBackground 00001111b
    
    SetBackground 3Fh
    PixHorP 0 , 10 , 300 , 00h
    ;     Top  bottom   LEFT  RIGHT  SCROLL COLOR
    ;DrawBox 8    , 10   ,  36 ,   41 ,   0 ,  10011111b ; Actual Boundary for Mouse Interrupt
    DrawBox 8    , 10   ,  32 ,   45 ,   0 ,  0Fh
    SetCursor 37, 9
    Stringout playStr
    DrawBox 11    , 13   ,  32 ,   45 ,   0 ,  0Fh
    SetCursor 33, 12
    Stringout instructionStr

    ;DrawBox 14    , 16   ,  36 ,   41 ,   0 ,  00011111b ; Acutual Boundary For Mouse Interrupt
    DrawBox 14    , 16   ,  32 ,   45 ,   0 ,  00011111b
    SetCursor 37, 15
    Stringout exitSTR
endm

instructionsMac macro 
    ;SetBackground 00001111b
    SetBackground 2F
        ;     Top  bottom   LEFT  RIGHT  SCROLL COLOR
    DrawBox 7    , 15   ,  10 ,   68 ,   0 ,  00011111b
    SetCursor 9, 8
    Stringout instructionsBuffer1
    Stringout instructionsBuffer2
        ;     Top  bottom   LEFT  RIGHT  SCROLL COLOR
    DrawBox 19    , 21   ,  33 ,   41 ,   0 ,  10011111b
    SetCursor   35, 20
    Stringout enterSTR
endm

instructionsReading macro 
    ; Opening the File
    mov dx, offset file
    mov al, 0
    mov ah, 3dh
    int 21H
    ; Extracting into bufferSTR
    mov bx, ax
    mov dx, offset instructionsBuffer1
    mov ah, 3fh
    int 21H
    mov dx, offset instructionsBuffer2
    mov ah, 3fh
    int 21H
    ; Closing the File
    mov ah, 3eh
    int 21h
endm

updateHiScore macro 
    pushALL
    ; Opening the File
    mov dx, offset hiScoreFile
    mov al, 2
    mov ah, 3dh
    int 21H
    mov bx, ax
    ;Output to File
    mov cx, sizeof hiScoreSTR
	mov dx, offset hiScoreSTR
	mov ah, 40h 
	int 21h
    mov cx, sizeof timeSTR
	mov dx, offset timeSTR
	mov ah, 40h 
	int 21h
    mov cx, sizeof dateSTR
	mov dx, offset dateSTR
	mov ah, 40h 
	int 21h
    ; Closing the File
    mov ah, 3eh
    int 21h
    popALL
endm

clearScreen macro 
    pushALL
    ;SetBackground 0bh
    mov al, 03
    mov ah, 0
    int 10h
    popALL
endm

drawPixBox macro X, Y, C
    pushALL
    mov cx, X 
    mov dx, Y
    mov bl, C
        FOR pixlopp, <1,2,3,4>
            ; Row 1

            drawPixel cx, dx, bl
            inc cx
            drawPixel cx, dx, bl
            inc cx
            drawPixel cx, dx, bl
            inc cx
            drawPixel cx, dx, bl
            inc cx
            
            ;end
            mov cx, X
            inc dx
        endm
    
    popALL
endm

drawPixBox2x2 macro X, Y, C
    pushALL
    mov cx, X 
    mov dx, Y
    mov bl, C
        FOR pixlopp, <1,2>
            ; Row 1
            drawPixel cx, dx, bl
            inc cx
            drawPixel cx, dx, bl
            inc cx
            ;end
            mov cx, X
            inc dx
        endm
    
    popALL
endm

PixBox macro X,Y ,C
    pushAll
    MOV CX, X
    MOV DX, Y

    FOR par1 , <1,2>

        FOR par2 ,<1,2>
            mov ax , 0
            MOV al, C 
            MOV ah, 0CH
            INT 10H
            inc CX      
        ENDM

        MOV CX, X
        inc DX
    ENDM
    
    popALL
endm





PixBox4 macro X,Y ,C
    pushAll
        
        MOV CX, X
        MOV DX, Y
        FOR para , <1,2,3,4>
            FOR parb ,<1,2,3,4>
                mov ax , 0
                MOV al, C 
                MOV ah, 0CH
                INT 10H
                inc CX      
            ENDM
            MOV CX, X
            inc DX
        ENDM
    popALL
endm

PixVer macro X , Y , S , C
   pushALL
    mov bx , Y
    mov si , S
    .while SI > 0
        PixBox X , BX , C
        add BX , 2  
        dec si
    .ENDW
    popALL
endm


PixVerP macro X , Y , S , C
   pushALL
    mov dx , Y
    mov si , S

    .while SI > 0
        
        pushAll
        mov CX , X
        mov bl , C
        Call PIXNEW
        popALL   
        add dX , 2

    dec si
    .ENDW
    popALL
endm

PixHorP macro X,Y , S , C
   pushAll
    mov cx , X
    mov si , S
    .while SI > 0
        
        pushAll
        mov DX , Y
        mov bl , C
        Call PIXNEW
        popALL
        
        add CX , 2  
        dec si
    .ENDW
    popALL
endm

PixHor macro X,Y , S , C
   pushAll
    mov bx , X
    mov si , S
    .while SI > 0
        PixBox BX , Y , C
        add BX , 2  
        dec si
    .ENDW
    popALL
endm

DrawDin macro A , B
    mov X , A
    Mov Y , B
    sub Y , 3
    PixHor X , Y , 8 , 04h
    sub X , 1
    add Y , 2
    PixHor X , Y , 9 , 04h
    add Y , 2
    PixHor X , Y , 3 , 04h
    add X , 5
    ;eye;
    PixHor X , Y , 2 , 0Eh
    add X , 3
    PixHor X , Y , 6 , 04h
    add Y , 2
    sub X , 8
    PixHor X , Y , 10 , 04h
    add Y , 2
    PixHor X , Y , 4 , 04h
    add Y , 2
    PixHor X , Y , 8 , 04h
    sub X , 2
    add Y , 2
    PixHor X , Y , 4 , 04h
    sub X , 2
    add Y , 2
    PixHor X , Y , 5 , 04h
    sub X , 2
    add Y , 2
    PixHor X , Y , 6 , 04h
    sub X , 2
    add Y , 2
    PixHor X , Y , 7 , 04h
    sub X , 2
    add Y , 2
    PixHor X , Y , 11 , 04h
    sub X , 2
    add Y , 2
    PixHor X , Y , 9 , 04h
    sub X , 2
    add Y , 2
    PixHor X , Y , 8 , 04h
    sub X , 2
    add Y , 2
    PixHor X , Y , 9 , 04h
    add Y , 2
    PixHor X , Y , 8 , 04h
    add Y , 2
    PixHor X , Y , 8 , 04h;>>>>>>>>>>>>>
    add X , 2
    PixVer X , Y , 7 , 04h;>>>>>>>>>>
    add X , 2
    PixVer X , Y , 3 , 04h
    add Y ,10
    PixHor X , Y , 1 , 04h
    add X, 8
    PixHor X , Y , 2 , 04h   
    sub X,8
    sub Y,10
    add X , 5
    PixVer X , Y , 4 , 04h
    add X , 2
    PixVer X , Y , 5 , 04h
    sub Y , 6
    sub X , 11
    PixVer X , Y , 4 , 04h
    ;sub Y , 4  
    sub X , 2
    FORC para, <POP>
        PixVer X , Y , 4 , 04h
        sub Y , 4   
        sub X , 2
        PixVer X , Y , 4 , 04h
    ENDM
    PixVer X , Y , 4 , 04h
        sub Y , 2   
        sub X , 2
        PixVer X , Y , 3 , 04h
        
    PixVer X , Y , 4 , 04h
        sub Y , 2   
        sub X , 2
        PixVer X , Y , 2 , 04h

    ;Collosion check 
    ;mov X, A
    ;mov Y, B 
    ;drawPixBox2x2 X, Y, 02h
    ;mov ax, y
    ;add ax, 38
    ;mov y, ax       
    ;drawPixBox2x2 X, Y, 02h
    ;mov ax, y
    ;sub ax, 38 
    ;sub ax, 3
    ;mov y, ax 
    ;drawPixBox2x2 X, Y, 02h 
endm

DrawDinC macro A , B
    mov X , A
    Mov Y , B
    add Y , 8
    PixHor X , Y , 8 , 04h
    sub X , 1
    add Y , 2
    PixHor X , Y , 9 , 04h
    add Y , 2
    PixHor X , Y , 3 , 04h
    add X , 5
    ;eye;
    PixHor X , Y , 2 , 0Eh
    add X , 3
    PixHor X , Y , 6 , 04h
    add Y , 2
    sub X , 8
    PixHor X , Y , 10 , 04h
    add Y , 2
    PixHor X , Y , 4 , 04h
    add Y , 2
    PixHor X , Y , 8 , 04h
    sub X , 2
    add Y , 2
    PixHor X , Y , 4 , 04h
    sub  X , 1   
    add Y ,1
    PixHor X , Y , 5 , 04h
    add Y ,1
    PixHor X , Y , 5 , 04h
    add Y , 2
    PixHor X , Y , 5 , 04h
    add Y , 2
    PixHor X , Y , 4 , 04h
    add Y , 2
    PixHor X , Y , 3 , 04h
    drawPixBox2x2 X , Y , 04h
    add X , 2
    drawPixBox2x2 X , Y , 04h
    add X , 1
    add Y , 2
    drawPixBox2x2 X , Y , 04h
    add X , 1
    add Y , 2
    drawPixBox2x2 X , Y , 04h
    add X , 2
    add Y , 2
    drawPixBox2x2 X , Y , 04h
    sub X , 1
    sub Y , 2
    drawPixBox2x2 X , Y , 04h
    sub Y , 12
    sub X , 7
    PixVer X , Y , 5 , 04h
    sub X , 2
    PixVer X , Y , 6 , 04h
    sub X , 2
    add Y , 1
    PixVer X , Y , 6 , 04h
    sub X , 2
    add Y , 1
    PixVer X , Y , 6 , 04h
    sub X , 2
    add Y , 1
    PixVer X , Y , 5 , 04h
     sub X , 2
     add Y , 1
    PixVer X , Y , 5 , 04h
     sub X , 2
     add Y , 1
    PixVer X , Y , 5 , 04h
    sub X , 2
    add Y , 1
    PixVer X , Y , 4 , 04h
    sub X , 2
    add Y , 1
    PixVer X , Y , 3 , 04h
    sub X , 2
    add Y , 1
    PixVer X , Y , 2 , 04h
    sub X , 2
    sub Y , 1
    PixVer X , Y , 2 , 04h
    sub X , 2
    sub Y , 1
    PixVer X , Y , 2 , 04h
    sub X , 2
    sub Y , 1
    PixVer X , Y , 2 , 04h
    sub X , 1
    sub Y , 1
    drawPixBox2x2 X , Y , 07h
    add Y , 8
    add X , 15
    drawPixBox2x2 X , Y , 04h
    PixVer X , Y , 3 , 04h
    sub X , 2
    add Y , 2
    PixVer X , Y , 3 , 04h
        sub Y , 2
    add X , 5
    PixVer X , Y , 3 , 04h
    add X , 2
    PixVer X , Y ,  4, 04h
endm


DrawHurd1 macro X ,Y , C    
    pushALL
    mov ax , X
    mov bx , Y
    mov cx , C
      PixVer X , Y , C, 02Eh   
    add X , 2 
    PixVer X , Y , C, 02Eh 
    add X , 2 
    PixVer X , Y , C, 02Eh   
    add X , 2 
    add Y , 2
    sub C , 1
    PixVer X , Y , C, 02Eh 
    sub X , 8
    PixVer X , Y , C, 02Eh   
    sub X , 2
    add Y , 16
    PixVer X , Y , 1, 02Eh   
    sub X , 6
    ;PixVer X , Y , 2, A   
    PixHor X , Y , 5, 02Eh 
    sub Y , 2
    sub X , 2
    PixHor X , Y , 5, 02Eh 
    sub Y , 2
    PixHor X , Y , 4, 02Eh 
    sub Y , 2
    PixHor X , Y , 4, 02Eh 
    sub Y , 2
    PixHor X , Y , 4, 02Eh 
    sub Y , 2
    PixHor X , Y , 4, 02Eh 
    add X , 2
    sub Y , 2
    PixHor X , Y , 2, 02Eh
    add X , 18
    add Y , 18
    PixHor X , Y , 4, 02Eh
    sub Y , 2
    add X , 2
    PixHor X , Y , 4, 02Eh
    sub Y , 2
    PixHor X , Y , 4, 02Eh
    sub Y , 2
    PixHor X , Y , 4, 02Eh
    sub Y , 2
    PixHor X , Y , 4, 02Eh
    sub Y , 2
    PixHor X , Y , 4, 02Eh
    add X , 2
    sub Y , 2
    PixHor X , Y , 2, 02Eh

    mov X , ax
    mov Y , bx
    mov C , cx
    popALL
endm

dateTimeOUT macro X, Y 
    pushALL
    mov al, X 
    mov bl, Y
    add al, 1
    ;Time 
    mov cx, 8
    mov si, 0
    .WHILE cx > 0
        SetCursor al, bl
        stringOutPixB timeSTR[si]
        inc al
        inc si 
        dec cx
    .ENDW
    
    ;Date 
    mov al, x
    add bl, 1
    mov cx, 10
    mov si, 0
    .WHILE cx > 0
        SetCursor al, bl
        stringOutPixB dateSTR[si]
        inc al
        inc si 
        dec cx
    .ENDW
    popALL
endm

upperRow macro 
    pushALL
    mov si, 0
    mov bx, 0
        .WHILE bx <= 20
            mov ax, si
            .WHILE ax < 320
                drawPixBox ax, bx, 0Ch
                add ax, 4
            .ENDW
            add bx, 4
        .ENDW

    push ax
    push bx
    mov al ,23
    mov bl ,1    
    Call hiScoreOUTP 
    pop bx
    pop ax
    popALL
endm


lowerRow macro 
    pushALL
    mov si, 0
    mov bx, 180
        .WHILE bx <= 200
            mov ax, si
            .WHILE ax < 320
                drawPixBox ax, bx, 2ch
                add ax, 4
            .ENDW
            add bx, 4
        .ENDW

    popALL
endm

Sec1 macro
    pushALL
    mov cx  , 0Fh
    mov dx  , 4240h
    mov ah  , 86h
    int 15h
    popALL
endm

waitloop macro
    pushALL
    mov cx  , 00h
    mov dx  , 9C40h
    mov ah  , 86h
    int 15h
    popALL
endm

ClrKeybuf macro
    pushAll
    mov ah ,0cH
    mov al ,0
    int 21h
    popALL
endm

dojump macro Hyt
    .IF jumpc <= 4
        sub dino_Y , Hyt
        inc jumpc
    .ELSEIF jumpc > 4 && jumpc < 10
        add dino_Y , Hyt
        inc jumpc    
    .ELSE
        mov jumpc , 0
        mov boolc , 0
    .ENDIF

endm

K_int macro
    mov ax, 0
    mov ah, 01h
    int 16h           
endm











