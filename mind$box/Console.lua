
local screens = {
	"ScreenEdit",
	"ScreenGameplay"
}

return Def.ActorFrame{
	Name="mindbox-Console",
	LoadCommand=function(self)

		local screen = SCREENMAN:GetTopScreen()
        
		mindbox.Beat = false
		for k,v in pairs( screens ) do
			if screen == v then
				mindbox.Beat = true break
			end
		end
		
		local old = mindbox.Lim
		mindbox.Lim = 40
		
		local s = mindbox.ConcatTable( mindbox.TextToDo )
		s = s .. "\n\n" .. mindbox.Trace
		
		mindbox.TextString = s

		if not self.Create then
			local path = mindbox.Path .. "PrintedPaper.lua"
			self:AddChildFromPath(path)
			self.Create = true
		end
		self:playcommand("Print")
		
		mindbox.Lim = old

	end
}