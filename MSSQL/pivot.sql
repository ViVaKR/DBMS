-- 타입 (1)
select 번호
	, [10001] as 업체_1
	, [10002] as 업체_2
	, [10003] as 업체_3
from 
	(
		select 
			번호
			, 업체
			, 합계대상_컬럼
			
		from 테이블명
	) as result pivot 
	(
		sum(합계대상_컬럼) for 업체 in ([10001], [10002], [10003])
	) as pivoit_result
