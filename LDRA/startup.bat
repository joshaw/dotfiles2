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
:: Is workday? {{{1
::
set /p workday= "Work day? [Y/n] "
if %workday% == n GOTO:eof

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
	%TBINI% -Section=%%x TBRUN_COLOURED_GUI=TRUE
)

::
:: Run vim to log times {{{1
::
"C:\Program Files (x86)\vim\vim74\gvim.exe" "C:\home\JoshWainwright\Documents\Details\times\times.txt"

::
:: Start Skype otherwise it won't start as the tmp files have been deleted {{{1
::
::taskkill /IM skype.exe /F
::start "Skype" /B /MIN /LOW "C:\Program Files (x86)\Skype\Phone\Skype.exe"
