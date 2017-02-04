-----------------------------------------------------------------------------------------
--
-- Lights.lua
--
-----------------------------------------------------------------------------------------
local Lights ={}


function Lights:new(col,row,hautCol,largRow)
	local c_Light= require('classe_light')
	local lights = display.newGroup()
		--Méthodes
	function lights:init()
		--init
		for i=1,row do
			for j=1,col do
				local light = c_Light:new()
				light.y= (i-1)*hautCol
				light.x= (j-1)*largRow
				lights:insert(light)
			end
		end
		
	end

	lights:init()
	--Event
	
	return lights
end

return Lights