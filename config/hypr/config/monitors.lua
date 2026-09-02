-- Monitor wiki https://wiki.hypr.land/Configuring/Basics/Monitors/
-- Example: output can be found with hyprctl monitors. Edit variables.lua for the monitor outputs instead of here directly
-- hl.monitor({
--     output    = "MONITOR1",
--     mode      = "1920x1080@60",
--     position  = "0x0",
--     scale     = "1",
-- })

-- Main display: Samsung Odyssey G5 (DP-3)
hl.monitor({
    output    = MONITOR1,
    mode      = "2560x1440@164.84",
    position  = "0x0",
    scale     = "1",
})

-- Secondary display, to the right of the main: HYTE Y70ti (DP-2)
-- Portrait flipped (Windows naming) = 270 deg clockwise rotation
hl.monitor({
    output    = MONITOR2,
    mode      = "3840x1100@60",
    position  = "2560x0",
    scale     = "1",
    transform = 3,
})
