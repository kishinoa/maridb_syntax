-- read uncommitted : 커밋되지 않은 데이터 read가능 -> dirty read 문제 발생
-- 실습절차
-- 1) 워크벤치에서 auto_commit해제, update 후 commit하지 않음
-- 2) 터미널을 열어 select 했을때 변경사항이 읽히는지 확인
-- 결론 : mariadb는 기본이 repeatable read 이므로 dirty read 발생하지 않음

-- read committed : 커밋한 데이터만 read가능 -> phantom read 발생(또는 non repeatable read)
-- 워크벤치에서 실행행
start transaction;
select count(*) from author;
do sleep(15);
select count(*) from author;
-- 터미널에서 실행
insert into author(email) values('xxxxx@naver.com');
-- repeatable read : 읽기의 일관성 보장 -> lost update 문제 발생 -> 베타적 잠금으로 해결
-- lost update 문제 발생
DELIMITER //
create procedure concurrent_test1()
begin
    declare count int;
    start transaction;
    insert into post(title, author_id) values('hello world', 1);
    select post_count into count from author where id = 1;
    do sleep(15);
    update author set post_count = count + 1 where id = 1;
    commit;
end//
DELIMITER ;
-- 터미널에서는 아래코드실행
select post_count from author where id = 1;
-- lost update 문제 해결 : select for update시에 트랜잭션이 종료후에 특정 행에 대한 lock이 풀림 -> 성능저하하
DELIMITER //
create procedure concurrent_test1()
begin
    declare count int;
    start transaction;
    insert into post(title, author_id) values('hello world', 1);
    select post_count into count from author where id = 1 for update;
    do sleep(15);
    update author set post_count = count + 1 where id = 1;
    commit;
end//
DELIMITER ;
-- 터미널에서는 아래코드실행
select post_count from author where id = 1 for update;

-- serializable : 모든 트랜잭션 순차적 실행 -> 동시성 문제 없으나 성능 저하