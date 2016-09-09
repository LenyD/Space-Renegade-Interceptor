-----------------------------------------------------------------------------------------
--
-- Classe.lua
--
-----------------------------------------------------------------------------------------
local Jeu = {}
function Jeu:new(leMain)
	local c_Bullet= require('classe_bullet')
	local jeu = display.newGroup();

	local c_Control = require('classe_control')
	local c_Vaisseau= require('classe_vaisseau')
	local c_Ennemi= require('classe_ennemi')
	local c_Etoiles= require('classe_etoiles')
	local c_Bullets= require('classe_bullets')
	local c_Bullets_ennemi= require('classe_bullets_ennemi')
	local c_Cam = require('classe_camera')
	local c_Monde = require('classe_monde')
	local c_Armes= require('classe_armes')
	
	function jeu:init()
		local sons = audio.loadSound( "sons/ambiance.mp3" )
		audio.play(sons,{loops=-1})
		self.lesArmes1 = {'heatcan','lascan','bola','tesla','gatling','quadcan'}
		self.lesArmes2 = {'flame','bola','railgun','tesla','mislauncher','quadassault'}
		self.lesArmes3 = {'heatcan','flame','lascan','bola','railgun','tesla','mislauncher','quadassault','gatling','quadcan'}
		self.lesArmes = {self.lesArmes1, self.lesArmes2, self.lesArmes3}
		self.lesControles = c_Control:new();
		--ajout des différent objets
		self.lesEtoiles = c_Etoiles:new(100)
		self.vaisseau = c_Vaisseau:new(self.lesControles,self)
		self.monMonde= c_Monde:new({})
		self.laCam = c_Cam:new(self.monMonde)
		self:insert(self.laCam)
		self:insert(self.lesControles)
	end
	
	function jeu:creerOeuil()
		self.ennemi = c_Ennemi:new('oeuil',self.vaisseau,self.lesArmes,self,self.lesControles)
		self.monMonde:setEnnemi(self.ennemi)
		self.lesBullets=c_Bullets:new(self.lesControles,self.vaisseau,self.ennemi)
		self.lesBulletsEnnemis=c_Bullets_ennemi:new(self.vaisseau,self.ennemi)
		self.monMonde:reordonne({self.lesEtoiles,self.ennemi,self.lesBullets,self.lesBulletsEnnemis,self.vaisseau})
		self.laCam:changerCible(self.ennemi,self.monMonde)
		
		self.vaisseau:startInvincible()
		
	end
	
	function jeu:creerSquareBot()
		self.ennemi = c_Ennemi:new('squarebot',self.vaisseau,self.lesArmes,self,self.lesControles)
		self.monMonde:setEnnemi(self.ennemi)
		self.lesBullets=c_Bullets:new(self.lesControles,self.vaisseau,self.ennemi)
		self.lesBulletsEnnemis=c_Bullets_ennemi:new(self.vaisseau,self.ennemi)	
		
		self.monMonde:reordonne({self.lesEtoiles,self.ennemi,self.lesBullets,self.lesBulletsEnnemis,self.vaisseau})
		self.laCam:changerCible(self.ennemi,self.monMonde)
		self.lesControles:pause(false)
		self.vaisseau:startInvincible()
	end
	
	function jeu:creerTincan()
		self.ennemi = c_Ennemi:new('tincan',self.vaisseau,self.lesArmes,self,self.lesControles)
		self.monMonde:setEnnemi(self.ennemi)
		self.lesBullets=c_Bullets:new(self.lesControles,self.vaisseau,self.ennemi)
		self.lesBulletsEnnemis=c_Bullets_ennemi:new(self.vaisseau,self.ennemi)
		
		self.monMonde:reordonne({self.lesEtoiles,self.ennemi,self.lesBullets,self.lesBulletsEnnemis,self.vaisseau})
		self.laCam:changerCible(self.ennemi,self.monMonde)
		self.lesControles:pause(false)
		self.vaisseau:startInvincible()
	end
	function jeu:blackout()
		self.lesControles:noirceur()
	end
	function jeu:theEnd()
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
	function jeu:transition(trans)
		self.lesBullets:die(self.lesBullets)
		self.lesBulletsEnnemis:die(self.lesBulletsEnnemis)
		self.lesControles:pause(true)
		self.laCam:changerCible(self.lesControles)
		leMain:creerMenu(trans)
		
	end
	
	function jeu:gameover(win)
		self:theEnd()
		if(win==false)then
			leMain:creerMenu('gameover')
		else
			leMain:creerMenu('')
		end
	end
	function jeu:kill()
		self:removeSelf();
		self=nil
	end
	jeu:init()
	
	return jeu
end 

return Jeu