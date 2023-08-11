-- ��ü��ȣ -----------------------------------------------------------------------
use DMS
go

declare @Cno  int
declare @Cname nvarchar(50)

declare cs cursor for
	select ��ü from  ����_Ÿ�̾��
	for update of ��ü��ȣ
open cs
	fetch next from cs into @Cname

	while @@FETCH_STATUS = 0
		begin
			update ����_Ÿ�̾�� set ��ü��ȣ =  
			case @Cname
				when N'����' then 10003
				when N'����' then 10002
				when N'����' then 10001
				else 10004
			end
			where current of cs
			
			fetch next from cs into @Cname
		end
close cs
deallocate cs

go

-- �����۾���ȣ ---------------------------------------------------------------------
use DMS
go

declare @Cname nvarchar(8)
declare @CarKind nvarchar(255)
declare @CarKindSum nvarchar(max)
declare cs cursor for
	select �ӽù�ȣ, ���� from  ����_�پ���θ�Ʈ_����
	for update of �����۾���ȣ
open cs
	fetch next from cs into @Cname, @CarKind
	while @@FETCH_STATUS = 0
		begin
			if @CarKind = '-'	-- ���� ������ ���� ��
				begin
					set @CarKindSum = @Cname
					update ����_�������� set �����۾���ȣ = 
					(select top 1 �۾���ȣ from �������� Where �ӽù�ȣ = @CarKindSum order by �۾���ȣ)
					where current of cs
				end
			else
				begin
					set @CarKindSum = @Cname + @CarKind
					update ����_�������� set �����۾���ȣ = 
					(select top 1 �۾���ȣ from �������� Where (�ӽù�ȣ + ����) = @CarKindSum order by �۾���ȣ)
					where current of cs
				end
			fetch next from cs into @Cname, @CarKind
		end
close cs
deallocate cs

GO

update ����_�������� Set ���� = N'TQ-PE2' where �ӽù�ȣ = '4081' 
 and �����۾���ȣ is null and ��ü = N'����'

select ��ü, �����۾���ȣ, ����, �ӽù�ȣ from ����_�������� where �ӽù�ȣ = '4081' 

select ����, �ӽù�ȣ, ��ü from ����_�������� where �����۾���ȣ is null group by ����, �ӽù�ȣ, ��ü  order by �ӽù�ȣ

GO

update ����_���ϼҸ� set ���� = 0 where ���� is null
select * from ����_���ϼҸ� where ���� is null

select �������� from ����_���ϼҸ� group by ��������
select * from ��������

update ����_���ϼҸ� set ���Ϲ�ȣ= 1002 where ���Ϲ�ȣ is null
select * from ����_���ϼҸ�

-- ���̺� ����
select * into ����_������ from ����_������
select * from ����_������

-- ������ ���� 
BEGIN TRANSACTION [Tran1]

  BEGIN TRY

      INSERT INTO Ÿ�̾�����
	  SELECT * 
	  FROM ����_Ÿ�̾�����

      COMMIT TRANSACTION [Tran1]

  END TRY

  BEGIN CATCH
	SELECT
		ERROR_NUMBER() AS ErrorNumber,
		ERROR_STATE() AS ErrorState,
		ERROR_SEVERITY() AS ErrorSeverity,
		ERROR_PROCEDURE() AS ErrorProcedure,
		ERROR_LINE() AS ErrorLine,
		ERROR_MESSAGE() AS ErrorMessage;
      ROLLBACK TRANSACTION [Tran1]

  END CATCH 

GO

-- �ڽ���ȣ ---------------------------------------------------------------------
use DMS
go

declare @Cs nvarchar(50)
declare @Comp int

declare cs cursor for
	select �ڽ�, ��ü��ȣ from  ����_������
	for update of �ڽ���ȣ
open cs
	fetch next from cs into @Cs, @Comp

	while @@FETCH_STATUS = 0
		begin

			update ����_������ set �ڽ���ȣ = 
			(select �ڽ���ȣ from �ڽ����� Where �ڽ��� = @Cs and ��ü = @Comp)
			where current of cs

			fetch next from cs into @Cs, @Comp
		end
close cs
deallocate cs

GO

-- �۾���ȣ �缳�� ---------------------------------------------------------------------
use DMS
go
declare @TempCarNumber nvarchar(8)
declare @Number int

declare @Num int
	set @Num = 1000000001

declare cs cursor for
	select �ӽù�ȣ, �۾���ȣ from ����_������ order by ��¥
	for update of �����۾���ȣ

open cs 
	fetch next from cs into  @TempCarNumber, @Number

	while @@FETCH_STATUS = 0
		begin
			update ����_������ set �����۾���ȣ= @Num
			where current of cs

			fetch next from cs into @TempCarNumber, @Number
			set @Num = @Num + 1
		end
close cs
deallocate cs

GO

-- �����۾���ȣ �ӽù�ȣ ������ �����
use DMS
go

declare @TempCarNumber nvarchar(8)
declare @CompNumber int
declare @CarKind	nvarchar(20)

declare cs cursor for
	select �ӽù�ȣ, ��ü��ȣ from  ����_Ÿ�̾��
	for update of �����۾���ȣ
open cs
	fetch next from cs into @TempCarNumber, @CompNumber
	while @@FETCH_STATUS = 0
		begin
				begin
					update ����_Ÿ�̾�� set �����۾���ȣ = 
					(select top 1 �۾���ȣ from �������� Where �ӽù�ȣ = @TempCarNumber and ��ü��ȣ = @CompNumber  order by �۾���ȣ)
					where current of cs
				end
			fetch next from cs into @TempCarNumber, @CompNumber
		end
close cs
deallocate cs

GO

-- ������ ��ȣ ------------------------------------------------
use DMS
go

declare @dv nvarchar(20)
declare @comp int

declare cs cursor for
	select ������, ��ü��ȣ from  ����_��������
	for update of �����ڹ�ȣ
open cs
	fetch next from cs into @dv, @comp
	while @@FETCH_STATUS = 0
		begin
				begin
					update ����_�������� set �����ڹ�ȣ = 
					(select top 1 �����ڹ�ȣ from ���������� Where �̸� = @dv and ��ü = @comp)
					where current of cs
				end
			fetch next from cs into @dv, @comp
		end
close cs
deallocate cs

GO

-- �ð����� ------------------------------------------------
use DMS
go

begin tran Tran2
begin try
	declare @t1 nvarchar(10)
	declare @t2 nvarchar(50)

	declare cs cursor for
		select ���ð��ӽ� from  ����_��������
		for update of ���ð�
	open cs
		fetch next from cs into @t1
		while @@FETCH_STATUS = 0
			begin
					begin
						update ����_�������� set ���ð� = (CONVERT(nvarchar, @t1, 108)) where current of cs
						-- update ����_�������� set ���ð��ӽ� = (select REPLACE(@t1, '��', '')) where current of cs
					end
				fetch next from cs into @t1
			end
	close cs
	deallocate cs
      COMMIT TRANSACTION [Tran2]
END TRY
BEGIN CATCH
	SELECT
		ERROR_NUMBER() AS ErrorNumber,
		ERROR_STATE() AS ErrorState,
		ERROR_SEVERITY() AS ErrorSeverity,
		ERROR_PROCEDURE() AS ErrorProcedure,
		ERROR_LINE() AS ErrorLine,
		ERROR_MESSAGE() AS ErrorMessage;
      ROLLBACK TRANSACTION [Tran2]

	  	close cs
	deallocate cs
END CATCH 

GO

-- Ÿ�Ժ��� ------------------------------------------------
use DMS
go

begin tran Tran3
begin try
	declare @t1 nvarchar(10)
	declare @t2 nvarchar(50)

	declare cs cursor for
		select ����ܾ� from  ����_��������
		for update of ����
	open cs
		fetch next from cs into @t1
		while @@FETCH_STATUS = 0
			begin
					begin
						update ����_�������� set ���� = (select cast(round(CONVERT(real, @t1), 0) as int))
						-- update ����_�������� set Ʈ���� = (select REPLACE(@t1, ',','.'))
						 where current of cs
					end
				fetch next from cs into @t1
			end
	close cs
	deallocate cs
      COMMIT TRANSACTION [Tran3]
END TRY
BEGIN CATCH
	SELECT
		ERROR_NUMBER() AS ErrorNumber,
		ERROR_STATE() AS ErrorState,
		ERROR_SEVERITY() AS ErrorSeverity,
		ERROR_PROCEDURE() AS ErrorProcedure,
		ERROR_LINE() AS ErrorLine,
		ERROR_MESSAGE() AS ErrorMessage;
      ROLLBACK TRANSACTION [Tran3]

	  	close cs
	deallocate cs
END CATCH 

GO

update ����_��������
set ����_��������.������ҹ�� = B.���
from ����_�������� as A,
(select �۾���ȣ, ��� from ����_�������� where ��� = N'�����н�') as B
where A.�۾���ȣ = B.�۾���ȣ

GO

-- Select ������ ������Ʈ �ϱ�

update ����_�������� 
set ����_��������.�������� = B.��������
from ����_�������� as A, 
(select �۾���ȣ, �������� from ���_��������  where �����۵� is null) as B
Where A.�۾���ȣ = B.�۾���ȣ

GO

-- ���ϼҸ� �����ϱ�
use DMS
go

--declare @Liter	int
--declare @kg		int
--declare @add	int
--declare	@drein	int
--declare	@rein	int

declare @jno	int
declare @tname	nvarchar(128)

declare cs cursor for
	select �۾���ȣ from  ���ϼҸ�
	for update of ���ϼҸ�_����, ���ϼҸ�_Ű�α׷�, ���淮, �巹�η�, �����Է�
open cs
	fetch next from cs into @Liter, @kg, @add, @drein, @rein
	while @@FETCH_STATUS = 0
		begin
			EXEC('UPDATE [' + @tname + '] SET item = UPPER(item)');
			fetch next from cs into @Liter, @kg, @add, @drein, @rein
		end
close cs
deallocate cs

GO

truncate table ��������
go
dbcc checkident(N'��������', reseed, 0)
go

-- �������� ��ȣ ------------------------------------------------
use DMS
go

declare @kind nvarchar(100)

declare cs cursor for
	select �������� from  ���ϼҸ�
	for update of ���Ϲ�ȣ
open cs
	fetch next from cs into @kind
	while @@FETCH_STATUS = 0
		begin
				begin
					update ���ϼҸ� set ���Ϲ�ȣ = 
					(select ���Ϲ�ȣ from �������� Where �����̸� = @kind)
					where current of cs
				end
			fetch next from cs into @kind
		end
close cs
deallocate cs

GO

-- Ÿ�̾���ǰ��ȣ �����
use DMS
go

declare @TireMaker int
declare @Spec nvarchar(100)

declare cs cursor for
	select Ÿ�̾��ü��ȣ, �԰� from  ����_Ÿ�̾��
	for update of Ÿ�̾���ǰ��ȣ
open cs
	fetch next from cs into @TireMaker, @Spec
	while @@FETCH_STATUS = 0
		begin
				begin
					update ����_Ÿ�̾�� set Ÿ�̾���ǰ��ȣ = 
					(select top 1 �۾���ȣ from Ÿ�̾���ǰ���� Where ��ü = @TireMaker and �԰� = @Spec  order by �۾���ȣ)
					where current of cs
				end
			fetch next from cs into @TireMaker, @Spec
		end
close cs
deallocate cs
-- ==========================================================================================

-- Ÿ�̾� ��ü��ȣ -----------------------------------------------------------------------
use DMS
go

declare @Cno  int
declare @Cname nvarchar(50)

declare cs cursor for
	select Ÿ�̾��ü from  ����_Ÿ�̾��
	for update of Ÿ�̾��ü��ȣ
open cs
	fetch next from cs into @Cname

	while @@FETCH_STATUS = 0
		begin

			update ����_Ÿ�̾�� set Ÿ�̾��ü��ȣ =  
			case @Cname
				when N'����' then 101
				when N'������' then 102
				when N'����' then 103
				when N'��Ƽ��Ż' then 104
				when N'�Ƿ���' then 105
				when N'�ѱ�' then 106
				when N'���̾�' then 107
				when N'��ȣ' then 108
				when N'�ؼ�' then 109
				when N'�̽���'then 110
				when N'�긴������' then 111
				when N'APOLLO' then 112
				when N'CEAT' then 113
				when N'MAXXIS' then 114
				when N'MRF' then 115

			end
			where current of cs
			
			fetch next from cs into @Cname
		end
close cs
deallocate cs

go

use DMS
go

------�������� ��ȣ
declare @Cno  int
declare @Cname nvarchar(50)

declare cs cursor for
	select �������� from  ����_Ÿ�̾��
	for update of ����
open cs
	fetch next from cs into @Cname

	while @@FETCH_STATUS = 0
		begin

			update ����_Ÿ�̾�� set ���� =  
			case @Cname
				when N'���' then 0
				when N'�ý���' then 1
			end
			where current of cs
			
			fetch next from cs into @Cname
		end
close cs
deallocate cs

-- End Line --
