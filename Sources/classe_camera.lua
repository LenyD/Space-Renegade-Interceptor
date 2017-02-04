-----------------------------------------------------------------------------------------
--
-- Camera.lua
--
-----------------------------------------------------------------------------------------
local Camera ={}

function Camera:new(monMonde)
	local camera = display.newGroup()
	
	function camera:init()
		self.cible = nil
		self:insert(monMonde)
	end
	
	function camera:enterFrame()
		if(self.cible~=nil)then
			local x,y = self.cible:localToContent(0,0)
			local dx = self.x - x
			local dy = self.y - y
			self.x=dx+display.contentWidth/2
			self.y=dy+display.contentHeight/2
		end
	end
	
	function camera:changerCible(nouvelleCible)
		self.cible = nouvelleCible
	end
	function camera:kill()
		Runtime:removeEventListener('enterFrame',self)
		self:removeSelf()
		self=nil
	end
	function camera:changerMonde()
		Runtime:removeEventListener('enterFrame',self)
		self:removeSelf()
		--self=nil
	end
	function camera:kill()
		Runtime:removeEventListener('enterFrame',self)
		self:removeSelf()
		self=nil
	end
	
	camera:init()
	Runtime:addEventListener('enterFrame',camera)
	return camera
end

return Camera