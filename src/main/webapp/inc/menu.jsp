<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
   <head>
      <meta charset="UTF-8">
      <title>index.jsp</title>
      
      <!-- 부트스트랩과의 약속! -->
      <!-- Latest compiled and minified CSS -->
      <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
      <!-- Latest compiled JavaScript -->
      <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
      
      
	</head>
	<body>	
		<!-- partial jsp 페이지 사용할 코드-->
		<div ="bold" >
			<a href="<%=request.getContextPath() %>/index.jsp" style="text-decoration: none;">
				<span class="bg-warning">[홈으로]</span>
			</a>
			<a href="<%=request.getContextPath() %>/dept/deptList.jsp" style="text-decoration: none;">
				<span class="bg-warning">[부서관리]</span>
			</a>
			<a href="<%=request.getContextPath() %>/emp/empList.jsp" style="text-decoration: none;">
				<span class="bg-warning">[사원관리]</span>
			</a>		
			<a href="<%=request.getContextPath() %>/" style="text-decoration: none;">
				<span class="bg-warning">[연봉관리]</span>
			</a>		
			<a href="<%=request.getContextPath() %>/board/boardList.jsp" style="text-decoration: none;">
				<span class="bg-warning">[게시판관리]</span>
			</a>		
		</div>
	</body>
</html>