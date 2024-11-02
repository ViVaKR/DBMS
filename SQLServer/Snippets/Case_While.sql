-- Case When Then .. End
select 
		번호
		,case
			when 시점 is null then '값없음'
			when 시점 is not null then 시점
			else '--'
		 end as [시점]
		,비고
from
	테이블
where
	case
		when 시점 is null then '값없음'
		when 시점 is not null then 시점
		else '--'
	end = '값없음'

-- While 
declare @i int = 0
while @i < (select COUNT(작업번호) from  테이블)
begin
	Set @i= @i + 1;
	select @i 
end

-- End Line --
