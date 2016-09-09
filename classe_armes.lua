-----------------------------------------------------------------------------------------
--
-- Arme.lua
--
-----------------------------------------------------------------------------------------
local Armes ={}

function Armes:new(leVaisseau,ennemi,lesArmes)
	local armes = display.newGroup()
	
		--Méthodes
	function armes:init()
		--init
		self.ennemi = ennemi
		self.tArmes = lesArmes
		self.currentArmes = {}
		for i=1,#(ennemi:getArmes()) do
			local c_armes = require('armes.classe_'..self.tArmes[self.ennemi:getTArmes()][math.random(1,#(self.tArmes[self.ennemi:getTArmes()]))])
			local laBase = self.ennemi:getArmes()
			local x = laBase[i].x
			local y = laBase[i].y
			local rot = laBase[i].rotation
			local hp = self.ennemi:getHealthMax()
			self.unArme = c_armes:new(leVaisseau,x,y,rot,hp,i)
			self:insert(self.unArme)
			self.currentArmes[i]=self.unArme
			
			
		end
		
	end
	function armes:getArmes()
		return self.currentArmes
	end
	function armes:kill()
		--removeEvent
		self:removeSelf()
		self=nil
	end

	
	armes:init()
	--Event
	
	return armes
end

return Armes