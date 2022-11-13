<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "vo.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.URLEncoder" %>

<%
    // 1. 요청 분석 
    request.setCharacterEncoding("utf-8"); // 한글버전 패치
    
    int boardNo = Integer.parseInt(request.getParameter("boardNo"));// P키값인 boardNo 받아와 값세팅
    int commentNo = Integer.parseInt(request.getParameter("commentNo"));
    String commentContent = request.getParameter("commentContent");
    String commentPw = request.getParameter("commentPw"); // 비밀번호 값세팅
    
 	System.out.println(boardNo + ""+commentNo+""+commentContent+""+commentPw+"------------");
    
	 // 2. 요청처리
    Class.forName("org.mariadb.jdbc.Driver"); // mariadb 드라이버 로딩
    System.out.println("드라이버 로딩 성공");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	// 쿼리 문자열 생성
	String sql = "UPDATE comment SET comment_content=? WHERE board_no=? AND comment_no=? AND comment_pw=? ";
	
	// 쿼리 셋팅
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, commentContent);
	stmt.setInt(2, boardNo);
	stmt.setInt(3, commentNo);
	stmt.setString(4, commentPw);

	// 쿼리 실행
	int row = stmt.executeUpdate();
	
	// 쿼리실행 결과 
	if(row == 1) {
	   response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo+"&commentNo="+commentNo);
	} else {
	   String msg = URLEncoder.encode("입력된 값 또는 비밀번호를 확인하세요", "utf-8");
	   response.sendRedirect(request.getContextPath()+"/board/updateCommentForm.jsp?boardNo="+boardNo+"&commentNo="+commentNo+"&msg="+msg);
   }
%>