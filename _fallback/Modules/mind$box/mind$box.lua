
local function getOnlyFiles( path )

	local output = {}
	local onlyDirs = FILEMAN:GetDirListing( path, true, true )
	local toFilter = FILEMAN:GetDirListing( path, false, true )
	
	for k,v in pairs( toFilter ) do
		local skip = false		
		for k2, v2 in pairs( onlyDirs ) do if v == v2 then skip = true break end end
		if not skip then output[#output+1] = v end
	end

	return output

end

local function find( toFilter, ext )

	local output = {}
	for k, v in pairs( toFilter ) do
		local dir = FILEMAN:GetDirListing( v .. "/", false, true )
		for k2, v2 in pairs( dir ) do if v2:match( ext .. "$" ) then output[#output+1] = v2 end end
	end

	return output

end

local defaultConfig = {
	showChildren = false, showIndexes = false, showTraces = false,
	showObjectId = true,	showFading = true,
	resetConfigOnPrint = true
}

local fontTheme = { 
	Index = 1,		randomColor = false,		customFont = false
}

mindbox = mindbox or {
	Theme = { Graphic = 1, Font = fontTheme },		Config = defaultConfig,
	Path = "/Appearance/Themes/_fallback/Modules/mind$box/"
}

mindbox.Windows = getOnlyFiles( mindbox.Path .. "Graphics/Windows/" )
mindbox.Fonts = find( FILEMAN:GetDirListing( mindbox.Path .. "Fonts/", true, true ), ".ini" )

local config = mindbox.Config

-- Remove useless data
local function purge(tbl)

	for k,v in pairs(tbl) do if type(v) == "table" then purge(v) end end

	if tbl.ctx then tbl.ctx = nil end

end

local function pack( tbl, moveTo, spaces )

	purge(tbl)			spaces = spaces or ''

	-- Convert indexed nil to strings.
	for i=1,#tbl do if tbl[i] == nil then tbl[i] = tostring(nil) end end

	local lastKey
	
	for k,v in pairs(tbl) do lastKey = k end

	-- The "start"...
	for k,v in pairs(tbl) do

		local cachedSpace = spaces				local isEmpty
		local s = tostring(v)					local newLines = ''
		local isTable = type(v) == "table"		local isIndex = type(k) == "number"

		-- Actors and objects and be table types
		if isTable then

			local v2 = tostring(v)

			spaces = spaces .. "    "

			-- Only objects / actors allowed, no tables.
			
			local childLine, bracket1, bracket2 = '\n', " { ", "}"
			local isObject = not v2:match("table")
			local isParent = v.GetChildren and isObject

			if not config.showObjectId then

				if isObject then v2 = v2:sub( 1, v2:find( " " ) - 1 )
				else v2 = v2:sub(1,5) end

			end

			if isParent and config.showChildren then v.Children = v:GetChildren() end

			s = pack(v, {}, spaces)			
			
			spaces = spaces:sub(1, #spaces - 4)

			isEmpty = next(v) == nil
			if isEmpty then childLine = '' bracket1 = '' bracket2 = '' end

			s = v2 .. bracket1 .. childLine .. table.concat(s)

			if isEmpty then cachedSpace = spaces		spaces = '' end

			s = s .. childLine .. spaces .. bracket2		newLines = '\n'

		end
		
		if lastKey ~= k then 
			s = s .. ",\n"			if not isEmpty then s = s .. newLines end
		end

		if lastKey == k then s = s .. newLines end

		spaces = cachedSpace

		if isIndex then

			if config.showIndexes then

				k = '[' .. tostring(k) .. ']' 
				moveTo[#moveTo+1] = newLines .. spaces .. k .. " = " .. s

			else moveTo[k] = newLines .. spaces .. s end
			

		else

			if k == "" then k = '""' end
			moveTo[#moveTo+1] = newLines .. spaces .. k .. " = " .. s

		end

	end

	return moveTo

end
mindbox.pack = pack

local function concat( ... )

	local tbl = table.pack( ... )			tbl.n = nil
	return table.concat( pack( tbl, {} ) )
	
end
mindbox.concat = concat

local function resetConfig() mindbox.Config = defaultConfig end
mindbox.resetConfig = resetConfig

local function print( ... )

	local s = concat( ... )

	if config.showTraces then s = s .. "\n\n" .. debug.traceback(2) end

	-- Format beat4sprite and song path (long)
	
	s = s:gsub("/BGAnimations/Resources/", "../")

	local song = GAMESTATE:GetCurrentSong()

	if song then

		song = song:GetSongDir():gsub( "(%p)", "%%%1" )

		s = s:gsub( song, "../SongsFolder/" )

	end

	mindbox.lastConcat = s
	
	local actor = mindbox.Actor
	if actor then actor:playcommand("SpawnMindboxConsole")
	else SCREENMAN:SystemMessage("mind$box: Console hasn't been created yet!") end
	
	if config.resetConfigOnPrint then resetConfig() end

end
mindbox.print = print

mindbox.spawn = function( ... )

	local args = ...

	local fontData = mindbox.Theme.Font
	mindbox.windowPath = mindbox.Windows[ mindbox.Theme.Graphic ]
	mindbox.fontPath = fontData.customFont or mindbox.Fonts[ fontData.Index ]

	return loadfile( mindbox.Path .. "Console/Main.lua" )() .. { 
		OnCommand=function() if args then print( args ) end end 
	}

end

return mindbox
