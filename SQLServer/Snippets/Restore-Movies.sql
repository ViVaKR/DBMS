-- 신규 데이터베이스 생성
USE master
GO
IF NOT EXISTS (
 SELECT name
 FROM sys.databases
 WHERE name = N'Movies'
)
 CREATE DATABASE [Movies];
GO
IF SERVERPROPERTY('ProductVersion') > '12'
 ALTER DATABASE [Movies] SET QUERY_STORE=ON;
GO

use master;
alter database Movies set recovery full
go

-- Auto Close 기능 끄기
USE [master]
GO
ALTER DATABASE [Movies] SET AUTO_CLOSE OFF WITH NO_WAIT
GO

-- (1) 다른 데이터베이스 백업 파일로 복원하기
-- (2) 백업파일에서 Logical Name 을 가져오기
RESTORE FileListOnly from DISK = 'D:\Backup\DB\movies_backup_data.bak'
-- (3)복원
USE master
go
ALTER DATABASE Movies Set single_user with ROLLBACK IMMEDIATE;
RESTORE DATABASE Movies   
   FROM DISK = 'D:\Backup\DB\movies_backup_data.bak'
   WITH  RECOVERY,
   MOVE 'Movies' TO 'D:\Database\MSSQL15.SQLEXPRESS\MSSQL\DATA\Movies.mdf',   
   MOVE 'Movies_log' TO 'D:\Database\MSSQL15.SQLEXPRESS\MSSQL\DATA\Movies_log.mdf',
   REPLACE
GO
ALTER DATABASE Movies SET MULTI_USER;
go

-- End Line --
