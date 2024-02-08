@echo off
setlocal enabledelayedexpansion

set /p extension=Enter the file extension (e.g., txt, docx): 
set /p directory=Enter absolute directory path (e.g., C:\Install\PoshGit): 

rem Check if the directory exists
if not exist "%directory%" (
    echo Error: Directory not found.
    exit /b
)

cd %directory%

rem Initialize collection to store file names and file paths
set "counter=0"

rem Loop through all files in the directory and its subdirectories with the specified extension
for /r %%a in (*.%extension%) do (
    rem Extract file name and full path
    set "fileName=%%~nxa"
    set "filePath=%%~fa"
    
    rem Increment the counter for each file
    set /a counter+=1

    rem Assign file name and path to variables with unique names
    set "fileName!counter!=!fileName!"
    set "filePath!counter!=!filePath!"
)

rem Get current date and time
set "currentDateTime=%DATE% %TIME%"

rem Output arrays and current date and time to a log file
(
    echo Current Date and Time: %currentDateTime%
    echo.
    rem Loop through the files using the counter to access each variable
    for /l %%i in (1, 1, %counter%) do (
        rem Print the filename and corresponding file path
        echo !fileName%%i!   !filePath%%i!
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