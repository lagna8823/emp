<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*" %> <!-- vo.Salary -->
<%@ page import = "java.util.*" %>
<%
	 // 1
	 String word = request.getParameter("word");
	 int currentPage = 1;
	 if(request.getParameter("currentPage") != null) {
	    currentPage = Integer.parseInt(request.getParameter("currentPage"));
	 }
	 
	 // 2
	 final int ROW_PER_PAGE = 10; // 상수 선언 문법
	 int beginRow = (currentPage-1)*ROW_PER_PAGE; 
	 Class.forName("org.mariadb.jdbc.Driver");
	 Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	 /*
		SELECT s.emp_no empNo
		, s.salary salary
		, s.from_date fromDate
		, s.to_date toDate
		, e.first_name firstName 
		, e.last_name lastName
		FROM salaries s INNER JOIN employees e  # 테이블 두개를 합칠때 : 테이블1 JOIN 테이블2 ON 합치는 조건식 
		ON s.emp_no = e.emp_no
		LIMIT ?, ?
 	 */
 	String cntSql = null;
 	String empSql = null;
 	PreparedStatement cntStmt = null;
 	PreparedStatement empStmt = null; 
 	if(word == null || word.equals("")) {
 		empSql = "SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, s.to_date toDate, e.first_name firstName, e.last_name lastName FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no ORDER BY s.emp_no ASC LIMIT ?,?";
 		empStmt = conn.prepareStatement(empSql);
 		empStmt.setInt(1, beginRow);
 		empStmt.setInt(2, ROW_PER_PAGE);
 		cntSql = "SELECT COUNT(*) cnt FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no WHERE e.first_name LIKE ? OR e.last_name LIKE?";
 		cntStmt = conn.prepareStatement(cntSql);
 		cntStmt.setString(1, "%"+word+"%");    
 		cntStmt.setString(2, "%"+word+"%");    
 		word="";	
 	} else {
 		empSql = "SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, s.to_date toDate, e.first_name firstName, e.last_name lastName FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no ORDER BY s.emp_no ASC LIMIT ?,?";
 		empStmt = conn.prepareStatement(empSql);
 		empStmt.setInt(1, beginRow);
 		empStmt.setInt(2, ROW_PER_PAGE);
 		cntSql = "SELECT COUNT(*) cnt FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no WHERE e.first_name LIKE ? OR e.last_name LIKE?";
 		cntStmt = conn.prepareStatement(cntSql);
 		cntStmt.setString(1, "%"+word+"%");    
 		cntStmt.setString(2, "%"+word+"%");    
 	}
	
	
	ResultSet cntRs = cntStmt.executeQuery();
	int cnt = 0; // 전체 행의 수
    if(cntRs.next()) {
       cnt = cntRs.getInt("cnt");
    }
	int lastPage = (int)(Math.ceil((double)cnt / (double)ROW_PER_PAGE));
  
	ArrayList<Salary> salaryList = new ArrayList<>();
	while(cntRs.next()) {
		Salary s = new Salary();
		s.emp = new Employee(); // ☆☆☆☆☆
		s.emp.empNo = cntRs.getInt("empNo");
		s.salary = cntRs.getInt("salary");
		s.fromDate = cntRs.getString("fromDate");
		s.toDate = cntRs.getString("toDate");
		s.emp.firstName = cntRs.getString("firstName");
		s.emp.lastName = cntRs.getString("lastName");
		salaryList.add(s);
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
		   background-image: url(<%=request.getContextPath()%>/img/cat1.PNG);
		   background-repeat: no-repeat;
		   background-position: right;
		   background-attachment: fixed;
		   background-size: 28% 420px;
		}
		</style>
	</head>
	<body class="background">
		<!-- 메뉴 partial jsp 구성 -->
		<div>
		   <jsp:include page="/inc/menu.jsp"></jsp:include>
		</div>

		<h1 align="center"><p style ="font-weight : 900;" class="text-black"> &#128049;</p></h1>
	
	
		<!-- 내용 검색창 -->
		<form action="<%=request.getContextPath()%>/emp/empList.jsp" method="get" >
		      <label for="word">사원명 검색 :  </label>
		      <input type="text" name="word" id="word" value="<%=word%>">
		      <button type="submit">검색</button>
	  	 </form>
		<table class="table">
			<%
				for(Salary s : salaryList){
			%>		
					<tr>
						<td><%=request.getContextPath()%>/salary/salaryList1.jsp?s.emp.empNo=<%=s.emp.empNo%></td>
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
		<!-- 3-2. 페이징 -->
		<%
		if(word == null|| word.equals("")){
		%>
			<div align="center">
			<a href="<%=request.getContextPath()%>/salary/salaryList1.jsp?currentPage=1">처음</a>
	
			<%
				if(currentPage > 1) {
			%>
					<a href="<%=request.getContextPath()%>/salary/salaryList1.jsp?currentPage=<%=currentPage-1%>">이전</a>
			<%		
				}
			%>
					<span><%=currentPage%></span>
	
			<%
				if(currentPage < lastPage) {
			%>
				<a href="<%=request.getContextPath()%>/salary/salaryList1.jsp?currentPage=<%=currentPage+1%>">다음</a>	
			<%		
				}
			%>
				<a href="<%=request.getContextPath()%>/salary/salaryList1.jsp?currentPage=<%=lastPage%>">마지막</a>
			</div>
		<%
		} else {
		%>	
			<div align="center">
			<a href="<%=request.getContextPath()%>/salary/salaryList1.jsp?currentPage=1&word=<%=word%>">처음</a>
	
			<%
				if(currentPage > 1) {
			%>
					<a href="<%=request.getContextPath()%>/salary/salaryList1.jsp?currentPage=<%=currentPage-1%>&word=<%=word%>">이전</a>
			<%		
				}
			%>
					<span><%=currentPage%></span>
	
			<%
				if(currentPage < lastPage) {
			%>
				<a href="<%=request.getContextPath()%>/salary/salaryList1.jsp?currentPage=<%=currentPage+1%>&word=<%=word%>">다음</a>	
			<%		
				}
			%>
				<a href="<%=request.getContextPath()%>/salary/salaryList1.jsp?currentPage=<%=lastPage%>&word=<%=word%>">마지막</a>
			</div>
		
		<%	
		}
		%>
	   
	</body>
</html>