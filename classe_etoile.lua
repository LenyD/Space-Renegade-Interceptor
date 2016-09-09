-----------------------------------------------------------------------------------------
--
-- etoile7.lua
--
-----------------------------------------------------------------------------------------
local Etoile ={}

function Etoile:new()
	local etoile = display.newImage('img/etoile.png')
		--Méthodes
	function etoile:init()
		--init
		self.x =math.random(self.parent.width*1.5)-self.parent.width/2
		self.y =math.random(self.parent.height*1.5)-self.parent.height/2
		self.xScale =math.random()*1.5
		self.yScale =self.xScale
		self.alpha = self.xScale
		self.rotation = math.random(360)
	end
	function etoile:changerMonde()
		--removeEvent
		Runtime:removeEventListener('enterFrame',self)
		self:removeSelf()
		--self=nil
	end
	
	function etoile:kill()
		--removeEvent
		Runtime:removeEventListener('enterFrame',self)
		self:removeSelf()
		self=nil
	end
	function etoile:enterFrame()
		self.rotation = self.rotation+(1/self.xScale)
	end
	etoile:init()
	Runtime:addEventListener('enterFrame',etoile)
	return etoile
	
	
end

return Etoile