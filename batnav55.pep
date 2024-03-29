;lDX 6, i
;LDX matrix, x         

         LDX     0,i         
         STRO welMsg, d; imprimer le msg de bienvenue 
         ;CHARO '\n', i ; imprimer saut de ligne
         
;JeuSpace:         

          LDX     0,i

in_loop: CPX     matrix,i 
         BRLE    display 

         ;LDX     ix,d        ;load dans X < ix >
         ;STX     ix,d        ;store dans < ix > la valeur de X

display: STRO        ALPHA,d  ; afficher les lettres ABCDEFGHIJKLMNOPQR
         LDX         0,i
         STX         ix,d 


iloop:   CPX     iSize,i
         ;BRGE    fini        ; fini pour arreter le jeu
         BRGE    msgBat      ; Si le nombre de ligne est atteint
         ;BRGE    suite ;for(line=0;line < 324; line += 36) {
                              ;on affiche le msg demandant d'entrer les bateaux 
         LDX     0,i         ; Initilize jx to 0
         STX     jx,d        ; jx <- 0 ;
         DECO    range,d
         CHARO  '|',i 

 

         
jloop:   CPX     jSize,i
         BRGE    next_ix
         ADDX    ix,d
         CHARO   tild,i
         LDX     ix,d         
         LDA     matrix,x    ; rA <- address of ln1,ln2 or ln3
         STA     ptr,d
         LDX     ptr,d
         ADDX    jx,d
         LDA     tild,i
     
         STA     0,x 
         LDX     jx,d
         ADDX    2,i 
        
         STX     jx,d 
         BR      jloop 

next_ix: CHARO   '|',i
         CHARO   '\n',i
         LDX     ix,d
         ADDX    2,i
         STX     ix,d
         LDA     range,d
         ADDA    1,i
         STA     range,d
         BR      iloop
         ;RET0

;-----------------------------------------------------------------

;--imprimer msg demandant d'entrer les specification des bateaux--

;-----------------------------------------------------------------

msgBat:         STRO askMsg, d 

;Boucle1:         CPX  gap, d     ; while char == gap, on repete la lecture des chars 
               ;  BREQ Boucle1
               ;  BRGE erreur               ; qui decrivent les bateaux
;erreur:         ; STRO askMsg, d  

           

;repeat:          CALL sizeBoat
                 ;STRO retMsgb, d
                 ;CHARO boatSize, d 
                 
                 ;CHARO '\n', i
 
                 ;CALL dirBoat
                 ;STRO retMsgD, d
                 ;CHARO boatdir, d 
                 ;CHARO '\n', i
                 ;CALL colBoat
                 ;STRO retMsgC, d
                 ;CHARO boatCol, d 
                 ;CHARO '\n', i
                 

                 ;CALL rowBoat 
                 ;STRO retMsg, d
                 ;CHARO boatRow, d
                 ;CHARO '\n', i

                 ;CALL checkgap
                 ;STRO retMsgG, d
                 ;CHARO gap, d
                 ;CHARO '\n', i
                 
                 ;CHARO gap, d
                 ;CHARO \n', i
                 ;CHARI gapp, d
                 ;
                 ;CPA  ', d
                 ;BREQ repeat 
                 ;BR msgDisp

                 ;LDA 0,i
                 ;LDBYTEA boatSize, d
                 ;CPA   'g', i
                 ;BREQ case1 
                 ;CPA   'm', i
                 ;BREQ case2 
                 ;CPA   'p', i
                 ;BREQ case3 

getBat:          CALL getsize
                 CALL getOri 
                 CALL getposC  ; colonne
                 CALL getposR  ; rangee
                 ;CALL isValid 

                 ; is valid laisse son bool de retour en A
                 ;CPA  1,i 
                 ;BREQ placerB ;Si valide on procede � placer les bateau dans l'espace de jeu
                 CALL placerB
                 ret0 

;------------------------------------------------------------------------------------
;-----------------------la grandeur  du bateau -------------------------------------
;-------------------------------------------------------------------------------------

getsize:         CHARI boatSize, d
                 LDBYTEA boatSize, d 
                 CPA   'g', i
                 BREQ casSize1    ; cas ou le bateau est grand 
                 CPA   'm', i
                 BREQ casSize2   ; cas ou le bateau est moyen 
                 CPA   'p', i
                 BREQ casSize3  ; cas ou le bateau est petit
                 
                 BR    msgBat   ; brancher si le bateau ni grand, ni moyen ni petit.
                  
casSize1:        LDA   5,i
                 CPA   5,i
                 BREQ finCasSz 
casSize2:        LDA   3,i
                 CPA   3,i
                 BREQ finCasSz
casSize3:        LDA   1,i
finCasSz:        STA   size,d   ; la grandeur du bateau 
                 RET0

;-------------------------------------------------------------------------------------
;---------------------------l'orientation du bateau ----------------------------------
;-------------------------------------------------------------------------------------
getOri:          CHARI orient,d
                 LDBYTEA orient,d   ; orientation du bateau 
                 STA dir, d   ; direction du bateau 
                 CPA   'h', i
                 BREQ finOrien  ; retour a la methode 
                 CPA   'v', i
                 BREQ finOrien ; si char = 'v' 
                 BR  msgBat  ;  si char != 'v' ou 'h'
finOrien:        RET0 ; retour a la methode

;--------------------------------------------------------------------------------------
;-----------------------------la position du bateau : colonne -------------------------
;--------------------------------------------------------------------------------------
getposC:        CHARI   boatCol,d
                LDBYTEA boatCol,d
                        
                CPA	'A', i
                    
                BRLT	msgBat  ; Si inferieur � A : msg d'erreur 
                     
                CPA	'R', i
                    
                BRGT   msgBat  ; Si grand que R : msg d'erreur 


                 SUBA  'A', i   ; Enlever 'A' du boatCol 
                 ASLA           ; here i get my position at y
                 STA   col, d   ; Colonne du bateau  col = boatCol -'A'
                 CHARO col, d
                 DECO col, d
                 RET0

                 
;--------------------------------------------------------------------------------------
;-----------------------------la position du bateau :  rangee  ------------------------
;--------------------------------------------------------------------------------------

               
getposR:         CHARI boatRow, d ;DECI boatRow, d ;CHARI boatRow, d  ;DECI boatRow, d       ; obtenir la rangee du bateau 
                 
                 LDA 0,i
                 LDBYTEA  boatRow, d
                 ;CPA	1, i 
                 CPA	49, i     
                 BRLT	msgBat  ; Si < 1 erreur 
		
                 ;CPA	9, i
                 CPA	57, i
		 
                 BRGT	msgBat  ; Si > 9 erreur 
                 SUBA 48,i
                 STA rowtemp, d
                 SUBA  1, i  ; on commence �  0
                 STA   row, d  ; Store res dans variable row
                 ;lDA col, i; creer multiplication par nobre de colonne
                 ;pos 'col' - 'A' + long*(rang-1))*2

                 LDX  jSize,i ;or d          ;LDX nb2,d ; X = nb2  nb de colonne
                 BRGE commence ; if(nb2 < 0){
                 LDA row,d ; maybe it is iSize,d
                 NEGA ;
                 STA row,d ; A = nb1 = -nb1;
                 LDX jSize,i ;  or d
                 NEGX ; X = nb2 = -nb2;
                 STX jSize,d ; } 
commence:        LDA 0,i ; A = 0;
addition:        ADDA row,d ; do{ A += nb1;
                 SUBX 1,i ; X--;
                 BRNE addition ; } while(X != 0);
                 ;ASLA 
fini:            STA res1,d ; res1 = A;
                 DECO res1,d ; cout << res; 
                ; STOP ;
;nb1: .WORD 0
;nb2: .WORD 0
;res: .WORD 0
;.END 
                  

                 ;ASLA    ; here i get my position at x
                 ;STA   row, d   ; .WORD rang 0
                 RET0


;--------------------------------------------------------------------------------------
;-----------------------------la position du bateau  rangee  --------------------------
;--------------------------------------------------------------------------------------

         
;isValid:         LDA  
                ; CPA ; Verifier si la  position des bateaux est a l'interieur de la matrix 
                ; RET0

;--------------------------------------------------------------------------------------
;-----------------------------mettre a jour le tableau   ------------------------------
;--------------------------------------------------------------------------------------


placerB:         LDA res1, d; LDX pos,d  ; (pos 'col' - 'A' + long*(rang-1))*2 
                 ;ASLA       ; (pos col + long*(row))
                 ; res1 = nbColonne*(rang-1)
                 
                 ADDA col, d ; or i   col = col - 'A'
                 ASLA
                 STA res2, d
                 LDX res2, d
                 ;LDA orient,d  ; maybe it is d
                 LDA dir,d
                 CPA 'h',i
                 BRNE placerVB   ; Si different de h donc c'est vertical 
loopPlac:        LDA '>',i
                 STA matrix,x 
                 ADDX 2,i
                 LDA size,d 
                 SUBA 1,i
                 CPA 0,i
                 BREQ finlpPl
                 BR loopPlac



placerVB:        LDA 'v',i      ; cas vertical 
                 STA matrix,x  ; have to store it somewhere else. 
                 ADDX 2,i
                 LDA size,d
                 SUBA 1,i
                 CPA 0,i
                 BREQ finlpPl
                 BR loopPlac

finlpPl:         RET0  ; fin de loop placer bateau

                 

                 


;----------------------------------------------------------------------------
;-- les cases determinant quoi imprimer selon le choix du joueur ------------
;----------------------------------------------------------------------------

 ; Si la taille de bateau est grande, on execute ce code

case1:           LDA 0,i 
                 LDBYTEA boatdir, d
                 CPA   'h', i
                 BREQ caseGH  ; cas grand et horizontal
                 CPA   'v', i
                 BREQ caseGV ; cas grand et Vertical

; Si la taille de bateau est moyenne , on execute ce code

case2:           LDA 0,i   
                 LDBYTEA boatdir, d
                 CPA   'h', i
                 BREQ caseMH   ; cas moyenne et horizontal
                 CPA   'v', i
                 BREQ caseMV ; cas moyenne et vertical

; Si la taille de bateau est petit, on execute ce code

case3:           LDA 0,i             
                 LDBYTEA boatdir, d
                 CPA   'h', i  
                 BREQ casePH    ; cas petit et horizontal
                 CPA   'v', i
                 BREQ casePV ; cas  petite et vertical

; Si la taille de bateau est grande et la direction est Horizontale on execute ce code
caseGH: LDA 0,i      ;CHARO G',i            
        LDBYTEA boatCol, d
        CHARO   boatCol, d   
        SUBA   'A',i    ; soutrait A de la valeur de la colonne dans l'accumulateur afin d'obtenir l'indice column
        ASLA            ; multiplie la valeur obtenue par 2 pour l'incrementation
        STA     tempCol,d
        DECO    tempCol,d

        LDBYTEA     boatRow,d
        CHARO   boatRow, d 
        SUBA        49,i
        STA     tempRow,d
        DECO    tempRow,d
        CPA      ix, d
        BREQ veriCol

veriCol: CPA jx, d
         BREQ load

load:   LDA carHori, i
        
        ;Call JeuSpace
        ;Call display

;carVert:      .EQUATE 0x0076   ; char v
;carHori:      .EQUATE 0x003E   ; char > 
        
        
        


; Si la taille de bateau est grande et la direction est Verticale on execute ce code
caseGV: CHARO 'G',i 

; Si la taille de bateau est moyenne et la direction est Horizontale on execute ce code
caseMH: CHARO 'M',i 

; Si la taille de bateau est moyenne et la direction est Verticale on execute ce code
caseMV: CHARO 'M',i 
; Si la taille de bateau est petite et la direction est Horizontale on execute ce code
casePH: CHARO 'P',i 

; Si la taille de bateau est petite et la direction est Verticale on execute ce code
casePV: CHARO 'P',i 
         CHARO '\n', i 


;----------------------------------------------------------------------------
;--Mettre a jour le tableau -------------------------------------------------
;----------------------------------------------------------------------------

LDX      0,i         
         ;STRO welMsg, d; imprimer le msg de bienvenue 
         ;CHARO '\n', i ; imprimer saut de ligne
         
;JeuSpace:         

          LDX     0,i
loopBoat: CPX     matrix,i 
          BRLE    alphaP   ; alpha print imprimer lettres ABCDEFGHIJKLMNOPQR 

         ;LDX     ix,d        ;load dans X < ix >
         ;STX     ix,d        ;store dans < ix > la valeur de X

alphaP:  STRO        ALPHA,d  ; les  lettres ABCDEFGHIJKLMNOPQR  � afficher
         LDX         0,i
         STX         ix,d 


iBoat:   CPX     iSize,i
         ;BRGE    fini        ; fini pour arreter le jeu
         BRGE    MsgFeu      ; Si le nombre de ligne est atteint, et que tous les bateaux 
                             ;sont affiche, on demande d'entrer les coups. 
                             ;BRGE    suite ;for(line=0;line < 324; line += 36) {
                             
         LDX     0,i         ; Initilize jx to 0
         STX     jx,d        ; jx <- 0 ;
         
         LDA     rantemp, d
         DECO    rantemp,d
  
         CHARO  '|',i 

 

         
jBoat:   CPX     jSize,i
         BRGE    then_ix
         ADDX    ix,d

;Here i should find a way to change tild to the right char. 

;carVert:      .EQUATE 0x0076   ; char v
;carHori:      .EQUATE 0x003E   ; char > 

         ;CHARO   tild,i

         CHARO   carHori, i

         LDX     ix,d         
         LDA     matrix,x    ; rA <- address of ln1,ln2 or ln3
         STA     ptr,d
         LDX     ptr,d
         ADDX    jx,d

         LDA     tild,i
     
         STA     0,x 
         LDX     jx,d
         ADDX    2,i 
        
         STX     jx,d 
         BR      jBoat

then_ix: CHARO   '|',i
         CHARO   '\n',i
         LDX     ix,d
         ADDX    2,i
         STX     ix,d
         LDA     rantemp,d
         ADDA    1,i
         STA     rantemp,d
         BR      iBoat
         ;RET0


                            
           

;fini:    stop 




;---------------------------------------------------------------

;Methode verifiant si la grandeur du bateau et correcte ou non 
;---------------------------------------------------------------
;sizeBoat:            CHARI	boatSize, d
                     ;CHARI carBidon, d
                     ;LDA 0,i
                    ; LDBYTEA	boatSize, d
                     
                     
                    ; CPA	'p', i
                     ;CPA	lettreP, d
                     ;BREQ	eqCharP
                     ;BREQ        loadBoat
 
                             
                     ;if p, convert to 1 bit 
                     ;RET0
                     ;CPA	'm', i
                     ;CPA	lettreM, d
                     ;BREQ	eqCharm 
                     ;BREQ        loadBoat
                     ;if p, convert to 3 bit 
                     ;RET0
                    ; CPA	'g', i
                     ;CPA	lettreG, d   
                     ;BREQ	eqCharg
                    ; BREQ        loadBoat
                    ;if p, convert to 5 bit 
                     ;RET0
                   ;  CALL         msgDisp, i 
                     ;STRO        notAccep, d
                    ; RET0
                     
;notlet:		STRO	nletmsg, d 
		;BR	out 

loadBoat:            LDX            sizeix, d
                     LDA            sizeVec, x
                     STA            sizeptr, d ; ptr -> vecteur[i]
                     LDX            sizeptr, d
                     ADDX           sizejx, d ; X -> vecteur[i][j]
                     LDA            boatSize, i ; vecteur[i][j] = nb_lu
                     STA            0, x
                     LDX            sizejx, d  ; maybe it is wrong to load sizejx 
                     ADDX           2, i
                     STX            sizejx, d
                     RET0


eqCharP:		STRO	msgCarP, d
RET0
eqCharm:              STRO	msgCarM, d
RET0 
eqCharg:              STRO	msgCarG, d
RET0
;out:		STOP

; Char to compare
lettreP:              .BYTE 'p'
lettreM:              .BYTE 'm'
lettreG:              .BYTE 'g'
;chr:		.BLOCK 1
boatSize:		.BYTE 1

; Is a letter message
msgCarP:		.ASCII "le char entre est p\n\x00"
msgCarM:              .ASCII "le char entre est m\n\x00"
msgCarG:              .ASCII "le char entre est g\n\x00"
; Is not a letter message
notAccep:	.ASCII "lettre ou char diffrent de ce qui est demand�\n\x00"

sizeix:             .BLOCK 2 ; #2d it�rateur ix pour tri
sizejx:             .BLOCK 2 ; #2d it�rateur jx pour tri 
sizeVec:         .ADDRSS sizer1 ; #2h 
sizeptr:           .BLOCK 2    ; #2h 
sizer1:            .BLOCK 8 ; #2d4a 
;sizer1:            .BLOCK 8 
;---------------------------------------------------------------------------
;--Methode v�rifiant si l'orientation du bateau entr� est correcte ou non --

;---------------------------------------------------------------------------

dirBoat:             CHARI	boatdir, d
                     ;CHARI carBidon, d
                     LDA 0,i
                     LDBYTEA	boatdir, d
                     
                     
                     CPA	'v', i
                     ;CPA	lettreP, d
                     ;BREQ	eqCharV
                     BREQ	loaddir
                     ;RET0
                     CPA	'h', i
                     ;CPA	lettreM, d
                     ;BREQ	eqCharH 
                     BREQ	loaddir
                     ;RET0
                     
                     STRO        dirNAcep, d 
                     RET0
                     
;notlet:		STRO	nletmsg, d 
		;BR	out 
eqCharV:		STRO	msgCarV, d
RET0
eqCharH:              STRO	msgCarH, d
RET0 

loaddir:                          LDX            dirix, d
                      LDA            dirVec, x
                      STA            dirptr, d         ; directionptr -> directionVecteur[i]
                      LDX            dirptr, d
                      ADDX         dirjx, d          ; X -> dirVecteur[i][j]
                      LDA           boatdir, d   ; dirvecteur[i][j] = boatdirection
                      STA            0, x
                      LDX            dirjx, d
                      ADDX         2, i
                      STX            dirjx, d
                      RET0


;out:		STOP

; Char to compare
lettreV:              .BYTE 'v'
lettreH:              .BYTE 'h'

;chr:		.BLOCK 1
boatdir:		.BYTE 1 

; Is a letter message
msgCarV:		.ASCII "le char entre est v\n\x00"
msgCarH:              .ASCII "le char entre est h\n\x00"

; Is not a letter message
dirNAcep:	.ASCII "lettre ou char diffrent de ce qui est demand�\n\x00" 

dirix:      .BLOCK 2 ; #2d it�rateur ix pour tri
dirjx:      .BLOCK 2 ; #2d it�rateur jx pour tri 
dirVec:   .ADDRSS dirr1 ; #2h 
dirptr:     .BLOCK 2    ; #2h 
dirr1:     .BLOCK 8 ; #2d4a 
;-----------------------------------------------------------------------------------
;--Methode v�rifiant si la lettre designant la colonne  entr� est correcte ou non --

;-----------------------------------------------------------------------------------
colBoat:             CHARI	boatCol, d
                     LDA 0,i
                     LDBYTEA	boatCol, d
                     
                     
                     CPA	'A', i
                     ;CPA	lettreA, d
                     BRLT	underA  ; inferieur � A
                     ;RET0
                     CPA	'R', i
                     ;CPA	lettreZ, d
                     ;BRLE	peOreqR 
                     BRLE        loadCol
                     ;RET0
                     
                     STRO        notaLet, d
                     RET0
                     
;notlet:		STRO	nletmsg, d 
		;BR	out 
underA:		STRO	msgpeA, d
RET0
peOreqR:              STRO	msgPeR, d
RET0


loadCol:           LDX            colix, d
                   LDA            colVec, x
                   STA            colptr, d ; ptr -> vecteur[i]
                   LDX            colptr, d
                   ADDX         coljx, d ; X -> vecteur[i][j]
                   LDA           boatCol, d ; vecteur[i][j] = nb_lu
                   STA            0, x
                   LDX            coljx, d
                   ADDX         2, i
                   STX            coljx, d
                   RET0 


;out:		STOP

; Char to compare
lettreA:              .BYTE 'A'
lettreZ:              .BYTE 'Q'

;chr:		.BLOCK 1
boatCol:		.BYTE 1 

; Is a letter message
msgpeA:		.ASCII "le char entre est inferieur � A\n\x00"
msgPeR:                .ASCII "le char entre est petit ou egal  R\n\x00"

; Is not a letter message
         
notaLet:	.ASCII "lettre n'est pas entre A et Q \n\x00"

colix:      .BLOCK 2 ; #2d it�rateur ix pour tri
coljx:      .BLOCK 2 ; #2d it�rateur jx pour tri 
colVec:   .ADDRSS colr1 ; #2h 
colptr:     .BLOCK 2    ; #2h 
colr1:     .BLOCK 8 ; #2d4a
;------------------------------------------------------------
;Methode verifiant si la rangee est entre  min =1 et max=9
;------------------------------------------------------------

rowBoat:              CHARI	boatRow, d
                      LDA 0,i
                      LDBYTEA	boatRow, d
                      CPA	'1', i
		BRLT	ltmin
		
                      CPA	'9', i
		;BRLE	gtmax
                      BRLE	loadrow
		STRO	outbmsg, d
                      RET0
		
ltmin:		STRO	ltmnmsg, d
                      RET0
		
gtmax:		STRO	gtmxmsg, d
                      RET0

loadrow:              LDX            rowix, d
                      LDA            rowVec, x
                      STA            rowptr, d ; ptr -> vecteur[i]
                      LDX            rowptr, d
                      ADDX           rowjx, d ; X -> vecteur[i][j]
                      LDA            boatRow, d ; vecteur[i][j] = nb_lu
                      STA            0, x
                      LDX            rowjx, d
                      ADDX           2, i
                      STX            rowjx, d
                      RET0 

min:		.BYTE '0'
max:		.BYTE '9'
boatRow:		.BLOCK 2


; In bounds message; msg va etre affich� si le nm de rang�s est: 1<=nb=<9
outbmsg:		.ASCII   "nombre de rangee est incorrecte\x00"
; Lower than min message
ltmnmsg:	            .ASCII  "plus petit que 1\x00"
; Higher than max message
gtmxmsg:	            .ASCII  "nombre de rangee est petit ou egale 9 !\x00"
carBidon: .BLOCK 1

rowix:      .BLOCK 2 ; #2d it�rateur ix pour tri
rowjx:      .BLOCK 2 ; #2d it�rateur jx pour tri 
rowVec:    .ADDRSS rowr1 ; #2h 
rowptr:    .BLOCK 2    ; #2h 
rowr1:     .BLOCK 8 ; #2d4a

;------------------------------------------------------------
;Methode verifiant si le char est un espace 
;------------------------------------------------------------

checkgap:             CHARI	gap, d
                 
                      LDA 0,i
                      LDBYTEA	gap, d
                     
                      CPA	' ', i         
                      ;BREQ	isGap 
	           STRO	msgNotG, d 
                      RET0
		
;isGap:		STRO	msgGap, d
;isGap:		CALL	repeat, i 
                      RET0

gap:		.BYTE 1


; msg va etre affich� si le char est un espace
msgGap:		.ASCII   "char est un ' ' \x00"
;  msg va etre affich� si le char n'est un espace
msgNotG:	            .ASCII  "char est different de ' ' \x00"		

;-------------------------------------------------------------------------
;------  Declaration, reservation espace memoire et  initialisation ------
;-------------------------------------------------------------------------
; Current line Index
lnIndex: .WORD 0

;Max line address = line start + 8
maxLnAdr:.WORD 0

nbLu:    .block 2

matrix:  .ADDRSS ln1         ; #2h
         .ADDRSS ln2         ; #2h
         .ADDRSS ln3         ; #2h
         .ADDRSS ln4         ;avant existe pas
         .ADDRSS ln5
         .ADDRSS ln6
         .ADDRSS ln7
         .ADDRSS ln8
         .ADDRSS ln9
         ;.ADDRSS ln10

totSize: .equate 48       ;CHANGER avant equate 24 pour 3x4 | critere pour taille de matrice (x2)

iSize:   .equate 18       ;18 parceque la matrice contien 9 lignes
jSize:   .equate 36       ;36 parceque la matrice contien 18 Colonne
res1:    .BLOCK 2
res2:    .BLOCK 2


ptr:     .BLOCK 2 

ln1:              .BLOCK 36 ; #2d18a 
ln2:              .BLOCK 36 ; #2d18a 
ln3:              .BLOCK 36 ; #2d18a 
ln4:              .BLOCK 36 ; #2d18a 
ln5:              .BLOCK 36 ; #2d18a 
ln6:              .BLOCK 36 ; #2d18a
ln7:              .BLOCK 36 ; #2d18a 
ln8:              .BLOCK 36 ; #2d18a 
ln9:              .BLOCK 36 ; #2d18a 

ALPHA:        .ASCII "  ABCDEFGHIJKLMNOPQR\n\x00"           

tild:         .EQUATE 0x007E   ; char ~
carVert:      .EQUATE 0x0076   ; char v
carHori:      .EQUATE 0x003E   ; char > 
emptyO:       .EQUATE 0x006F   ; char o , si aucune partie de boat n'est touche�
tempCol:      .BLOCK 2
tempRow:      .BLOCK 2
rowtemp: .BLOCK 2

col:       .WORD 0  ; la colonne du bateau 
dir:       .WORD 0  ; direction du bateau 
row:       .WORD 0  ; la rangee du bateau 
orient:    .BYTE 1  ; l'orientation du bateau 
size:	.BYTE 1  ; la grandeur du bateau 

                
                   
    
     
                   
        
         

ix:      .BLOCK  2           ; #2d  reserv� 2 octet � ix initialis� � 0 // rangee ou line
 
jx:      .BLOCK  2           ; #2d  reserv� 2 octet � jx initialis� � 0  // colonne 
range:   .WORD  1            ; nbr de rangee a imprimer 
rantemp:   .WORD  1  

temp:    .block  2           ;reserv� 2 octet � temp
;temp:    .block  1           ;reserv� 2 octet � temp
gapp:    .WORD ' '

welMsg:  .ASCII "Bienvenue au jeu de bataille navale! \n\x00"

askMsg:  .ASCII "Entrer la description et la position des bateaux \n"
         .ASCII "selon le format suivant, separes par des espaces: \n"
         .ASCII "taille[p/m/g] orientation[h/v] colonne[A-R] rang�e[1-9] \n"
         .ASCII "ex: ghC4 mvM2 phK9 \n\x00" 
retMsg:  .ASCII "Je suis de retour\n\x00" 
retMsgb: .ASCII "Je suis de retour apres verif de grandeur boat\n\x00"
retMsgD: .ASCII "Je suis de retour apres verif de l'orientation boat\n\x00"
retMsgC: .ASCII "Je suis de retour apres verif de la colonne boat\n\x00"
retMsgG: .ASCII "Je suis de retour apres verif du char ' ' \n\x00"

MsgFeu: .ASCII "Feu � volont�!\n"
        .ASCII "(entrer les coups � tirer: colonne [A-R] rang�e [1-9])\n"
        .ASCII "ex: A3 I5 M3 \n\x00"

.end








