use [<Database Name>]
go

backup database [<Database Name>]
to disk = '<Drive Letter>:\Database\Backup\<File Name>.Bak'
with format,
	medianame = '<Media Name>',
	name = 'Full Backup of ...'
go
