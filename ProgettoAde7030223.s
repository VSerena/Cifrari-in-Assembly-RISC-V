#Progetto Assembly RISC-V per il Corso di Architetture degli Elaboratori A.A. 2021/2022
#Messaggi in Codice
#Serena Vannacci 7030223

.data

key_Blocchi: .string "OLE"
key_Sostituizione: .word 30
fine: .string "Termine programma"
mycypher: .string "EE"
myplaintext: .string "Ciao Mondo!?-2023"

.text

#########  MAIN DEL PROGETTO  #########

Main:
la a1 myplaintext    
addi a0 a1 0          #Salvo myplaintext in a0
li a7, 4
ecall 
             
la s0 mycypher  

li s1 65 #A = Cifrario a Sostituizione
li s2 66 #B = Cifrario a Blocchi
li s3 67 #C = Cifratura Occorrenze
li s4 68 #D = Dizionario
li s5 69 #E = Inversione

li t0 0
li t1 32
li t3 127
ControlloLunghezzaMyplaintext:
lb t2 0(a1)
beq t2 zero LunghezzaMassimaMyplaintext
blt t2 t1 Fine
bgt t2 t3 Fine
addi t0 t0 1
addi a1 a1 1
j ControlloLunghezzaMyplaintext
LunghezzaMassimaMyplaintext:
li t2 199
bgt t0 t2 Fine

Selezione_Codice_di_Cifratura:
lb t0 0(s0)
addi s0 s0 1  
beq t0 zero Selezione_Codice_di_Decifrazione
beq t0 s1 Cifrario_a_SostituizioneProcedura
beq t0 s2 Cifrario_a_BlocchiProcedura
beq t0 s3 Cifratura_OccorrenzeProcedura
beq t0 s4 DizionarioProcedura
beq t0 s5 InversioneProcedura

Selezione_Codice_di_Decifrazione:
addi s0 s0 -1  
Decifrazione:
addi s0 s0 -1     
lb t0 0(s0)
beq t0 zero Fine
beq t0 s1 Cifrario_a_SostituizioneProceduraDecifrazione
beq t0 s2 Cifrario_a_BlocchiProceduraDecifrazione
beq t0 s3 Decifrazione_OccorrenzeProcedura
beq t0 s4 DizionarioProceduraDecifrazione
beq t0 s5 InversioneProceduraDecifrazione

Stampa:
li a0 10
li a7, 11
ecall 
add a0 t0 zero  
li a7, 4
ecall   
jr ra
                ############  IMPLEMENTAZIONE CODICI DI CIFRATURA E DECIFRAZIONE  ############

#############################################
###########  CODICE SOSTITUZIONE  ###########
#############################################

Cifrario_a_SostituizioneProcedura: #CIFRATURA
li t3 0 #Controllo di selezione: istruzioni per la Cifratura
jal Cifrario_a_Sostituizione
j   Selezione_Codice_di_Cifratura    
Cifrario_a_SostituizioneProceduraDecifrazione: #DECIFRAZIONE
li t3 1 #Controllo di selezione: istruzioni per la Decifrazione
jal Cifrario_a_Sostituizione    
j Decifrazione   
Cifrario_a_Sostituizione:  
lw t1 key_Sostituizione
add t0 a0 zero
li t4 26 #Numero lettere alfabeto inglese
LoopSostituzione:
lb t2 0(a0)
beq t2 zero Stampa          #Controllo fine stringa
li t6 97 #a
bge t2 t6 SostituzioneLettereMinuscole     #Controllo se il valore in t2 ? una lettera minuscola
li t5 65 #A
bge t2 t5 SostituzioneLettereMaiuscole     #Controllo se il valore in t2 ? una lettera maiuscola
#Se il simbolo in t2 non appartiene alle casistiche precedenti si passa direttamente al suo salvataggio nella stringa crittografata  
SalvaSimboloSostituzione:
sb t2 0(a0)
addi a0 a0 1
j LoopSostituzione  
CambioLettera:
sub t2 t2 t5     #cod(X)-t5
add t2 t2 t1     #(cod(X)-t6)+key_Sostituizione
rem t2 t2 t4     #[(cod(X)-t6)+key_Sostituizione] mod 26
add t2 t2 t6     #t6 + [(cod(X)-t6)+key_Sostituizione] mod 26
bge t2 t5  SalvaSimboloSostituzione
addi t2 t2 26 #Aggiusta scarto decifrazione
j SalvaSimboloSostituzione  
SostituzioneLettereMinuscole:
li t6 122 #z
bgt t2 t6 SalvaSimboloSostituzione
li t5 97 #a
li t6 1
beq t3 t6 SostituzioneLettereMinuscoleDecifrazione
li t6 97 
j CambioLettera
#Uso t6 = 97 per la cifratura e t6 = 89 per la decifrazione per correggere lo scarto di 8
SostituzioneLettereMinuscoleDecifrazione:
li t6 89
j CambioLettera     
SostituzioneLettereMaiuscole:
li t6 90 #Z
bgt t2 t6 SalvaSimboloSostituzione
li t5 65
li t6 1
beq t3 t6 SostituzioneLettereMaiuscoleDecifrazione
li t6 65
j CambioLettera
#Uso t6 = 65 per la cifratura e t6 = 57 per la decifrazione per correggere lo scarto di 8
SostituzioneLettereMaiuscoleDecifrazione:
li t6 57
j CambioLettera

########################################
###########  CODICE BLOCCHI  ###########
########################################

Cifrario_a_BlocchiProcedura: #CIFRATURA
li t3 0
jal Cifrario_a_Blocchi
j   Selezione_Codice_di_Cifratura
Cifrario_a_BlocchiProceduraDecifrazione: #DECIFRAZIONE
li t3 1
jal Cifrario_a_Blocchi
j   Decifrazione
Cifrario_a_Blocchi:
li t1 0       #Contatore stringa key_Blocchi
la a3 key_Blocchi
add t0 a0 zero
LoopBlocchi:
add t5 t1 a3
lb t6 0(t5)
beq t6 zero AzzeraContatore
lb t2 0(a0)
beq t2 zero Stampa
li t5 1
beq t3 t5 DecifrazioneBlocchi
add t2 t2 t6     #cod(bij) + cod(keyj) 
li t6 96
rem t2 t2 t6     #(cod(bij) + cod(keyj)) mod 96
li t6 32
add t2 t2 t6     #32 + (cod(bij) + cod(keyj)) mod 96
SalvataggioSimboloBlocchi:
sb t2 0(a0)
addi a0 a0 1
addi t1 t1 1
j LoopBlocchi
DecifrazioneBlocchi:     
sub t2 t2 t6       #Sottraggo al simbolo il valore ascii della lettera appartenente alla chiave di cifratura
addi t2 t2 64 
li t6 32
bge t2 t6 SalvataggioSimboloBlocchi
addi t2 t2 96       #Ripristino il valore del simbolo nel range dei codici ascii 32-127
j SalvataggioSimboloBlocchi
AzzeraContatore:
li t1 0
j LoopBlocchi

###########################################
###########  CODICE OCCORRENZE  ###########
###########################################

Cifratura_OccorrenzeProcedura:      #CIFRATURA
jal Cifratura_Occorrenze
j   Selezione_Codice_di_Cifratura
Decifrazione_OccorrenzeProcedura:      #DECIFRAZIONE
jal Decifrazione_Occorrenze
j   Decifrazione       
Cifratura_Occorrenze:
li t0 0 #Contatore
li t5 2
div a2 a0 t5
add a3 a2 zero
li t5 -1 #Simbolo ripetuto
LoopOccorrenze:
addi sp sp -8
lb t2 0(a0)
addi a0 a0 1
addi t0 t0 1 #Aggiorno il contantore e la posizione degli elementi nella stringa dato che partono da 1 e non da 0
sw t0 0(sp)
sw a0 4(sp)
beq t2 zero Fine_LoopOccorrenze
beq t2 t5 LoopOccorrenze
sb t2 0(a2) #Salvo nella stringa cifrata valore contenuto in t2
addi a2 a2 1
Occorrenze:
li t6 45       # trattino -
sb t6 0(a2)       #Salvo nella stringa cifrata il trattino
addi a2 a2 1
li t6 10
bge t0 t6 CalcoloSingoleCifreDecine
CalcoloSingoleCifreUnità:
addi t1 t0 0
rem t1 t1 t6
addi t1 t1 48
sb t1 0(a2)       #Salvo nella stringa cifrata la posizione del valore contenuto in t2
addi a2 a2 1
j TrovaPosizioneOccorrenze
CalcoloSingoleCifreCentinaia:
div t1 t1 t6
addi t1 t1 48       #Codice Ascii
sb t1 0(a2)
addi a2 a2 1
li t6 45       # trattino -
sb t6 0(a2)       #Salvo nella stringa cifrata il trattino
addi a2 a2 1
CalcoloSingoleCifreDecine:
addi t1 t0 0
div t1 t1 t6        # t0:10
bge t1 t6 CalcoloSingoleCifreCentinaia
addi t1 t1 48       #Codice Ascii
sb t1 0(a2)
addi a2 a2 1
j CalcoloSingoleCifreUnità 
RiasettaLoopOccorrenze:
lw t0 0(sp)
lw a0 4(sp)
addi sp sp 4
li t6 32 
sb t6 0(a2) #Salvo lo spazio
addi a2 a2 1 
j LoopOccorrenze
TrovaPosizioneOccorrenze:
lb t4 0(a0) #parte dal simbolo che segue quello salvato in t2 
beq t4 zero RiasettaLoopOccorrenze 
addi t0 t0 1
beq t2 t4 SegnaSimboloRipetuto 
addi a0 a0 1 
j TrovaPosizioneOccorrenze
SegnaSimboloRipetuto:
sb t5 0(a0)
addi a0 a0 1 
j Occorrenze
Fine_LoopOccorrenze:
add t0 a3 zero
j Stampa 

Decifrazione_Occorrenze: 
li t2 3
mul a2 a0 t2
add t0 a2 zero
Loop_Decifrazione_Occorrenze:
lb t2 0(a0)
beq t2 zero Stampa
addi a0 a0 1
li t1 45
beq t2 t1 ControlloTrattino
addi t4 t2 0
j Loop_Decifrazione_Occorrenze  
ControlloTrattino:
lb t6 0(a0)
bne t6 t1 TrasformaInPosizione
li t4 45
addi a0 a0 1
lb t6 0(a0)
TrasformaInPosizione:
addi a0 a0 1
li t1 48
rem t6 t6 t1
lb t2 0(a0)
bge t2 t1 Decine #vuol dire che dopo non c'è nè lo spazio nè il trattino
j SalvaggioValore
Centinaia:
li t1 100
mul t6 t6 t1
li t1 10
mul t2 t2 t1
add t6 t6 t2
li t1 48
rem t5 t5 t1
add t6 t5 t6
j SalvaggioValore
Decine:
addi a0 a0 1
lb t5 0(a0)
bge t5 t1 Centinaia
li t1 10
mul t6 t6 t1
li t1 48
rem t2 t2 t1
add t6 t2 t6
SalvaggioValore:
add t3 t6 a2
addi t3 t3 -1
sb t4 0(t3)
j Loop_Decifrazione_Occorrenze

###########################################
###########  CODICE DIZIONARIO  ###########
###########################################

DizionarioProcedura: #CIFRATURA
jal Dizionario
j   Selezione_Codice_di_Cifratura    
DizionarioProceduraDecifrazione: #DECIFRAZIONE
jal Dizionario
j   Decifrazione          
Dizionario:
add t0 a0 zero
LoopDizionario:
lb t2 0(a0)
beq t2 zero Stampa           #Controllo fine stringa
li t6 97 #a
bge t2 t6 DizionarioLetteraMinuscola      #Controllo se il valore in t2 ? una lettera minuscola
li t5 65 #A
bge t2 t5 DizionarioLetteraMaiscola       #Controllo se il valore in t2 ? una lettera maiuscola
li t4 48 #0
bge t2 t4 DizionarioNumero                #Controllo se il valore in t2 ? un numero
#Se il simbolo in t2 non appartiene alle casistiche precedenti si passa direttamente al suo salvataggio nella stringa crittografata 
SalvaSimboloDizionario:
sb t2 0(a0)
addi a0 a0 1
j LoopDizionario
DizionarioLetteraMinuscola:
li t6 122 #z
bgt t2 t6 SalvaSimboloDizionario
li t6 97 #a
sub t6 t2 t6         # Lettera minuscola in t2 - a
li t5 90 #Z
sub t2 t5 t6         # Z - valore calcolato in t6
j SalvaSimboloDizionario
DizionarioLetteraMaiscola:
li t5 90 #Z
bgt t2 t5 SalvaSimboloDizionario 
sub t5 t5 t2         #Z - lettera maiuscola in t2
add t2 t6 t5         #a + valore in t5 = lettera maiuscola cifrata in minuscola
j SalvaSimboloDizionario
DizionarioNumero:
li t4 58 #: 
bge t2 t4 SalvaSimboloDizionario
li t4 105 #i
sub t2 t4 t2   # (9 - valore numerico in t2)
j SalvaSimboloDizionario


###########################################
###########  CODICE INVERSIONE  ###########
###########################################

InversioneProcedura: #CIFRATURA
jal Inversione
j   Selezione_Codice_di_Cifratura    
InversioneProceduraDecifrazione: #DECIFRAZIONE
jal Inversione
j   Decifrazione    
Inversione:
li t2 4
div a2 a0 t2
LoopInversione:
lb t2 0(a0)
addi a0 a0 1
beq t2 zero fine_LoopInversione 
sb t2 0(a2)
addi a2 a2 -1  
j LoopInversione
fine_LoopInversione:    
addi t0 a2 1
j Stampa

###########  FINE PROGRAMMA  ###########

Fine:
li a0 10
li a7, 11
ecall 
la a0 fine
li a7 4 
ecall 