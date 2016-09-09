-----------------------------------------------------------------------------------------
--
-- Vaisseau.lua
--
-----------------------------------------------------------------------------------------
local Vaisseau ={}

function Vaisseau:new(ctrl,leJeu)
	local vaisseau = display.newGroup()
		--Méthodes
	function vaisseau:init()
		--init
		local particleDesigner = require('particleDesigner')
		self.rotation = 0
		self.objType = 'joueur'
		self.emitterG = particleDesigner.newEmitter('emitter53179.rg')
		self.emitterD = particleDesigner.newEmitter('emitter53179.rg')
		self.emitterD.rotation=145
		self.emitterG.rotation=-self.emitterD.rotation
		self.emitterD.x=18
		self.emitterG.x=-self.emitterD.x
		self.emitterD.y=3
		self.emitterG.y=self.emitterD.y
		self.lesEmitter = display.newGroup()
		self.lesEmitter.rotation = -90
		
		self.control = ctrl
		self.hull = display.newImage('img/vaisseau/vaisseau.png')
		self.reacG = display.newImage('img/vaisseau/reacteur.png')
		self.reacD = display.newImage('img/vaisseau/reacteur.png')
		self.reacD.xScale = -1
		self.reacD.rotation=-90
		self.reacG.rotation=-90
		self.hull.rotation=-90
		
		self.bulletSpawn={}
		self:setBulletSpawn(1)
		
		self.radMax = 440
		self.radMin = 320
		self.x=radMax
		self.angleDeg= self.rotation
		self.dist= 0
		self.lesEmitter:insert(self.emitterG)
		self.lesEmitter:insert(self.emitterD)
		
		self:insert(self.lesEmitter)
		self:insert(self.reacG)
		self:insert(self.reacD)
		self:insert(self.hull)
		
		
		self.hblg=display.newGroup()
		self.hbld=display.newGroup()
		self.hblg.y=-30
		self.hbld.y=30
		self:insert(self.hblg)
		self:insert(self.hbld)
		self.hitBoxLas = {self.hblg,self.hbld}
		--self.hitBox = display.newCircle(0,0,self.width/2-5)
		--self:insert(self.hitBox)
		
		self.emitterG:pause()
		self.emitterD:pause()
		self.playing=false
		self.son = audio.loadSound( "sons/reacteur.mp3" )
		audio.play(self.son,{loops= -1,channel = 31})
		self.tire = 1
		self.rate =10
		self.rateCpt =0
		self.dmg =50
		self.bulletSpeed =20
		self.bullet = {'laserbleu'}
		self.vit = 8
		
		self.hpMax=200
		self.hp =self.hpMax
		self.invincible=true
		
	end
	
	function vaisseau:kill()
		--removeEvent
		Runtime:removeEventListener('enterFrame',vaisseau)
		self:removeSelf()
		self=nil
	end
	function vaisseau:changerMonde()
		--removeEvent
		Runtime:removeEventListener('enterFrame',vaisseau)
		self:removeSelf()
	end
	
	function vaisseau:enterFrame(event)
		self.rateCpt = self.rateCpt+1
		if self.rate < self.rateCpt then
			self.tire =1
		end
		self.angleDeg = self.control:getAngle()
		if self.rotation>180 then
			self.rotation = self.rotation-360
		elseif self.rotation<-180 then
			self.rotation = self.rotation+360
		end
		
		
		
		local dist = math.sqrt((self.angleDeg-self.rotation)*(self.angleDeg-self.rotation))
		local ang = 0
	
		if dist>180 then
			if(self.angleDeg>self.rotation) then
				ang = self.angleDeg-360
				self.dist =(dist-360)*-1
			else
				ang = self.angleDeg+360
				self.dist=(dist-360)*-1
			end
	
		else
			ang = self.angleDeg
			self.dist=dist
			if dist<5 then
				self.emitterG:stop()
				self.emitterD:stop()
			end
		end
		
		if(ang>self.rotation) then
			self.rotation = self.rotation+self.dist/self.vit
			self.emitterG:stop()
			
		else
			self.rotation = self.rotation-self.dist/self.vit
			self.emitterD:stop()
		end
		self.emitterG:start()
		self.emitterG.yScale = (math.log(self.dist+1))*0.5
		
		self.emitterD:start()
		self.emitterD.yScale = (math.log(self.dist+1))*0.5
		self.x =math.cos((self.rotation)*math.pi/180)*self.radMax
		self.y =math.sin((self.rotation)*math.pi/180)*self.radMin
		audio.setVolume((self.dist/180+0.001)*5,{channel = 31})			
	end
	
	function vaisseau:startInvincible()

	
		local aMod = 1
		local aModCpt = 0
		local function invincible(event)
			local leMax=1
			local leMin=0
			self.alpha=self.alpha-aMod
			if(self.alpha>=leMax or self.alpha<=leMin) then
				aMod = aMod*-1
				aModCpt = aModCpt+1
				if(aModCpt>=15)then
					self.alpha=1
					timer.cancel(event.source)
					self.invincible=false
				end
			end
		end
		timer.performWithDelay(250,invincible,0)
	end
	function vaisseau:getPos()
		return self:localToContent(0,0)
	end
	function vaisseau:getBulletSpawn()
		return self.bulletSpawn
	end
	function vaisseau:getHitBoxLas()
		return self.hitBoxLas
	end
	function vaisseau:getTire()
		return self.tire
	end
	function vaisseau:getBullet()
		return self.bullet
	end
	function vaisseau:getBulletSpeed()
		return self.bulletSpeed
	end
	function vaisseau:setVit(nb)
		if self.vit-nb<3 then
			self.vit = 3
		else
			self.vit = self.vit-nb
		end
	end
	function vaisseau:getDmg()
		return self.dmg
	end
	function vaisseau:resetTire()
		self.tire=0
		self.rateCpt=0
	end
	function vaisseau:setAtkSpeed(nb)
		self.rate= self.rate-nb*3
	end
	function vaisseau:setDmg(nb)
		self.dmg = self.dmg+nb*5
		if(self.dmg<=0) then
			self.dmg = 1
		end
	end
	function vaisseau:setBullet(leType)
		self.bullet[#self.bullet+1] = leType
	end
	function vaisseau:setHue(leType)
		self.emitterG.startColorVarianceRed=1
		self.emitterG.startColorVarianceBlue=0
		self.emitterG.startColorVarianceGreen=0.4
		self.emitterG.finishColorVarianceRed=1
		self.emitterG.finishColorVarianceBlue=0
		self.emitterG.finishColorVarianceGreen=0.4
		self.emitterG.startColorRed=1
		self.emitterG.startColorBlue=0.2
		self.emitterG.startColorGreen=0.4
		self.emitterG.finishColorRed=1
		self.emitterG.finishColorGreen=0.3
		self.emitterG.finishColorBlue=0.1
		
		self.emitterD.startColorVarianceRed=1
		self.emitterD.startColorVarianceBlue=0
		self.emitterD.startColorVarianceGreen=0.4
		self.emitterD.finishColorVarianceRed=1
		self.emitterD.finishColorVarianceBlue=0
		self.emitterD.finishColorVarianceGreen=0.4
		self.emitterD.startColorRed=1
		self.emitterD.startColorBlue=0.2
		self.emitterD.startColorGreen=0.4
		self.emitterD.finishColorRed=1
		self.emitterD.finishColorGreen=0.3
		self.emitterD.finishColorBlue=0.1

	end
	function vaisseau:setBulletSpawn(nb)
		if(#self.bulletSpawn<nb) then
			if nb ==1 then
				self.bulletSpawn = {display.newGroup()}
			elseif nb ==2 then
				self.bulletSpawn = {display.newGroup(),display.newGroup()}
				self.bulletSpawn[1].x = -10
				self.bulletSpawn[2].x = 10
			elseif nb ==3 then
				self.bulletSpawn = {display.newGroup(),display.newGroup(),display.newGroup()}
				self.bulletSpawn[1].x = -35
				self.bulletSpawn[2].x = 0		
				self.bulletSpawn[2].y = -10		
				self.bulletSpawn[3].x = 35		
			elseif nb ==4 then
				self.bulletSpawn = {display.newGroup(),display.newGroup(),display.newGroup(),display.newGroup()}
				self.bulletSpawn[1].x = -35
				self.bulletSpawn[2].x = -5	
				self.bulletSpawn[2].y = -15
				self.bulletSpawn[3].x = 5
				self.bulletSpawn[3].y = -15
				self.bulletSpawn[4].x = 35
				
			end
			for i=1, #self.bulletSpawn do
				self.lesEmitter:insert(self.bulletSpawn[i])
				
			end
		end
	end
	function vaisseau:setBulletSpeed(nb)
		self.bulletSpeed = self.bulletSpeed+ nb*-2
		if(self.bulletSpeed<10) then
			self.bulletSpeed = 10
		end
	end

	function vaisseau:reduceHp(dmg)
		if self.invincible== false then
			self.hp = self.hp-dmg
			self.control:reduireHp(self.hp,self.hpMax)
			if self.hp<=0 then
				leJeu:gameover(false)
			end
		end
	end
	vaisseau:init()
	--Event
	Runtime:addEventListener('enterFrame',vaisseau)
	
	return vaisseau
end

return Vaisseau