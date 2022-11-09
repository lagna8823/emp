<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>

<%
	// 1.요청분석(Controller)
	request.setCharacterEncoding("utf-8"); // 한글버전 패치
	
	// 2.업무처리(Model) -> 모델데이터(딘일값 or 자료구조형태(배열, 리스트, ...))
	Class.forName("org.mariadb.jdbc.Driver");
		System.out.println("드라이버 로딩 성공");
		
	// DB정보 연결 (디비를 연결하고 연결된 선(conn)으로 PreparedStatement을 통해 쿼리를 stmt에 값세팅)		
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	String sql = "SELECT dept_no deptNo, dept_name deptName FROM departments ORDER BY dept_no asc";
	PreparedStatement stmt = conn.prepareStatement(sql);
	ResultSet rs = stmt.executeQuery();  
	
	/* 모델데이터 ResultSet은 보편적인 타입이 아니다.		
	 <- 모델데이터로서 ResultSet은 일반적인 타입이 아니고 독립적인 타입도 아니다.
	RestultSet rs라는 모델자료구조를 좀 더 일반적 이고 독립적인 자료구조로 변경하자 */
	
	ArrayList<Department> list = new ArrayList<Department>();
	while(rs.next()){ //보편적이지 않음 ResultSet의 API(사용방법)을 모른다면 사용할 수 없는 반복문
		Department d = new Department(); 
		d.deptNo = rs.getString("deptNo");
		d.deptName = rs.getString("deptName");
		list.add(d);
	}
	// 3.출력(View) -> 모델데이터를 고객이 원하는 형태로 출력 -> 뷰(리포트)
	
%>
<!DOCTYPE html>
<html>
	<head>
	<meta charset="UTF-8">
	<title>insertDeptAction.jsp</title>
		<!-- 부트스트랩과의 약속! -->
		<!-- Latest compiled and minified CSS -->
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
		<!-- Latest compiled JavaScript -->
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
		<!-- 테이블 스타일 -->
			<style>
				table {
					width: 60%;
					height: 100px;
					margin: auto;
					text-algin:center;
				}	
			</style>
	</head>
	<body>
		<!-- 메뉴 patial jsp 구성-->
		<div>
			 <jsp:include page="/inc/menu.jsp"></jsp:include> <!-- include에 한해서는 emp주체? 이기에  -->
		</div>
		<h1 class="text-center">DEPARTMENT LIST</h1>
		<div>접속하신걸 환영합니다</div>
		<div>당신의 하루를 응원합니다</div>
		</h4>
		<div>
			<a href="<%=request.getContextPath()%>/dept/insertDeptForm.jsp">
			<span class="h2" >부서추가</span>
			</a>
		</div>
		<table>
			<tr>
				<th><span class="bg-warning">부서번호</span></th>
				<th><span class="bg-warning">부서이름</span></th>
				<th><span class="text-primary">수정</span></th>
				<th><span class="text-danger">삭제</span></th>
			</tr>
			<%
				for(Department d : list) { // 자바문법에서 제공하는 foreach문
			%>
					<tr>
						<td><%=d.deptNo%></td>
						<td><%=d.deptName%></td>
						<td><a href="<%=request.getContextPath()%>/dept/updateDeptForm.jsp?deptNo=<%=d.deptNo%>">수정</a></td>
						<td>
							<a href="<%=request.getContextPath()%>/dept/deleteDept.jsp?deptNo=<%=d.deptNo%>">
								<span class="text-danger">삭제</span>
							</a>
						</td>
					</tr>
			<%	
				}
			%>
		</table>
	</body>
</html>