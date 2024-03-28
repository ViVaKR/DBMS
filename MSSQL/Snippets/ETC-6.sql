use master
go

--* Check : xp_cmdshell
SELECT * FROM sys.configurations WHERE name = 'xp_cmdshell'

--* xp_cmdshell : Disable
Use Master
GO

EXEC master.dbo.sp_configure 'xp_cmdshell', 0
RECONFIGURE WITH OVERRIDE

GO

EXEC master.dbo.sp_configure 'show advanced options', 0
RECONFIGURE WITH OVERRIDE
GO

--* xp_cmdshell : Enable
Use Master
GO
EXEC master.dbo.sp_configure 'show advanced options', 1
RECONFIGURE WITH OVERRIDE
GO

EXEC master.dbo.sp_configure 'xp_cmdshell', 1
RECONFIGURE WITH OVERRIDE
GO

--* Confirm : xp_cmdshell
SELECT * FROM sys.configurations WHERE name = 'xp_cmdshell'

--* Use
exec xp_cmdshell 'path'

--* Use
exec sp_helptext xp_cmdshell

--* Use
exec master.sys.xp_dirtree 'F:\Temp',0,1

--* Get Logins List
exec master.sys.xp_logininfo
go

--* xp_dirtree Examples
IF OBJECT_ID('tempdb..#DirectoryTree') IS NOT NULL
DROP TABLE #DirectoryTree;

CREATE TABLE #DirectoryTree (
       id int Primary Key IDENTITY(1,1)
      ,subdirectory nvarchar(512)
      ,depth int
      ,isfile bit);

INSERT #DirectoryTree (subdirectory,depth,isfile) EXEC master.sys.xp_dirtree 'D:\Temp',0,1;

SELECT * FROM #DirectoryTree
WHERE isfile = 1 AND RIGHT(subdirectory,4) = '.BAK'
ORDER BY id;

GO

use tempdb
go
select * from #DirectoryTree

go

-- End Line --
