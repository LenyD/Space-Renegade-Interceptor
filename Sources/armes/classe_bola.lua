-----------------------------------------------------------------------------------------
--
-- Bola.lua
--
-----------------------------------------------------------------------------------------
local Bola ={}

function Bola:new(leVaisseau,x,y,rot,hp)
	local bola = display.newGroup()
		--Méthodes
		
	function bola:init()
		--init
		self.objType = 'npc'
		self.vaisseau = leVaisseau
		self.type = arme
		self.base = display.newImage('img/armes/g_base.png')
		self.canon = display.newGroup()
		self.deco = display.newImage('img/armes/d_bola.png')
		self.deco.y =  -35
		self.deco.anchorY =  0.3
		
		self.canonImg =display.newImage('img/armes/g_bola.png')
		self.canonImg.y = self.canonImg.x-20
		self.canon.y = self.canonImg.x+20
		self.bulletSpawn = {display.newGroup()}
		self.bulletSpawn[1].y =-30
		self.y = y
		self.x = x
		self.rotMax = 70
		self.changeModeMin = 5
		self.changeModeMax = 8
		self.rotation = rot
		self.cibleRot = math.random(-self.rotMax,self.rotMax)
		
		
		self.canon:insert(self.canonImg)
		for i=1,#self.bulletSpawn do
			self.canon:insert(self.bulletSpawn[i])
		end
		
		self:insert(self.canon)
		self.canon:insert(self.deco)
		self:insert(self.base)
		self.dist=0
		self.r = 50
		
		
		
		self.tShootType ={'raffale','auto','bolt','swipe'}
		--{'raffale','bolt'}
		self.shootType = self.tShootType[math.floor(math.random(#self.tShootType))]
		self.state = self.shootType
		self.tire =0
		self.rate =20
		self.rateCpt =0
		self.change =1
		self.bullet = 'bola'
		self.dmg = 15
		


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
		
		self.healthMax = hp*0.4
		self.health = self.healthMax
		self.etat = 'vivant'
		
		self.son = audio.loadSound( "sons/bola.mp3" )
		self.playing = false
	end
	
	function bola:changerMonde()
		--removeEvent
		Runtime:removeEventListener('enterFrame',self)
		self:removeSelf()
		--self=nil
	end
	function bola:kill()
		--removeEvent
		Runtime:removeEventListener('enterFrame',self)
		self:removeSelf()
		self=nil
	end

	function bola:destroy()
		--removeEvent
		Runtime:removeEventListener('enterFrame',self)
		self.alpha = 0.3
		self.etat = 'destroyed'
	end
	
	function bola:enterFrame(event)
		self.rateCpt = self.rateCpt+1
		local dist = self.cibleRot-self.canon.rotation
		self.deco.rotation = self.deco.rotation+25
		self.canon.rotation = self.canon.rotation+dist/20
		if self.shootType == 'swipe' then
			if(dist<0.75 and dist>-0.75) then
				self.cibleRot=-self.cibleRot
			else
				if self.rateCpt>self.rate then
				self:tirer()
				end	
			end
			
			
		elseif self.shootType == 'raffale' then
		
			if(dist<3 and dist>-3) then
				if self.rateCpt>self.rate then
					self:tirer()
					
				end	
				if self.change > 0 then
					self.change = 0
					timer.performWithDelay( math.random(4*1000,6*1000),self.F_setCible,1)
				end
			end
			
		elseif self.shootType == 'bolt' then
			if(dist<1 and dist>-1) then
				if self.rateCpt>self.rate then
					self:tirer()
				end	
				if self.change > 0 then
					self.change = 0
					self.cibleRot = math.random(-self.rotMax,self.rotMax)
					--timer.performWithDelay( math.random(1*1000,3*1000),self.F_setCible,0)
				end
			else
				self.change = 1
			end	
		elseif self.shootType == 'auto' then

			if(dist<1 and dist>-1) then
				if self.rateCpt>self.rate then
					self:tirer()
				end	
			end
		end	
	end
	
	function bola:tirer()
		self.tire = 1	
		self.rateCpt = 0
		
		if self.playing~= true then
			local function playingOff()
				self.playing = false
			end
			audio.play(self.son,{channel=self.channel,duration=900,onComplete=playingOff})
			self.playing = true
		end
	end
	function bola:setCible(angle)
		self.cibleRot=angle
	end
	
	function bola:setShootType(nb)
		self.shootType = self.tShootType[nb]
	end
	function bola:getHitBox()
		return self.hitBox
	end
	function bola:reduceHealth (dmg)
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
	function bola:upgrade()
		self.vaisseau:setAtkSpeed(1)
		self.vaisseau:setDmg(2)
		self.vaisseau:setBullet(self.bullet)
						--dmg,spd,aspd,sspd,special
		self.vaisseau.control:upgradePopUp('+','0','+','0','Curve shot')
	end
	function bola:getPos()
		return self.canon:localToContent(0,0)
	end
	
	function bola:getBulletSpawn()
		return self.bulletSpawn
	end
	function bola:getAng()
		return self.canon.rotation-self.rotation
	end
	
	function bola:getTire()
		return self.tire
	end
	
	function bola:getDmg()
		return self.dmg
	end
	
	function bola:getBullet()
		return self.bullet
	end
	
	function bola:resetTire()
		self.tire=0
		self.rateCpt=0
	end
	bola:init()
	--Event
	Runtime:addEventListener('enterFrame',bola)
	
	return bola
end

return Bola