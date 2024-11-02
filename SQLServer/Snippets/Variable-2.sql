USE Movies
GO

--* 검색 결과를 변수에 할당하기

DECLARE @ID INT
DECLARE @Name NVARCHAR(MAX)
DECLARE @Date DATETIME

SELECT
    TOP 1
    @ID = ActorID
    , @Name = FullName
    , @Date = DoB
FROM
    Actor
WHERE
    DoB >= '1970-01-01'
ORDER BY
    DoB ASC

SELECT @ID, @Name, @Date

--* 변수에 검색결과 합치기

DECLARE @NameList NVARCHAR(MAX)
SET @NameList = ''

SELECT
    @NameList = @NameList + FirstName + CHAR(10) -- + CHAR(13)
FROM
    Actor
WHERE
    YEAR(DoB) = 1970

PRINT @NameList
