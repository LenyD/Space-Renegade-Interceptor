-----------------------------------------------------------------------------------------
--
-- Lascan.lua
--
-----------------------------------------------------------------------------------------
local Lascan ={}

function Lascan:new(leVaisseau,x,y,rot,hp,chan)
	local lascan = display.newGroup()
		--Méthodes
		
	function lascan:init()
		--init
		self.objType = 'npc'
		self.vaisseau = leVaisseau
		self.type = arme
		self.base = display.newImage('img/armes/g_base.png')
		self.canon = display.newGroup()
		self.canonImg =display.newImage('img/armes/g_lascan.png')
		self.canonImg.y = self.canonImg.x-20
		self.canon.y = self.canonImg.x+20
		self.bulletSpawn = {display.newGroup()}
		self.bulletSpawn[1].y =-50
		self.y = y
		self.x = x
		self.rotMax = 40
		self.changeModeMin = 15
		self.changeModeMax = 20
		self.rotation = rot
		self.cibleRot = math.random(-self.rotMax,self.rotMax)
		self.longeurLine = 1000
		self.line = display.newLine(self.bulletSpawn[1].x,self.bulletSpawn[1].y,0,-self.longeurLine)
		self.line.strokeWidth=5
		self.line:setStrokeColor( 0.3, 1, 0.8 )
		self.canon:insert(self.line)
		self.canon:insert(self.canonImg)
		self.line.alpha = 0
		for i=1,#self.bulletSpawn do
			self.canon:insert(self.bulletSpawn[i])
		end
		
		self:insert(self.canon)
		self:insert(self.base)
		self.dist=0
		self.r = 50
		
		
		
		self.tShootType ={'swipe','bolt'}
		self.shootType = self.tShootType[math.floor(math.random(#self.tShootType))]
		self.state = self.shootType
		self.tire =0
		self.rate =15
		self.rateCpt =0
		self.change =1
		self.bullet = 'special'
		self.dmg = 5
		
		self.son = audio.loadSound( "sons/lascan.mp3" )
		self.playing = false

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
		
		self.healthMax = hp*0.5
		self.health = self.healthMax
		self.etat = 'vivant'
	end
	
	function lascan:changerMonde()
		--removeEvent
		Runtime:removeEventListener('enterFrame',self)
		self:removeSelf()
		--self=nil
	end
	
	function lascan:kill()
		--removeEvent
		Runtime:removeEventListener('enterFrame',self)
		self:removeSelf()
		self=nil
	end

	function lascan:destroy()
		--removeEvent
		Runtime:removeEventListener('enterFrame',self)
		self.alpha = 0.3
		self.line.alpha=0
		self.etat = 'destroyed'
	end
	
	function lascan:enterFrame(event)
	if self.line.alpha==1 then
		audio.play(self.son)
	end
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
					self:tirer()
					
				end	
				if self.change > 0 then
				--print('change')
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
		if self:detectCollision() then

			self.vaisseau:reduceHp(self.dmg)
		end
		
	end
	
	function lascan:tirer()

		if self.line.alpha == 1 then
			self.line.alpha = 0
		else
			self.line.alpha = 1

		end
		self.rateCpt = 0
	end
	
	function lascan:detectCollision()
		if self.line.alpha == 1 then
			local startX,startY =self.bulletSpawn[1]:localToContent(0,0)
			local angleLas = (self.canon.rotation+self.parent.parent.rotation+self.rotation-90)*math.pi
			local endX = (math.cos(angleLas/180)*1000)+display.contentWidth/2
			local endY = (math.sin(angleLas/180)*1000)+display.contentHeight/2
			local cX,cY = self.vaisseau:localToContent(0,0)
			local lineVaisseau = self.vaisseau:getHitBoxLas()
			local hbStartX,hbStartY= lineVaisseau[1]:localToContent(0,0)
			local hbEndX,hbEndY = lineVaisseau[2]:localToContent(0,0)
			local dx1 = startX-endX
			local dy1 = startY-endY	
			local dx2 = startX-hbStartX
			local dy2 = startY-hbStartY
			local dx3 = startX-hbEndX
			local dy3 = startY-hbEndY
			local angle1 = math.atan2(dx1,dy1)
			local angle2 = math.atan2(dx2,dy2)
			local angle3 = math.atan2(dx3,dy3)
			if(((angle2>angle1 and angle3<angle1) or(angle2<angle1 and angle3>angle1))and math.abs((angle2+10)-(angle3+10))<1) then
				return true
			end
			return false
		end
	end
	function lascan:setCible(angle)
		self.cibleRot=angle
	end
	
	function lascan:setShootType(nb)
		self.shootType = self.tShootType[nb]
	end
	function lascan:getHitBox()
		return self.hitBox
	end
	function lascan:reduceHealth (dmg)
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
	function lascan:upgrade()
		self.vaisseau:setDmg(1)
		self.vaisseau:setAtkSpeed(2)
						--dmg,spd,aspd,sspd,special
		self.vaisseau.control:upgradePopUp('+','0','+','0','none')
	end
	
	function lascan:getPos()
		return self.canon:localToContent(0,0)
	end
	
	function lascan:getBulletSpawn()
		return self.bulletSpawn
	end
	function lascan:getAng()
		return self.canon.rotation-self.rotation
	end
	
	function lascan:getTire()
		return self.tire
	end
	function lascan:getDmg()
		return self.dmg
	end
	function lascan:getBullet()
		return self.bullet
	end
	
	function lascan:resetTire()
		self.tire=0
		self.rateCpt=0
	end
	lascan:init()
	--Event
	Runtime:addEventListener('enterFrame',lascan)
	
	return lascan
end

return Lascan