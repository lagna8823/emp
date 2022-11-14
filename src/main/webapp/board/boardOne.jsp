<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
   // 1
   System.out.println(request.getParameter("boardNo"));
   int boardNo = Integer.parseInt(request.getParameter("boardNo"));
   // 댓글 페이징에 사용할 현재 페이지
   int currentPage = 1;
   if(request.getParameter("currentPage") != null) {
      currentPage = Integer.parseInt(request.getParameter("currentPage"));
   }

   // 2-1 게시글 하나
   Class.forName("org.mariadb.jdbc.Driver");
   Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234");
   String boardSql = "SELECT board_title boardTitle, board_content boardContent, board_writer boardWriter, createdate FROM board WHERE board_no = ?";
   PreparedStatement boardStmt = conn.prepareStatement(boardSql);
   boardStmt.setInt(1, boardNo);
   ResultSet boardRs = boardStmt.executeQuery();
   Board board = null;
   if(boardRs.next()) {
      board = new Board();
      board.boardNo = boardNo;
      board.boardTitle = boardRs.getString("boardTitle");
      board.boardContent = boardRs.getString("boardContent");
      board.boardWriter = boardRs.getString("boardWriter");
      board.createdate = boardRs.getString("createdate");
   }
   // 2-2 댓글 목록
   /*
      SELECT comment_no commentNo, comment_content commentContent 
      FROM comment
      WHERE board_no = ?
      ORDER BY comment_no DESC
      LIMIT ?, ? 
   */

   int rowPerPage = 5;
   int beginRow = (currentPage-1)*rowPerPage;
   
   String commentSql = "SELECT comment_no commentNo, comment_content commentContent FROM comment WHERE board_no = ? ORDER BY comment_no DESC LIMIT ?, ?";
   PreparedStatement commentStmt = conn.prepareStatement(commentSql);
   commentStmt.setInt(1, boardNo);
   commentStmt.setInt(2, beginRow);
   commentStmt.setInt(3, rowPerPage);
   ResultSet commentRs = commentStmt.executeQuery();
   ArrayList<Comment> commentList = new ArrayList<Comment>();
   while(commentRs.next()) {
      Comment c = new Comment();
      c.commentNo = commentRs.getInt("commentNo");
      c.commentContent = commentRs.getString("commentContent");
      commentList.add(c);
   }
   // 2-3 댓글 전체행의 수 -> lastPage
   int lastPage = 0;
   
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>boardOne.jsp</title>
		
		<!-- 부트스트랩과의 약속! -->
		<!-- Latest compiled and minified CSS -->
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
		<!-- Latest compiled JavaScript -->
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>	
	</head>
	<body>
	    <!-- 메뉴 partial jsp 구성 -->
	    <div>
		<jsp:include page="/inc/menu.jsp"></jsp:include>
	    </div>
    	<div align="center">
   			<h1>게시글 상세보기</h1>
	    </div>
	   
	   
		<table  class="table table-hover">
			<tr>
			   <td>번호</td>
			   <td><%=board.boardNo%></td>
			</tr>
			<tr>
			   <td>제목</td>
			   <td><%=board.boardTitle%></td>
			</tr>
			<tr>
			   <td>내용</td>
			   <td><%=board.boardContent%></td>
			</tr>
			<tr>
			   <td>글쓴이</td>
			   <td><%=board.boardWriter%></td>
			</tr>
			<tr>
			   <td>생성날짜</td>
			   <td><%=board.createdate%></td>
			</tr>
	   </table>
		<a href="<%=request.getContextPath()%>/board/updateBoardForm.jsp?boardNo=<%=boardNo%>" style="text-decoration: none;">
		<span>수정</span>
		</a>
		<a href="<%=request.getContextPath()%>/board/deleteBoardForm.jsp?boardNo=<%=boardNo%>" style="text-decoration: none;">
		   	<span class="text-danger">삭제</span>
		</a>
		<br><br>
	    <div>
			<!-- 댓글입력 폼 -->
			<div align="left">
			<h3>댓글입력</h3>
			</div>
			
			  <!-- msg 파라메타값이 있으면 출력 -->
			<%
				if(request.getParameter("msg") != null){
			%>
				<div><%=request.getParameter("msg") %></div>
			<%
				}
			%>	
				<br>	
				<form action="<%=request.getContextPath()%>/board/insertCommentAction.jsp" method="post">
				<input type="hidden" name="boardNo" value="<%=board.boardNo%>">
				<div align="left">
	         		<table>
			            <tr>
			               <td>내용</td>
			               <td><textarea rows="3" cols="80" name="commentContent"></textarea></td>
			            </tr>
			            <tr>
			               <td>비밀번호</td>
			               <td><input type="password" name="commentPw"></td>	
			            </tr>
			         </table>
	         		 <button type="submit">댓글입력</button>
       			</div>
       			<br><br>
	         	<!-- 댓글 목록 -->
	         	<div text-algin="left">	 
	         		<h2>댓글목록</h2>	 
	   
			         <%
			          	for(Comment c : commentList) {
			         %>
				            <div>
				               <div>
				                  <%=c.commentNo%>
				                  <a href="<%=request.getContextPath()%>/board/updateCommentForm.jsp?commentNo=<%=c.commentNo%>&boardNo=<%=boardNo%>" style="text-decoration: none;">
				                     [수정]
				                  </a>
				                  <a href="<%=request.getContextPath()%>/board/deleteCommentForm.jsp?commentNo=<%=c.commentNo%>&boardNo=<%=boardNo%>" style="text-decoration: none;">
				                  	<span class="text-danger"> [삭제]</span>
				                  </a>
				               </div>
				               		<div><%=c.commentContent%></div>
					           </div>
			         <%      
			       		}
			         %>
				</form>
			</div>
			<div>
			   
			   
			   <!-- 댓글 페이징 -->
			   <%
			      if(currentPage > 1) {
			   %>
			         <a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>&currentPage=<%=currentPage-1%>">
			            <span>이전</span>
			         </a>
			   <%      
			      }
			      // 다음 <-- 마지막페이지 <-- 전체행의 수 
			      if(currentPage < lastPage) {
			   %>
			         <a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>&currentPage=<%=currentPage+1%>">
			             <span>다음</span>
			         </a>
			   <%   
			      }
			   %>
			</div>
	</body>
</html>