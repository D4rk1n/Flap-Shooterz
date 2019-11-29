include p1m.inc 
include barrier.inc
include shoot.inc
.model small
.stack
.data
plen   equ  20      ; height and width of player
slen	equ 4
swid	equ 8
p1x    dw   0      ; left upper corner
p1y    dw   2
m1x    dw   0       ; right bottom corner
m1y    dw   0
p1cl   db   09h     ; p1 body color
p1cd   db   01h     ; p1 link color
s1x	dw 0h	;p1 shoot x
s1y	dw 0h	;p1 shoot y

Pipx dw 0
seed db 0
Gap dw 0
Running db  0h
Tunnel dw   0h
TunnelSize dw 24


.code
main proc far
    mov ax,@data
    mov ds,ax
    ; change graphics mode
    mov ah,0
    mov al,13h
    int 10h

    mov Pipx ,100
	getrandom Gap seed

    mov Running, 1

	;------------------
	;MainMenuLoop
	;------------------
GameLoop:

    ; Clear
    Call Clear
	; Get Input
    Call GetInput
    ; Update
	Call Update
    ; Draw
    Call Draw
    ; Delay
    Call Delay
	; UI
	;Call UI
    cmp Running, 1
    je GameLoop


    ;------------------
	;GameOverLoop
	;------------------

	mov ah, 4ch
	int 21h

main endp


;------Clear Screen-----
Clear proc
    ClearP1 p1x, p1y, plen, m1x , m1y ; Clear Player1
	DeletePipe Pipx ,Gap
    cmp s1x, 0
    je noclear
    shoot s1x, s1y, slen, swid, 0h
noclear:
    ret
Clear endp
;-----------------------

;------Get Input-----
GetInput proc
    mov ah, 1
    int 16h   ; Get Key Pressed
    jz Return ; If no Key Pressed Return

    ; Key Pressed
    cmp ah, 48h     ; IF UP ARROW MOVE UP
    je MoveUp

    cmp ah, 50h     ; IF DOWN ARROW MOVE DOWN
    je MoveDown

    cmp ah, 39h
    je P1Shoot

    mov Running, 0  ; Else Exit
    jmp Return
    ;------------

MoveUp:
    cmp Tunnel, 0
    je Return
    DEC Tunnel
    jmp Return

MoveDown:
    cmp Tunnel, 5
    je Return
    INC Tunnel
    jmp Return
P1Shoot:
    cmp s1x, 0
    jne Return
    mov ax, p1x
    add ax, plen
    mov s1x, ax
    mov ax, p1y
    add ax, plen / 2 - slen / 2
    mov s1y, ax

Return:
    ; Flush Keyboard Buffer
    mov ah,0ch
    mov al,0
    int 21h
    ret
GetInput endp
;-----------------------

;------Draw Function----
Draw proc
    DrawPipe Pipx , Gap
	; Draw Player 1
    DrawP1 p1x, p1y, plen, m1x , m1y , p1cl , p1cd
    cmp s1x, 0
    jnz DrawShoot ; to avoid jmp out of range
    jmp noshoot ;we factor the jumping into two jumps
DrawShoot:
    mov bp, swid / 4
    add s1x, 3 * swid / 4
    shoot s1x, s1y, slen, bp, 0Bh ;right most layer
    sub s1x, swid / 4
    shoot s1x, s1y, slen, bp, 04h ;middle layer
    mov bp, swid / 2
    sub s1x, swid / 2
    shoot s1x, s1y, slen, bp, 0fh ;left most layer
noshoot:
    ret

Draw endp
;-----------------------

;------Delay Function----
Delay proc
    mov ah, 86h        ;  1/10 second
    mov cx, 1h
    mov dx, 86A0h
    int 15h
    ret

Delay endp
;---------------------
;----Update Function--
Update proc

    cmp s1x, 0 ;check if there's a shoot
    jz noupdate
    add s1x, 4 ;move the shoot
    mov si, s1x
    cmp s1x, 320 ;if we reached to the end of screen
    jb noupdate
    mov s1x, 0
noupdate:
    ; UPDATE PLAYER
    mov ax, Tunnel    ; TUNNEL ==> POSITION
    mul TunnelSize
    mov p1y, ax
	mov ax , TunnelSize
	sub ax , plen
	shr ax , 1b
    ADD p1y, ax        ; PLAYER POS Aligned with the tunnel
    ;--------------

    ; GENERATE PIP
    dec Pipx          ; TODO CHANGE SPEED LATER
    cmp Pipx,-1
	jnz nowrap
	mov Pipx,159	  ; Center of Screen
	getrandom Gap seed
	;------------

	nowrap:
	; CHECK IF PLAYER HIT THE PIP
	; is the spaceship inside the tunnel or not in x axis
	;mov ax ,Pipx
	;cmp ax,20
	;jg complete
	;is the spaceship inside the tunnel or not in y axis
    ;mov ax, p1y
	;sub ax,Gap
	;alaways the different bettwen the gap and the spaceship y is 2
	;cmp ax,2
	;jz complete
	;mov Running ,0     ; Exit
	;-------------------------

	complete:
	ret
Update endp
;-----------------------
end main
