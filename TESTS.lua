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


-----------------------
-- test pickerwheel
-----------------------

 
-- Set up the picker wheel columns
local columnData =
{
    {
        align = "left",
        width = 126,
        startIndex = 2,
        labels = { "Hoodie", "Short Sleeve", "Long Sleeve", "Sweatshirt" }
    },
    {
        align = "left",
        width = 106,
        labelPadding = 10,
        startIndex = 1,
        labels = { "Dark Grey", "White", "Black", "Orange" }
    },
    {
        align = "left",
        labelPadding = 10,
        startIndex = 3,
        labels = { "S", "M", "L", "XL", "XXL" }
    }
}
 
-- Create the widget
pickerWheel = widget.newPickerWheel(
{
    x = display.contentCenterX,
    top = display.contentHeight - 222,
    fontSize = 18,
    columns = columnData
})  
 
-- Get the table of current values for all columns
-- This can be performed on a button tap, timer execution, or other event
local values = pickerWheel:getValues()
 
-- Get the value for each column in the wheel, by column index
local currentStyle = values[1].value
local currentColor = values[2].value
local currentSize = values[3].value
 
print( currentStyle, currentColor, currentSize )

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
        pickerWheel:removeSelf()

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
