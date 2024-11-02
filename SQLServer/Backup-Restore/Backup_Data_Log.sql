
BACKUP LOG [<Database Name>] TO DISK = N'D:\Backup\HyundaiDb.TRN'
BACKUP DATABASE [<Database Name>]
TO DISK = 'D:\Backup\<File Name>.bak'
GO
BACKUP LOG HyundaiDb
TO DISK = 'D:\Backup\<File Name>.TRN'
GO
