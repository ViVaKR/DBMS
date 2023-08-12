use TutorialDB
go
--insert into tblGender values(3, 'Unknown'), (2, 'Female')

--select * from tblGender


--insert into tblPerson 
--values 
--(1, 'John', 'j@j.com', 1),
--(2, 'Mary', 'mn@j.com', null),
--(3, 'Jade', 'jd@j.com', 1),
--(4, 'Rob', 'rb@j.com', null),
--(5, 'May', 'ma@j.com', 2),
--(6, 'Kristy', 'k@j.com', 1)

create table tblFullText
(
    Id int constraint pk_id primary key identity,
    contant nvarchar(max) not null
);


insert into tblFullText values
('전체 텍스트 검색은 전체 텍스트 엔진을 통해 수행됩니다. 전체 텍스트 엔진은 인덱싱 지원과 쿼리 지원의 두 가지 역할을 수행합니다.'),
('탐색이라고도 하는 전체 텍스트 채우기가 시작되면 전체 텍스트 엔진은 대용량 데이터 일괄 처리를 메모리에 밀어 넣고 필터 데몬 호스트에 알립니다. 호스트가 데이터를 필터링하고 데이터의 단어를 분리하며 변환된 데이터를 반전된 단어 목록으로 변환합니다. 그런 다음 전체 텍스트 검색은 변환된 데이터를 단어 목록에서 끌어오고 데이터를 처리하여 중지 단어를 제거하며 하나의 일괄 처리에 대한 단어 목록을 하나 이상의 반전된 인덱스를 통해 유지합니다.'),
('인덱싱 데이터가 varbinary(max) 또는 image 열에 저장되어 있으면 IFilter 인터페이스를 구현하는 필터는 해당 데이터에 지정된 파일 형식(예: Microsoft Word)을 기준으로 텍스트를 추출합니다. 필터 구성 요소에서 varbinary(max) 또는 image 데이터를 메모리에 밀어넣는 대신 filterdata 폴더에 기록해야 하는 경우도 있습니다.'),
('채우기가 완료되면 인덱스 조각을 하나의 마스터 전체 텍스트 인덱스로 병합하는 최종 병합 프로세스가 실행됩니다. 이렇게 하면 많은 인덱스 조각 대신 마스터 인덱스만 쿼리하면 되기 때문에 쿼리 성능이 향상되며 개선된 평가 통계를 사용하여 관련성 등급을 지정할 수 있습니다.'),
('쿼리 프로세서는 쿼리의 전체 텍스트 부분을 처리하기 위해 전체 텍스트 엔진에 전달합니다. 전체 텍스트 엔진은 단어 분리를 수행하고 필요에 따라 동의어 사전 확장, 형태소 분석 및 중지 단어(의미 없는 단어) 처리도 수행합니다. 그러면 쿼리의 전체 텍스트 부분은 SQL 연산자 형식, 주로 STVF(스트리밍 테이블 반환 함수)로 표시됩니다. 쿼리를 실행하는 동안 이러한 STVF는 반전된 인덱스에 액세스하여 올바른 결과를 검색합니다. 결과는 이 시점에서 클라이언트에 반환되거나 추가로 처리된 후 클라이언트에 반환됩니다.'),
('전체 텍스트 인덱스의 정보는 전체 텍스트 엔진이 테이블에서 특정 단어나 단어 조합을 빠르게 검색할 수 있는 전체 텍스트 쿼리를 컴파일하는 데 사용됩니다. 전체 텍스트 인덱스는 하나 이상의 데이터베이스 테이블 열에 중요한 단어와 그 위치에 대한 정보를 저장합니다. 전체 텍스트 인덱스는 SQL Server용 전체 텍스트 엔진이 작성하고 유지 관리하는 특수한 유형의 토큰 기반 인덱스입니다. 전체 텍스트 인덱스의 작성 과정은 다른 유형의 인덱스를 작성하는 것과 다릅니다. 특정 행에 저장된 값을 기준으로 B-트리 구조를 생성하는 대신 전체 텍스트 엔진은 인덱싱되는 텍스트의 개별 토큰을 기준으로 반전된 누적 압축 인덱스 구조를 작성합니다. 전체 텍스트 인덱스 크기는 SQL Server 인스턴스가 실행되는 컴퓨터의 사용 가능한 메모리 리소스에 의해서만 제한됩니다.'),
('예를 들어 조각 1을 보여 주는 아래 표에서는 Document 테이블의 Title 열에 생성된 전체 텍스트 인덱스의 내용을 설명합니다. 전체 텍스트 인덱스에는 이 표에 표시되어 있는 것보다 많은 정보가 포함되어 있습니다. 이 표는 전체 텍스트 인덱스를 논리적으로 표현한 것이며 설명 목적으로만 제공됩니다. 행은 디스크 사용률을 최적화하기 위해 압축된 형식으로 저장됩니다.
데이터는 원래 문서와 다르게 반전되었습니다. 왜냐하면 키워드가 문서 ID로 매핑되기 때문입니다. 따라서 전체 텍스트 인덱스를 반전된 인덱스라고 부르기도 합니다.')
go

--  카탈로그 생성
create fulltext catalog movieCatalog as default;
go


create fulltext index on dbo.tblFullText(contant)
Key index pk_id
on movieCatalog
with Change_Tracking Auto;
go

-- fullText Index  확인
select * from sys.dm_fts_index_keywords(db_id(), object_id('dbo.tblFullText'))

-- 삭제
drop fulltext index on FullText;

-- 중지 목록
USE [TutorialDB]
GO
ALTER FULLTEXT STOPLIST [StopKeyWord] ADD '및' LANGUAGE 'Korean';
ALTER FULLTEXT STOPLIST [StopKeyWord] ADD '수' LANGUAGE 'Korean';
ALTER FULLTEXT STOPLIST [StopKeyWord] ADD '없' LANGUAGE 'Korean';
ALTER FULLTEXT STOPLIST [StopKeyWord] ADD '보여' LANGUAGE 'Korean';
ALTER FULLTEXT STOPLIST [StopKeyWord] ADD '용' LANGUAGE 'Korean';
ALTER FULLTEXT STOPLIST [StopKeyWord] ADD '을' LANGUAGE 'Korean';
GO

select * from sys.fulltext_indexes

-- 전체 텍스트 검색 실행
select * from tblFullText Where contains(contant, '반전')

-- End Line --
