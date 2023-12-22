@echo off
setlocal

REM Check if the input file is provided as an argument
if "%1"=="" (
    echo Usage: build_and_run.bat [filename]
    exit /b 1
)

REM Set the filename from the command line argument
set "filename=%1"

REM Assemble the input program using masm
masm %filename%.asm;

REM Link the object file using link
link %filename%.obj;

endlocal