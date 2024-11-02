
USE Demo
GO

IF OBJECT_ID(N'Salaries', 'U') IS NULL
BEGIN
    CREATE TABLE Salaries
    (
        Id INT PRIMARY KEY,
        FullName NVARCHAR(50) NOT NULL,
        Salary INT NOT NULL,
        Dept_Id INT NOT NULL
    );
END
ELSE
BEGIN
    PRINT '== 이미 있는 테이블입니다. =='
END
GO

INSERT INTO Salaries
VALUES
    (12009, 'Sutherland', 54000, 45),
    (34974, 'Yates', 80000, 45),
    (34987, 'Erickson', 42000, 45),
    (45001, 'Parker', 57500, 30),
    (75623, 'Gates', 65000, 30)
GO

SELECT
    *
FROM
    Salaries


/* Syntax

SELECT
    first_column AS <first_column_alias>
    , [pivot_value1]
    , [pivot_value2]
    , ....
    , [pivoit_value_n]
FROM
    (<source_tables>) AS <source_table_alias>
PIVOT
(
    aggregate_function(<aggregate_column>) 
    FOR <pivot_column>
    IN ([pivot_value1], [pivot_value2], ... [pivot_value_n])
) AS <pivot_table_alias>

 */

-- aggregate_function : SUM, COUNT, MIN, MAX or AVG
USE [Demo]
GO
DECLARE @q NVARCHAR(MAX), @name NVARCHAR(MAX)

SELECT '합계' AS Total, [30], [45]
FROM (SELECT Salary, Dept_Id
    FROM Salaries) AS SourceTable
PIVOT (SUM(Salary) FOR Dept_Id IN ([30], [45])) AS PivotTable

EXECUTE(@q)

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

GO

--

SELECT @cols = STUFF((SELECT DISTINCT ',' + QUOTENAME([차량작업번호])
    FROM 주행일지
    FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')

SELECT @cols

USE [Demo]
GO

DECLARE @xml XML
-- FOR XML PATH('xxx')<xxx></xxx>, -- PATH('') 노드를 지우는 효과
SET @xml = (SELECT ', ' + QUOTENAME([FullName])
FROM Salaries
FOR XML PATH(''), TYPE)

SELECT STUFF(@xml.value('.', 'NVARCHAR(MAX)'), 1, 1, '')

SELECT *
FROM Salaries


SELECT STUFF('ABCDEFG', 2, 3, 'KKK')

SELECT DISTINCT ', ' + QUOTENAME(차량작업번호)
FROM 주행일지

SELECT QUOTENAME(십진코드)
FROM 약식기호
FOR XML PATH(''), TYPE


    DECLARE @myDoc XML
    DECLARE @ProdID INT
    SET @myDoc = '<Root>  
                    <ProductDescription ProductID="127" ProductName="Road Bike">  
                    <Features>  
                    <Warranty>1 year parts and labor</Warranty>  
                    <Maintenance>3 year parts and labor extended maintenance is available</Maintenance>  
                    </Features>  
                    </ProductDescription>  
                    </Root>'

    SET @ProdID =  @myDoc.value('(/Root/ProductDescription/@ProductID)[1]', 'int' )
    SELECT @ProdID


SELECT FORMAT(123456789, 'N0') --that's a zero, specifying the number of decimal places


SELECT FORMAT(23432.5, '')