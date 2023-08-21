IF OBJECT_ID (N'tempdb.dbo.#temp') IS NOT NULL
   DROP TABLE #temp

CREATE TABLE #temp
(
    [user] VARCHAR(10),
    Category VARCHAR(10),
    [Date] DATETIME
)

INSERT INTO #temp
    ([user], Category, [Date])
VALUES
    ('Jack', 'Shoes', '20110101'),
    ('Jack', 'Tie', '20110102'),
    ('Jack', 'Glass', '20110303'),
    ('Peggy', 'Shoe', '20120202'),
    ('Peggy', 'Skirt', '20131202')

DECLARE @Columns NVARCHAR(MAX)

SELECT @Columns = STUFF((
    SELECT DISTINCT
        ',[' + 'Category' + CAST(
        ROW_NUMBER() OVER (PARTITION BY t.[user] ORDER BY (SELECT 1)) AS VARCHAR(3)) + ']'
    FROM #temp t
    FOR XML PATH (''), TYPE).value('.', 'VARCHAR(MAX)'), 1, 1, '')

DECLARE @SQL NVARCHAR(MAX)
SELECT @SQL = '
SELECT [user], ' + @Columns + ', Dates 
FROM (
    SELECT 
          t.[user]
        , t.category
        , rn = ''Category'' + CAST(ROW_NUMBER() OVER (PARTITION BY t.[user] ORDER BY (SELECT 1)) AS VARCHAR(3))
        , Dates = STUFF((
              SELECT '', '' + CONVERT(VARCHAR(10), t2.[Date], 103)
              FROM #temp t2
              WHERE t2.[user] = t.[user]
              FOR XML PATH(''''), TYPE).value(''.'', ''VARCHAR(MAX)''), 1, 2, '''')  
    FROM #temp t
) t3 
PIVOT (
    MAX(category) 
    FOR rn IN (' + @Columns + ')
) p'

PRINT @SQL

EXECUTE sys.sp_executesql @SQL