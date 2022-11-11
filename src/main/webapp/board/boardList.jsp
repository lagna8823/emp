<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	// 1. 요청분석
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	// 2. 요청처리 후 필요하다면 모델데이터를 생성
	final int ROW_PER_PAGE = 10; // 상수 선언 문법
	int beginRow = (currentPage-1)*ROW_PER_PAGE; // ... Limit beginRow, ROW_PER_PAGE
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234");
	
	// 2-1
	String cntSql = "SELECT COUNT(*) cnt FROM board";
	PreparedStatement cntStmt = conn.prepareStatement(cntSql);
	ResultSet cntRs = cntStmt.executeQuery();
	int cnt = 0; // 전체 행의 수
	if(cntRs.next()) {
		cnt = cntRs.getInt("cnt");
	}
	
	// 올림 5.3 -> 6.0, 5.0->5.0
	int lastPage = (int)(Math.ceil((double)cnt / (double)ROW_PER_PAGE));
	
	// 2-2
	String listSql = "SELECT board_no boardNo, board_title boardTitle FROM board ORDER BY board_no ASC LIMIT ?, ?";
	PreparedStatement listStmt = conn.prepareStatement(listSql);
	listStmt.setInt(1, beginRow);
	listStmt.setInt(2, ROW_PER_PAGE);
	ResultSet listRs = listStmt.executeQuery(); // 모델 source data
	ArrayList<Board> boardList = new ArrayList<Board>(); // 모델의 new data
	while(listRs.next()) {
		Board b = new Board();
		b.boardNo = listRs.getInt("boardNo");
		b.boardTitle = listRs.getString("boardTitle");
		boardList.add(b);
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>boardList</title>
</head>
<body>
	<!-- 메뉴 partial jsp 구성 -->
	<div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>
	
	<h1>자유 게시판</h1>
	<div>
		<a href="<%=request.getContextPath()%>/board/insertBoardForm.jsp?">게시글 입력</a>
	</div>
	<!-- 3-1. 모델데이터(ArrayList<Board>) 출력 -->	
	<table border="1">
		<tr>
			<th>번호</th>
			<th>제목</th>
		</tr>
		
		<%
			for(Board b : boardList) {
		%>
				<tr>
					<td><%=b.boardNo%></td>
					<!-- 제목 클릭시 상세보기 이동 -->
					<td>
						<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=b.boardNo%>">
							<%=b.boardTitle%>
						</a>
					</td>
				</tr>
		<%		
			}
		%>
	</table>
	
	<!-- 3-2. 페이징 -->
	<div>
		<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=1">처음</a>
		
		<%
			if(currentPage > 1) {
		%>
				<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage-1%>">이전</a>
		<%		
			}
		%>
		
		<span><%=currentPage%></span>
		
		<%
			if(currentPage < lastPage) {
		%>
				<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage+1%>">다음</a>	
		<%		
			}
		%>
		
		<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=lastPage%>">마지막</a>
	</div>
</body>
</html>