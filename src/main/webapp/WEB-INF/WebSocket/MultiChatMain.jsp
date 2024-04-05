<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>웹소켓 채팅</title>
</head>
<body>
	<script>
		function chatWinOpen() {
			var nickname = document.getElementById("user.nickname").value; // 사용자의 닉네임 가져오기
			window.open("ChatWindow?user.nickname=" + user.nickname, "", "width=400, height=450");
		}
	</script>
	<h2>웹소켓 채팅 - 게시물에 대화참여 누르면 채팅방 참여하게 만들어야 함</h2>
	<h3>채팅방 입장할때 유저의 닉네임 가지고 오기</h3>
	<h4></h4>
	대화명 :<input type="text" id="chatId" readonly/> 
	<!-- id는 나중에 user.getNickname으로 변경한후 대화명 삭제 하기 -->
	<button onclick="chatWinOpen();">채팅 참여</button>
</body>

</html>