-- Created:  2016-05-17
-- Modified: Thu 15 Sep 2016
-- Author:   Josh Wainwright
-- Filename: diff_orig.lua

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
	local f = assert(io.popen(diff_cmd, 'r'))
	local diff_out = assert(f:read('*a'))
	f:close()

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
