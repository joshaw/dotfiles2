::
:: Map certain folders to drive letters. {{{1
::
subst h: c:\home\JoshWainwright
subst l: c:\home\JoshWainwright\Resources

::
:: Remove everything inside the "tmp" directory {{{1
::
set tmpdir="c:\tmp"
del /q %tmpdir%\*
for /d %%x in (%tmpdir%\*) do @rd /s /q ^"%%x^"
mkdir %tmpdir%\jaw

start C:\home\JoshWainwright\Tools\TextEditorAnywhere\TextEditorAnywhere.exe

::
:: Is weekday? {{{1
:: The following tests the day of the week so that commands are only run on
:: weekdays
::
set path=c:\Windows\System32\wbem;%PATH%
SETLOCAL enabledelayedexpansion
SET /a count=0
FOR /F "skip=1" %%D IN ('wmic path win32_localtime get dayofweek') DO (
	if "!count!" GTR "0" GOTO next
	set dow=%%D
	SET /a count+=1
)
:next
if "%dow%" GEQ "6" GOTO:eof

::
:: Set flags in Testbed.ini {{{1
::
set TBINI="C:\LDRA_Toolsuite\C_C++\954\TBini.exe"
for %%x in (
	"C/C++ LDRA Testbed"
	"Ada95 LDRA Testbed"
	) do (
	%TBINI% -Section=%%x SHOW_CMTOOL_MENU=TRUE
	%TBINI% -Section=%%x CM_TOOL_SELECTED=Git

	%TBINI% -Section=%%x REDIRECT_MAILTO=TRUE

	%TBINI% -Section=%%x TBBROWSE_HTML_FONT_SIZE=2
	%TBINI% -Section=%%x USE_DEFAULT_HTML_BROWSER=TRUE
	%TBINI% -Section=%%x SOURCE_CODE_BROWSER="C:\Program Files (x86)\vim\vim74\gvim.exe" %1 %2
	%TBINI% -Section=%%x BROWSE_FILE_AT_LINE_ARG_FORMAT=" +%d"
	%TBINI% -Section=%%x TBRUN_COLOURED_GUI=TRUE
)

::
:: Run vim to log times {{{1
::
"C:\Program Files (x86)\vim\vim74\gvim.exe" "C:\home\JoshWainwright\Documents\Details\times\times.txt"
::
:: Start Skype otherwise it won't start as the tmp files have been deleted {{{1
::
taskkill /IM skype.exe /F
start "Skype" /B /MIN /LOW "C:\Program Files (x86)\Skype\Phone\Skype.exe"
