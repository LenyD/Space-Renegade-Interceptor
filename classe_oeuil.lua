-----------------------------------------------------------------------------------------
--
-- Oeuil.lua
--
-----------------------------------------------------------------------------------------
local Oeuil ={}


function Oeuil:new(leVaisseau,leJeu)
	local oeuil = display.newGroup()
		--Méthodes
	function oeuil:init()
		--init
		self.jeu = leJeu
		self.type = 'oeuil'
		self.rotMax = 140
		self.vaisseau = leVaisseau
		self.objType = 'npc'
		self.pointArme1 = display.newGroup()
		self.pointArme1.x = 190 
		self.pointArme1.rotation = 90 
		self.pointArme1.y = 0 
		
		self.pointArme2 = display.newGroup()
		self.pointArme2.x = -190 
		self.pointArme2.rotation = -90 
		self.pointArme2.y = 0 
		
		self.pointArme3 = display.newGroup()
		self.pointArme3.x = 0 
		self.pointArme3.rotation = 180 
		self.pointArme3.y = 190 
	
		self.tArmes = {self.pointArme1,self.pointArme2,self.pointArme3}
		self.unOeuil = display.newImage('img/ennemis/oeuil.png')
		self:insert(self.unOeuil)
		
		self.gauge = display.newImage('img/ennemis/gauge.png')
		self.gaugeFill = display.newImage('img/ennemis/gaugefill.png')
		self.gaugeFill.anchorX=0
		self.gaugeFill.x=-self.gaugeFill.width/2
		self.laGauge = display.newGroup()
		self.laGauge.y = 50
		self.laGauge:insert(self.gaugeFill)
		self.laGauge:insert(self.gauge)
		self:insert(self.laGauge)
		
		self.healthMax = 5000
		self.health = self.healthMax
		self.etat='vivant'
		
		self.gaugeFill.xScale =self.health/self.healthMax
		
		self.r = 170
		self.nbArme = 1
	end
	function oeuil:enterFrame()
		if self.etat =='destroyed' then
			self.parent:destroy('squarebot')
		end
	end
	function oeuil:kill()
		--removeEvent
		Runtime:removeEventListener('enterFrame',self)
		self:removeSelf()
		self=nil
	end

	function oeuil:reduceHealth (dmg)
		self.health = self.health-dmg
		local scale =self.health/self.healthMax
		if self.health<=0  then
			self.health = 0
			scale=0.01
			self.etat='destroyed'
			self.gaugeFill.xScale =scale
			return
		end
		self.gaugeFill.xScale =scale
	end
	function oeuil:getHealthMax()
		return self.healthMax
	end
	function oeuil:getRotMax()
		return self.rotMax
	end
	function oeuil:getArmes()
		return self.tArmes
	end
	function oeuil:getTArmes()
		return self.nbArme
	end
	function oeuil:getTriggerred()
		return 0
	end
	
	function oeuil:resetTriggerred()
		return 0
	end
	function oeuil:setEmitter(etat)
		return
	end
	
	oeuil:init()
	Runtime:addEventListener('enterFrame',oeuil)
	--Event
	
	return oeuil
end

return Oeuil