SELECT * FROM user;

DROP TABLE user;

SHOW DATABASES;

SHOW TABLES;

CREATE DATABASE LectureEvaluation;					#데이터베이스 생성

USE LectureEvaluation;									#생성한 데이터베이스에 접속

DROP TABLE evaluation;

# 평가 테이블
CREATE TABLE EVALUATION (
  evaluationID int PRIMARY KEY AUTO_INCREMENT,	#평가 번호
  userID varchar(50),									#작성자 아이디
  lectureName varchar(50),								#강의명
  professorName varchar(50), 							#교수명
  lectureYear INT,										#수강 연도
  semesterDivide varchar(20),							#수강 학기
  lectureDivide varchar(10),							#강의 구분
  evaluationTitle varchar(50),						#평가 제목
  evaluationContent varchar(2048),					#평가 내용
  totalScore varchar(10),								#종합 점수
  creditScore varchar(10),								#성적 점수
  comfortableScore varchar(10),						#널널 점수
  lectureScore varchar(10),							#강의 점수
  likeCount INT											#추천갯수
);

SELECT * FROM evaluation;


# 회원 테이블
CREATE TABLE USER (
  userID varchar(50),									#작성자 아이디
  userPassword varchar(50),							#작성자 비밀번호
  userEmail varchar(50),								#작성자 이메일
  userEmailHash varchar(64),							#이메일 확인 해시값
  userEmailChecked BOOLEAN								#이메일 확인 여부
);

SELECT * FROM USER;

# 추천 테이블
CREATE TABLE LIKEY (
  userID varchar(50), #작성자 아이디
  evaluationID int, #평가 번호
  userIP varchar(50) #작성자 아이피
);

SELECT * FROM likey;

# 추천순
SELECT * 
FROM EVALUATION 
WHERE lectureDivide 
LIKE ? 
AND CONCAT(lectureName, professorName, evaluationTitle, evaluationContent) 
LIKE ? ORDER BY likeCount DESC
LIMIT " + pageNumber * 5 + ", " + pageNumber * 5 + 6;

# 최신순
SELECT * 
FROM EVALUATION 
WHERE lectureDivide 
LIKE ? 
AND CONCAT(lectureName, professorName, evaluationTitle, evaluationContent) 
LIKE ? ORDER BY evaluationID DESC
LIMIT " + pageNumber * 5 + ", " + pageNumber * 5 + 6;
