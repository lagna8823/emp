<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%
   // 1
   //System.out.println(request.getParameter("boardNo"));
   //System.out.println(request.getParameter("boardPw"));
   int boardNo = Integer.parseInt(request.getParameter("boardNo"));
   int commentNo = Integer.parseInt(request.getParameter("commentNo"));
   String commentPw = request.getParameter("commentPw");
   
   // 2
   Class.forName("org.mariadb.jdbc.Driver");
   Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234");
   
   // 쿼리 문자열 생성
   String sql = "DELETE FROM comment WHERE board_no=? AND comment_pw=? AND comment_no=?";
   // 쿼리 셋팅
   PreparedStatement stmt = conn.prepareStatement(sql);
   stmt.setInt(1, boardNo);
   stmt.setString(2, commentPw);
   stmt.setInt(3, commentNo);
   // 쿼리실행
   int row = stmt.executeUpdate();
   // 쿼리실행결과 
   if(row == 1) {
      response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo="+boardNo);
   } else {
      String msg = URLEncoder.encode("비밀번호를 확인하세요", "utf-8");
      response.sendRedirect(request.getContextPath()+"/board/deleteCommentForm.jsp?boardNo="+boardNo+"&commentNo="+commentNo+"&msg="+msg);
   }
  
%>