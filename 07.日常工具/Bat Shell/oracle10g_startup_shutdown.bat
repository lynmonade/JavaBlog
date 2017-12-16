rem 必须在管理员权限下运行

@ECHO OFF
for /f "skip=3 tokens=4" %%i in ('sc query OracleServiceORCL') do set "zt=%%i" &goto :next
:next          
if /i "%zt%"=="RUNNING" (
ECHO Stoping OracleService, please wait ...
net stop OracleDBConsoleorcl
net stop OracleJobSChedulerORCL
net stop OracleOraDb10g_home1iSQL*Plus
net stop OracleOraDb10g_home1TNSListener
net stop OracleServiceORCL

net stop OracleVssWriterORCL
net stop OracleMTSRecoveryService

)else (
ECHO Starting OracleService, please wait ...
net start OracleDBConsoleorcl
net start OracleJobSChedulerORCL
net start OracleOraDb10g_home1iSQL*Plus
net start OracleOraDb10g_home1TNSListener
net start OracleServiceORCL

net start OracleVssWriterORCL
net start OracleMTSRecoveryService
)          
pause         
exit 