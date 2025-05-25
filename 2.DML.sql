-- insert : 테이블에 데이터 삽입
insert into 테이블명(컬럼1, 컬럼2, 컬럼3) values(데이터1, 데이터2, 데이터3);
insert into author(id, name, email) values(3, 'hong3', 'hong3@naver.com') -- 문자열은 일반적으로 ''사용
-- update : 테이블에 데이터 변경
update author set name = '홍길동', email = 'hong100@naver.com' where id = 3;
-- select : 조회
select 컬럼1, 컬럼2 from 테이블명;
select name, email from author;
select * from author;
-- delete : 삭제 => 복구 가능한 삭제(로그O)
delete from 테이블명 where 조건;
delete from author where id = 3;
-- truncate : 삭제 => 복구 불가능한 삭제(로그X)
truncate table author;

-- select 조건절 활용 조회
-- 테스트 데이터 삽입 : insert문을 활용해서 author 데이터 3개, post데이터 5개
select * from author; -- 어떤 조회조건없이 모든 컬럼 조회
select * from author where id = 1; -- where 뒤에 조회조건을 통해 filtering
select * from author where name = 'hong1';
select * from author where id > 3 and name = 'kim1';
select * from author where id in (1, 3, 5);
select * from post where author_id in (select id from author where name = 'hong1');

-- 중복제거 조회 : distinct
select distinct name from author;

-- 정렬 : order by + 컬럼명
-- asc : 오름차순, desc : 내림차순, 안붙이면 오름차순(default)
-- 아무런 정렬조건 없이 조회할 경우 pk기준으로 오름차순
select * from author order by name desc;

-- 멀티컬럼 order by : 여러컬럼으로 정렬시에, 먼저쓴 컬럼 우선정렬, 중복시 그 다음 정렬옵션 적용
select * from author order by name desc, email asc; -- name으로 먼저 정렬후, name이 중복되면 email로 정렬

-- 결과값 개수 제한
select * from author order by id desc limit 1;

-- 별칭(alias)을 이용한 select
select name as '이름', email as '이메일', password as '비밀번호' from author
select a.name, a.email, a.password from author as a
select a.name, a.email, a.password from author a

-- null을 조회조건으로 활용
select * from author where password is null;
select * from author where password is not null;

-- 프로그래머스 DB 문제풀기
