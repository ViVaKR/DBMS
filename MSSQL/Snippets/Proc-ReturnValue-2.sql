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
ALTER 
--CREATE
    PROC spFilmsInYear2
    (@Year AS INT)

AS BEGIN

    SELECT 
        FilmName
    FROM
        tblFilm
    WHERE
        YEAR(FilmReleaseDate) >= @Year
    ORDER BY 
        FilmName ASC

    RETURN @@ROWCOUNT

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
