<%@page import="user.UserService"%>
<%@page import="user.User"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="javax.sql.DataSource"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link
    href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"
    rel="stylesheet">
<meta charset="UTF-8">
<title>채팅창 구현</title>
<script>
        var webSocket = new WebSocket('<%=application.getInitParameter("CHAT_ADDR")%>/PersonalChatWindow/${ userid }');
        var userId = "${ userid }"; // userId 변수를 WebSocket 주소 설정 이전에 정의
        var personalChatWindow, chatMessage, nickname;

        // 채팅창이 열리면 대화창, 메시지 입력창, 대화명 표시란으로 사용할 DOM 객체 저장
        window.onload = function () {
            personalChatWindow = document.getElementById("personalChatWindow");
            chatMessage = document.getElementById("chatMessage");
            nickname = document.getElementById("nickname").value;

            // userId에 해당하는 사용자의 닉네임 가져오기
            fetch('/person/personalChatWindow/' + userId)
                .then(response => response.json())
                .then(data => {
                    const opponentNickname = data.nickname;
                    console.log("상대방 닉네임:", opponentNickname);
                    // 상대방 닉네임을 표시할 요소에 닉네임 설정
                    document.getElementById("opponentnickname").innerText = opponentNickname;
                })
                .catch(error => {
                    console.error('Error:', error);
                });
        }

        // 메시지 전송
        function sendMessage() {
            var messageContent = chatMessage.value; // 메시지 내용
            if (!messageContent) { // 메시지가 비어있는 경우 전송하지 않음
                return;
            }
			
            // JSON 데이터 생성
            var jsonData = {
                sender: nickname,
                content: messageContent,
            };

            // 서버로 JSON 데이터 전송
            webSocket.send(JSON.stringify(jsonData));

            // 메시지 입력창 내용 지우기
            chatMessage.value = "";
        }

        // 엔터 키 입력 처리
        function enterKey() {
            if (window.event.keyCode == 13) { // 13은 'Enter' 키의 코드값
                sendMessage();
            }
        }

        // 웹소켓 서버에 연결됐을 때 실행
        webSocket.onopen = function (event) {
            personalChatWindow.innerHTML += "채팅창에 연결 되었습니다.<br/>";
        };

        // 웹소켓이 닫혔을 때(서버와의 연결이 끊켰을 때) 실행
        webSocket.onclose = function (event) {
            alert("서버와의 연결이 종료되었습니다.");
            window.close();
        };

        webSocket.onerror = function (event) {
            alert(event.data);
            personalChatWindow.innerHTML += "채팅 중 에러가 발생하였습니다.<br/>";
        };

        webSocket.onmessage = function (event) {
            var message = JSON.parse(event.data); // JSON 형식으로 메시지 파싱
            var sender = message.sender; // 메시지를 보낸 사용자
            var content = message.content; // 메시지 내용
            // 일반 메시지 표시
            var messageHtml = "";
            if (sender === nickname) {
                // 보낸 사람의 채팅은 오른쪽에 표시
                messageHtml = "<div class='myMsg'><strong>" + sender + ": </strong>" + content + "<span class='time'>" + "</span></div>";
            } else {
                // 받는 사람의 채팅은 왼쪽에 표시
                messageHtml = "<div class='otherMsg'><strong>" + sender + ": </strong>" + content + "<span class='time'>" + "</span></div>";
            }
            personalChatWindow.innerHTML += messageHtml;
            // 대화창 스크롤
            personalChatWindow.scrollTop = personalChatWindow.scrollHeight;
        };

        function disconnect() {
            // 웹소켓 연결 종료
            webSocket.close();
            window.close();
        }

        function getUserIdFromCookie(cookieName) {
            const name = cookieName + "=";
            const decodedCookie = decodeURIComponent(document.cookie);
            const cookieArray = decodedCookie.split(';');
            for (let i = 0; i < cookieArray.length; i++) {
                let cookie = cookieArray[i];
                while (cookie.charAt(0) === ' ') {
                    cookie = cookie.substring(1);
                }
                if (cookie.indexOf(name) === 0) {
                    return cookie.substring(name.length, cookie.length);
                }
            }
            return "";
        }
    </script>
<style>
/* 전체 채팅창 스타일 */
#personalChatWindow {
    border: 1px solid #ccc; /* 테두리 추가 */
    width: 380px;
    height: 310px;
    overflow-y: scroll; /* 세로 스크롤만 보이도록 설정 */
    padding: 5px;
}

body {
    background-color: pink; /* 배경색을 핑크색으로 지정 */
}

/* 대화 입력창 스타일 */
#chatMessage {
    width: 300px;
    height: 60px;
    border: 4px solid #ccc; /* 테두리 설정 */
    margin-top: 5px;
    margin-left: 1px;
}

/* 전송 버튼 스타일 */
#sendBtn {
    width: 80px;
    height: 60px;
    border: none; /* 테두리 제거 */
    cursor: pointer; /* 커서를 포인터로 변경하여 클릭 가능함을 나타냄 */
    border-radius: 5px; /* 모서리를 둥글게 만듦 */
    margin-top: 0px; /* 상단 여백 설정 */
    margin-left: 0px; /* 왼쪽 여백 설정 */
    display: inline-block; /* 인라인 블록 요소로 설정하여 다른 요소와 옆에 위치하게 함 */
}

/* 대화명 입력창 스타일 */
#nickname {
    width: 100px;
    height: 25px;
    border: 1px solid #ccc; /* 테두리 추가 */
}

/* 게시판 번호 스타일 */
#post_id {
    font-weight: bold; /* 굵은 글꼴 */
    color: blue; /* 파란색 */
}

/* 종료 버튼 스타일 */
#closeBtn {
    margin-bottom: 10px; /* 하단 여백 */
}

/* 채팅 메시지 스타일 */
.myMsg {
    text-align: right; /* 오른쪽 정렬 */
    margin-bottom: 5px; /* 하단 여백 */
}

.otherMsg {
    text-align: left; /* 왼쪽 정렬 */
    margin-bottom: 5px; /* 하단 여백 */
}

/* 귓속말 메시지 스타일 */
.whisper-received {
    color: green; /* 받은 귓속말은 초록색 */
}

.whisper-sent {
    color: blue; /* 보낸 귓속말은 파란색 */
}

/* 시간 스타일 */
.time {
    color: #888; /* 회색 */
    font-size: 12px; /* 작은 글꼴 */
}

#exitBtn {
    margin-top: 60px; /* 위쪽 여백 */
    float: right; /* 오른쪽 정렬 */
    clear: both; /* 다음 요소와 겹치지 않게 함 */
    display: block; /* 블록 요소로 설정하여 줄바꿈을 만듦 */
    border: none; /* 테두리 제거 */
    padding: 10px 20px; /* 내부 여백 설정 */
    cursor: pointer; /* 커서를 포인터로 변경하여 클릭 가능함을 나타냄 */
    border-radius: 5px; /* 모서리를 둥글게 만듦 */
}

#closeBtn {
    border: none;
    border-radius: 5px;
    width: 120px;
    height: 30px;
    background-color: #FFFFD0;
}
/* .btn-dark 클래스의 배경색을 회색(#808080)으로 설정 */
.btn-dark {
    background-color: #808080;
}

/* .btn-dark 클래스의 테두리 색을 회색(#808080)으로 설정 */
.btn-dark {
    border-color: #808080;
}

/* .btn-dark 클래스의 텍스트 색을 흰색(#ffffff)으로 설정 */
.btn-dark {
    color: #ffffff;
}
</style>
</head>
<body>
    <label id="라벨">닉네임</label> :
    <input type="text" id="nickname" value="${ user.nickname }" readonly />
    <br>
    <label id="opponentnickname">상대방닉네임</label> :
    <span id="opponentnickname"></span>
    <button id="closeBtn" onclick="disconnect();">채팅 종료</button>
    <div id="personalChatWindow"></div>
    <div>
        <input type="text" id="chatMessage" onkeyup="enterKey();">
        <button id="sendBtn" class="btn btn-dark" onclick="sendMessage();">전송</button>
        <button id="exitBtn" class="btn btn-dark" onclick="exitChatroom();">채팅방
            나가기</button>
    </div>
</body>
</html>
