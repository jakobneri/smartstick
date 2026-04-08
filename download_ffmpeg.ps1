param([string]$ToolsDir)

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$zip = Join-Path $ToolsDir "ffmpeg.zip"
$temp = Join-Path $ToolsDir "ffmpeg_temp"
$dest = Join-Path $ToolsDir "ffmpeg.exe"

Invoke-WebRequest -Uri "https://github.com/yt-dlp/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip" -OutFile $zip
Expand-Archive -Path $zip -DestinationPath $temp -Force

$exe = Get-ChildItem -Path $temp -Recurse -Filter "ffmpeg.exe" | Select-Object -First 1
Copy-Item $exe.FullName $dest

Remove-Item $temp -Recurse -Force
Remove-Item $zip -Force
