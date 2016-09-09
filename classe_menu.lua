-----------------------------------------------------------------------------------------
--
-- Classe.lua
--
-----------------------------------------------------------------------------------------
local Menu = {}
function Menu:new(leMain,transition)
	local menu = display.newGroup();
	local c_Etoiles = require('classe_etoiles')
	local c_Lights = require('classe_lights')
	function menu:init()
		local sons = audio.loadSound( "sons/ambiance.mp3" )
		audio.play(sons,{channel=32,loops=-1})
		local coorBtLaunch={390,220}
		self.main=leMain
		self.cockpit = display.newGroup();
		self.lesEtoiles = c_Etoiles:new(125)
		self.lesLights = c_Lights:new(3,5,20,25)
		self.lesLights.x = -445
		self.lesLights.y = 245
		self.bg = display.newImage('img/menu/bg.png')
		self.bgCredit = display.newImage('img/menu/bgcredit.png')
		self.bgCredit.x=self.bg.x+self.bg.width
		self.bgInstruction= display.newImage('img/menu/bgcredit.png')
		self.bgInstruction.x=self.bg.x-self.bg.width
		self.bgInstruction.xScale=-1
		self.btLaunch = display.newImage('img/menu/buttonlaunch.png')
		self.btOpen = display.newImage('img/menu/open.png')
		self.btClose = display.newImage('img/menu/close.png')
		self.btLaunch.anchorY=1
		self.btLaunch.x =coorBtLaunch[1]
		self.btLaunch.y =coorBtLaunch[2]+self.btLaunch.height/2
		
		self.btLaunchHB = display.newRect(390,300,200,150)
		self.btLaunchHB.alpha = 0
		self.btLaunchHB.isHitTestable = true
		self.btOpen.x =coorBtLaunch[1]
		self.btOpen.y =coorBtLaunch[2]
		self.btOpen.alpha =0
		
		self.startX = self.cockpit.x
		
		self.btClose.x =coorBtLaunch[1]
		self.btClose.y =coorBtLaunch[2]
		self.scoreDisplayString={'1234567891234567891234 1234567891234567891234',
								'1234563 sasda','allo world, this is really fun',
								'quoi écrire?',
								'une string random','du travail encore',
								'937 0707 le clan panneton',
								'lorem ipsum dolor isim blabla bla',
								'sahd  momonja aihjbdfo ijabnf aoijnd',
								'aef adf dfgsaaa994 1dsf613 ds31555 a651ds',
								'sahd  momonja aihjbdfo ijabnf aoijnd',
								'aef adf dfgsaaa994 1dsf613 ds31555 a651ds sahd',
								'aef adf dfgsaaa994 1dsf613 ds31555 a651ds',
								'mon imperial knight est plus fort que le tient',
								'ay lmaoo',
								'',
								'saj noknd f..;d.f;; sdfsd;.;`; sd^fp,   84ds6f1 sd6g1'}
		self.scoreDisplay  = display.newText(self,self.scoreDisplayString[math.random(1,#self.scoreDisplayString)],10,360,'orbitron-regular.ttf',2)
		self.scoreDisplay2 = display.newText(self,self.scoreDisplayString[math.random(1,#self.scoreDisplayString)],10,365,'orbitron-regular.ttf',2)
		self.scoreDisplay3 = display.newText(self,self.scoreDisplayString[math.random(1,#self.scoreDisplayString)],10,370,'orbitron-regular.ttf',2)
		self.scoreDisplay.fill.effect = "filter.blurHorizontal"
		self.scoreDisplay.fill.effect.blurSize = 100
		self.scoreDisplay.fill.effect.sigma = 140
		local particleDesigner = require('particleDesigner')
		self.vit=particleDesigner.newEmitter('emitter86359.rg')
		self.vit.xScale = 0.01
		self.vit.yScale = 0.01
		self.vit.alpha = 0
		
		self.inDrag = false
		self.cibleX = 0
		
		
		self.grandTitre = display.newGroup()
		self.titre = display.newImage('img/menu/titre.png')
		self.titre.xScale = 1.25
		self.titre.yScale = self.titre.xScale 
		local laString='press launch to continue'
		if(transition=='')then
			self.titre = display.newImage('img/menu/titre.png')
			laString = 'press launch to start'
			
		elseif transition == 'gameover' then
			self.titre = display.newImage('img/menu/gameover.png')
			laString = 'press launch to restart'

		elseif transition == 'squarebot' then
			self.titre = display.newImage('img/menu/level2.png')

		elseif transition == 'tincan' then
			self.titre = display.newImage('img/menu/level3.png')
		else
			self.titre = {}
		end
		self.fleche1 = display.newText(self,'>', display.contentWidth/2,0,'orbitron-medium.ttf',250)
		self.fleche2 = display.newText(self,'<',-display.contentWidth/2,0,'orbitron-medium.ttf',250)
		
		self.grandTitre:insert(self.titre)
		self.start = display.newText(self,laString,0,250,'orbitron-regular.ttf',18)
		self.grandTitre:insert(self.start)
		self.grandTitre:insert(self.fleche1)
		self.grandTitre:insert(self.fleche2)
		
		self.fleche1.fill.effect = "filter.monotone"
		self.fleche1.fill.effect.r = 0
		self.fleche1.fill.effect.g = 0.7
		self.fleche1.fill.effect.b = 1
		self.fleche1.fill.effect.a = 0.2
		
		self.fleche2.fill.effect = "filter.monotone"
		self.fleche2.fill.effect.r = 0
		self.fleche2.fill.effect.g = 0.7
		self.fleche2.fill.effect.b = 1
		self.fleche2.fill.effect.a = 0.2
		
		self.start.fill.effect = "filter.monotone"
		self.start.fill.effect.r = 0
		self.start.fill.effect.g = 0.7
		self.start.fill.effect.b = 1
		self.start.fill.effect.a = 0.2
		
		
		self.credit = display.newGroup()
		self.credit.x = 1290
		self.credit.y = -30
		self.creditTitre = display.newText(self,'Credit',0,0,'orbitron-medium.ttf',46)

		local text ='Game design  -  Leny Deslauriers\n\nProgramming  -  Leny Deslauriers\n\nDesign  -  Leny Deslauriers\n\nSound Effects  -  Leny Deslauriers'
		self.creditText = display.newText(self,text,0,130,'orbitron-regular.ttf',18)
		local text ='CEGEP de Saint-Jerome, integration multimedia, mars 2016'
		self.creditLegal = display.newText(self,text,0,300,'orbitron-regular.ttf',10)
		
		self.creditTitre.fill.effect = "filter.monotone"
		self.creditTitre.fill.effect.r = 0
		self.creditTitre.fill.effect.g = 0.7
		self.creditTitre.fill.effect.b = 1
		self.creditTitre.fill.effect.a = 0.2
		
		self.creditText.fill.effect = "filter.monotone"
		self.creditText.fill.effect.r = 0
		self.creditText.fill.effect.g = 0.7
		self.creditText.fill.effect.b = 1
		self.creditText.fill.effect.a = 0.2
		
		self.creditLegal.fill.effect = "filter.monotone"
		self.creditLegal.fill.effect.r = 0
		self.creditLegal.fill.effect.g = 0.7
		self.creditLegal.fill.effect.b = 1
		self.creditLegal.fill.effect.a = 0.2
		
		self.credit:insert(self.creditTitre)
		self.credit:insert(self.creditText)	
		self.credit:insert(self.creditLegal)	
		
		self.instruction = display.newGroup()
		self.instruction.x = -1275
		self.instruction.y = -30
		self.instructionTitre = display.newText(self,'Instruction',0,0,'orbitron-medium.ttf',46)
		local text ='Touch anywhere to shoot\n\nDestroy your ennemies\n\nDestroy the weapons for upgrades\n\nHave fun!'
		self.instructionText = display.newText(self,text,0,130,'orbitron-regular.ttf',18)
		
		self.instructionTitre.fill.effect = "filter.monotone"
		self.instructionTitre.fill.effect.r = 0
		self.instructionTitre.fill.effect.g = 0.7
		self.instructionTitre.fill.effect.b = 1
		self.instructionTitre.fill.effect.a = 0.2
		
		self.instructionText.fill.effect = "filter.monotone"
		self.instructionText.fill.effect.r = 0
		self.instructionText.fill.effect.g = 0.7
		self.instructionText.fill.effect.b = 1
		self.instructionText.fill.effect.a = 0.2

		self.instruction:insert(self.instructionTitre)
		self.instruction:insert(self.instructionText)
		
		
		local aMod = 0.02
		self:insert(self.lesEtoiles)
		self.lesEtoiles:insert(self.vit)
		self.cockpit:insert(self.bg)
		self.cockpit:insert(self.bgCredit)
		self.cockpit:insert(self.bgInstruction)
		self.cockpit:insert(self.btOpen)
		self.cockpit:insert(self.btLaunch)
		self.cockpit:insert(self.btLaunchHB)
		self.cockpit:insert(self.btClose)
		self.cockpit:insert(self.lesLights)
		self.cockpit:insert(self.scoreDisplay)
		self.cockpit:insert(self.scoreDisplay2)
		self.cockpit:insert(self.scoreDisplay3)
		self.cockpit:insert(self.grandTitre)
		self.cockpit:insert(self.credit)
		self.cockpit:insert(self.instruction)
		self:insert(self.cockpit)

		
		local function flash()
			local leMax=1
			local leMin=0
			self.start.alpha=self.start.alpha-aMod
			self.fleche1.alpha = self.start.alpha
			self.fleche2.alpha = self.start.alpha
			if(self.start.alpha>=leMax or self.start.alpha<=leMin) then
				aMod = aMod*-1
			end
		end
		self.timerStart = timer.performWithDelay(50, flash, 0)
		
		self.x=display.contentWidth/2
		self.y=display.contentHeight/2
		local function switch(event)
			if(event.phase=='ended')then
				if(event.target.text=='<')then
					self.cibleX=self.cibleX+display.contentWidth
					event.target.text='>'
				elseif(event.target.text=='>')then

					self.cibleX=self.cibleX-display.contentWidth
					event.target.text='<'
				end
			end
		end
		
		local function touchLaunch(event)
			if(event.phase ~='moved') then
				if self.btOpen.alpha<1 then
					if event.phase == 'ended'then
						self.btClose.alpha=0
						self.btOpen.alpha=1
					end
				else
					if event.phase == 'began'then
						self.btLaunch.yScale=0.75
					else
						self.btLaunch.yScale=1
						self:animation()
						timer.cancel(self.timerStart)
						self.fleche1:removeEventListener('touch',switch)
						self.fleche2:removeEventListener('touch',switch)
						self.grandTitre.alpha=0
						self.btLaunchHB:removeEventListener('touch',touchLaunch)
						self.cibleX=0
						self.inDrag=false
						Runtime:removeEventListener('touch',self)
						
						local sons = audio.loadSound( "sons/clic.mp3" )
						audio.play(sons)
					end
				end
			end
		end
		
		
		self.btLaunchHB:addEventListener('touch',touchLaunch)
		Runtime:addEventListener('touch',self)
		self.fleche1:addEventListener('touch',switch)
		self.fleche2:addEventListener('touch',switch)
		
		local tRand = math.random(100,1000)
		local function changeScoreDisplay()
			self.scoreDisplay.text=self.scoreDisplayString[math.random(1,#self.scoreDisplayString)]
			self.scoreDisplay2.text=self.scoreDisplayString[math.random(1,#self.scoreDisplayString)]
			self.scoreDisplay3.text = self.scoreDisplayString[math.random(1,#self.scoreDisplayString)]
			tRand = math.random(100,1000)
			timer.performWithDelay(tRand, changeScoreDisplay, 1)
		end
		
		timer.performWithDelay(tRand, changeScoreDisplay, 1)
	end
	
	
	function menu:touch(event)
		if(event.phase =='began') then
			self.startX = self.cockpit.x
			
		end
		if(event.phase =='moved') then
			local dX=(event.x-event.xStart)+self.startX
			self.cockpit.x=dX
			if(self.cockpit.x<-display.contentWidth) then
				self.cockpit.x=-display.contentWidth
				
			elseif(self.cockpit.x>display.contentWidth) then
				self.cockpit.x=display.contentWidth
				
			end
			self.inDrag=true
		end
		if(event.phase =='ended' and self.inDrag==true) then
			self.inDrag=false
			if self.cockpit.x>display.contentWidth/2 then
				self.cibleX = display.contentWidth
				self.fleche1.text = '>'
				self.fleche2.text = '>'
			elseif self.cockpit.x<display.contentWidth/2 and self.cockpit.x>-display.contentWidth/2 then
				self.cibleX = 0
				self.fleche1.text = '>'
				self.fleche2.text = '<'
			elseif self.cockpit.x<-display.contentWidth/2 then
				self.cibleX = -display.contentWidth
				self.fleche1.text = '<'
				self.fleche2.text = '<'
			end
		end
	end
	
	function menu:enterFrame(event)
	self.credit.alpha = (math.random()*0.35)+0.5
	self.instruction.alpha = (math.random()*0.35)+0.5
		if(self.inDrag==false) then
			local dX= self.cockpit.x-self.cibleX
			self.cockpit.x=self.cockpit.x-dX/10
		end
	end
	
	function menu:animation()
		local message =display.newImage('img/menu/launch.png')
		message.alpha=0
		
		

		local rect=display.newRect(0,0,display.contentWidth,display.contentHeight)
		rect.fill = { 0.7, 0, 0 }
		rect.alpha=0
		rect.fill.effect = "filter.iris"
		rect.fill.effect.center = { 0.5, 0.5 }
		rect.fill.effect.aperture = 0.3
		rect.fill.effect.aperture = 0.3
		rect.fill.effect.aspectRatio = ( rect.width / rect.height )
		rect.fill.effect.smoothness = 1
		
		local aMod=0.02
		local aModMess=0.05
		local messCpt=0
		local rumbleInt=0
		local vitesseBool=false
		self:insert(message)
		self:insert(rect)
		
		local function flash()
			local leMax=0.25
			local leMin=0
			rect.alpha=rect.alpha-aMod
			if(rect.alpha>=leMax or rect.alpha<=leMin) then
				aMod = aMod*-1
			end
		end
		
		
		
		local function flashMess(event)
			local leMax=0.75
			local leMin=0
			message.alpha=message.alpha-aModMess
			if(message.alpha>=leMax or message.alpha<=leMin) then
				aModMess = aModMess*-1
				messCpt = messCpt+1
				if(messCpt>=9)then
					message.alpha=0
					timer.cancel(event.source)
					rumbleInt=10
					vitesseBool=true
					local sons = audio.loadSound( "sons/load.mp3" )
					audio.play(sons)
				end
			end
		end	
		local function rumble(event)
		self.lesEtoiles.x=math.random(-rumbleInt,rumbleInt)
		self.lesEtoiles.y=math.random(-rumbleInt,rumbleInt)

		end	
		local function vitesse(event)
			if(vitesseBool==true)then
				self.vit.alpha = 1
				self.vit.xScale=self.vit.xScale*1.1
				self.vit.yScale=self.vit.yScale*1.1
				self.vit.startParticleSize=self.vit.startParticleSize*1.12
				self.vit.finishParticleSize=self.vit.startParticleSize+50
				if self.vit.xScale>= 3 then
				timer.cancel(event.source)
				end
			end
		end
		
		
		local function fin()
			for i=1,#self.tTimer do
				timer.cancel(self.tTimer[i])
			end
			
			if(transition=='' or transition =='gameover') then
				self.main:creerJeu()
			else
				self.main:changerEnnemi(transition)
			end
			self:theEnd();
		end
		
		local sons = audio.loadSound( "sons/siren.mp3" )
		audio.play(sons,{duration =14000 ,loops=-1})
		self.tTimer = {
			timer.performWithDelay(50, flash, 0),
			timer.performWithDelay(50, flashMess, 0),
			timer.performWithDelay(50, rumble, 0),
			timer.performWithDelay(50, vitesse, 0),
			timer.performWithDelay(14000, fin, 1)
		}
		
	
	end
	function menu:kill()
		Runtime:removeEventListener('enterFrame',self)
		self:removeSelf()
		self=nil
	end
	
	function menu:theEnd()
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
	
	Runtime:addEventListener('enterFrame',menu)
	menu:init()
	
	return menu
end 

return Menu