USE master;
GO

ALTER DATABASE AdventureWorks
SET SINGLE_USER
WITH ROLLBACK IMMEDIATE;
GO

ALTER DATABASE AdventureWorks
SET READ_ONLY;
GO

ALTER DATABASE AdventureWorks
SET MULTI_USER;
GO