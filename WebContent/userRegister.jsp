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
	String userID=null;
	// userID세션값이 있으면
	if(session.getAttribute("userID")!=null){
		userID=(String)session.getAttribute("userID");
	}
	// userID가 있으면
	if(userID!=null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인이 되어 있습니다')");
		script.println("location.href='index.jsp'");
		script.println("</script>");
		script.close();
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
				<li class="nav-item">
					<a class="nav-link" href="index.jsp">메인</a>
				</li>
				<li class="nav-item dropdown">
					<a id="dropdown" class="nav-link dropdown-toggle" data-toggle="dropdown">회원 관리</a>
					<div class="dropdown-menu" aria-labelledby="dropdown">
<%
	if(userID==null){
%>
						<a class="dropdown-item" href="./userLogin.jsp">로그인</a>
						<a class="dropdown-item active" href="./userRegister.jsp">회원가입</a>
<%
	}else{
%>
						<a href="#" class="dropdown-item"><%=userID %>님</a>
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
	<section class="container mt-3 style="max-width:560px;">
		<form action="./userRegisterAction.jsp" method="post">
			<div class="form-group">
				<label>아이디</label>
				<input type="text"name="userID" class="form-control">
			</div>
			<div class="form-group">
				<label>비밀번호</label>
				<input type="password"name="userPassword" class="form-control">
			</div>
			<div class="form-group">
				<label>이메일</label>
				<input type="email"name="userEmail" class="form-control">
			</div>
			<button type="submit" class="btn btn-primary" style="width:100%;">회원가입</button>
		</form>
	</section>
	
	<footer class="bg-dark mt-4 p-5 text-center" style="position:absolute; bottom:0; height:70px; color:#ffffff;">
		Copyright ⓒ 2021 JIMIBOY All Rights Reserved.(CloneProject)
	</footer>
</body>
</html>