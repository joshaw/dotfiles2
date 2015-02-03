:: Is weekday?
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
:: Run vim to log times
::
"C:\Program Files (x86)\vim\vim74\gvim.exe" "C:\home\JoshWainwright\Documents\Details\times.txt" -c "wq"
