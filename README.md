# Blender for Claude (Windows): free kit + all 7 fixes

Free from **Stravenford Academy**. MIT licence.

Claude drives your own Blender on your own PC. It builds a grey 3D layout of a shot (room, actors, camera move) before you pay for any AI video. The layout then guides the video model, so it follows your camera instead of guessing.

It took us 7 attempts and one night to make this work. This kit is the working result: about 15 minutes for you.

**[Download the kit (ZIP)](https://github.com/pavelpravosud/blender-for-claude/archive/refs/heads/main.zip)**

## What you need
- Windows 10 or 11
- The Claude desktop app (normal download or Microsoft Store version)
- About 2 GB free space and an internet connection

## Install in 4 steps
1. **Download the kit** with the link above and unzip it (right-click, Extract All).
2. **Double-click `1_Install_Blender_for_Claude.bat`.** It installs Blender and uv from official sources (winget), builds a private Python 3.11 just for Blender, installs the MCP for Blender connector and its Blender add-on, and builds the Claude extension file. About 10 minutes. If Windows asks, choose More info, then Run anyway.
3. **Double-click `2_Blender (Python 3.11).mcpb`** (it appears in the same folder after step 2) and press **Install** in Claude. Then quit Claude fully (right-click its icon in the system tray, then Quit) and open it again.
4. **Open Blender.** In the 3D view press **N**, open the **MCP for Blender** tab and check it says **Connected on localhost:9876** (press Connect if it doesn't).

Test it: in a Claude chat ask *"What objects are in my Blender scene?"*

## The 7 problems we hit, and the fix for each
| # | What you see | Cause | Fix (already in the kit) |
|---|---|---|---|
| 1 | One-click install works, then "Server transport closed unexpectedly" | The connector crashes the moment it starts | Read the cause in the log, never reinstall blindly |
| 2 | "pywin32: no build for Python 3.15" | The installer picked the newest Python, and a Windows part it needs has no 3.15 build yet | Python 3.11 |
| 3 | "claude_desktop_config.json: not found" | The Microsoft Store version of Claude keeps its settings in `%LOCALAPPDATA%\Packages\Claude_...\LocalCache\Roaming\Claude\` | Look in the right folder, not `%APPDATA%\Claude\` |
| 4 | The log still says Python 3.15 | Claude starts connectors with its own built-in installer and ignores your Python setting | A private Python 3.11 just for Blender |
| 5 | Still crashing | The crash came from another copy: the official Blender extension, which can't install on these PCs yet | Uninstall the official "Blender" extension, keep only "Blender (Python 3.11)" |
| 6 | Install button greyed out: "requires Python" | Claude extensions can't assume Python on your PC | A tiny launcher on Node.js, which ships with Claude |
| 7 | The launcher dies after 1 second | Nobody could see why | The launcher writes its own error log. Next start: connected |

## The rule that saved the night
Every time something fails, make it write down its own errors. Then fix the cause the log names. Never retry the same thing twice.

## If something goes wrong
- Open `%USERPROFILE%\.blender-mcp-py311\launcher_log.txt` and read the last lines.
- "connector missing": run step 2 again.
- Tools time out: Blender is closed, or the add-on isn't connected (step 4).
- Still stuck? Post the last lines of the log in the Help category of the Stravenford Academy community. We answer.

## What is in this kit
- `1_Install_Blender_for_Claude.bat` and `install.ps1`: step 2.
- `extension/`: the source of the Claude extension, packed into the `.mcpb` file by step 2. No data collection: telemetry is switched off.

Tested 24 Nov 2026 on Windows 11, Blender 5.3, MCP for Blender 2.3.1 and the Claude desktop app.

## Next
How to turn the grey layout into an AI video that follows your camera is in Track 1: AI Content Creator, inside Stravenford Academy. Start free with the 7-day challenge: https://www.skool.com/stravenford-academy-6569
