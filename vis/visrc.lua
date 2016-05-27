-- Created:  2016-05-09
-- Modified: Thu 26 May 2016
-- Author:   Josh Wainwright
-- Filename: visrc.lua

-- load standard vis module, providing parts of the Lua API
require('vis')

require('utils')
require('navd_p')
require('tag_jump')
reg_save = require('reg_save')
require('fmt_tabs')
require('statusline')
header_info = require('header_info')
require('diff_orig')
fs = require('fs')
require('toggle')
require('comment')

vis.pwd = os.getenv('PWD') .. '/'

vis.events.win_open = function(win)
	-- enable syntax highlighting for known file types
	vis.filetype_detect(win)
	fname = win.file.name or '.'
	local dir
	if fname:sub(1, 1) == '/' then
		dir = fname
	else
		dir = vis.pwd .. '/' .. fname
	end
	vis.cwd = os.capture('dirname ' .. dir) .. '/'

	vis:command('set theme molokai')
	vis:command('set number')
	vis:command('set tabwidth 4')
	vis:command('set autoindent')
	vis:command('set colorcolumn 80')
	vis:command('set show tabs')

	user_keybindings(win)
	reg_save.restore(win)
	header_info.update(win)
end

vis.events.win_close = function(win)
	reg_save.save(win)
end

user_keybindings = function(win)
	vis:command('map! normal ; <prompt-show>')
	vis:command('map! normal j <cursor-screenline-down>')
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

	vis:map(vis.MODE_NORMAL, '<C-]>', jump_tag)
end
