<%@page import="javax.mail.Transport"%>
<%@page import="javax.mail.Message"%>
<%@page import="javax.mail.Address"%>
<%@page import="javax.mail.internet.InternetAddress"%>
<%@page import="javax.mail.internet.MimeMessage"%>
<%@page import="javax.mail.Session"%>
<%@page import="javax.mail.Authenticator"%>
<%@page import="java.util.Properties"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="user.UserDAO"%>
<%@page import="util.Gmail"%>
<%@page import="util.SHA256"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	UserDAO userDao=new UserDAO();
	String userID=null;
	
	if(session.getAttribute("userID")!=null){
		userID=(String)session.getAttribute("userID");
	}
	if(userID==null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인 해주세요');");
		script.println("location.href='userLogin.jsp'");
		script.println("</script>");
		script.close();
		return;
	}
	
	boolean emailChecked=userDao.getUserEmailChecked(userID);
	if(emailChecked==true){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('이미 인증 된 회원입니다');");
		script.println("location.href='index.jsp'");
		script.println("</script>");
		script.close();
		return;
	}
	
	// 사용자에게 보낼 메세지
	String host="http://localhost:8080/lecture/";	// 사이트 web루트
	String from="yorusicu@gmail.com";				// 보내는 사람 메일주소
	String to=userDao.getUserEmail(userID);			// 받는 사람 메일주소
	String subject="강의 평가를 위한 확인 메일입니다";			// 메일 제목
	String content="다음 링크에 접속해서 이메일 인증을 진행하세요"	// 메일 내용
	+"<br><a href='"+host+"emailCheckAction.jsp?code="	
	+new SHA256().getSHA256(to)+"'>이메일 인증하기</a>";
	
	/* System.out.println("content:"+ content); */
	// SMTP(보내는 메일서버)에 접속하기 위한 정보를 기입
	Properties p=new Properties();
	p.put("mail.smtp.user", from);
	p.put("mail.smtp.host", "smtp.googlemail.com");
	p.put("mail.smtp.port", "465");
	p.put("mail.smtp.starttls.enable", "true");
	p.put("mail.smtp.auth", "true");
	p.put("mail.smtp.debug", "true");
	p.put("mail.smtp.socketFactory.port", "465");
	p.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
	p.put("mail.smtp.socketFactory.fallback", "false");
	
	try{
		Authenticator auth=new Gmail();
		Session ses=Session.getInstance(p, auth);
		ses.setDebug(true);
		MimeMessage msg=new MimeMessage(ses);
		msg.setSubject(subject);
		Address fromAddr=new InternetAddress(from);
		msg.setFrom(fromAddr);
		Address toAddr=new InternetAddress(to);
		msg.addRecipient(Message.RecipientType.TO, toAddr);
		msg.setContent(content, "text/html; charset=UTF-8");
		Transport.send(msg);
	}catch(Exception e){
		e.printStackTrace();
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('오류가 발생했습니다');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		
		return;
	}
%>
<!doctype html>
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
						<a class="dropdown-item active" href="./userRegister.jsp">회원가입</a>
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
		<div class="alert alert-success mt-4" role="alert">
			이메일 주소 인증 메일 전송. 이메일에 들어가서 인증해주세요.
		</div>
	</section>
	
	<footer class="bg-dark mt-4 p-5 text-center" style="position:absolute; bottom:0; height:70px; color:#ffffff;">
		Copyright ⓒ 2021 JIMIBOY All Rights Reserved.(CloneProject)
	</footer>
	</body>
</html>