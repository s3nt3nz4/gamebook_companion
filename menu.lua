-----------------------------------------------------------------------------------------
--
-- Lone Wolf : menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function gotoCreate()
    composer.removeScene( "sheet_create" )
    composer.gotoScene( "sheet_create" )
end

local function gotoTESTS ()
    composer.removeScene( "TESTS" )
    composer.gotoScene( "TESTS" )
end

local function gotoLoad()
    composer.removeScene( "adventure_sheet" )
    composer.gotoScene( "adventure_sheet" )
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	-- Add background (member of sceneGroup)
	local background = display.newImageRect( sceneGroup, "pic/parch_background.png", 300, 556 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

  -- Add title (member of sceneGroup)
	local title = display.newImageRect( sceneGroup, "pic/logo.png", 200, 66 )
	title.x = display.contentCenterX
	title.y = 100

  -- Add createSheet button and loadSheet button
	local createSheet = display.newText( sceneGroup, "Creer fiche de personnage", display.contentCenterX, 180, native.systemFont, 20 )
	createSheet:setFillColor( 0.2, 0.2, 0.2 )

	local loadSheet = display.newText( sceneGroup, "Charger fiche de personnage", display.contentCenterX, 230, native.systemFont, 20 )
	loadSheet:setFillColor( 0.2, 0.2, 0.2 )

	local TESTS = display.newText( sceneGroup, "TESTS", display.contentCenterX, 280, native.systemFont, 20 )
	TESTS:setFillColor( 0.2, 0.2, 0.2 )

	--Add event listener to detect user interactions
	createSheet:addEventListener( "tap", gotoCreate )
	loadSheet:addEventListener( "tap", gotoLoad )
	TESTS:addEventListener( "tap", gotoTESTS)

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
