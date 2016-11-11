-- Created:  Thu 30 Jun 2016
-- Modified: Mon 04 Jul 2016
-- Author:   Josh Wainwright
-- Filename: menu.lua

local compl = {}
local item = ''
local itemn = 1

function os.capture(cmd)
	local cmd = cmd .. ' 2> /dev/null'
	local f = assert(io.popen(cmd, 'r'))
	local s = assert(f:read('*a'))
	f:close()
	return s
end

local highlight = function(list, n)
	local str, sep = '', ' '
	for i=1, #list do
		if  i == n then sep = '|' else sep = ' 'end
		str = str .. sep .. list[i] .. sep
	end
	vis:info(str)
end

local complete_files = function(path)
	local str = os.capture('ls -1d ' .. path .. '*')
	local compl = {}
	for file in str:gmatch('([^\n]+)\n') do
		compl[#compl+1] = file
	end
	return compl
end

local complete_cmds = function()
	local cmds = {'!', '<', '>', 'Diff', 'Fmt', 'HeaderInfo', 'MaxLine', 
		'Status', 'X', 'Y', 'a', 'bdelete', 'c', 'cd', 'd', 'e', 'earlier', 
		'g', 'help', 'i', 'langmap', 'later', 'map', 'map-window', 'new', 
		'oldfiles', 'open', 'p', 'q', 'qall', 'r', 's', 'set', 'split', 
		'unmap', 'unmap-window', 'v', 'vnew', 'vsplit', 'w', 'wq', 'x', 'y', 
		'{', '|', '}'}
	return cmds
end

local complete_opts = function()
	return {
	"autoindent", 
	"colorcolumn",
	"cursorline", 
	"expandtab", 
	"horizon", 
	"number", 
	"relativenumber", 
	"show", 
	"syntax", 
	"tabwidth", 
	"theme"
	}
end

local selectmatches = function(lst, str)
	local items = {}
	for _, item in ipairs(lst) do
		if item:sub(1, #str) == str then
			items[#items+1] = item
		end
	end
	return items
end

local tab = function(dir)
	local win = vis.win
	local line = win.file.lines[win.cursor.line]
	local cmd, args =  line:match('(:%a*) *(.*)')
	
	if win.height == 1 then
		if #item ~= #args then itemn = 0 end
		if itemn == 0 then
			if cmd == ':e' or cmd == ':r' then
				compl = complete_files(args)
			elseif cmd == ':set' then
				compl = complete_opts()
			elseif cmd == ':' then
				compl = complete_cmds()
			else
				return
			end
			compl = selectmatches(compl, args)
		end
		
		if itemn == 0 then itemn = 1 end
		item = compl[itemn]
		local del = ''
		if #item > 0 then
			del = ('<Backspace>'):rep(#args)
		end
		item = del .. item
		vis:feedkeys(item)
		itemn = (itemn + dir) % #compl
		if itemn == 0 then itemn = #compl end
		vis:info(#compl .. ' ' .. itemn .. ' ' .. table.concat(compl, ' '))
	else
		vis:feedkeys('	')
	end
end

--vis:command('map! normal ; <prompt-show>')
local prompt_show = function()
	vis:feedkeys('<prompt-show>')
	itemn = 0
	vis:map(vis.MODE_INSERT, '<Tab>', function() tab(1) end)
	vis:map(vis.MODE_INSERT, '<S-Tab>', function() tab(-1) end)
end
vis:map(vis.MODE_NORMAL, ';', prompt_show)

