<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "vo.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<!DOCTYPE html>
<html>
   <head>
      <meta charset="UTF-8">
      <title>index.jsp</title>
      
      <!-- 부트스트랩과의 약속! -->
      <!-- Latest compiled and minified CSS -->
      <nk href="https://cdn.jsdevr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
      <!-- Latest compiled JavaScript -->
      <script src="https://cdn.jsdevr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
      
      <!--스타일 -->
		<style>
		.background{
		   background-image: url(<%=request.getContextPath()%>/img/cat.jpg);
		   background-repeat: no-repeat;
		   background-position: center
		   background-attachment: fixed;
		   background-size: 100% 800px;
		}	
		
		</style>
   </head>
   <body class="background">
      <!-- 메뉴 patial jsp 구성-->
         <div>
            <jsp:include page="./inc/menu.jsp"></jsp:include> <!-- include에 한해서는 emp주체? 이기에  -->
         </div>
		<p class="h1 text-center" >INDEX</p>
		<table style="width: 100%; height: 400px; text-align: center;">
			<tr>
				<td>
					 <a href="<%=request.getContextPath()%>/dept/deptList.jsp" style="text-decoration: none;">
		     		 	<p class="h2 text-center rounded-circle"><mark>부서관리</mark></p>
		  			 </a>
				</td>
			</tr>
			<tr>
				<td>
					<a href="<%=request.getContextPath()%>/emp/empList.jsp" style="text-decoration: none;">
				    	<p class="h2 text-center "><mark>사원관리</mark></p>
				    </a>  
				</td>
			</tr>
			<tr>
				<td>
					<a href="<%=request.getContextPath()%>/board/boardList.jsp" style="text-decoration: none;">
		      			<p class="h2 text-center "><mark>게시판관리</mark></p>	
		      		</a> 
				</td>
			</tr>
			
			<tr>
				<td>
					<a href="<%=request.getContextPath()%>/salary/salarylist1.jsp" style="text-decoration: none;">
					    <p class="h2 text-center "><mark>연봉관리</mark></p>
				    </a>  
				</td>
			</tr>
		</table>     				     		
   </body>
</html>

