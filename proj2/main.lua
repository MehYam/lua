local physics = require("physics")
physics.start( );

local sky = display.newImage( "bkg_clouds.png" )
sky.x = 160
sky.y = 195

local ground = display.newImage( "ground.png")
ground.x = 160
ground.y = 445


physics.addBody( ground, "static", {friction = 0.5, bounce = 0.3} )


local crate = display.newImage("crate.png")
crate.x = 180
crate.y = -40
crate.rotation = 5

physics.addBody(crate, { density = 3, friction = 0.5, bounce = 0.3})
