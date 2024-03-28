
-- Get SPID
 select  d.name , convert (smallint, req_spid) As spid
      from master.dbo.syslockinfo l, 
           master.dbo.spt_values v,
           master.dbo.spt_values x, 
           master.dbo.spt_values u, 
           master.dbo.sysdatabases d
      where   l.rsc_type = v.number 
      and v.type = 'LR' 
      and l.req_status = x.number 
      and x.type = 'LS' 
      and l.req_mode + 1 = u.number
      and u.type = 'L' 
      and l.rsc_dbid = d.dbid 
      and rsc_dbid = (select top 1 dbid from 
                      master..sysdatabases 
                      where name like 'ReportServer')

GO
declare @spid int
declare @kill_process nvarchar(max)

SET @spid = 1234
-- Kill Process
SET @kill_process =  'KILL ' + @spid      
            EXEC master.dbo.sp_executesql @kill_process
                   PRINT 'killed spid : '+ @spid

GO
-- Drop
USE master;
GO
ALTER DATABASE dbname SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

DROP DATABASE [Demo]