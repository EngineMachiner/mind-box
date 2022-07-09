
local windows = {
	"Window.png",	"Window_2.png"
}

local dir = mindbox.Path
local Graphic = dir .. "/Graphics/" .. windows[mindbox.Theme.Graphic]
local FontP = dir .. "Font/_eurostile Outline/30px.ini"

local borderO = { SCREEN_CENTER_X * 0.1, SCREEN_HEIGHT * 0.1 }
local w = SCREEN_CENTER_X - borderO[1] * 2
local h = SCREEN_HEIGHT - borderO[2]
local borderI = { w - borderO[1] * 0.5, h - borderO[2] * 0.5 }

local scl = SCREEN_HEIGHT / 720

local function GetQTemplate()
	return Def.Quad {
		InitCommand=function(self)
			self:diffuse(Color.Black)
			self:diffusealpha(0.925)
			self:setsize( borderI[1], borderI[2] )
		end
	}
end

local function RandomColor()
	local c = {}
	while #c < 4 do
		local num = math.random(500,1000) * 0.001
		c[#c+1] = tostring(num) .. ","
	end
	c = c[1] .. c[2] .. c[3] .. "1"
	return color(c)
end

-- 2 is the default tween duration
local defTween = 3
local stayOn = defTween
local waitOn = defTween
return Def.ActorFrame{

	InitCommand=function(self)
		self:CenterY():diffusealpha(0)
		self:x(w * 0.55)
	end,
	OpenCommand=function(self)
		self:finishtweening()
		self:linear(0.5):diffusealpha(1)
		self:queuecommand("Fade")
		self:sleep(stayOn + waitOn)
		self:linear(0.5):diffusealpha(0)
	end,

	GetQTemplate(),

	-- Create text texture
	Def.ActorFrameTexture{

		Name="TextBlock",
		InitCommand=function(self)
			self:setsize( borderI[1], borderI[2] )
			self:EnableAlphaBuffer(true)
			self:Create()
		end,

			Def.BitmapText{

				Font=FontP,
				InitCommand=function(self) 
					self:halign(0)
				end,
				PrintCommand=function(self)

					self:finishtweening()
					self:settext(mindbox.ConcatInfo)

					local color = Color.White

					if mindbox.Theme.Text == 2 then
						color = RandomColor()
					elseif type(mindbox.Theme.Text) == "table" 
					and mindbox.Theme.Text.Color then
						color = mindbox.Theme.Text.Color
					end

					self:diffuse(color)

					local textW = self:GetZoomedWidth()
					local textH = self:GetZoomedHeight()

					if textW > borderI[1] * 0.9 then 
						self:zoom( borderI[1] * 0.9 / textW ) 
					end

					textH = self:GetZoomedHeight()
					self:y( textH * 0.5 + borderO[2] * 0.25 )

					self.newY = nil
					stayOn = defTween		waitOn = defTween

					local limY = borderI[2] * 0.5 * 1.75
					if textH > limY then

						local y = self:GetY()
						local distance = textH - limY

						self.newT = distance * 8 / limY

						stayOn = stayOn * 2
						waitOn = self.newT * 0.75 * 1.25
						
						self.newY = y - distance

					end
					
					self:queuecommand("Prepare")
					
				end,
				PrepareCommand=function(self)
					local p = self:GetParent():GetParent()
					p:playcommand("Open")
					if self.newY then
						self:sleep( defTween )
						self:linear( self.newT )
						self:y( self.newY )
					end
				end
				
			}

	},

	-- Put texture on sprite
	Def.Sprite{
		InitCommand=function(self)
			local p = self:GetParent()
			local AFT = p:GetChild("TextBlock")
			local Tex = AFT:GetTexture()
			self:SetTexture(Tex)
			self:x( 20 * scl )
		end
	},

	-- Top fade
	GetQTemplate() .. {
		InitCommand=function(self)
			self:SetHeight( h * 0.5 )
			self:y( - self:GetHeight() * 0.5 )
			self:diffusealpha(0)
		end,
		FadeCommand=function(self)

		end
	},

	-- Bottom fade
	GetQTemplate() .. {
		InitCommand=function(self)
			self:SetHeight( h * 0.5 )
			self:y( self:GetHeight() * 0.5 )
			self:diffusealpha(0)
		end,
		FadeCommand=function(self)

		end
	},

	-- Window
	Def.Sprite{
		Texture=Graphic,
		InitCommand=function(self)
			self:setsize( w * 1.05, h * 1.025 )
			self:SetTextureFiltering(false)
			self:diffuse(color("#909090"))
			self:diffusealpha(1)
		end
	},

	-- Title
	Def.ActorFrame{

		InitCommand=function(self)
			self:y( - h * 0.476 ):zoom(0.5 * scl)
		end,

		Def.Quad{
			InitCommand=function(self)
				self:setsize(600, 50)
				self:diffuse(color("#202020"))
				self:fadeleft(0.25):faderight(0.25)
			end
		},

		Def.BitmapText{
			Font=FontP,
			InitCommand=function(self)
				self:settext("mind$box - Console")
				self:diffuse(color("#959595"))
			end
		}

	}

}