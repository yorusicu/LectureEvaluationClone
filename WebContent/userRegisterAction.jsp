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
	String userEmail = null;
	
	if (request.getParameter("userID") != null) {
		userID = request.getParameter("userID");
	}
	if (request.getParameter("userPassword") != null) {
		userPassword = request.getParameter("userPassword");
	}
	if (request.getParameter("userEmail") != null) {
		userEmail = request.getParameter("userEmail");
	}
	// 입력이 하나라도 안됐을 경우
	if (userID == null || userPassword == null || userEmail == null) {
		// 응답출력
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('입력이 안된 사항이 있습니다');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
	} else {
		UserDAO userDao = new UserDAO();
		int result = userDao.join(new UserDTO(userID, userPassword
				, userEmail, SHA256.getSHA256(userEmail), false));
		System.out.println("result: "+ result);
		
		if(result==-1){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('이미 존재하는 아이디입니다');");
			script.println("history.back();");
			script.println("</script>");
			script.close();
		}else{
			session.setAttribute("userID", userID);
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("location.href='emailSendAction.jsp'");
			script.println("</script>");
			script.close();
		}
	}
%>