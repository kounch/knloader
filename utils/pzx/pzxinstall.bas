#program pzxinstall
#autostart
  10 ; PZX Installer - Copyright (c) 2021 @kounch
  20 ; This program is free software, you can redistribute
  30 ; it and/or modify it under the terms of the
  40 ; GNU General Public License

  50 LET %s=%REG 7&3:RUN AT 3:LET %q=%REG 2&3
  60 ON ERROR PRINT "ERROR":ERROR TO e,l:PRINT e,l:PAUSE 0:FOR %a=0 TO 15:CLOSE # %a:NEXT %a:PAPER 7:BORDER 7:INK 0:RUN AT %s:ERASE:ON ERROR
  70 LAYER CLEAR:SPRITE CLEAR:PALETTE CLEAR:PAPER 1:BORDER 1:INK 7:CLS
  80 PRINT AT 1,4;"> pzx Installer v0.1.0 <":PRINT AT 21,18;"© kounch 2021"
  
  95 ; Draw Disclaimer
 100 BORDER 0:PAPER 7:INK 0:OPEN # 6,"w>3,1,17,30,4"
 110PRINT #6;INK 0;PAPER 7;CHR$ 14:; Clear Window
 120 PRINT #6;AT 2,1;"This program installs or uninstalls to NextPI the file:"
 130 PRINT #6;AT 4,3;"/NextPi/nextpi/pzx2wav"
 140 PRINT #6;AT 8,1;"Please, see NextPI official documentation for more info."
 150 PRINT #6;AT 11,3;"PZX->WAV convertor Copyright (C) 2007 Patrik Rak"
 160 PRINT #6;AT 15,17;"- Press any key to continue -"
 165 ; Wait for Key
 170 LET K$=INKEY$:IF K$<>"" THEN GO TO 190
 180 GO TO 170
 190 CLOSE # 6:BEEP 0.008,-20
 
 195 ; Draw Disclaimer
 200 BORDER 2:PAPER 1:INK 6:OPEN # 6,"w>3,1,17,30,4"
 210 PRINT #6;INK 6;PAPER 1;CHR$ 14:; Clear Window
 220 PRINT #6;AT 4,20;"Press (i) to install"
 230 PRINT #6;AT 6,19;"Press (u) to uninstall"
 240 PRINT #6;AT 12,16;"Press any other key to exit."
 
 245 ; Wait for Key
 250 LET K$=INKEY$:IF K$<>"" THEN GO TO 250
 260 LET K$=INKEY$:IF K$<>"" THEN GO TO 280
 270 GO TO 260
 280 CLOSE # 6:BEEP 0.008,-20
 290 IF K$="I" OR K$="i" THEN GO TO 400
 300 IF K$="U" OR K$="u" THEN GO TO 450
 350 LAYER CLEAR:SPRITE CLEAR:PALETTE CLEAR:PAPER 7:BORDER 7:INK 0:RUN AT %s:ERASE
 390 STOP
 
 400 LET %r=3:PROC installtopi()
 410 ; PROC installtosd()
 420 BORDER 0:CLS:PRINT AT 10,5;"Installation finished"
 430 LET K$=INKEY$:IF K$="" THEN GO TO 430
 440 LAYER CLEAR:SPRITE CLEAR:PALETTE CLEAR:PAPER 7:BORDER 7:INK 0:RUN AT %s:ERASE
 
 450 LET %r=3:PROC uninstallonpi()
 460 ; PROC uninstallonsd()
 470 BORDER 0:CLS:PRINT AT 10,7;"Finished Uninstall":PAUSE 0
 480 LET K$=INKEY$:IF K$="" THEN GO TO 430
 490 LAYER CLEAR:SPRITE CLEAR:PALETTE CLEAR:PAPER 7:BORDER 7:INK 0:RUN AT %s:ERASE

 495 DEFPROC installtopi()
 500 BORDER 1:PAPER 1:INK 6:CLS
 510 OUT 5434,64:OUT 9275,162:OUT 9531,211:.pisend -q:PAUSE 5:CLS
 520 IF %REG 127=0 THEN GO TO %580
 530 .$ pisend pzx2wav
 540 PAUSE 100:LET g$="-c mv -f pzx2wav /NextPi/nextpi/pzx2wav"
 550 .$ pisend g$
 560 PAUSE 100
 570 ENDPROC
 580 ; Error with Pi
 590 CLS:PRINT AT 1,1;INK 6;PAPER 2;" Error: Can't connect with Pi "
 600 LET %r=%r-1:IF %r>0 THEN PRINT AT 4,1;"Please, wait for a few seconds":PRINT AT 6,2;"Then press any key to retry"
 610 LET K$=INKEY$:IF K$="" THEN GO TO 610
 620 IF %r>0 THEN GO TO 500
 630 LAYER CLEAR:SPRITE CLEAR:PALETTE CLEAR:PAPER 7:BORDER 7:INK 0:RUN AT %s:ERASE

 635 DEFPROC installtosd()
 640 BORDER 1:PAPER 1:INK 6:CLS
 650 COPY "pzxload.bas" TO "c:/nextzxos/pzxload.bas"
 660 ENDPROC
 
 695 DEFPROC uninstallonpi()
 700 BORDER 1:PAPER 1:INK 6:CLS
 710 OUT 5434,64:OUT 9275,162:OUT 9531,211:.pisend -q:PAUSE 5:CLS
 720 IF %REG 127=0 THEN GO TO %770
 730 PAUSE 100:LET g$="-c rm -f /NextPi/nextpi/pzx2wav"
 740 .$ pisend g$
 750 PAUSE 100
 760 ENDPROC
 770 ; Error with Pi
 780 CLS:PRINT AT 1,1;INK 6;PAPER 2;" Error: Can't connect with Pi "
 790 LET %r=%r-1:IF %r>0 THEN PRINT AT 4,1;"Please, wait for a few seconds":PRINT AT 6,2;"Then press any key to retry"
 800 LET K$=INKEY$:IF K$="" THEN GO TO 800
 810 IF %r>0 THEN GO TO 700
 820 LAYER CLEAR:SPRITE CLEAR:PALETTE CLEAR:PAPER 7:BORDER 7:INK 0:RUN AT %s:ERASE

 825 DEFPROC uninstallonsd()
 830 BORDER 1:PAPER 1:INK 6:CLS
 840 ERASE "c:/nextzxos/pzxload.bas"
 850 ENDPROC

 999 STOP
9999 SAVE "c:\pzxinstall.bas" LINE 10
