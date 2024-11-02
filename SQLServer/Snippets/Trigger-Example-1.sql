USE [Movies]
GO

/****** Object:  DdlTrigger [trgNoNewTables]    Script Date: 2019-12-22 오후 1:19:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER trigger [trgNoNewTables]
on Database
for create_table, alter_table, drop_table
as
begin
	print '== No change to tables please =='
	rollback
end
GO


