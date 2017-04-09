-- -----------------------------------------------------------------------------------
-- Code pour TESTS !!!!!!!!!
-- -----------------------------------------------------------------------------------


local composer = require( "composer" )

local scene = composer.newScene()

local widget = require( "widget" )

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function gotoMenu()
    composer.removeScene( "menu" )
    composer.gotoScene( "menu" )
end

-- TEST json
local json = require "json"

 -- lua script
 local luaTable = {
   ["name1"] = "value1",
   ["name2"] = {1, false, true, 23.45, "a string"},
   name3 = json.null
 }
 print (luaTable.name1)

local jsonData = json.encode( luaTable )
print (jsonData)

-- local filePath = system.pathForFile( "tests.json", system.DocumentsDirectory )

-- local file = io.open( filePath, "w" )

-- if file then
--   file:write( json.encode( luaTable ))
--   io.close( file )
-- end

--print (jsonData)

-- Fin du test json

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    -- Parchment background
    local parch_background = display.newImageRect( sceneGroup, "pic/parch_background.png", 400, 700 )
    parch_background.x = display.contentCenterX
    parch_background.y = display.contentCenterY

    -- Retour au menu
    local backToMenu = display.newImageRect(sceneGroup, "pic/arrowBack.png", 30, 30)
    backToMenu.x = 40
    backToMenu.y = 0
    backToMenu:addEventListener( "tap", gotoMenu )

    -- d10 pics
    local diceOptions = {
        width = 150,
        height = 150,
        numFrames = 10,
        sheetContentWidth = 750,
        sheetContentHeight = 300
    }
    local d10 = graphics.newImageSheet( "pic/d10.png", diceOptions )


    local sequenceDice = {
        {
            name = "rollingDice",
            start = 1,
            count = 10,
            time = 1000,
            loopCount = 1
        }
    }

    local function rollingDice( event )
        --https://docs.coronalabs.com/guide/media/spriteAnimation/index.html
        local thisDice = event.target
        thisDice:play()
    end

    -- display dice
    local startSide = math.random(10)
    local dice = display.newSprite( sceneGroup, d10, sequenceDice )
    dice:scale(0.35,0.35)
    dice.x = 50
    dice.y = 50
    dice:addEventListener( "tap", rollingDice )


end


-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen

    end
end


-- hide()
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)

    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen

    end
end


-- destroy()
function scene:destroy( event )

    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
