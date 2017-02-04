-----------------------------------------------------------------------------------------
--
-- Monde.lua
--
-----------------------------------------------------------------------------------------
local Monde ={}

function Monde:new(unTableau)
		--Méthodes
	local monde = display.newGroup()

	function monde:init()
		for i=1,#unTableau do
			self:insert(unTableau[i]);
		end
	end
	
	function monde:reordonne(leTableau)
		for i=1,#leTableau do
			self:insert(leTableau[i]);
		end
	end
	function monde:changerMonde()
		--removeEvent
		self:removeSelf()
		--self=nil
	end
	function monde:setEnnemi(unEnnemi)
		self:insert(unEnnemi)
	end
	function monde:kill()
		--removeEvent
		self:removeSelf()
		self=nil
	end
	
	monde:init()
		--Event
	return monde
end

return Monde