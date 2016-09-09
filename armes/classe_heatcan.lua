-----------------------------------------------------------------------------------------
--
-- heatcan.lua
--
-----------------------------------------------------------------------------------------
local Heatcan ={}

function Heatcan:new(leVaisseau,x,y,rot,hp)
	local heatcan = display.newGroup()
		--Méthodes
		
	function heatcan:init()
		--init
		self.objType = 'npc'
		self.vaisseau = leVaisseau
		self.type = arme
		self.base = display.newImage('img/armes/g_base.png')
		self.canon = display.newGroup()
		self.canonImg =display.newImage('img/armes/g_heatcan.png')
		self.canonImg.xScale =2
		self.canonImg.y = self.canonImg.x-20
		self.canon.y = self.canonImg.x+20
		self.bulletSpawn = {display.newGroup()}
		self.bulletSpawn[1].y =-35
		self.y = y
		self.x = x
		self.rotMax = 40
		self.changeModeMin = 15
		self.changeModeMax = 20
		self.rotation = rot
		self.cibleRot = math.random(-self.rotMax,self.rotMax)
		self.line = display.newImage('img/bullets/b_heat.png')
		self.line.anchorX=0
		self.line.rotation = -90
		self.line.xScale =0.01
		self.line.yScale =2
		self.line.y=self.bulletSpawn[1].y
		self.canon:insert(self.line)
		self.canon:insert(self.canonImg)
		self.circ = display.newCircle(self.bulletSpawn[1].x,self.bulletSpawn[1].y-180,60)
		self.circ.alpha = 0
		self.canon:insert(self.circ)
		
		self.line.alpha = 0
		for i=1,#self.bulletSpawn do
			self.canon:insert(self.bulletSpawn[i])
		end
		
		self:insert(self.canon)
		self:insert(self.base)
		self.dist=0
		self.r = 50
		
		
		
		self.tShootType ={'raffale'}
		self.shootType = self.tShootType[math.floor(math.random(#self.tShootType))]
		self.state = self.shootType
		self.tireOn =0
		self.rate =35
		self.rateCpt =0
		self.change =1
		self.bullet = 'special'
		self.dmg = 2
		

		self.F_setCible =  function()
			self.tireOn=0
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
		
		self.son = audio.loadSound( "sons/heatcan.mp3" )
		self.playing = false
	end
	
	function heatcan:changerMonde()
		--removeEvent
		Runtime:removeEventListener('enterFrame',self)
		self:removeSelf()
		--self=nil
	end
	
	function heatcan:kill()
		--removeEvent
		Runtime:removeEventListener('enterFrame',self)
		self:removeSelf()
		self=nil
	end

	function heatcan:destroy()
		--removeEvent
		Runtime:removeEventListener('enterFrame',self)
		self.alpha = 0.3
		self.line.alpha=0
		self.etat = 'destroyed'
	end
	
	function heatcan:enterFrame(event)
		self.rateCpt = self.rateCpt+1
		local dist = self.cibleRot-self.canon.rotation
	
		self.canon.rotation = self.canon.rotation+dist/20
		if self.shootType == 'swipe' then
			if(dist<0.75 and dist>-0.75) then
				self.cibleRot=-self.cibleRot
				self.line.alpha = 1
			else
				if self.rateCpt>self.rate then
				end	
			end
			
			
		elseif self.shootType == 'raffale' then
		
			if(dist<3 and dist>-3) then
				if self.rateCpt>self.rate then
					self.tireOn=1
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
					self.tireOn=1
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
		if(self.tireOn==0 and self.line.xScale>0.01) then
			--self.line.alpha = 0
			self.line.xScale = self.line.xScale-0.1
			self.line.yScale = self.line.xScale-0.05
			self.line.alpha = self.line.alpha-0.05
		elseif self.line.xScale>=2 then
			if self:detectCollision(self.circ,self.vaisseau) then
				self.vaisseau:reduceHp(self.dmg)
			end
		end
	end
	
	function heatcan:tirer()
		audio.play(self.son)
		if(self.tireOn==1 and self.line.xScale<2) then
			self.line.xScale = self.line.xScale+0.1
			self.line.yScale = self.line.xScale+0.05
			self.line.alpha = self.line.alpha+0.05
		end
	end
	
	function heatcan:detectCollision(obj1,obj2)
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
	function heatcan:setCible(angle)
		self.cibleRot=angle
	end
	
	function heatcan:setShootType(nb)
		self.shootType = self.tShootType[nb]
	end
	function heatcan:getHitBox()
		return self.hitBox
	end
	function heatcan:reduceHealth (dmg)
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
	function heatcan:upgrade()
		self.vaisseau:setDmg(2)
		self.vaisseau:setVit(1)
							--dmg,spd,aspd,sspd,special
		self.vaisseau.control:upgradePopUp('+','+','0','0','None')
	end
	
	function heatcan:getPos()
		return self.canon:localToContent(0,0)
	end
	
	function heatcan:getBulletSpawn()
		return self.bulletSpawn
	end
	function heatcan:getAng()
		return self.canon.rotation-self.rotation
	end
	
	function heatcan:getTire()
		return self.tire
	end
	function heatcan:getDmg()
		return self.dmg
	end
	function heatcan:getBullet()
		return self.bullet
	end
	
	function heatcan:resetTire()
		self.tire=0
		self.rateCpt=0
	end
	heatcan:init()
	--Event
	Runtime:addEventListener('enterFrame',heatcan)
	
	return heatcan
end

return Heatcan