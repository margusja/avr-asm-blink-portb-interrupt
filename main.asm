;
; AssemblerApplication1.asm
;
; MCU: Atmega328p
; Blink PORTB using TIMER0 overflow interrupt
.org 0x0020 ; Timer0 OVF
	jmp interupt1

main:
	SER R16 ; set all bits to high
	OUT DDRB, R16 ; set PORTB as output
	;OUT PORTB,R16

	LDI R21, 10 ; Count Timer0 overflows

	; set the ISR OVERFLOW vector
	CLR R16 ; Clear all bits in R16
	LDI R16, (1<<TOIE0) ; toggle TOIE0 to high and put it into R16
	STS TIMSK0, R16 ; load R16 to TIMSK0

	; set prescaling 1024
	CLR R16
	SBR R16, 5 ; Store 00001001 to R16
	OUT TCCR0B, R16

	SEI ; SET global interrupts

main_loop:
	CP R20, R21
		BRSH blink ; Branch if R21 >= R20
	jmp main_loop

blink:
	CLR R20
	; change led status
	IN R17, PORTB ; Read PORTB to F17
	LDI R16, 255 ; Load 11111111 to R16
	EOR R17, R16 ; DO XOR between R17 and R16 put result into R17
	OUT PORTB, R17 ; Put result from R17 to PORTB
	jmp main_loop

interupt1:
	INC R20 ; increase R20 + 1
  	RETI

