BEGIN TRANSACTION [Tran1]

  BEGIN TRY

	declare @CarNum nvarchar(4)
	declare @CarType nvarchar(50)

	set @CarNum = '2024'
	set @CarType = N'TA'
	update �������� set ���� = @CarType, �ӽù�ȣ_�޸�=N'�پ���θ�Ʈ ����, ���� ' + @CarType + N'���� ����' where �ӽù�ȣ = @CarNum

	select * from �������� where �ӽù�ȣ = @CarNum

    COMMIT TRANSACTION [Tran1]

  END TRY

  BEGIN CATCH
      ROLLBACK TRANSACTION [Tran1]
  END CATCH

-- �Ǽ��� ã��
SELECT  *
FROM ���̺�
WHERE   
	CASE WHEN IsNumeric([���ڿ�]) = 1 
	THEN 
	CASE WHEN CAST(���� AS FLOAT) <> CAST(CAST(���� AS FLOAT) AS INT) 
	THEN 1 END 
	ELSE 1 END = 1

-- End Line --
