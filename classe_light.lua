-----------------------------------------------------------------------------------------
--
-- light.lua
--
-----------------------------------------------------------------------------------------
local Light ={}

function Light:new()
	local light = display.newImage('img/menu/light.png')
		--Méthodes
	function light:init()
		--init
		self.fill.effect = "filter.monotone"
		self.fill.effect.r = math.random()
		self.fill.effect.g = math.random()
		self.fill.effect.b = math.random()
		self.fill.effect.a = math.random()*0.5+0.5
		self.flash = math.random(20,300)
		self.on=math.random(1,2)*2-3
		self:toggleOn()
	end
	function light:toggleOn()
		if self.on==1 then
			self.alpha=1
			local sons = audio.loadSound( "sons/lascan.mp3" )
			audio.play(sons,{})
		else
			self.alpha=0.4
		end
	end
	
	function light:kill()
		--removeEvent
		Runtime:removeEventListener('enterFrame',self)
		self:removeSelf()
		self=nil
	end
	function light:enterFrame()
		self.flash = self.flash-1
		if(self.flash<0)then
			self.on = self.on*-1
			self.flash = math.random(20,300)
			self:toggleOn()
		end
	end
	light:init()
	Runtime:addEventListener('enterFrame',light)
	return light
	
	
end

return Light