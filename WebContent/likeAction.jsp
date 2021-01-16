<%@page import="likey.LikeyDAO"%>
<%@page import="evaluation.EvaluationDAO"%>
<%@page import="user.UserDTO"%>
<%@page import="util.SHA256"%>
<%@page import="user.UserDAO"%>
<%@page import="java.io.PrintWriter"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%!
/* 서블릿으로 변환되는 클래스에서 <%!는 member field영역으로 <% 는 dervice method영역으로 인식 */
public static String getClientIP(HttpServletRequest request) {
    String ip = request.getHeader("X-FORWARDED-FOR"); 
    
    if (ip == null || ip.length() == 0) {
        ip = request.getHeader("Proxy-Client-IP");
    }
    if (ip == null || ip.length() == 0) {
        ip = request.getHeader("WL-Proxy-Client-IP");
    }
    if (ip == null || ip.length() == 0) {
        ip = request.getRemoteAddr() ;
    }
    return ip;
}
%>
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
	System.out.println("evalID1: "+evaluationID);
	EvaluationDAO evalDao=new EvaluationDAO();
	LikeyDAO likeyDao=new LikeyDAO();
	int result=likeyDao.like(userID, evaluationID, getClientIP(request));
	if(result==1){
		result=evalDao.like(evaluationID);
		if(result==1){
			PrintWriter script=response.getWriter();
			script.println("<script>");
			script.println("alert('추천이 완료되었습니다');");
			script.println("location.href='index.jsp'");
			script.println("</script>");
			script.close();
			return;
		}else{
			PrintWriter script=response.getWriter();
			script.println("<script>");
			script.println("alert('네트워크 오류가 발생했습니다');");
			script.println("history.back();");
			script.println("</script>");
			script.close();
			return;
		}
	}else{
		PrintWriter script=response.getWriter();
		script.println("<script>");
		script.println("alert('이미 추천한 글입니다');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
%>