-----------------------------------------------------------------------------------------
--
-- Control.lua
--
-----------------------------------------------------------------------------------------
local Control ={}

function Control:new()
	local control = display.newGroup()
	
	function control:init()
		self.angle=0.1
		--ne doit pas être 0
		self.tire=false
		self.temps=-1
		self.txtTemps = display.newText(self,self.temps,20,30,'orbitron-medium.ttf',50)
		self.txtTemps.anchorX = 0
		self:increaseTime()
		self.reverse = false
		self.baseScale = 1
		
		self.hpHud = display.newGroup()
		self.hpHud.x = display.contentWidth-self.width-100
		self.hpHud.y = display.contentHeight-30
		self.barHp = display.newImage('img/ennemis/gauge.png')
		self.barHp.xScale =self.baseScale
		self.barHp.yScale =self.baseScale
		self.barHpFill = display.newImage('img/ennemis/gaugefill.png')
		self.barHpFill.anchorX =1
		self.barHpFill.x =self.barHpFill.width/2
		self.barHpFill.xScale =self.baseScale
		self.barHpFill.yScale =self.baseScale
		self.barHpFill.fill.effect = "filter.monotone"
		self.barHpFill.fill.effect.r =0
		self.barHpFill.fill.effect.g = 1
		self.barHpFill.fill.effect.b =0.3
		self.barHpFill.fill.effect.a = 1
		
		self.vaisseau =display.newImage('img/vaisseau/vaisseau.png')
		self.reacteurD=display.newImage('img/vaisseau/reacteur.png')
		self.reacteurD.xScale=-1
		self.reacteurG=display.newImage('img/vaisseau/reacteur.png')
		self.leVaisseau=display.newGroup()
		self.leVaisseau:insert(self.vaisseau)
		self.leVaisseau:insert(self.reacteurD)
		self.leVaisseau:insert(self.reacteurG)
		self.leVaisseau.x=self.barHp.width-self.leVaisseau.width
		
		self.hpHud:insert(self.barHpFill)
		self.hpHud:insert(self.barHp)
		self.hpHud:insert(self.leVaisseau)
		
		
		
		self.blackout = display.newRect(display.contentWidth/2,display.contentHeight/2,display.contentWidth,display.contentHeight)
		self.blackout.alpha=0.0
		self.blackout.fill= { 0, 0, 0 }
		self.blackoutEtat = 'stop'
		
		self:insert(self.blackout)
		self.upgrade=display.newGroup()
		self.imgUpgrade=display.newImage('img/menu/upgrade.png')
		self.dmgTxt =display.newText(self,'++',0,0,'orbitron-regular.ttf',15)
		self.spdTxt =display.newText(self,'--',0,0,'orbitron-regular.ttf',15)
		self.aspdTxt=display.newText(self,'0',0,0, 'orbitron-regular.ttf',15)
		self.sspdTxt=display.newText(self,'0',0,0, 'orbitron-regular.ttf',15)
		self.specTxt=display.newText(self,'123456789111315',0,0,'orbitron-regular.ttf',15)
		 self.dmgTxt.anchorX =  0
		 self.spdTxt.anchorX =  0
		self.aspdTxt.anchorX =  0
		self.sspdTxt.anchorX =  0
		self.specTxt.anchorX =  0
		self.specTxt.anchorY=  0
		
		 self.dmgTxt.x =  -95
		 self.spdTxt.x =  45
		self.aspdTxt.x =  70
		self.sspdTxt.x =  77
		self.specTxt.x =  -130
		
		self.dmgTxt.y  =  -17
		self.spdTxt.y  =  -17
		self.aspdTxt.y =  17
		self.sspdTxt.y =  53
		self.specTxt.y =  25

		
		
		self.upgrade:insert(self.imgUpgrade)
		self.upgrade:insert(self.dmgTxt)
		self.upgrade:insert(self.spdTxt)
		self.upgrade:insert(self.aspdTxt)
		self.upgrade:insert(self.sspdTxt)
		self.upgrade:insert(self.specTxt)
		self.upgrade.x=870
		self.upgrade.y=-80
		
		
		self:insert(self.upgrade)
		self:insert(self.hpHud)
		
		
		
		
		local function timeListener(event)
			self:increaseTime()
		end
		self.leTimer = timer.performWithDelay(1000, timeListener, 0)
		local function blank(event)
		
		end
		self.upgradeTimer=timer.performWithDelay(3000,blank,0)
	end
		
	function control:getAngle()
		return self.angle
	end
	function control:increaseTime()

		self.temps=self.temps+1
		local sec = self.temps%60
		if(sec<10)then
			sec = '0'..sec
		end
		
		local minutes = math.floor(self.temps/60)
		self.txtTemps.text = minutes..':'..sec
	end
	
	function control:upgradePopUp(dmg,spd,aspd,sspd,spec)
		 self.dmgTxt.text =  dmg
		 self.spdTxt.text =  spd
		self.aspdTxt.text =  aspd
		self.sspdTxt.text =  sspd
		self.specTxt.text =  spec
		local function hide()
			if (self.upgrade.y>-80)then
				self.upgrade.y=self.upgrade.y-7
			else
				timer.cancel(self.upgradeTimer)
			end
		end
		local function stay()
				self.upgradeTimer=timer.performWithDelay(30,hide,-1)
		end
		
		local function show()
			if (self.upgrade.y<80)then
				self.upgrade.y=self.upgrade.y+7
			else
				timer.cancel(self.upgradeTimer)
				self.upgradeTimer=timer.performWithDelay(3000,stay)
			end
		end
		self.upgradeTimer=timer.performWithDelay(30,show,-1)
	end
	
	function control:noirceur()
	self.blackoutEtat='add'
	end
	
	function control:touch(event)
		local dx = event.x-display.contentWidth/2
		local dy = event.y-display.contentHeight/2
		local angleRad=math.atan2(dy,dx)
		local angleDeg=angleRad*180/math.pi
		if(self.reverse == true) then
			if(angleDeg>=0) then
				self.angle=angleDeg-179;
			elseif(angleDeg<0) then
				self.angle=angleDeg+179;
			end
		else
			self.angle=angleDeg;
		end
		self.tire=true
		
		if(event.phase == 'ended') then
			self.tire=false
		end
		
	end
	
	function control:enterFrame(event)
		if(self.blackoutEtat =='remove')then
			if(self.blackout.alpha>0) then
				self.blackout.alpha = self.blackout.alpha-0.02
			else
				self.blackoutEtat='stop'
			end
		elseif self.blackoutEtat =='add' then	
			
			self.blackout.alpha = self.blackout.alpha+0.03
			if(self.blackout.alpha>=0.9) then
				self.blackoutEtat='remove'
			end
		end
	end
	function control:getTire()
		return self.tire
	end
	function control:pause(toggle)
		if(toggle==true) then
			Runtime:removeEventListener('touch',control)
			timer.pause(self.leTimer)
			self.alpha=0
			self.tire=false
			
		else
			Runtime:addEventListener('touch',control)
			timer.resume(self.leTimer)
			self.alpha=1
			self.upgrade.y = -80
		end
	end
	
	function control:reduireHp(hp,hpMax)
	local pourcentHp = hp/hpMax
		if pourcentHp>0 then
			self.barHpFill.xScale = pourcentHp*self.baseScale
		else
			self.barHpFill.xScale=0.01
		end
	end
	function control:kill()
		--removeEvent
		
		timer.cancel(self.leTimer)
		timer.cancel(self.upgradeTimer)
		
		Runtime:removeEventListener('enterFrame',control)
		Runtime:removeEventListener('touch',control)
		self:removeSelf()
		self=nil
	end
	
	
	Runtime:addEventListener('touch',control)
	Runtime:addEventListener('enterFrame',control)
	control:init()
	
	return control
end

return Control