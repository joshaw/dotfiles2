-- Created:  2016-05-09
-- Modified: Fri 01 Jul 2016
-- Author:   Josh Wainwright
-- Filename: visrc.lua

-- load standard vis module, providing parts of the Lua API
require('vis')

require('navd_p')
require('tag_jump')
reg_save = require('reg_save')
require('fmt_tabs')
require('statusline')
header_info = require('header_info')
require('diff_orig')
require('toggle')
require('comment')
require('menu')

vis.events.win_open = function(win)
	-- enable syntax highlighting for known file types
	vis.filetype_detect(win)

	vis:command('set theme molokai')
	vis:command('set number')
	vis:command('set tabwidth 4')
	vis:command('set autoindent')
	vis:command('set colorcolumn 80')
	vis:command('set show tabs')

	reg_save.restore(win)
	header_info.update(win)
	local fmt = "\x1b]2;%s/[%s]\x07"
	print(fmt:format(os.getenv('PWD'), win.file.name or '.'))
end

vis.events.win_close = function(win)
	reg_save.save(win)
end

--vis:command('map! normal j <cursor-screenline-down>')
vis:command('map! normal k <cursor-screenline-up>')
vis:command('map! normal S <insert-newline>')
vis:command('map! normal "[ " 0<insert-newline>')
vis:command('map! normal "] " $l<insert-newline>k')
vis:command('map! normal <C-Up> ddkP')
vis:command('map! normal <C-Down> ddp')

vis:command('map! insert <C-e> <cursor-line-end>')
vis:command('map! insert <C-a> <cursor-line-start>')
vis:command('map! insert <C-Right> <cursor-word-start-next>')
vis:command('map! insert <C-Left> <cursor-word-start-prev>')

vis:map(vis.MODE_NORMAL, '<F5>', function()
	vis:command('w')
	os.execute('make')
end)

local maxline = function(win, force)
	local line
	local max = 0
	local cnt = 1
	for line in win.file:lines_iterator() do
		if force then
			line = line:gsub('\t', '    ')
		end
		if #line > max then
			max = #line
			maxl = cnt
		end
		cnt = cnt + 1
	end
	vis:info('Max line is line ' .. maxl .. ' (' .. max .. ' chars)')
	win.cursor:to(maxl, 1)
end

vis:command_register('MaxLine', function(argv, force, win, cursor, range)
	maxline(win, force)
end)
