#program autoexec 
#autostart 50
  10 ; knloader autoexec - Copyright (c) 2020 @kounch
  20 ; This program is free software, you can redistribute
  30 ; it and/or modify it under the terms of the
  40 ; GNU General Public License

  50 LET %s=%REG 7&3:RUN AT 2
  60 CLS:ON ERROR RUN AT %s:ERASE
  70 LET J=IN 31:LET K$=INKEY$:IF (J<>0 AND J<>255) OR K$<>"" THEN GO TO 120
  80 ON ERROR GO TO 100:ON ERROR
  90 LOAD "C:":CD "/Aplicaciones/knloader":RUN AT %s:LOAD "knloader.bas"
 100 ON ERROR RUN AT %s:ERASE
 110 LOAD "D:":CD "/Aplicaciones/knloader":RUN AT %s:LOAD "knloader.bas"
 120 IF K$=" " OR J=32 THEN RUN AT %s:ERASE
 130 IF K$<>"t" AND K$<>"T" AND J<>64 THEN GO TO 170
 140 CLS:PRINT AT 6,12;"NTP..."
 150 .nxtp time.nxtel.org 12300 -z=RomanceStandardTime
 160 PRINT AT 6,12;"NTP OK!":GO TO 60
 170 IF K$="a" OR K$="A" OR J=16 THEN LOAD "C:":CD "/":RUN AT %s:LOAD "/nextzxos/autoexec.old"
 180 IF K$<>"d" AND K$<>"D" THEN GO TO 210
 190 CLS:PRINT AT 6,12;"WiFi Off":REG 2,128
 200 IF INKEY$<>"" THEN GO TO 200
 210 GO TO 60

 990 SAVE "autoexec.bas"LINE 50
