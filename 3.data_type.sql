-- tinyint : -128 ~ 127까지 표현(unsigned시에 0~255까지)
-- author테이블에 age 컬럼 변경
alter table author modify column age tinyint unsigned;

-- int : 4바이트(대략, 40억 숫자범위)

-- bigint : 8바이트
-- author, post 테이블의 id 값 bigint로 변경
alter table author modify column id bigint;

-- decimal(총자리수, 소수부자리수)
alter table post add column price decimal(10, 3);
insert into post(id, title, price, author_id) values(7, 'hello', 10.33412, 3)

-- 문자타입 : 고정길이(char), 가변길이(varchar, text)
alter table author add column gender char(10);
alter table author add column self_introduction text;

-- blob(바이너리데이터) 타입 실습
-- 일반적으로 blob으로 저장하기 보다, varchar로 설계하고 이미지 경로만을 저장함
alter table author add column profile_image longblob;
insert into author(id, email, profile_image) values(8, 'aas@naver.com', LOAD_FILE(C:\\cat.jpg));

-- enum : 삽입될 수 있는 데이터의 종류를 한정하는 데이터 타입
alter table author add column role enum('admin', 'user') not null default 'user';
-- enum에 지정된 값인 경우
insert into author(id, email, role) values(9, 'sss@naver.com', 'admin');
-- role을 지정하지지 않은 경우
insert into author(id, email) values(10, 'ssh@naver.com');
-- 지정된 값 이외의 값을 넣은 경우
insert into author(id, email, role) values(11, 'ssd@naver.com', 'admin2');

-- date와 datetime
-- 날짜타입의 입력, 수정, 조회시에 문자열 형식을 사용
alter table author add column birthday date;
alter table post add column created_time datetime;
insert into post(id, title, author_id, created_time) values(8, 'hello', 3, '2025-05-23 14:36:30')
alter table post modify column created_time datetime default current_timestamp();

-- 비교연산자
select * from author where id >= 2 and id <= 4;
select * from author where id between 2 and 4; -- 위 구문과 같은 결과
select * from author where id in (2, 3, 4); -- 위 구문과 같은 결과

-- like : 특정 문자를 포함하는 데이터를 조회하기 위한 키워드
select * from post where title like 'hello%';

-- regexp : 정규표현식을 활용한 조회
select * from post where title regexp '[a-z]'; -- 하나라도 알파벳 소문자가 들어있으면
select * from post where title regexp '[가-힣]'; -- 하나라도 한글이 있으면

-- 숫자 -> 날짜
select cast(20250523 as date); -- 2025-05-23
-- 문자 -> 날짜
select cast('20250523' as date); -- 2025-05-23
-- 문자 -> 숫자
select cast('12' as unsigned);

-- 날짜조회 방법 : 2025-05-23 14:30:25
-- like패턴, 부등호 활용, date_format
select * from post where created_time like '2025-05%'; -- 문자열처럼 조회
-- 5월 1일 부터 5월 20일 까지, 날짜만 입력시 시간구분은 00:00:00이 자동으로 붙음음
select * from post where created_time >= '2025-05-01' and created_time <= '2025-05-21';
select * from post where created_time between '2025-05-01' and '2025-05-20';

select date_format(created_time, '%Y-%m-%d') as '날짜만' from post;
select date_format(created_time, '%H:%i:%s') as '시간만' from post;
select * from post where date_format(created_time, '%m') = '05';

select * from post where cast(date_format(created_time, '%m') as unsigned) = 5;