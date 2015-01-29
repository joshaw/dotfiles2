::
:: Map certain folders to drive letters. {{{1
::
subst r: c:\_in_out
subst h: c:\home\JoshWainwright
subst l: c:\home\JoshWainwright\Resources

::
:: Remove everythin inside the "tmp" directory {{{1
::
set tmpdir="c:\tmp"
del /q %tmpdir%\*
for /d %%x in (%tmpdir%\*) do @rd /s /q ^"%%x^"
mkdir %tmpdir%\jaw

::
:: Set flags in Testbed.ini {{{1
::
set TBINI="C:\LDRA_Toolsuite\C_C++\946\TBini.exe"
for %%x in (
	"C/C++ LDRA Testbed"
	"Ada95 LDRA Testbed"
	) do (
	%TBINI% -Section=%%x SHOW_CMTOOL_MENU=TRUE
	%TBINI% -Section=%%x CM_TOOL_SELECTED=Git

	%TBINI% -Section=%%x REDIRECT_MAILTO=TRUE

	%TBINI% -Section=%%x TBBROWSE_HTML_FONT_SIZE=2
)

::
:: Start Skype otherwise it won't start as the tmp files have been deleted {{{1
::
taskkill /IM skype.exe /F
start "Skype" /B /MIN /LOW "C:\Program Files (x86)\Skype\Phone\Skype.exe"
