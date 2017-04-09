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

-- Charge la fiche perso
loadSheet()

-- import mob from prepare2fight screen
local mobName = composer.getVariable("mobName")
local mobHabil = composer.getVariable("habil")
local mobEndu = composer.getVariable("endu")

-- Déclaration des variables
local parch_background, backToMenu, title, combatSeq, caracHero, combatResult, dice
local round = 1
local combatRatio = carac.habil - mobHabil + 12

print ("Combat Ratio : "..combatRatio)


-- Combat result tables
local CombatResult = 
{
    {{0,99},{0,99},{0,8},{0,8},{1,7},{2,6},{3,5},{4,4},{5,3},{6,0}},
    {{0,99},{0,8},{0,7},{1,7},{2,6},{3,6},{4,5},{5,4},{6,3},{7,0}},
    {{0,99},{0,8},{0,7},{1,7},{2,6},{3,6},{4,5},{5,4},{6,3},{7,0}},
    {{0,8},{0,7},{1,6},{2,6},{3,5},{4,5},{5,4},{6,3},{7,2},{8,0}},
    {{0,8},{0,7},{1,6},{2,6},{3,5},{4,5},{5,4},{6,3},{7,2},{8,0}},
    {{0,6},{1,6},{2,5},{3,5},{4,4},{5,4},{6,3},{7,2},{8,0},{9,0}},
    {{0,6},{1,6},{2,5},{3,5},{4,4},{5,4},{6,3},{7,2},{8,0},{9,0}},
    {{1,6},{2,5},{3,5},{4,4},{5,4},{6,3},{7,2},{8,1},{9,0},{10,0}},
    {{1,6},{2,5},{3,5},{4,4},{5,4},{6,3},{7,2},{8,1},{9,0},{10,0}},
    {{2,5},{3,5},{4,4},{5,4},{6,3},{7,2},{8,2},{9,1},{10,0},{11,0}},
    {{2,5},{3,5},{4,4},{5,4},{6,3},{7,2},{8,2},{9,1},{10,0},{11,0}},
    {{3,5},{4,4},{5,4},{6,3},{7,2},{8,2},{9,1},{10,0},{11,0},{12,0}},
    {{4,5},{5,4},{6,3},{7,3},{8,2},{9,2},{10,1},{11,0},{12,0},{14,0}},
    {{4,5},{5,4},{6,3},{7,3},{8,2},{9,2},{10,1},{11,0},{12,0},{14,0}},
    {{5,4},{6,3},{7,3},{8,2},{9,2},{10,2},{11,1},{12,0},{14,0},{16,0}},
    {{5,4},{6,3},{7,3},{8,2},{9,2},{10,2},{11,1},{12,0},{14,0},{16,0}},
    {{6,4},{7,3},{8,3},{9,2},{10,2},{11,1},{12,0},{14,0},{16,0},{18,0}},
    {{6,4},{7,3},{8,3},{9,2},{10,2},{11,1},{12,0},{14,0},{16,0},{18,0}},
    {{7,4},{8,3},{9,2},{10,2},{11,2},{12,1},{14,0},{16,0},{18,0},{99,0}},
    {{7,4},{8,3},{9,2},{10,2},{11,2},{12,1},{14,0},{16,0},{18,0},{99,0}},
    {{8,3},{9,3},{10,2},{11,2},{12,2},{14,1},{16,0},{18,0},{99,0},{99,0}},
    {{8,3},{9,3},{10,2},{11,2},{12,2},{14,1},{16,0},{18,0},{99,0},{99,0}},
    {{9,3},{10,2},{11,2},{12,2},{14,1},{16,1},{18,0},{99,0},{99,0},{99,0}}
}

-- d10 pics
local diceOptions = {
    width = 150,
    height = 150,
    numFrames = 10,
    sheetContentWidth = 750,
    sheetContentHeight = 300
}
local d10 = graphics.newImageSheet( "pic/d10.png", diceOptions )

-- dice sequence
local sequenceDice = {
    {
        name = "rollingDice",
        start = 1,
        count = 10,
        time = 1000,
        loopCount = 1
    }
}


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen


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


    -- Dice animation functions -----------------

    local function checkDiceRoll( event )
        local rollingDice = event.target
        local diceResult = math.random(10)
        if (event.phase == "ended" ) then
            rollingDice:setFrame( diceResult )

            -- affichages console
            print ("résultat du dé : "..diceResult)
            print ("round "..round.." : ")
            print ("Mob's loss"..CombatResult[combatRatio][diceResult][1])
            print ("Hero's loss"..CombatResult[combatRatio][diceResult][2])

            carac.endu = carac.endu - CombatResult[combatRatio][diceResult][2]
            mobEndu = mobEndu - CombatResult[combatRatio][diceResult][1]
            combatSeq.text = combatSeq.text.."Round "..round.." : ".."D="..diceResult.." | "..mobName.."-"..CombatResult[combatRatio][diceResult][1]..
                             " | Hero-"..CombatResult[combatRatio][diceResult][2].."\n"
            caracHero.text = "Hero :\nHabileté : "..carac.habil..", Endurance : "..carac.endu
            displayMob.text = mobName.." :\nHabileté : "..mobHabil..", Endurance : "..mobEndu

            if ( mobEndu <= 0 ) then
                event.target.isVisible = false
                combatResult.text = "Victoire"
                combatResult.isVisible = true
                jsonSave()
            elseif ( carac.endu <= 0 ) then
                event.target.isVisible = false
                combatResult.text = "Vous êtes mort"
                combatResult.isVisible = true
            end

            round = round + 1
        end
    end

    local function rollingDice( event )
        --https://docs.coronalabs.com/guide/media/spriteAnimation/index.html
        local launchDice = event.target
        launchDice:play()
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

    -- Display carac hero
    caracHero = display.newText( sceneGroup, "Hero :\nHabileté : "..carac.habil..", Endurance : "..carac.endu, 40, 50, native.systemFont, 18 )
    caracHero:setFillColor(0,0,0)
    caracHero.anchorX = 0

    -- Display mob
    displayMob = display.newText( sceneGroup, mobName.." :\nHabileté : "..mobHabil..", Endurance : "..mobEndu, 40, 100, native.systemFont, 18 )
    displayMob:setFillColor(0,0,0)
    displayMob.anchorX = 0

    -- Display combat sequence
    combatSeq = display.newText( sceneGroup, "", 40, 250, native.systemFont, 14 )
    combatSeq:setFillColor(0,0,0)
    combatSeq.anchorX = 0
    combatSeq.anchorY = 0

    -- Combat result
    combatResult = display.newText( sceneGroup, "Victoire", 40, 180, native.systemFontBold, 24 )
    combatResult:setFillColor(0,0,0)
    combatResult.x = display.contentCenterX
    combatResult.isVisible = false

    -- display dice
    local startSide = math.random(10)
    local dice = display.newSprite( sceneGroup, d10, sequenceDice )
    dice:scale(0.35,0.35)
    dice.x = display.contentCenterX
    dice.y = 180
    dice:addEventListener( "tap", rollingDice )
    dice:addEventListener( "sprite", checkDiceRoll )

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
