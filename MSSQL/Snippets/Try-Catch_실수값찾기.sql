BEGIN TRANSACTION [Tran1]

  BEGIN TRY

	declare @CarNum nvarchar(4)
	declare @CarType nvarchar(50)

	set @CarNum = '2024'
	set @CarType = N'TA'
	update 시험차량 set 차종 = @CarType, 임시번호_메모=N'휠얼라인먼트 참조, 차종 ' + @CarType + N'으로 수정' where 임시번호 = @CarNum

	select * from 시험차량 where 임시번호 = @CarNum

    COMMIT TRANSACTION [Tran1]

  END TRY

  BEGIN CATCH
      ROLLBACK TRANSACTION [Tran1]
  END CATCH

-- 실수값 찾기
SELECT  *
FROM 테이블
WHERE   
	CASE WHEN IsNumeric([숫자열]) = 1 
	THEN 
	CASE WHEN CAST(오도 AS FLOAT) <> CAST(CAST(오도 AS FLOAT) AS INT) 
	THEN 1 END 
	ELSE 1 END = 1

-- End Line --
