@echo off
setlocal

echo Checking if Windows Terminal is installed...


powershell -Command "Get-AppxPackage -Name Microsoft.WindowsTerminal" >nul 2>&1

if %errorlevel% equ 0 (
    echo Windows Terminal is installed.
) else (
    echo Windows Terminal is not installed.
    echo Please install Windows Terminal from the Microsoft Store.
    pause
    exit /b 1
)

for /f "delims=" %%i in ('powershell -Command "Get-AppxPackage -Name Microsoft.WindowsTerminal | Select-Object -ExpandProperty PackageFamilyName"') do set "wtPackName=%%i"
set "wtFullPath=%LOCALAPPDATA%\Packages\%wtPackName%"

if exist "%wtFullPath%" (
    echo Found Windows Terminal at %wtFullPath%
) else (
    echo Looked for Windows Terminal installation path like this: %wtFullPath% but not found.
    echo Please re-install Windows Terminal from the Microsoft Store.
    pause
    exit /b 1
)

echo Checking if Git is installed...

git --version >nul 2>&1
if %errorlevel% equ 0 (
    echo Git is installed.
) else (
    echo Git is not installed.
    echo Please install Git from https://git-scm.com/download/win.
    pause
    exit /b 1
)

echo Checking if Git Bash is installed...

for /f "delims=" %%i in ('where git') do set "gitPath=%%i"
set "gitPath=%gitPath:\cmd\git.exe=%"
set gitBashPath=%gitPath%\bin\bash.exe
if exist "%gitBashPath%" (
    echo Found bash.exe at %gitBashPath%
    echo Perform adding option to Windows Terminal...
) else (
    echo Git Bash is not installed.
    echo Please re-install Git with Git Bash from https://git-scm.com/download/win.
    pause
    exit /b 1
)

set "currentTs=%time:~0,2%%time:~3,2%%time:~6,2%"
set "settingsJson=%wtFullPath%\LocalState\settings.json"
set "backupJson=%wtFullPath%\LocalState\settings-backup.json"

copy "%wtFullPath%\LocalState\settings.json" "%backupJson%"
echo Old settings is coppied to %backupJson%, you can restore it if something goes wrong.

:: Generate GUID & other properties
for /f "delims=" %%i in ('powershell -Command "[guid]::NewGuid()"') do set "guid=%%i"
set "optionCommandLine=%gitBashPath% --login -i"
set "optionName=Git Bash"
set "optionSource=Windows.Terminal.Wsl"

:: At this point I do think why not use plain PowerShell to do the job. :"D
set "psScriptContent=$settings = Get-Content '%settingsJson%' -Raw ^| ConvertFrom-Json;\r$newOption = @{\r    commandline = '%optionCommandLine%';\r    guid = '{%guid%}';\r    hidden = $false;\r    name = '%optionName%';^\r    source = '%optionSource%'\r};\r$settings.profiles.list += $newOption;\r$modified = $settings ^| ConvertTo-Json -Depth 100;\rSet-Content -Path '%settingsJson%' -Value $modified;"


echo %psScriptContent%

endlocal
pause