-- 백업
use Movies
go

DECLARE @Path NVARCHAR(max)
set @Path = N'D:\Backup\DB\movies_backup_data.bak'

backup database movies
to DISK = @path
WITH format,
medianame = 'MoviesBackups',
NAME = 'Full Backup of Movies'
GO

select * from sys.backup_devices

-- 로그백업
use Movies
go
DECLARE @Path NVARCHAR(max)
set @Path = N'D:\Backup\DB\movies_backup_log.bak'

BACKUP LOG Movies
to DISK = @Path
with init,
NAME = 'MoviesBackupLog'
go

-- 데이터베이스 생성
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

-- 삭제전 연결끊기
ALTER DATABASE database_name
SET OFFLINE WITH ROLLBACK IMMEDIATE
GO

-- 데이터베이스 정보 가져오기
SELECT d.name DatabaseName, f.name LogicalName,
f.physical_name AS PhysicalName,
f.type_desc TypeofFile
FROM sys.master_files f
INNER JOIN sys.databases d ON d.database_id = f.database_id
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

use Movies
go

backup DATABASE Movies
to DISK = 'D:\Backup\DB\SQLEXPRESS\Movies_data.bak'
WITH FORMAT;
go

backup log Movies 
to DISK = 'D:\Backup\DB\SQLEXPRESS\Movies_Log.bak'
WITH FORMAT

-- 로그파일 줄이기 —
-- (1)데이터베이스 상태보기
-- 단순복구 모델로 변경
alter DATABASE Movies Set RECOVERY SIMPLE
GO
-- 축소하기
DBCC shrinkfile(Movies_Log)
GO
-- 전체복구 모델로 변경
ALTER DATABASE Movies SET RECOVERY FULL
GO
