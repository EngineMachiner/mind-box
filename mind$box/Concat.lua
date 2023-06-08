
-- Remove useless data.
local function purge(tbl)

	for k,v in pairs(tbl) do if type(v) == "table" then purge(v) end end

	if tbl.ctx then tbl.ctx = nil end

end

local function pack( tbl, moveTo, spaces )

	local config = mindbox.Config

	purge(tbl)			spaces = spaces or ''

	-- Parse indexed nil to strings.
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

			if not config.showObjectID then

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

mindbox.concat = function(...)

	local tbl = table.pack(...)			tbl.n = nil
	return table.concat( pack( tbl, {} ) )

end