;Final Fantasy V: Dress Code

hirom


!tempram_char = $1f10 	;might be the top of
						; stack, should never be hit
!jobtable = $f9ff00
org $c03ded ;cmp #$4b
			;bcc $27
;A = character to load
jml loadmap ;save dest to  
			;$0b23-$0b25
			;and the rest gets handled for us.

;map sprite loader:
org $c01d70 ;toad fix
db $0f		;increase branch length by 1 to hit our second JML
org $c01d7b ;mini fix
db $04		;increase branch length by 1 to hit our second JML

org $c01d7c
jml loadleader ;lda $0ada (load map leader sprite)
jml abortloadleader ;move the mini/toad branches here.
nop
nop
nop
nop
nop
nop


org $f9F000 ;39F000 in prg
loadmap:	;loads a number of sprites for each map.
cmp #$4b
bcs doreplacemap
bra abortloadmap

abortloadmap:
jml $C03E18

doreplacemap: ;a=char sprite load
sec
sbc #$4b
pha
php
phx
phy

dec ;character sprite loads are offset by 2
dec ;bartz's index in character data is "0"
	;but in sprite loads is after Toad and Mini
sta !tempram_char
ldy #$0004 ;number of loops to do (check all 4 character slots)
ldx #$0000 ;character data bank selection
charcheckloop:
	lda $0500,x 		;character data is stored in #$50 byte chunks
	and #$07			;filter out extra set bits (hidden/not, front/back row, etc)
	cmp !tempram_char	;and byte 0 is "character"
	beq ischar
	txa
	clc
	adc #$50			;check next slot
	tax
	dey					;once you've checked 4 slots, exit.
	cpy #$0000
	bne charcheckloop
bra notchar

ischar:
nop
nop						;leaving room to hook for the moogle suit patch
nop						
lda $501,x				;byte 1 is "job"
;sta !tempram_Job       ;may not be needed
clc						;3 byte pointers in job table
asl						;x2
adc $501,x				;+1  total of x3, same as our pointers.
tax
lda !jobtable,x			
sta $0b25				; $XX____ of the three byte pointer for DMA
rep #$20 ;16 bit mode
inx
lda !jobtable,x
sep #$10
ldy !tempram_char
rep #$10
beq skip_charselect_loop ;if bartz nothing needs to be added
charselect_loop:		;load $800 bytes farther in per character.
clc
adc #$0800
dey
bne charselect_loop
skip_charselect_loop:
sta $0b23				; $__XXXX of the three byte pointer for DMA
; exit into DMA routine?
ply
plx
plp
pla
jml $c03e00
notchar: ;need to exit gracefully, execute native code.
ply
plx
plp
pla
jml $c03df4







loadleader: ;loads the characterin topmost slot. 
			;used for walking around.
LDA $0ADA ;native code
cmp #$07 ;up to krile
bcs abortloadleader ;if higher than krile, abort!
cmp #$02
bcc abortloadleader ;if lower than bartz, abort!
jmp doreplaceleader

notcharleader:
lda $0ADA
abortloadleader:
  ASL
  TAX
  REP #$20
  LDA $C01E02,X
  STA $4302
jml $C01D8A

doreplaceleader: ;a=char sprite load
dec ;character sprite loads are offset by 2
dec ;bartz's index in character data is "0"
	;but in sprite loads is after Toad and Mini
sta !tempram_char
ldy #$0004 ;number of loops to do (check all 4 character slots)
ldx #$0000 ;character data bank selection
charcheckloopleader:
	lda $0500,x 		;character data is stored in #$50 byte chunks
	and #$07			;filter out extra set bits (hidden/not, front/back row, etc)
	cmp !tempram_char	;and byte 0 is "character"
	beq ischarleader
	txa
	clc
	adc #$50			;check next slot
	tax
	dey					;once you've checked 4 slots, exit.
	cpy #$0000
	bne charcheckloopleader
bra notcharleader

ischarleader:
nop
nop						;leaving room to hook for the moogle suit patch
nop						
lda $501,x				;byte 1 is "job"
clc						;3 byte pointers in job table
asl						;x2
adc $501,x				;+1  total of x3, same as our pointers.
tax
lda !jobtable,x			
sta $4304				; $XX____ of the three byte pointer for DMA
rep #$20 ;16 bit mode
inx
lda !jobtable,x
sep #$10
ldy !tempram_char
rep #$10
beq skip_charselect_loopleader
charselect_loopleader:
clc
adc #$0800
dey
bne charselect_loopleader
skip_charselect_loopleader:
sta $4302				; $__XXXX of the three byte pointer for DMA
jml $c01d8a



org $f9ff00
jobtable: ;3 bytes per entry. DATABANK|Address format eg $112233 is $11,$33,$22
;knight
db $F9,$00,$00 ;390000
;monk
db $F9,$00,$28 ;392800
;thief
db $F9,$00,$50 ;395000
;dragoon
db $F9,$00,$78 ;397800
;ninja
db $F9,$00,$A0 ;39A000
;samurai
db $F9,$00,$C8 ;39C800

;berserker
db $FA,$00,$00
;ranger
db $FA,$00,$28
;mystic knight
db $FA,$00,$50
;white mage
db $FA,$00,$78
;black mage
db $FA,$00,$A0
;time mage
db $FA,$00,$C8

;summoner
db $FB,$00,$00
;blue mage
db $FB,$00,$28
;red mage
db $FB,$00,$50
;beastmaster
db $FB,$00,$78
;chemist
db $FB,$00,$A0
;geomancer
db $FB,$00,$C8

;bard
db $FC,$00,$00
;dancer
db $FC,$00,$28
;mimic
db $FC,$00,$50

;freelancer
db $DA,$00,$D8

;00= mini
;01= frog
;
;02= bartz
;03= lenna
;04= galuf
;05= faris
;06= krile
;
;07=boko
;08=moogle

;$800+$800+$800+$800+$800 = one job $2800 (10240)
;split by job:
;00=knight
;01=monk
;02=thief
;03=dragoon
;04=ninja
;05=samurai
;06=berserker
;07=ranger
;08=mystic
;09=whitemage
;0a=blackmage
;0b=timemage
;0c=summoner
;0d=bluemage
;0e=redmage
;0f=beastmaster
;10=chemist
;11=geomancer
;12=bard
;13=dancer
;14=mimic
;15=freelancer

;character information is located in
;Char: 500 550 5A0 5F0
;char data needs to be filtered. lowest 3 bytes filters well
;0=bartz
;1=lenna
;2=galuf
;3=faris
;4=krile? (its a bit weird)

;palette located at $1ffc00 in PRG rom

;sprite loader DMA:
;c04cbc
;source written to:
;$0b25 $0b24 $0b23
;amount written to:
;$0b2c (ignore, always 200)