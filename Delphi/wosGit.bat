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
del /s /f /q "%CD%\*.delphilsp.*"

del /s /f /q "%CD%\iphist.dat"
del /s /f /q "%CD%\*.map"

rem del /s /f /q "%CD%\*.sdb"
rem del /s /f /q "%CD%\*.s3db"
rem del /s /f /q "%CD%\*.sqlite"

for /F "usebackq tokens=1,2 delims==" %%i in (`wmic os get LocalDateTime /VALUE 2^>NUL`) do if '.%%i.'=='.LocalDateTime.' set ldt=%%j

set dateNow=%ldt:~0,4%.%ldt:~4,2%.%ldt:~6,2%
set timeNow=%ldt:~8,2%:%ldt:~10,2%:%ldt:~12,2%

set appName=WOS Gemini API (Google)

git config --global --replace-all credential.helper wincred
git config --global --replace-all credential.useHttpPath true
git config --global --replace-all gui.encoding utf-8

git config --global --replace-all user.name "wos83"
git config --global --replace-all user.email "williansantos__@live.com"

git config --global --replace-all core.autocrlf true
git config --global --replace-all core.safecrlf false

git config --system --unset credential.helper

git config --global commit.gpgsign false
git config --global credential.helper manager
git config --global credential.interactive never
git config --global credential.modalprompt false
rem git config --global credential.interactive always
rem git config --global credential.modalprompt true

git branch -M develop

git add .
git commit -m "%1 %appName% Update Source %dateNow% %timeNow%"
rem git merge main
rem git remote add origin https://github.com/wos83/wosGeminiAPI.git
rem git remote add main https://github.com/wos83/wosGeminiAPI.git
rem git remote add develop https://github.com/wos83/wosGeminiAPI.git
git remote set-url origin https://github.com/wos83/wosGeminiAPI.git
git push -v -u -f origin develop
rem git pull-request -b develop main