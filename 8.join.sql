-- post테이블의 author_id값을 nullable하게 변경
alter table post modify column author_id bigint;

-- inner join
-- 두 테이블 사이에 지정된 조건에 맞는 레코드만을 반환, on 조건을 통해 교집합찾기
-- 즉, post테이블에 글쓴적이 있는 author와 글쓴이가 author에 있는 post 데이터를 결합하여 출력
select * from author inner join post on author.id = post.author_id;
select * from author a inner join post p on a.id = p.author_id;
-- 출력순서만 달라질뿐 위 쿼리와 아래쿼리는 동일
select * from post p inner join author a on p.author_id = a.id;
-- 만약 같게 하고 싶다면
select a.*, p.* from post p inner join author a on p.author_id = a.id;

-- 글쓴이가 있는 글 전체 정보와 글쓴이의 이메일만 출력하시오.
-- post에 글쓴이가 없는데이터는 제외, 글쓴이중에 글쓴적 없는 사람도 제외
select p.*, a.email from post p inner join author a on a.id = p.author_id;
-- 글쓴이가 있는 글의 제목, 내용, 그리고 글쓴이의 이름만 출력하시오
select p.title, p.content, a.name from post p inner join author a on a.id = p.author_id;

-- A left join B : A테이블의 데이터는 모두 조회하고, 관련있는(ON 조건) B의 테이터를 출력
-- 글쓴이는 모두 출력하되, 글을 쓴적 있다면 관련 글도 같이 출력하라
select * from author a left join post p on a.id = p.author_id;
-- 모든 글목록을 출력하고, 만약 저자가 있다면 이메일정보를 출력
select p.*, a.email from post p left join author a on p.author_id = a.id;
-- 모든 글 목록을 출력하고, 관련된 저자 정보 출력(author_id가 not null이라면)
-- 아래 두 쿼리는 동일일
select * from post p left join author a on p.author_id = a.id;
select * from post p inner join author a on p.author_id = a.id;

-- 실습)글쓴이가 있는 글 중에서 글의 title과 저자의 emial을 출력하되, 저자의 나이가 30세 이상인 글만 출력하겠다
select p.title, a.email from author a inner join post p on a.id = p.author_id where a.age >= 30;
-- 전체 글 목록을 조회하되, 글의 저자의 이름이 비어져 있지 않은 글목록만을 출력
select p.*, a.name from post p left join author a on a.id = p.author_id where a.name is not null;

-- 조건에 맞는 도서와 저자 리스트 출력
-- 없어진 기록 찾기

-- union : 두 테이블의 select 결과를 횡으로 결합(기본적으로 distinct가 적용)
-- union시킬때 컬럼의 개수와 컬럼의 타입이 같아야함
select name, email from author union select title, content from post;
-- union all : 중복까지 모두 포함
select name, email from author union all select title, content from post;

-- 서브쿼리 : select문 안에 또 다른 select문을 서브쿼리라 한다.
-- where절 안에 서브쿼리
-- 한번이라도 글을 쓴 author 목록 조회
select * from author where id in (select author_id from post);
-- 컬럼 위치에 서브쿼리
-- author의 email과 author별로 본인의 쓴 글의 개수를 출력
select email, (select count(*) from post p where p.author_id = a.id) from author a;
-- from절 위치에 서브쿼리
select * from (select * from author where id = 5);

-- group by 컬럼명 : 특정 컬럼으로 데이터를 그룹화 하여 하나의 행 취급
select author_id from post group by author_id;
-- 보통 아래와 같이 집계함수와 같이 많이 사용
select author_id, count(*) from post group by author_id;

-- 집계함수
-- null은 count에서 제외
select count(*) from author;
select sum(price) from post;
select avg(price) from post;
-- 소수점 3번째 자리에서 반올림
select round(avg(price), 3) from post;

-- group by 와 집계함수
select author_id, count(id), sum(price) from post group by author_id;
-- where와 group by
-- 날짜별 post 글의 개수 출력(null은 제외)
select date_format(created_time, '%Y-%m-%d') as day, count(*) from post where created_time is not null group by date_format(created_time, '%Y-%m-%d');
-- 자동차 종류 별 특정 옵션이 포함된 자동차 수 구하기
-- 입양 시각 구하기(1)
-- group by 와 having
-- having은 group by를 통해 나온 집계값에 대한 조건
-- 글을 2번이상 쓴 사람 id 찾기
select author_id, count(*) from post group by author_id having count(*) >= 2;
-- 동명 동물 수 찾기
-- 카테고리 별 도서 판매량 집계하기
-- 조건에 맞는 사용자와 총 거래금액 조회하기

-- 다중열 group by
-- group by 첫번째컬럼, 두번째컬럼 : 첫번째컬럼으로 먼저 grouping이후에 두번째컬럼으로 grouping
select author_id, title, count(*) from post group by author_id, title;
-- 재구매가 일어난 상품과 회원 리스트 구하기
