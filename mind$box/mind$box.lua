
mindbox = { 
	Lim = 40, -- One line / row char limit
	Theme = { Graphic = 1, Text = 1 },
	Path = "/Scripts/mind$box/",
	Config = {}
}

local function remove(tbl)

	for k,v in pairs(tbl) do
		if type(v) == "table" then remove(v) end
	end

	if tbl.ctx then tbl.ctx = nil end

end

local function ConcatValues( tbl, moveTo, spaces )

	local config = mindbox.Config

	remove(tbl)

	spaces = spaces or ''

	-- Convert indexed nil to strings
	for i=1,#tbl do 
		if tbl[i] == nil then tbl[i] = tostring(nil) end 
	end

	local lastKey
	for k,v in pairs(tbl) do lastKey = k end

	--

	for k,v in pairs(tbl) do

		local newVal = tostring(v)

		if type(v) == "table" then

			spaces = spaces .. "    "

			-- Only objects / actors allowed, not tables
			-- dunno why table.GetChildren exists
			if v.GetChildren and config.Children
			and not tostring(v):match("table") then
				v.Children = v:GetChildren()
			end

			newVal = ConcatValues(v, {}, spaces)

			newVal = tostring(v) .. " { \n" .. table.concat(newVal)

			spaces = spaces:sub(1, #spaces - 4)
			
			newVal = newVal .. '\n' .. spaces .. "}"
			
		end

		local tblSkip = ''
		if type(v) == "table" then tblSkip = '\n' end
		
		if lastKey ~= k then 
			newVal = newVal .. ",\n" .. tblSkip
		end

		if type(k) == "number" and not config.Indexes then 
			moveTo[k] = tblSkip .. spaces .. newVal
		else 

			if config.Indexes and type(k) == "number" then 
				k = '[' .. tostring(k) .. ']' 
			end

			if k == "" then k = '""' end
			moveTo[#moveTo+1] = tblSkip .. spaces .. k .. " = " .. newVal 

		end

	end

	return moveTo

end

-- print functions

local function loadDefConfig()
	mindbox.Config.Indexes = false
	mindbox.Config.Trace = false
	mindbox.Config.Children = false
end

local function print( ... )

	local tbl = table.pack(...)		tbl.n = nil
	tbl = ConcatValues( tbl, {} )

	local s = table.concat( tbl )

	if mindbox.Config.Trace then
		mindbox.Trace = debug.traceback(2)
		s = s .. "\n\n" .. mindbox.Trace
	end

	s = s:gsub("/BGAnimations/Resources/", "../")
	local song = GAMESTATE:GetCurrentSong()
	if song then
		song = song:GetSongDir():gsub("(%p)", "%%%1")
		s = s:gsub(song,"../SongsFolder/")
	end

	mindbox.ConcatInfo = s
	
	MESSAGEMAN:Broadcast("mindboxConsoleInit")
	
	loadDefConfig()

end
mindbox.print = print

mindbox.SpawnConsole = function()
	return loadfile(mindbox.Path .. "Console/Main.lua")()
end