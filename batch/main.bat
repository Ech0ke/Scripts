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

rem Initialize arrays to store file names and file paths
set "fileNames="
set "filePaths="

rem Loop through all files in the directory and its subdirectories with the specified extension
for /r %%a in (*.%extension%) do (
    rem Extract file name from the full path using %%~nxa modifier
    set "fileName=%%~nxa"
    
    rem Append file name and full path to the respective arrays
    set "fileNames=!fileNames!,!fileName!"
    set "filePaths=!filePaths!,%%~fa"
)

rem Remove leading comma from arrays
set "fileNames=!fileNames:~1!"
set "filePaths=!filePaths:~1!"

rem Print the arrays
echo File Names: !fileNames!
echo File Paths: !filePaths!

rem Get current date and time
set "currentDateTime=%DATE% %TIME%"

rem Output arrays to a log file
(
    echo !currentDateTime!
    echo.
    echo File Names: !fileNames!
    echo File Paths: !filePaths!
) > "%directory%\summary.log"

exit /b