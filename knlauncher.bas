#program knlauncher
#autostart
  10 ; knlauncher - Copyright (c) 2020 @kounch
  20 ; This program is free software, you can redistribute
  30 ; it and/or modify it under the terms of the
  40 ; GNU General Public License

  50 LET %s=%REG 7&3:RUN AT 2
  60 ON ERROR PRINT "ERROR":ERROR TO e,l:PRINT e,l:PAUSE 0:RUN AT %s:FOR %a=0 TO 15:CLOSE # %a:NEXT %a:ERASE:ON ERROR
  70 LAYER CLEAR:SPRITE CLEAR:PALETTE CLEAR:PAPER 7:BORDER 7:INK 0:CLS
  80 OPEN # 6,"w>22,1,1,32,4":PRINT #6;AT 0,0;">> knlauncher v0.11 >> (c) kounch 2020":CLOSE # 6
  90 LET x=USR 5808:LOAD "c:/nextzxos/usr0.bin"CODE 32768

 200 ; Load Options
 210 DIM o$(255):OPEN # 2,"v>o$":PWD #2:CLOSE # 2
 220 LET a$=o$:GO SUB 5200:LET p$=a$(3 TO LEN a$-1):LET q$=a$(1 TO 2):;My Path
 230 LOAD "m:klo.tmp"DATA o()
 240 LOAD "m:kls.tmp"DATA o$()
 250 mode=o(1)
 260 LET a$=o$(1):GO SUB 5200:LET y$=a$
 270 LET a$=o$(2):GO SUB 5200:LET c$=a$
 280 LET a$=o$(3):GO SUB 5200

 300 IF c$<>" " THEN LET y$=y$+"/"+c$
 310 CD y$

 320 PRINT AT 1,1;a$

 345 ; Select Mode
 350 IF mode=0 THEN GO TO 1000:;3DOS (Next)
 360 IF mode=1 THEN GO TO 1100:;TAP (128K)
 370 IF mode=2 THEN LET %s=2:LET t$="tzx":GO TO 1200:;TZX (Fast)
 380 IF mode=3 THEN LET a$=a$+":*":GO TO 1300:;DSK (AUTOBOOT)
 390 IF mode=4 THEN GO TO 1400:;TAP (USR 0)
 400 IF mode=5 THEN LET %s=2:LET t$="tzx":GO TO 1500:;TZX (USR0 - Fast)
 410 IF mode=6 THEN GO TO 1600:;TAP (Next)
 420 IF mode=7 THEN LET %s=2:LET t$="tzx":GO TO 1700:;TZX (Next - Fast)
 430 IF mode=8 THEN GO TO 1300:;DSK (Custom Boot)
 440 IF mode=9 THEN LET t$="tap":GO TO 1200:;TAP (PI Audio)
 450 IF mode=10 THEN LET t$="tzx":GO TO 1200:;TZX
 460 IF mode=11 THEN LET t$="tap":GO TO 1500:;TAP (USR 0 - PI Audio)
 470 IF mode=12 THEN LET t$="tzx":GO TO 1500:;TZX (USR 0)
 480 IF mode=13 THEN LET t$="tap":GO TO 1700:;TAP (PI Audio - Next)
 490 IF mode=14 THEN LET t$="tzx":GO TO 1700:;TZX (Next)
 500 IF mode=15 THEN GO TO 1800:;NEX
 510 IF mode=16 THEN GO TO 1900:;Snapshot
 530 IF mode=17 THEN GO TO 2000:;Z-Machine Program
 540 IF mode=18 THEN GO TO 2100:;3DOS (128K)
 550 IF mode=19 THEN GO TO 2200:;TAP (48K)
 560 IF mode=20 THEN LET %s=2:LET t$="tzx":GO TO 2300:;TZX (48K - Fast)
 570 IF mode=21 THEN LET t$="tap":GO TO 2300:;TAP (Pi Audio 48K)
 580 IF mode=22 THEN LET t$="tzx":GO TO 2300:;TZX (48K)
 590 PRINT "ERROR: Unknown Mode":PAUSE 0:STOP

1000 ; Mode 3DOS (Next)
1010 GO SUB 5400:DIM o$(1,LEN a$):LET o$(1)=a$:SAVE "m:kl99.tmp"DATA o$()
1020 LAYER CLEAR:SPRITE CLEAR:PALETTE CLEAR:RUN AT %s:CLEAR
1030 LOAD "m:kl99.tmp"DATA o$():LET a$=o$(1):LOAD a$
1090 STOP

1100 ; Mode TAP (128K)
1110 GO SUB 5400:.$ tapein a$:LET m4=0:GO SUB 5500:CLEAR:SPECTRUM LOAD
1190 STOP

1200 ; Mode PI Audio (128K)
1210 GO SUB 5400:GO SUB 5600:LET m4=0:GO SUB 5500:CLEAR:SPECTRUM LOAD
1290 STOP

1300 ; Mode DSK obtained from mounter.bas
1310 GO SUB 5300:DIM o$(1,LEN d$):LET o$(1)=d$:SAVE "m:kl99.tmp" DATA o$()
1315 GO SUB 5400:LET m4=0:GO SUB 5500
1320 MOVE "A:"OUT:MOVE "A:" IN a$
1330 CLEAR:CD "A:":LOAD "m:kl99.tmp"DATA o$():LET a$=o$(1)
1340 REG %$82,%REG $82&$fe:CLS:LOAD a$
1390 STOP

1400 ; Mode TAP (USR 0) obtained from tapload.bas
1410 GO SUB 5400:.$ tapein a$
1420 LET m4=0:GO SUB 5500:CLEAR:SPECTRUM:POKE 32768,0:LET x=USR 32769
1430 REM LET m4=0:GO SUB 5500:SPECTRUM:POKE 32768,0:LET x=USR 32769:;LOAD "" CODE
1490 STOP

1500 ; Mode PI Audio (USR 0) obtained from tapload.bas and tzxload.bas
1510 GO SUB 5400:GO SUB 5600:LET m4=0:GO SUB 5500
1520 CLEAR:SPECTRUM:POKE 32768,0:LET x=USR 32769
1530 REM SPECTRUM:POKE 32768,1:LET x=USR 32769:;LOAD "" CODE
1590 STOP

1600 ; Mode TAP (Next)
1610 GO SUB 5400:.$ tapein a$
1620 LAYER CLEAR:SPRITE CLEAR:PALETTE CLEAR:RUN AT %s:CLEAR
1630 DPOKE %$5c76,0:LOAD "t:":POKE 33792,0:CLEAR USR 33793
1640 REM DPOKE %$5c76,0:LOAD "t:":POKE 33792,1:CLEAR USR 33793:;LOAD "" CODE
1690 STOP

1700 ; Mode PI Audio (Next)
1710 GO SUB 5400: GO SUB 5600
1720 LAYER CLEAR:SPRITE CLEAR:PALETTE CLEAR:RUN AT %s:CLEAR
1730 DPOKE %$5c76,0:LOAD "t:":POKE 33792,0:CLEAR USR 33793
1740 REM DPOKE %$5c76,0:LOAD "t:"POKE 33792,1:CLEAR USR 33793:;LOAD "" CODE
1790 STOP

1800 ; Mode NEX
1810 GO SUB 5400:DIM o$(1,LEN a$):LET o$(1)=a$:SAVE "m:kl99.tmp"DATA o$()
1820 LAYER CLEAR:SPRITE CLEAR:PALETTE CLEAR:RUN AT %s:CLEAR
1830 LOAD "m:kl99.tmp"DATA o$():LET a$=o$(1):.$ nexload a$
1890 STOP

1900 ; Mode Snapshot
1910 GO SUB 5400:DIM o$(1,LEN a$):LET o$(1)=a$:SAVE "m:kl99.tmp"DATA o$()
1920 LAYER CLEAR:SPRITE CLEAR:PALETTE CLEAR:RUN AT %s:CLEAR
1930 LOAD "m:kl99.tmp"DATA o$():LET a$=o$(1):CLS:SPECTRUM a$
1990 STOP

2000 ; Z-Machine Program
2010 GO SUB 5400:DIM o$(1,LEN y$+LEN a$+1):LET o$(1)=y$+"/"+a$:SAVE "m:kl99.tmp"DATA o$()
2020 LAYER CLEAR:SPRITE CLEAR:PALETTE CLEAR
2030 RUN AT 2:LOAD q$:CD p$
2040 CLEAR:LOAD "knzml"
2090 STOP

2100 ; Mode 3DOS (128K)
2110 GO SUB 5400:DIM o$(1,LEN a$):LET o$(1)=a$:SAVE "m:kl99.tmp"DATA o$()
2120 LAYER CLEAR:SPRITE CLEAR:PALETTE CLEAR:RUN AT %s:LET m4=0:GO SUB 5500:CLEAR
2130 LOAD "m:kl99.tmp"DATA o$():LET a$=o$(1):LOAD a$
2190 STOP

2200 ; Mode TAP (48K) obtained from tapload.bas
2210 GO SUB 5400:.$ tapein a$:LET m4=1:GO SUB 5500
2220 CLEAR:SPECTRUM 48:POKE 32768,0:LET x=USR 32769
2230 REM LET m4=1:GO SUB 5500:SPECTRUM 48:POKE 32768,0:LET x=USR 32769:;LOAD "" CODE
2290 STOP

2300 ; Mode PI Audio (48K) obtained from tapload.bas
2310 GO SUB 5400:GO SUB 5600:LET m4=1:GO SUB 5500
2320 CLEAR:SPECTRUM 48:POKE 32768,0:LET x=USR 32769
2330 REM SPECTRUM 48:POKE 32768,1:LET x=USR 32769:;LOAD "" CODE
2390 STOP

4995 ; SUBROUTINES

5195 ; Strip Spaces from a$
5200 LET m=1:FOR n=1 TO LEN (a$):IF a$(n TO n)<>" " THEN LET m=n
5210 NEXT n:LET a$=a$(1 TO m)
5290 RETURN

5295 ; Split a$ into a$ and d$, using ":"
5300 LET v=1:FOR x=1 TO LEN a$:IF a$(x TO x)=":" THEN LET v=x
5310 NEXT x:LET d$=""
5320 IF a$(v TO v)<>":" THEN GO TO 5390
5330 IF v=LEN a$ THEN GO TO 5350
5340 LET d$=a$(v+1 TO LEN a$):IF v=1 THEN LET a$="":GO TO 5390
5350 LET a$=a$(1 TO v-1)
5390 RETURN

5395 ; Get 8.3 Filename from a$ (find a$ in current dir)
5400 DIM d$(255):OPEN # 2,"v>d$":CAT -a$:CLOSE # 2:LET g$=d$(1 TO 12)
5410 LET a$="":FOR x=1 TO LEN g$:IF g$(x TO x)<>" " THEN LET a$=a$+g$(x TO x)
5420 NEXT x
5490 RETURN

5495 ; Mode 48k/128k obtained from tapload.bas
5500 LAYER CLEAR:SPRITE CLEAR:PALETTE CLEAR
5510 LET hwm=0:LET hwa=0:LET hwt=0:LET hw1=0:LET hw2=0:LET hwf=0:LET hwx=0:LET hwo=0:LET hwg=0
5520 LET hws=0:LET hwk=0:LET hwv=1:LET hwi=1:LET hwu=1:LET hwp=1:LET mp=0
5530 REG 130,218+(32*hwm)+(4*mp)+hwt:REG 131,(32*hwu)+(20*hwi)+(9*hwv)+2
5540 REG 132,(128*hws)+(64*hwg)+(32*hwo)+(16*hwx)+(8*hwf)+(4*hw2)+(2*hw1)+(hwa OR NOT m4)
5550 REG 133,254+hwp:LET %k=hwk:REG 8,%REG 8&@11111110|k
5560 RUN AT %s
5570 DPOKE %$5c76,0
5590 RETURN

5595 ; TZX/TAP PiSend obtained from tzxload.bas and tapload.bas
5600 LET %r=3
5610 .tapein -c
5620 OUT 5434,64:OUT 9275,162:OUT 9531,211:.pisend -q:PAUSE 5:CLS
5630 IF %REG 127=0 THEN GO TO 6000
5640 .$ pisend a$
5650 IF t$="tzx" THEN PAUSE 100:LET g$="-c printf ""\x14\x57\x03\xAE\x06\x08\x00\x00\x02\x00\x00\xFF\xFF"" > /ram/tzxfix.bin ; cat """+a$+""" /ram/tzxfix.bin > /ram/file.tzx"
5660 IF t$="tap" THEN PAUSE 100:LET g$="-c printf ""\x02\x00\xAA\x55"" > /ram/tapfix.bin ; cat """+a$+""" /ram/tapfix.bin > /ram/file.tap"
5670 .$ pisend g$
5680 PAUSE 50
5690 LET g$="-c tape2wav /ram/file."+t$+" /ram/out.wav"
5700 .$ pisend g$
5710 PAUSE 200
5720 LET v=%REG 17:RESTORE 5800
5730 FOR x=0 TO v:READ hertz:NEXT x
5740 LET ss=%1<< s:IF ss=8 THEN LET ss=6.57
5750 LET g$="-c play -r"+STR$ (ss*hertz)+" /ram/out.wav"
5760 PAUSE 100
5770 .$ pisend g$
5780 REG 162,211
5790 RETURN
5800 DATA 44100,45000,46406,47250,48825,50400,51975,42525

5995 ; Error with Pi
6000 CLS:PRINT AT 1,1;INK 6;PAPER 2;" Error: Can't connect with Pi "
6010 LET %r=%r-1:IF %r>0 THEN PRINT AT 4,1;"Please, wait for a few seconds":PRINT AT 6,2;"Then press any key to retry"
6020 LET J=IN 31:LET K$=INKEY$:IF K$="" AND J=0 THEN GO TO 6020
6030 IF %r>0 THEN GO TO 5610
6040 STOP
