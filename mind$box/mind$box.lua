
mindbox = { Path = "/Appearance/Themes/_fallback/Modules/mind$box/" }

LoadModule("mind$box/Config.lua")		LoadModule("mind$box/Concat.lua")
LoadModule("mind$box/Print.lua")

local config = mindbox.Config
mindbox.resetConfig = function() for k,v in pairs( config.Defaults ) do config[k] = v end end

-- To be done: Reset config to defaults if no config found in txt.
mindbox.resetConfig()

local tapLua = tapLua.OutFox.FILEMAN
mindbox.Windows = tapLua.getFiles( mindbox.Path .. "Graphics/Windows/" )
mindbox.Fonts = tapLua.getFilesBy( FILEMAN:GetDirListing( mindbox.Path .. "Fonts/", true, true ), "%.ini" )

mindbox.spawn = function(...)

	local fontData = mindbox.Theme.Font
	mindbox.windowPath = mindbox.Windows[ mindbox.Theme.Graphic ]
	mindbox.fontPath = fontData.custom or mindbox.Fonts[ fontData.Index ]

	return loadfile( mindbox.Path .. "Console/Frame.lua" )(...)

end