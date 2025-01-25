:: Add Git Bash Profile to Windows Terminal
:: Usage 1: "gitbash-terminal.cmd" to add Git Bash profile option to Windows Terminal.
:: Usage 2: "gitbash-terminal.cmd SetDefault" to add Git Bash profile option to Windows Terminal and set it as default profile.
::
:: Edit: Địt con mẹ code cả buổi chiều mới biết được là tính năng nó implement rồi.
::       Có thể thêm profile bằng cách chọn "Add a profile" trong Windows Terminal.
::       Địt mẹ
::       Có thể dùng "gitbash-terminal.cmd SetDefault" để ăn luôn mà ko cần setup nhé. yêu <3
::       Địttttt mẹeeeee


@echo off
setlocal enabledelayedexpansion

set "SetDefault=false"
if "%~1"=="SetDefault" (
    set "SetDefault=true"
)

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

:: At this point I do think why not use plain PowerShell to do the job. :"D
:: Edit: Ừ chửi tao ngu đi
set "l[0]=$settings = Get-Content '%settingsJson%' -Raw ^| ConvertFrom-Json;"
set "l[1]=$newOption = @{"
set "l[2]=    tabTitle = 'Git Bash';"
set "l[3]=    useAcrylic = $true;"
set "l[4]=    acrylicOpacity = 0.5;"
set "l[5]=    closeOnExit = 'automatic';"
set "l[6]=    icon = 'ms-appdata:///roaming/git-bash_32px.ico';"
set "l[7]=    fontFace = 'Cascadia Code';"
set "l[8]=    fontSize = 12;"
set "l[9]=    fontWeight = 'normal';"
set "l[10]=    commandline = '%optionCommandLine%';"
set "l[11]=    guid = '{%guid%}';"
set "l[12]=    hidden = $false;"
set "l[13]=    name = '%optionName%';"
set "l[14]=};"
set "l[15]=$settings.profiles.list += $newOption;"
set "l[16]=$settings.defaultProfile = '{%guid%}';"
set "l[17]=$modified = $settings | ConvertTo-Json -Depth 100;"
set "l[18]=Set-Content -Path '%settingsJson%' -Value $modified;"

set "psScriptPath=update-wt-settings-%currentTs%.ps1"

echo %l[0]% > %psScriptPath%
for /L %%n in (1,1,18) do (
    if %%n==16 (
        if "%SetDefault%"=="false" (
            echo "Skip setting default profile"
        ) else (
            echo !l[%%n]! >> %psScriptPath%
        )
    ) else (
        echo !l[%%n]! >> %psScriptPath%
    )
)

powershell -ExecutionPolicy Bypass -File "%psScriptPath%"
:: Edit: Dọn file temp. Chịch xong chuồn như J97
del "%psScriptPath%"

endlocal
echo Done, check Windows Terminal settings for the new option.
pause