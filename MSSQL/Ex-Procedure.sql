--? GO : 일괄처리의 작업단위
/* 
    작업단위 안에서 선언된 변수는 해당 작업 단위내에서만 참조 가능함
    GO 문의 줄에는 주석을 제외한 T-SQL 문은 올수 없음
 */


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

ALTER 
--CREATE
PROC spFilmCriteria
    (
        @MinLength AS INT = NULL
        ,@MaxLength AS INT = NULL
        ,@Title AS NVARCHAR(MAX)
    )
AS
BEGIN
    SELECT
        Title
        ,RunTimeMinutes
    FROM
        Film
    WHERE
        (@MinLength IS NULL OR RunTimeMinutes >= @MinLength) AND
        (@MaxLength IS NULL OR RunTimeMinutes <= @MaxLength) AND
        Title LIKE '%' + @Title + '%'
    ORDER BY
        RunTimeMinutes ASC

END

GO

-- #3 Variable
USE Movies
GO

DECLARE @MyDate AS DATETIME
SET @MyDate = '1970-01-01'

SELECT 
    Title AS [이름]
    ,ReleaseDate AS [날짜]
    ,'Film' AS [타입]
FROM Film
WHERE ReleaseDate >= '1970-01-01'

UNION ALL

SELECT
    FullName AS [이름]
    ,DoB AS [날짜]
    ,'Actor' as [타입]
FROM Actor
WHERE DoB >= '1970-01-01'

UNION ALL

SELECT FullName, DoB, 'Director'
FROM Director
WHERE DoB >= '1970-01-01'
ORDER BY [날짜] ASC
