-----------------------------------------------------------------------------------------
--
-- squarebot.lua
--
-----------------------------------------------------------------------------------------
local Squarebot ={}


function Squarebot:new(leVaisseau,leJeu)
	local squarebot = display.newGroup()
		--Méthodes
	function squarebot:init()
		--init
		local particleDesigner = require('particleDesigner')
		self.jeu = leJeu
		self.type = 'squarebot'
		self.rotMax=45
		
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
		
		self.pointArme4 = display.newGroup()
		self.pointArme4.x = 0 
		self.pointArme4.rotation = 0 
		self.pointArme4.y = -190 
		self.trigger = 0
		self.triggerMax = 15
		
		self.tArmes = {self.pointArme1,self.pointArme2,self.pointArme3,self.pointArme4}
		self.squarebot = display.newImage('img/ennemis/squarebot.png')
																
		self:insert(self.squarebot)
		self.emitter = particleDesigner.newEmitter('emitter64990.rg')
		self.emitter.xScale=0.5
		self.emitter.yScale=self.emitter.xScale
		
		self:insert(self.emitter)
		self.gauge = display.newImage('img/ennemis/gauge.png')
		self.gaugeFill = display.newImage('img/ennemis/gaugefill.png')
		self.gaugeFill.anchorX=0
		self.gaugeFill.x=-self.gaugeFill.width/2
		self.laGauge = display.newGroup()
		self.laGauge.y = 100
		self.laGauge:insert(self.gaugeFill)
		self.laGauge:insert(self.gauge)
		self:insert(self.laGauge)
		
		self.healthMax = 25000
		self.health = self.healthMax
		self.gaugeFill.xScale =self.health/self.healthMax
		self.etat='vivant'
		
		self.r = 170
		self.nbArme=2
	end
	
	function squarebot:changerMonde()
		--removeEvent
		self:removeSelf()
		--self=nil
	end
	function squarebot:kill()
		--removeEvent
		Runtime:removeEventListener('enterFrame',self)
		self:removeSelf()
		self=nil
	end

	function squarebot:enterFrame()
		if self.etat =='destroyed' then
			self.parent:destroy('tincan')
		end
	end
	
	function squarebot:reduceHealth (dmg)
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
	function squarebot:getHealthMax()
		return self.healthMax
	end
	function squarebot:getArmes()
		return self.tArmes
	end
	function squarebot:getTArmes()
		return self.nbArme
	end
	function squarebot:getTriggerred()
		self.trigger = self.trigger-0.03
		return self.trigger
	end
	function squarebot:getRotMax()
		return self.rotMax
	end
	function squarebot:resetTriggerred()
		self.trigger = self.triggerMax
		self.emitter:start()
	end
	function squarebot:setEmitter(etat)
		if(etat== 'play' or etat == 'start') then
			self.emitter:start()
		else
			self.emitter:stop()
		end
	end
	
	squarebot:init()
	--Event
	Runtime:addEventListener('enterFrame',squarebot)
	return squarebot
end

return Squarebot