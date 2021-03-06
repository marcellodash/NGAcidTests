    ORG $0
    dc.l $10F300		; Initial SP
    dc.l $C00402		; Initial PC
    dc.l $C00408, $C0040E, $C00414, ErrDivZero	; Bus error, Address error, Illegal Instruction, Divide by 0
    dc.l ErrCHK, ErrTRAPV, $C0041A, $C00420		; CHK, TRAPV ,Privilege Violation, Trace
    dc.l ErrLineA, ErrLineF, $C00426, $C00426	; Emu, Emu, Reserved, Reserved
    dc.l $C00426, $C0042C, $C00426, $C00426		; Reserved, Reserved, Reserved, Reserved
    dc.l $C00426, $C00426, $C00426, $C00426		; Reserved, Reserved, Reserved, Reserved
    dc.l $C00426, $C00426, $C00432, VBI			; Reserved, Reserved, Spurious Interrupt, Vertical blank
    dc.l TMRI, IRQ3, ErrG, ErrG					; Timer interrupt, Cold boot interrupt
    dc.l ErrG, ErrG, ErrG, ErrG					; Auto, Auto, Trap 0, Trap1...
    dc.l ErrG, ErrG, ErrG, ErrG
    dc.l $FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF
    dc.l $FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF
    dc.l $FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF
    dc.l $FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF
    dc.l $FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF
    dc.l $FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF
    dc.l $FFFFFFFF,$FFFFFFFF

    ORG $0100
    dc.b "NEO-GEO", $00

    dc.w $0029			; NGH (Legend of Success Joe, because nobody wants that)
    dc.l $00020000      ; P1 size (128KiB)
    dc.l $0010F000		; Pointer to debug DIPs (none)
    dc.w $0001			; No save (0 is not allowed ?)

    ORG $0114
    dc.w $0200			; No eye-catcher, sprite bank number ignored
    dc.l SoftDIPs		; JP
    dc.l SoftDIPs		; US
    dc.l SoftDIPs		; EU

    ORG $0122
	jmp User
    ORG $0128
	jmp _rt				; Player_start
    ORG $012E
	jmp _rt				; Demo_end
    ORG $0134
	jmp _rt				; Coin_sound

    ORG $0182
	dc.l SCode			; Pointer to security code

SCode:
	dc.l $76004A6D, $0A146600, $003C206D, $0A043E2D
	dc.l $0A0813C0, $00300001, $32100C01, $00FF671A
	dc.l $30280002, $B02D0ACE, $66103028, $0004B02D
	dc.l $0ACF6606, $B22D0AD0, $67085088, $51CFFFD4
	dc.l $36074E75, $206D0A04, $3E2D0A08, $3210E049
	dc.l $0C0100FF, $671A3010, $B02D0ACE, $66123028
	dc.l $0002E048, $B02D0ACF, $6606B22D, $0AD06708
	dc.l $588851CF, $FFD83607
	dc.w $4E75

SoftDIPs:
    dc.b "NEOGEO LAG TEST "		; Title
    dc.w $FFFF, $FFFF			; Special options
	dc.b $FF, $FF
    dc.b $00					; Simple options
	dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00

ErrG:
	rte
	
ErrDivZero:
ErrCHK:
ErrTRAPV:
ErrLineA:
ErrLineF:
    rts

jt_user:
	dc.l   Init			; Start-up init
	dc.l   _rt			; Eye-catcher
	dc.l   Start        ; Game/demo
	dc.l   _rt			; Title display

User:
    move.b  d0,REG_DIPSW
    move.b  BIOS_USER_REQUEST,d0
    andi.b  #3,d0
    lsl.w   #2,d0
    lea     jt_user,a0
    movea.l (a0,d0),a0
    jsr     (a0)
    jmp     BIOSF_SYSTEM_RETURN

_rt:
	rts

Init:
	move.w  #1337,$10F000		; Backup RAM init
	rts
