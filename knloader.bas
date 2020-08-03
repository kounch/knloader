#program knloader
#autostart
  10 ; knloader - Copyright (c) 2020 @kounch
  20 ; This program is free software, you can redistribute
  30 ; it and/or modify it under the terms of the
  40 ; GNU General Public License

  50 LET %s=%REG 7&3:RUN AT 3:LET %q=%REG 2&3
  60 ON ERROR PRINT "ERROR":ERROR TO e,l:PRINT e,l:PAUSE 0:FOR %a=0 TO 15:CLOSE # %a:NEXT %a:PAPER op:BORDER ob:INK oi:RUN AT %s:ERASE:ON ERROR
  70 GO SUB 7000:; Load Defaults
  80 LAYER CLEAR:SPRITE CLEAR:PALETTE CLEAR:PAPER tinta:BORDER tinta:INK papel:CLS
  90 PRINT AT 5,13;"> knloader  v1.0.1 <":PRINT AT 8,15;"© kounch  2020":PRINT AT 15,14;"Press H for help"

  95 ; Load Menu Items
 100 GO SUB 4900:; Load Cache To RAM
 110 GO SUB 5000:; Load Options
 120 GO SUB 5100:; Load From Cache

 195 ; Draw Menu Text
 200 PAPER tinta:BORDER tinta:INK papel:CLS:OPEN # 6,"w>0,0,24,12,4"
 210 PRINT #6;INK tinta;PAPER papel;CHR$ 14:; Clear Widow
 250 FOR %c=1 TO 22:LET c=%c:PRINT #6;INVERSE 0;OVER 0;AT c,1;z$(c):NEXT %c

 295 ; Menu Input Control and Delay Logic
 300 LET prv=1:LET %k=0:LET J=0:LET K$="":LET %d=1
 310 PRINT #6;AT prv,0;OVER 1;"                        ":PRINT #6;AT pos,0;OVER 1;INVERSE 1;"                        "
 320 LET J=IN 31:LET K$=INKEY$:IF J=255 THEN LET J=0
 330 IF J<>0 OR K$<>"" THEN LET %d=1:GO TO 360
 340 LET %k=0:IF %d=0 THEN GO TO 320
 350 GO SUB 4000:LET %d=0
 360 IF J=0 AND K$="" THEN GO TO 320
 370 IF J=IN 31 OR K$=INKEY$ THEN IF %k=1 THEN GO TO 440
 380 IF J<>IN 31 AND K$<>INKEY$ THEN LET %k=0:GO TO 430
 390 IF K$<>"6" AND K$<>CHR$(10) AND J<>4 AND K$<>"7" AND K$<>CHR$(11) AND J<>8 THEN GO TO 430
 400 LET %t=PEEK 23672:LET kr=1
 410 LET %r=256+PEEK 23672:LET %r=%(r-t) MOD 255
 420 IF %r<p THEN GO TO 410
 430 IF J=IN 31 OR K$=INKEY$ THEN LET %k=1
 440 BEEP 0.008,-20

 495 ; Menu Control Input
 500 IF K$="0" OR K$=CHR$(13) OR J=16 THEN GO TO 895
 510 IF K$="5" OR K$=CHR$(8) OR J=2 THEN LET prv=pos:GO TO 700
 520 IF K$="8" OR K$=CHR$(9) OR J=1 THEN LET prv=pos:GO TO 750
 530 IF K$="6" OR K$=CHR$(10) OR J=4 THEN LET prv=pos:GO TO 800
 540 IF K$="7" OR K$=CHR$(11) OR J=8 THEN LET prv=pos:GO TO 850
 550 IF K$="R" OR K$="r" THEN CLOSE # 6:CLS:PRINT AT 10,12;"ERASING...":ERASE "C:/tmp/knloader/*.*":RUN AT %s:CLEAR:RUN
 560 IF K$="X" OR K$="x" OR J=64 THEN GO SUB 5200:FOR %a=0 TO 15:CLOSE # %a:NEXT %a:PAPER op:BORDER ob:INK oi:RUN AT %s:ERASE
 570 IF K$="C" OR K$="c" OR J=32 THEN LET prv=pos:LET covers=1-covers:GO TO 1400
 580 IF K$="A" OR K$="a" THEN LET autosave=1-autosave:GO SUB 5200:GO TO 1700
 590 IF K$="H" OR K$="h" THEN LET prv=pos:GO TO 1500
 690 GO TO 320

 695 ; Input LEFT
 700 IF pag>0 THEN LET pag=pag-1:LET pos=1:GO SUB 5100:GO TO 210
 710 GO TO 320
 745 ; Input RIGHT
 750 IF pag<maxpag THEN LET pag=pag+1:LET pos=1:GO SUB 5100:GO TO 210
 760 GO TO 320
 795 ; Input DOWN
 800 IF pag<maxpag AND pos=22 THEN LET pag=pag+1:LET pos=1:GO SUB 5100:GO TO 210
 810 IF pag<maxpag AND pos<22 THEN LET pos=pos+1
 820 IF pag=maxpag AND pos<maxpos THEN LET pos=pos+1
 830 GO TO 310
 845 ; Input UP
 850 IF pag>0 AND pos=1 THEN LET pag=pag-1:LET pos=22:GO SUB 5100:GO TO 210
 860 IF pos>1 THEN LET pos=pos-1
 870 GO TO 310

 895 ; Prepare to Launch Program
 900 CLOSE # 6:CLS:BORDER 1:ON ERROR GO TO 1300:ON ERROR
 910 PRINT AT 4,13;"> knloader <":PRINT AT 6,12;"© kounch 2020":PRINT AT 10,1;z$(pos):PRINT AT 12,0;"Mode: ";o(pos);" - ";m$
 920 PRINT AT 14,0;"Dir:":PRINT AT 15,1;w$(pos):PRINT AT 17,0;"File:":PRINT AT 18,1;x$(pos)
 930 LET a$=x$(pos):GO SUB 5300:LET l$=a$:LET a$=w$(pos):GO SUB 5300:IF a$(LEN a$ TO LEN a$)="/" THEN LET a$=a$(1 TO LEN a$-1)
 940 IF a$<>"" AND a$(LEN a$ TO LEN a$)="." THEN LET a$(LEN a$ TO LEN a$)="_":IF a$="_" THEN LET a$=" "
 950 LET c$=y$:LET v$="C:":IF c$(2 TO 2)=":" THEN LET v$=c$(1 TO 2):LET c$=c$(3 TO LEN c$)
 960 IF c$(LEN c$ TO LEN c$)<>"/" THEN LET c$=c$+"/"
 970 IF a$<>" " THEN LET c$=c$+a$
 980 LET a$=l$:GO SUB 5400:LOAD v$:CD c$:DIM d$(255):OPEN # 2,"v>d$":CAT a$:CLOSE # 2:LOAD q$:CD p$
 990 IF d$(1 TO 14)="No files found" THEN GO TO 1300

 995 ; Save Launcher Options
1000 LET mode=o(pos)
1010 LET a$=w$(pos):GO SUB 5300:IF a$(LEN a$ TO LEN a$)="/" THEN LET a$=a$(1 TO LEN a$-1)
1020 IF a$<>"" AND a$(LEN a$ TO LEN a$)="." THEN LET a$(LEN a$ TO LEN a$)="_":IF a$="_" THEN LET a$=" "
1030 LET c$=a$
1040 LET a$=x$(pos):GO SUB 5300
1050 DIM o(1):DIM o$(3,maxpath)
1060 LET o(1)=mode
1070 LET o$(1)=y$
1080 LET o$(2)=c$
1090 LET o$(3)=a$
1100 SAVE "m:klo.tmp"DATA o()
1110 SAVE "m:kls.tmp"DATA o$()

1140 GO SUB 5200:;Save Loader Options 
1150 BORDER tinta:RUN AT %s:CLEAR:LOAD "knlauncher":; Launch Program
1190 STOP

1295 ; File to load not found
1300 ON ERROR
1310 PRINT AT 7,5;INK 6;PAPER 2;"                      "
1320 PRINT AT 8,5;INK 6;PAPER 2;" ERROR:File Not Found "
1330 PRINT AT 9,5;INK 6;PAPER 2;"                      "
1340 LET J=IN 31:LET K$=INKEY$:IF (J<>0 AND J<>255) OR K$<>"" THEN GO TO 1340
1350 LET J=IN 31:LET K$=INKEY$:IF (J=0 OR J=255) AND K$="" THEN GO TO 1350
1360 LET prv=pos:CLS:GO TO 200

1395 ; Show Cover Status
1400 LET a$="ON ":IF covers=0 THEN LET a$="OFF"
1410 PRINT AT 6,16;"             "
1420 PRINT AT 7,16;" Covers: ";a$;" "
1430 PRINT AT 8,16;"             "
1440 PAUSE 30:GO TO 210

1495 ; Help Window
1500 OPEN # 5,"w>1,1,22,30,4":PRINT #5;INK papel;PAPER tinta;CHR$ 14:CLOSE # 5
1510 OPEN # 5,"w>2,2,20,28,4":PRINT #5;INK tinta;PAPER papel;CHR$ 14
1520 PRINT #5;AT 1,23;"- HELP -"
1530 PRINT #5;AT 3,1;"Use cursor keys or joystick (kempston) to move"
1540 PRINT #5;AT 5,1;"ENTER, 0 or joystick button to launch selected program"
1550 PRINT #5;AT 7,1;"Press R to rebuild the cache from DBT file"
1560 PRINT #5;AT 9,1;"Press C or joystick secondary to hide/show images"
1570 PRINT #5;AT 11,1;"Press A to enable/disable auto save"
1580 PRINT #5;AT 14,1;"Press X to exit"
1590 PRINT #5;AT 16,1;"Press H to show this help"
1600 PRINT #5;AT 19,5;"Press any key or button to close this window"
1610 LET J=IN 31:LET K$=INKEY$:IF (J<>0 AND J<>255) OR K$<>"" THEN GO TO 1610
1620 LET J=IN 31:LET K$=INKEY$:IF (J=0 OR J=255) AND K$="" THEN GO TO 1620
1630 CLOSE # 5:GO TO 210

1695 ; Show Autosave Status
1700 LET a$="ON ":IF autosave=0 THEN LET a$="OFF"
1710 PRINT AT 6,14;"               "
1720 PRINT AT 7,14;" Autosave: ";a$;" "
1730 PRINT AT 8,14;"               "
1740 PAUSE 30:GO TO 210

3095 ; SUBROUTINES
3096 ;-------------

3995 ; Cover Data
4000 LET mode=o(pos):LET a$=b$(pos):LET m$="Unknown":GO SUB 5300
4010 IF mode=0 THEN LET m$="3DOS (Next)"
4020 IF mode=1 THEN LET m$="TAP"
4030 IF mode=2 THEN LET m$="TZX (fast)"
4040 IF mode=3 THEN LET m$="DSK (AUTOBOOT)"
4050 IF mode=4 THEN LET m$="TAP (USR 0)"
4060 IF mode=5 THEN LET m$="TZX (USR0 - Fast)"
4070 IF mode=6 THEN LET m$="TAP (Next)"
4080 IF mode=7 THEN LET m$="TZX (Next - Fast)"
4090 IF mode=8 THEN LET m$="DSK (Custom Boot)"
4100 IF mode=9 THEN LET m$="TAP (PI Audio)"
4110 IF mode=10 THEN LET m$="TZX"
4120 IF mode=11 THEN LET m$="TAP (USR 0 - PI Audio)"
4130 IF mode=12 THEN LET m$="TZX (USR 0)"
4140 IF mode=13 THEN LET m$="TAP (PI Audio - Next)"
4150 IF mode=14 THEN LET m$="TZX (Next)"
4160 IF mode=15 THEN LET m$="NEX"
4170 IF mode=16 THEN LET m$="Snapshot"
4180 IF mode=17 THEN LET m$="Z-Machine Program"
4190 IF mode=18 THEN LET m$="3DOS (128K)"
4200 IF mode=19 THEN LET m$="TAP (48K)"
4210 IF mode=20 THEN LET m$="TZX (48K - Fast)"
4220 IF mode=21 THEN LET m$="TAP (PI Audio - 48K)"
4230 IF mode=22 THEN LET m$="TZX (48K)"
4240 IF mode=23 THEN LET m$="TAP (LOAD CODE)"
4250 IF mode=24 THEN LET m$="TZX (LOAD CODE - Fast)"
4260 IF mode=25 THEN LET m$="TAP (LOAD CODE - USR 0)"
4270 IF mode=26 THEN LET m$="TZX (LOAD CODE - USR0 - Fast)"
4280 IF mode=27 THEN LET m$="TAP (LOAD CODE - USR 0 - PI Audio)"
4290 IF mode=28 THEN LET m$="TZX (LOAD CODE - USR 0)"
4300 IF mode=29 THEN LET m$="TAP (LOAD CODE - 48K)"
4310 IF mode=30 THEN LET m$="TZX (LOAD CODE - 48K - Fast)"
4320 IF mode=31 THEN LET m$="TAP (LOAD CODE - PI Audio - 48K)"
4330 IF mode=32 THEN LET m$="TZX (LOAD CODE - 48K)"
4390 IF a$<>" " AND covers=1 THEN GO TO 4500

4395 ; Text Data
4400 LAYER 2,0:LAYER 0
4420 OPEN # 5,"w>0,12,24,20,4":PRINT #5;INK papel;PAPER tinta;CHR$ 14:CLOSE # 5
4430 OPEN # 5,"w>1,13,22,18,4":PRINT #5;INK papel;PAPER tinta;CHR$ 14
4440 PRINT #5;AT 3,1;"NAME: ";z$(pos)
4450 PRINT #5;AT 5,1;"MODE: ";m$
4460 PRINT #5;AT 9,1;"FILE: ":PRINT #5;AT 11,0;x$(pos)
4470 PRINT #5;AT 13,1;"COVER: ":PRINT #5;AT 15,0;b$(pos)
4490 CLOSE # 5:RETURN

4495 ; Image Data (Cover)
4500 ON ERROR LOAD q$:GO TO 4400:ON ERROR
4510 LET l$=a$:LET a$=w$(pos):GO SUB 5300:IF a$(LEN a$ TO LEN a$)="/" THEN LET a$=a$(1 TO LEN a$-1)
4520 IF a$<>"" AND a$(LEN a$ TO LEN a$)="." THEN LET a$(LEN a$ TO LEN a$)="_":IF a$="_" THEN LET a$=" "
4530 LET c$=y$:LET v$="C:":IF c$(2 TO 2)=":" THEN LET v$=c$(1 TO 2):LET c$=c$(3 TO LEN c$)
4535 LOAD v$:IF c$(LEN c$ TO LEN c$)<>"/" THEN LET c$=c$+"/"
4540 LET c$=c$+a$+"/"+l$:LET l$=l$((LEN l$-2) TO LEN l$):LET a$=c$
4550 IF l$="BMP" OR l$="bmp" THEN PRINT #6;CHR$ 2;:LAYER 2,0:.$ bmpload a$:LAYER 2,1:LAYER 0:PRINT #6;CHR$ 3
4560 IF l$="SCR" OR l$="scr" THEN PRINT #6;CHR$ 2;:LAYER 2,0:LAYER 0:LOAD a$ SCREEN$:PRINT #6;CHR$ 3
4570 IF l$="SLR" OR l$="slr" THEN PRINT #6;CHR$ 2;:LAYER 2,0:LAYER 1,0:LOAD a$ LAYER:LAYER 0:PRINT #6;CHR$ 3
4580 IF l$="SHR" OR l$="shr" THEN PRINT #6;CHR$ 2;:LAYER 2,0:LAYER 1,1:LOAD a$ LAYER:LAYER 0:PRINT #6;CHR$ 3
4590 IF l$="SHC" OR l$="shc" THEN PRINT #6;CHR$ 2;:LAYER 2,0:LAYER 1,2:LOAD a$ LAYER:LAYER 0:PRINT #6;CHR$ 3
4600 IF l$="SL2" OR l$="sl2" THEN PRINT #6;CHR$ 2;:LAYER 2,0:LOAD a$ LAYER:LAYER 2,1:LAYER 0:PRINT #6;CHR$ 3
4610 LOAD q$:RETURN

4895 ; Load Cache from Disk
4900 ON ERROR GO SUB 6000:ON ERROR
4910 LOAD"C:/tmp/knloader/cache13"BANK 13
4920 LET maxpag=%BANK 13 DPEEK 16252:LET maxpos=%BANK 13 PEEK 16254
4930 LET y$=BANK 13 PEEK$(16255,~0)
4940 IF y$(LEN y$ TO LEN y$)="/" AND LEN y$>1 THEN LET y$=y$(1 TO LEN y$-1)
4950 LET bnk=13+INT((maxpag*22+maxpos)/74):LET p=PEEK 23401:IF bnk>p THEN GO TO 6700
4960 IF bnk>13 THEN FOR p=14 TO bnk:LOAD"C:/tmp/knloader/cache"+STR$ p BANK p:NEXT p
4970 DIM z$(22,22):DIM o(22):DIM w$(22,maxpath):DIM x$(22,maxpath):DIM b$(22,maxpath)
4980 RETURN

4995 ; Load Options
5000 ON ERROR GO SUB 5200:ON ERROR
5010 DIM p(7)
5020 LOAD "opts.tmp"DATA p()
5030 LET tinta=p(1):LET papel=p(2):LET %p=p(3):LET autosave=p(4)
5040 IF %q=2 THEN GO TO 5070:;Hard Reset
5050 IF autosave=1 THEN LET covers=p(5):LET pos=p(6):LET pag=p(7)
5060 IF pag>maxpag OR (pag=maxpag AND pos>maxpos) THEN LET pag=0:LET pos=1
5070 RETURN

5095 ; Load from RAM Cache
5100 LET %n=pag:LET %j=%(22*n)MOD 74*219:LET %k=13+INT(22*pag/74):LET a=22:IF pag=maxpag THEN LET a=maxpos
5110 FOR p=1 TO a:LET z$(p)=BANK %k PEEK$(%j,~0):LET o(p)=%BANK k PEEK (j+23):LET w$(p)=BANK %k PEEK$(%(j+24),~0)
5120 LET x$(p)=BANK %k PEEK$(%(j+89),~0):LET b$(p)=BANK %k PEEK$(%(j+154),~0):LET %j=%j+219:IF %j>16205 THEN LET %k=%k+1:LET %j=0
5130 NEXT p:IF a<22 THEN FOR p=a+1 TO 22:LET z$(p)="":NEXT p
5160 RETURN

5195 ; Save Options
5200 ON ERROR PRINT "Error saving options!!":ERROR TO e:PRINT e:PAUSE 0:ON ERROR:STOP
5210 DIM p(7)
5220 LET p(1)=tinta:LET p(2)=papel:LET p(3)=%p:LET p(4)=autosave:LET p(5)=covers:LET p(6)=pos:LET p(7)=pag
5230 SAVE "opts.tmp"DATA p()
5240 RETURN

5295 ; Strip Spaces from a$
5300 LET m=1:FOR p=1 TO LEN (a$):IF a$(p TO p)<>" " THEN LET m=p
5310 NEXT p
5320 LET a$=a$(1 TO m)
5330 RETURN

5395 ; Split a$ into a$ and l$, using ":"
5400 LET v=1:FOR x=1 TO LEN a$:IF a$(x TO x)=":" THEN LET v=x
5410 NEXT x:LET l$=""
5420 IF a$(v TO v)<>":" THEN GO TO 5490
5430 IF v=LEN a$ THEN GO TO 5450
5440 LET l$=a$(v+1 TO LEN a$):IF v=1 THEN LET a$="":GO TO 5490
5450 LET a$=a$(1 TO v-1)
5490 RETURN

5995 ; Build Cache
6000 DIM d$(40):OPEN # 2,"v>d$":CAT "knloader.bdt":CLOSE # 2
6010 IF d$(1 TO 14)="No files found" THEN GO TO 6500
6020 ON ERROR GO TO 6040:ON ERROR
6030 MKDIR "C:/tmp/knloader"
6040 ON ERROR PRINT "Cache Build Error!!":ERROR TO e,l:PRINT e,l:PAUSE 0:ON ERROR:STOP
6050 LET %n=0:LET f=0:LET %f=0:LET pag=0:PRINT AT 20,12;"BUILDING CACHE: 0%"
6060 OPEN # 4,"knloader.bdt":DIM #4 TO %g:CLOSE # 4:BANK 12 ERASE 10:LOAD "knloader.bdt" BANK 12:IF %g>16384 THEN GO TO 6600
6070 LET %k=13:BANK 14 ERASE 0:LET %j=0:;Current Bank, Current Base Address
6080 LET lp=1:LET cn=1
6090 LET m$=BANK 12 PEEK$(%f,~10):LET %c=LEN m$:IF %c=0 THEN LET %f=%f+c+1:LET %n=%n-1:GO TO 6300
6100 IF CODE m$(LEN m$ TO LEN m$)=13 THEN LET m$=m$(1 TO LEN m$-1):LET %c=LEN m$:IF %c=0 THEN LET %f=%f+c+1:LET %n=%n-1:GO TO 6300
6110 LET %f=%f+c+1:IF %n=0 THEN LET y$=m$:GO TO 6300
6120 FOR %a=1 TO %c:LET ln=%a:LET c$=m$(ln TO ln):LET %b=CODE c$:IF %b=13 THEN GO TO 6230
6130 IF c$<>"," THEN GO TO 6230
6140 LET l$="":IF ln>cn THEN LET l$=m$(cn TO ln-1):LET cn=ln+1
6150 IF LEN l$>maxpath THEN LET l$=l$(1 TO maxpath)
6160 LET a$=l$:IF LEN a$>22 THEN LET a$=a$(1 TO 22)
6170 IF lp=1 THEN BANK 14 POKE %j,a$:IF a$="" THEN IF %f<=g THEN GO TO 6090
6180 IF lp=2 THEN BANK 14 POKE %(j+23),VAL l$
6190 IF lp=3 THEN BANK 14 POKE %(j+24),l$
6200 IF lp=4 THEN BANK 14 POKE %(j+89),l$
6210 IF lp=5 THEN BANK 14 POKE %(j+154),l$
6220 LET lp=lp+1
6230 NEXT %a:IF ln<=cn THEN GO TO 6260
6240 LET l$=m$(cn TO ln):IF lp=4 THEN BANK 14 POKE %(j+89),l$
6250 IF lp=5 THEN BANK 14 POKE %(j+154),l$
6260 LET %j=%j+219:IF %j<16206 THEN GO TO 6300
6270 IF %k=13 THEN BANK 14 COPY TO 13:GO TO 6290
6280 LET bnk=%k:SAVE"C:/tmp/knloader/cache"+STR$ bnk BANK 14
6290 LET %k=%k+1:LET %j=0:BANK 14 ERASE 0
6300 IF %f>=g THEN GO TO 6330
6310 LET %n=%n+1:IF %n<23 THEN GO TO 6080
6320 IF %n<23 THEN LET a$=BANK 14 PEEK$(%j,~0):IF a$="" THEN LET %n=%n-1
6330 PRINT AT 20,12;"BUILDING CACHE:";%(10*f/g*10);"%":IF %f<g THEN LET pag=pag+1:LET %n=1:GO TO 6080
6340 PRINT AT 20,12;"                       ":LET maxpag=pag:LET maxpos=%n:IF maxpos=23 THEN LET maxpos=22
6350 IF %k>13 THEN LET bnk=%k:SAVE"C:/tmp/knloader/cache"+STR$ bnk BANK 14
6360 IF %k=13 THEN BANK 14 COPY TO 13
6370 BANK 13 DPOKE 16252,maxpag:BANK 13 POKE 16254,maxpos:IF CODE y$(LEN y$ TO LEN y$)=13 THEN LET y$=y$(1 TO LEN y$-1)
6380 BANK 13 POKE 16255,y$:SAVE"C:/tmp/knloader/cache13" BANK 13:BANK 13 CLEAR:BANK 14 CLEAR:LET pag=0:LET pos=1:BANK 12 CLEAR:RETURN

6495 ; Database Not Found
6500 CLS:PRINT AT 2,2;INK 6;PAPER 2;" ERROR:  Database Not Found "
6510 PRINT AT 5,1;"A file named ";INK 6;"knloader.bdt";INK papel;" must"
6520 PRINT AT 6,0;"exist in the same folder where"
6530 PRINT AT 7,0;"knloader.bas and knlauncher are"
6540 PRINT AT 8,0;"installed."
6550 PRINT AT 12,1;" Please read the installation"
6560 PRINT AT 13,0;"guide for more information."
6590 PAUSE 0:PAPER op:BORDER ob:INK oi:RUN AT %s:STOP

6595 ; Database Too Big
6600 CLS:PRINT AT 2,2;INK 6;PAPER 2;" ERROR: BDT File is Too Big "
6610 PRINT AT 5,1;"The file ";INK 6;"knloader.bdt";INK papel;" is too"
6620 PRINT AT 6,0;"large: ";INK 2;%g;" bytes"
6630 PRINT AT 8,1;"The maximum is 16384 bytes."
6640 PRINT AT 11,1;"Please use a smaller file or"
6650 PRINT AT 12,0;"build the cache with an external"
6660 PRINT AT 13,0;"program."
6670 PRINT AT 15,1;" Read the user guide for more"
6680 PRINT AT 16,0;"information."
6690 PAUSE 0:PAPER op:BORDER ob:INK oi:RUN AT %s:STOP

6695 ; Not enough RAM
6700 CLS:PRINT AT 2,3;INK 6;PAPER 2;" ERROR: Not enough memory "
6710 PRINT AT 5,1;"Too much cache data for current"
6720 PRINT AT 6,0;"configuration. ";INK 6;bnk;INK papel;" memory banks"
6730 PRINT AT 7,0;"are needed, but the maximum"
6740 PRINT AT 8,0;"is ";p;"."
6750 PRINT AT 11,1;"Please use a smaller cache or,"
6760 PRINT AT 12,0;"if possible, expand the physical"
6770 PRINT AT 13,0;"RAM."
6790 PAUSE 0:PAPER op:BORDER ob:INK oi:RUN AT %s:STOP

6995 ; Default Config
7000 ON ERROR RUN AT %s:ERASE
7010 LET tinta=0:LET papel=7:LET ob=7:LET op=7:LET oi=0:LET %p=8:LET pos=1:LET pag=0:LET maxpag=0:LET maxpos=1:LET maxpath=64
7020 LET covers=1:LET autosave=0:DIM d$(255):OPEN # 2,"v>d$":PWD #2:CLOSE # 2
7030 LET a$=d$:GO SUB 5300:LET p$=a$(3 TO LEN a$-1):LET q$=a$(1 TO 2):;My Path
7040 DIM d$(255):OPEN # 2,"v>d$":.NEXTVER -v:CLOSE # 2:LET a=VAL(d$):GO SUB 5300:PRINT a
7050 IF a>2.05 THEN RETURN
7060 CLS:PRINT AT 5,3;INK 6;PAPER 2;" ERROR:  NextZXOS Too Old "
7070 PRINT AT 8,1;"Please upgrade the distribution"
7080 PRINT AT 9,0;"in your SD Card to version ";BRIGHT 1;"1.3.2"
7090 PRINT AT 10,0;"or later."
7100 PAUSE 0:PAPER op:BORDER ob:INK oi:RUN AT %s:STOP
