EXEC sp_configure 'show advanced options', 1
RECONFIGURE
GO
EXEC sp_configure 'ad hoc distributed queries', 1
RECONFIGURE
GO

use Demo
go

SELECT *
INTO TestTb
FROM OPENDATASOURCE (
        'SQLNCLI'
        ,'Data Source=192.168.35.200,59273;Initial Catalog=Movies;User ID=sa;Password=B9037!m8947#'
        ).[Movies].dbo.tblFilm


SELECT * 
FROM OPENDATASOURCE('MSOLEDBSQL', 'Server=192.168.35.200,59273;Database=Movies;User ID=sa;Password=B9037!m8947#;').Movies.dbo.tblFilm
