.data 1FFFh
db 0Ah ;;tamanho do vetor

.org 0000h
ei
jump:jmp jump

.org 003Ch

mvi a,0Ah
sta 1FFFh


lxi h,1009h 
push h ;;---- carregando pilha com a ultima posicao do vetor

;---------- armazenando as entradas nas memorias
mvi a,00h
in 00
sta 2000h
in 01
sta 2001h
in 02
sta 2002h
in 03
sta 2003h
in 04
sta 2004h
in 05
sta 2005h
in 06
sta 2006h
in 07
sta 2007h
in 08
sta 2008h
in 09
sta 2009h
;-----------

comeco:lxi h,1FFFh ;;em "comeco" o primeiro num do vetor é jogado para A e é setado como maior e ultimo num, alem disso é def qual o novo tamanho do vet a ser percorrido
	mov a,m
	sta 3000h
	inx h
	dcr a
	sta 3000h ;;quantidade de comparacoes a serem feitas
	jz ultimo_num ;;"funcao" para salvar o numero restante do vetor na primeira posicao
	mov a,m
	sta 3004h ;;endereco onde será armazenado maior num
	sta 100Ah ;;endereco onde será armazenado ultimo num
	mvi d,20h ;;par D E armazena o endereco do maior numero 
	mvi e,00h
continua: ;;comparacoes entre os num.s do vetor 
	inx h
	mov a,m
	sta 100Ah
	dcx h
	lda 3004h
	inx h 
	
	mov b,h ;;endereco ultimo num do vetor no par B C
	mov c,l

	cmp m
	jnc maior ;;num do A é maior do que o do endereco HL, ent DE permanece o msm
	mov a,m ;;se o num do endereco for maior, ele sera o novo maior num que será comparado com os outros e seu endereco será salvo

	mov d,h ;;endereco do maior num do vetor no par D E
	mov e,l

maior:;;novo maior num armaz em 3004h
	sta 3004h 
	lda 3000h;; quantidade de comparacoes restantes
	dcr a
	sta 3000h
	lda 3004h
	jnz continua;;ainda tem comparacoes a serem feitas

	mov h,d ;;nao tem mais comparacoes a serem feitas para definir o maior numero
	mov l,e
	mov a,m
	sta 3004h

	
;;trocando o endereco do ultimo num com o do maior num
	mov a,m
	
	lda 3004h ;;carrega maior num
	stax b ;;maior num p ultima pos do vet
	
	lda 100Ah ;;carrega ult num do vetor
	stax d ;;ultimo num para pos que era do maior num

;;-------1009h na pilha---------
	
	pop h ;;carregar pilha no par HL
	lda 3004h
	mov m,a	;;-------- salva em 1009h-x o maior numero do vetor
	
	dcx h  ;;----- 1009-x
	push h ;;-----1009-x na pilha 
	
;;-----------------------------

	lda 1FFFh ;;redefinindo ate onde o vetor vai ser analisado na prox exec
	dcr a
	sta 1FFFh
	sta 3000h
	jnz comeco ;;vetor ainda nao foi completamente organizado
	jmp 0000h ;;vet já esta completamente organizado, vai para stand by

	ultimo_num:mov a,m
		     sta 1000h
		     jmp 0000h
	
