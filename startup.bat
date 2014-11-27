:: Map certain folders to drive letters.
:: ---------------------------------------------------------------------------
subst r: c:\_in_out
subst h: c:\home\JoshWainwright
subst l: c:\home\JoshWainwright\TLPs


:: Remove everythin inside the "tmp" directory
:: ---------------------------------------------------------------------------
set tmpdir="c:\tmp"
del /q %tmpdir%\*
for /d %%x in (%tmpdir%\*) do @rd /s /q ^"%%x^"
mkdir %tmpdir%\jaw


:: Set flags in Testbed.ini
:: ---------------------------------------------------------------------------
set TBINI="C:\LDRA_Toolsuite\C_C++\946\TBini.exe"

%TBINI% -Section="C/C++ LDRA Testbed" SHOW_CMTOOL_MENU=TRUE
%TBINI% -Section="C/C++ LDRA Testbed" CM_TOOL_SELECTED=Git
%TBINI% -Section="Ada95 LDRA Testbed" SHOW_CMTOOL_MENU=TRUE
%TBINI% -Section="Ada95 LDRA Testbed" CM_TOOL_SELECTED=Git

%TBINI% -Section="C/C++ LDRA Testbed" REDIRECT_MAILTO=TRUE


:: Start Skype otherwise it won't start as the tmp files have been deleted
:: ---------------------------------------------------------------------------
taskkill /IM skype.exe /F
start "Skype" /B /MIN /LOW "C:\Program Files (x86)\Skype\Phone\Skype.exe"
