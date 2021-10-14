
local windows = {
	"Window.png",
	"Window_2.png"
}

local f_path = mindbox.Path
local tex = f_path

f_path = f_path .. "Font/_eurostile Outline/30px.ini"
tex = tex .. windows[mindbox.Theme]

local m_float = 0.0625

local w = SCREEN_WIDTH * ( 0.5 - m_float )
local h = SCREEN_HEIGHT * ( 1 - m_float )

local long_sleep
local n = 4 -- short sleep

local scl = SCREEN_HEIGHT / 720

local function QuadInit(self)
	self.p = self.p or self:GetParent()
	self:diffuse(Color.Black)
	self:diffusealpha(0.875)
	self:setsize( w, h )
end

return Def.ActorFrame{

	Name = "mb_paper",
	InitCommand=function(self)

		self.Lock = {}
		self.b = mindbox.Beat and GAMESTATE:GetSongBeat()
		local s = SCREENMAN:GetTopScreen()

		self:CenterY()
		self:diffusealpha(0)
		self:x( w * ( 0.5 + m_float ) )
		
		self:SetUpdateFunction(function()

			-- Trigger closing fading
			if s:GetName():match("MainMenu")
			and self.Lock[2] then 
				self:playcommand("GoodBye")
				self.Lock[2] = false
			end

			-- Trigger how to show up
			
			if mindbox.Beat then

				if self.b and self.b ~= GAMESTATE:GetSongBeat() then
					self.b = GAMESTATE:GetSongBeat()
					self.Lock[1] = false
				end
				
				if not self.Lock[1] then

					local BGChanges = GAMESTATE:GetCurrentSong()
					BGChanges = BGChanges:GetBGChanges()
					local b = GAMESTATE:GetSongBeat()
					
					for i=1,#BGChanges do
						local a = BGChanges[i].start_beat
						if b >= a + 0.001 and b <= a + 0.1
						or a == b then
							self:queuecommand("Print")
							self.Lock[1] = true
						break end
					end

				end
				
			end

		end)

	end,
	GoodByeCommand=function(self)
		self:stoptweening()
		self:linear(0.5)
		self:diffusealpha(0)
	end,

	Def.Quad{
		InitCommand=QuadInit,
		WaitNFadeCommand=function(self)
			self:GetParent().Lock[2] = true
			local sleep = long_sleep and long_sleep + n * 2.5 or n
			self.p:stoptweening()
			self.p:linear(0.5):diffusealpha(1)
			self.p:sleep(sleep)
			self.p:linear(0.5):diffusealpha(0)
		end
	},
	Def.ActorFrameTexture{
		Name="TextBlock",
		InitCommand=function(self)
			self:setsize( w * 2, h * 2 )
			self:EnableAlphaBuffer(true)
			self:Create()
		end,
		Def.ActorFrame{
			Def.BitmapText{
				Font=f_path,
				InitCommand=function(self)
					self:halign(0)
					self:x( w * m_float - 13 * scl )
					self:GetParent():zoom(2)
				end,
				PrintCommand=function(self)

					local p = self:GetParent():GetParent()
					p = p:GetParent()

					local c = {}
					while #c < 4 do
						local num = math.random(500,1000)
						num = num * 0.001
						c[#c+1] = tostring(num) .. ","
					end
					local colour = c[1] .. c[2] .. c[3] .. "1"
					colour = color(colour)

					p:RunCommandsOnChildren(function(c) 
						c:finishtweening() 
					end)

					self:settext(p.TextString)
					self:diffuse(colour)

					self:zoom(1)
					if self:GetWidth() > w then
						local v = self:GetWidth()
						v = w * ( 1 - m_float * 2 ) / v
						self:zoom( v )
					end

					local h2 = self:GetZoomedHeight()
					self:y( h2 * 0.5 + 40 * scl )

					if h2 > h then

						local a = self:GetY()
						local b = ( h2 - h ) + 80 * scl
						long_sleep = b * 8 / h

						b = a - b
						self.Y = b

						self:sleep(n)
						self:queuecommand("Scroll")
						p:queuecommand("Fade")

					end

					p:queuecommand("WaitNFade")

				end,
				ScrollCommand=function(self)
					self:linear(long_sleep)
					self:y( self.Y )
				end
			}
		}
	},
	Def.Sprite{
		InitCommand=function(self)
			self.p = self:GetParent()
			local aft = self.p:GetChild("TextBlock")
			local tex = aft:GetTexture()
			self:SetTexture(tex):zoom(0.5)
		end
	},

	-- Bottom fade
	Def.Quad{
		InitCommand=function(self)
			QuadInit(self)
			self:SetHeight( h * 0.5 )
			self:y( self:GetHeight() * 0.5 )
			self:diffusealpha(0)
		end,
		FadeCommand=function(self)
			local f = long_sleep and 0.875 or 1
			local da = long_sleep and 1 or 0
			self:stoptweening()
			self:diffusealpha(da)
			self:sleep(0.25):linear(0.25)
			self:fadetop(f)
			if long_sleep then
				self:sleep(n)
				self:linear( long_sleep + n * 0.25 )
				self:diffusealpha(0)
			end
		end
	},

	-- Top fade
	Def.Quad{
		InitCommand=function(self)
			QuadInit(self)
			self:SetHeight( h * 0.5 )
			self:y( - self:GetHeight() * 0.5 )
			self:diffusealpha(0)
		end,
		FadeCommand=function(self)
			local f = long_sleep and 0.875 or 1
			self:stoptweening()
			self:sleep(0.25):linear(0.25)
			self:diffusealpha(0)
			self:fadebottom(f)
			if long_sleep then
				self:sleep(n * 1.125)
				self:linear( long_sleep )
				self:diffusealpha(1)
			end
		end
	},

	-- Window
	Def.Sprite{
		Texture=tex,
		InitCommand=function(self)
			self:setsize( w * 1.05, h * 1.025 )
			self:SetTextureFiltering(false)
			self:zoom(1.0625)
			self:diffuse(color("#909090"))
			self:diffusealpha(1)
		end
	},

	-- Title
	Def.ActorFrame{
		InitCommand=function(self)
			self:y( - h * 0.476 )
			self:zoom(0.5 * scl)
		end,

		Def.Quad{
			InitCommand=function(self)
				self:setsize(300, 50)
				self:diffuse(color("#202020"))
				self:fadeleft(0.25):faderight(0.25)
			end
		},

		Def.BitmapText{
			Font=f_path,
			InitCommand=function(self)
				self:settext("mind$box")
				self:diffuse(color("#959595"))
			end
		}
	}

}