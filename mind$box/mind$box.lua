
mindbox = { 
	Lim = 40,
	Theme = 2
}
local a = mindbox


-- ConcatTable
local function IsEmpty( t, which )

	local check
	for k,v in pairs(t) do
		if v then check = true break end
	end

	local s = which or "Start"

	local tbl = {
		Start = function() return check and " \n" or "" end
	}

	return tbl[s]()
	
end

local function ConcatTable( ... )

	local lim = mindbox.Lim
	local tbl_init = { ... }
	local s = { Lim = "" }
	s.str, s.spc = "", ""
	
	local args = ...
	local function Reload( tbl )

		if tbl ~= tbl_init then
			s.spc = s.spc .. "    "
			s.str = tostring(tbl) .. " {" .. IsEmpty(tbl)
		end
		s.str = tbl == args and s.str .. "\n" or s.str

      	local lst_i = 0
      	for k,v in pairs( tbl ) do
        	lst_i = lst_i + 1
      	end

    	local i = 0
	   	for k,v in pairs( tbl ) do

			local val = tostring(v)
			local s1 = type(v) == "table" and "\n" or ""
			s1 = s.str .. s1 .. s.spc
			local sp = [["]] .. k .. [["]] .. " = "
			s1 = s1 .. sp

        	i = i + 1
		   	if type(k) == "number" then
				s1 = k == 1 and s.str .. s.spc or s.str
		   	end

			if type(v) == "table" then

				val = Reload(v)
				s.spc = s.spc:sub(1,#s.spc-4)
				val = val .. s.spc .. "}"

				-- Check if empty
				val = val:gsub("{    }","{}")
				s.Lim = ""

			end

			local s2 = val .. ",\n"

			if type(v) ~= "table" then
				if #sp + #val + 1 <= lim and #s.Lim <= lim then
					s.Lim = s.Lim .. sp .. val .. ","
					s2 = val .. ", "
				end
			else
				s2 = s2 .. IsEmpty(v)
			end

			s2 = i == lst_i and val .. "\n" or s2

			s.str = s1 .. s2

	    end

		s.str = tbl == args and s.str .. "\n" or s.str

	    return s.str 

	end

	local final = Reload( tbl_init )
	final = final:gsub("/BGAnimations/Resources/", "../")
	if GAMESTATE then
		local song = GAMESTATE:GetCurrentSong()
		song = song:GetSongDir():gsub("(%p)", "%%%1")
		final = final:gsub(song,"../SongFolder/")
	end

	return final

end
a.ConcatTable = ConcatTable


-- print
local screens = {
	"ScreenEdit",
	"ScreenGameplay"
}

local function print( ... )

	local screen = SCREENMAN:GetTopScreen()
	mindbox.Beat = false
	for k,v in pairs( screens ) do
		if screen:GetName() == v then
			mindbox.Beat = true break
		end
	end

	local old = mindbox.Lim
	mindbox.Lim = 13

	local s = ConcatTable( ... )
	--s = s .. "\n" .. ConcatTable( debug.traceback() ) 
	s = s .. "\n"

	local pb = SCREENMAN:GetTopScreen():GetChild("mb_paper")
	if not pb then
		local s = "/Scripts/mind$box/PrintedPaper.lua"
		SCREENMAN:GetTopScreen():AddChildFromPath(s)
	end

	pb = SCREENMAN:GetTopScreen():GetChild("mb_paper")
	pb.TextString = s
	pb:queuecommand("Print")

	mindbox.Lim = old

end
a.print = print


-- FirstDelta
local function FirstDelta(self)
	self.d = self.d or self:GetEffectDelta()
	print(self.d)
end
a.FirstDelta = FirstDelta