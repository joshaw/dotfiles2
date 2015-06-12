" Created:  Mon 27 Apr 2015
" Modified: Fri 12 Jun 2015
" Author:   Josh Wainwright
" Filename: weeklyr.vim

function! DateOnFri(sep)
python << EOP
import vim, datetime as dt
t = dt.date.today()
f = t + dt.timedelta((4 - t.weekday()) % 7)
sep = vim.eval('a:sep')
f = str(f.strftime('%Y{0}%m{0}%d'.format(sep)))
vim.command('let date = \'%s\'' % f)
EOP
return date
endfunction

function! weeklyr#EditReport(monthly, retval, ...)
	let suffix = ''
	" a:0 (number of args) is >0 if a specific date is given
	if a:0 > 0
		let date = a:1
		if a:monthly
			let suffix = 'MonthlyJAW'
		endif
	" Otherwise get the relevant current date
	else
		if a:monthly
			let date = strftime("%Y%m")
			let suffix = 'MonthlyJAW'
		else
			"let date = system("echo -n `date -d Fri '+%Y%m%d'`")
			let date = DateOnFri('')
		endif
	endif
	let thisweek = '$HOME/Documents/Forms/WeeklyReports/'.date.suffix
	if filereadable(expand(thisweek).'.md')
		if a:retval
			return thisweek.".md"
		else
			exec "edit ".thisweek.".md"
		endif
	elseif filereadable(expand(thisweek).'.txt')
		if a:retval
			return thisweek.".txt"
		else
			exec "edit ".thisweek.".txt"
		endif
	else
		if a:retval
			echoerr "Report file for ".thisweek." not found."
		else
			exec "edit ".thisweek . ".md | normal iWeeklyr"
		endif
	endif
endfunction
