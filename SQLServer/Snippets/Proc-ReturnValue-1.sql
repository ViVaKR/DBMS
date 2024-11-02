--* Return Values from Stored Procedures
/* 
 (1) Recap of Input Parameters
 (2) Defining Output Parameters
 (3) Getttin the Result of an Output Parameter
 (4) Using Return Values in Stored Procedures 
 */

USE MoviesB
GO

-- (1)
ALTER -- CREATE
    PROC spFilmsInYear
    (
    @Year AS INT,
    @FilmList NVARCHAR(MAX) OUTPUT,
    @FilmCount INT OUTPUT)

AS BEGIN

    DECLARE @Films NVARCHAR(MAX)
    SET @Films = ''

    SELECT 
        @Films = @Films + FilmName + ', '
    FROM
        tblFilm
    WHERE
        YEAR(FilmReleaseDate) >= @Year
    ORDER BY 
        FilmName ASC

    SET @FilmCount = @@ROWCOUNT
    SET @FilmList = @Films
END
GO 

--! (1) Default
-- EXEC spFilmsInYear @Year = 2000

--! (2) Get Return Values
DECLARE @Names NVARCHAR(MAX)
DECLARE @Count INT


EXEC spFilmsInYear 
    @Year = 2000
    ,@FilmList = @Names OUTPUT
    ,@FilmCount = @Count OUTPUT

SELECT @Names AS [List of Films], @Count AS [Number of Films] 

PRINT @Names
PRINT @Count
