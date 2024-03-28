--* (1) 백업 디바이스 정의
USE [master]
GO
EXEC master.dbo.sp_addumpdevice  
    @devtype = N'disk'
    , @logicalname = N'PlayGround'
    , @physicalname = N'C:\SQLServer\Backup\PlayGround.bak'
GO
