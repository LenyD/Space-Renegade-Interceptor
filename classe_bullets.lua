-----------------------------------------------------------------------------------------
--
-- Bullets.lua
--
-----------------------------------------------------------------------------------------
local Bullets ={}


function Bullets:new(ctrl,vaisseau,ennemi)
	local c_Bullet= require('classe_bullet')
	local bullets = display.newGroup()
		--Méthodes
	function bullets:init()
		--init
		self.ctrl = ctrl
		self.vaisseau = vaisseau
		self.ennemi = ennemi
		self.tArmes = self.ennemi:getArmes()
	end
	
	function bullets:enterFrame()
		if self.ctrl:getTire() and self.vaisseau:getTire()>0 then
			for i =1,#self.vaisseau:getBulletSpawn() do
				local x,y  = self.vaisseau:getBulletSpawn()[i]:localToContent(0,0)
				local leType =vaisseau:getBullet()
				local rot=0
				local dir = {self.vaisseau.x*-1,self.vaisseau.y*-1}
				local bulletSpeed=vaisseau:getBulletSpeed()
				local bullet = c_Bullet:new(self.ennemi,x-display.contentWidth/2,y-display.contentHeight/2,leType[math.random(#leType)],rot,dir,self.vaisseau:getDmg(),bulletSpeed)
				self:insert(bullet)
				self.vaisseau:resetTire()
			end
		end
	end
	function bullets:setEnnemi(nouvelleEnnemi)
		self.ennemi = nouvelleEnnemi 
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