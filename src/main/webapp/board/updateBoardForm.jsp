<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "vo.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.URLEncoder" %>

<%
    // 1. 요청 분석 
    request.setCharacterEncoding("utf-8"); // 한글버전 패치
    String boardNo = request.getParameter("boardNo");

	 // 2. 요청처리
    Class.forName("org.mariadb.jdbc.Driver"); // mariadb 드라이버 로딩
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	String sql = "SELECT board_no boardNo, board_pw boardPw, board_title boardTitle, board_content boardContent, board_writer boardWriter, createdate  FROM board WHERE board_no=?"; 
	PreparedStatement stmt = conn.prepareStatement(sql);	
	stmt.setString(1, boardNo);
	ResultSet rs =stmt.executeQuery();
	
	
	Board b = new Board();
	b.boardNo = 0;
	b.boardPw = null;
	b.boardTitle = null;
	b.boardContent =  null;
	b.boardWriter =  null;
	b.createdate =  null;
	
	if(rs.next()) {
		b.boardNo = Integer.parseInt(boardNo);
		b.boardPw = rs.getString("boardPw");
		b.boardTitle = rs.getString("boardTitle");
		b.boardContent = rs.getString("boardContent");
		b.boardWriter = rs.getString("boardWriter");	
		b.createdate = rs.getString("createdate");
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
		<h2> <p align="center">게시글 수정 </p></h2>
		<!-- msg 파라메타값이 있으면 출력 -->
		<%
			if(request.getParameter("msg") != null){
		%>
			<div><%=request.getParameter("msg") %></div>
		<%
			}
		%>
	
		<form action="<%=request.getContextPath()%>/board/updateBoardAction.jsp">
			<table class="table table-hover w-auot">
				<tr>
					<td><span>게시글 번호</span></td>
					<td>
						<input type="text" name="boardNo" value="<%=b.boardNo%>" readonly="readonly">
					</td>				
				</tr>
				<tr>
					<td><span>비밀번호</span></td> 
					<td>
						<input type="text" name="boardPw" value="">
					</td>				
				</tr>
				<tr>
					<td> <span>제목</span></td>
					<td>
					<input type="text" name="boardTitle" value="<%=b.boardTitle%>"> 
					</td>					
				</tr>
				<tr>
					<td>내용</td>
					<td>
						<textarea rows="8" cols="80" name="boardContent"><%=b.boardContent%></textarea>
					</td>					
				</tr>
				<tr>
					<td>글쓴이</td>
					<td>
					<input type="text" name="boardWriter" value="<%=b.boardWriter%>" readonly="readonly"> 
					</td>					
				</tr>
				<tr>
					<td>생성날짜</td>
					<td>
					<input type="text" name="createdate" value="<%=b.createdate%>" readonly="readonly"> 
					</td>					
				</tr>
					<td colspan="2">
					<button type="submit">수정하기</button>
					</td>				
				</tr>
			</table>
		</form>		
	</body>
</html>