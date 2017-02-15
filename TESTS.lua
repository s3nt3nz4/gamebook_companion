-- -----------------------------------------------------------------------------------
-- Code pour TESTS !!!!!!!!!
-- -----------------------------------------------------------------------------------


local composer = require( "composer" )

local scene = composer.newScene()

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
    local parch_background = display.newImageRect( sceneGroup, "pic/parch_background.png", 300, 556 )
    parch_background.x = display.contentCenterX
    parch_background.y = display.contentCenterY

    -- Retour au menu
    local backToMenu = display.newImageRect(sceneGroup, "pic/arrowBack.png", 30, 30)
    backToMenu.x = 40
    backToMenu.y = 0
    backToMenu:addEventListener( "tap", gotoMenu )

    --test text input
    local defaultBox
     
    local function textListener( event )
     
        if ( event.phase == "began" ) then
            -- User begins editing "defaultBox"
     
        elseif ( event.phase == "ended" or event.phase == "submitted" ) then
            -- Output resulting text from "defaultBox"
            print( event.target.text )
     
        elseif ( event.phase == "editing" ) then
            print( event.newCharacters )
            print( event.oldText )
            print( event.startPosition )
            print( event.text )
        end
    end
     
    -- Create text box
    defaultBox = native.newTextBox( 200, 200, 280, 140 )
    defaultBox.text = "This is line 1.\nAnd this is line2"
    defaultBox.isEditable = true
    defaultBox:addEventListener( "userInput", textListener )

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
