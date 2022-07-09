
mindbox = { 
	Lim = 40, -- One line / row char limit
	Theme = { Graphic = 1, Text = 1 },
	Path = "/Scripts/mind$box/",
	ToShow = { Indexes = false, Trace = false }
}

local function ConcatValues( tbl, moveTo, showIndexes, spaces )

	spaces = spaces or ''

	-- Convert indexed nil to strings
	for i=1,#tbl do 
		if tbl[i] == nil then tbl[i] = tostring(nil) end 
	end

	local lastKey
	for k,v in pairs(tbl) do lastKey = k end

	for k,v in pairs(tbl) do

		local newVal = tostring(v)

		if tostring(v):match("table") then

			spaces = spaces .. "    "

			newVal = ConcatValues(v, {}, showIndexes, spaces)

			newVal = "{ \n" .. table.concat(newVal)

			spaces = spaces:sub(1, #spaces - 4)
			
			newVal = newVal .. '\n' .. spaces .. "}"
			
		end

		local tblSkip = ''
		if tostring(v):match("table") then tblSkip = '\n' end
		
		if lastKey ~= k then 
			newVal = newVal .. ",\n" .. tblSkip
		end

		if type(k) == "number" and not showIndexes then 
			moveTo[k] = tblSkip .. spaces .. newVal
		else 

			if showIndexes and type(k) == "number" then 
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
	mindbox.ToShow.Indexes = false
	mindbox.ToShow.Trace = false
end

local function print( ... )

	local tbl = table.pack(...)		tbl.n = nil
	tbl = ConcatValues( tbl, {}, mindbox.ToShow.Indexes )

	local s = table.concat( tbl )

	if mindbox.ToShow.Trace then
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