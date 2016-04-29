-- load standard vis module, providing parts of the Lua API
require('vis')
require("utils")

vis.events.win_open = function(win)
	-- enable syntax highlighting for known file types
	vis.filetype_detect(win)

	vis:command('set theme molokai')
	vis:command('set number')
	vis:command('set tabwidth 4')
	vis:command('set autoindent')
	vis:command('set colorcolumn 80')

	user_keybindings(win)
	statusline(win)
end

user_keybindings = function(win)
	vis:command('map! normal ; <prompt-show>')
	vis:command('map! normal S <insert-newline>')
	vis:command('map! normal "[ " 0<insert-newline>')
	vis:command('map! normal "] " $l<insert-newline>k')
	vis:command('map! normal <C-Up> ddkP')
	vis:command('map! normal <C-Down> ddp')

	vis:map(vis.MODE_NORMAL, "Q", function()
		statusline(vis.win)
	end)
	vis:map(vis.MODE_NORMAL, "K", function()
		navd(vis.win)
	end)
end

navd = function(win)
	local f = io.popen('ls -1', 'r')
	local list = f:read('*a')
	--vis:command('e empty.txt')
	--append(win, 0, list)
	vis:message(list)
end

statusline = function(win)
	local mode = ""
	if vis.mode == vis.MODE_INSERT then
		mode = "--INSERT-- "
	elseif vis.mode == vis.MODE_REPLACE then
		mode = "--REPLACE-- "
	elseif vis.mode == vis.MODE_VISUAL then
		mode = "--VISUAL-- "
	elseif vis.mode == vis.MODE_VISUAL_LINE then
		mode = "--VISUAL LINE-- "
	end

	local columns = os.capture("tput cols")
	local lines = os.capture("tput lines")

	stl = string.format("%s%s %s %s %s %i(%i), %i  %i%% %s",
			mode,
			win.file.name or "[No Name]",
			win.syntax or "",
			win.file.newlines,
			human_bytes(win.file.size or 0) .. "",
			win.cursor.line,
			#win.file.lines,
			win.cursor.col,
			math.ceil(win.cursor.pos/(win.file.size + 1)*100),
			columns .. '|' .. lines
		)
	vis:info(stl)
end

function human_bytes(bytes)
	if bytes <= 0 then
		return ""
	end
	local n = 1
	while bytes >= 1024 do
		n = n + 1
		bytes = bytes / 1024
	end
	local s = {'B', 'KB', 'MB'}
	return string.format("%.2f", bytes) .. s[n]
end
