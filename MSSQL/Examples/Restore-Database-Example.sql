sp_databases
GO

RESTORE FileListOnly from disk = '/var/opt/mssql/backup/adventure.bak'

use Works
GO
SELECT * FROM sys.database_files

USE [master]
GO
ALTER DATABASE [Works] SET AUTO_CLOSE OFF WITH NO_WAIT
GO

-- (1) 다른 데이터베이스 백업 파일로 복원하기
-- (2) 백업파일에서 Logical Name 을 가져오기
    RESTORE FileListOnly from DISK = '/var/opt/mssql/backup/adventure.bak'
-- (3)복원
USE master
go
ALTER DATABASE Works Set single_user with ROLLBACK IMMEDIATE;
RESTORE DATABASE Works   
   FROM DISK = '/var/opt/mssql/backup/adventure.bak'
   WITH  RECOVERY,
   MOVE 'AdventureWorksLT2012_Data' TO '/var/opt/mssql/data/Works.mdf',   
   MOVE 'AdventureWorksLT2012_Log' TO '/var/opt/mssql/data/Works_log.ldf',
   REPLACE
GO

ALTER DATABASE Works SET MULTI_USER;
go

USE master
GO
IF NOT EXISTS (
 SELECT name
 FROM sys.databases
 WHERE name = N'Works'
)
 CREATE DATABASE [Works];
GO
IF SERVERPROPERTY('ProductVersion') > '12'
 ALTER DATABASE [Works] SET QUERY_STORE=ON;
GO

use master;
alter database Works set recovery full
go
