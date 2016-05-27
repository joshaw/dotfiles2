-- Created:  2016-05-17
-- Modified: Thu 26 May 2016
-- Author:   Josh Wainwright
-- Filename: diff_orig.lua

--require('utils')

diff_orig = function(win)
	local fname = win.file.name
	if not fname then return end
	local a = win.file:content(0, win.file.size)
	local tmpname = os.tmpname()
	local tmp = assert(io.open(tmpname, 'w'))
	tmp:write(a)
	tmp:close()

	local diff_exe = 'diff -u '
	local diff_cmd = string.format('%s %s %s', diff_exe, fname, tmpname)
	local diff_out = os.capture(diff_cmd)
	os.remove(tmpname)
	if diff_out == '' then
		vis:info('No difference')
		return
	end
	vis:message(diff_out)
	vis:feedkeys('dgg')
	vis:command('set syntax diff')
end

vis:command_register('Diff', function() diff_orig(vis.win) end)
