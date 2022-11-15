<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import ="vo.*" %>

<%
	// 1) 요청분석
	request.setCharacterEncoding("utf-8");
	String word = request.getParameter("word");
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
	currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	// 2) 요청처리
	int ROW_PER_PAGE = 10;
	int beginRow = (currentPage-1)*ROW_PER_PAGE;
	
	// db -> 모델생성
	String driver = "org.mariadb.jdbc.Driver";
	Class.forName(driver);

	String dbUrl = "jdbc:mariadb://localhost:3306/employees";
	String dbUser = "root";
	String dbPw = "java1234";
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	// 검색기능 
 	String cntSql = null; //sql문을 담을 변수
 	PreparedStatement cntStmt = null; //sql문에 값을 세팅할 변수
 	if(word == null || word.equals("")) {
 		cntSql = "SELECT COUNT(*) cnt FROM dept_emp";
		cntStmt = conn.prepareStatement(cntSql); 
		word="";
 	} else {
 		cntSql = "SELECT COUNT(*) cnt FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no WHERE d.dept_name LIKE?";
		cntStmt = conn.prepareStatement(cntSql);
		cntStmt.setString(1, "%"+word+"%");    
 	}
	 	
 	// 검색 결과 쿼리 값세팅 
 	ResultSet cntRs = cntStmt.executeQuery();
	int cnt = 0; // 전체 행의 수
    if(cntRs.next()) {
       cnt = cntRs.getInt("cnt");
    }
	int lastPage = (int)(Math.ceil((double)cnt / (double)ROW_PER_PAGE)); // 마지막 페이지 설정(정수화)
	
	//	조건 검색(JOIN)
	String sql = null; //sql문을 담을 변수
	PreparedStatement stmt = null; //sql문에 값을 세팅할 변수
	
	if(word == null || word.equals("")) {
		sql = "SELECT de.emp_no empNo, d.dept_name deptName, de.from_date fromDate, de.to_date toDate, e.first_name firstName, e.last_name lastName FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no ORDER BY de.emp_no ASC LIMIT ?, ?;";
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, ROW_PER_PAGE);
	} else {
		sql = "SELECT de.emp_no empNo, d.dept_name deptName, de.from_date fromDate, de.to_date toDate, e.first_name firstName, e.last_name lastName FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no WHERE d.dept_name LIKE? ORDER BY de.emp_no ASC LIMIT ?, ?";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, "%"+word+"%"); 
		stmt.setInt(2, beginRow);
		stmt.setInt(3, ROW_PER_PAGE);    
		
	}	
	
	ResultSet rs = stmt.executeQuery();
	ArrayList<DeptEmp> list = new ArrayList<DeptEmp>();
	while(rs.next()) {
	   DeptEmp de = new DeptEmp();
	   de.emp = new Employee();
	   de.emp.empNo = rs.getInt("empNo");
	   de.emp.firstName = rs.getString("firstName");
	   de.emp.lastName = rs.getString("lastName");
	   de.dept = new Department();
	   de.dept.deptName = rs.getString("deptName");
	   de.fromDate = rs.getString("fromDate");
	   de.toDate = rs.getString("toDate");
	   list.add(de);
	}
	// 닫아주는 메소드
		cntRs.close();
		cntStmt.close();
		
		rs.close();
		stmt.close();
		conn.close();
%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>deptEmpList.jsp</title>
		
		<!-- 부트스트랩과의 약속! -->
		<!-- Latest compiled and minified CSS -->
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
		<!-- Latest compiled JavaScript -->
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
		
		<!--스타일 -->
		<style>
		
		.table {
		    width: 60%;
		    height: 100px;
		 }   
		
		.font1 {
		   font-size : 20pt;
		   line-height : 30px;
		   text-algin: right;
		}
		.background{
		   background-image: url(<%=request.getContextPath()%>/img/fiting.PNG);
		   background-repeat: no-repeat;
		   background-position: bottom;
		   background-attachment: fixed;
		   background-size: 40% 200px;
		}
		</style>
	</head>
	
	<body class="background">
		<!-- 메뉴 partial jsp 구성 -->
		<div>
		   <jsp:include page="/inc/menu.jsp"></jsp:include>
		</div>

		<h1 align="center"><p style ="font-weight : 900;" class="text-black"> 사원 상세정보&#128049;</p></h1>
	
	
		<!-- 내용 검색창 -->
		<form action="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp" method="post" >
		      <label for="word">부서명 검색 : </label>
		      <input type="text" name="word" id="word" value="<%=word%>">
		      <button type="submit">검색</button>
	  	</form>
		<table class="table table-hover w-auot">
			<tr>
				<th>사번</th>
				<th>이름</th>
				<th>부서명</th>
				<th>입사일</th>
				<th>퇴사일</th>
			</tr>
			<%
				for(DeptEmp de : list){
			%>		
					<tr>
						<td><%=de.emp.empNo%></td>
						<td><%=de.emp.firstName%>&nbsp;<%=de.emp.lastName%></td>
						<td><%=de.dept.deptName%></td>
						<td><%=de.fromDate%></td>
						<td><%=de.toDate%></td>
					</tr>
			<%
				}
			%>
		</table>
		
		<!-- 페이징 -->
		<%
			if(word == null|| word.equals("")){
		%>
				<div align="center">
					<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=1" style="text-decoration: none;">
					처음
					</a>
	
					<%
						if(currentPage > 1) {
					%>
							<a href="<%=request.getContextPath()%>>/deptEmp/deptEmpList.jsp?currentPage=<%=currentPage-1%>" style="text-decoration: none;">
							이전
							</a>
					<%		
						}
					%>
						<span><%=currentPage%></span>
	
					<%
						if(currentPage < lastPage) {
					%>
							<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList?currentPage=<%=currentPage+1%>" style="text-decoration: none;">
							다음
							</a>   
					<%		
						}
					%>
							<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList?currentPage=<%=lastPage%>" style="text-decoration: none;">
							마지막
							</a>
				</div>
					<%
						} else {
					%>	
							<div align="center">
							<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList?currentPage=1&word=<%=word%>" style="text-decoration: none;">
							처음
							</a>
	
							<%
								if(currentPage > 1) {
							%>
								<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList?currentPage=<%=currentPage-1%>&word=<%=word%>" style="text-decoration: none;">
								이전
								</a>
							<%		
								}
							%>
								<span><%=currentPage%></span>
					
							<%
								if(currentPage < lastPage) {
							%>
								<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList?currentPage=<%=currentPage+1%>&word=<%=word%>" style="text-decoration: none;">
								다음
								</a>	
							<%		
								}
							%>
								<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList?currentPage=<%=lastPage%>&word=<%=word%>" style="text-decoration: none;">
								마지막
								</a>
							</div>
		
					<%	
						}
					%>
	</body>
</html>