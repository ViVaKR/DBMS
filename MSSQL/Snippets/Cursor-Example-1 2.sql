declare @NO int

declare cs cursor for
	select 작업번호 from 문제점
	for update of 발생일자

open cs

	fetch next from cs into @NO
	while @@FETCH_STATUS = 0
		begin
				begin

					update 문제점 set 발생일자 = 
					(select 발생시점 from 참조테이블 Where 작업번호 = @NO)
					where current of cs
				end

			fetch next from cs into @NO
		end

close cs

deallocate cs


--


