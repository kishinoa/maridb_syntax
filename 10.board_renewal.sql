-- 사용자 테이블 생성
create table author (
	id 			bigint PRIMARY KEY auto_increment,
    email		varchar(50) not null,
    name		varchar(100),
    password	varchar(255) not null
);

-- post 테이블
create table post (
	id			bigint primary key auto_increment,
    title		varchar(255) not null,
    contents	varchar(10000)
);

-- 주소 테이블 생성성
create table address (
	id			bigint primary key auto_increment,
    country		varchar(255),
    city		varchar(255),
    street		varchar(255),
    author_id	bigint not null,
    foreign key(author_id) references author(id)
);

-- 연결 테이블
create table author_post (
	id			bigint primary key auto_increment,
    post_id		bigint not null,
    author_id	bigint not null,
    foreign key(post_id) references post(id),
    foreign key(author_id) references author(id)
);

-- 복합키를 이용한 연결테이블생성
-- 연결 테이블
create table author_post2 (
    post_id		bigint,
    author_id	bigint,
    primary key(post_id, author_id),
    foreign key(post_id) references post(id),
    foreign key(author_id) references author(id)
);


-- 회원가입 및 주소생성
DELIMITER //
create procedure insert_author(in emailInput varchar(255), in nameInput varchar(255), in passwordInput varchar(255),in countryInput varchar(255), in cityInput varchar(255), in streetInput varchar(255))
begin
    declare exit handler for SQLEXCEPTION
    begin
        rollback;
    end;
    start transaction;
    insert into author(email, name, password) values (emailInput, nameInput, passwordInput);
    insert into address(author_id, country, city, street) values((select id from author order by id desc limit 1) , countryInput, cityInput, streetInput);
    commit;
end //
DELIMITER ;

-- 글쓰기
DELIMITER //
create procedure insert_post(in titleInput varchar(255), in contentsInput varchar(255), in emailInput varchar(255))
begin
    declare exit handler for SQLEXCEPTION
    begin
        rollback;
    end;
    start transaction;
    insert into post(title, contents) values (titleInput, contentsInput);
    insert author_post(author_id, post_id) values((select id from author where email=emailInput), (select id from post order by id desc limit 1));
    commit;
end //
DELIMITER ;

-- 글편집하기
DELIMITER //
create procedure edit_post(in titleInput varchar(255), in contentsInput varchar(255), in emailInput varchar(255), in idInput bigint)
begin
    declare exit handler for SQLEXCEPTION
    begin
        rollback;
    end;
    start transaction;
    update post set title=titleInput, contents=contentsInput where id=idInput;
    insert author_post(author_id, post_id) values((select id from author where email=emailInput), idInput);
    commit;
end //
DELIMITER ;

-- 모든 테이블 조인 후 조회
select * from author a inner join address ad on a.id = ad.author_id inner join author_post ap on a.id = ap.author_id inner join post p on ap.post_id = p.id;