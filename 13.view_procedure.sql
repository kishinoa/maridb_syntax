-- view : 실제데이터를 참조만 하는 가상의 테이블, SELECT만 가능
-- 사용목적 : 1) 복잡한쿼리를 사전생성 2) 권한 분리
-- view생성
create view author_for_vw as select name, email from author;

-- view조회
select * from author_for_vw;

-- view권한부여
grant select on board.author_for_vw to '계정명'@'%';

-- view삭제
drop view author_for_vw;

-- 프로시저
delimiter //
create procedure hello_procedure()
begin
    select "hello world";
end
// delimiter ;

-- 프로시저 호출
call hello_procedure();

-- 프로시저 삭제
drop procedure hello_procedure();

-- 회원목록조회 : 한글명 프로시저 가능
delimiter //
create procedure 회원목록조회()
begin
    select * from author;
end
// delimiter ;

-- 회원상세조회 : input값 사용 가능
delimiter //
create procedure 회원상세조회(in emailInput varchar(255))
begin
    select * from author where email = emailInput;
end
// delimiter ;

-- 글쓰기
delimiter //
create procedure 글쓰기(in emailInput varchar(255), in titleInput varchar(255), in contentsInput varchar(255))
begin
-- declare는 시작하는 begin 밑에 위치
    declare exit handler for SQLEXCEPTION
    begin
        rollback;
    end;
    start transaction;
        select id into @author_id from author where email = emailInput;
        insert into post(title, contents) values(titleInput, contentsInput);
        select id into @post_id from post order by id desc limit 1;
        insert into author_post(author_id, post_id) values(@author_id, @post_id);
    commit;
end
// delimiter ;

-- 여러명이 편집가능한 글에서 글삭제
delimiter //
create procedure 글삭제(in postIdInput bigint, in emailInput varchar(255))
begin
-- 글쓴이가 나밖에 없는경우 : author_post삭제, post 삭제
-- 글쓴이가 나 이외에 다른사람도 있는경우 : author_post만 삭제
    select count(*) into @authorCount from author_post where post_id = postIdInput;
    select id into @author_id from author where email = emailInput;
    if @authorCount = 1 then
        delete from author_post where post_id = postIdInput;
        delete from post where id = postIdInput;
-- elseif도 가능
    else
        delete from author_post where post_id = postIdInput and author_id = @author_id;
    end if;
end
// delimiter ;

-- 반복문을 통한 post 대량생산
delimiter //
create procedure 대량글쓰기(in countInput bigint, in emailInput varchar(255))
begin
    declare countValue bigint default 0;
    while countValue < countInput do
        select id into @author_id from author where email = emailInput;
        insert into post(title) values('안녕하세요');
        select id into @post_id from post order by id desc limit 1;
        insert into author_post(author_id, post_id) values(@author_id, @post_id);
        set countValue = countValue + 1;
    end while;
end
// delimiter ;