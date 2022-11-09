<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "vo.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>insertDeptForm.jsp</title>
		
		<!-- 부트스트랩과의 약속! -->
		<!-- Latest compiled and minified CSS -->
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
		<!-- Latest compiled JavaScript -->
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
		<!-- 제목 작성 -->
		<h2> <p align="center">부서 추가하기 </p></h2>
		
		<!-- 테이블 스타일 -->
		<style>
			table {
				width: 60%;
				height: 100px;
				margin: auto;
				text-algin:center;
			}	
		</style>
	</head>
	<body> <!-- 폼작성 -->
		<!-- 메뉴 patial jsp 구성-->
		<div>
			<jsp:include page="/inc/menu.jsp"></jsp:include> <!-- include에 한해서는 emp주체? 이기에  -->
		</div>
		<br>	
		<!-- msg 파라메타값이 있으면 출력 -->
		<%
			if(request.getParameter("msg") != null){
		%>
			<div><%=request.getParameter("msg") %></div>
		<%
			}
		%>
	
		<form action="<%=request.getContextPath()%>/dept/insertDeptAction.jsp">
			<table>
				<tr>
					<td>
						<span>부서번호</span>
					</td>
					<td>
						<input type="text" name="deptNo" value="">
					</td>				
				</tr>
				<tr>
					<td>부서명</td>
					<td>
					<input type="text" name="deptName" value="">
					</td>				
				</tr>
				<tr>
					<td colspan="2">
					<button type="submit">추가하기</button>
					</td>				
				</tr>
			</table>
		</form>		
	</body>
</html>