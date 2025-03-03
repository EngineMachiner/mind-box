
local input = table.pack(...)

local scale = SCREEN_HEIGHT / 720

local function console() return mindbox.Console end

local config = mindbox.Config

local showFading = config.showFading


local title = "mind$box - Console"

local fontTheme = mindbox.Theme.Font
local fontFile = fontTheme.File

-- We need to adjust every actor into our window.
-- The window will be the director.

-- Can't load SVG gradients.

local margin = 0.915 -- The float based on the window's margin.

local windowFile = mindbox.Theme.Window

local window = Def.Sprite {

    Name = "Window",        Texture = windowFile,

    InitCommand=function(self)

        mindbox.Console = self:GetParent()


        self:zoom( scale )        local color = color("#909090")

        self:diffuse(color):SetTextureFiltering(false)


        local w, h = self:GetZoomedWidth(), self:GetZoomedHeight()

        console():setsize(w, h):queuecommand("PostInit")

    end,

    PostInitCommand=function()
        
        if not input[1] then return end

        mindbox.print( table.unpack(input) )
    
    end

}


local function quad()

	return Def.Quad {

		InitCommand=function(self) self:diffuse( Color.Black ) end,

        PostInitCommand=function(self)

            local p = self:GetParent()

            local width, height = p:GetWidth(), p:GetHeight()

            self:setsize( width * margin, height * margin )

        end

	}

end


return Def.ActorFrame {

	InitCommand=function(self)
        
        local w = self:GetWidth()

        self:CenterY():x( w * 0.625 ):diffusealpha(0)

        self:draworder(100) -- Just in case to show up further.
    
    end,

	FadeCommand=function(self)

        self:diffusealpha(0)
        
        self:linear(0.5):diffusealpha(1)        self:sleep( self.time )
        self:linear(0.5):diffusealpha(0)
        
	end,

	OffCommand=function(self)

		self:finishtweening()

		self:RunCommandsOnChildren( function(child) child:finishtweening() end )

	end,

    quad() .. { -- Background.

        InitCommand=function(self) self:diffusealpha(0.925) end

    },
    
    dofile( mindbox.Path .. "Console/Text.lua" ),

	quad() .. { -- Top fade.

		PostInitCommand=function(self)

            local h = self:GetHeight() * 0.25

            self:SetHeight(h):y( - h * 1.5 )

			self:diffusealpha(0):fadebottom(0.5)

		end,

		FadeCommand=function(self)

			if not showFading then return end

            self:diffusealpha(0)


            local scroll = console().scroll

			if not scroll then return end


            local time =  console().time - 1

			self:sleep(0.5):linear(time):diffusealpha(1)

		end

	},

	quad() .. { -- Bottom fade.

		PostInitCommand=function(self)

            local h = self:GetHeight() * 0.25

            self:SetHeight(h):y( h * 1.5 )

            self:diffusealpha(0):fadetop(0.5)

		end,

		FadeCommand=function(self)

			if not showFading then return end

            self:diffusealpha(0)


            local scroll = console().scroll

			if not scroll then return end


            local time =  console().time - 1

			self:diffusealpha(1):sleep(0.5):linear(time):diffusealpha(0)

		end

	},

	window,

	Def.ActorFrame { -- Console title.

		PostInitCommand=function(self) 
            
            local h = console():GetHeight()         local offset = 24 * scale

            self:y( - h * 0.5 + offset ):zoom( scale * 0.5 )
        
        end,

		Def.Quad {

			InitCommand=function(self)

                local color = color("#202020")

				self:setsize(600, 45):diffuse(color)

				self:fadeleft(0.25):faderight(0.25)

			end

		},

		Def.BitmapText {

			Font = fontFile,          Text = title,

			InitCommand=function(self)
                
                local color = color("#959595")      self:diffuse(color) 
            
            end

		}

	}

}
