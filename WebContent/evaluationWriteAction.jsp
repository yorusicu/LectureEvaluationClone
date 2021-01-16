<%@page import="evaluation.EvaluationDTO"%>
<%@page import="evaluation.EvaluationDAO"%>
<%@page import="user.UserDTO"%>
<%@page import="util.SHA256"%>
<%@page import="user.UserDAO"%>
<%@page import="java.io.PrintWriter"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");
//로그인 검사 ==========================================================
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
	String lectrueName=null;
	String professorName=null;
	int lectureYear=0;
	String semesterDivide =null;
	String lectureDivide =null;
	String evaluationTitle =null;
	String evaluationContent =null;
	String totalScore =null;
	String creditScore =null;
	String comfortableScore =null;
	String lectureScore =null;
	
	
	
	// 
	if(request.getParameter("lectureName")!=null) {
		lectrueName=(String)request.getParameter("lectureName");
	}
	if(request.getParameter("professorName")!=null) {
		professorName=(String)request.getParameter("professorName");
	}
	if(request.getParameter("lectureYear")!=null) {
		try{
		lectureYear=Integer.parseInt(request.getParameter("lectureYear"));
		}catch(Exception e){
			System.out.println("강연 연도 오류");
		}
	}
	if(request.getParameter("semesterDivide")!=null) {
		semesterDivide=(String)request.getParameter("semesterDivide");
	}
	if(request.getParameter("lectureDivide")!=null) {
		lectureDivide=(String)request.getParameter("lectureDivide");
	}
	if(request.getParameter("evaluationTitle")!=null) {
		evaluationTitle=(String)request.getParameter("evaluationTitle");
	}
	if(request.getParameter("evaluationContent")!=null) {
		evaluationContent=(String)request.getParameter("evaluationContent");
	}
	if(request.getParameter("totalScore")!=null) {
		totalScore=(String)request.getParameter("totalScore");
	}
	if(request.getParameter("creditScore")!=null) {
		creditScore=(String)request.getParameter("creditScore");
	}
	if(request.getParameter("comfortableScore")!=null) {
		comfortableScore=(String)request.getParameter("comfortableScore");
	}
	if(request.getParameter("lectureScore")!=null) {
		lectureScore=(String)request.getParameter("lectureScore");
	}
	
	System.out.println("lectrueName: "+lectrueName);
	System.out.println("professorName: "+professorName);
	System.out.println("lectureYear: "+lectureYear);
	System.out.println("semesterDivide: "+semesterDivide);
	System.out.println("lectureDivide: "+lectureDivide);
	System.out.println("evaluationTitle: "+evaluationTitle);
	System.out.println("evaluationContent: "+evaluationContent);
	System.out.println("totalScore: "+totalScore);
	System.out.println("creditScore: "+creditScore);
	System.out.println("comfortableScore: "+comfortableScore);
	System.out.println("lectureScore: "+lectureScore);
	
	if(lectrueName==null||professorName==null||lectureYear==0
			||semesterDivide==null||lectureDivide==null||evaluationTitle==null
			||evaluationContent==null||totalScore==null||creditScore==null
			||comfortableScore==null||lectureScore==null){
		
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('모두 입력해 주세요')");
		script.println("history.back()");
		script.println("</script>");
		script.close();
	}else{
		EvaluationDAO evalDao=new EvaluationDAO();
		int result=evalDao.write(new EvaluationDTO(
				0,userID, lectrueName, professorName, lectureYear
				, semesterDivide, lectureDivide, evaluationTitle
				, evaluationContent, totalScore, creditScore
				, comfortableScore,lectureScore,0));
		
		if(result==-1){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('평가 등록에 실패')");
			script.println("history.back();");
			script.println("</script>");
			script.close();
			return;
		}else{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("location.href='./index.jsp'");
			script.println("</script>");
			script.close();
			return;
		}
	}
%>