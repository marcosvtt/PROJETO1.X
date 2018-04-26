;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*        Projeto 1 V1.0 Microcomputadores - automação de caixa dagua								*
;*																									*
;*																									*
;*      DESENVOLVIDO PELO GRUPO:																	*
;*   => Beatrice Azoubel Michalewicz																			*
;*   => Marcos Vinicius Torres Teixeira																				*
;*																									*
;*      VERSÃO: 1.0                             DATA: 26/04/2018									*
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
;*                      DESCRIÇÃO DO ARQUIVOS														*
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*																									* 
;* COMENTÁRIOS E DESCRIÇÃO DO PROBLEMA PROPOSTO:													*
;* MODELO DE PROGRAMA PARA OS ALUNOS DE MICROCOMPUTADORES											*
;*																									*                                                                                                          
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 


;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
;*                     ARQUIVOS DE DEFINIÇÕES														*
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 

#INCLUDE <P16F628A.INC>		;ARQUIVO PADRÃO MICROCHIP PARA 16F628A
 __CONFIG _BOREN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _LVP_OFF & _MCLRE_ON


#DEFINE BANK0	BCF STATUS,RP0		;SETA BANK 0 DE MEMÓRIA
#DEFINE BANK1	BSF STATUS,RP0		;SETA BANK 1 DE MEMÓRIA

#DEFINE THAB 	INTCON, TOIE		;HABILITA A INTERRUPÇÃO DO TIMER
#DEFINE	TFLAG	INTCON,	T0IF		;FLAG DE ESTOURO DO TIMER
#DEFINE	PFLAG	INTCON,	INTF		;FLAG  DE INTERRUPÇÃO EM RB0


DELAY_1S	EQU		.246

	 CBLOCK 0x0C

 		ESTADO	;VARIAVEL DE ESTADO

 	ENDC

 #DEFINE ESTADO_BOMBA		ESTADO,1
 #DEFINE ESTADO_VALVULA		ESTADO,2


 #DEFINE I_SENSOR_RUA			PORTB,1		;1= COM FLUXO
 #DEFINE I_SENSOR_CXDAGUA		PORTB,2		;1= CHEIA
 #DEFINE I_SENSOR_CISTERNA		PORTB,3		;1= CHEIA

 #DEFINE O_VALVULA				PORTA,1
 #DEFINE O_BOMBA				PORTA,2

 	ORG 0x00
 	GOTO	INICIO


INICIO
	BANK1

	MOVLW	B'00000000'
	MOVWF	TRISA

	MOVLW	B'11111111'
	MOVWF	TRISB

	MOVLW	B'10000001'
	MOVWF	OPTION_REG

	MOVLF	B'10100000'
	MOVWF	INTCON

	BANK0

	CLRF	PORTA
	CLRF	PORTB
	CLRF	TMR0
	CLRF	ESTADO_BOMBA
	CLRF	ESTADO_VALVULA

	GOTO 	MAIN

DELAY					  	;ROTINA DE 1 SEGUNDOS 
    CLRF    TMR0			;
 	BCF 	TFLAG			;LIMPA O FLAG DE ESTOURO DE CONTAGEM DO TIMER0
	MOVLW 	DELAY_1S  		;MOVE O VALOR DE DELAY DE 1 SEG PARA W
	MOVWF 	TMR0		   	;MOVE O VALOR DE DELAY DE 1 SEG PARA TMR0
DELAY1	
	BTFSS 	TFLAG		    ;A CONTAGEM DE 1 SEGUNDO TERMINOU?
	GOTO 	DELAY1	    	;NÃO, VOLTA PARA ESPERAR
	RETURN


MAIN
	BTFSS	I_SENSOR_CISTERNA	;CISTERNA CHEIA?
	CALL	CHECA_VALVULA		;NAO
	BTFSC	I_SENSOR_CISTERNA	;
	CALL	DESATIVA_VALVULA	;SIM
								;NADA

	BTFSS	I_SENSOR_CXDAGUA	;CAIXA DAGUA CHEIA?
	CALL	ATIVA_BOMBA			;NAO
	BTFSC	I_SENSOR_CXDAGUA	;
	CALL	DESATIVA_BOMBA	;SIM
								;NADA
	GOTO	MAIN


CHECA_VALVULA
	MOVLW	.1

	BTFSS	I_SENSOR_RUA
	SUBWF	PCL,F
	CALL 	ABRE_VALVULTIVA
	RETURN

ATIVA_BOMBA
	BTFSS	ESTADO_BOMBA
	PULSO_BOMBA
	;
	RETURN

DESATIVA_BOMBA
	BTFCS	ESTADO_BOMBA
	PULSO_BOMBA
	;
	RETURN

ATIVA_VALVULA
	BTFSS	ESTADO_VALVULA
	PULSO_VALVULA
	;
	RETURN

DESATIVA_VALVULA
	BTFSS	ESTADO_VALVULA
	PULSO_VALVULA
	;
	RETURN

PULSO_BOMBA
	BSF		O_BOMBA
	DELAY
	BCF		O_BOMBA
	BTFCS		ESTADO_BOMBA
	BCF 		ESTADO_BOMBA
	BTFSS		ESTADO_BOMBA
	BSF 		ESTADO_BOMBA
	;
	RETURN


PULSO_VALVULA
	BSF		O_VALVULA
	DELAY
	BCF		O_VALVULA
	BTFCS		ESTADO_VALVULA
	BCF 		ESTADO_VALVULA
	BTFSS		ESTADO_VALVULA
	BSF 		ESTADO_VALVULA
	;
	RETURN