<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%

	// 1. 요청분석
	String word = request.getParameter("word");
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
	String cntSql = null;
	String listSql = null;
	PreparedStatement cntStmt = null;
	PreparedStatement listStmt = null;
	if(word == null || word.equals("")) {
   		listSql = "SELECT board_no boardNo, board_title boardTitle FROM board ORDER BY board_no ASC LIMIT ?, ?";
		listStmt = conn.prepareStatement(listSql);
		listStmt.setInt(1, beginRow);
		listStmt.setInt(2, ROW_PER_PAGE);
		cntSql = "SELECT COUNT(*) cnt FROM board";
		cntStmt = conn.prepareStatement(cntSql); 
		word="";
	} else {
     		listSql = "SELECT board_no boardNo, board_title boardTitle FROM board WHERE board_content LIKE ? ORDER BY board_no ASC LIMIT ?, ?";
		listStmt = conn.prepareStatement(listSql);
		listStmt.setString(1, "%"+word+"%"); 
		listStmt.setInt(2, beginRow);
		listStmt.setInt(3, ROW_PER_PAGE);         
		cntSql = "SELECT COUNT(*) cnt FROM board WHERE board_content LIKE ?";
		cntStmt = conn.prepareStatement(cntSql);
		cntStmt.setString(1, "%"+word+"%");    
	}
  
  	// 2-2
  
	ResultSet cntRs = cntStmt.executeQuery();
	int cnt = 0; // 전체 행의 수
    if(cntRs.next()) {
       cnt = cntRs.getInt("cnt");
    } 
  	// 올림 5.3 -> 6.0, 5.0->5.0
  	int lastPage = (int)(Math.ceil((double)cnt / (double)ROW_PER_PAGE));
  	
  	
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
		<title>boardList.jsp</title>
	   
	    <!-- 부트스트랩과의 약속! -->
		<!-- Latest compiled and minified CSS -->
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
		<!-- Latest compiled JavaScript -->
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	
		<!--스타일 -->
		<style>
		
		.table1 {
		    width: 40%;
		    height: 100px;
		 }   
		
		.font1 {
		   font-size : 20pt;
		   line-height : 30px;
		   text-algin: right;
		}
		.background{
		   background-image: url(<%=request.getContextPath()%>/img/cat1.PNG);
		   background-repeat: no-repeat;
		   background-position: right;
		   background-attachment: fixed;
		   background-size: 28% 380px;
		}
		</style>
	</head>
	
	<body class="background">
   	<!-- 메뉴 partial jsp 구성 -->
	<div>
	   <jsp:include page="/inc/menu.jsp"></jsp:include>
	</div>

	<h1 align="center"><p style ="font-weight : 900;" class="text-black"> 자유게시판&#128049;</p></h1>
	
	<!-- 내용 검색창 -->
	<form action="<%=request.getContextPath()%>/board/boardList.jsp" method="post" >
	      <label for="word">게시판 내용 검색 :  </label>
	      <input type="text" name="word" id="word" value="<%=word%>">
	      <button type="submit">검색</button>
  	 </form>
  	 
  	 <div align="right" >
		<a href="<%=request.getContextPath()%>/board/insertBoardForm.jsp?" style="text-decoration: none;">
		<span class="font1">&#9997;게시글 입력</span>
		</a>
	</div>
	
    <!-- 3-1. 모델데이터(ArrayList<Board>) 출력 -->	
	<table class="table left" style="width:950px;" align="left">
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
				<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=b.boardNo%>" style="text-decoration: none;">
				<%=b.boardTitle%>
				</a>
			</td>
		</tr>
		
	<%		
		}
	%>
	</table>
		<!-- 3-2. 페이징 -->
	<div align= "right">
	<%
	if(word == null|| word.equals("")){
	%>
		
		<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=1" style="text-decoration: none;">처음</a>

		<%
			if(currentPage > 1) {
		%>
				<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage-1%>" style="text-decoration: none;">이전</a>
		<%		
			}
		%>
				<span><%=currentPage%></span>

		<%
			if(currentPage <lastPage) {
		%>
			<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage+1%>" style="text-decoration: none;">다음</a>	
		<%		
			}
		%>
			<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=lastPage%>" style="text-decoration: none;">마지막</a>
		
	<%
	} else {
	%>	
		
		<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=1&word=<%=word%>" style="text-decoration: none;">처음</a>

		<%
			if(currentPage > 1) {
		%>
				<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage-1%>&word=<%=word%>" style="text-decoration: none;">이전</a>
		<%		
			}
		%>
				<span><%=currentPage%></span>

		<%
			if(currentPage < lastPage) {
		%>
			<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage+1%>&word=<%=word%>" style="text-decoration: none;">다음</a>	
		<%		
			}
		%>
			<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=lastPage%>&word=<%=word%>" style="text-decoration: none;">마지막</a>
	</div>
	
	<%	
	}
	%>
	</body>
</html>