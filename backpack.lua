-----------------------------------------------------------------------------------------
--
-- Lone Wolf : backpack_normal.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function gotoAdventureSheet()
    composer.removeScene( "adventure_sheet" )
    composer.gotoScene( "adventure_sheet" )
end

local json = require("json")
local carac = {}
local filePath = system.pathForFile( "adventureSheet.json", system.DocumentsDirectory )

-- Charge le fichier adventureSheet.json = fiche perso
local function loadSheet()
    local adventureSheet = io.open(filePath, "r")

    if adventureSheet then
        local contents = adventureSheet:read("*a")
        --print("===>adventureSheet : " .. contents)
        io.close(adventureSheet)
        carac = json.decode( contents )
        --print(carac.habil)
    end
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

    -- Charge la fiche perso
    loadSheet()

    -- declare text field objects
   -- local addObjField
    local typedObject

	-- Fonction de stockage de la fiche de perso dans un fichier json
	local function jsonSave()
		--calcul de la charge du sac à dos :
		carac.charge = #carac.obj - 1 + carac.meal
		local jsonCarac = json.encode( carac )
		print(jsonCarac)
		local adventureSheet = io.open (filePath, "w")
		if adventureSheet then
			adventureSheet:write( json.encode(carac) )
			io.close( adventureSheet )
		end
	end

    local function textListener( event )
        if ( event.phase == "began" ) then
            -- User begins editing "defaultField"
		elseif ( event.phase == "ended" or event.phase == "submitted" ) then
		    -- Output resulting text from "defaultField"
            print( event.target.text )
            typedObject = event.target.text
        elseif ( event.phase == "editing" ) then
        	--https://docs.coronalabs.com/api/library/native/newTextField.html
        end
    end

	-- Parchment background
    local parch_background = display.newImageRect( sceneGroup, "pic/parch_background_warrior.png", 300, 556 )      
    parch_background.x = display.contentCenterX
    parch_background.y = display.contentCenterY

    -- Retour au menu
    local backToMenu = display.newImageRect(sceneGroup, "pic/arrowBack.png", 30, 30)
    backToMenu.x = 40
    backToMenu.y = 0
    backToMenu:addEventListener( "tap", gotoAdventureSheet )

    -- Titre
    local title = display.newText( sceneGroup, "Inventaire", 40, 10, native.systemFontBold, 20 )
    title:setFillColor(0,0,0)
    title.x = display.contentCenterX

    -- Sac à dos
    local backpack = display.newText( sceneGroup, "Sac à dos ( ".. 8-carac.charge .." place(s) libre(s) ) : \n", 40, 60, native.systemFont, 18 )
    backpack:setFillColor(0,0,0)
    backpack.anchorX = 0

    -- Text field -> add object
    addObjField = native.newTextField( 130, 80, 180, 20 )
	addObjField:addEventListener( "userInput", textListener )
	print(addObjField[1])
	print(#addObjField)

    -- Repas
    local backpackMeal = display.newText( sceneGroup, "Repas : " .. carac.meal .. "\n", 40, 100, 250, 0, native.systemFont, 16 )
    backpackMeal:setFillColor(0,0,0)
    backpackMeal.anchorX = 0
    backpackMeal.anchorY = 0

    -- Alimentation du tableau des objets du sac à dos (avec test sur le nombre d'objet -> max 8 repas inclus)
    local obj = display.newText( sceneGroup, "\n", 40, 100, native.systemFont, 16 )
    obj:setFillColor(0,0,0)
    obj.anchorX = 0
    obj.anchorY = 0

    local function displayObject()
        for i=2, #carac.obj do
            obj.text = obj.text .. carac.obj[i] .. "\n"
            obj.anchorY = 0
        end
        backpack.text = ("Sac à dos ( ".. 8-carac.charge .." place(s) libre(s) ) : \n")
    end

    if carac.charge > 8 then
    	print ("ERROR : NUMBER OF OBJECTS > 8 !!!")
    else
    	displayObject()
    end

	-- Fonction addObject
	local function addObjFunc()
		if carac.charge >= 8 then
			print("ERROR NUMBER OF OBJECTS > 8 !!!")
			else
				table.insert(carac.obj,typedObject)
				jsonSave()
				addObjField.text = ""
		end
		obj.text = "\n"
		displayObject()
	end

    --Add object
    local addObject = display.newText( sceneGroup, "+", 250, 76, native.systemFontBold, 24)
    addObject:setFillColor(0,0,0)
    addObject.anchorX = 0
    addObject:addEventListener("tap", addObjFunc)
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
	addObjField:removeSelf()
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
