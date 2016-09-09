-----------------------------------------------------------------------------------------
--
-- Bullets_ennemi.lua
--
-----------------------------------------------------------------------------------------
local Bullets ={}


function Bullets:new(vaisseau,ennemi)
	local c_Bullet= require('classe_bullet_ennemi')
	local bullets = display.newGroup()
		--Méthodes
	function bullets:init()
		--init
		self.vaisseau = vaisseau
		self.ennemi = ennemi
		self.armes = self.ennemi:getArmes()
	end
	
	function bullets:enterFrame()
		for i =1, #self.armes do
			if self.armes[i]:getTire() == 1 then
				for j = 1,#self.armes[i]:getBulletSpawn() do
					local x,y  = self.armes[i]:getBulletSpawn()[j]:localToContent(0,0)
					local xB,yB =self.armes[i]:getPos()
					local leType =self.armes[i]:getBullet()
					local rot=self.armes[i]:getAng()-180
					if(self.armes[i].x ==0 )then
					rot = rot+180
					end
					local dx= x-xB
					local dy = y-yB
					local dir = {dx*10,dy*10}
					local dmg = self.armes[i]:getDmg()
					local bullet = c_Bullet:new(self.vaisseau,self.ennemi,x-display.contentWidth/2,y-display.contentHeight/2,leType,rot,dir,dmg)
					self:insert(bullet)
				end
				self.armes[i]:resetTire()
				
			end
		end
		
	end
	function bullets:setEnnemi(nouvelleEnnemi)
		self.ennemi = nouvelleEnnemi 
		self.armes = nouvelleEnnemi:getArmes()
		for i=self.numChildren,1,-1 do
			self[i]:setEnnemi(self.ennemi)
		end
	end

	function bullets:kill()
		Runtime:removeEventListener('enterFrame',bullets)
		self:removeSelf();
		self=nil
	end
	function bullets:die()
		local function genocide(enfant)
			if enfant.numChildren ~=nil then
				for i=enfant.numChildren,1,-1 do
					genocide(enfant[i])
				end
			end
			if enfant.kill ~= nil then
				enfant:kill();
			end
		end	
		genocide(self)
		
	end
	
	Runtime:addEventListener('enterFrame',bullets)
	bullets:init()
	--Event
	
	return bullets
end

return Bullets