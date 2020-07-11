#program autoexec 
#autostart 50
  10 ; knloader autoexec - Copyright (c) 2020 @kounch
  20 ; This program is free software, you can redistribute
  30 ; it and/or modify it under the terms of the
  40 ; GNU General Public License

  50 CLS:ON ERROR ERASE
  60 LET J=IN 31:LET K$=INKEY$:IF J<>0 OR K$<>"" THEN GO TO 80
  70 LOAD "C:":CD "/knloader":LOAD "knloader.bas"
  80 IF K$=" " OR J=32 THEN ERASE
  90 IF K$<>"t" AND K$<>"T" THEN GO TO 130
 100 CLS:PRINT AT 11,12;"NTP..."
 110 .nxtp time.nxtel.org 12300 -z=RomanceStandardTime
 120 PRINT AT 11,12;"  OK! ":GO TO 50
 130 IF K$="a" OR K$="A" OR J=16 THEN LOAD "C:":CD "/":LOAD "/nextzxos/autoexec.bas.bak"
 140 IF K$="d" OR K$="D" THEN CLS:PRINT AT 11,12;"Disabling WiFi...":REG 2,128
 150 GO TO 50

 990 SAVE "autoexec.bas"LINE 50
