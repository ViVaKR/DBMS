USE [데이터베이스명]
GO
/****** Object:  Trigger [dbo].[trgExam]    Script Date: 2019-12-18 오전 2:36:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER Trigger [dbo].[trgExam]
on [dbo].[Exam]
After Insert
as
Begin
	Insert into Exam_Log
	select *, GETDATE() as WorkDate
	from inserted
End

GO
If (OBJECT_ID('Exam_Log') is not null)
	Begin
	Set Identity_Insert Exam_Log  on
End
	Else
	Begin
	Select *, GETDATE() as WorkDate
	into Exam_Log
	From inserted
	Set Identity_Insert Exam_Log   off
End
