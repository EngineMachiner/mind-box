

# mind$box

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/W7W32691S)

https://user-images.githubusercontent.com/15896027/137427034-f411f697-c420-409d-8e56-a170546f9b0e.mp4

### Description

Tool and library to debug and display stuff / prints in-game. For OutFox / SM5+.
Check mind$box.lua for more.

The log font ("_eurostile Outline") is originally from the Soundwaves theme.

## Usage - OutFox

1. Drop the mind$box folder in the Modules folder of _fallback.
2. Store the mindbox variable with LoadModule()
3. Add mindbox.spawn() as an additional actor in the script you want for the console to show up (beware actors draw order).
4. Run the functions like mindbox.print() in your Lua scripts or do mindbox.spawn(...).

## Credits
- AwfulRanger (for being available and answering my questions about Lua)
