" Created:  Mon 27 Apr 2015
" Modified: Mon 27 Apr 2015
" Author:   Josh Wainwright
" Filename: weeklyr.vim

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
			let date = system("echo -n `date '+%Y%m'`")
			let suffix = 'MonthlyJAW'
		else
			let date = system("echo -n `date -d Fri '+%Y%m%d'`")
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
