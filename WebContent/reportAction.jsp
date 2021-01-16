<%@page import="javax.mail.Transport"%>
<%@page import="javax.mail.Message"%>
<%@page import="javax.mail.internet.InternetAddress"%>
<%@page import="javax.mail.Address"%>
<%@page import="javax.mail.internet.MimeMessage"%>
<%@page import="javax.mail.Session"%>
<%@page import="javax.mail.Authenticator"%>
<%@page import="java.util.Properties"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="user.UserDAO"%>
<%@page import="util.Gmail"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	// 로그인 검사 ==========================================================
	String userID=null;
	// userID세션값이 있으면 userID에 넣어줌
	if(session.getAttribute("userID")!=null){
		userID=(String)session.getAttribute("userID");
	}
	// userID가 비었으면
	if(userID==null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 해주세요')");
		script.println("location.href='userLogin.jsp'");
		script.println("</script>");
		script.close();
	}
	// ==================================================================
	request.setCharacterEncoding("UTF-8");
	String reportTitle=null;
	String reportContent=null;
	
	// reportTilte 리퀘스트값이 있으면
	if(request.getParameter("reportTitle")!=null){
		reportTitle=(String)request.getParameter("reportTitle");
	}
	// reportContent 리퀘스트값이 있으면
	if(request.getParameter("reportContent")!=null){
		reportContent=(String)request.getParameter("reportContent");
	}
	if(reportTitle==null||reportContent==null){
		PrintWriter script=response.getWriter();
		script.println("<script>");
		script.println("alert('입력이 안된 사항이 있습니다')");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		
		return;
	}
	
	// 사용자에게 보낼 메세지 기입
	UserDAO userDao=new UserDAO();
	String host="http://localhost:8080/lecture/";	// 사이트 web루트
	String from=userDao.getUserEmail(userID);		// 보내는 사람 메일주소
	System.out.println("reportAction_from: "+from);
	String to="yorusicu@gmail.com";					// 받는 사람 메일주소
	String subject="강의 평가사이트에서 접수된 신고메일입니다";	// 메일 제목
	String content="신고자: "+userID					// 메일 내용
	+"<br>제목: "+reportTitle+"<br>내용: "+reportContent;	
	
	// SMTP에 접속 정보 기입
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
	
	PrintWriter script = response.getWriter();
	script.println("<script>");
	script.println("alert('정상적으로 신고되었습니다');");
	script.println("history.back();");
	script.println("</script>");
	script.close();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

</body>
</html>