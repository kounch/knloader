#program knloader
#autostart
  10 ; knloader - Copyright (c) 2020 @kounch
  20 ; This program is free software, you can redistribute
  30 ; it and/or modify it under the terms of the
  40 ; GNU General Public License

  50 LET %s=%REG 7&3:RUN AT 2
  60 REM ON ERROR RUN AT %s:FOR %a=0 TO 15:CLOSE # %a:NEXT %a:ON ERROR:STOP:REM ERASE
  70 GO SUB 7000:; Load Defaults
  80 LAYER CLEAR:SPRITE CLEAR:PALETTE CLEAR:PAPER tinta:BORDER tinta:INK papel:CLS
  90 PRINT AT 5,15;"> knloader v0.1 <":PRINT AT 8,17;"© kounch 2020"

  95 ; Load Menu Items
 100 GO SUB 5000:; Load Cache
 110 GO SUB 5100:; Load Options
 120 CLS

 195 ; Draw Menu Text
 200 LET pos=1:OPEN # 6,"w>0,0,24,12,4"
 210 PRINT #6;INK tinta;PAPER papel;CHR$ 14:REM Clear Widow
 250 FOR %c=1 TO 22:LET c=%c:PRINT #6;INVERSE 0;OVER 0;AT c,1;z$(c):NEXT %c
 295 ; Menu Input Control and Delay Logic


 300 LET prv=1:LET %k=0:LET J=0:LET K$="":LET %d=1
 310 PRINT #6;AT prv,0;OVER 1;"                        ":PRINT #6;AT pos,0;OVER 1;INVERSE 1;"                        "
 320 LET J=IN 31:LET K$=INKEY$:IF J<>0 OR K$<>"" THEN LET %d=1:GO TO 360
 330 LET %k=0:IF %d=0 THEN GO TO 320
 340 LET a$=b$(pos):GO SUB 5300
 350 GO SUB 4500:LET %d=0
 360 IF J=0 AND K$="" THEN GO TO 320
 370 IF J=IN 31 OR K$=INKEY$  THEN IF %k=1 THEN GO TO 440
 380 IF J<>IN 31 AND K$<>INKEY$ THEN LET %k=0:GO TO 430
 390 IF K$<>"6" AND K$<>CHR$(10) AND J<>4 AND K$<>"7" AND K$<>CHR$(11) AND J<>8 THEN GO TO 430
 400 LET %t=PEEK 23672:LET kr=1
 410 LET %r=256+PEEK 23672:LET %r=%(r-t) MOD 255
 420 IF %r<p THEN GO TO 410
 430 IF J=IN 31 OR K$=INKEY$  THEN LET %k=1
 440 BEEP 0.008,-20

 495 ; Menu Control Input
 500 IF CODE K$=13 OR J=16 THEN GO TO 895
 510 IF K$="5" OR K$=CHR$ (8) OR J=2 THEN GO TO 695
 520 IF K$="8" OR K$=CHR$ (9) OR J=1 THEN GO TO 755
 530 IF K$="6" OR K$=CHR$ (10) OR J=4 THEN GO TO 795
 540 IF K$="7" OR K$=CHR$ (11) OR J=8 THEN GO TO 845
 550 IF K$="R" OR K$="r" THEN CLOSE # 6:CLS:ERASE "/tmp/knloader/*.*":RUN AT %s:CLEAR:RUN
 560 IF K$="X" OR K$="x" THEN FOR %a=0 TO 15:CLOSE # %a:NEXT %a:RUN AT %s:ERASE
 570 IF K$="C" OR K$="c" OR J=32 THEN LET prev=pos:LET covers=1-covers:GO TO 210
 580 IF K$="O" OR K$="o" THEN REM SaveOptions>>>`xc3IMPLEMENTED<<<
 590 IF K$="E" OR K$="e" THEN REM EditOptions>>>`xc3IMPLEMENTED<<<
 600 IF K$="H" OR K$="h" THEN REM ShowHelp>>>`xc3IMPLEMENTED<<<
 690 GO TO 320

 695 ; Input LEFT
 700 LET prv=pos:IF pag>0 THEN LET pag=pag-1:LET pos=1:GO SUB 5000:GO TO 210
 750 GO TO 320
 755 ; Input RIGHT
 760 LET prv=pos:IF pag<maxpag THEN LET pag=pag+1:LET pos=1:GO SUB 5000:GO TO 210
 790 GO TO 320
 795 ; Input DOWN
 800 LET prv=pos
 810 IF pag<maxpag AND pos=22 THEN LET pag=pag+1:LET pos=1:GO SUB 5000:GO TO 210
 820 IF pag<maxpag AND pos<22 THEN LET pos=pos+1
 830 IF pag=maxpag AND pos<maxpos THEN LET pos=pos+1
 840 GO TO 310
 845 ; Input UP
 850 LET prv=pos
 860 IF pag>0 AND pos=1 THEN LET pag=pag-1:LET pos=22:GO SUB 5000:GO TO 210
 870 IF pos>1 THEN LET pos=pos-1
 880 GO TO 310

 895 ; Prepare to Launch Program
 900 CLOSE # 6
 910 CLS:BORDER 1
 920 PRINT AT 4,13;"> knloader <":PRINT AT 6,12;"© kounch 2020"
 930 PRINT AT 10,1;z$(pos)
 940 PRINT AT 12,1;"MODE: ";o(pos);" - ";m$
 950 PRINT AT 14,0;"Dir:"
 960 PRINT AT 15,1;w$(pos)
 970 PRINT AT 16,0;"File:"
 980 PRINT AT 17,1;x$(pos)
 990 PAUSE 0

 995 ; Save Loader Options
1000 LET mode=o(pos)
1010 LET a$=w$(pos):GO SUB 5300:LET c$=a$
1020 LET a$=x$(pos):GO SUB 5300

1050 DIM o(1):DIM o$(3,maxpath)
1060 LET o(1)=mode
1070 LET o$(1)=y$
1080 LET o$(2)=c$
1090 LET o$(3)=a$
1100 SAVE "m:klo.tmp"DATA o()
1110 SAVE "m:kls.tmp"DATA o$()
1145 ; Launch Program

1150 BORDER tinta:RUN AT %s:CLEAR:LOAD "knlauncher"
1190 STOP
3095 ; SUBROUTINES
3096 ;-------------

4495 ; Cover Data
4500 LET mode=o(pos)
4510 IF mode=0 THEN LET m$="3DOS"
4520 IF mode=1 THEN LET m$="TAP"
4530 IF mode=2 THEN LET m$="TZX (fast)"
4540 IF mode=3 THEN LET m$="DSK (AUTOBOOT)"
4550 IF mode=4 THEN LET m$="TAP (USR 0)"
4560 IF mode=5 THEN LET m$="TZX (USR0 - Fast)"
4570 IF mode=6 THEN LET m$="TAP (Next)"
4580 IF mode=7 THEN LET m$="TZX (Next - Fast)"
4590 IF mode=8 THEN LET m$="DSK (Custom Boot)"
4600 IF mode=9 THEN LET m$="TAP (PI Audio)"
4610 IF mode=10 THEN LET m$="TZX"
4620 IF mode=11 THEN LET m$="TAP (USR 0 - PI Audio)"
4630 IF mode=12 THEN LET m$="TZX (USR 0)"
4640 IF mode=13 THEN LET m$="TAP (PI Audio - Next)"
4650 IF mode=14 THEN LET m$="TZX (Next)"
4690 IF a$<>" " AND covers=1 THEN GO TO 4800

4695 ; Text Data
4700 LAYER 2,0:LAYER 0
4710 OPEN # 5,"w>1,14,22,17,4"
4720 PRINT #5;INK papel;PAPER tinta;CHR$ 14:REM Clean Widow
4730 PRINT #5;AT 1,0;"FILE: ";z$(pos)
4740 PRINT #5;AT 4,0;"MODE: ";m$
4750 PRINT #5;AT 6,0;"NAME: ";x$(pos)
4790 CLOSE # 5:RETURN

4795 ; Image Data (Cover)
4800 LET l$=a$((LEN a$-2) TO LEN a$)
4810 IF l$="BMP" OR l$="bmp" THEN PRINT #6;CHR$ 2;:LAYER 2,0:.$ bmpload a$:LAYER 2,1:LAYER 0:PRINT #6;CHR$ 3;
4820 IF l$="SCR" OR l$="scr" THEN PRINT #6; CHR$ 2;:LAYER 2,0:LAYER 0:LOAD a$ SCREEN$:PRINT #6; CHR$ 3;
4830 IF l$="SLR" OR l$="slr" THEN PRINT #6;CHR$ 2;:LAYER 2,0:LAYER 1,0:LOAD a$ LAYER:LAYER 0:PRINT #6;CHR$ 3;
4840 IF l$="SHR" OR l$="shr" THEN PRINT #6;CHR$ 2;:LAYER 2,0:LAYER 1,1:LOAD a$ LAYER:LAYER 0:PRINT #6;CHR$ 3;
4850 IF l$="SHC" OR l$="shc" THEN PRINT #6;CHR$ 2;:LAYER 2,0:LAYER 1,2:LOAD a$ LAYER:LAYER 0:PRINT #6;CHR$ 3;
4860 IF l$="SL2" OR l$="sl2" THEN PRINT #6;CHR$ 2;:LAYER 2,0:LOAD a$ LAYER:LAYER 2,1:LAYER 0:PRINT #6;CHR$ 3;
4890 RETURN

4995 ; Load Cache
5000 ON ERROR GO SUB 6000:ON ERROR
5010 RUN AT 3:DIM z$(22,22):DIM o(22):DIM w$(22,maxpath):DIM x$(22,maxpath):DIM b$(22,maxpath)
5020 LOAD "/tmp/knloader/zcch"+STR$ pag+".tmp"DATA z$()
5030 LOAD "/tmp/knloader/occh"+STR$ pag+".tmp"DATA o()
5040 LOAD "/tmp/knloader/wcch"+STR$ pag+".tmp"DATA w$()
5050 LOAD "/tmp/knloader/xcch"+STR$ pag+".tmp"DATA x$()
5060 LOAD "/tmp/knloader/bcch"+STR$ pag+".tmp"DATA b$()
5070 DIM p(2):LOAD "/tmp/knloader/cache.tmp"DATA p():LET maxpag=p(1):LET maxpos=p(2)
5080 DIM o$(1,maxpath*2):LOAD "/tmp/knloader/ycch.tmp" DATA o$() :LET a$=o$(1):GO SUB 5300:LET y$=a$
5090 RUN AT 2:RETURN

5095 ; Load Options
5100 ON ERROR GO SUB 5200:ON ERROR
5110 DIM p(4)
5120 LOAD "opts.tmp"DATA p()
5130 LET tinta=p(1):LET papel=p(2):LET %p=p(3):covers=p(4)
5150 RETURN

5195 ; Save Options
5200 ON ERROR PRINT "Error saving options!!":ERROR  TO e:PRINT e:PAUSE 0:ON ERROR:STOP
5210 DIM p(4)
5220 LET p(1)=tinta:LET p(2)=papel:LET p(3)=%p:LET p(4)=covers
5230 SAVE "opts.tmp"DATA p()
5240 RETURN

5295 ; Strip Spaces from a$
5300 LET m=1:FOR n=1 TO LEN (a$):IF a$(n TO n)<>" " THEN LET m=n
5310 NEXT n
5320 LET a$=a$(1 TO m)
5330 RETURN

5995 ; Build Cache
6000 ON ERROR GO TO 6010:ON ERROR
6005 MKDIR "/tmp/knloader"
6010 ON ERROR PRINT "Cache Build Error!!":ERROR  TO e,l:PRINT e,l:PAUSE 0:ON ERROR:STOP
6020 RUN AT 3:LET n=0:LET f=0:LET fp=1:LET pag=0
6030 PRINT AT 14,0;:COPY "knloader.bdt" TO "m:":;Copy to RAMDisk
6040 OPEN # 4,"m:knloader.bdt":DIM #4 TO %f:LET lf=%f
6050 DIM z$(22,22):DIM o(22):DIM w$(22,maxpath):DIM x$(22,maxpath):DIM b$(22,maxpath)
6060 LET l$="":LET lp=1:IF n>0 THEN LET z$(n)="":LET o(n)=0:LET x$(n)="":LET b$(n)=""
6070 LET fp=fp+1:IF fp>lf THEN GO TO 6200
6080 NEXT #4 TO b:LET c$=CHR$ b
6090 IF b=10 OR b=13 THEN GO TO 6110
6100 IF c$<>"," THEN LET l$=l$+c$:GO TO 6070
6110 PRINT AT 20,12;"BUILDING CACHE:";INT (100*fp/lf);"%"
6120 IF n=0 THEN LET y$=l$:GO TO 6180
6130 IF lp=1 THEN LET z$(n)=l$
6140 IF lp=2 THEN LET o(n)=VAL (l$)
6150 IF lp=3 THEN LET w$(n)=l$
6160 IF lp=4 THEN LET x$(n)=l$
6170 IF lp=5 THEN LET b$(n)=l$
6180 LET l$="":IF c$="," THEN LET lp=lp+1:GO TO 6070
6190 IF b=10 OR b=13 THEN LET n=n+1:IF n<23 THEN GO TO 6060

6195 ;Save cache
6210 SAVE "/tmp/knloader/zcch"+STR$ pag+".tmp"DATA z$()
6220 SAVE "/tmp/knloader/occh"+STR$ pag+".tmp"DATA o()
6230 SAVE "/tmp/knloader/wcch"+STR$ pag+".tmp"DATA w$()
6240 SAVE "/tmp/knloader/xcch"+STR$ pag+".tmp"DATA x$()
6250 SAVE "/tmp/knloader/bcch"+STR$ pag+".tmp"DATA b$()
6255 REM PRINT AT 20,0;"Page: "+STR$ pag:PAUSE 0
6260 IF (b=10 OR b=13) AND fp<=lf THEN LET pag=pag+1:LET n=1:GO TO 6050
6270 CLOSE # 4:PRINT AT 20,12;"                       "
6280 LET maxpag=pag:LET maxpos=n
6290 DIM p(2):LET p(1)=maxpag:LET p(2)=maxpos
6300 SAVE "/tmp/knloader/cache.tmp"DATA p()
6310 DIM o$(1,maxpath*2):LET o$(1)=y$:SAVE "/tmp/knloader/ycch.tmp" DATA o$() 
6390 RUN AT 2:LET pag=0:LET pos=0:RETURN

6995 ; Default Config
7000 LET tinta=0:LET papel=7:LET %p=7:LET pag=0:LET maxpag=0:LET maxpos=1:LET maxpath=64
7010 LET covers=1
7090 RETURN
