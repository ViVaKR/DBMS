
--* Global Varable

select @@SERVERNAME as 'Server Name'

select @@VERSION

select @@MICROSOFTVERSION

select @@SERVICENAME

USE Movies;
SELECT * FROM Actor 
Select @@ROWCOUNT AS [행 갯수]

Select SERVERPROPERTY('MachineName') as 'MachineName'

select HOST_NAME() -- return nvarchar(128)

select @@ERROR

select @@TRANCOUNT

select @@DBTS

select @@IDENTITY

select @@SPID

select @@FETCH_STATUS

select @@LANGID

select @@LANGUAGE

select @@CPU_BUSY

select @@CONNECTIONS 

select @@IDLE
