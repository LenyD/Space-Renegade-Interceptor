-----------------------------------------------------------------------------------------
--
-- Oeuil.lua
--
-----------------------------------------------------------------------------------------
local Etoiles ={}


function Etoiles:new(nb)
	local c_Etoile= require('classe_etoile')
	local etoiles = display.newGroup()
		--Méthodes
	function etoiles:init()
		--init
			for i=1,nb do
			local etoile = c_Etoile:new()
			
			etoiles:insert(etoile)
		end
		
	end
	
	function etoiles:enterFrame()
		--init
		self.rotation=self.rotation+0.1
		
	end

	function etoiles:kill()
		Runtime:removeEventListener('enterFrame',etoiles)
		self:removeSelf()
		self=nil
	end
	etoiles:init()
	--Event
	Runtime:addEventListener('enterFrame',etoiles)
	return etoiles
end

return Etoiles