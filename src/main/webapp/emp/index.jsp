<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "vo.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>index.jsp</title>
	</head>
	<body>
		<!-- 메뉴 patial jsp 구성-->
			<div>
				<jsp:include page="/inc/menu.jsp"></jsp:include> <!-- include에 한해서는 emp주체? 이기에  -->
			</div>
		<p class="h1 text-center text-bg-warning rounded-circle" >INDEX</p>
		<li>		
			<a href="<%=request.getContextPath()%>/dept/deptList.jsp">
				<p class="h2 text-center text-bg-warning rounded-circle">부서관리</p>
			</a>		
		</li>
		
	</body>
</html>