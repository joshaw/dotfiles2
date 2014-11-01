rem Map certain folders to drive letters.
rem ---------------------------------------------------------------------------
subst r: c:\_in_out
subst h: c:\home\JoshWainwright


rem Remove everythin inside the "tmp" directory
rem ---------------------------------------------------------------------------
set targetdir="c:\tmp"
del /q %targetdir%\*
for /d %%x in (%targetdir%\*) do @rd /s /q ^"%%x^"


rem Set flags in Testbed.ini
rem ---------------------------------------------------------------------------
set TBINI="C:\LDRA_Toolsuite\946\TBini.exe"

%TBINI% -Section="C/C++ LDRA Testbed" "SHOW_CMTOOL_MENU=TRUE"
%TBINI% -Section="C/C++ LDRA Testbed" "CM_TOOL_SELECTED=Git"
