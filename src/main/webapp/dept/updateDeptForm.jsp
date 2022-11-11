<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "vo.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>

<%
    // 1. 요청 분석 
    request.setCharacterEncoding("utf-8"); // 한글버전 패치
    String deptNo = request.getParameter("deptNo"); // 키값인 deptNo 값세팅
	 // 입력값 체크(deptList의 링크를 호출하지 않고 updateDeptForm.jsp 주소창에 직접 호출하면 deptNo는 null값이 된다.)
 	if(deptNo == null){
 		response.sendRedirect(request.getContextPath() + "dept/deptList.jsp");
		return;
 	}
    
	 // 2. 요청처리
    Class.forName("org.mariadb.jdbc.Driver"); // mariadb 드라이버 로딩
    	System.out.println("드라이버 로딩 성공");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	String sql = "SELECT dept_name deptName FROM departments WHERE dept_no=?"; 
	PreparedStatement stmt = conn.prepareStatement(sql);	
	stmt.setString(1, deptNo);
	ResultSet rs =stmt.executeQuery();
	
	// if 블럭 안에 쓰면 밖에서 못쓰기 때문에 블럭 밖에서 변수를 지정해놓고 블럭안의 값을 저장해둔다
	 // 변수를 지정해놨기 때문에 if문 안에다가 출력을 적을 필요가 없어진다. 요청과 출력을 분리
	   
	Department dept = null;
	if(rs.next()) {
		dept = new Department();
		dept.deptNo = deptNo;
		dept.deptName = rs.getString("deptName");
	}
	
	// 3.출력(View) -> 모델데이터를 고객이 원하는 형태로 출력 -> 뷰(리포트)	
%>
<!DOCTYPE html>
<html>
	<head>
	<meta charset="UTF-8">
	<title>deleteDept.jsp</title>
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
			<h1 class="text-center">부서 수정</h1>
	</head>
	<body>
		<div>
			<jsp:include page="/inc/menu.jsp"></jsp:include> <!-- include에 한해서는 emp주체? 이기에  -->
		</div>
		<%
			if(request.getParameter("msg") != null){
		%>
			<div><%=request.getParameter("ms2") %></div>
		<%
			}
		%>
		<form method="post" action="<%=request.getContextPath()%>/dept/updateDeptAction.jsp" >
			<table border="2">
				<tr>
					<td><span class="bg-secondary">부서번호</span></td>
					<td><input type="text" name="deptNo" value="<%=dept.deptNo%>" readonly="readonly"></td>
				</tr>
				<tr>
					<td><span class="bg-warning">부서명</span></td>
					<td><input type="text" name="deptName" value="<%=dept.deptName%>"></td>
				</tr>
			</table>
			<table>
				<tr>
					<td>
					<span class="text-primary" text="center">한번 더 확인해주세요</span>
					<button type="submit" class="btn btn-outline-primary">수정하기</button>
					</td>
				</tr>		
			</table>		
		</form>
	</body>
</html>