-----------------------------------------------------------------------------------------
--
-- quadcan.lua
--
-----------------------------------------------------------------------------------------
local Quadcan ={}

function Quadcan:new(leVaisseau,x,y,rot,hp)
	local quadcan = display.newGroup()
		--Méthodes
		
	function quadcan:init()
		--init
		self.objType = 'npc'
		self.vaisseau = leVaisseau
		self.type = arme
		self.base = display.newImage('img/armes/g_base.png')
		self.canon = display.newGroup()
		self.canonImg =display.newImage('img/armes/g_quadcan.png')
		self.canonImg.y = self.canonImg.x-20
		self.canon.y = self.canonImg.x+20
		self.bulletSpawn = {display.newGroup(),display.newGroup(),display.newGroup(),display.newGroup()}
		self.bulletSpawn[1].x =-10
		self.bulletSpawn[2].x =-5		
		self.bulletSpawn[3].x = 5
		self.bulletSpawn[4].x = 10		
		self.bulletSpawn[1].y =-50
		self.bulletSpawn[2].y =-50
		self.bulletSpawn[3].y =-50
		self.bulletSpawn[4].y =-50
		self.y = y
		self.x = x
		self.rotMax = 60
		self.changeModeMin = 5
		self.changeModeMax = 25
		self.rotation = rot
		self.cibleRot = math.random(-self.rotMax,self.rotMax)
		
		
		self.canon:insert(self.canonImg)
		for i=1,#self.bulletSpawn do
			self.canon:insert(self.bulletSpawn[i])
		end
		
		self:insert(self.canon)
		self:insert(self.base)
		self.dist=0
		self.r = 50
		
		
		
		self.tShootType ={'raffale','swipe','bolt'}
		--{'raffale','auto','swipe','bolt'}
		self.shootType = self.tShootType[math.floor(math.random(#self.tShootType))]
		self.state = self.shootType
		self.raffale = 4
		self.tire =0
		self.rate =30
		self.rateCpt =0
		self.change =1
		self.bullet = 'canonball'
		self.dmg = 8

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
		
		self.healthMax = hp*0.45
		self.health = self.healthMax
		self.etat = 'vivant'
		
		self.son = audio.loadSound( "sons/quadcan.mp3" )
		self.playing = false
	end
	
	function quadcan:changerMonde()
		--removeEvent
		Runtime:removeEventListener('enterFrame',self)
		self:removeSelf()
		--self=nil
	end
	function quadcan:kill()
		--removeEvent
		Runtime:removeEventListener('enterFrame',self)
		self:removeSelf()
		self=nil
	end
	function quadcan:destroy()
		--removeEvent
		Runtime:removeEventListener('enterFrame',self)
		self.alpha = 0.3
		self.etat = 'destroyed'
	end
	function quadcan:enterFrame(event)
		self.rateCpt = self.rateCpt+1
		local dist = self.cibleRot-self.canon.rotation
	
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
					timer.performWithDelay( math.random(2*1000,4*1000),self.F_setCible,1)
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
	
	function quadcan:tirer()
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
	function quadcan:setCible(angle)
		self.cibleRot=angle
	end
	
	function quadcan:setShootType(nb)
		self.shootType = self.tShootType[nb]
	end
	function quadcan:reduceHealth (dmg)
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
	function quadcan:upgrade()
		self.vaisseau:setAtkSpeed(-2)
		self.vaisseau:setDmg(-2)
		self.vaisseau:setBulletSpawn(4)
		self.vaisseau:setBullet(self.bullet)
								--dmg,spd,aspd,sspd,special
		self.vaisseau.control:upgradePopUp('-','0','-','0','Quad shot')
	end
	function quadcan:getHitBox()
		return self.hitBox
	end
	
	function quadcan:getPos()
		return self.canon:localToContent(0,0)
	end
	
	function quadcan:getBulletSpawn()
		return self.bulletSpawn
	end
	function quadcan:getAng()
		return self.canon.rotation-self.rotation
	end
	
	function quadcan:getTire()
		return self.tire
	end
	function quadcan:getDmg()
		return self.dmg
	end
	function quadcan:getBullet()
		return self.bullet
	end
	
	function quadcan:resetTire()
		self.tire=0
		self.rateCpt=0
	end
	quadcan:init()
	--Event
	Runtime:addEventListener('enterFrame',quadcan)
	
	return quadcan
end

return Quadcan