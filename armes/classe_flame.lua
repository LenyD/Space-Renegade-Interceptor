-----------------------------------------------------------------------------------------
--
-- flame.lua
--
-----------------------------------------------------------------------------------------
local Flame ={}

function Flame:new(leVaisseau,x,y,rot,hp)
	local flame = display.newGroup()
		--Méthodes
		
	function flame:init()
		--init
		local particleDesigner = require('particleDesigner')
		
		self.objType = 'npc'
		self.vaisseau = leVaisseau
		self.type = arme
		self.base = display.newImage('img/armes/g_base.png')
		self.canon = display.newGroup()
		self.canonImg =display.newImage('img/armes/g_flame.png')
		self.canonImg.y = self.canonImg.x-20
		self.canon.y = self.canonImg.x+20
		self.bulletSpawn = {display.newGroup()}
		self.bulletSpawn[1].y =-60
		self.y = y
		self.x = x
		self.rotMax = 65
		self.changeModeMin = 5
		self.changeModeMax = 15
		self.rotation = rot
		self.cibleRot = math.random(-self.rotMax,self.rotMax)
		self.circ = display.newCircle(self.bulletSpawn[1].x,self.bulletSpawn[1].y-160,80)
		self.circ.alpha = 0
		self.emitter = particleDesigner.newEmitter('emitter11933.rg')
		self.emitter.y =self.bulletSpawn[1].y
		self.canon:insert(self.emitter)
		self.canon:insert(self.circ)
		self.canon:insert(self.canonImg)

		for i=1,#self.bulletSpawn do
			self.canon:insert(self.bulletSpawn[i])
		end
		
		self:insert(self.canon)
		self:insert(self.base)
		self.dist=0
		self.r = 50
		
		
		
		self.tShootType ={'swipe','auto'}
		self.shootType = self.tShootType[math.floor(math.random(#self.tShootType))]
		self.state = self.shootType
		self.tire =0
		self.rate =300
		self.rateCpt =0
		self.rateMod=1
		self.change =1
		self.bullet = 'special'
		self.dmg = 2
		


		self.F_setCible =  function()
			self.change = 1
			return self:setCible(math.random(-self.rotMax,self.rotMax))
		end
		
		self.F_shootType =  function()
			self.cibleRot = math.random(-self.rotMax,self.rotMax)
			return self:setShootType(math.random(1,#self.tShootType))
		end
		
		timer.performWithDelay( math.random(self.changeModeMin*1000,self.changeModeMax*1000),self.F_shootType,0)
				
		self.hitBox = display.newCircle(0,45,self.width/2.5)
		self.hitBox.alpha = 0
		self:insert(self.hitBox)

		
		self.gauge = display.newImage('img/ennemis/gauge.png')
		self.gaugeFill = display.newImage('img/ennemis/gaugefill.png')
		self.gaugeFill.anchorX=0
		self.gaugeFill.x=-self.gaugeFill.width/2
		self.laGauge = display.newGroup()
		self.laGauge.y = 30
		self.laGauge:insert(self.gaugeFill)
		self.laGauge:insert(self.gauge)
		self.laGauge.xScale = 0.5
		self.laGauge.yScale = 0.5
		self:insert(self.laGauge)
		
		self.healthMax = hp*0.3
		self.health = self.healthMax
		self.etat = 'vivant'

		self.son = audio.loadSound( "sons/flame.mp3" )
		self.playing = false
	end
	
	function flame:changerMonde()
		--removeEvent
		Runtime:removeEventListener('enterFrame',self)
		self:removeSelf()
		--self=nil
	end
	
	function flame:kill()
		--removeEvent
		Runtime:removeEventListener('enterFrame',self)
		self:removeSelf()
		self=nil
	end

	function flame:destroy()
		--removeEvent
		Runtime:removeEventListener('enterFrame',self)
		self.alpha = 0.3
		self.emitter:stop()
		self.etat = 'destroyed'
	end
	
	function flame:enterFrame(event)
		self.rateCpt = self.rateCpt+self.rateMod
		local dist = self.cibleRot-self.canon.rotation
	
		self.canon.rotation = self.canon.rotation+dist/20
		if self.shootType == 'swipe' then
			if(dist<0.75 and dist>-0.75) then
				self.cibleRot=-self.cibleRot
			end
		elseif self.shootType == 'auto' then
		end	
		if self.rateCpt<=0 then
			self.emitter:start()
			self.rateMod=2
		elseif self.rateCpt>self.rate then
			self.emitter:stop()
			self.rateMod=-3
		end
		if self.emitter.state =='playing' then
			if self:detectCollision(self.circ,self.vaisseau) then
				self.vaisseau:reduceHp(self.dmg)
			end
		end
		if(self.emitter.state=='playing')then
			audio.play(self.son)
		end
	end
	
	function flame:tirer()

	end
	
	function flame:detectCollision(obj1,obj2)
		if ( obj1 ~= nil and obj2 ~= nil ) then  
			local o1x,o1y = obj1:localToContent(0,0)
			local o2x,o2y = obj2:localToContent(0,0)
			local dx = o1x - o2x
			local dy =  o1y - o2y

			local distance = math.sqrt( dx*dx + dy*dy )
			local objectSize = (obj2.contentWidth/4) + (obj1.contentWidth/2)
			if ( distance < objectSize ) then
				return true
			end
		else
			return false
		end
	end
	function flame:setCible(angle)
		self.cibleRot=angle
	end
	
	function flame:setShootType(nb)
		self.shootType = self.tShootType[nb]
	end
	function flame:getHitBox()
		return self.hitBox
	end
	function flame:reduceHealth (dmg)
		self.health = self.health-dmg
		self.gaugeFill.xScale =self.health/self.healthMax
		if self.health<0  then
			self.health = 0
			self.gaugeFill.xScale =0.01
			if self.etat ~= 'destroyed' then
				self:upgrade()
				self:destroy()
			end
		end
	end
	function flame:upgrade()
		self.vaisseau:setAtkSpeed(2)
		self.vaisseau:setHue()
		self.vaisseau:setVit(2)
								--dmg,spd,aspd,sspd,special
		self.vaisseau.control:upgradePopUp('0','++','+','0','Cool flames')
	end
	
	function flame:getPos()
		return self.canon:localToContent(0,0)
	end
	
	function flame:getBulletSpawn()
		return self.bulletSpawn
	end
	function flame:getAng()
		return self.canon.rotation-self.rotation
	end
	
	function flame:getTire()
		return self.tire
	end
	function flame:getDmg()
		return self.dmg
	end
	function flame:getBullet()
		return self.bullet
	end
	
	function flame:resetTire()
		self.tire=0
		self.rateCpt=0
	end
	flame:init()
	--Event
	Runtime:addEventListener('enterFrame',flame)
	
	return flame
end

return Flame