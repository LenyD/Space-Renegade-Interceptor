-----------------------------------------------------------------------------------------
--
-- bullet.lua
--
-----------------------------------------------------------------------------------------
local Bullet ={}

function Bullet:new(vaisseau,enn,x,y,leType,rot,dir,dmg)
	local bullet = display.newImage('img/bullets/b_'..leType..'.png')
		--Méthodes
	function bullet:init()
		--init
		self.grEnnemi = enn
		self.ennemi = self.grEnnemi:getEnn()
		self.vaisseau = vaisseau
		self.cible = 'joueur'
		self.type=leType
		self.x = x
		self.y = y
		self.tDir = dir
		self.vit = 20
		self.bounce=0
		self.dmg=dmg
		self.rotation = rot+self.grEnnemi:getRot()
		local r = 5
	end
	
	function bullet:changerMonde()
		--removeEvent
		Runtime:removeEventListener('enterFrame',bullet)
		self:removeSelf()
		--self=nil
	end
	
	function bullet:kill()
		--removeEvent
		Runtime:removeEventListener('enterFrame',bullet)
		self:removeSelf()
		self=nil
	end
	function bullet:enterFrame()
		self.x= self.x+self.tDir[1]/self.vit
		self.y= self.y+self.tDir[2]/self.vit
		if self.x>display.contentWidth/1.5	or self.x<display.contentWidth/-1.5 or self.y>display.contentHeight/1.5	or self.y<display.contentHeight/-1.5 then
			self:kill()
		end
		if self:collisionCirculaire(self,self.vaisseau) then 
			self.vaisseau:reduceHp(self.dmg)
			if self.type~='sniper' then
				self:kill()
			end
			
		end
		
		if self.type == 'bola' then
			self.rotation=self.rotation+25
			self.x = self.x+math.cos(self.y/100)*10
			self.y = self.y+math.sin(self.x/100)*10
		elseif self.type =='electric' then
			self.x = self.x+math.random(-10,10)
			self.y = self.y+math.random(-10,10)
		elseif self.type =='bullet' then
			
		elseif self.type =='powerball' then
			if self.x>display.contentWidth/2	or self.x<-display.contentWidth/2 or self.y>display.contentHeight/2	or self.y<-display.contentHeight/2 or self:collisionCirculaire(self,self.ennemi) then
				self.tDir[1]=-1*self.tDir[1]
				self.tDir[2]=-1*self.tDir[2]
				self.bounce =self.bounce+1
				if self.bounce >2 then
					self:kill()
				end
			end
		end
	end
	
	function bullet:getCible()
		return self.cible
	end
	function bullet:collisionCirculaire( obj1, obj2 )
		if ( obj1 == nil ) then  -- Make sure the first object exists
			return false
		end
		if ( obj2 == nil ) then  -- Make sure the other object exists
			return false
		end

		local dx = obj1.x - obj2.x
		local dy = obj1.y - obj2.y

		local distance = math.sqrt( dx*dx + dy*dy )
		local objectSize = (obj2.contentWidth/3) + (obj1.contentWidth/2)
		if(obj2.forme=='small') then
			objectSize =(obj2.contentWidth/5) + (obj1.contentWidth/2)
		end
		if ( distance < objectSize ) then
			return true
		end
		return false
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