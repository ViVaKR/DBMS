USE [PlayGround]
GO

--* (1) Sample Table

IF OBJECT_ID(N'dbo.PlayGround', N'U') IS NULL 
BEGIN
    CREATE TABLE dbo.PlayGround
    (
        ID INT NOT NULL PRIMARY KEY,
        Title NVARCHAR(100) NOT NULL,
        DoW DATETIME NOT NULL DEFAULT GETDATE()
    );
    INSERT INTO [PlayBackup]
        (ID, Title)
    VALUES
        (1, 'test1'),
        (2, 'test2'),
        (3, 'test3'),
        (4, 'test4'),
        (5, 'test5');
END;

--* (2) 전체백업
-- 백업파일명 조립 : `현재일자 + 시분초` 접미사로 사용
DECLARE @datetime DATETIME
SET @datetime = GETDATE()

DECLARE @BackupFileName NVARCHAR(MAX)
SET @BackupFileName = CONCAT
(
    'C:\SQLServer\Backup\Backup-PlayGround-',
    YEAR(@datetime),
    MONTH(@datetime),
    DAY(@datetime), 
    DATEPART(HOUR, @datetime), 
    DATEPART(MINUTE, @datetime),
    DATEPART(SECOND, @datetime),
    '.bak'
)

-- 백업 수행
BACKUP DATABASE [PlayGround] 
TO DISK = @BackupFileName
WITH  
    INIT, -- 기존 백업 내용 모두 삭제 후 새롭게 백업 
    DESCRIPTION = N'PlayGround 전체백업', 
    NOFORMAT, 
    NAME = N'PlayGround-Full Database Backup', -- 백업세트-이름
    SKIP,  -- 미디어 세트 이름 백업세트 만료 확인 | `NOSKIP`
    STATS = 10, -- 기본값, 백업 완료율 10%마다 표시 옵션
    CHECKSUM -- 체크썸 수행
GO

-- 후 처리
declare @backupSetId as int
select
    @backupSetId = position
from
    msdb..backupset
where 
    database_name=N'PlayGround' and
    backup_set_id=(select max(backup_set_id)
    from msdb..backupset
    where database_name=N'PlayGround' )
if @backupSetId is null begin
    raiserror(N'Verify failed. Backup information for database ''PlayGround'' not found.', 16, 1)
end
RESTORE VERIFYONLY FROM  [PlayGround] WITH  FILE = @backupSetId,  NOUNLOAD,  NOREWIND
GO

PRINT '백업완료'
