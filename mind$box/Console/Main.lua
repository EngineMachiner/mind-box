return Def.ActorFrame{
	Name="mindbox-Console",
	mindboxConsoleInitMessageCommand=function(self)

		self:RemoveAllChildren()

		local screen = SCREENMAN:GetTopScreen()
		local oldLim = mindbox.Lim		mindbox.Lim = 40
		
		self:AddChildFromPath(mindbox.Path .. "Console/Core.lua")
		self:queuecommand("Print")

		mindbox.Lim = oldLim

	end
}