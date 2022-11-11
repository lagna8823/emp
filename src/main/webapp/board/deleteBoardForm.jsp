<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
	// 1. 
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String msg = request.getParameter("msg"); // 수정실패시 리다이렉트시에는 null값이 아니고 에러메세지 유
	//2.
	
	//3.
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>deleteBoardForm.jsp</title>
		
		<!-- 부트스트랩과의 약속! -->
		<!-- Latest compiled and minified CSS -->
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
		<!-- Latest compiled JavaScript -->
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
		<!-- 제목 작성 -->
		<h2> <p align="center">게시글 삭제 </p></h2>
		
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
	<body> 
		<!-- 메뉴 patial jsp 구성-->
		<div>
			<jsp:include page="/inc/menu.jsp"></jsp:include> <!-- include에 한해서는 emp주체? 이기에  -->
		</div>

		<!-- msg 파라메타값이 있으면 출력 -->
		<%
			if(msg != null){
		%>
			<div><%= msg %></div>
		<%
			}
		%>
	
		<form action="<%=request.getContextPath()%>/board/deleteBoardAction.jsp">	
		<input type="hidden" name="boardNo" value="<%=boardNo%>">
		삭제할 비밀번호 : 
		<input type="password" name="boardPw">
		<button type="submit">삭제</button>
		</form>		
	</body>
</html>