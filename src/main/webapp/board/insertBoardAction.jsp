<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "vo.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.URLEncoder" %>
<%
	// 1. 요청분석
	request.setCharacterEncoding("utf-8");
	String boardPw = request.getParameter("boardPw");
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	String boardWriter = request.getParameter("boardWriter");
	
	System.out.println(""+ boardPw + boardTitle+boardContent+boardWriter);
	
	// 2. 요청처리
	Class.forName("org.mariadb.jdbc.Driver"); // mariadb 드라이버 로딩
	System.out.println("드라이버로딩성공");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234"); //DB연결
	
	
	if(request.getParameter("boardPw") == null || request.getParameter("boardTitle") == null ||  request.getParameter("boardContent") == null || request.getParameter("boardWriter") == null ||
	   	request.getParameter("boardPw").equals("") || request.getParameter("boardTitle").equals("") ||  request.getParameter("boardContent").equals("") || request.getParameter("boardWriter").equals("")){
		String msg = URLEncoder.encode("입력되지 않은 값이 있습니다.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/board/insertBoardForm.jsp?="+"&msg="+msg);
		return;
   	}
	
	int boardNo = 0;
	//쿼리 문자열 생성
	String sql = "INSERT into board(board_no, board_pw, board_title, board_content, board_writer, createdate ) value(?,?,?,?,?,curdate())";
	// 쿼리 셋팅
	PreparedStatement stmt = conn.prepareStatement(sql);
 	stmt.setInt(1, boardNo);
 	stmt.setString(2, boardPw);
 	stmt.setString(3, boardTitle);
 	stmt.setString(4, boardContent);
 	stmt.setString(5, boardWriter);
 	
 	// 쿼리 실행
	int row = stmt.executeUpdate();
 	
 	//쿼리실행 결과
	if(row ==1) {
		System.out.println("입력성공");
	} else {
		System.out.println("입력실패");
	}
	response.sendRedirect(request.getContextPath() + "/board/boardtList.jsp");
%>