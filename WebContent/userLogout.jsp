<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%
	session.invalidate();	// 세션 초기화
	/* session.removeAttribute("userID"); */
%>
<script>
	location.href="index.jsp";
</script>