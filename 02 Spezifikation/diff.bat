@echo off
setlocal enabledelayedexpansion

:: -------------------------------------------------------------------
:: 1. Parameter verarbeiten
:: -------------------------------------------------------------------
set "FILE=%~1"
if defined FILE set "FILE=!FILE:'=!"
if "%FILE%"=="" set "FILE=main.typ"

set "COMMIT=%~2"
if defined COMMIT set "COMMIT=!COMMIT:'=!"

:: -------------------------------------------------------------------
:: 2. Automatische Commit-Ermittlung (falls kein Commit übergeben wurde)
:: -------------------------------------------------------------------
if "%COMMIT%"=="" (
    for /f "delims=" %%C in ('git log -n 1 --skip=1 --pretty=format:"%%H" -- "%FILE%" 2^>nul') do set "COMMIT=%%C"
)

:: Fallback, falls die Datei erst 1-mal gecommittet wurde
if "%COMMIT%"=="" set "COMMIT=HEAD~1"

:: -------------------------------------------------------------------
:: 3. Pfad zu typdiff.exe ermitteln
:: -------------------------------------------------------------------
set "TYPDIFF_EXE=typdiff"

if exist ".\typdiff.exe" set "TYPDIFF_EXE=.\typdiff.exe"
if exist "%~dp0typdiff.exe" set "TYPDIFF_EXE=%~dp0typdiff.exe"
if exist "%~dp0..\typdiff.exe" set "TYPDIFF_EXE=%~dp0..\typdiff.exe"
if exist "..\00 assets\typdiff.exe" set "TYPDIFF_EXE=..\00 assets\typdiff.exe"

:: -------------------------------------------------------------------
:: 4. Pfade und Dateinamen vorbereiten
:: -------------------------------------------------------------------
for %%F in ("%FILE%") do set "BASENAME=%%~nF"
set "OUTPUT=%BASENAME%-diff.pdf"

set "TMP_OLD=._tmp_old_%RANDOM%.typ"
set "TMP_DIFF=._tmp_diff_%RANDOM%.typ"

if not exist "%FILE%" (
    echo [!] Fehler: Datei "%FILE%" wurde im aktuellen Ordner nicht gefunden.
    echo [!] Aktueller Ordner: %CD%
    exit /b 1
)

:: -------------------------------------------------------------------
:: 5. Vergleich und PDF-Erstellung durchfuehren
:: -------------------------------------------------------------------
echo [Info] Verwende typdiff unter: "%TYPDIFF_EXE%"
echo [1/3] Vergleiche aktuellen Stand von %FILE% mit Commit %COMMIT%...

git show %COMMIT%:./%FILE% > "%TMP_OLD%"
if errorlevel 1 (
    echo.
    echo [!] Git konnte die Datei aus Commit %COMMIT% nicht laden.
    goto :cleanup_error
)

echo [2/3] Berechne Unterschiede...
"%TYPDIFF_EXE%" "%TMP_OLD%" "%FILE%" > "%TMP_DIFF%"
if errorlevel 1 (
    echo.
    echo [!] Fehler bei der Ausfuehrung von typdiff.
    goto :cleanup_error
)

echo [3/3] Kompiliere PDF mit Typst...
typst compile "%TMP_DIFF%" "%OUTPUT%"
if errorlevel 1 (
    echo.
    echo [!] Fehler beim Kompilieren mit Typst.
    goto :cleanup_error
)

echo.
echo Erfolgreich! PDF erzeugt: %OUTPUT%

del "%TMP_OLD%" "%TMP_DIFF%" 2>nul
exit /b 0

:cleanup_error
del "%TMP_OLD%" "%TMP_DIFF%" 2>nul
exit /b 1