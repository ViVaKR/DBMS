EXEC sp_configure 'show advanced options', 1 -- ��޿ɼ��� �����ϱ�
RECONFIGURE
GO
EXEC sp_configure 'ad hoc distributed queries', 1
RECONFIGURE
GO

-- SqlOledb, SqlNCli, MsOleDbSql
SELECT *
INTO ���̺�
FROM OPENDATASOURCE (
        'SQLNCLI'
        ,'Data Source=localhost;Initial Catalog=�����ͺ��̽�;User ID=���̵�;Password=��й�ȣ'
        ).[�����ͺ��̽�].dbo.���̺�

SELECT * 
FROM OPENDATASOURCE('MSOLEDBSQL', 'Server=localhost;Database=�����ͺ��̽�;User ID=���̵�;Password=<��й�ȣ>').�����ͺ��̽�.dbo.���̺�

SELECT * 
FROM OPENDATASOURCE('SqlOleDb', 'Server=localhost;Database=�����ͺ��̽�;User ID=���̵�;Password=��й�ȣ;').�����ͺ��̽�.dbo.���̺�

-- End Line --
