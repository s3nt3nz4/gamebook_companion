-- -----------------------------------------------------------------------------------
-- Fiche d'aventure
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

local function gotoBackpack()
    composer.removeScene( "backpack" )
    composer.gotoScene( "backpack" )
end

local function gotoSpecialObjects()
    composer.removeScene( "specialobjects" )
    composer.gotoScene( "specialobjects" )
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
local options_icons, icons, parch_background, backToMenu, title, habil, endu, kai, weapon, sack, po, minus, plus, backpack, backpackMeal, tapToOpen, obj, backpackSpecial

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    composer.removeScene("backpack")
    local sceneGroup = self.view
    
    -- Déclaration groupes
    local poGroup = display.newGroup()
    local backpackGroup = display.newGroup()
    local backpackSpecGroup = display.newGroup()

    -- Charge la fiche perso
    loadSheet()

    -- scene create functions

    -- Fonction de stockage de la fiche de perso dans un fichier json
    local function jsonSave()
        local jsonCarac = json.encode( carac )
        print(jsonCarac)
        local adventureSheet = io.open (filePath, "w")
        if adventureSheet then
            adventureSheet:write( json.encode(carac) )
            io.close( adventureSheet )
        end
    end

    local function addPO()
        if carac.po <= 49 then carac.po = carac.po + 1 else carac.po = 50 end
        po.text = carac.po
        jsonSave()
    end

    local function removePO()
        if carac.po >= 1 then carac.po = carac.po - 1 else carac.po = 0 end
        po.text = carac.po
        jsonSave()
    end

    -- Conversion du code discipline kai en libellé
    local function kaiDecode(kai)
        local libKai = ""
        if kai == "dkaihide" then libKai = "Camouflage"
        elseif kai == "dkaihunt" then libKai = "Chasse"
        elseif kai == "dkai6" then libKai = "6ème sens"
        elseif kai == "dkaiorient" then libKai = "Orientation"
        elseif kai == "dkaiheal" then libKai = "Guérison"
        elseif kai == "dkaiweapon" then libKai = "Maîtrise des armes"
        elseif kai == "dkaishield" then libKai = "Bouclier psychique"
        elseif kai == "dkaipsy" then libKai = "Puissance psychique"
        elseif kai == "dkaianima" then libKai = "Communication animale"
        elseif kai == "dkaitelek" then libKai = "Maîtrise psychique de la matière"            
        end
        return libKai
    end

    -- +/- pics
    options_icons = {
        width = 100,
        height = 100,
        numFrames = 6,
        sheetContentWidth = 300,
        sheetContentHeight = 200
    }
    icons = graphics.newImageSheet( "pic/icons.png", options_icons )


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
    backToMenu:addEventListener( "tap", gotoMenu )

    -- Titre
    title = display.newText( sceneGroup, "Feuille d'aventure", 40, 10, native.systemFontBold, 20 )
    title:setFillColor(0,0,0)
    title.x = display.contentCenterX

    -- Habileté
    habil = display.newText( sceneGroup, "Habileté : "..carac.habil, 40, 50, native.systemFont, 18 )
    habil:setFillColor(0,0,0)
    habil.anchorX = 0

    -- Endurance
     endu = display.newText( sceneGroup, "Endurance : "..carac.endu, 160, 50, native.systemFont, 18 )
    endu:setFillColor(0,0,0)
    endu.anchorX = 0

    -- Disciplines kai
    kai = display.newText( sceneGroup, "Disciplines kai :\n", 40, 80, native.systemFont, 16 )
    kai:setFillColor(0,0,0)
    kai.anchorX = 0
    

    -- Alimentation du tableau des disciplines kai
    for i=1, #carac.kai do
        print(carac.kai[i])
        kai.text = kai.text .. i .. " - " .. kaiDecode(carac.kai[i]) .. "\n"
        kai.anchorY = 0
    end

    -- Armes
    weapon = display.newText( sceneGroup, "Armes (max 2) :\n", 40, 210, 200, 0, native.systemFont, 16 )
    weapon:setFillColor(0,0,0)
    weapon.anchorX = 0

    -- Alimentation du tableau des armes (avec test sur le nombre d'armes -> max 2)
    if #carac.weapon > 2 then print ("ERROR : NUMBER OF WEAPON > 2 !!!")
    else
        for i=1, #carac.weapon do
            weapon.text = weapon.text .. "  " .. carac.weapon[i] .. "\n"
            weapon.anchorY = 0
        end
    end

    -- Sacs
    -- Bourse po
    sack = display.newImageRect( poGroup, "pic/sack.png", 96, 70 )
    sack.anchorX = 1
    sack.x = 280
    sack.y = 245

    --Affichage pieces d'or
    po = display.newText( poGroup, carac.po, 260, 240, native.systemFontBold, 26)
    po:setFillColor(0,0,0)
    po.anchorX = 1

    -- Ajouter soustraire PO
    minus = display.newImageRect( poGroup, icons, 2, 30, 30 )
    minus.x = 210
    minus.y = 240
    minus:addEventListener( "tap", removePO )

    plus = display.newImageRect( poGroup, icons, 1, 30, 30 )
    plus.x = 280
    plus.y = 240
    plus:addEventListener( "tap", addPO )

    sceneGroup:insert( poGroup )


    -- sacs à dos
    backpack = display.newImageRect( backpackGroup, "pic/backpack_red.png", 140, 140 )
    backpack.anchorX = 0
    backpack.x = 20
    backpack.y = 380
    backpack:addEventListener( "tap", gotoBackpack )

    backpackSpecial = display.newImageRect( backpackGroup, "pic/backpack_green.png", 140, 140 )
    backpackSpecial.anchorX = 0
    backpackSpecial.x = 160
    backpackSpecial.y = 380
    backpackSpecial:addEventListener( "tap", gotoSpecialObjects )

    backpackMeal = display.newText( backpackGroup, "Repas : " .. carac.meal .. "\n", 57, 360, 100, 0, native.systemFont, 16 )
    backpackMeal:setFillColor(0,0,0)
    backpackMeal.anchorX = 0

    tapToOpen = display.newText(backpackGroup, "Ouvrir", 65, 400, 80, 0, native.systemFont, 18)
    tapToOpen:setFillColor(0,0,0)
    tapToOpen.anchorX = 0

    obj = display.newText(backpackGroup, "Sac à dos", 55, 450, native.systemFont, 16)
    obj:setFillColor(0,0,0)
    obj.anchorX = 0

    tapToOpenSpe = display.newText(backpackGroup, "Ouvrir", 205, 400, 80, 0, native.systemFont, 18)
    tapToOpenSpe:setFillColor(0,0,0)
    tapToOpenSpe.anchorX = 0

    objSpe = display.newText(backpackGroup, "Objets spéciaux", 175, 450, native.systemFont, 16)
    objSpe:setFillColor(0,0,0)
    objSpe.anchorX = 0

    sceneGroup:insert( backpackGroup )

    -- move bags
    backpackGroup.y = -20
    poGroup.x = -10
    poGroup.y = 0


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
