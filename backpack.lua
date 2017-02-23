-------------------------------------------------------------------------------------
--				                         
-- Lone Wolf : backpack_normal.lua	       
--				                          
-------------------------------------------------------------------------------------

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

-- Déclaration des variables
local icons, parch_background, backToMenu, title, typedObject, backpack, backpackMeal, minus, plus, obj, addObject
local deleteObj = {}

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

    -- Charge la fiche perso
    loadSheet()

    -------------------------------------------------------------------------------------
    -- scene create functions
    -------------------------------------------------------------------------------------

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

    -- listener pour champ de saisie
    local function textListener( event )  --https://docs.coronalabs.com/api/library/native/newTextField.html
        if ( event.phase == "began" ) then
            -- User begins editing "defaultField"
        elseif ( event.phase == "ended" or event.phase == "submitted" ) then
            -- Output resulting text from "defaultField"
            print( event.target.text )
            typedObject = event.target.text
        elseif ( event.phase == "editing" ) then
            print(event.text)
            typedObject = event.text
        end
    end
    
    -- +/- pics
    local options_icons = {
        width = 100,
        height = 100,
        numFrames = 6,
        sheetContentWidth = 300,
        sheetContentHeight = 200
    }
    icons = graphics.newImageSheet( "pic/icons.png", options_icons )

    local function addMeal()
        if carac.charge < 8 then
            carac.meal = carac.meal + 1
            carac.charge = carac.charge + 1
        else
            carac.charge = 8
        end
        jsonSave()
        backpackMeal.text = ( "Repas : " .. carac.meal .. "\n" )
        backpack.text = ("Sac à dos ( ".. 8-carac.charge .." place(s) libre(s) ) : \n")
    end

    local function removeMeal()
        if carac.meal >= 1 then carac.meal = carac.meal - 1 else carac.meal = 0 end
        jsonSave()
        backpackMeal.text = ( "Repas : " .. carac.meal .. "\n" )
        backpack.text = ("Sac à dos ( ".. 8-carac.charge .." place(s) libre(s) ) : \n")
    end

    -- Fonction de suppression des objets
    local function deleteObjFunc()
        print("deleteObjFunc : \n")        
    end

    local function displayObject()
        for i=2, #carac.obj do
            obj.text = obj.text .. "      " .. carac.obj[i] .. "\v"
            obj.anchorY = 0
        end
        backpack.text = ("Sac à dos ( ".. 8-carac.charge .." place(s) libre(s) ) : \n")
    end

    -- Fonction addObject
    local function addObjFunc()
        if carac.charge >= 8 then
            print("ERROR NUMBER OF OBJECTS > 8 !!!")
            else
                table.insert(carac.obj,typedObject)
                jsonSave()
                addObjField.text = ""
                typedObject = nil
        end
        obj.text = "\n"
        displayObject()
    end

    -------------------------------------------------------------------------------------
    -- scene create display and listeners
    -------------------------------------------------------------------------------------

	-- Parchment background
    parch_background = display.newImageRect( sceneGroup, "pic/parch_background.png", 400, 700 )
    parch_background.x = display.contentCenterX
    parch_background.y = display.contentCenterY

    -- Retour au menu
    backToMenu = display.newImageRect(sceneGroup, "pic/arrowBack.png", 30, 30)
    backToMenu.x = 40
    backToMenu.y = 0
    backToMenu:addEventListener( "tap", gotoAdventureSheet )

    -- Titre
    title = display.newText( sceneGroup, "Inventaire", 40, 10, native.systemFontBold, 20 )
    title:setFillColor(0,0,0)
    title.x = display.contentCenterX

    -- Sac à dos
    backpack = display.newText( sceneGroup, "Sac à dos ( ".. 8-carac.charge .." place(s) libre(s) ) : \n", 40, 60, native.systemFont, 18 )
    backpack:setFillColor(0,0,0)
    backpack.anchorX = 0

    -- Text field -> add object
    addObjField = native.newTextField( 130, 80, 180, 20 )
	addObjField:addEventListener( "userInput", textListener )

    -- Repas
    backpackMeal = display.newText( sceneGroup, "Repas : " .. carac.meal .. "\n", 40, 100, 250, 0, native.systemFont, 16 )
    backpackMeal:setFillColor(0,0,0)
    backpackMeal.anchorX = 0
    backpackMeal.anchorY = 0

    -- Ajouter soustraire repas
    minus = display.newImageRect( sceneGroup, icons, 2,30, 30 )
    minus.x = 230
    minus.y = 110
    minus:addEventListener( "tap", removeMeal )

    plus = display.newImageRect( sceneGroup, icons, 1, 30, 30 )
    plus.x = 270
    plus.y = 110
    plus:addEventListener( "tap", addMeal )


    -- Bouton de suppression des objets
    local y = 117
    for i=1, 8 do
        deleteObj[i] = display.newImageRect( sceneGroup, icons, 2, 23, 23 )
        deleteObj[i].anchorX = 0
        deleteObj[i].anchorY = 0
        deleteObj[i].x = 40
        deleteObj[i].y = y
        y = y + 19
        print ("i=" .. i .. " | y=" .. y)
        deleteObj[i]:addEventListener( "tap", deleteObjFunc )
    end


    -- Alimentation du tableau des objets du sac à dos (avec test sur le nombre d'objet -> max 8 repas inclus)
    obj = display.newText( sceneGroup, "\n", 40, 100, native.systemFont, 16 )
    obj:setFillColor(0,0,0)
    obj.anchorX = 0
    obj.anchorY = 0


    if carac.charge > 8 then
    	print ("ERROR : NUMBER OF OBJECTS > 8 !!!")
    else
    	displayObject()
    end

    --Add object
    addObject = display.newImageRect( sceneGroup, icons, 4, 30, 30 )
    addObject.x = 250
    addObject.y = 80
    addObject:addEventListener("tap", addObjFunc)

	-- Text field -> add object spec
    addSpecObjField = native.newTextField( 130, 320, 180, 20 )
	addSpecObjField:addEventListener( "userInput", textListener )
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
	addSpecObjField:removeSelf()
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
