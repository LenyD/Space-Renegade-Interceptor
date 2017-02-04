-----------------------------------------------------------------------------------------
--
-- Classe.lua
--
-----------------------------------------------------------------------------------------
local Ennemi = {}
function Ennemi:new(leType,vaisseau,lesArmes,leJeu,ctrl)
	local ennemi = display.newGroup();

	local c_Ennemi= require('classe_'..leType)
	local c_Armes= require('classe_armes')
	
	function ennemi:init()
		--ajout des différent objets
		self.jeu = leJeu
		self.lesCtrl = ctrl
		self.ennemi = c_Ennemi:new(vaisseau,leJeu)
		self.arme=display.newGroup()
		self:insert(self.ennemi)
		self.arme=c_Armes:new(vaisseau,self.ennemi,lesArmes)
		self:insert(self.arme)
		self.load = 1
		self.distMin = 20
		self.cible= self.distMin*(math.random(1,2)*2)-3
		
	end
	
	
	
	function ennemi:enterFrame(event)
	
		local dist = self.rotation - self.cible
			if(dist>-self.distMin and dist<self.distMin) then
				self.xScale = self.xScale-0.003 
				self.yScale = self.xScale 
				self.ennemi:setEmitter('stop')
	
				if(self.xScale<0.8 and self.load==1)then
					self.load=0
					self.cible= math.random(self.distMin,self.ennemi:getRotMax())*(math.random(1,2)*2)-3
					self.ennemi:resetTriggerred()
				elseif self.xScale<0.6 then
					self.load=1
				end
			
			else
				self.xScale = self.xScale +0.02
				self.yScale = self.xScale
				if(self.xScale>1) then
					self.xScale = 1
					self.yScale = self.xScale
					self.load=1
					
				end
			end
		
		self.rotation = self.rotation-dist/36

		if(self.ennemi:getTriggerred()>0) then
			if(self.ennemi.type =='squarebot') then
				self.x=math.random(-self.ennemi:getTriggerred(),self.ennemi:getTriggerred())
				self.y=math.random(-self.ennemi:getTriggerred(),self.ennemi:getTriggerred())
			elseif (self.ennemi.type =='tincan') then
				leJeu:blackout()
			end
		end
	end

	function ennemi:getArmes()
		return self.arme:getArmes()
	end
	function ennemi:destroy(transition)
		self.alpha = self.alpha-0.02
		if self.alpha<=0 then
			self:die()
			if(transition == 'gameover') then
				self.jeu:gameover(true)
			else
				self.jeu:transition(transition)
			end
		end
	end
	function ennemi:getRot()
		return self.rotation
	end
	function ennemi:getEnn()
		return self.ennemi
	end
	function ennemi:kill()
		Runtime:removeEventListener('enterFrame',self)
		self:removeSelf();
		self=nil
	end
	function ennemi:changerMonde()
		Runtime:removeEventListener('enterFrame',self)
		self:removeSelf();
		--self=nil
	end
	function ennemi:die()
		local function genocide(enfant)
			if enfant.numChildren ~=nil then
				for i=enfant.numChildren,1,-1 do
					genocide(enfant[i])
				end
			end
			if enfant.kill ~= nil then
				enfant:kill();
			end
		end	
		genocide(self)
		--self:removeSelf();
		--self=nil
	end
	
	ennemi:init()
	Runtime:addEventListener('enterFrame',ennemi)
	return ennemi
end 

return Ennemi