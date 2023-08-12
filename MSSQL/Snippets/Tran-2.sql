-- 견본 (1)
use Demo
go

alter database Test set allow_snapshot_isolation on;
-- 잠금이 되어도 데이터를 확인하기 위함
set transaction isolation level snapshot;

begin tran
update Test Set Age = 24 where Id = 1
update Test Set Age = 25 where Id = 2
update Test Set Age = 27 where Id = 3
commit tran
alter database Test set allow_snapshot_isolation off;

-- 견본 (2)
use Demo
go
drop table if exists dbo.BankBook

Create table BankBook
(
    Uname nvarchar(10),
    Umoney int,
    constraint CK_money
        check (Umoney >= 0)
)
go

insert into BankBook
values
    (N'구매자', 1000)
insert into BankBook
values
    (N'판매자', 0)
go

update BankBook set Umoney = Umoney -500 where Uname = N'구매자'
update BankBook set Umoney = Umoney + 500 where Uname = N'판매자'
select *
from BankBook

-- 오류 발생시 롤백 견본
begin try
    begin tran tran1 -- Check 제약 조건이 있을 때에는 롤백이 안됨으로  try catch 문 실행
        update BankBook set Umoney = Umoney - 600 where Uname = N'구매자'
        update BankBook set Umoney = Umoney + 600 where Uname = N'판매자'
    commit tran tran1
end try
begin catch
    select
    ERROR_NUMBER() AS N'오류번호',
    ERROR_STATE() AS N'오류상태',
    ERROR_SEVERITY() AS N'오류 심각도',
    ERROR_PROCEDURE() AS N'오류절차',
    ERROR_LINE() AS N'오류발생 줄번호',
    ERROR_MESSAGE() as N'오류발생 내용';
    rollback tran tran1
end catch
go
--


select *
from BankBook

-- 기타
save tran 저장점이름
rollback tran
set implicit_transactions on -- 반드시 커밋트랜젝션은 선언해야 한다. (오라클 호환)
