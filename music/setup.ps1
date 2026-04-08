$StickDir = Split-Path $PSScriptRoot -Parent
$ToolsDir = Join-Path $PSScriptRoot "tools"
$ConfigFile = Join-Path $StickDir "config.txt"
$ConfigExample = Join-Path $StickDir "config.example.txt"

Write-Host "=============================" -ForegroundColor Cyan
Write-Host "  Smart Stick - Setup"        -ForegroundColor Cyan
Write-Host "=============================" -ForegroundColor Cyan
Write-Host ""

# Create tools directory
if (-not (Test-Path $ToolsDir)) {
    New-Item -ItemType Directory -Path $ToolsDir | Out-Null
}

# Download yt-dlp.exe
Write-Host "[1/2] Downloading yt-dlp.exe..."
$ytdlpPath = Join-Path $ToolsDir "yt-dlp.exe"
try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe" -OutFile $ytdlpPath
    Write-Host "       yt-dlp.exe downloaded successfully." -ForegroundColor Green
} catch {
    Write-Host "       ERROR: Failed to download yt-dlp.exe" -ForegroundColor Red
    Write-Host "       $($_.Exception.Message)" -ForegroundColor Red
    Read-Host "Press Enter to continue"
    return
}

# Download ffmpeg
Write-Host "[2/2] Downloading ffmpeg..."
Write-Host "       This may take a moment (ffmpeg is ~80MB)..."
$ffmpegZip = Join-Path $ToolsDir "ffmpeg.zip"
$ffmpegTemp = Join-Path $ToolsDir "ffmpeg_temp"
$ffmpegPath = Join-Path $ToolsDir "ffmpeg.exe"
try {
    Invoke-WebRequest -Uri "https://github.com/yt-dlp/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip" -OutFile $ffmpegZip
    Expand-Archive -Path $ffmpegZip -DestinationPath $ffmpegTemp -Force

    $exe = Get-ChildItem -Path $ffmpegTemp -Recurse -Filter "ffmpeg.exe" | Select-Object -First 1
    Copy-Item $exe.FullName $ffmpegPath

    Remove-Item $ffmpegTemp -Recurse -Force
    Remove-Item $ffmpegZip -Force

    Write-Host "       ffmpeg.exe downloaded successfully." -ForegroundColor Green
} catch {
    Write-Host "       ERROR: Failed to download ffmpeg.exe" -ForegroundColor Red
    Write-Host "       $($_.Exception.Message)" -ForegroundColor Red
    Read-Host "Press Enter to continue"
    return
}

# Create config.txt from example if it doesn't exist
if (-not (Test-Path $ConfigFile)) {
    Copy-Item $ConfigExample $ConfigFile
    Write-Host ""
    Write-Host "Created config.txt - edit it to add your playlist URLs." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=============================" -ForegroundColor Cyan
Write-Host "  Setup complete!"             -ForegroundColor Cyan
Write-Host "=============================" -ForegroundColor Cyan
Read-Host "Press Enter to continue"
