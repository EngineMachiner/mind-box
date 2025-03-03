[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/W7W32691S)

# mind$box

**mind$box** is a **debug console** for **[StepMania 5](https://github.com/stepmania/stepmania) and [OutFox](https://github.com/TeamRizu/OutFox)** 
designed to display information and data.

https://user-images.githubusercontent.com/15896027/137427034-f411f697-c420-409d-8e56-a170546f9b0e.mp4

mind$box focuses to be compatible with newer game builds, so it may not be
compatible with older versions.

## Usage

  1. Use [tapLua](https://github.com/EngineMachiner/tapLua).

### OutFox

  2. Clone the repository in the fallback's Modules folder.
  ```
  git clone https://github.com/EngineMachiner/mindbox mind\$box
  ```

  3. Load tapLua first, then load mind$box and add the console actor
  in `ScreenSystemLayer aux.lua` to make the console actor persistent:
  ```lua
  -- Themes/_fallback/BGAnimations/ScreenSystemLayer aux.lua

  LoadModule("tapLua/tapLua.lua")
  LoadModule("mind$box/mind$box.lua")

  return mindbox.console()
  ```

### Legacy

  2. Clone the repository in the same Modules folder following the same
  steps for tapLua cloning.
  ```
  git clone https://github.com/EngineMachiner/mindbox mind\$box
  ```

  3. Load tapLua first, then load mind$box and add the console actor
  in `ScreenSystemLayer aux.lua` to make the console actor persistent:
  ```lua
  -- Themes/_fallback/BGAnimations/ScreenSystemLayer aux.lua

  dofile("Modules/tapLua/tapLua.lua")
  LoadModule("mind$box/mind$box.lua")

  return mindbox.console()
  ```

---

  4. Use `mindbox.print(...)` to print into the console or `mindbox.sysPrint(...)`
  if you want to use the system message function.

---

Remember, if you're having problems with the texture being white, not showing up 
and you're using legacy builds you should enable only OpenGL as renderer in 
your `Preferences.ini` due to D3D not being able to render textures in these builds.
```
VideoRenderers=opengl
```

## Credits
- [TeamRizu](https://github.com/TeamRizu)

Thank you to everyone who contributed to the development of this project!
