-- Change Database Name
USE [master]
GO

ALTER DATABASE MoviesB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

ALTER DATABASE [MoviesB] MODIFY NAME = [MoviesA]
GO 

ALTER DATABASE MoviesA SET MULTI_USER;
GO

-- Change Logical Name
USE [master]
GO

ALTER DATABASE [MoviesA] MODIFY FILE (Name = MoviesB, NEWNAME = MoviesA);
GO

ALTER DATABASE [MoviesA] MODIFY FILE (NAME = MoviesB_log, NEWNAME = MoviesA_log)

-- Database Info
USE MoviesA
Go
SELECT
    file_id, name as logical_name, physical_name
FROM
    sys.database_files

-- Detach
USE master
GO

ALTER DATABASE MoviesA
SET SINGLE_USER
GO

EXEC sp_detach_db 'MoviesA', 'true';

-- Attach
CREATE DATABASE MoviesA   
    ON (FILENAME = '/var/opt/mssql/data/MoviesA.mdf'),   
    (FILENAME = '/var/opt/mssql/data/MoviesA_log.ldf')   
    FOR ATTACH;

USE master
GO
ALTER DATABASE MoviesA
SET MULTI_USER
GO