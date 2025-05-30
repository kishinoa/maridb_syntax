-- 사용자 관리
-- 사용자 목록조회
select * from mysql.user;

-- 사용자 생성
create user 'choi'@'%' identified by '4321';

-- 사용자에게 권한부여
grant select on board.author to 'choi'@'%';
grant select, insert on board.* to 'choi'@'%';
grant all priviliegeson board.* to 'choi'@'%';

-- 사용자 권한 회수
revoke select on board.author from 'choi'@'%';
-- 사용자 권한 조회
show grants for 'choi'@'%';
-- 사용자 계정 삭제
drop user 'choi'@'%'