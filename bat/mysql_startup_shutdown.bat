@echo off
for /f "skip=3 tokens=4" %%i in ('sc query MySQL56') do set "zt=%%i" &goto :next

:next
if /i "%zt%"=="RUNNING" (
echo shutdown mysql......
net stop MySQL56
) else (
echo startup MySQL56.....
net start MySQL56
)
exit
pause
