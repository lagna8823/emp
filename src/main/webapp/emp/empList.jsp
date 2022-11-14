<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.util.*" %>
<%
	// 1
	// 페이지 알고리즘
	String word = request.getParameter("word");
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
	   currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
   
	// 2
	final int ROW_PER_PAGE = 10;
	int beginRow = (currentPage-1)*ROW_PER_PAGE; // ... Limit beginRow, ROW_PER_PAGE
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
 
	String cntSql = null;
	String empSql = null;
	PreparedStatement cntStmt = null;
	PreparedStatement empStmt = null;
	if(word == null || word.equals("")) {
   		empSql = "SELECT emp_no empNo, first_name firstName, last_name lastName FROM employees ORDER BY emp_no ASC LIMIT ?, ?";
		empStmt = conn.prepareStatement(empSql);
		empStmt.setInt(1, beginRow);
		empStmt.setInt(2, ROW_PER_PAGE);
		cntSql = "SELECT COUNT(*) cnt FROM employees";
		cntStmt = conn.prepareStatement(cntSql); 
		word="";
		} else {
      		empSql = "SELECT emp_no empNo, first_name firstName, last_name lastName FROM employees WHERE first_name LIKE ? OR last_name LIKE ? ORDER BY emp_no ASC LIMIT ?, ?";
			empStmt = conn.prepareStatement(empSql);
			empStmt.setString(1, "%"+word+"%"); 
			empStmt.setString(2, "%"+word+"%"); 
			empStmt.setInt(3, beginRow);
			empStmt.setInt(4, ROW_PER_PAGE);         
			cntSql = "SELECT COUNT(*) cnt FROM employees WHERE first_name LIKE ? OR last_name LIKE?";
			cntStmt = conn.prepareStatement(cntSql);
			cntStmt.setString(1, "%"+word+"%");    
			cntStmt.setString(2, "%"+word+"%");    
		}

	ResultSet cntRs = cntStmt.executeQuery();
	int cnt = 0;
	if(cntRs.next()) {
	   cnt = cntRs.getInt("cnt");
	}
   
   int lastPage = cnt / ROW_PER_PAGE;
   if(cnt % ROW_PER_PAGE != 0) {
      lastPage = lastPage + 1; // lastPage++, lastPage+=1
   }
   
   // 한페이지당 출력할 emp목록
   ResultSet empRs = empStmt.executeQuery();
   ArrayList<Employee> empList = new ArrayList<Employee>();
   while(empRs.next()) {
      Employee e = new Employee();
      e.empNo = empRs.getInt("empNo");
      e.firstName = empRs.getString("firstName");
      e.lastName = empRs.getString("lastName");   
      empList.add(e); //empList에 e참조값들을 넣는다 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   }
%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Insert title here</title>
	</head>
	<body>
	   <!-- 메뉴 partial jsp 구성 -->
	   <div>
	      <jsp:include page="/inc/menu.jsp"></jsp:include>
	   </div>   
	   
	   <h1>사원목록</h1>
	  <!-- 내용 검색창 -->
		<form action="<%=request.getContextPath()%>/emp/empList.jsp" method="get" >
		      <label for="word">사원명 검색 :  </label>
		      <input type="text" name="word" id="word" value="<%=word%>">
		      <button type="submit">검색</button>
	  	 </form>
	  	 <div align="right" >
			<a href="<%=request.getContextPath()%>/board/insertBoardForm.jsp?" ><span class="font1">&#9997;게시글 입력</span></a>
		</div>
	   <div>
	    <table board="1">
			<a href="<%=request.getContextPath()%>/emp/insertEmpForm.jsp?">사원 추가</a>
		</div>
		</table>
	   <div>현재 페이지 : <%=currentPage%></div>
	   <table border="1">
	      <tr>
	         <th>사원번호</th>
	         <th>퍼스트네임</th>
	         <th>라스트네임</th>
	      </tr>
	      <%
	         for(Employee e : empList) {
	      %>
	            <tr>
	               <td><%=e.empNo%></td>
	               <td><%=e.firstName%></td>
	               <td><%=e.lastName%></td>
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
			<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=1">처음</a>
	
			<%
				if(currentPage > 1) {
			%>
					<a href="<%=request.getContextPath()%>>/emp/empList.jsp?currentPage=<%=currentPage-1%>">이전</a>
			<%		
				}
			%>
					<span><%=currentPage%></span>
	
			<%
				if(currentPage < lastPage) {
			%>
				<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage+1%>">다음</a>   
			<%		
				}
			%>
				<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=lastPage%>">마지막</a>
			</div>
		<%
		} else {
		%>	
			<div align="center">
			<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=1&word=<%=word%>">처음</a>
	
			<%
				if(currentPage > 1) {
			%>
					<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage-1%>&word=<%=word%>">이전</a>
			<%		
				}
			%>
					<span><%=currentPage%></span>
	
			<%
				if(currentPage < lastPage) {
			%>
				<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage+1%>&word=<%=word%>">다음</a>	
			<%		
				}
			%>
				<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=lastPage%>&word=<%=word%>">마지막</a>
			</div>
		
		<%	
		}
		%>
	</body>
</html>