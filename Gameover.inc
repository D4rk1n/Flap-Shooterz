writewinner macro playercolor1,playercolor2,lives1,lives2,p1name,p2name,drawresult
  LOCAL print, win2,draw,finish
    ;delete all drawn objects
	mov ah,0
    mov al,13h
    int 10h
	; move cursor
	;decied who wins
    cmp lives1,0
    jz win2
    mov bp, offset p1name
	mov bl,playercolor1
    jmp print
    win2:
	cmp lives2,0
	jz draw

    mov bp, offset p2name
	mov bl,playercolor2

	print:

    mov al, 1
    mov bh, 0
    mov dl, 35
    sub dl, ds:[bp]
    shr dl, 1
    mov dh, 12
    mov cl, ds:[bp]
    mov ch, 0
    push ds
    pop es
    inc bp
    mov ah, 13h
    int 10h

    add dl, cl

    mov cx, 6
    lea bp, winstr
    int 10h
    jmp finish

    draw:
	mov bp,offset drawresult
	mov bl,0Fh

    mov al, 1
    mov bh, 0
    mov cx, 13
    mov dl, 14
    mov dh, 12
    push ds
    pop es
    mov ah, 13h
    int 10h

finish:
endm  writewinner
;=======================================
;=======================================
WriteGameoverUI macro currentoption,option1,optionssize
 local uiloop,printoptions,nopress,press,white

	;print options
	;get input
	mov ah,1
    int 16h
    jz nopress
    cmp ah,048h
    jz up
    cmp ah,050h
    jz down
    jmp press
    up:
    dec currentoption
    jns press
	mov ax,optionssize
	dec ax
    mov currentoption,ax
    jmp press
    down:
    inc currentoption
    jmp press
    press:
	;flush keyboard buffer
    mov ah,0ch
    mov al,0
    int 21h
	;mod to wrap
    mov ax,currentoption
    mov dx,optionssize
    div dl
    mov al,0
    xchg al,ah
    mov currentoption,ax
    nopress:
	;init for int 10h
    mov dh, 15;row
	mov bh,0 ;Page 0
    mov cx,optionssize;loop to print option
    mov bp,offset option1
    mov si,offset option1;to change cx because [bp]==ss:bp
    push ds;to make es equal to ds
    pop es;int 10h es:bp
    printoptions:
    push cx
    mov bl,8h
    mov ax,optionssize
    sub ax, currentoption
    cmp ax,cx
	jnz white
	mov bl,0fh
	white:
    mov al, 1
    mov cx, [si]
    mov ch,0
    inc si
    add si,cx
    inc bp
	;set cursor to middel of screen
    mov dl,40
	sub dl,cl
	shr dl,1
	mov ah, 13h
    int 10h
	;increas bp for the upcoming message
	add bp,cx
	dec dl
	mov ah, 2
	int 10h
	add dh,2;new line/row
	pop cx
    loop printoptions
endm WriteGameoverUI
