<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import ="vo.*" %>

<%
	// 1) 요청분석
	String word = request.getParameter("word");
	int currentPage = 1;
	if(request.getParameter("currentpage") != null){
		currentpage = Integer.ParseInt(request.getParameter("currentPage"));
	}
	
	// 2) 요청처리
	int ROW_PER_PAGE = 10;
	int beginRow = (currentPage-1)*ROW_PER_PAGE;
	// db -> 모델생성
	String driver = "org.mriadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://loacalhost:3306/employees";
	String dbUser = "root";
	String dbPw = "java1234";
	
	Class.forName("driver"); //드라이브 로딩(드라이버매니저 클래스를 쓸수잇게됨)
	Connection conn = DriverManager.getConnection("dburl","dbUser","dbPw"); 
	
	// 검색기능 
 	String cntSql = null; //sql문을 담을 변수
 	PreparedStatement cntStmt = null; //sql문에 값을 세팅할 변수
 	if(word == null || word.equals("")) {
 		cntSql = "SELECT COUNT(*) cnt FROM employees";
		cntStmt = conn.prepareStatement(cntSql); 
		word="";
 	} else {
 		cntSql = "SELECT COUNT(*) cnt FROM employees WHERE d.dept_no?";
		cntStmt = conn.prepareStatement(cntSql);
		cntStmt.setString(1, "%"+word+"%");    
		cntStmt.setString(2, "%"+word+"%");    
 	}
	 	
 	// 검색 결과 쿼리 값세팅 
 	ResultSet cntRs = cntStmt.executeQuery();
	int cnt = 0; // 전체 행의 수
    if(cntRs.next()) {
       cnt = cntRs.getInt("cnt");
    }
	int lastPage = (int)(Math.ceil((double)cnt / (double)ROW_PER_PAGE)); // 마지막 페이지 설정(정수화)
	
	//	조건 검색(JOIN)
	String selectSql = null; //sql문을 담을 변수
	PreparedStatement selectStmt = null; //sql문에 값을 세팅할 변수
	
	if(word == null || word.equals("")) {
		selectSql = "SELECT de.emp_no, e.first_name, d.dept_name, de.from_date, de.to_date FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no ASC LIMIT ?, ?;";
		selectStmt = conn.prepareStatement(empSql);
		selectStmt.setInt(1, beginRow);
		selectStmt.setInt(2, ROW_PER_PAGE);
	} else {
		selectSql = "SELECT de.emp_no, first_name firstName, last_name lastName FROM employees WHERE first_name LIKE ? OR last_name LIKE ? ORDER BY emp_no ASC LIMIT ?, ?";
		selectStmt = conn.prepareStatement(empSql);
		selectStmt.setString(1, "%"+word+"%"); 
		selectStmt.setString(2, "%"+word+"%"); 
		selectStmt.setInt(3, beginRow);
		selectStmt.setInt(4, ROW_PER_PAGE);         
	}
	
	
	selectSql = "SELECT de.emp_no, e.first_name, d.dept_name, de.from_date, de.to_date 
					FROM dept_emp de INNER JOIN employees e 
					ON de.emp_no = e.emp_no 
					INNER JOIN departments d 
					ON de.dept_no = d.dept_no ASC LIMIT ?, ?;";
	
		
			
	ArrayList<DeptEmp> list = new ArrayList<DeptEmp>();
	while(rs.next()) {
	   DeptEmp de = new DeptEmp();
	   de.emp = new Employee();
	   de.emp.empNo = rs.getInt("empNo");
	   de.dept = new Department();
	   de.dept.deptNo = rs.getInt("deptNo");
	   de.fromDate = 
	   de.toDate = 
	}
%>
<%
   // DeptEmp.class가 없다면
   // deptEmpMapList.jsp
   ArrayList<HashMap<String, Ojbect>> list = new ArrayList<String, Ojbect>();
   while(rs.next()) {
      //...
   }
%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>salaryList1.jsp</title>
		
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
		   background-size: 50% 250px;
		}
		</style>
	</head>
	
	<body class="background">
		<!-- 메뉴 partial jsp 구성 -->
		<div>
		   <jsp:include page="/inc/menu.jsp"></jsp:include>
		</div>

		<h1 align="center"><p style ="font-weight : 900;" class="text-black"> 연봉&#128049;</p></h1>
	
	
		<!-- 내용 검색창 -->
		<form action="<%=request.getContextPath()%>/salary/salaryList1.jsp" method="post" >
		      <label for="word">사원명 검색 : </label>
		      <input type="text" name="word" id="word" value="<%=word%>">
		      <button type="submit">검색</button>
	  	 </form>
		<table class="table table-hover w-auot">
			<tr>
				<th>사번</th>
				<th>연봉</th>
				<th>입사일</th>
				<th>퇴사일</th>
				<th>이름</th>
				<th>성</th>
			</tr>
			<%
				for(Salary s : salaryList){
			%>		
					<tr>
						<td><%=s.emp.empNo%></td>
						<td><%=s.salary%></td>
						<td><%=s.fromDate%></td>
						<td><%=s.toDate%></td>
						<td><%=s.emp.firstName%></td>
						<td><%=s.emp.lastName%></td>
						
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
			<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=1" style="text-decoration: none;">
			처음</a>
	
			<%
				if(currentPage > 1) {
			%>
					<a href="<%=request.getContextPath()%>>/emp/empList.jsp?currentPage=<%=currentPage-1%>" style="text-decoration: none;">
					이전
					</a>
			<%		
				}
			%>
					<span><%=currentPage%></span>
	
			<%
				if(currentPage < lastPage) {
			%>
					<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage+1%>" style="text-decoration: none;">
					다음
					</a>   
			<%		
				}
			%>
					<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=lastPage%>" style="text-decoration: none;">
					마지막
					</a>
			</div>
		<%
		} else {
		%>	
			<div align="center">
				<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=1&word=<%=word%>" style="text-decoration: none;">
				처음
				</a>
	
			<%
				if(currentPage > 1) {
			%>
					<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage-1%>&word=<%=word%>" style="text-decoration: none;">
					이전
					</a>
			<%		
				}
			%>
					<span><%=currentPage%></span>
	
			<%
				if(currentPage < lastPage) {
			%>
					<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage+1%>&word=<%=word%>" style="text-decoration: none;">
					다음
					</a>	
			<%		
				}
			%>
					<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=lastPage%>&word=<%=word%>" style="text-decoration: none;">
					마지막
					</a>
			</div>
		
		<%	
			}
		%>
	</body>
</html>