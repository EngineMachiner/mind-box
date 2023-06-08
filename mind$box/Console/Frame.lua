
local args = ...
local path = mindbox.Path .. "Console/Actors.lua"

return Def.ActorFrame {
	InitCommand=function(self) mindbox.Actor = self end,
	OnCommand=function() if not args then return end mindbox.print(args) end,
	SpawnConsoleMessageCommand=function(self)
		self:RemoveAllChildren():AddChildFromPath(path)
		self:playcommand("Print")
	end
}