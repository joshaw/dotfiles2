-- Created:  Wed 07 Dec 2016
-- Modified: Fri 16 Dec 2016
-- Author:   Josh Wainwright
-- Filename: git-lp.lua

local function capture(cmd)
	local f = assert(io.popen(cmd, 'r'))
	local s = assert(f:read('*a'))
	f:close()
	return s
end

commits = nil
x = 1

local function gitlp()
	if not commits then
		local com_str = capture('git rev-list master')
		commits = {}
		for i in com_str:gmatch('[^\n]+') do
			commits[#commits+1] = i
		end
		vis:info('Total commits: ' .. #commits)
		
		if #commits == 0 then
			vis:info('Not a git repository')
			return
		end
	end

	local c = x .. ' ' .. capture('git show --no-color ' .. commits[x])

	vis:command('e! gitlp')
	vis.win.file:delete(0, vis.win.file.size)
	vis.win.file:insert(0, c)
	vis.win.syntax = 'diff'
	vis.win.cursor:to(1,1)

	vis.win:map(vis.modes.NORMAL, 'l', function()
		x = x + 1
		if x > #commits then x = #commits; return end
		gitlp()
	end)
	vis.win:map(vis.modes.NORMAL, 'h', function()
		x = x - 1
		if x < 1 then x = 1; return end
		gitlp()
	end)
	vis.win:map(vis.modes.NORMAL, 'gg', function()
		x = 1
		gitlp()
	end)
	vis.win:map(vis.modes.NORMAL, 'G', function()
		x = #commits
		gitlp()
	end)
	vis.win:map(vis.modes.NORMAL, 'q', function()
		vis:command('q!')
	end)
end

vis:command_register('GitLP', function(argv, force, win, cursor, range)
	gitlp()
end)
