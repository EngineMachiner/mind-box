
-- Can't load svg's that contain gradients. (maybe someday)

local border = { w = SCREEN_CENTER_X * 0.1, h = SCREEN_HEIGHT * 0.1 }
local w = SCREEN_CENTER_X - border.w * 2		local h = SCREEN_HEIGHT - border.h
local innerQuad = { w = w - border.w * 0.5, h = h - border.h * 0.5 }

local tweenTime = 3					local stayOn, waitOn = tweenTime, tweenTime * 2

local zoomScale = 720 / SCREEN_HEIGHT
local scale = SCREEN_HEIGHT / 720

local function quadTemplate()

	return Def.Quad {
		InitCommand=function(self)
			self:diffuse( Color.Black ):diffusealpha(0.925)
			self:setsize( innerQuad.w, innerQuad.h )
		end
	}

end

local function getRandomColor()

	local c = {}

	while #c <= 3 do

		local num = math.random(500,1000) * 0.001
		c[#c+1] = tostring(num) .. ","
		
	end

	c = c[1] .. c[2] .. c[3] .. "1"

	return color(c)

end

return Def.ActorFrame{

	quadTemplate(),

	InitCommand=function(self) self:CenterY():diffusealpha(0):x( w * 0.55 ) end,
	OpenCommand=function(self)
		self:finishtweening():playcommand("Fade")
		self:linear(0.5):diffusealpha(1)
		self:sleep(stayOn + waitOn):linear(0.5):diffusealpha(0)
	end,

	-- Create text texture
	Def.ActorFrameTexture{

		Name="TextBlock",
		InitCommand=function(self)
			self:setsize( innerQuad.w * zoomScale, innerQuad.h * zoomScale )
			self:EnableAlphaBuffer(true):Create()
		end,

		Def.BitmapText{

			Font=mindbox.fontPath,
			InitCommand=function(self) self:halign(0) end,
			PrintCommand=function(self)

				zoomScale = 720 / SCREEN_HEIGHT
				local limY = innerQuad.h * 0.875 * zoomScale
				
				local color = Color.White
				stayOn, waitOn = tweenTime, tweenTime
				local customColor = mindbox.Theme.Font.Color

				if mindbox.Theme.Font.randomColor then color = getRandomColor()
				elseif customColor then color = customColor end

				self:finishtweening():settext( mindbox.lastConcat )

				local textW, textH = self:GetZoomedWidth(), self:GetZoomedHeight()

				if textW > innerQuad.w * 0.9 then self:zoom( innerQuad.w * 0.9 * zoomScale / textW ) end

				self.nextY, textH = false, self:GetZoomedHeight()
				
				self:y( textH * 0.5 + border.h * 0.25 ):diffuse(color)

				mindbox.Actor.shouldScroll = false

				if textH > limY then

					local y = self:GetY()		local distance = textH - limY

					stayOn = stayOn * 2

					self.nextTweenTime = distance * 8 / limY

					waitOn = waitOn + self.nextTweenTime * 0.875

					self.nextY = y - distance
					
					mindbox.Actor.shouldScroll = true

				end
					
				self:queuecommand("Prepare")
					
			end,

			PrepareCommand=function(self)
				local p = self:GetParent():GetParent()				p:playcommand("Open")
				if self.nextY then self:sleep( tweenTime ):linear( self.nextTweenTime ):y( self.nextY ) end
			end
				
		}

	},

	-- Put texture on sprite
	Def.Sprite{
		InitCommand=function(self) 
			self:SetTexture( self:GetParent():GetChild("TextBlock"):GetTexture() )
			self:x( 20 * scale ):zoom( 1 / zoomScale )
		end
	},

	-- Top fade
	quadTemplate() .. {

		InitCommand=function(self)
			self:SetHeight( h * 0.475 ):y( - self:GetHeight() * 0.5 )
			self:diffusealpha(0):fadebottom(0.9)
		end,

		FadeCommand=function(self)

			if not mindbox.Config.showFading then return end

			self:finishtweening()

			if not mindbox.Actor.shouldScroll then self:diffusealpha(0) return end
			self:diffusealpha(0):sleep( 0.5 ):linear( stayOn + waitOn - 1 ):diffusealpha(1)

		end

	},

	-- Bottom fade
	quadTemplate() .. {

		InitCommand=function(self)
			self:SetHeight( h * 0.475 ):y( self:GetHeight() * 0.5 )
			self:diffusealpha(0):fadetop(0.9)
		end,

		FadeCommand=function(self)

			if not mindbox.Config.showFading then return end

			self:finishtweening()

			if not mindbox.Actor.shouldScroll then self:diffusealpha(0) return end
			self:diffusealpha(1):sleep( 0.5 ):linear( stayOn + waitOn - 1 ):diffusealpha(0)

		end

	},

	-- Window
	Def.Sprite{
		Texture=mindbox.windowPath,
		InitCommand=function(self)
			self:setsize( w * 1.05, h * 1.025 ):SetTextureFiltering(false)
			self:diffuse( color("#909090") ):diffusealpha(1)
		end
	},

	-- Title
	Def.ActorFrame{

		InitCommand=function(self) self:y( - h * 0.476 ):zoom( 0.5 * scale ) end,

		Def.Quad{
			InitCommand=function(self)
				self:setsize(600, 50):diffuse( color("#202020") )
				self:fadeleft(0.25):faderight(0.25)
			end
		},

		Def.BitmapText{
			Font=mindbox.fontPath,
			InitCommand=function(self) self:settext("mind$box - Console"):diffuse( color("#959595") ) end
		}

	}

}
