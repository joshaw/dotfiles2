-- Created:  Mon 16 May 2016
-- Modified: Thu 08 Dec 2016
-- Author:   Josh Wainwright
-- Filename: navd_p.lua

-- Open navd window
vis.navd = function(path, search)
	if vis.win.file.name and vis.win.file.modified then
		vis:info('No write since last change')
		return
	end
	local fname = vis.win.file.name
	if not path then
		path = vis.dirname(os.getenv('PWD') .. '/' .. (fname or ''))
		path = vis.dirname(vis.win.file.path)
	end
	path = path:gsub('/+', '/')
	if not search then
		search = ""
		if fname then
			search = vis.basename(fname)
		end
	end

	local lscmd = 'ls -1 -A -p -b --group-directories-first "' .. path .. '"'
	local f = assert(io.popen(lscmd, 'r'))
	local list = assert(f:read('*a'))
	f:close()
	list = list:gsub('\\ ', ' ')
	list = '# ' .. path .. '\n' .. list
	
	vis:message('')
	vis:feedkeys('ggdG')
	vis:message(list)
	--vis:command('set syntax navd')
	--vis:feedkeys('dggj')
	vis:feedkeys('/' .. search .. '<Enter>')
	local win = vis.win

	win:map(vis.modes.NORMAL, '<Enter>', function()
		local line = win.file.lines[win.cursor.line]
		local file = path .. '/' .. line
		if line:sub(1,1) == '#' then return end
		if line:sub(-1) == '/' then
			vis.navd(file)
		else
			vis:feedkeys(':q<Enter>')
			vis:feedkeys(':e ' .. file .. '<Enter>')
		end
	end)

	win:map(vis.modes.NORMAL, '-', function()
		local path = win.file.lines[1]:gsub('^# ', ''):gsub('/$', '')
		local search = vis.basename(path)
		local path = vis.dirname(path) .. '/'
		vis.navd(path, search)
	end)

	win:map(vis.modes.NORMAL, 'q', function()
		vis:feedkeys(':q<Enter>')
	end)

	win:map(vis.modes.NORMAL, 'gh', function()
		vis.navd(os.getenv('HOME'))
	end)
end

vis.basename = function(path)
	if path:sub(-1,-1) == '/' then
		path = path:sub(1, -2)
	end
	local sl = path:reverse():find('/', 1, true)
	if not sl then
		return path
	end
	sl = path:len() - sl + 2
	return path:sub(sl)
end

vis.dirname = function(path)
	if path:sub(-1,-1) == '/' then
		return path:sub(1,-2)
	end
	local sl = path:reverse():find('/', 1, true)
	if not sl then
		return path
	end
	sl = path:len() - sl
	return path:sub(1, sl)
end

vis:map(vis.modes.NORMAL, '-', vis.navd)
