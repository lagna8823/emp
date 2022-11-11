<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "vo.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.URLEncoder" %>
<%
	// 1. 요청분석
	request.setCharacterEncoding("utf-8");
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String commentContent = request.getParameter("commentContent");
	String commentPw = request.getParameter("commentPw");
	
	System.out.println(boardNo + "" + commentContent + "" + commentPw);
	
	
	if(request.getParameter("commentPw") == null || request.getParameter("commentContent") == null ||
		   	request.getParameter("commentPw").equals("") || request.getParameter("commentContent").equals("")){
			String msg = URLEncoder.encode("입력되지 않은 값이 있습니다.", "utf-8");
			response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo + "&msg="+msg);
			return;
	   	}
	
	// 2. 요청처리
	Class.forName("org.mariadb.jdbc.Driver"); // mariadb 드라이버 로딩
	System.out.println("드라이버로딩성공");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234"); //DB연결
	
	// 2.1 요청처리-중복검사
	
	// 2.2 요청처리-삽입
	// 쿼리 문자열 생성
	String sql = "INSERT into comment(board_no, comment_pw, comment_content, createdate) value(?,?,?,curdate())";
	
	// 쿼리 셋팅
	PreparedStatement stmt = conn.prepareStatement(sql);
 	stmt.setInt(1, boardNo);
 	stmt.setString(2, commentPw);
 	stmt.setString(3, commentContent);
 
 	// 쿼리 실행
	int row = stmt.executeUpdate();
 	
 	//쿼리실행 결과
	if(row ==1) {
		System.out.println("입력성공");
	} else {
		System.out.println("입력실패");
	}
	response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?boardNo="+boardNo);
%>