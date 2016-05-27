-- Created:  Thu 26 May 2016
-- Modified: Thu 26 May 2016
-- Author:   Josh Wainwright
-- Filename: comment.lua

local dict = {
	bash = '#',
	c = '//',
	conf = '#',
	cpp = '//',
	dosbatch = '::',
	dot = '//',
	gitconfig = '#',
	gnuplot = '#',
	haskell = '--',
	java = '//',
	lua = '--',
	mail = '> ',
	make = '#',
	markdown = '<!--',
	perl = '#',
	python = '#',
	ruby = '#',
	sh = '#',
	tex = '%',
	vim = '"',
	zsh = '#',
}

local toggle_comment = function(win)
	local syntax = win.syntax
	local com_char = dict[syntax]
	if com_char ~= nil then
		local line = win.cursor.line
		win.file.lines[line] = com_char  .. ' ' .. win.file.lines[line]
		vis:feedkeys('<editor-redraw>')
	else
		vis:info(syntax .. ': no comment char')
	end
end

vis:map(vis.MODE_NORMAL, 'gcc', function() toggle_comment(vis.win) end)
