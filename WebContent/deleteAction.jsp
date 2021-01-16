<%@page import="evaluation.EvaluationDAO"%>
<%@page import="user.UserDTO"%>
<%@page import="user.UserDAO"%>
<%@page import="java.io.PrintWriter"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");
/* 로그인 확인 ====================================================== */
	String userID = null;
	if(session.getAttribute("userID")!=null){
		userID=(String)session.getAttribute("userID");
	}
	if(userID==null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 해주세요');");
		script.println("location.href='userLogin.jsp'");
		script.println("</script>");
		script.close();
		return;
	}
	/* end 로그인 확인 ====================================================== */	
	String evaluationID=null;
	
	if(request.getParameter("evaluationID")!=null){
		evaluationID=(String)request.getParameter("evaluationID");
	}
	
	EvaluationDAO evalDao=new EvaluationDAO();
	System.out.println("userID: "+userID);
	System.out.println("evaluationID: "+evaluationID);
	System.out.println("evalDao.getUserID(evaluationID): "+evalDao.getUserID(evaluationID));
	if(userID.equals(evalDao.getUserID(evaluationID))){
		int result=new EvaluationDAO().delete(evaluationID);
		
		if(result==1){
			session.setAttribute("userID", userID);
			PrintWriter script=response.getWriter();
			script.println("<script>");
			script.println("alert('삭제가 완료되었습니다');");
			script.println("location.href='index.jsp'");
			script.println("</script>");
			script.close();
			
			return;
		}else{
			session.setAttribute("userID", userID);
			PrintWriter script=response.getWriter();
			script.println("<script>");
			script.println("alert('네트워크 오류가 발생했습니다');");
			script.println("history.back()");
			script.println("</script>");
			script.close();
			
			return;
		}
	}else{
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('자신이 쓴 글만 삭제 가능합니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();

		return;
	}
%>