-- not null 제약조건 추가
alter table author modify column name varchar(255) not null;
alter table post modify column title varchar(255) not null;
-- not null 제약조건 제거(덮어쓰기)
alter table author modify column name varchar(255);
-- not null, unique 제약조건 동시 추가
alter table author modify column email varchar(255) not null unique;

-- 테이블 차원의 제약조건(PK, FK) 추가/제거
-- 제약조건 삭제(fk)
alter table post drop foreign key 제약조건명;
alter table post drop constraint 제약조건명;
-- 제약조건 삭제(pk)
alter table post drop primary key;
-- 제약조건 추가
alter table post add constraint post_pk primary key(id);
alter table post add constraint post_fk foreign key(author_id) references author(id);

-- on delete/update 제약조건 테스트
-- 부모테이블 데이터 delete시에 자식 fk컬럼 set null, update시에 자식 fk컬럼 cascade
alter table post add constraint post_fk foreign key(author_id) references author(id) on delete set null on update cascade;

-- default옵션
-- enum타입 및 현재시간(current_timestamp)에서 많이 사용
alter table author modify column name varchar(255) default 'anonymous';
-- auto_increment : 입력을 안했을때 마지막에 입력된 가장 큰 값에서 +1만큼 자동으로 증가된 숫자값을 적용
alter table author modify column id bigint auto_increment;
alter table post modify column id bigint auto_increment;

-- uuid 타입
alter table post add column user_id char(36) default(UUID());