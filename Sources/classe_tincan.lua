-----------------------------------------------------------------------------------------
--
-- Tincan.lua
--
-----------------------------------------------------------------------------------------
local Tincan ={}


function Tincan:new(leVaisseau,leJeu)
	local tincan = display.newGroup()
		--Méthodes
	function tincan:init()
		--init
		
		local particleDesigner = require('particleDesigner')
		self.jeu = leJeu
		self.type = 'tincan'
		self.forme='small'
		self.rotMax=45
		self.yScale=self.xScale
		self.vaisseau = leVaisseau
		self.objType = 'npc'
		self.pointArme1 = display.newGroup()
		self.pointArme1.x = 150 
		self.pointArme1.rotation = 90 
		self.pointArme1.y = 70
		
		self.pointArme2 = display.newGroup()
		self.pointArme2.x = -150 
		self.pointArme2.rotation = -90 
		self.pointArme2.y = 70 
		
		self.pointArme3 = display.newGroup()
		self.pointArme3.x = 0 
		self.pointArme3.rotation = 180 
		self.pointArme3.y = 190 
		
		self.pointArme4 = display.newGroup()
		self.pointArme4.x = 0 
		self.pointArme4.rotation = 0 
		self.pointArme4.y = -190 
		
		self.pointArme5 = display.newGroup()
		self.pointArme5.x = 150 
		self.pointArme5.rotation = 90 
		self.pointArme5.y = -70
		
		self.pointArme6 = display.newGroup()
		self.pointArme6.x = -150 
		self.pointArme6.rotation = -90 
		self.pointArme6.y = -70
		
		self.trigger = 0
		self.triggerMax = 2
		self.triggerMax = 2
		
		self.tArmes = {self.pointArme1,self.pointArme2,self.pointArme3,self.pointArme4,self.pointArme5,self.pointArme6}
		self.tincan = display.newImage('img/ennemis/tincan.png')
																
		self:insert(self.tincan)

		self.gauge = display.newImage('img/ennemis/gauge.png')
		self.gaugeFill = display.newImage('img/ennemis/gaugefill.png')
		self.gaugeFill.anchorX=0
		self.gaugeFill.x=-self.gaugeFill.width/2
		self.laGauge = display.newGroup()
		self.laGauge.y = 100
		self.laGauge:insert(self.gaugeFill)
		self.laGauge:insert(self.gauge)
		self:insert(self.laGauge)
		
		self.healthMax = 75000
		self.health = self.healthMax
		self.etat ='vivant'
		self.gaugeFill.xScale =self.health/self.healthMax
		self.r = 170
		self.nbArme = 3
	end
	
	function tincan:changerMonde()
		--removeEvent
		self:removeSelf()
		--self=nil
	end
	function tincan:kill()
		--removeEvent
		Runtime:removeEventListener('enterFrame',tincan)
		self:removeSelf()
		self=nil
	end
	function tincan:enterFrame()
		if self.etat =='destroyed' then
			self.parent:destroy('gameover')
		end
	end
	function tincan:reduceHealth (dmg)
		self.health = self.health-dmg
		self.gaugeFill.xScale =self.health/self.healthMax
		if self.health<0  then
			self.health = 0
			self.etat ='destroyed'
			self.jeu:gameover(true)
		
		end
	end
	function tincan:getHealthMax()
		return self.healthMax
	end
	function tincan:getArmes()
		return self.tArmes
	end
	function tincan:getTArmes()
		return self.nbArme
	end
	function tincan:getTriggerred()
		self.trigger = self.trigger-1
		return self.trigger
	end
	function tincan:getRotMax()
		return self.rotMax
	end
	function tincan:getForme()
		return self.forme
	end
	function tincan:resetTriggerred()
		self.trigger = self.triggerMax

	end
	function tincan:setEmitter(etat)

	end
	
	tincan:init()
	--Event
	Runtime:addEventListener('enterFrame',tincan)
	return tincan
end

return Tincan