ALTER Trigger [dbo].[trgExam]
on [dbo].[Exam]
After Insert
as
Begin
	Insert into Exam_Log select *, GETDATE() as WorkDate from inserted
End