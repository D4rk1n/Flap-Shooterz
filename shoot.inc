;-------------------------------------------------
DrawShoot MACRO sxpos, sypos, color1, color2, color3
local colcount1, Continue1, colcount2,Continue2, colcount3, Continue3

mov cx, sxpos  ;col
mov dx, sypos  ;row
mov ah, 0ch ; put pixel
mov al, color1
mov si, sxpos
mov di, sypos
add si, swidquart
add si, swidquart
add di, slen
mov bp, cx

colcount1:
cmp cx, 320
jge Continue1
int 10h
inc cx
cmp cx, si
JNE colcount1
Continue1:
mov cx, bp  ; reset to start of col
inc dx      ;next row
cmp dx, di
JNE colcount1

mov cx, si
add si, swidquart
mov al, color2
mov dx, sypos
mov bp, cx


colcount2:
cmp cx, 320
jge Continue2
int 10h
inc cx
cmp cx, si
JNE colcount2
Continue2:
mov cx, bp  ; reset to start of col
inc dx      ;next row
cmp dx, di
JNE colcount2

mov cx, si
add si, swidquart
mov al, color3
mov dx, sypos
mov bp, cx

colcount3:
cmp cx, 320
jge Continue3
int 10h
inc cx
cmp cx, si
JNE colcount3
Continue3:
mov cx, bp  ; reset to start of col
inc dx      ;next row
cmp dx, di
JNE colcount3
ENDM DrawShoot
;-------------------------------------------------
;-------------------------------------------------
MoveShoot MACRO sx, ScreenWidth
    LOCAL noupdate
    ;check if there's a shoot
    cmp sx, 0
    jz noupdate
    add sx, 4 ;move the shoot

    ;if we reached to the end of screen
    cmp sx, ScreenWidth
    jb noupdate
    mov sx, 0 ;sx == 0 means there's no shoot
noupdate:

ENDM MoveShoot
;-------------------------------------------------
