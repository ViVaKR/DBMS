--======================= Start ============================--

go
BEGIN TRY
    BEGIN TRANSACTION

	select 1 / 0 as Result

    COMMIT TRAN
END TRY

BEGIN CATCH
	
	select @@TRANCOUNT as 'Tran Count'

    IF @@TRANCOUNT > 0 ROLLBACK TRAN
	
	  SELECT
		ERROR_NUMBER() AS ErrorNumber,
		ERROR_STATE() AS ErrorState,
		ERROR_SEVERITY() AS ErrorSeverity,
		ERROR_PROCEDURE() AS ErrorProcedure,
		ERROR_LINE() AS ErrorLine,
		ERROR_MESSAGE() AS ErrorMessage;

	 select @@TRANCOUNT as 'Tran Count'
END CATCH
go

--======================= End ============================--
