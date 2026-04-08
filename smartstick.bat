@echo off
setlocal enabledelayedexpansion

:: Get the directory where this script lives
set "STICK_DIR=%~dp0"

:menu
cls
echo =============================
echo    Smart Stick v1.0
echo =============================
echo.
echo  [1] Download playlists
echo  [2] Update Smart Stick
echo  [3] Setup (first-time)
echo  [4] Exit
echo.
echo =============================
echo.
set /p "choice=Choose an option: "

if "%choice%"=="1" goto :download
if "%choice%"=="2" goto :update
if "%choice%"=="3" goto :setup
if "%choice%"=="4" goto :eof
echo Invalid choice. & pause & goto :menu

:: ============================================================
:: DOWNLOAD PLAYLISTS
:: ============================================================
:download
cls
echo =============================
echo   Downloading Playlists
echo =============================
echo.

:: Check yt-dlp exists
if not exist "%STICK_DIR%tools\yt-dlp.exe" (
    echo ERROR: yt-dlp.exe not found. Run Setup first (option 3).
    echo.
    pause
    goto :menu
)

:: Check playlists.txt exists
if not exist "%STICK_DIR%playlists.txt" (
    echo ERROR: playlists.txt not found. Run Setup first (option 3),
    echo then edit playlists.txt to add your playlist URLs.
    echo.
    pause
    goto :menu
)

:: Set ffmpeg location for yt-dlp
set "FFMPEG_DIR=%STICK_DIR%tools"

set "count=0"
for /f "usebackq eol=# tokens=*" %%u in ("%STICK_DIR%playlists.txt") do (
    set "url=%%u"
    :: Skip empty lines
    if not "!url!"=="" (
        set /a count+=1
        echo.
        echo --- Playlist !count!: %%u ---
        echo.
        "%STICK_DIR%tools\yt-dlp.exe" --extract-audio --audio-format mp3 --audio-quality 0 --download-archive "%STICK_DIR%archive.txt" --output "%STICK_DIR%downloads\%%(playlist_title)s\%%(title)s.%%(ext)s" --no-overwrites --ignore-errors --ffmpeg-location "%FFMPEG_DIR%" "%%u"
    )
)

if %count%==0 (
    echo No playlist URLs found in playlists.txt.
    echo Edit playlists.txt and add your YouTube playlist URLs.
) else (
    echo.
    echo =============================
    echo   Done! Processed !count! playlist(s).
    echo =============================
)
echo.
pause
goto :menu

:: ============================================================
:: UPDATE SMART STICK
:: ============================================================
:update
cls
echo =============================
echo   Updating Smart Stick
echo =============================
echo.

:: Check if git is available
where git >nul 2>&1
if errorlevel 1 (
    echo ERROR: Git is not installed on this computer.
    echo Install Git from https://git-scm.com and try again.
    echo.
    pause
    goto :menu
)

cd /d "%STICK_DIR%"
echo Pulling latest changes from GitHub...
echo.
git pull origin main
echo.
echo =============================
echo   Update complete!
echo =============================
echo.
pause
goto :menu

:: ============================================================
:: SETUP
:: ============================================================
:setup
call "%STICK_DIR%setup.bat"
goto :menu
