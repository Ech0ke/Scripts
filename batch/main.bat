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

rem Print the arrays (optional)
echo File Names: !fileNames!
echo File Paths: !filePaths!

exit /b

@REM rem Initialize the two-dimensional array
@REM set "row=0"
@REM set "col=0"

@REM rem Define a subroutine to process files in the directory and its subdirectories
@REM :ProcessFiles
@REM rem Reset the column index before processing files in the current directory
@REM set "col=0"
@REM for /f "delims=" %%F in ('dir /b /s "%~1\*.%extension%" 2^>nul') do (
@REM     set "files[!row!][!col!]=%%~nxF"
@REM     set "dirs[!row!][!col!]=%%~dpF"
@REM     set /a col+=1
@REM )
@REM for /d %%D in ("%~1\*") do (
@REM     call :ProcessFiles "%%D"
@REM )
@REM set /a row+=1

@REM rem Print the table header
@REM echo Filename^|Filepath

@REM rem Loop through the array and print the contents as a table
@REM for /l %%r in (0,1,%row%) do (
@REM     for /l %%c in (0,1,!col!) do (
@REM         if defined files[%%r][%%c] (
@REM             echo !files[%%r][%%c]!^|!dirs[%%r][%%c]!
@REM         )
@REM     )
@REM )



@REM rem Accumulate found files into an array
@REM set "index=0"
@REM for /f "delims=" %%F in ('dir /b /s "%directory%\*.%extension%" 2^>nul') do (
@REM     set "file[!index!]=%%F"
@REM     set /a index+=1
@REM )

@REM rem Loop through the array and print file names with paths
@REM if %index% equ 0 (
@REM     echo No files with extension %extension% found in %directory% or its subdirectories.
@REM ) else (
@REM     echo Files with extension %extension% found in %directory% or its subdirectories:
@REM     for /l %%i in (0,1,%index%) do (
@REM         echo !file[%%i]!
@REM     )
@REM )