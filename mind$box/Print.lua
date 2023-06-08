
local config = mindbox.Config

mindbox.quickPrint = function(...) SCREENMAN:SystemMessage( mindbox.concat(...) ) end

mindbox.print = function(...)

	local s = mindbox.concat(...)

	if config.showTraces then s = s .. "\n\n" .. debug.traceback(2) end

	-- Format beat4sprite and song path (long).
	
	s = s:gsub("/BGAnimations/Resources/", "../")

	local song = GAMESTATE:GetCurrentSong()

	if song then

		song = song:GetSongDir():gsub( "(%p)", "%%%1" )

		s = s:gsub( song, "../SongsFolder/" )

	end

	mindbox.lastConcat = s

	local actor = mindbox.Actor
	if actor then actor:playcommand("SpawnConsole")
	else SCREENMAN:SystemMessage("mind$box: Console hasn't been created yet!") end
	
	if config.resetConfigOnPrint then mindbox.resetConfig() end

end