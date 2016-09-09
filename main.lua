-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
display.setStatusBar(display.HiddenStatusBar)
--local physics = require('physics')
--physics.setDrawMode('hybrid')
--physics:start()
--physics.setGravity(0,0)

local c_Jeu = require('classe_jeu')
local c_Menu = require('classe_menu')
local Screens ={}


function Screens:creerJeu()
	
	self.monJeu=c_Jeu:new(self)
	self.monJeu:creerOeuil();
end

function Screens:creerMenu(transition)
	local monMenu=c_Menu:new(self,transition)
	local rect1 = display.newRect(-512,500,1024,1000)
	local rect2 = display.newRect(1536,500,1024,1000)
	
	rect1:setFillColor( 0 )
	rect2:setFillColor( 0 )
end

function Screens:changerEnnemi(transition)
	if(transition == 'squarebot')then
		self.monJeu:creerSquareBot();
	elseif transition == 'tincan' then
		self.monJeu:creerTincan();
	end
end

Screens:creerMenu('')
--Screens:creerJeu()
