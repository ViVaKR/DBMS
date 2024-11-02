-- #3 Variable
USE Movies
GO

SET NOCOUNT ON

DECLARE @MyDate AS DATETIME
DECLARE @NumFilms INT
DECLARE @NumActors INT
DECLARE @NumDirectors INT

SET @MyDate = '1970-01-01'
SET @NumFilms = (SELECT COUNT(*) FROM Film WHERE ReleaseDate >= @MyDate)
SET @NumActors = (SELECT COUNT(*) FROM Actor WHERE DoB >= @MyDate)
SET @NumDirectors = (SELECT COUNT(*) FROM Director WHERE DoB >= @MyDate)

SELECT 'Number of films' AS [구분], @NumFilms AS [COUNT]
UNION
SELECT 'Number of Actors' As [구분], @NumActors AS [COUNT]
UNION
SELECT 'Number of Director' AS [구분], @NumDirectors AS [COUNT]

PRINT 'Number of Films = ' + CAST(@NumFilms AS NVARCHAR(MAX))
PRINT 'Number of Actors = ' + CAST(@NumActors AS NVARCHAR(MAX))
PRINT 'Number of Directors = ' + CAST(@NumDirectors AS NVARCHAR(MAX))
GO
