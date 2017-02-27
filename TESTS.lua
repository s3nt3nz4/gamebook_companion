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

--[[
    -- TEST : https://coronalabs.com/blog/2013/04/16/lua-string-magic/
    local function textWrap( str, limit, indent, indent1 )
       limit = limit or 72
       indent = indent or ""
       indent1 = indent1 or indent

       local here = 1 - #indent1
       return indent1..str:gsub( "(%s+)()(%S+)()",
          function( sp, st, word, fi )
             if fi - here > limit then
                here = st - #indent
                return "\n"..indent..word
             end
          end )
    end

    local initialText = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet."

    local wrappedText = textWrap( initialText, 36, nil, "    " )

    print( wrappedText )

    local textBox = display.newRect( 30, 30, 640, 840 )
    textBox:setFillColor( 200, 80, 50, 50 )
    textBox.strokeWidth = 4 ; textBox:setStrokeColor( 200, 80, 50, 150 )

    local myParagraph = display.newText( wrappedText, 66, 58, 580, 800, native.systemFont, 28 )
]]

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
