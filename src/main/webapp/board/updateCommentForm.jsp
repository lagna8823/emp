<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "vo.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.URLEncoder" %>

<%
	//1. 요청분석
	request.setCharacterEncoding("utf-8");
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	String commentContent = request.getParameter("commentContent");
	String commentPw = request.getParameter("commentPw");
	
	System.out.println(boardNo + "" + commentContent + "" + commentPw + "" + commentNo+"!!!!!!!!!!!");

	 // 2. 요청처리
    Class.forName("org.mariadb.jdbc.Driver"); // mariadb 드라이버 로딩
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	String sql = "SELECT board_no boardNo, comment_content commentContent, comment_no commentNo, createdate  FROM comment WHERE board_no=?"; 
	PreparedStatement stmt = conn.prepareStatement(sql);	
	stmt.setInt(1, boardNo);
	ResultSet rs =stmt.executeQuery();
		
	
	Comment c = new Comment();
	c.commentPw = null;
	c.commentContent = null;
	c.commentNo =  0;
	c.creatdate =  null;

	if(rs.next()) {
		boardNo = rs.getInt("boardNo");
		c.commentContent = rs.getString("commentContent");
		c.commentNo =  rs.getInt("commentNo");
		c.creatdate = rs.getString("createdate");
	}
	

	// 3.출력(View) -> 모델데이터를 고객이 원하는 형태로 출력 -> 뷰(리포트)	
%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>insertBoardForm.jsp</title>
		
		<!-- 부트스트랩과의 약속! -->
		<!-- Latest compiled and minified CSS -->
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
		<!-- Latest compiled JavaScript -->
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
		<!-- 제목 작성 -->
		
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
		<h2> <p align="center">댓글 수정 </p></h2>
		<!-- msg 파라메타값이 있으면 출력 -->
		<%
			if(request.getParameter("msg") != null){
		%>
			<div><%=request.getParameter("msg") %></div>
		<%
			}
		%>
	
		<form action="<%=request.getContextPath()%>/board/updateCommentAction.jsp">
			<input type="hidden" name="boardNo" value="<%=boardNo%>">
			<input type="hidden" name="commentNo" value="<%=c.commentNo%>">
			<table>
				<tr>
					<td>내용</td>
					<td>
						<textarea rows="8" cols="80" name="commentContent"><%=c.commentContent%></textarea>
					</td>					
				</tr>
				<tr>
					<td><span>비밀번호</span></td> 
					<td>
						<input type="password" name="commentPw" value="">
					</td>				
				</tr>
				<tr>
					<td colspan="2">
					<button type="submit">수정하기</button>
					</td>				
				</tr>
			</table>
		</form>		
	</body>
</html>