<%@page import="user.UserDTO"%>
<%@page import="util.SHA256"%>
<%@page import="user.UserDAO"%>
<%@page import="java.io.PrintWriter"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");
	String code=request.getParameter("code");
	UserDAO userDao=new UserDAO();
	String userID = null;
	// userID세션이 있으면 userID변수에 넣어줌 
	if (session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
	}
	// userID가 없으면 alert창을 띄우고 넘어감
	if(userID==null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 해주세요');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
	String userEmail=userDao.getUserEmail(userID);
	// 암호화된 mail과 code가 같음 참, 아님 거짓
	boolean rightCode=(new SHA256().getSHA256(userEmail).equals(code))?true:false;
	// rightCode가 거짓일 때
	if(!rightCode){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('유효하지 않은 코드입니다');");
		script.println("location.href='index.jsp");
		script.println("</script>");
		script.close();
		return;
	}else{
		// 참일 경우
		userDao.setUserEmailChecked(userID);
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('인증에 성공하였습니다');");
		script.println("location.href='index.jsp'");
		script.println("</script>");
		script.close();
		return;
	}
%>