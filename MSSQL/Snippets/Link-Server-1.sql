sp_configure 'show advanced options', 1;  
RECONFIGURE;
GO 
sp_configure 'Ad Hoc Distributed Queries', 1;  
RECONFIGURE;  
GO  
  
SELECT *
FROM OPENDATASOURCE (
        'SQLNCLI'
        ,'Data Source=�ܺμ����ҽ�;Initial Catalog=�����ͺ��̽�;User ID=���̵�;Password=��й�ȣ'
        ).[�����ͺ��̽�].dbo.���̺�
