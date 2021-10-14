
mindbox = { 
	Lim = 40,
	Theme = 1,
	Path = "/Scripts/mind$box/"
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
		Start = function() return check and "\n" or "" end
	}

	return tbl[s]()
	
end

local function ConcatTable( ... )

	local lim = mindbox.Lim

	local tbl_init = { ... }
	local s = { Lim = "" }
	s.str, s.spc = "", ""
	
	local args = ...
	local former
	local function Reload( smth )

		local s_type = ""
		if smth ~= tbl_init then
			former = former or smth
			s_type = tostring(smth) .. " {"
			s_type = s_type .. IsEmpty(smth)
			s.str = s.str .. s_type
		end

      	local lst_i = 0
      	for k,v in pairs( smth ) do
        	lst_i = lst_i + 1
      	end

		if lst_i > 0
		and smth ~= tbl_init then
			s.spc = s.spc .. "    "
		end

    	local i, b4 = 0
	   	for k,v in pairs( smth ) do

			i = i + 1

			local last = i == lst_i and "" or ","
			local s_val = tostring(v)
			local s_key = [["]] .. k .. [["]] .. " = "
			s_key = type(k) == "number" and "" or s_key
			
			if type(v) == "table" then

				if type(b4) ~= "table"
				and i > 1 then
					s.str = s.str .. "\n" .. s.spc
				end

				s.str = s.str .. "\n" .. s.spc
				s.str = s.str .. s_key
				Reload(v)
				
				s_val = "}" .. last
				if IsEmpty(v) == "\n" then
					s.spc = s.spc:sub(1,#s.spc-4)
					local spc = "\n" .. s.spc
					s_val = spc .. s_val
				end
				s.Lim = ""

				s.str = s.str .. s_val

			else

				if type(b4) == "table" then
					s.str = s.str .. "\n\n" .. s.spc
				end

				s.Lim = s.Lim .. s_key
				s.Lim = s.Lim .. s_val .. last

				local a = "\n"
				if #s.Lim <= lim then 
					a = " "
				else
					s_key = i > 1 and s.spc .. s_key or s_key
					s.Lim = s_key
					s.Lim = s.Lim .. s_val .. last
					if #s.Lim > lim then lim = #s.Lim end
				end
				
				local nl = smth == former and "\n" or ""
				s_key = i == 1 and nl .. s.spc .. s_key or s_key
				
				if a == " " then
					s_val = s_val .. last .. a
				else
					s_key = i > 1 and a .. s_key or s_key
					s_val = s_val .. last
				end

				s.str = s.str .. s_key .. s_val

			end

			if i == lst_i and smth == former then
				s.str = s.str .. "\n"
			end

			b4 = v

	    end

	    return s.str 

	end

	local final = Reload( tbl_init )
	final = final:sub(2,#final)
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
	mindbox.Lim = 40

	local s = ConcatTable( ... )
	s = s .. "\n\n" .. ConcatTable( debug.traceback() )

	local pb = SCREENMAN:GetTopScreen():GetChild("mb_paper")
	if not pb then
		local path = mindbox.Path .. "PrintedPaper.lua"
		SCREENMAN:GetTopScreen():AddChildFromPath(path)
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