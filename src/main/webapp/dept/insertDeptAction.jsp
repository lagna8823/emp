<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.net.URLEncoder" %>
<%@ page import = "vo.*" %>

<%	
	// 1.요청분석
	request.setCharacterEncoding("utf-8"); // 한글버전 패치 (값이 넘어오니까 인코딩)	
  	String deptNo = request.getParameter("deptNo");
   	String deptName = request.getParameter("deptName");

	
	// 입력값 체크
	 if(deptNo == null || deptName == null || deptNo.equals("") || deptName.equals("")) {
      String msg = URLEncoder.encode("부서번호와 부서이름을 입력하세요","utf-8"); // get방식 주소창에 문자열 인코딩
      response.sendRedirect(request.getContextPath()+"/dept/insertDeptForm.jsp?msg="+msg);
      return;
   }

	
	// 2. 요청처리
	// 이미 존재하는 key(dept_no)에 동일값이 입력되면 예외(에러)발생 -> 동일한 dept_no값 입력시 안전조치
	// DB정보 연결
  	Class.forName("org.mariadb.jdbc.Driver"); // mariadb 드라이버 로딩
   	System.out.println("드라이버 로딩 성공");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	// 2-1 dept-no 중복검사
	String sql1 = "SELECT * FROM departments WHERE dept_no = ? OR dept_name = ?";
	PreparedStatement stmt1 = conn.prepareStatement(sql1);	
	stmt1.setString(1, deptNo);
	stmt1.setString(2, deptName);
	ResultSet rs = stmt1.executeQuery();
	if(rs.next()){ // 결과물이 있다 -> 같은 dept_no 존재.
		String msg =URLEncoder.encode("부서번호 또는 부서이름이 중복되었습니다.","utf-8");
		response.sendRedirect(request.getContextPath() + "/dept/insertDeptForm.jsp?msg="+msg);		
		return;
	}
			
	// 2-3 입력
	String sql2 = "insert into departments(dept_no, dept_name) values(?,?)"; 
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, deptNo);
	stmt2.setString(2, deptName);

	//디버깅용
	int row = stmt2.executeUpdate(); 
	if(row ==1) {
		System.out.println("입력성공");
	} else {
		System.out.println("입력실패");
	}
	response.sendRedirect(request.getContextPath() + "/dept/deptList.jsp");
	// 3. 결과분석 
%>