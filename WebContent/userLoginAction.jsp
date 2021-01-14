<%@page import="user.UserDTO"%>
<%@page import="util.SHA256"%>
<%@page import="user.UserDAO"%>
<%@page import="java.io.PrintWriter"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");
	String userID = null;
	String userPassword = null;
	
	if (request.getParameter("userID") != null) {
		userID = request.getParameter("userID");
	}
	if (request.getParameter("userPassword") != null) {
		userPassword = request.getParameter("userPassword");
	}
	
	UserDAO userDao = new UserDAO();
	int result=userDao.login(userID, userPassword);
	System.out.println("result: "+ result);
	
	if(result==1){
		session.setAttribute("userID", userID);
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("location.href='index.jsp'");
		script.println("</script>");
		script.close();
	}else if(result == 0){
		session.setAttribute("userID", userID);
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('비밀번호가 틀립니다');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
	}else if(result == -1){
		session.setAttribute("userID", userID);
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('존재하지 않는 아이디입니다');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
	}else if(result == -2){
		session.setAttribute("userID", userID);
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('네트워크 오류가 발생했습니다');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
	}
%>