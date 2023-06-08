

# mind$box

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/W7W32691S)

https://user-images.githubusercontent.com/15896027/137427034-f411f697-c420-409d-8e56-a170546f9b0e.mp4

### Description

Tool and library to debug and display stuff / prints in-game. For OutFox / StepMania 5+.
Check mind$box.lua for more.

The log font ("_eurostile Outline") is originally from OutFox's SoundWaves theme.

## Usage

1. Copy the mind$box to _fallback Modules folder.
2. Load mind$box using LoadModule() on the first screen (or anywhere you want)
3. Add mindbox.spawn() as an additional actor in the script you want for the console to show up (beware actors draw order).
4. Run the functions like mindbox.spawn(...), mindbox.print() or mindbox.quickPrint() in your Lua scripts.

## Credits
- AwfulRanger (for being available and answering my questions about Lua)
- Project Moondance dev team.
