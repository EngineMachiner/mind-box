
-- I'll add a .txt file to save configs later.

local defaults = {
	showChildren = false,   showIndexes = false, showTraces = false,
	showObjectID = true,	showFading = true,
	resetConfigOnPrint = true
}

mindbox.Config = { Defaults = defaults }

-- You can either drop fonts in mindbox's font folder or add a path in the 'custom' value.
mindbox.Theme = {
    Graphic = 1,    Font = { Index = 1,     randomColor = false,	custom = false } 
}