-- -----------------------------------------------------------------------------------
-- prepare2fight.lua
-- -----------------------------------------------------------------------------------


local composer = require( "composer" )

local scene = composer.newScene()

local widget = require( "widget" )

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function gotoAdventureSheet()
    composer.removeScene( "adventure_sheet" )
    composer.gotoScene( "adventure_sheet" )
end

local function gotoCombat()
    composer.removeScene( "fight" )
    composer.gotoScene( "fight" )
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
local parch_background, backToMenu, title, choose, displayMob, startCombat

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

    local function chooseMob()    
      -- Get the table of current values for all columns
      -- This can be performed on a button tap, timer execution, or other event
      local values = pickerWheelFight:getValues()
       
      -- Get the value for each column in the wheel, by column index
      local currentMob = values[1].value
      local currentHabil = values[2].value
      local currentEndu = values[3].value
       
      print( currentMob, currentHabil, currentEndu )
      displayMob.text = currentMob.." :\nHabileté : "..currentHabil..", Endurance : "..currentEndu
      startCombat.text = "Combattre"

      composer.setVariable("mobName", currentMob )
      composer.setVariable("habil", currentHabil )
      composer.setVariable("endu", currentEndu )
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
    title = display.newText( sceneGroup, "Combat", 40, 10, native.systemFontBold, 20 )
    title:setFillColor(0,0,0)
    title.x = display.contentCenterX

    -- Choose
    choose = display.newText( sceneGroup, "Choisir", 40, 320, native.systemFontBold, 20 )
    choose:setFillColor(0,0,0)
    choose.x = display.contentCenterX

    -- Display mob
    displayMob = display.newText( sceneGroup, "", 40, 380, native.systemFont, 18 )
    displayMob:setFillColor(0,0,0)
    displayMob.x = display.contentCenterX

    -- Start combat
    startCombat = display.newText( sceneGroup, "", 40, 440, native.systemFontBold, 20 )
    startCombat:setFillColor(0,0,0)
    startCombat.x = display.contentCenterX
    startCombat:addEventListener( "tap", gotoCombat )


    -----------------------
    -- pickerwheelFight
    -----------------------

    -- Set up the picker wheel columns
    local columnData =
    {
        {
            align = "left",
            width = 126,
            startIndex = 2,
            labels = { "Kraan", "Vordak", "Black Bear", "Giak" }
        },
        {
            align = "left",
            labelPadding = 40,
            startIndex = 2,
            labels = { 9, 16, 17 }
        },
        {
            align = "left",
            labelPadding = 10,
            startIndex = 3,
            labels = { 9, 10, 24, 25 }
        }
    }
     
    -- Create the widget
    pickerWheelFight = widget.newPickerWheel(
    {
        x = display.contentCenterX,
        top = 60,
        fontSize = 18,
        columns = columnData
    })  
    
    choose:addEventListener( "tap", chooseMob )


    ----------------------------------------------

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
        pickerWheelFight:removeSelf()

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
