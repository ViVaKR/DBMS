@echo off
setlocal

set Y=%date:~0,4%
set M=%date:~5,2%
set D=%date:~8,2%

sqlcmd -E -Q "Backup Database BJ_DB TO DISK='D:\DataBase\BJ_DB_%Y%-%M%-%D%.bak'"
exit


@REM [내용]
@REM BJ_DB를 파일뒤에 년_월_일.bak 확장자를 붙여서 일일 백업하는 내용 --- 
@REM 위 내용을 .bat 로 만들어 저장한 다음 윈도우 예약 관리에서 배치 파일을 매일 실행하도록 하면 됩니다.

@REM 만일 1433 포트가 아닌 다른 포트를 사용한다면 아래와 같이
@REM     sqlcmd -S 127.0.0.1,3433 -Q   "Backup Database BJ_DB TO DISK='D:\DataBase\BJ_DB_%Y%-%M%-%D%.bak'"

@REM 원격지 서버 접속 방법은 아래와 같이
@REM     sqlcmd -S 211.49.99.48,1433  -U  아이디 -P 비밀번호   (엔터)
