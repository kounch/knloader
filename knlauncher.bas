#program knlauncher
#autostart
  10 ; knlauncher - Copyright (c) 2020 @kounch
  20 ; This program is free software, you can redistribute
  30 ; it and/or modify it under the terms of the
  40 ; GNU General Public License

  50 LET %s=% REG 7&3:RUN AT 2
  60 ON ERROR RUN AT %s:FOR %a=0 TO 15:CLOSE # %a:NEXT %a:ON ERROR:STOP:REM ERASE
  70 LAYER CLEAR:SPRITE CLEAR:PALETTE CLEAR:PAPER 7:BORDER 7:INK 0:CLS

  80 LET x=USR 5808
  90 LOAD "c:/nextzxos/usr0.bin"CODE 32768

 150 OPEN #6,"w>22,1,1,32,4":PRINT #6; AT 0,0;">> knlauncher v0.1 >> (c) kounch 2020":CLOSE #6

 200 ; Load Options
 210 LOAD "m:klo.tmp" DATA o()
 220 LOAD "m:kls.tmp" DATA o$()

 250 mode=o(1)
 260 LET a$=o$(1):GO SUB 5200:LET y$=a$
 270 LET a$=o$(2):GO SUB 5200:LET c$=a$
 280 LET a$=o$(3):GO SUB 5200

 300 LET y$=y$+"/"+c$:CD y$
 
 320 PRINT AT 1,1;a$

 350 IF mode=0 THEN GO TO 1000:;3DOS
 360 IF mode=1 THEN GO TO 1100:;TAP (128K)
 370 IF mode=2 THEN LET %s=2:GO TO 1200:;TZX (Fast)
 380 IF mode=3 THEN LET a$=a$+":*":GO TO 1300:;DSK (AUTOBOOT)
 390 IF mode=4 THEN GO TO 1400:;TAP (USR 0)
 400 IF mode=5 THEN LET %s=2:GO TO 1500:;TZX (USR0 - Fast)
 410 IF mode=6 THEN GO TO 1600:;TAP (Next)
 420 IF mode=7 THEN LET %s=2:GO TO 1700:;TZX (Next - Fast)
 430 IF mode=8 THEN GO TO 1300:;DSK (Custom Boot)
 440 IF mode=9 THEN GO TO 1800:;TAP (PI Audio)
 450 IF mode=10 THEN GO TO 1200:;TZX
 460 IF mode=11 THEN GO TO 1900:;TAP (USR 0 - PI Audio)
 470 IF mode=12 THEN GO TO 1500:;TZX (USR 0)
 480 IF mode=13 THEN GO TO 1700:;TZX (Next)

 500 STOP

 995 ; Mode 3DOS (128K)
1000 REM
1010 GO SUB 5400
1040 GO SUB 5500
1050 LOAD a$
1090 STOP

1100 ; Mode TAP (128K)
1110 GO SUB 5400:.$ tapein a$
1120 GO SUB 5500:CLEAR
1130 DPOKE %$5c76,0:SPECTRUM LOAD
1190 STOP

1200 ; Mode TZX (128K)
1210 GO SUB 5400
1220 GO SUB 5600
1230 GO SUB 5500
1240 DPOKE %$5c76,0
1250 CLEAR:SPECTRUM LOAD
1290 STOP

1300 ; Mode DSK obtained from mounter.bas
1310 GO SUB 5300
1320 GO SUB 5400
1330 GO SUB 5500
1340 MOVE "A:" OUT
1350 MOVE "A:" IN a$:DIM o$(1):LET o$(1)=d$:SAVE"m:kl99.tmp"DATA o$()
1360 CLEAR:CD "A:":DIM o$(1):LOAD"m:kl99.tmp"DATA o$():LET a$=o$(1)
1370 REG %$82,%REG $82&$fe:CLS:LOAD a$
1390 STOP

1400 ; Mode TAP (USR 0) obtained from tapload.bas
1410 GO SUB 5400:.$ tapein a$:CLOSE #4:OPEN #4,a$
1420 LET a$=INKEY$ #4+INKEY$ #4+INKEY$ #4:LET %z=CODE INKEY$ #4
1430 FOR %a=0 TO 15:CLOSE # %a:NEXT %a:DIM o(1):LET o(1)=%z:SAVE"m:kl99.tmp"DATA o()
1450 GO SUB 5500:CLEAR:DIM o(1):LOAD"m:kl99.tmp"DATA o():LET z=o(1)
1460 SPECTRUM:POKE 32768,z:LET x=USR 32769
1470 POKE 33792,z:CLEAR USR 33793
1490 STOP

1500 ; Mode TZX (USR 0) obtained from tzxload.bas
1510 GO SUB 5400:CLOSE #4:OPEN #4,a$
1520 LET a$=INKEY$ #4+INKEY$ #4+INKEY$ #4:LET %z=CODE INKEY$ #4
1530 FOR %a=0 TO 15:CLOSE # %a:NEXT %a:DIM o(1):LET o(1)=%z:SAVE"m:kl99.tmp"DATA o()
1550 GO SUB 5600:GO SUB 5500:CLEAR:DIM o(1):LOAD"m:kl99.tmp"DATA o():LET z=o(1)
1560 SPECTRUM:POKE 32768,z:LET x=USR 32769
1570 POKE 33792,z:CLEAR USR 33793
1590 STOP

1600 ; Mode TAP (Next) obtained from tapload.bas
1690 STOP

1700 ; Mode TZX (Next) obtained from tzxload.bas
1790 STOP

1800 ; Mode TAP (PI Audio) obtained from tapload.bas
1890 STOP

1900 ; Mode TAP (USR 0 - PI Audio) obtained from tapload.bas
1990 STOP

4995 ; SUBROUTINES

5195 ; Strip Spaces from a$
5200 LET m=1: FOR n=1 TO LEN (a$):IF a$(n TO n) <> " " THEN LET m=n
5210 NEXT n:LET a$=a$(1 TO m)
5290 RETURN

5295 ; Split a$ into a$ and d$, using ":"
5300 LET v=0:FOR x=0 TO LEN a$:IF a$(x TO x)=":" THEN LET v=x
5310 NEXT x:LET d$=""
5320 IF a$(v TO v)<>":" THEN GO TO 5390
5330 IF v=LEN a$ THEN GO TO 5350
5340 LET d$=a$(v+1 TO LEN a$):IF v=1 THEN LET a$="":GO TO 5390
5350 LET a$=a$(1 TO v-1)
5390 RETURN

5395 ; Get 8.3 Filename from a$ (find a$ in current dir)
5400 IF LEN(a$)<13 THEN RETURN
5410 DIM d$(40):OPEN #2,"v>d$":CAT - a$:CLOSE #2:LET a$=d$(1 TO 12)
5490 RETURN

5495 ; Mode 128k obtained from tapload.bas
5500 LAYER CLEAR:SPRITE CLEAR:PALETTE CLEAR
5510 LET hwm=0:LET hwa=0:LET hwt=0:LET hw1=0:LET hw2=0:LET hwf=0:LET hwx=0:LET hwo=0:LET hwg=0
5520 LET hws=0:LET hwk=0:LET hwv=1:LET hwi=1:LET hwu=1:LET hwp=1:LET mn=0:LET mp=0:LET m4=0
5530 REG 130,218+(32*hwm)+(4*mp)+hwt:REG 131,(32*hwu)+(20*hwi)+(9*hwv)+2
5540 REG 132,(128*hws)+(64*hwg)+(32*hwo)+(16*hwx)+(8*hwf)+(4*hw2)+(2*hw1)+(hwa OR NOT m4)
5550 REG 133,254+hwp:LET %k=hwk:REG 8,%REG 8&@11111110|k
5570 RUN AT %s
5590 RETURN

5596 ; TZX PiSend obtained from tzxload.bas
5600 .tapein -c
5610 OUT 5434,64:OUT 9275,162:OUT 9531,211:.pisend -q:PAUSE 5:CLS
5620 IF %REG 127=0 THEN GO TO %6000
5630 .$ pisend a$
5640 PAUSE 100:LET g$="-c printf ""\x14\x57\x03\xAE\x06\x08\x00\x00\x02\x00\x00\xFF\xFF"" > /ram/tzxfix.bin ; cat """+a$+""" /ram/tzxfix.bin > /ram/file.tzx"
5650 .$ pisend g$
5660 PAUSE 50
5670 LET g$="-c tape2wav /ram/file.tzx /ram/out.wav"
5680 .$ pisend g$
5690 PAUSE 200
5710 LET v=%REG 17:RESTORE 5800
5720 FOR x=0 TO v:READ hertz:NEXT x
5730 LET ss=%1<< s:IF ss=8 THEN LET ss=6.57
5740 LET g$="-c play -r"+STR$ (ss*hertz)+" /ram/out.wav"
5750 PAUSE 100
5760 .$ pisend g$
5770 REG 162,211
5790 RETURN
5800 DATA 44100,45000,46406,47250,48825,50400,51975,42525

5995 ; Error with Pi
6000 CLS:PRINT AT 0,0;"Error communicating with Pi":STOP
