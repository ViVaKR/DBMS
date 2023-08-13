@echo off
setlocal

set Y=%date:~0,4%
set M=%date:~5,2%
set D=%date:~8,2%

set destination="C:\Temp\"

if exist %destination% (
sqlcmd -E -Q "Backup Database <DB Name> TO DISK='%destination%\BJ_DB_%Y%-%M%-%D%.bak'"
rem xcopy %source% %destination% /Y/D:%M%-%D%-%Y%
) else (
mkdir %destination%
sqlcmd -E -Q "Backup Database <DB Name> TO DISK='%destination%\BJ_DB_%Y%-%M%-%D%.bak'"
rem xcopy %source% %destination% /Y/D:%M%-%D%-%Y%
)
