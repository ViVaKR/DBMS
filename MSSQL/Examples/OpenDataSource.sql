EXEC sp_configure 'show advanced options', 1 -- 고급옵션을 설정하기
RECONFIGURE
GO
EXEC sp_configure 'ad hoc distributed queries', 1
RECONFIGURE
GO

-- SqlOledb, SqlNCli, MsOleDbSql
SELECT *
INTO 테이블
FROM OPENDATASOURCE (
        'SQLNCLI'
        ,'Data Source=localhost;Initial Catalog=데이터베이스;User ID=아이디;Password=비밀번호'
        ).[데이터베이스].dbo.테이블

SELECT * 
FROM OPENDATASOURCE('MSOLEDBSQL', 'Server=localhost;Database=데이터베이스;User ID=아이디;Password=<비밀번호>').데이터베이스.dbo.테이블

SELECT * 
FROM OPENDATASOURCE('SqlOleDb', 'Server=localhost;Database=데이터베이스;User ID=아이디;Password=비밀번호;').데이터베이스.dbo.테이블

-- End Line --
