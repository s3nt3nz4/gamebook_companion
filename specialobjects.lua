-------------------------------------------------------------------------------------
--				                         
-- Lone Wolf : specialobjects.lua	       
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
local icons, parch_background, backToMenu, title, typedObject, addObjectSpe, objSpe, addSpecObjField
local deleteSpeObj = {}

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


    local function displaySpecObject()
        for i=1, #carac.specObj do
            objSpe.text = objSpe.text .. "      " .. carac.specObj[i] .. "\n"
            objSpe.anchorY = 0
        end
    end

    -- Fonction de suppression des objets
    local function deleteSpecObjFunc(event)
        display.remove(objSpe)

        table.remove(carac.specObj, event.target.num)
        deleteSpeObj[#carac.specObj+1].isVisible = false
        
        jsonSave()
        
        objSpe = display.newText( sceneGroup, "\n", 40, 90, native.systemFont, 18 )
        objSpe:setFillColor(0,0,0)
        objSpe.anchorX = 0
        objSpe.anchorY = 0
        displaySpecObject()
    end    

    -- Hide delete button
    local function hideDeleteSpeButton()
        for i=1, 9 do
            deleteSpeObj[i].isVisible = true
        end
        for i=(#carac.specObj+1), 9 do
            deleteSpeObj[i].isVisible = false
        end
    end

    -- Fonction add special object
    local function addObjSpeFunc()
        table.insert(carac.specObj,typedObject)
        jsonSave()
        addSpecObjField.text = ""
        typedObject = nil
        hideDeleteSpeButton() -- pour cacher le bouton de suppression
        objSpe.text = "\n"
        displaySpecObject()
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
    title = display.newText( sceneGroup, "Objets spéciaux", 40, 10, native.systemFontBold, 20 )
    title:setFillColor(0,0,0)
    title.x = display.contentCenterX

    -- Text field -> add object spec
    addSpecObjField = native.newTextField( 130, 80, 180, 20 )
    addSpecObjField:addEventListener( "userInput", textListener )

    -- Alimentation du tableau des objets spéciaux
    objSpe = display.newText( sceneGroup, "\n", 40, 90, native.systemFont, 18 )
    objSpe:setFillColor(0,0,0)
    objSpe.anchorX = 0
    objSpe.anchorY = 0
    displaySpecObject()

    --Add special object
    addObjectSpe = display.newImageRect( sceneGroup, icons, 4, 30, 30 )
    addObjectSpe.x = 250
    addObjectSpe.y = 80
    addObjectSpe:addEventListener("tap", addObjSpeFunc)


    -- affichage des boutons de suppression des objets spéciaux
    local y = 111
    for i=1, 9 do
        deleteSpeObj[i] = display.newImageRect( sceneGroup, icons, 2, 25, 25 )
        deleteSpeObj[i].anchorX = 0
        deleteSpeObj[i].anchorY = 0
        deleteSpeObj[i].x = 40
        deleteSpeObj[i].y = y
        deleteSpeObj[i].num = i
        y = y + 21
        deleteSpeObj[i]:addEventListener( "tap", deleteSpecObjFunc )
    end

    hideDeleteSpeButton()
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
        addSpecObjField:removeSelf()
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
	--addSpecObjField:removeSelf()
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
