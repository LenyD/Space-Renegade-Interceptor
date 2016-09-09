-----------------------------------------------------------------------------------------
--
-- bullet.lua
--
-----------------------------------------------------------------------------------------
local Bullet ={}

function Bullet:new(enn,x,y,leType,rot,tDir,dmg,bulSpd)
	local bullet = display.newImage('img/bullets/b_'..leType..'.png')
		--Méthodes
	function bullet:init()
		--init
		self.grEnnemi =enn
		self.ennemi=self.grEnnemi:getEnn()
		self.armes = self.grEnnemi:getArmes()
		self.dir =tDir 
		self.type=leType
		self.x = x
		self.y = y
		self.cible = 'npc'
		self.bounce = 0
		self.dX = self.x-self.dir[1]
		self.dY = self.y-self.dir[2]
		self.vit = bulSpd
		local angleRad=math.atan2(self.dX,self.dY)
		local angleDeg=angleRad*180/math.pi
		self.rotation = -angleDeg
		
		self.dmg = dmg
	end
	
	function bullet:changerMonde()
		--removeEvent
		Runtime:removeEventListener('enterFrame',bullet)
		self:removeSelf()
		--self=nil
	end
	function bullet:kill()
		--removeEvent
		Runtime:removeEventListener('enterFrame',self)
		self:removeSelf()
		self=nil
	end
	function bullet:enterFrame()
		self.dX = self.x-self.dir[1]
		self.dY = self.y-self.dir[2]
		self.x= self.x-self.dX/self.vit
		self.y= self.y-self.dY/self.vit
		if self.x>display.contentWidth/1.5	or self.x<display.contentWidth/-1.5 or self.y>display.contentHeight/1.5	or self.y<display.contentHeight/-1.5 then
			self:kill()
		end
		if(self.grEnnemi ~= nil) then
			for i = 1 , #self.armes do
			local obj2 =self.armes[i]:getHitBox()
				if(self:collisionCirculaire(self,obj2)) then
					self.armes[i]:reduceHealth(self.dmg)
					self.ennemi:reduceHealth(self.dmg/1.5)
					if self.type~='sniper' and self.type~='powerball' then
						self:kill()
					end
				end
			end
			if(self:collisionCirculaire(self,self.ennemi)) then
				if self.ennemi~=nil then
					self.ennemi:reduceHealth(self.dmg)
					if self.type~='powerball' then
							self:kill()
					end
				end
			end
			
			if self.type == 'bola' then
				self.rotation=self.rotation+25
				self.y = self.y+math.sin(self.x/100)*10
			elseif self.type =='electric' then
				self.x = self.x+math.random(-10,10)
				self.y = self.y+math.random(-10,10)
			elseif self.type =='bullet' then
				self.x = self.x+math.cos(self.y)*7
				self.y = self.y+math.sin(self.x)*7
				
			elseif self.type =='powerball' then
				if self.x>display.contentWidth/2 or self.x<display.contentWidth/-2 or self.y>display.contentHeight/2 or self.y<display.contentHeight/-2 or self:collisionCirculaire(self,self.ennemi) then
					if self:collisionCirculaire(self,self.ennemi) then
						self.dir[1]=-1*self.dir[1]*2
						self.dir[2]=-1*self.dir[2]*2
					else
						self.dir[1]=-1*self.dir[1]/2
						self.dir[2]=-1*self.dir[2]/2
					end
						self.bounce =self.bounce+1
					
					if self.bounce >2 then
						self:kill()
					end
				end
			end
		end
	end
	function bullet:collisionCirculaire( obj1, obj2 )
		if ( obj1 ~= nil and obj2 ~= nil ) then 
			local o1x,o1y = obj1:localToContent(0,0)
			local o2x,o2y = obj2:localToContent(0,0)
			local dx = o1x - o2x
			local dy =  o1y - o2y

			local distance = math.sqrt( dx*dx + dy*dy )
			local objectSize = (obj2.contentWidth/3) + (obj1.contentWidth/2)
			if(obj2.forme=='small') then
				objectSize =(obj2.contentWidth/5) + (obj1.contentWidth/2)
			end
			if ( distance < objectSize ) then
				return true
			end
		else
			return false
		end
	end
	function bullet:getCible()
		return self.cible
	end
	
	function bullet:setEnnemi(nouvelleEnnemi)
		self.grEnnemi =nouvelleEnnemi
		self.ennemi=self.grEnnemi:getEnn()
		self.armes = self.grEnnemi:getArmes()
	end
	
	bullet:init()
	Runtime:addEventListener('enterFrame',bullet)
	return bullet
	
	
end

return Bullet