rem 必须在管理员权限下运行

@ECHO OFF
for /f "skip=3 tokens=4" %%i in ('sc query OracleServiceORCL') do set "zt=%%i" &goto :next
:next          
if /i "%zt%"=="RUNNING" (
ECHO Stoping OracleService, please wait ...
net stop OracleVssWriterORCL
net stop OracleDBConsoleorcl
rem net stop OracleMTSRecoveryService
rem net stop OracleOraDb11g_home1ClrAgent
net stop OracleOraDb11g_home1TNSListener
net stop OracleServiceORCL
)else (
ECHO Starting OracleService, please wait ...
net start OracleVssWriterORCL
net start OracleDBConsoleorcl
rem net start OracleMTSRecoveryService
rem net start OracleOraDb11g_home1ClrAgent
net start OracleOraDb11g_home1TNSListener
net start OracleServiceORCL
)          
pause         
exit 