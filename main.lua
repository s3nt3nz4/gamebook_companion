-----------------------------------------------------------------------------------------
--
-- Lone Wolf : main.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )

-- Seed the random number generator
math.randomseed( os.time() )

-- Hide status bar
display.setStatusBar( display.HiddenStatusBar )

-- Go to the menu screen
composer.gotoScene( "menu" )
