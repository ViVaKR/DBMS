-- 피벗테이블 (표준)

USE [ViVa]
GO

DECLARE @cols AS NVARCHAR(MAX), @query AS NVARCHAR(MAX)

SELECT @cols = STUFF((SELECT DISTINCT ',' + QUOTENAME([차량작업번호])
    FROM 주행일지
    FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '')

SET @query = 
    'SELECT ' + '''주행거리 합계''' + ' AS [차량작업번호], ' 
    + @cols
    + ' FROM (SELECT 차량작업번호, 주행거리 FROM 주행일지) t '
    + ' PIVOT (SUM([주행거리]) '
    + ' FOR [차량작업번호] '
    + ' IN ('
    + @cols
    + ')) p'

execute(@query)
