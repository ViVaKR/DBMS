USE [master]
GO

EXEC msdb.dbo.sp_delete_database_backuphistory 
@database_name = [데이터베이스명]
GO

ALTER DATABASE [데이터베이스명] 
SET SINGLE_USER WITH ROLLBACK IMMEDIATE
GO

DROP DATABASE IF EXISTS [데이터베이스명]
GO
