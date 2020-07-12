#program autoexec 
#autostart 50
  10 ; knloader autoexec - Copyright (c) 2020 @kounch
  20 ; This program is free software, you can redistribute
  30 ; it and/or modify it under the terms of the
  40 ; GNU General Public License

  50 LET %s=%REG 7&3:RUN AT 2
  60 CLS:ON ERROR RUN AT %s:ERASE
  70 LET J=IN 31:LET K$=INKEY$:IF J<>0 OR K$<>"" THEN GO TO 90
  80 LOAD "C:":CD "/knloader":RUN AT %s:LOAD "knloader.bas"
  90 IF K$=" " OR J=32 THEN RUN AT %s:ERASE
 100 IF K$<>"t" AND K$<>"T" AND J<>64 THEN GO TO 140
 110 CLS:PRINT AT 6,12;"NTP..."
 120 .nxtp time.nxtel.org 12300 -z=RomanceStandardTime
 130 PRINT AT 6,12;"NTP OK!":GO TO 60
 140 IF K$="a" OR K$="A" OR J=16 THEN LOAD "C:":CD "/":RUN AT %s:LOAD "/nextzxos/autoexec.bas.bak"
 150 IF K$<>"d" AND K$<>"D" THEN GO TO 180
 160 CLS:PRINT AT 6,12;"WiFi Off":REG 2,128
 170 IF INKEY$<>"" THEN GO TO 170
 180 GO TO 60

 990 SAVE "autoexec.bas"LINE 50
