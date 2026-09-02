local mainMod = "SUPER"
local noctCall = "noctalia msg "
local launchPrefix = "uwsm app -- " -- if you are not using UWSM, make this empty (e.g. "")

---------------------------
---- WINDOW MANAGEMENT ----
---------------------------

-- Window manipulation
hl.bind(mainMod .. " + Escape",      hl.dsp.exec_cmd("hyprctl kill"), { description = "FORCE KILL — Click any window to kill it; Escape cancels" })
hl.bind(mainMod .. " + Q",           hl.dsp.window.close(), { description = "CLOSE — Asks the app to quit, unlike force kill" })
hl.bind(mainMod .. " + ALT + Space", hl.dsp.window.float({ action = "toggle" }), { description = "FLOAT — Untiles it so it can be moved and resized freely" })
hl.bind(mainMod .. " + ALT + D",           hl.dsp.window.fullscreen({ mode = 1 }), { description = "MAXIMIZE — Fills the monitor but keeps your bar and gaps" })
hl.bind(mainMod .. " + ALT + F",           hl.dsp.window.fullscreen(), { description = "FULLSCREEN — True fullscreen, covers the bar" })
hl.bind(mainMod .. " + J",           hl.dsp.layout("togglesplit"), { description = "SPLIT — Flips whether the next window opens beside or below" })

-- Floating window snapping (Windows Snap style, halves/quarters of the current monitor)
local function snapFloating(xFrac, yFrac, wFrac, hFrac)
    local win = hl.get_active_window()
    if not win or not win.floating then return end
    local mon = win.monitor
    if not mon then return end
    local mw, mh = mon.width, mon.height
    if mon.transform % 2 == 1 then mw, mh = mh, mw end -- portrait rotations swap effective w/h
    hl.dispatch(hl.dsp.window.resize({ x = math.floor(wFrac * mw), y = math.floor(hFrac * mh) }))
    hl.dispatch(hl.dsp.window.move({ x = mon.x + math.floor(xFrac * mw), y = mon.y + math.floor(yFrac * mh) }))
end

hl.bind(mainMod .. " + ALT + Left",      function() snapFloating(0,   0,   0.5, 1)   end, { description = "SNAP LEFT — Left half; floating windows only" })
hl.bind(mainMod .. " + ALT + Right",     function() snapFloating(0.5, 0,   0.5, 1)   end, { description = "SNAP RIGHT — Right half; floating windows only" })
hl.bind(mainMod .. " + ALT + Up",        function() snapFloating(0,   0,   1,   1)   end, { description = "SNAP FULL — Fills the monitor; floating windows only" })
hl.bind(mainMod .. " + ALT + Down",      hl.dsp.window.center(), { description = "CENTER — Centres a floating window without resizing it" })
hl.bind(mainMod .. " + ALT + Home",      function() snapFloating(0,   0,   0.5, 0.5) end, { description = "SNAP TOP-LEFT — Top-left quarter; floating windows only" })
hl.bind(mainMod .. " + ALT + Page_Up",   function() snapFloating(0.5, 0,   0.5, 0.5) end, { description = "SNAP TOP-RIGHT — Top-right quarter; floating windows only" })
hl.bind(mainMod .. " + ALT + End",       function() snapFloating(0,   0.5, 0.5, 0.5) end, { description = "SNAP BOTTOM-LEFT — Bottom-left quarter; floating windows only" })
hl.bind(mainMod .. " + ALT + Page_Down", function() snapFloating(0.5, 0.5, 0.5, 0.5) end, { description = "SNAP BOTTOM-RIGHT — Bottom-right quarter; floating windows only" })

-- Change focus
hl.bind(mainMod .. " + Left",  hl.dsp.focus({ direction = "left" }), { description = "FOCUS LEFT — Moves focus, never the window" })
hl.bind(mainMod .. " + Right", hl.dsp.focus({ direction = "right" }), { description = "FOCUS RIGHT — Moves focus, never the window" })
hl.bind(mainMod .. " + Up",    hl.dsp.focus({ direction = "up" }), { description = "FOCUS UP — Moves focus, never the window" })
hl.bind(mainMod .. " + Down",  hl.dsp.focus({ direction = "down" }), { description = "FOCUS DOWN — Moves focus, never the window" })
hl.bind("ALT + Tab",           hl.dsp.window.cycle_next(), { description = "CYCLE — Straight through the stack, no preview" })
hl.bind(mainMod .. " + Tab",   hl.dsp.exec_cmd(noctCall .. "window-switcher"), { description = "SWITCHER — Noctalia's visual window picker" })

-- Move active window around workspaces & monitors
hl.bind(mainMod .. " + SHIFT + Up",                   hl.dsp.window.move({ direction = "u" }), { description = "MOVE UP — Rearranges the tiling" })
hl.bind(mainMod .. " + SHIFT + Right",                hl.dsp.window.move({ direction = "r" }), { description = "MOVE RIGHT — Rearranges the tiling" })
hl.bind(mainMod .. " + SHIFT + Left",                 hl.dsp.window.move({ direction = "l" }), { description = "MOVE LEFT — Rearranges the tiling" })
hl.bind(mainMod .. " + SHIFT + Down",                 hl.dsp.window.move({ direction = "d" }), { description = "MOVE DOWN — Rearranges the tiling" })
hl.bind(mainMod .. " + SHIFT + 1",                    hl.dsp.window.move({ monitor = MONITOR1 }), { description = "SEND TO MONITOR — Throws the window to DP-3" })
hl.bind(mainMod .. " + SHIFT + 2",                    hl.dsp.window.move({ monitor = MONITOR2 }), { description = "SEND TO MONITOR — Throws the window to DP-2" })
hl.bind(mainMod .. " + SHIFT + 3",                    hl.dsp.window.move({ monitor = MONITOR3 }), { description = "SEND TO MONITOR — Third monitor, unset" })
hl.bind(mainMod .. " + SHIFT + mouse_up",             hl.dsp.window.move({ monitor   = "-1" }), { description = "SEND MONITOR — Previous screen" })
hl.bind(mainMod .. " + SHIFT + mouse_down",           hl.dsp.window.move({ monitor   = "+1" }), { description = "SEND MONITOR — Next screen" })
hl.bind(mainMod .. " + CONTROL + SHIFT + Right",      hl.dsp.window.move({ workspace = "m+1" }), { description = "SEND WORKSPACE — Carries the window to the next" })
hl.bind(mainMod .. " + CONTROL + SHIFT + Left",       hl.dsp.window.move({ workspace = "m-1" }), { description = "SEND WORKSPACE — Carries the window to the previous" })
hl.bind(mainMod .. " + CONTROL + SHIFT + mouse_up",   hl.dsp.window.move({ workspace = "m-1" }), { description = "SEND WORKSPACE — Carries the window back" })
hl.bind(mainMod .. " + CONTROL + SHIFT + mouse_down", hl.dsp.window.move({ workspace = "m+1" }), { description = "SEND WORKSPACE — Carries the window forward" })
for i = 1, NUM_WPM do
    local key = i % 10
    hl.bind(mainMod .. " + SHIFT + CONTROL + " .. key, hl.dsp.window.move({ workspace = "m~" .. i }), { description = "SEND TO WORKSPACE — Nth workspace of this monitor" })
end

-- Move & Resize with mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { description = "DRAG MOVE — Hold SUPER and drag with the left button" })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { description = "DRAG RESIZE — Hold SUPER and drag with the right button" })

-- Zoom
local function zoomfunction(value)
    local zoomvalue = hl.get_config("cursor:zoom_factor")
    if (zoomvalue + value) > 3.0 then
        hl.config({ cursor = { zoom_factor = 3.0 } })
    elseif (zoomvalue + value) < 1.0 then
        hl.config({ cursor = { zoom_factor = 1.0 } })
    else
        hl.config({ cursor = { zoom_factor = zoomvalue + value } })
    end
end
hl.bind(mainMod .. " + Minus", function() zoomfunction(-0.3) end, { repeating = true, description = "ZOOM OUT — 0.3 steps, stops at 1.0x" })
hl.bind(mainMod .. " + Plus", function() zoomfunction(0.3) end, { repeating = true, description = "ZOOM IN — 0.3 steps, stops at 3.0x" })

--# Zoom with keypad
hl.bind(mainMod .. " + code:82", function() zoomfunction(-0.3) end, { repeating = true, description = "ZOOM OUT — Same, on the numpad" })
hl.bind(mainMod .. " + code:86", function() zoomfunction(0.3) end, { repeating = true, description = "ZOOM IN — Same, on the numpad" })


------------------
---- LAUNCHER ----
------------------

hl.bind(mainMod .. " + Return",     hl.dsp.exec_cmd(launchPrefix .. TERMINAL), { description = "TERMINAL — kitty" })
hl.bind(mainMod .. " + E",          hl.dsp.exec_cmd(launchPrefix .. FILE_MANAGER), { description = "FILES — Dolphin" })
hl.bind(mainMod .. " + T",          hl.dsp.exec_cmd(launchPrefix .. EDITOR), { description = "EDITOR — GNOME Text Editor" })
hl.bind(mainMod .. " + C",          hl.dsp.exec_cmd(launchPrefix .. CALCULATOR), { description = "CALCULATOR — Also on the media key" })
hl.bind("XF86Calculator",           hl.dsp.exec_cmd(launchPrefix .. CALCULATOR), { description = "CALCULATOR — Same as SUPER + C" })
hl.bind(mainMod .. " + W",          hl.dsp.exec_cmd(launchPrefix .. BROWSER), { description = "BROWSER — Firefox" })
hl.bind(mainMod .. " + F",          hl.dsp.exec_cmd(launchPrefix .. "firefox-developer-edition"), { description = "FIREFOX DEV — Developer Edition, separate profile" })
hl.bind(mainMod .. " + S",          hl.dsp.exec_cmd(launchPrefix .. "spotify-launcher"), { description = "SPOTIFY" })
hl.bind(mainMod .. " + D",          hl.dsp.exec_cmd(launchPrefix .. "discord"), { description = "DISCORD" })
hl.bind("CONTROL + SHIFT + Escape", hl.dsp.exec_cmd(launchPrefix .. TERMINAL .. " -e btop"), { description = "SYSTEM MONITOR — btop in a new terminal" })
hl.bind(mainMod .. " + Z",          hl.dsp.exec_cmd(noctCall .. "settings-toggle"), { description = "SETTINGS — Noctalia's own settings" })
hl.bind(mainMod .. " + X",          hl.dsp.exec_cmd(noctCall .. "panel-toggle control-center"), { description = "CONTROL CENTER — Audio, network, bluetooth" })
hl.bind(mainMod .. " + Space",      hl.dsp.exec_cmd(noctCall .. "panel-toggle launcher"), { description = "LAUNCHER — Search apps by name" })
hl.bind(mainMod .. " + period",     hl.dsp.exec_cmd(noctCall .. "panel-toggle launcher /emo"), { description = "EMOJI" })
hl.bind(mainMod .. " + L",          hl.dsp.exec_cmd(noctCall .. "session lock"), { description = "LOCK" })
hl.bind(mainMod .. " + ALT + C",    hl.dsp.exec_cmd(noctCall .. "panel-toggle session"), { description = "SESSION — Log out, reboot, shut down" })

---------------------------
---- HARDWARE CONTROLS ----
---------------------------

-- Audio
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(noctCall .. "volume-up"),   { locked = true, repeating = true, description = "VOLUME UP — Works while locked" })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(noctCall .. "volume-down"), { locked = true, repeating = true, description = "VOLUME DOWN — Works while locked" })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd(noctCall .. "volume-mute"), { locked = true, description = "MUTE — Output only" })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd(noctCall .. "mic-mute"),    { locked = true, description = "MIC MUTE — Input only" })

-- Media
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd(noctCall .. "media toggle"),   { locked = true, description = "PLAY PAUSE — Toggles, same as the Pause key" })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd(noctCall .. "media toggle"),   { locked = true, description = "PLAY PAUSE — Toggles, same as the Play key" })
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd(noctCall .. "media next"),     { locked = true, description = "NEXT TRACK" })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd(noctCall .. "media previous"), { locked = true, description = "PREV TRACK" })

-- Brightness
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd(noctCall .. "brightness-up"),   { locked = true, repeating = true, description = "BRIGHTER — Current monitor only" })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(noctCall .. "brightness-down"), { locked = true, repeating = true, description = "DIMMER — Current monitor only" })

-------------------
---- UTILITIES ----
-------------------

-- Screen Capture
hl.bind(mainMod .. " + P",     hl.dsp.exec_cmd("hyprpicker -a -n"), { description = "COLOR PICK — Copies the hex to your clipboard" })
hl.bind("Print",               hl.dsp.exec_cmd(noctCall .. "screenshot-region"), { description = "REGION SHOT — Drag to choose the area" })
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd(noctCall .. "screenshot-fullscreen"), { description = "FULL SHOT — Whole screen, no prompt" })

-- Theming and Wallpaper
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd(noctCall .. "panel-toggle wallpaper"), { description = "WALLPAPER" })

-- Clipboard
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(noctCall .. "panel-toggle clipboard"), { description = "CLIPBOARD — History of what you have copied" })

-- Notifications
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd(noctCall .. "panel-toggle control-center notifications"), { description = "NOTIFICATIONS — Opens the control centre on notifications" })

-- Keybind browser
hl.bind(mainMod .. " + slash", hl.dsp.exec_cmd(launchPrefix .. "kitty --class hyprbinds -e hyprbinds"), { description = "KEYBINDS — This tool" })

-------------------------------
---- WORKSPACES & MONITORS ----
-------------------------------

-- Focus on monitors
hl.bind(mainMod .. " + 1", hl.dsp.focus({ monitor = MONITOR1 }), { description = "MONITOR 1 — Focus DP-3" })
hl.bind(mainMod .. " + 2", hl.dsp.focus({ monitor = MONITOR2 }), { description = "MONITOR 2 — Focus DP-2" })
hl.bind(mainMod .. " + 3", hl.dsp.focus({ monitor = MONITOR3 }), { description = "MONITOR 3 — Unset on this machine" })

-- Focus on workspace number
-- Absolute
for i = 1, NUM_WPM do
    local key = i % 10
    hl.bind(mainMod .. " + ALT + " .. key, hl.dsp.focus({ workspace = i }), { description = "WORKSPACE N — Absolute, ignores which monitor you are on" })
end
-- Relative
for i = 1, NUM_WPM do
    local key = i % 10
    hl.bind(mainMod .. " + CONTROL + " .. key, hl.dsp.focus({ workspace = "m~" .. i }), { description = "LOCAL WORKSPACE — Nth workspace of this monitor" })
end

-- Move to adjacent workspaces and next empty on a given monitor
hl.bind(mainMod .. " + CONTROL + Right",       hl.dsp.focus({ workspace = "m+1" }), { description = "NEXT WORKSPACE — Stays on this monitor" })
hl.bind(mainMod .. " + CONTROL + Left",        hl.dsp.focus({ workspace = "m-1" }), { description = "PREV WORKSPACE — Stays on this monitor" })
hl.bind(mainMod .. " + CONTROL + Down",        hl.dsp.focus({ workspace = "emptym" }), { description = "EMPTY WORKSPACE — Jumps to the first unused one" })

-- Scroll through existing workspaces & monitors
hl.bind(mainMod .. " + mouse_down",           hl.dsp.focus({ workspace = "m-1" }), { description = "SCROLL WORKSPACE — Wheel down goes to the previous" })
hl.bind(mainMod .. " + mouse_up",             hl.dsp.focus({ workspace = "m+1" }), { description = "SCROLL WORKSPACE — Wheel up goes to the next" })
hl.bind(mainMod .. " + CONTROL + mouse_up",   hl.dsp.focus({ workspace = "m-1" }), { description = "SCROLL WORKSPACE — Inverted: wheel up goes back" })
hl.bind(mainMod .. " + CONTROL + mouse_down", hl.dsp.focus({ workspace = "m+1" }), { description = "SCROLL WORKSPACE — Inverted: wheel down goes forward" })

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special" }), { description = "STASH — Hides the window in the scratchpad" })
hl.bind(mainMod .. " + ALT + S",         hl.dsp.workspace.toggle_special(), { description = "SCRATCHPAD — Shows or hides what is stashed" })
