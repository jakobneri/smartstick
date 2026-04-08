# Smart Stick

Portable USB toolkit. Double-click `smartstick.bat` to launch.

## Structure

```
smartstick.bat        # Launcher (calls main/smartstick.ps1)
main/                 # Core scripts
  smartstick.ps1      # Main menu and logic
music/                # Music download module
  setup.ps1           # Downloads yt-dlp + ffmpeg into music/tools/
config.txt            # User config (playlist URLs, gitignored)
```

## Tech

- All scripts are PowerShell (.ps1). The .bat is a 2-line launcher for double-click support.
- Music downloads use yt-dlp + ffmpeg (portable, stored in music/tools/).
- Downloads go to E:\Music\<playlist name>\*.mp3 (USB root, outside smartstick/).
- `--download-archive archive.txt` tracks already-downloaded videos.
- Self-updates via `git pull origin main`.

## Dev notes

- config.txt is gitignored (user-specific). config.example.txt is the committed template.
- music/tools/ is gitignored (binaries downloaded by setup).
- Repo: https://github.com/jakobneri/smartstick
