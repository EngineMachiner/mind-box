
local path = mindbox.Path .. "Console/Core.lua"

return Def.ActorFrame{
	InitCommand=function(self) mindbox.Actor = self end,
	SpawnMindboxConsoleMessageCommand=function(self)
		self:RemoveAllChildren():AddChildFromPath(path)
		self:playcommand("Print")
	end
}