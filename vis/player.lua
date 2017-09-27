-- Created:  Fri 08 Sep 2017
-- Modified: Mon 11 Sep 2017
-- Author:   Josh Wainwright
-- Filename: /cygdrive/c/home/JoshWainwright/.dotfiles/vis/player.lua

-- TODO

local lfs = require('lfs')
local file_handle

function table.slice(tbl, first, last, step)
	local sliced = {}
	for i=(first or 1), (last or #tbl), (step or 1) do
		sliced[#sliced+1] = tbl[i]
	end
	return sliced
end

local function send(cmd)
	if file_handle then
		vis:info(cmd)
		file_handle:write(cmd, '\n'):flush()
	else
		vis:info('error: mpv not running')
	end
end

local function play(file, append)
	if type(file) == 'table' then
		play(file[1])
		for i=2, #file do
			play(file[i], true)
		end
	else
		local append_str = append and ' append' or ''
		local cmd = 'loadfile "'..file..'"'..append_str
		send(cmd)
	end
end

local function get_listing()

	vis:info('Get Listing')
	lfs.chdir(os.getenv('PWD'))
	local files = {files={}, dirs={}}
	for f in lfs.dir('.') do
		if not (f == '.' or f == '..') then
			local mode = lfs.attributes(f, 'mode')
			if mode == 'file' then
				files.files[#files.files+1] = f
			elseif mode == 'directory' then
				files.dirs[#files.dirs+1] = f
			end
		end
	end
	return files
end

local function player()
	local win = vis.win
	local list = get_listing()
	local list_str = table.concat(list.dirs, '/\n') .. table.concat(list.files, '\n')

	win.file:delete(0, vis.win.file.size)
	win.file:insert(0, list_str)
	win.selection.pos = 0

	local cmd = 'mpv --idle --really-quiet --input-terminal=no --input-file=/dev/stdin'
	vis:info(cmd)
	file_handle = io.popen(cmd, 'w')

	send('set loop-playlist inf')

	win:map(vis.modes.NORMAL, '<Enter>', function()
		local file = win.file.lines[win.selection.line]
		play(file)
	end)

	win:map(vis.modes.NORMAL, '<Enter>', function()
		local list = table.slice(win.file.lines, win.selection.line)
		play(list)
	end)

	win:map(vis.modes.NORMAL, 'p', function() send('cycle pause') end)

	win:map(vis.modes.NORMAL, '.', function() send('seek 10 relative') end)
	win:map(vis.modes.NORMAL, ',', function() send('seek -10 relative') end)
	win:map(vis.modes.NORMAL, '>', function() send('playlist-next ') end)
	win:map(vis.modes.NORMAL, '<', function() send('playlist-prev ') end)

	win:map(vis.modes.NORMAL, 'q', function()
		send('quit')
		vis:exit(0)
	end)
end

vis:command_register('Player', function(argv, force, win, selection, range)
	player()
end)
