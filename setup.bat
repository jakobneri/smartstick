@echo off
setlocal

echo =============================
echo   Smart Stick - Setup
echo =============================
echo.

:: Get the directory where this script lives
set "STICK_DIR=%~dp0"

:: Create directories
if not exist "%STICK_DIR%tools" mkdir "%STICK_DIR%tools"

:: Download yt-dlp.exe
echo [1/2] Downloading yt-dlp.exe...
powershell -Command "& { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe' -OutFile '%STICK_DIR%tools\yt-dlp.exe' }"
if exist "%STICK_DIR%tools\yt-dlp.exe" (
    echo        yt-dlp.exe downloaded successfully.
) else (
    echo        ERROR: Failed to download yt-dlp.exe
    goto :done
)

:: Download ffmpeg
echo [2/2] Downloading ffmpeg...
echo        This may take a moment (ffmpeg is ~80MB)...
powershell -Command "& { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $tmp = '%STICK_DIR%tools\ffmpeg.zip'; Invoke-WebRequest -Uri 'https://github.com/yt-dlp/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip' -OutFile $tmp; Expand-Archive -Path $tmp -DestinationPath '%STICK_DIR%tools\ffmpeg_temp' -Force; $exe = Get-ChildItem -Path '%STICK_DIR%tools\ffmpeg_temp' -Recurse -Filter 'ffmpeg.exe' | Select-Object -First 1; Copy-Item $exe.FullName '%STICK_DIR%tools\ffmpeg.exe'; Remove-Item '%STICK_DIR%tools\ffmpeg_temp' -Recurse -Force; Remove-Item $tmp -Force }"
if exist "%STICK_DIR%tools\ffmpeg.exe" (
    echo        ffmpeg.exe downloaded successfully.
) else (
    echo        ERROR: Failed to download ffmpeg.exe
    goto :done
)

:: Copy example playlists config if needed
if not exist "%STICK_DIR%playlists.txt" (
    copy "%STICK_DIR%playlists.example.txt" "%STICK_DIR%playlists.txt" >nul
    echo.
    echo Created playlists.txt - edit it to add your playlist URLs.
)

echo.
echo =============================
echo   Setup complete!
echo =============================

:done
echo.
pause
endlocal
