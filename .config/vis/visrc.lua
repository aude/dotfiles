-- load standard vis module, providing parts of the Lua API
require('vis')

vis.events.subscribe(vis.events.INIT, function()
	-- Your global configuration options
	vis:command('set autoindent on')
	vis:command('set tabwidth 8')
	vis:command('set theme solarized')
end)

vis.events.subscribe(vis.events.WIN_OPEN, function(win)
	-- Your per window configuration options e.g.
	-- vis:command('set number')
	vis:command('set show-tabs on')
end)
