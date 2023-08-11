use master
go

-- Backup
declare @backupFile_full nvarchar(max)
declare @backupFile_full_log nvarchar(max)
declare @backupFile_copy nvarchar(max)
declare @backupFile_copy_log nvarchar(max)

set @backupFile_full = N'D:\Database\Backup\Movie_full.bak'
set @backupFile_full_log = N'D:\Database\Backup\Movie_full_log.bak'
set @backupFile_copy = N'D:\Database\Backup\Movie_copy.bak'
set @backupFile_copy_log = N'D:\Database\Backup\Movie_copy_log.bak'

-- 전체백업
backup database Movie
to disk = @backupFile_full
with format

backup log Movie
to disk = @backupFile_full_log
with format

-- 복사전용 백업
backup database Movie
to disk = @backupFile_copy
with copy_only, format

backup log Movie
to disk = @backupFile_copy_log
with copy_only, format

-- Restore
use master
go

if not exists
(
	select name
	from sys.databases
	where name = N'Movies_Copy'

)
Create database [Movies_Copy]
go

alter database Movies_Copy 
set recovery full
go


-- 데이터베이스 삭제
ALTER DATABASE 데이터베이스
SET OFFLINE WITH ROLLBACK IMMEDIATE
GO

drop database if exists 데이터베이스
go

-- 데이터베이스 생성
if(DB_ID(N'Movie_Copy') is null)
create database Movie_Copy

alter database Movie_Copy 
Set single_user
with rollback immediate

-- 데이터베이스 복원
use master
go
restore database Movies_Copy
from disk = N'D:\Database\Backup\Movie_copy.bak'
with recovery,
move 'Movie' to 'D:\Database\Data\Movies_Copy.mdf',
move 'Movie_log' to 'D:\Database\Data\Movies_Copy_log.ldf',
replace
go

use Movies_Copy
go
select * from Film

alter database Movie_Copy Set Multi_User
go
select * from sys.master_files where name = 'Moive_Copy_log'

select * from sys.master_files where name like 'Movies_Copy%'

restore filelistonly from disk = N'D:\Database\Backup\Movie_copy.bak'
--
backup log dms
to disk = 'D:\Database\Backup\server-dms.bak'
with norecovery;
go

RESTORE DATABASE DMS WITH RECOVERY

use master
go
backup database DMS
to Disk = 'D:\Database\Backup\server-dms-full.bak'
with format;

backup log DMS
to disk = 'D:\Database\Backup\server-dms-full.bak'
go
