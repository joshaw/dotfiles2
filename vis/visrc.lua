-- Created:  2016-05-09
-- Modified: Thu 14 Sep 2017
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

require('player')

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

	--local fmt = "\x1b]2;%s/[%s]\x07\n"
	--local pwd = os.getenv('PWD'):gsub(os.getenv('HOME'), '~')
	--io.write(fmt:format(pwd, vis.win.file.name or '.'))
end)

vis:map(vis.modes.NORMAL, ';', '<vis-prompt-show>')
--vis:map(vis.modes.NORMAL, 'S', '<vis-insert-newline>')
vis:map(vis.modes.NORMAL, '<C-Up>', 'ddkP')
vis:map(vis.modes.NORMAL, '<C-Down>', 'ddp')

vis:map(vis.modes.INSERT, '<C-e>', '<vis-motion-line-end>')
vis:map(vis.modes.INSERT, '<C-a>', '<vis-motion-line-start>')
vis:map(vis.modes.INSERT, '<C-Right>', '<vis-motion-word-start-next>')
vis:map(vis.modes.INSERT, '<C-Left>', '<vis-motion-word-start-prev>')

vis:option_register('makeprg', 'string', function(value)
	if not vis.win then return false end
	vis.win.makeprg = value
	vis:info('Option makeprg = ' .. tostring(vis.win.makeprg))
	return true
end, 'Set the program to run when invoking make')

vis:command_register('make', function(argv, force, win, cursor, range)
	if vis.win then vis:command('w') end
	local cmd = vis.win.makeprg or 'ninja -v'
	local tmpname = os.tmpname()
	local success = os.execute(cmd..' 2>&1 | tee '..tmpname..'; (exit ${PIPESTATUS[0]})')
	if not success then
		local f = assert(io.open(tmpname, 'r'))
		local output = f:read('*all')
		f:close()
		os.remove(tmpname)
		vis:message('')
		local win = vis.win
		win.file:delete(0, win.file.size)
		win.file:insert(0, output)
		vis.win:map(vis.modes.NORMAL, 'q', function() vis:command('q!') end)
	else
		vis:feedkeys('<vis-redraw>')
		vis:info('Exit success: '..cmd)
	end
end, 'Run the command specified by makeprg (defaults to make)')

vis:map(vis.modes.NORMAL, '<F5>', function()
	vis:command('make')
end, 'Run make in current directory')

vis:map(vis.modes.NORMAL, '[ ', function()
	for i=1, (vis.count or 1) do
		vis:feedkeys('<vis-mark>am<vis-motion-line-begin><vis-insert-newline><vis-mark>aM')
	end
end, 'Insert newline above current line')

vis:map(vis.modes.NORMAL, '] ', function()
	for i=1, (vis.count or 1) do
		vis:feedkeys('<vis-mark>am<vis-motion-line-end><vis-insert-newline><vis-mark>aM')
	end
end, 'Insert newline below current line')

vis:operator_new('g?', function(file, range, pos)
	local rot13 = {
		a='n', b='o', c='p', d='q', e='r', f='s', g='t', h='u', i='v', j='w', 
		k='x', l='y', m='z', n='a', o='b', p='c', q='d', r='e', s='f', t='g', 
		u='h', v='i', w='j', x='k', y='l', z='m',
		A='N', B='O', C='P', D='Q', E='R', F='S', G='T', H='U', I='V', J='W', 
		K='X', L='Y', M='Z', N='A', O='B', P='C', Q='D', R='E', S='F', T='G', 
		U='H', V='I', W='J', X='K', Y='L', Z='M',
	}
	local text = file:content(range)
	text = text:gsub('%a', function(l) return rot13[l] end)
	file:delete(range)
	file:insert(range.start, text)
	return range.start
end, 'Perform a rot13 transform')

vis:command_register('setf', function(argv, force, win, cursor, range)
	vis:command('set syntax ' .. (argv[1] or ''))
end, 'Alias for set syntax ...')

vis:command_register('MaxLine', function(argv, force, win, cursor, range)
	local line
	local length_max = 0
	local lnum = 0

	win.selection.pos = range.start
	local start = win.selection.line
	win.selection.pos = range.finish
	local finish = win.selection.line
	
	for line in win.file:lines_iterator() do
		lnum = lnum + 1
		if lnum > start and lnum < finish then
			if force then
				line = line:gsub('\t', '    ')
			end
			if #line > length_max then
				length_max = #line
				maxl = lnum
			end
		end
	end
	vis:info(('Max line is %i (%i chars)'):format(maxl, length_max))
	win.selection:to(maxl, 1)
end, 'Find the longest line in the current file')

vis:command_register('pwd', function(argv, force, win, cursor, range)
	vis:info(('%s/[%s]'):format(win.file.path, win.file.name))
end, 'Display present working directory and filename')
