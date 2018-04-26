;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*        Projeto 1 V1.0 Microcomputadores - automação de caixa dagua								*
;*																									*
;*																									*
;*      DESENVOLVIDO PELO GRUPO:																	*
;*   => Beatrice Azoubel Michalewicz																			*
;*   => Marcos Torres																				*
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


 #DEFINE BANK0	BCF STATUS,RP0
 #DEFINE BANK1	BSF STATUS,RP0


	 CBLOCK 0x0C

 		ESTADO_VALVULA
 		ESTADO_BOMBA

 	ENDC

 #DEFINE 


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


MAIN
	BTFSS	I_SENSOR_CISTERNA	;CISTERNA CHEIA?
	CALL	CHECA_VALVULA		;NAO
	BTFSC	I_SENSOR_CISTERNA	;
	CALL	FECHA_VALVULA		;SIM
								;NADA

	BTFSS	I_SENSOR_CXDAGUA	;CAIXA DAGUA CHEIA?
	CALL	ATIVA_BOMBA			;NAO
	;


CHECA_VALVULA
	MOVLW	.1

	BTFSS	I_SENSOR_RUA
	SUBWF	PCL,F
	CALL 	ABRE_VALVULA



ATIVA_BOMBA
	BTFSS	ESTADO_BOMBA

	;
ABRE_VALVULA
	








