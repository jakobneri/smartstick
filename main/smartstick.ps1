$RootDir = Split-Path $PSScriptRoot -Parent
$MusicDir = Join-Path ($RootDir | Split-Path -Qualifier) "Music"
$ConfigFile = Join-Path $RootDir "config.txt"
$ArchiveFile = Join-Path $RootDir "archive.txt"
$MusicModule = Join-Path $RootDir "music"
$ToolsDir = Join-Path $MusicModule "tools"
$YtDlp = Join-Path $ToolsDir "yt-dlp.exe"
$FFmpeg = Join-Path $ToolsDir "ffmpeg.exe"

function Show-Menu {
    Clear-Host
    Write-Host "=============================" -ForegroundColor Cyan
    Write-Host "   Smart Stick v2.0"          -ForegroundColor Cyan
    Write-Host "=============================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host " [1] Download playlists"
    Write-Host " [2] Update Smart Stick"
    Write-Host " [3] Setup (first-time)"
    Write-Host " [4] Exit"
    Write-Host ""
    Write-Host "=============================" -ForegroundColor Cyan
    Write-Host ""
}

function Start-Download {
    if (-not (Test-Path $YtDlp)) {
        Write-Host "ERROR: yt-dlp.exe not found. Run Setup first (option 3)." -ForegroundColor Red
        Read-Host "Press Enter to continue"
        return
    }

    if (-not (Test-Path $ConfigFile)) {
        Write-Host "ERROR: config.txt not found. Run Setup first (option 3)," -ForegroundColor Red
        Write-Host "then edit config.txt to add your playlist URLs." -ForegroundColor Red
        Read-Host "Press Enter to continue"
        return
    }

    $urls = Get-Content $ConfigFile | Where-Object { $_ -match '\S' -and $_ -notmatch '^\s*#' }

    if ($urls.Count -eq 0) {
        Write-Host "No playlist URLs found in config.txt." -ForegroundColor Yellow
        Write-Host "Edit config.txt and add your YouTube playlist URLs."
        Read-Host "Press Enter to continue"
        return
    }

    $count = 0
    foreach ($url in $urls) {
        $count++
        Write-Host ""
        Write-Host "--- Playlist ${count}: $url ---" -ForegroundColor Green
        Write-Host ""

        $outputTpl = Join-Path $MusicDir "%(playlist_title)s\%(title)s.%(ext)s"

        & $YtDlp --extract-audio --audio-format mp3 --audio-quality 0 `
            --download-archive $ArchiveFile `
            --output $outputTpl `
            --no-overwrites --ignore-errors `
            --ffmpeg-location $ToolsDir `
            $url
    }

    Write-Host ""
    Write-Host "=============================" -ForegroundColor Cyan
    Write-Host "  Done! Processed $count playlist(s)." -ForegroundColor Cyan
    Write-Host "=============================" -ForegroundColor Cyan
    Read-Host "Press Enter to continue"
}

function Start-Update {
    $gitPath = Get-Command git -ErrorAction SilentlyContinue
    if (-not $gitPath) {
        Write-Host "ERROR: Git is not installed on this computer." -ForegroundColor Red
        Write-Host "Install Git from https://git-scm.com and try again."
        Read-Host "Press Enter to continue"
        return
    }

    Push-Location $StickDir
    Write-Host "Pulling latest changes from GitHub..."
    Write-Host ""
    git pull origin main
    Pop-Location

    Write-Host ""
    Write-Host "=============================" -ForegroundColor Cyan
    Write-Host "  Update complete!" -ForegroundColor Cyan
    Write-Host "=============================" -ForegroundColor Cyan
    Read-Host "Press Enter to continue"
}

function Start-Setup {
    & (Join-Path $MusicModule "setup.ps1")
}

# Main loop
while ($true) {
    Show-Menu
    $choice = Read-Host "Choose an option"

    switch ($choice) {
        "1" { Start-Download }
        "2" { Start-Update }
        "3" { Start-Setup }
        "4" { exit }
        default {
            Write-Host "Invalid choice." -ForegroundColor Yellow
            Start-Sleep -Seconds 1
        }
    }
}
