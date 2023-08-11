use [master];
GO
ALTER DATABASE [데이터베이스명] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
GO

EXEC master.dbo.sp_detach_db @dbname = [데이터베이스명], @skipchecks = 'false'
GO

-- End Line --
