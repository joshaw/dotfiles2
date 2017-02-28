-- Created:  2016-05-09
-- Modified: Tue 28 Feb 2017
-- Author:   Josh Wainwright
-- Filename: visrc.lua

-- load standard vis module, providing parts of the Lua API
require('vis')

require('navd_p')
require('tag_jump')
require('reg_save')
require('fmt_tabs')
require('statusline')
require('header_info')
require('diff_orig')
require('toggle')
require('comment')
require('git-lp')
require('complete')

vis.events.subscribe(vis.events.INIT, function()
	-- enable syntax highlighting for known file types
	require('plugins/filetype')

	vis:command('set theme molokai')
	vis:command('set escdelay 10')
end)

vis.events.subscribe(vis.events.WIN_OPEN, function(win)
	vis:command('set number on')
	vis:command('set tabwidth 4')
	vis:command('set autoindent on')
	vis:command('set colorcolumn 80')
	vis:command('set show-tabs on')

	local fmt = "\x1b]2;%s/[%s]\x07\n"
	local pwd = os.getenv('PWD'):gsub(os.getenv('HOME'), '~')
	io.write(fmt:format(pwd, vis.win.file.name or '.'))
end)

vis:map(vis.modes.NORMAL, ';', '<vis-prompt-show>')
vis:map(vis.modes.NORMAL, 'S', '<vis-insert-newline>')
vis:map(vis.modes.NORMAL, '<C-Up>', 'ddkP')
vis:map(vis.modes.NORMAL, '<C-Down>', 'ddp')

vis:map(vis.modes.INSERT, '<C-e>', '<vis-motion-line-end>')
vis:map(vis.modes.INSERT, '<C-a>', '<vis-motion-line-start>')
vis:map(vis.modes.INSERT, '<C-Right>', '<vis-motion-word-start-next>')
vis:map(vis.modes.INSERT, '<C-Left>', '<vis-motion-word-start-prev>')

vis:map(vis.modes.NORMAL, '<F5>', function()
	vis:command('w')
	local cmd = 'make -s'
	local success = os.execute(cmd..' 2>&1 | tee /tmp/jaw/vis-make-output; (exit ${PIPESTATUS[0]})')
	if not success then
		local f = io.open('/tmp/jaw/vis-make-output', 'r')
		local output = f:read('*all')
		vis:message(output)
		vis.win:map(vis.modes.NORMAL, 'q', function() vis:command('q!') end)
	else
		vis:feedkeys('<vis-redraw>')
	end
end, 'Run make in current directory')

vis:map(vis.modes.NORMAL, '[ ', function()
	for i=1, (vis.count or 1) do
		vis:feedkeys('<vis-mark-set>a<vis-motion-line-begin><vis-insert-newline><vis-mark-goto>a')
	end
end, 'Insert newline above current line')

vis:map(vis.modes.NORMAL, '] ', function()
	for i=1, (vis.count or 1) do
		vis:feedkeys('<vis-mark-set>a<vis-motion-line-end><vis-insert-newline><vis-mark-goto>a')
	end
end, 'Insert newline below current line')

vis:command_register('setf', function(argv, force, win, cursor, range)
	vis:command('set syntax ' .. argv[1])
end, 'Alias for set syntax ...')

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
end, 'Find the longest line in the current file')


vis:command_register('pwd', function(argv, force, win, cursor, range)
	vis:info(win.file.name)
end)
