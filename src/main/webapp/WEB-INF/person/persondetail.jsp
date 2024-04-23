<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib uri="http://java.sun.com/jsp/jstl/core"
prefix="c"%> <%@ page isELIgnored="true"%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>사람 상세</title>
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css"
      rel="stylesheet"
    />
    <link href="../Resources/css/styles.css" rel="stylesheet" />
    <style>
      .topcontainer {
        display: flex;
        justify-content: space-between;
        border: 2px solid gray;
        padding: 10px;
        border-radius: 10px;
      }

      .image-container {
        width: 30%;
        display: flex;
        justify-content: center;
        align-items: center;
      }

      .image {
        width: 200px;
        height: 200px;
        background-color: white;
        border-radius: 50%;
      }

      .info-container {
        width: 65%;
        height: 270px;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        margin-top: 20px;
        display: flex;
      }

      .info {
        border: 2px solid gray;
        padding: 10px;
        border-radius: 10px;
        margin: 5px 0;
      }

      .review {
        border: 2px solid gray;
        padding: 10px;
        border-radius: 10px;
        margin-top: 20px;
      }

      .actions-container {
        display: flex;
        justify-content: space-around;
        margin-top: 20px;
      }

      .action {
        width: 30%;
        border: 2px solid gray;
        height: 50px;
        text-align: center;
        line-height: 50px;
      }
      /* 별 모양을 만드는 CSS */
      .star-rating {
        font-size: 0;
        display: flex;
        flex-direction: row-reverse; /* 별을 오른쪽에서 왼쪽으로 배치 */
        justify-content: flex-end;
      }

      .star-rating label {
        font-size: 30px;
      }

      /* Bootstrap Icons로 별 모양을 변경 */
      .star-rating label:before {
        content: "\E256"; /* 별 아이콘의 유니코드 값 */
        display: inline-block;
        font-family: "Bootstrap Icons"; /* Bootstrap Icons 폰트 패밀리 지정 */
        color: #ccc; /* 비활성화된 별 아이콘의 색상 */
      }

      /* 활성화된 별 아이콘 색상 변경 */
      .star-rating label.active:before {
        color: gold; /* 활성화된 별 아이콘의 색상을 변경할 수 있습니다. */
      }
    </style>
  </head>
  <body>
    <%@ include file="../user/navigation.jsp"%>
    <div class="total" style="margin: 0 20%">
      <br />
      <h3>프로필</h3>
      <div class="topcontainer">
        <div class="image-container">
          <div class="image"></div>
        </div>

        <div class="info-container">
          <div
            class="info"
            style="
              height: 200px;
              overflow: auto;
              display: flex;
              align-items: center;
            "
          >
            <ul if="personinfo">
              <li id="nickname">이름</li>
              <li id="age">나이</li>
              <li id="starContainer">별점</li>
              <li id="bloodtype">혈액형</li>
              <li id="mbti">mbti</li>
            </ul>
          </div>
          <div class="info" style="height: 100px; overflow: auto">
            자기소개 내용이 길어지면? <br />
            자기소개 <br />
            <br />
            <br />
            <br />
            <br />
            <br />
            <br />
            <br />
            <br />
            <br />
            <br />
            <br />
            <br />
            <br />
            <br />GMA..fsdafsd <br />
            <br />
            <br />sdsa <br />sda
          </div>
        </div>
      </div>

      <br />

      <h3>글목록</h3>
      <div style="border: 2px solid gray; padding: 10px; border-radius: 10px">
        <div>
          <input
            type="radio"
            id="progressing"
            name="status"
            value="progressing"
            checked
          />
          <label for="progressing">진행중</label>
          <!-- <input type="radio" id="completed" name="status" value="completed">
				<label for="completed">완료</label> -->
        </div>

        <br />
        <div style="padding: 3px">
          <div id="postlist">
            <table class="table table-hover table-bordered" id="postTable">
              <thead class="table-light">
                <tr>
                  <th scope="col" style="text-align: center">#</th>
                  <th scope="col">제목</th>
                  <th scope="col">작성일</th>
                  <th scope="col">조회수</th>
                </tr>
              </thead>
              <tbody class="table-group-divider">
                <!-- 데이터는 JavaScript로 채웁니다 -->
              </tbody>
            </table>
            <nav aria-label="Page navigation example">
              <ul
                class="pagination justify-content-center"
                id="pagination"
              ></ul>
              <!-- &nbsp;&nbsp;&nbsp; -->
            </nav>
          </div>
        </div>
      </div>
      <br />

      <!-- 	<h3>한줄 후기</h3>

		<div class="review"padding: 10px;">사장님이 맛있고 음식이 친절해요</div>
		 -->

      <div class="actions-container">
        <button class="action" id="friendbtn" style="border-radius: 10px">
          친구추가
        </button>
        <button class="action" id="chatbtn" style="border-radius: 10px"
         onclick="openPersonalChatWindow()">대화신청</button>
        <div class="action" style="border-radius: 10px">블랙리스트등록</div>
      </div>
    </div>
  </body>
  <script>
    const postlist = document.getElementById("postlist");

    const postTable = document.getElementById("postTable");
    const pagination = document.getElementById("pagination");

    let currentPage = 1; // 초기 페이지는 1로 설정
    const itemsPerPage = 3; // 페이지당 아이템 수

    const tbody = postTable.querySelector("tbody");

    const urlParams = new URLSearchParams(window.location.search);
    const userid = urlParams.get("userid");

    const progressingRadio = document.getElementById("progressing");
    const completedRadio = document.getElementById("completed");
    const friendbtn = document.getElementById("friendbtn");

    fetch(`/person/personinfo?userid=${userid}`, {
      method: "PUT",
    })
      .then((resp) => resp.json())
      .then((data) => {
        const nickname = document.getElementById("nickname");
        const age = document.getElementById("age");
        const bloodtype = document.getElementById("bloodtype");
        const mbti = document.getElementById("mbti");
        const rating = document.getElementById("rating");

        // userinfo 객체에서 user 정보를 가져옵니다.
        const user = data.user;

        // 사용자 정보를 화면에 출력합니다.
        nickname.innerText = `닉네임: ${user.nickname}`;
        age.innerText = `나이: ${user.age}`;
        bloodtype.innerText = `혈액형: ${user.bloodtype}`;
        mbti.innerText = `MBTI: ${user.mbti}`;

        // userinfo 객체에서 rating 정보를 가져옵니다.
        const averageRating = data.rating.toFixed(0); // 별점을 정수로 반올림하여 계산
        const starContainer = document.getElementById("starContainer");
        starContainer.innerHTML = ""; // 기존의 별 아이콘을 지웁니다.
        starContainer.innerText = "별점: ";
        // averageRating에 따라 별 아이콘을 채웁니다.
        for (let i = 0; i < 5; i++) {
          const starIcon = document.createElement("i");
          starIcon.classList.add("bi");
          if (i < averageRating) {
            starIcon.classList.add("bi-star-fill", "text-warning");
          } else {
            starIcon.classList.add("bi-star");
          }
          starContainer.appendChild(starIcon);
        }
      });

    //페이지 로드시 실행
    document.addEventListener("DOMContentLoaded", function () {
      // 진행중 라디오 버튼이 선택되어 있는 경우 loadPosts 함수 호출
      if (progressingRadio.checked) {
        function loadPosts(page) {
          fetch(
            `/person/activepostlist?page=${page}&pagePer=${itemsPerPage}&userid=${userid}`,
            {
              method: "POST",
            }
          )
            .then((resp) => resp.json())
            .then((data) => {
              // 게시물 테이블의 내용을 초기화
              tbody.innerHTML = "";
              const maxTitleLength = 20; // 예시로 20자로 설정

              data.items.forEach((element) => {
                let contenttr = document.createElement("tr");
                let tdId = document.createElement("td");
                let tdtitle = document.createElement("td");
                let tdresistdate = document.createElement("td");
                let tdview = document.createElement("td");

                tdId.innerText = `${element.post_Id}`;
                tdtitle.innerText =
                  element.title.length > maxTitleLength
                    ? element.title.substring(0, maxTitleLength) + "..."
                    : element.title;
                tdresistdate.innerText = formattedDate(element);
                tdview.innerText = `${element.view}`;

                // 각 셀에 스코프 및 스타일 지정
                tdId.setAttribute("scope", "col"); // 제목 셀에는 'row' 스코프를 지정합니다.
                tdId.style.width = "5%"; // 제목 셀의 너비를 설정합니다.
                tdtitle.setAttribute("scope", "col");
                tdtitle.style.width = "73%"; // 내용 셀의 너비를 설정합니다.
                tdresistdate.setAttribute("scope", "col");
                tdresistdate.style.width = "15%"; // 작성일 셀의 너비를 설정합니다.
                tdview.setAttribute("scope", "col");
                tdview.style.width = "7%";

                tdId.style.textAlign = "center";
                tdview.style.textAlign = "center";

                // 클릭 이벤트 추가하여 상세 페이지로 이동
                tdtitle.addEventListener("click", () => {
                  window.location.href = `/post/detail?post_Id=${element.post_Id}`;
                });

                contenttr.appendChild(tdId);
                contenttr.appendChild(tdtitle);
                contenttr.appendChild(tdresistdate);
                contenttr.appendChild(tdview);
                tbody.appendChild(contenttr);
              });

              /*    // 페이지네이션 표시
        	        displayPagination(data.totalPages, page); */
            });
        }
      }
      loadPosts(currentPage);
    });
    function formattedDate(element) {
      // MySQL DATETIME 값을 Date 객체로 변환
      const timestamp = Number(element.resistdate);
      const date = new Date(timestamp);

      // 년, 월, 일 추출
      const year = date.getFullYear();
      const month = String(date.getMonth() + 1).padStart(2, "0"); // 월은 0부터 시작하므로 1을 더하고, 2자리로 맞춤
      const day = String(date.getDate()).padStart(2, "0"); // 일은 1일부터 시작하므로 2자리로 맞춤

      // 'YYYY-MM-DD' 형식으로 문자열 조합
      const formattedDate = `${year}-${month}-${day}`;

      return formattedDate;
    }

    // 라디오 버튼 상태가 변경될 때 loadPosts 함수 호출
    progressingRadio.addEventListener("change", () => {
      if (progressingRadio.checked) {
        function loadPosts(page) {
          fetch(
            `/person/activepostlist?page=${page}&pagePer=${itemsPerPage}&userid=${userid}`,
            {
              method: "POST",
            }
          )
            .then((resp) => resp.json())
            .then((data) => {
              // 게시물 테이블의 내용을 초기화
              tbody.innerHTML = "";
              const maxTitleLength = 20; // 예시로 20자로 설정

              data.items.forEach((element) => {
                let contenttr = document.createElement("tr");
                let tdId = document.createElement("td");
                let tdtitle = document.createElement("td");
                let tdresistdate = document.createElement("td");
                let tdview = document.createElement("td");

                tdId.innerText = `${element.post_Id}`;
                tdtitle.innerText =
                  element.title.length > maxTitleLength
                    ? element.title.substring(0, maxTitleLength) + "..."
                    : element.title;
                tdresistdate.innerText = formattedDate(element);
                tdview.innerText = `${element.view}`;

                // 각 셀에 스코프 및 스타일 지정
                tdId.setAttribute("scope", "col"); // 제목 셀에는 'row' 스코프를 지정합니다.
                tdId.style.width = "5%"; // 제목 셀의 너비를 설정합니다.
                tdtitle.setAttribute("scope", "col");
                tdtitle.style.width = "73%"; // 내용 셀의 너비를 설정합니다.
                tdresistdate.setAttribute("scope", "col");
                tdresistdate.style.width = "15%"; // 작성일 셀의 너비를 설정합니다.
                tdview.setAttribute("scope", "col");
                tdview.style.width = "7%";

                tdId.style.textAlign = "center";
                tdview.style.textAlign = "center";

                // 클릭 이벤트 추가하여 상세 페이지로 이동
                tdtitle.addEventListener("click", () => {
                  window.location.href = `/post/detail?post_Id=${element.post_Id}`;
                });

                contenttr.appendChild(tdId);
                contenttr.appendChild(tdtitle);
                contenttr.appendChild(tdresistdate);
                contenttr.appendChild(tdview);
                tbody.appendChild(contenttr);
              });

              /*  // 페이지네이션 표시
     	        displayPagination(data.totalPages, page); */
            });
        }
      }

      loadPosts(currentPage);
    });

    friendbtn.addEventListener("click", () => {
      const requestData = {
        userId: userid,
        action: "add_friend",
      };
      console.log(userid);

      // JSON 데이터를 문자열로 변환
      const jsonData = JSON.stringify(requestData);

      // POST 요청 보내기
      fetch("/add_friend", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonData,
      })
        .then((response) => {
          if (response.ok) {
            response.json().then((data) => {
            	alert(JSON.stringify(data)); // 데이터를 문자열로 변환하여 출력
            });
          } else {
            response.json().then((errorData) => {
              alert("이미 상대방에게 신청이 왔습니다. 친구추가 목록을 확인해 보세요."); // 에러 메시지 출력
            });
          }
        })
        .catch((error) => {
			alert("이미 상대방에게 신청이 왔습니다. 친구추가 목록을 확인해 보세요.");
        });
    });
    
    
    document.addEventListener("DOMContentLoaded", function() {
        // 쿠키에서 닉네임 가져오기
        const currentUserNickname  = getCookieValue("nickname");
    });

    // 쿠키에서 특정 이름의 값 가져오는 함수
    function getCookieValue(name) {
        const cookies = document.cookie.split("; ");
        for (let cookie of cookies) {
            const [cookieName, cookieValue] = cookie.split("=");
            if (cookieName === name) {
                return cookieValue;
            }
        }
        return null;
    }
    
    let personalChatWindow = null;
    // 채팅창 열기 함수
    function openPersonalChatWindow() {
    const currentUserNickname = getCookieValue("nickname"); // 내 닉네임 가져오기
    const chatAddr = '<%=application.getInitParameter("CHAT_ADDR")%>'; // 채팅 서버 주소 가져오기
    if (!personalChatWindow || personalChatWindow.closed) {
        const url = "PersonalChatWindow?&userid=" + userid; // 대화창 열기 URL 생성
        personalChatWindow = window.open(url, "", "width=386, height=564"); // 대화창 열기
    } else {
        personalChatWindow.focus();
    }
}


    
  </script>
  <!-- 페이지 번호 -->
  <script src="/js/pagination.js"></script>
</html>
