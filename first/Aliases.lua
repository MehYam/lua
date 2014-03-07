
-- A singleton class - not really sure which lua singleton "implementation" to go with yet, it seems like global objects are just that - singletons...
Aliases = {}

Aliases.dWidth = display.viewableContentWidth
Aliases.dHeight = display.viewableContentHeight
Aliases.centerX = Aliases.dWidth / 2
Aliases.centerY = Aliases.dHeight / 2

Aliases.ACCEL = 0.01
Aliases.INERTIA = 0.002
Aliases.MAX_SPEED = 0.1