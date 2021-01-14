<%@page import="user.UserDAO"%>
<%@page import="java.io.PrintWriter"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>강의 평가 웹 사이트</title>
	<!-- 뷰포트와 관련된 메타 설정(반응형 웹)feat.부트스트랩 -->
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<!-- 부트스트랩 CSS 추가하기 -->
	<link rel="stylesheet" href="css/bootstrap.min.css">
	<!-- 커스텀 CSS 추가하기 -->
	<link rel="stylesheet" href="css/custom.css">
	<!-- 제이쿼리 자바스크립트 추가하기 -->
	<script src="./js/jquery-3.5.1.min.js"></script>
	<!-- Popper 자바스크립트 추가하기 -->
	<script src="./js/popper.min.js"></script>
	<!-- 부트스트랩 자바스크립트 추가하기 -->
	<script src="./js/bootstrap.min.js"></script>

</head>
<body>
<%
System.out.println("index_session: "+session.getAttribute("userID"));
	String userID=null;
	// userID세션이 있으면 userID변수에 넣음 
	if(session.getAttribute("userID")!=null){
		// session도 Object라 String으로 형변환
		userID=(String)session.getAttribute("userID");
	}
	// userID가 없으면 로그인창으로
	if(userID==null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 해주세요');");
		script.println("location.href='userLogin.jsp'");
		script.println("</script>");
		script.close();
	}
	
	boolean emailChecked=new UserDAO().getUserEmailChecked(userID);
	// 메일인증이 안했으면 보낸메일 확인 창으로
	if(!emailChecked){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("location.href='emailSendConfirm.jsp'");
		script.println("</script>");
		script.close();
		return;
	}
%>
	<!-- nav 영역 -->
	<nav class="navbar navbar-expand-lg navbar-light bg-light">
		<a class="navbar-brand" href="index.jsp">강의 평가 웹 사이트</a>
		<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbar">
			<span class="navbar-toggler-icon"></span>
		</button>
		<div id="navbar" class="collapse navbar-collapse">
			<ul class="navbar-nav mr-auto">
				<li class="nav-item active">
					<a class="nav-link" href="index.jsp">메인</a>
				</li>
				<li class="nav-item dropdown">
					<a id="dropdown" class="nav-link dropdown-toggle" data-toggle="dropdown">회원 관리</a>
					<div class="dropdown-menu" aria-labelledby="dropdown">
<%
	if(userID==null){			
%>
						<a class="dropdown-item" href="./userLogin.jsp">로그인</a>
						<a class="dropdown-item" href="./userRegister.jsp">회원가입</a>
<%
	}else{
%>
						<a class="dropdown-item" href="./userLogout.jsp">로그아웃</a>
<%
	}
%>
					</div>
				</li>
			</ul>
			<!-- 상단 검색 부분 -->
			<form action="./index.jsp" method="get" class="form-inline my-2 my-lg-0">
				<input type="search" name="search" class="form-control mr-sm-2" placeholder="내용을 입력하세요" >
				<button class="btn btn-outline-success my-2 my-sm-0" type="submit">검색</button>
			</form>
		</div>
	</nav><!-- // nav 영역 -->
	<section class="container">
		<form action="form-inline mt-3" method="get" class="form-inline mt-3">
			<select name="lectureDivide" class="form-control mx-1 mt-2">
				<option value="전체">전체</option>
				<option value="전공">전공</option>
				<option value="교양">교양</option>
				<option value="기타">기타</option>
			</select>
			<input type="text" name="search" class="form-control mx-1 mt-2" placeholder="내용을 입력하세요">
			<button type="submit" class="btn btn-primary mx-1 mt-2">검색</button>
			<a class="btn btn-primary mx-1 mt-2" data-toggle="modal" href="#registerModal">등록하기</a>
			<a class="btn btn-danger mx-1 mt-2" data-toggle="modal" href="#reportModal">신고</a>
		</form>
		<!-- 강의 -->
		<div class="card bg-light mt-3"><!-- 강의 타이틀 -->
			<div class="card-header bg-light">
				<div class="row">
					<div class="col-8 text-left">컴퓨터 개론&nbsp;<small>나동빈</small></div>
					<div class="col-4 text-right">종합<span style="color:red;">A</span></div>
				</div>
			</div><!-- //강의 타이틀 -->
			<!-- 게시글 1개 영역 -->
			<div class="card-body">
				<h5 class="card-title">정말 좋은 강의예요&nbsp;<small>(2017년 가을학기)</small></h5>
				<p class="card-text">강의 평가 내용을 쓰는 부분입니다 많이들 써주세요</p>
				<div class="row">
					<div class="col-9 text-left">
						성적<span style="color:red;">A</span>
						널널<span style="color:red;">B</span>
						강의<span style="color:red;">C</span>
						<span style="color:green;">(추천: 15★)</span>
					</div>
					<div class="col-3 text=right">
						<a onclick="return confirm('추천하시겠습니까?')" href="./likeAction.jsp?evaluationID=">추천</a>
						<a onclick="return confirm('삭제하시겠습니까?')" href="./deleteAction.jsp?evaluationID=">삭제</a>
					</div>
				</div>
			</div><!-- //게시글 1개 영역 -->
		</div><!-- //강의 -->
		<ul class="pagination justify-content-center mt-3">
			<li class="page-item">
				<a class="page-link" href="#">이전</a>
			</li>
			<li class="page-item">
				<a class="page-link" href="#">다음</a>
			</li>
		</ul>
		<!-- 등록하기 -->
		<div class="modal fade" id="registerModal" tabindex="-1" role="dialog" aria-labelledby="modal" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title" id="modal">평가등록</h5>
						<button type="button" class="close" data-dismiss="modal" aria-labal="Close">
							<span aria-hidden="true">&times;</span>
						</button>
					</div><!-- //modal-header -->
					<!-- modal-body -->
					<div class="modal-body">
						<form action="./evaluationRegisterAction.jsp" method="post">
							<!-- form-row -->
							<div class=form-row">
								<div class="form-group">
									<label>강의명</label>
									<input type="text" name="lectureName" class="form-control" maxlength="20" placeholder="강의명을 입력해주세요">
								</div>
								<div class="form-group">
									<label>교수명</label>
									<input type="text" name="professorName" class="form-control" maxlength="20" placeholder="이름을 입력해주세요">
								</div>
							</div>
							<div class="form-row">
								<div class="form-group col-sm-4">
									<label>수강 연도</label>
									<select name="lectureYear" class="form-control">
										<option value="2017">2017</option>
										<option value="2018">2018</option>
										<option value="2019">2019</option>
										<option value="2020">2020</option>
										<option value="2021" selected>2021</option>
										<option value="2022">2022</option>
										<option value="2023">2023</option>
										<option value="2024">2024</option>
										<option value="2025">2025</option>
									</select>
								</div>
								<div class="form-group col-sm-4">
									<label>수강 학기</label>
									<select name="semesterDivide" class="form-control">
										<option name="1학기" selected>1학기</option>
										<option name="여름학기">여름학기</option>
										<option name="2학기">2학기</option>
										<option name="겨울학기">겨울학기</option>
									</select>
								</div>
								<div class="form-group col-sm-4">
									<label>강의 구분</label>
									<select name="lectureDivide" class="form-control">
										<option name="전공" selected>전공</option>
										<option name="교양">교양</option>
										<option name="기타">기타</option>
									</select>
								</div>
							</div>
							<div class="form-group">
								<label>제목</label>
								<input type="text" name="evaluationTitle" class="form-control" placeholder="제목을 입력해주세요" maxlength="20">
							</div>
							<div class="form-group">
								<label>내용</label>
								<textarea type="text" name="evaluationContent" class="form-control" maxlength="2048" placeholder="내용을 입력해주세요" style="resize:none; width:465px; height:180px;"></textarea>
							</div>
							<div class="form-row">
								<div class="form-group col-sm-3">
									<label>종합 평가</label>
									<select name="totalScore" class="form-control">
										<option value="A" selected>A</option>
										<option value="B">B</option>
										<option value="C">C</option>
										<option value="D">D</option>
										<option value="F">F</option>
									</select>
								</div>
								<div class="form-group col-sm-3">
									<label>성적 평가</label>
									<select name="creditScore" class="form-control">
										<option value="A" selected>A</option>
										<option value="B">B</option>
										<option value="C">C</option>
										<option value="D">D</option>
										<option value="F">F</option>
									</select>
								</div>
								<div class="form-group col-sm-3">
									<label>수업 강도</label>
									<select name="comfortableScore" class="form-control">
										<option value="A" selected>A</option>
										<option value="B">B</option>
										<option value="C">C</option>
										<option value="D">D</option>
										<option value="F">F</option>
									</select>
								</div>
								<div class="form-group col-sm-3">
									<label>강의 평가</label>
									<select name="comfortableScore" class="form-control">
										<option value="A" selected>A</option>
										<option value="B">B</option>
										<option value="C">C</option>
										<option value="D">D</option>
										<option value="F">F</option>
									</select>
								</div>
							</div><!-- //form-row(평가dropdown) -->
							<div class="modal-footer">
								<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
								<button type="button" class="btn btn-primary">등록하기</button>
							</div>
						</form>
					</div><!-- //modal-body -->
				</div><!-- //modal-content -->
			</div><!-- //modal-dialog -->
		</div><!-- //등록하기 -->
		<!-- 신고하기 -->
		<div class="modal fade" id="reportModal" tabindex="-1" role="dialog" aria-labelledby="modal" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title" id="modal">신고하기</h5>
						<button type="button" class="close" data-dismiss="modal" aria-label="Close">
							<!-- 곱하기를 왜하는 걸까? = x버튼 표현 -->
							<span aria-hidden="true">&times;</span>
						</button>					
					</div>
					<div class="modal-body">
						<form method="post" action="./reportAction.jsp">
							<div class="form-group">
								<label>신고 제목</label>
								<input type="text" name="reportTitle" class="form-control" maxlength="20">
							</div>
							<div class="form-group">
								<label>신고 내용</label>
								<textarea type="text" name="reportContent" class="form-control" maxlength="2048" style="height:180px; resize:none;"></textarea>
							</div>
							<div class="modal-footter">
								<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
								<button type="submit" class="btn btn-danger">신고하기</button>
							</div>
						</form>
					</div>
				</div><!-- //modal-content -->
			</div><!-- //modal-dialog -->
		</div><!-- //신고하기 -->
	</section>
	
	<footer class="bg-dark mt-4 p-5 text-center">
		Copyright ⓒ 2021 JIMIBOY All Rights Reserved.(CloneProject)
	</footer>
</body>
</html>