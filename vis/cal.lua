-- Created:  Tue 24 May 2016
-- Modified: Tue 24 May 2016
-- Author:   Josh Wainwright
-- Filename: cal.lua

local TRANS_YEAR = 1752
local TRANS_MONTH = 8 -- September
local TRANS_DAY = 2

local center = function(width, str)
	local width = (width - str:len()) / 2
	return string.rep(' ', width) .. str
end

local isleap = function(year, cal)
	if cal == 'GREGORIAN' then
		if year % 400 == 0 then
			return 1
		elseif year % 100 == 0 then
			return 0
		end
		return (year % 4 == 0)
	else -- cal == 'JULIAN'
		return (year % 4 == 0)
	end
end

local monthlength = function(year, month, cal)
	local mdays = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}
	if month == 1 and isleap(year, cal) then
		return 29
	else
		return mdays[month-1]
	end
end

local dayofweek = function(year, month, dom, cal)
	local a = (13 - month) / 12
	local y = year - a
	local m = month + 12 * a - 1
	
	if cal == 'GREGORIAN' then
		return (dom + y + y/4 - y/100 + y/400 + (31*m)/12) % 7
	else -- cal == 'JULIAN'
		return (5 + dom + y + y/4 + (31*m)/12) % 7
	end
end

local getgrid = function(year, month, line)
	local ret = ''
	local cal
	if year < TRANS_YEAR or year == TRANS_YEAR and month <= TRANS_MONTH then
		cal = 'JULIAN'
	else
		cal = 'GREGORIAN'
	end
	local offset = dayofweek(year, month, 1, cal) - 1
	if offset < 0 then
		offset = offset + 7
	end
	
	local d = 0
	if line == 1 then
		while d < offset do
			ret = ret .. '   '
			d = d + 1
		end
		dom = 1
	else
		dom = 8 - offset + (line - 2) * 7
		if trans then
			dom = dom + 11
		end
	end
	
	local thismonth = (year == os.date('%Y') and month+1 == os.date('%m'))
	while d < 7 and dom <= monthlength(year, month, cal) do
		if thismonth and dom == os.date('%d') then
			ret = ret .. string.format('%2d|', dom)
		else
			ret = ret .. string.format('%2d ', dom)
		end
		if trans and dom == TRANS_DAY then
			dom = dom + 11
		end
		d = d + 1
		dom = dom + 1
	end
	
	while d < 7 do
		ret = ret .. '   '
		d = d + 1
	end
	
	return ret
end

local getcal = function(year, month, showyear)
	local cal = {}
	local smon = {'January', 'February', 'March', 'April', 'May', 'June',
		'July', 'August', 'September', 'October', 'November', 'December'}
	local days = {'Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'}
	
	month = (month % 12) + 1
	local mon_name = smon[month] .. (showyear and ' ' .. year)
	local mon_line = center(20, mon_name)
	table.insert(cal, string.format('%-21s', mon_line))
	
	local dow = 1
	local line = ''
	while dow < (1 + 7) do
		line = line .. days[(dow % 7) + 1] .. ' '
		dow = dow + 1
	end
	table.insert(cal, line)
	
	line = 1
	while line <= 6 do
		table.insert(cal, getgrid(year, month, line))
		line = line + 1
	end
	return cal
end

for n=1, 12 do
	for i, line in ipairs(getcal(2016, n, true)) do
		print(line)
	end
end
