--* TRAN Examples *--
BEGIN TRANSACTION [Tran1]

  BEGIN TRY

      INSERT INTO [대상_테이블]
	  SELECT * 
	  FROM [원본_테이블]

      COMMIT TRANSACTION [Tran1]

  END TRY

  BEGIN CATCH -- 오류 상세보기
	SELECT
		ERROR_NUMBER() AS ErrorNumber,
		ERROR_STATE() AS ErrorState,
		ERROR_SEVERITY() AS ErrorSeverity,
		ERROR_PROCEDURE() AS ErrorProcedure,
		ERROR_LINE() AS ErrorLine,
		ERROR_MESSAGE() AS ErrorMessage;
      ROLLBACK TRANSACTION [Tran1]
  END CATCH 
 go

-- End Line --
