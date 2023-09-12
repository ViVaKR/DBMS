
--* Change `Database Logical Name`
USE [ViVa]
GO

-- (1) 확인
SELECT
    file_id, name as logical_name, physical_name
FROM
    sys.database_files

-- (2) ReName
USE [master]
GO

ALTER DATABASE [ViVa] MODIFY FILE (Name = OldName, NEWNAME = ViVa);
GO

ALTER DATABASE [ViVa] MODIFY FILE (NAME = OldName_log, NEWNAME = ViVa_log)


-- Rename Database
USE [master]
GO

ALTER DATABASE MoviesB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

ALTER DATABASE [MoviesB] MODIFY NAME = [MoviesA]
GO 

ALTER DATABASE MoviesA SET MULTI_USER;
GO