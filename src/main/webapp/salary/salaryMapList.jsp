<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %><!-- HashMap<키,값>, ArrayList<요소> -->
<%
	// 1) 요청분석
	// 페이징 currentpage, ...
	
	// 2) 요청처리
	// 페이징 rowPerpage
	int rowPerPage = 10;
	int beginRow = 0;
	// db -> 모델생성
	String driver = "org.mriadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://loacalhost:3306/employees";
	String dbUser = "root";
	String dbPw = "java1234";
	
	Class.forName("driver"); //드라이브 로딩(드라이버매니저 클래스를 쓸수잇게됨)
	Connection conn = DriverManager.getConnection("dburl","dbUser","dbPw"); 
	/*
	DiverManager.getConnection("프로토콜://주소:포트번호","","");  / conn에 쿼리를 저장
	TCP 주소(255.255.255...) 외 영어로돈 도메인주소(www.naver.com) 있음;
	conn.close(); 현재 연결된 커넥션을 종료시킴
	*/
	String sql = "SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, CONCAT(e.first_name,' ', e.last_name) name FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no ORDER BY s.emp_no ASC LIMIT ?,?";
	// 순서는 상관없지만 외래키(FK)쪽을 먼저 쓰도록 연습, 조인은 행과행을 연결하기에 항상 ON을 적기, 결과값에는 SELECT의 3개값이 나옴
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, beginRow);
	stmt.setInt(2, rowPerPage);
	ResultSet rs = stmt.executeQuery();
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	while(rs.next()){
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("empNo", rs.getInt("empNo"));
		m.put("salary", rs.getInt("salary"));
		m.put("fromDate", rs.getString("fromDate"));
		m.put("name", rs.getString("name"));
		list.add(m);
	}
			
	
	rs.close();
	stmt.close(); // stmt를 먼저해지하고 conn을 해지는 순서가 용이함
	conn.close();
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>salaryMapList.jsp</title>
	</head>
	<body>
		<h1>연봉 목록</h1>
		<table border="1">
			<tr>
				<th>사원번호</th>
				<th>사원이름</th>
				<th>연봉</th>
				<th>계약일자</th>		
			</tr>
			<%
				for(HashMap<String,Object> m : list){
					
				}
			%>
		</table>
	</body>
</html>