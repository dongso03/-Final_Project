<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 찾기</title>
</head>
<body>
<h3>회원정보 검색</h3>
${ error }
	<form action="/pwInquiry.do" method="POST">
		ID: <input type="text" name="id"> 
		비밀번호: <input type="password" name="password"> 
		<input type="hidden" name="job"	value="idSearch"> 
		<input type="submit" value="검색">
	</form>
</body>
</html>