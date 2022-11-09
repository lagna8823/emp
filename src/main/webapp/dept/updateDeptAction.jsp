<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "vo.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.URLEncoder" %>

<%
	//1.요청분석
	request.setCharacterEncoding("utf-8"); // 한글버전 패치
	String deptNo = request.getParameter("deptNo");
	String deptName = request.getParameter("deptName");
	
	// 입력값 체크
	if(deptName == null ||deptName.equals("")) {
      String msg = URLEncoder.encode("부서이름을 입력하세요","utf-8"); // get방식 주소창에 문자열 인코딩
      response.sendRedirect(request.getContextPath()+"/dept/updateDeptForm.jsp?msg="+msg);
      return;
   }

	// 논리적으로 하나로 묶음
	Department dept = new Department();
	dept.deptNo = deptNo;
	dept.deptName = deptName;
		
	// 2. 요청처리
	Class.forName("org.mariadb.jdbc.Driver"); // mariadb 드라이버 로딩
		System.out.println("드라이버 로딩 성공"); 
	// DB정보 연결 (디비를 연결하고 연결된 선(conn)으로 PreparedStatement을 통해 쿼리를 stmt에 값세팅)	
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees","root","java1234");	
	
	// 2-1 dept-no 중복검사
		String sql1 = "SELECT dept_name FROM departments WHERE dept_name = ?";
		PreparedStatement stmt1 = conn.prepareStatement(sql1);	
		stmt1.setString(1, deptName);
		ResultSet rs = stmt1.executeQuery();
		if(rs.next()){ // 결과물이 있다 -> 같은 dept_no가 존재.
			String msg = URLEncoder.encode( deptName +"는 사용할 수 없습니다","utf-8");
			response.sendRedirect(request.getContextPath() + "/dept/updateDeptForm.jsp?msg="+msg);		
			return;
		}
	
	// 2-2 수정
	String sql2 = "UPDATE departments SET dept_name=? WHERE dept_no= ?";	
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, deptName);
	stmt2.setString(2, deptNo);
	
	//디버깅용
	int row = stmt2.executeUpdate();
	if(row == 1) {
		System.out.println("수정성공");
	} else {
		System.out.println("수정실패");
	}
	
	response.sendRedirect(request.getContextPath() + "/dept/deptList.jsp");
	// 3. 결과분석 
	
%>