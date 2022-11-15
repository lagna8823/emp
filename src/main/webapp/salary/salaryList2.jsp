<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %><!-- HashMap<키,값>, ArrayList<요소> -->
<%
	 // 1 요청 분석 검색기능, 페이징...
	 String word = request.getParameter("word");
	 int currentPage = 1;
	 if(request.getParameter("currentPage") != null) {
	    currentPage = Integer.parseInt(request.getParameter("currentPage"));
	 }
	 
	 // 2. 요청처리 
	 final int ROW_PER_PAGE = 10; // 상수 선언 문법
	 int beginRow = (currentPage-1)*ROW_PER_PAGE; 
	 
	 //드라이버 로딩 및 DB 연결
	 Class.forName("org.mariadb.jdbc.Driver");
	 Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
 	 
 	// 검색기능 
 	String cntSql = null;
 	PreparedStatement cntStmt = null;
 	if(word == null || word.equals("")) {
 		cntSql = "SELECT COUNT(*) cnt FROM salaries";
 		cntStmt = conn.prepareStatement(cntSql);		
 	} else {
 		cntSql = "SELECT COUNT(*) cnt FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no WHERE e.first_name LIKE ? OR e.last_name LIKE?";
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
	
 	//	조건 검색(LIKE)
 	String salarySql = null;
	PreparedStatement salaryStmt = null; 
	if(word == null || word.equals("")) {
		salarySql = "SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, s.to_date toDate, CONCAT(e.first_name, ' ' ,e.last_name) name FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no ORDER BY s.emp_no ASC LIMIT ?,?";
		salaryStmt = conn.prepareStatement(salarySql);
		salaryStmt.setInt(1, beginRow);
		salaryStmt.setInt(2, ROW_PER_PAGE);
 		word="";	
	} else {
		salarySql = "SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, s.to_date toDate, CONCAT(e.first_name, ' ' ,e.last_name) name  FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no WHERE e.first_name LIKE ? OR e.last_name LIKE ? ORDER BY s.emp_no ASC LIMIT ?,?";
		salaryStmt = conn.prepareStatement(salarySql);
		salaryStmt.setString(1, "%"+word+"%");    
		salaryStmt.setString(2, "%"+word+"%");    
		salaryStmt.setInt(3, beginRow);
		salaryStmt.setInt(4, ROW_PER_PAGE);
	}
	
	//조건 결과 Array 및 해쉬맵으로 클래스 없이 값 저장하기
	ResultSet salaryRs = salaryStmt.executeQuery();
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	while(salaryRs.next()) {
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("empNo", salaryRs.getInt("empNo"));
		m.put("salary", salaryRs.getInt("salary"));
		m.put("fromDate", salaryRs.getString("fromDate"));
		m.put("toDate", salaryRs.getString("toDate"));
		m.put("Name", salaryRs.getString("Name"));
		list.add(m);
	}	
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>salaryList2.jsp</title>
		
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
	  	
	  	<!-- 폼작성 -->
		<table class="table table-hover w-auot">
			<tr>
				<th>사번</th>
				<th>연봉</th>
				<th>입사일</th>
				<th>퇴사일</th>
				<th>이름</th>
			</tr>
			<%
				for(HashMap<String, Object> m : list){
			%>		
					<tr>
						<td><%=m.get("empNo")%></td>
						<td><%=m.get("salary")%></td>
						<td><%=m.get("fromDate")%></td>
						<td><%=m.get("toDate")%></td>
						<td><%=m.get("Name")%></td>					
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