@echo off
chcp 866
setlocal enabledelayedexpansion
set LOCALIZATION_FILE="rus"
set ADDONS_FILE="addons"
set TARGET_DIR_GAME="C:\SteamLibrary\steamapps\common\Deadlock"
set TARGET_DIR_ADDONS="C:\SteamLibrary\steamapps\common\Deadlock\game\citadel\addons"
set "FILE_CHANGE=C:\SteamLibrary\steamapps\common\Deadlock\game\citadel\gameinfo.gi"
set lineIndex=0
set "searchString=SearchPaths"
set "replaced=false"
cd /d "%~dp0"
copy /Y "%FILE_CHANGE%" .
rename gameinfo.gi gameinfo.txt
set "NEW_FILE_CHANGE=gameinfo.txt"
set "newFile=gameinfo_new.txt"
if exist "%newFile%" del "%newFile%"
if not exist "%NEW_FILE_CHANGE%" (
    echo Не найденн файл для редактирования %FILE_CHANGE%, проверьте на каком диске установленна игра
    goto :EOF
	pause
	exit
)
findstr /c:"Mod citadel" "%FILE_CHANGE%" >nul
if %errorlevel% equ 0 (
	echo gameinfo.gi уже содержит изменения
	del gameinfo.txt
) ELSE (
	for /f "delims=" %%A in ('type "%NEW_FILE_CHANGE%"') do (
    set /a lineIndex+=1
    set "line=%%A"
	if !replaced! equ false (
		echo. !line! | findstr /i "%searchString%" >nul
		if not errorlevel 1 (
			set /a nextLine=lineIndex+1
			set replaced=true
		)
	)
	echo.!line! >> "%newFile%"
	if !lineIndex! equ !nextLine! (
		echo.			Mod citadel >> "%newFile%"
		echo.			Write citadel >> "%newFile%"
		echo.			Game citadel/addons >> "%newFile%"
		)
	)
	move /y "%newFile%" "%NEW_FILE_CHANGE%"
	rename gameinfo.txt gameinfo.gi
	move /y gameinfo.gi "%FILE_CHANGE%"
	echo Файл успешно изменнён
)
IF EXIST "%TARGET_DIR_GAME%" (
  xcopy /Y %LOCALIZATION_FILE% %TARGET_DIR_GAME% /s /e /h /q
  echo Копирование локализации успешно выполненно!
) ELSE (
  echo Не найденна папка %TARGET_DIR_GAME%, проверьте на каком диске установленна игра
)
IF EXIST "%TARGET_DIR_ADDONS%" (
  xcopy /Y %ADDONS_FILE% %TARGET_DIR_ADDONS% /s /e /h /q
  echo Копирование модов успешно выполненно!
) ELSE (
  MD %TARGET_DIR_ADDONS% \addons /
  echo Папка %ADDONS_FILE% созданна по пути %TARGET_DIR_ADDONS%
  xcopy /Y %ADDONS_FILE% %TARGET_DIR_ADDONS% /s /e /h /q
  echo Копирование успешно выполненно!
)
endlocal
pause