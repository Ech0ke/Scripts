@echo off
setlocal enabledelayedexpansion

set /p "extension=Enter the file extension (default: bat): " || set "extension=bat"
set /p "directory=Enter absolute directory path (default: C:\Users\%USERNAME%): " || set "directory=C:\Users\%USERNAME%"

rem Check if the directory exists
if not exist "%directory%" (
    echo Error: Directory not found.
    exit /b
)

rem If directory exists cd into it
cd %directory%

set "index=0"

rem Loop through all files in the directory and its subdirectories with the specified extension
for /r %%A in (*.%extension%) do (
    rem Append file path to the array
    set /a index+=1
    set "file[!index!]=%%~nxA"
    set "filePath[!index!]=%%~fA"
)

rem Output arrays and current date and time to a log file
(
    echo Date: %DATE%
    echo Time: %TIME%
    echo.
    rem Loop through the files using the counter to access each variable
    for /l %%i in (1, 1, %index%) do (
    echo !file[%%i]!
    echo !filePath[%%i]!
    echo.
    )
) > "%directory%\output.log"

rem Open the log file
start "" "%directory%\output.log"

rem Pause the script until the user presses Enter
pause

rem Close the log file by terminating the associated program
taskkill /f /im notepad.exe

rem Delete the log file
del "%directory%\output.log"

exit /b