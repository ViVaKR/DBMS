DECLARE @Path NVARCHAR(max)
set @Path = N'D:\Database\Backup\Movie_full.bak'
restore filelistonly from disk = @Path

-- End Line --
