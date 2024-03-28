--? [ spFilmCriteria ] ?--

--* Parameter
-- (1) EXEC spFilmCriteria 170, 180

--* Named Parameter
-- (2) EXEC spFilmCriteria @MinLength = 170, @MaxLength = 180

--* Create Text Parameter
-- (3) EXEC spFilmCriteria @MinLength = 100, @MaxLength = 250, @Title = 'star'

--* Optional Parameter
EXEC spFilmCriteria  @MaxLength = 250, @Title = 'die'

--* Null Parameter
EXEC spFilmCriteria @Title = 'star'
EXEC spFilmCriteria @Title = 'star', @MinLength = 120


USE [AdventureWorks]
GO

SELECT
    *
FROM
    Person.Address


-- (1) 확인
USE [AdventureWorks]
GO

SELECT
    file_id, name as logical_name, physical_name
FROM
    sys.database_files

-- (2) ReName
USE [master]
GO

ALTER DATABASE [AdventureWorks] MODIFY FILE (Name = AdventureWorks2022, NEWNAME = AdventureWorks);
GO

ALTER DATABASE [AdventureWorks] MODIFY FILE (NAME = AdventureWorks2022_log, NEWNAME = AdventureWorks_log)
GO


USE [Viv]
GO

INSERT INTO Users
VALUES
        ('John Dals',GETDATE(), 'Hi Everyone')
GO

SELECT
    *
FROM
    Users


SELECT
    *
FROM
    __MigrationHistory
