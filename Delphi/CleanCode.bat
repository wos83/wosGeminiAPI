@echo off

chcp 65001

del /s /f /q "%CD%\*.~*"
del /s /f /q "%CD%\*.dcu"
del /s /f /q "%CD%\*.rsm"
del /s /f /q "%CD%\*.local"
del /s /f /q "%CD%\*.identcache"
del /s /f /q "%CD%\*.dsk"
del /s /f /q "%CD%\*.tmp"
del /s /f /q "%CD%\*.log"
del /s /f /q "%CD%\*.stat"
del /s /f /q "%CD%\*.skincfg"

del /s /f /q "%CD%\iphist.dat"
del /s /f /q "%CD%\*.map"

del /s /f /q "%CD%\*.sdb"
del /s /f /q "%CD%\*.s3db"
del /s /f /q "%CD%\*.sqlite"