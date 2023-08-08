
USE Movies;
GO -- begins a new batch

ALTER -- CREATE 
PROC [dbo].[spFilmList]
AS
BEGIN
    SELECT
        Title
        ,ReleaseDate
        ,RunTimeMinutes
        ,OscarNominations -- 오스카 후보
    FROM
        Film
    ORDER BY
        Title ASC
END
GO

-- Excute Procedure
EXEC spFilmList

-- Refresh Cache : Ctrl + Shift + Alt + R
-- DROP PROC spFilmList
GO

-- Working with Parameters

CREATE
PROC spFilmCriteria
(@MinLength AS INT)
AS
BEGIN
    SELECT
        Title
        ,RunTimeMinutes
    FROM
        Film
    ORDER BY
        RunTimeMinutes ASC
    
END
