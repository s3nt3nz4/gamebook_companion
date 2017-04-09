-----------------------------------------------------------------------------------------
--
-- Lone Wolf : sheet_create.lua / test sur la création de la fiche perso
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local widget = require( "widget" )
local json = require "json"
local scene = composer.newScene()


-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function gotoStart()
    composer.removeScene( "adventure_sheet" )
    composer.gotoScene( "adventure_sheet" )
end

local function gotoMenu()
    composer.removeScene( "menu" )
    composer.gotoScene( "menu" )
end

-- initialisation des variables
local carac = {
	habilOrigin = "?",
	habil = "?",
	enduOrigin = "?",
	endu = "?",
	po = "?",
	weapon = {"Hache"},
	kaiBonusWeapon = " ",
	meal = 1,
	specObj = {{"Carte géographique","",""}},
	obj = {""},
	charge = 0,
	kai = {}
}
local totalkaiRestant = 5
local filePath = system.pathForFile( "adventureSheet.json", system.DocumentsDirectory )
--print(filePath)

-- d10 pics
local diceOptions = {
    width = 150,
    height = 150,
    numFrames = 10,
    sheetContentWidth = 750,
    sheetContentHeight = 300
}
local d10 = graphics.newImageSheet( "pic/d10.png", diceOptions )

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
function scene:create( event )

	local sceneGroup = self.view

	-- Déclaration du groupe bouton disciplines kai
	local dkaiGroup = display.newGroup()

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

	-- Dice sequence ---------------------
    local sequenceDice = {
        {
            name = "rollingDice",
            start = 1,
            count = 10,
            time = 1000,
            loopCount = 0
        }
    }

    local function rollingDice( event )
        --https://docs.coronalabs.com/guide/media/spriteAnimation/index.html
        local thisDice = event.target
        thisDice:play()
    end
    --------------------------------------
--[[
    -- Dice animation functions -----------------
    local function displayDice( )
        local side = math.random(10)
        print( "displayDice called, résultat = "..side)
        dice = display.newImageRect( sceneGroup, d10, side, 50, 50 )
        dice.x = 50
        dice.y = 50
        return side
    end

    local function gotoLaunchDice( )
        timer.performWithDelay( 50, displayDice, 5 )
        result = displayDice()
        print ("Résultat final = "..result)
        dice = display.newImageRect( sceneGroup, d10, result, 50, 50 )
        dice.x = 50
        dice.y = 50
    end
    --------------------------------------------
--]]

	-- Images des cases à cocher disciplines kai
	local options_checkbox = {
		width = 100,
		height = 100,
		numFrames = 2,
		sheetContentWidth = 200,
		sheetContentHeight = 100
	}
	local kaiCheckbox = graphics.newImageSheet( "pic/checkbox-sprite.png", options_checkbox )

	-- Parchment background
	local parch_background = display.newImageRect( sceneGroup, "pic/parch_background.png", 400, 700 )
	parch_background.x = display.contentCenterX
	parch_background.y = display.contentCenterY

	-- Retour au menu
	local backToMenu = display.newImageRect(sceneGroup, "pic/arrowBack.png", 30, 30)
	backToMenu.x = 40
	backToMenu.y = 0
	backToMenu:addEventListener( "tap", gotoMenu )

	-- Titre
	local title = display.newText( sceneGroup, "Création de la feuille\n          d'aventure", 40, 10, native.systemFontBold, 20 )
	title:setFillColor(0,0,0)
	title.x = display.contentCenterX

    -- display dice
    local dice = display.newSprite( sceneGroup, d10, sequenceDice )
    dice:scale(0.35,0.35)
    dice.x = display.contentCenterX
    dice.y = 70
    dice:addEventListener( "tap", rollingDice )

	-- Habileté
	local habil = display.newText( sceneGroup, "- Habileté : "..carac.habil, 40, 120, native.systemFont, 14 )
	habil:setFillColor(0,0,0)
	habil.anchorX = 0

	-- Endurance
	local endu = display.newText( sceneGroup, "- Endurance : "..carac.endu, 40, 140, native.systemFont, 14 )
	endu:setFillColor(0,0,0)
	endu.anchorX = 0

	-- Pièces d'or
	local po = display.newText( sceneGroup, "- Pièces d'or : "..carac.po, 40, 400, native.systemFont, 14 )
	po:setFillColor(0,0,0)
	po.anchorX = 0

	-- Pièces d'or
	local obj = display.newText( sceneGroup, "- Objet de départ :\n   ?", 40, 430, native.systemFont, 14 )
	obj:setFillColor(0,0,0)
	obj.anchorX = 0

	--start
	local start = display.newText( sceneGroup, "Commencer l'aventure", 75, 470, native.systemFontBold, 18 )
	start:setFillColor( 0.5, 0.5, 0.5 )
	start.x = display.contentCenterX

	-- Display kai weapon bonus
	local kaiWeaponText = display.newText( dkaiGroup, " ", 200, 376, 100, 200, native.systemFont, 10 )
	kaiWeaponText:setFillColor(0,0,0)
	kaiWeaponText.anchorX = 0

	-- Fonction affichage start
	local function displayStart ()
		if #carac.kai == 5 and carac.habil ~= "?" then
			start:setFillColor(0,0,0)
			start:addEventListener( "tap", gotoStart )
			jsonSave()
		else
			start:setFillColor(0.5,0.5,0.5)
			start:removeEventListener( "tap", gotoStart )
		end
	end

	-- Fonction lancer de dé
  local function launchDice()
		carac.weapon = {"Hache"}
		carac.meal = 1
		carac.specObj = {{"Carte géographique","",""}}
		carac.obj = {" "}
		carac.po = "?"
		carac.habil = math.random(9)+11
		carac.habilOrigin = carac.habil
		carac.endu = math.random(9)+21
		carac.enduOrigin = carac.endu
		carac.po = math.random(9)+1

		habil.text = "- Habileté : " .. carac.habil
		endu.text = "- Endurance : " .. carac.endu
		po.text = "- Pièces d'or : " .. carac.po

		local rndObj = math.random(10)
		if rndObj == 1 then
			table.insert( carac.weapon, "Epée" )
			obj.text = "- Objet de départ :\n   " .. carac.weapon[2]
		elseif rndObj == 2 then
			table.insert( carac.specObj, {"Casque","endu",2} )
			carac.endu = carac.endu + 2
			obj.text = "- Objet de départ :\n   " .. carac.specObj[2][1] .. " Endurance + 2 => " .. carac.endu
		elseif rndObj == 3 then
			carac.meal = 3
			obj.text = "- Objet de départ :\n   2 repas en plus"
		elseif rndObj == 4 then
			table.insert( carac.specObj, {"Côte de mailles","endu",4} )
			carac.endu = carac.endu + 4
			obj.text = "- Objet de départ :\n   " .. carac.specObj[2][1] .. " Endurance + 4 => " .. carac.endu
		elseif rndObj == 5 then
			table.insert( carac.weapon, "Masse d'armes" )
			obj.text = "- Objet de départ :\n   " .. carac.weapon[2]
		elseif rndObj == 6 then
			carac.obj[1] = "Potion de guérison"
			obj.text = "- Objet de départ :\n   " .. carac.obj[1] .. " (1 dose)"
		elseif rndObj == 7 then
			table.insert( carac.weapon, "Bâton" )
			obj.text = "- Objet de départ :\n   " .. carac.weapon[2]
		elseif rndObj == 8 then
			table.insert( carac.weapon, "Lance" )
			obj.text = "- Objet de départ :\n   " .. carac.weapon[2]
		elseif rndObj == 9 then
			carac.po = carac.po + 12
			obj.text = "- Objet de départ :\n   +12 couronnes => " .. carac.po
		elseif rndObj == 10 then
			table.insert( carac.weapon, "Glaive" )
			obj.text = "- Objet de départ :\n   " .. carac.weapon[2]
		--else print("Erreur dans le choix de l'objet de départ !")
		end

		-- Kai bonus weapon
		local rndKaiWeapon = math.random(10)
		if rndKaiWeapon == 1 then carac.kaiBonusWeapon = "Poignard"
		elseif rndKaiWeapon == 2 then carac.kaiBonusWeapon = "Lance"
		elseif rndKaiWeapon == 3 then carac.kaiBonusWeapon = "Masse d'arme"
		elseif rndKaiWeapon == 4 then carac.kaiBonusWeapon = "Sabre"
		elseif rndKaiWeapon == 5 then carac.kaiBonusWeapon = "Marteau"
		elseif rndKaiWeapon == 6 then carac.kaiBonusWeapon = "Epée"
		elseif rndKaiWeapon == 7 then carac.kaiBonusWeapon = "Hache"
		elseif rndKaiWeapon == 8 then carac.kaiBonusWeapon = "Epée"
		elseif rndKaiWeapon == 9 then carac.kaiBonusWeapon = "Bâton"
		elseif rndKaiWeapon == 10 then carac.kaiBonusWeapon = "Glaive"
		end

		-- Display kai weapon bonus
		kaiWeaponText.text = "-> "..carac.kaiBonusWeapon

		displayStart()
	--	jsonSave()
  end

  dice:addEventListener( "tap", launchDice )

	-- Choix des disciplines Kai
	local dkaiTitle = display.newText( sceneGroup, "- Disciplines Kai (reste "..totalkaiRestant.." à choisir) :", 40, 160, native.systemFont, 14 )
	dkaiTitle:setFillColor(0,0,0)
	dkaiTitle.anchorX = 0

	-- Fonctions d'affichage du nombre de disciplines kai restantes
	local function addKai (typKai)
		totalkaiRestant = totalkaiRestant-1
		dkaiTitle.text = "- Disciplines Kai (reste "..totalkaiRestant.." à choisir) :"
		table.insert( carac.kai, typKai )
	end

	local function removeKai (typKai)
		totalkaiRestant = totalkaiRestant+1
		dkaiTitle.text = "- Disciplines Kai (reste "..totalkaiRestant.." à choisir) :"
		if table.indexOf( carac.kai, typKai ) ~= nil then table.remove( carac.kai, table.indexOf( carac.kai, typKai ) )
		end
	end



	-- Listener disciplines Kai
	local function dkaiListener( event )
		local Dkaicheckbox = event.target
	
	-- tests checkboxes
		if Dkaicheckbox.isOn == true and Dkaicheckbox.id == "dkaihide" then	addKai(Dkaicheckbox.id)
		elseif Dkaicheckbox.isOn == false and Dkaicheckbox.id == "dkaihide"	then removeKai(Dkaicheckbox.id)
		elseif Dkaicheckbox.isOn == true and Dkaicheckbox.id == "dkaihunt"	then addKai(Dkaicheckbox.id)
		elseif Dkaicheckbox.isOn == false and Dkaicheckbox.id == "dkaihunt"	then removeKai(Dkaicheckbox.id)
		elseif Dkaicheckbox.isOn == true and Dkaicheckbox.id == "dkai6"	then addKai(Dkaicheckbox.id)
		elseif Dkaicheckbox.isOn == false and Dkaicheckbox.id == "dkai6"	then removeKai(Dkaicheckbox.id)
		elseif Dkaicheckbox.isOn == true and Dkaicheckbox.id == "dkaiorient"	then addKai(Dkaicheckbox.id)
		elseif Dkaicheckbox.isOn == false and Dkaicheckbox.id == "dkaiorient"	then removeKai(Dkaicheckbox.id)
		elseif Dkaicheckbox.isOn == true and Dkaicheckbox.id == "dkaiheal"	then addKai(Dkaicheckbox.id)
		elseif Dkaicheckbox.isOn == false and Dkaicheckbox.id == "dkaiheal"	then removeKai(Dkaicheckbox.id)
		elseif Dkaicheckbox.isOn == true and Dkaicheckbox.id == "dkaiweapon"	then addKai(Dkaicheckbox.id)
		elseif Dkaicheckbox.isOn == false and Dkaicheckbox.id == "dkaiweapon"	then removeKai(Dkaicheckbox.id)
		elseif Dkaicheckbox.isOn == true and Dkaicheckbox.id == "dkaishield"	then addKai(Dkaicheckbox.id)
		elseif Dkaicheckbox.isOn == false and Dkaicheckbox.id == "dkaishield"	then removeKai(Dkaicheckbox.id)
		elseif Dkaicheckbox.isOn == true and Dkaicheckbox.id == "dkaipsy"	then addKai(Dkaicheckbox.id)
		elseif Dkaicheckbox.isOn == false and Dkaicheckbox.id == "dkaipsy"	then removeKai(Dkaicheckbox.id)
		elseif Dkaicheckbox.isOn == true and Dkaicheckbox.id == "dkaianima"	then addKai(Dkaicheckbox.id)
		elseif Dkaicheckbox.isOn == false and Dkaicheckbox.id == "dkaianima"	then removeKai(Dkaicheckbox.id)
		elseif Dkaicheckbox.isOn == true and Dkaicheckbox.id == "dkaitelek"	then addKai(Dkaicheckbox.id)
		elseif Dkaicheckbox.isOn == false and Dkaicheckbox.id == "dkaitelek"	then removeKai(Dkaicheckbox.id)
		end

		displayStart()
	--	jsonSave()
	end

	-- Création des checkbox pour selection des disciplines kai
	-- Camouflage ----------------------------------------------
	local dkaiHide = widget.newSwitch {
			left = 40,
			top = 170,
			style = "checkbox",
			id = "dkaihide",
			onPress = dkaiListener,
			sheet = kaiCheckbox,
			width = 20,
			height = 20,
			frameOff = 1,
			frameOn = 2
	}
  dkaiGroup:insert( dkaiHide )

	local dkaihideText = display.newText( dkaiGroup, "Camouflage", 75, 180, native.systemFont, 14 )
	dkaihideText:setFillColor(0,0,0)
	dkaihideText.anchorX = 0

	-- Chasse --------------------------------------------------
	local dkaiHunt = widget.newSwitch {
			left = 40,
			top = 190,
			style = "checkbox",
			id = "dkaihunt",
			onPress = dkaiListener,
			sheet = kaiCheckbox,
			width = 20,
			height = 20,
			frameOff = 1,
			frameOn = 2
	}
	dkaiGroup:insert( dkaiHunt )

	local dkaihuntText = display.newText( dkaiGroup, "Chasse (dispense des repas)", 75, 200, native.systemFont, 14 )
	dkaihuntText:setFillColor(0,0,0)
	dkaihuntText.anchorX = 0

	-- 6eme sens --------------------------------------------------
	local dkai6 = widget.newSwitch {
			left = 40,
			top = 210,
			style = "checkbox",
			id = "dkai6",
			onPress = dkaiListener,
			sheet = kaiCheckbox,
			width = 20,
			height = 20,
			frameOff = 1,
			frameOn = 2
	}
	dkaiGroup:insert( dkai6 )

	local dkai6Text = display.newText( dkaiGroup, "6ème sens", 75, 220, native.systemFont, 14 )
	dkai6Text:setFillColor(0,0,0)
	dkai6Text.anchorX = 0

	-- Orientation --------------------------------------------------
	local dkaiorient = widget.newSwitch {
			left = 40,
			top = 230,
			style = "checkbox",
			id = "dkaiorient",
			onPress = dkaiListener,
			sheet = kaiCheckbox,
			width = 20,
			height = 20,
			frameOff = 1,
			frameOn = 2
	}
	dkaiGroup:insert( dkaiorient )

	local dkaiorientText = display.newText( dkaiGroup, "Orientation", 75, 240, native.systemFont, 14 )
	dkaiorientText:setFillColor(0,0,0)
	dkaiorientText.anchorX = 0

	-- Guérison --------------------------------------------------
	local dkaiheal = widget.newSwitch {
			left = 40,
			top = 250,
			style = "checkbox",
			id = "dkaiheal",
			onPress = dkaiListener,
			sheet = kaiCheckbox,
			width = 20,
			height = 20,
			frameOff = 1,
			frameOn = 2
	}
	dkaiGroup:insert( dkaiheal )

	local dkaihealText = display.newText( dkaiGroup, "Guérison (+1END / § sans combat)", 75, 260, native.systemFont, 14 )
	dkaihealText:setFillColor(0,0,0)
	dkaihealText.anchorX = 0

	-- Maîtrise des armes --------------------------------------------------
	local dkaiweapon = widget.newSwitch {
			left = 40,
			top = 270,
			style = "checkbox",
			id = "dkaiweapon",
			onPress = dkaiListener,
			sheet = kaiCheckbox,
			width = 20,
			height = 20,
			frameOff = 1,
			frameOn = 2
	}
	dkaiGroup:insert( dkaiweapon )

	local dkaiweaponText = display.newText( dkaiGroup, "Maîtrise des armes", 75, 280, native.systemFont, 14 )
	dkaiweaponText:setFillColor(0,0,0)
	dkaiweaponText.anchorX = 0

	-- Bouclier psychique --------------------------------------------------
	local dkaishield = widget.newSwitch {
			left = 40,
			top = 290,
			style = "checkbox",
			id = "dkaishield",
			onPress = dkaiListener,
			sheet = kaiCheckbox,
			width = 20,
			height = 20,
			frameOff = 1,
			frameOn = 2
	}
	dkaiGroup:insert( dkaishield )

	local dkaishieldText = display.newText( dkaiGroup, "Bouclier psychique", 75, 300, native.systemFont, 14 )
	dkaishieldText:setFillColor(0,0,0)
	dkaishieldText.anchorX = 0

	-- Puissance psychique --------------------------------------------------
	local dkaipsy = widget.newSwitch {
			left = 40,
			top = 310,
			style = "checkbox",
			id = "dkaipsy",
			onPress = dkaiListener,
			sheet = kaiCheckbox,
			width = 20,
			height = 20,
			frameOff = 1,
			frameOn = 2
	}
	dkaiGroup:insert( dkaipsy )

	local dkaipsyText = display.newText( dkaiGroup, "Puissance psychique", 75, 320, native.systemFont, 14 )
	dkaipsyText:setFillColor(0,0,0)
	dkaipsyText.anchorX = 0

	-- Communication animale --------------------------------------------------
	local dkaianima = widget.newSwitch {
			left = 40,
			top = 330,
			style = "checkbox",
			id = "dkaianima",
			onPress = dkaiListener,
			sheet = kaiCheckbox,
			width = 20,
			height = 20,
			frameOff = 1,
			frameOn = 2
	}
	dkaiGroup:insert( dkaianima )

	local dkaianimaText = display.newText( dkaiGroup, "Communication animale", 75, 340, native.systemFont, 14 )
	dkaianimaText:setFillColor(0,0,0)
	dkaianimaText.anchorX = 0

	-- Maîtrise psychique de la matière --------------------------------------------------
	local dkaitelek = widget.newSwitch {
			left = 40,
			top = 350,
			style = "checkbox",
			id = "dkaitelek",
			onPress = dkaiListener,
			sheet = kaiCheckbox,
			width = 20,
			height = 20,
			frameOff = 1,
			frameOn = 2
	}
	dkaiGroup:insert( dkaitelek )

	local dkaitelekText = display.newText( dkaiGroup, "Maîtrise psychique de la matière", 75, 360, native.systemFont, 14 )
	dkaitelekText:setFillColor(0,0,0)
	dkaitelekText.anchorX = 0

	-- Déplace le groupe dkaiGroup
	dkaiGroup.x = 10
	dkaiGroup.y = 10

	-- insert groupe kai dans sceneGroup -------------------------
	sceneGroup:insert( dkaiGroup )

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
