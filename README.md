[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/W7W32691S)

# mind$box
mind$box is a tool and library to debug and display / print in-game. Check mind$box.lua for more.

mind$box has been tested through from StepMania 5.0.12 to 5.3 / OutFox.

https://user-images.githubusercontent.com/15896027/137427034-f411f697-c420-409d-8e56-a170546f9b0e.mp4

## Usage
0. Make sure you have [tapLua](https://github.com/EngineMachiner/tapLua).

### OutFox

1. Copy the mind$box folder to fallback Modules folder.
2. Load mind$box.lua using LoadModule() to fallback's first screen.

   For example in ScreenInit overlay's script: <br>
   <img src=https://github.com/EngineMachiner/mind-box/assets/15896027/d9384dea-a1d7-4c7b-a238-5b74e445f01a width=400>

### StepMania

1. Copy the beat4sprite folder in your "Stepmania/Scripts" folder.
2. Reload scripts once at first screen if something goes wrong.

---

3. Add mindbox.spawn() as an additional actor in the script you want for the console to show up (beware actors draw order).
4. Run functions like mindbox.spawn(), mindbox.print() or mindbox.quickPrint() in your Lua scripts.

## Credits
- AwfulRanger
- Project Moondance developers.
