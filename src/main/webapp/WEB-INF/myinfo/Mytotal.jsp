<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page isELIgnored="true"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>내게시물</title>
<!-- Bootstrap icons-->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css"
	rel="stylesheet" />
<!-- Custom CSS for Table and Pagination -->
<style>
/* Custom CSS for Table */
.table {
	width: 100%;
	margin-bottom: 1rem;
	background-color: transparent;
}

.table th, .table td {
	padding: 0.75rem;
	vertical-align: top;
	border-top: 1px solid #dee2e6;
}

.table thead th {
	vertical-align: bottom;
	border-bottom: 2px solid #dee2e6;
}

/* Custom CSS for Pagination */
.pagination {
	margin-top: 20px;
}

.pagination .page-item {
	display: inline-block;
}

.pagination .page-item .page-link {
	color: #007bff;
	border: 1px solid #dee2e6;
	padding: 0.375rem 0.75rem;
}

.pagination .page-item.active .page-link {
	z-index: 1;
	color: #fff;
	background-color: #007bff;
	border-color: #007bff;
}

.pagination .page-link {
	position: relative;
	display: block;
	padding: 0.5rem 0.75rem;
	margin-left: -1px;
	line-height: 1.25;
	text-decoration: none;
	background-color: #fff;
	border: 1px solid #dee2e6;
}

.pagination .page-link:hover {
	z-index: 2;
	color: #0056b3;
	text-decoration: none;
	background-color: #e9ecef;
	border-color: #dee2e6;
}

/* Custom CSS for buttons */
.btn-small {
	padding: 0.2rem 0.5rem;
	font-size: 0.8rem;
}

/* Custom CSS for button group */
.btn-group-sm .btn {
	padding: 0.2rem 0.5rem;
	font-size: 0.8rem;
}
</style>
</head>
<body class="d-flex flex-column h-100">
	<main class="flex-shrink-0">
		<!-- Navigation-->
		<%@ include file="/WEB-INF/user/navigation.jsp"%>
		<section class="py-5">
			<div class="container px-5">
				<div class="bg-light rounded-4 py-5 px-4 px-md-5">
					<div class="row align-items-center">
						<!-- 내정보 -->
						<div class="col-md-3 mb-3 mb-md-0" style="height: 500px;">
							<%@ include file="/WEB-INF/myinfo/MyInfoSidebar.jsp"%>
						</div>
						<!-- 테이블 -->
						<div class="col-md-9">
							<div class="d-flex flex-column flex-shrink-0 p-3 bg-light">
								<div class="row justify-content-center">
									<div class="col-12">
										<h3>내가쓴글</h3>
										<table class="table table-hover table-bordered" id="postTable">
											<thead class="table-light">
												<tr>
													<th scope="col" style="width: 60%;">제목</th>
													<th scope="col" style="width: 20%;">작성일</th>
													<th scope="col" style="width: 20%;"></th>
												</tr>
											</thead>
											<tbody class="table-group-divider">
												<!--    <tr>
                                                </tr> -->
											</tbody>
										</table>
										<nav aria-label="Page navigation example">
											<ul class="pagination justify-content-center" id="pagination">
												<!-- Pagination dynamically created by JavaScript -->
											</ul>
										</nav>
									</div>
								</div>
							</div>
						</div>
						<h3>내가쓴댓글</h3>
						<div class="col-md-9">
							<div class="d-flex flex-column flex-shrink-0 p-3 bg-light">
								<div class="row justify-content-center">
									<div class="col-12">
										<h3>내가댓 글</h3>
										<table class="table table-hover table-bordered"
											id="reviewTable">
											<thead class="table-light">
												<tr>
													<th scope="col" style="width: 60%;">제목</th>
													<th scope="col" style="width: 20%;">작성일</th>
													<th scope="col" style="width: 20%;"></th>
												</tr>
											</thead>
											<tbody class="table-group-divider" id="reviewtbody">
												<!--    <tr>
                                                </tr> -->
											</tbody>
										</table>
										<nav aria-label="Page navigation example">
											<ul class="pagination justify-content-center"
												id="reviewpagination">
												<!-- Pagination dynamically created by JavaScript -->
											</ul>
										</nav>
									</div>
								</div>
							</div>
						</div>


					</div>
				</div>
			</div>
		</section>
	</main>
	<%@ include file="/WEB-INF/layout/footer.jsp"%>

</body>
<script type="text/javascript">
	const postTable = document.getElementById("postTable");
	const pagination = document.getElementById("pagination");
    const reviewTable = document.getElementById("reviewTable");
    const reviewpagination = document.getElementById("reviewpagination");
    
    const tbody = postTable.querySelector("tbody");
    const reviewtbody = document.getElementById("reviewtbody");
    let currentPage = 1; // 초기 페이지는 1로 설정
    const itemsPerPage = 5; // 페이지당 아이템 수

    // 페이지를 로드할 때 초기 데이터를 가져오는 함수 호출
    loadPosts(currentPage);
    loadreviews(currentPage);
    
    function loadreviews(page) {
        fetch(`/review/list?page=${page}&pagePer=${itemsPerPage}`, {
            method: 'POST'
        })
        .then((resp) => resp.json())
        .then((data) => {
            tbody.innerHTML = ""; // 기존 게시물 내용 초기화
            
            data.items.forEach((element) => {
                let contenttr = document.createElement("tr");
                let tdTitle = document.createElement("td");
                let tdResistDate = document.createElement("td");
                let tdActions = document.createElement("td"); // 수정 및 삭제 버튼을 포함할 셀
                
                tdTitle.innerText = `${element.review}`;
                tdResistDate.innerText = `${element.resistdate}`;
                
                // 클릭 이벤트 추가하여 상세 페이지로 이동
                contenttr.addEventListener("click", () => {
                    window.location.href = `/post/detail?post_Id=${element.postId}`;
                });
                
                
                // 수정 버튼 생성
                let editButton = document.createElement("button");
                editButton.textContent = "수정";
                editButton.classList.add("btn", "btn-primary", "btn-small", "mx-1");
                editButton.addEventListener("click", () => {
                    // 수정 기능 수행
                    console.log(`수정 버튼 클릭 - 게시물 ID: ${element.post_Id}`);
                });
                
                // 삭제 버튼 생성
                let deleteButton = document.createElement("button");
                deleteButton.textContent = "삭제";
                deleteButton.classList.add("btn", "btn-danger", "btn-small", "mx-1");
                deleteButton.addEventListener("click", () => {
                    // 삭제 기능 수행
                    console.log(`삭제 버튼 클릭 - 게시물 ID: ${element.post_Id}`);
                });
                
                // 버튼을 셀에 추가
                tdActions.appendChild(editButton);
                tdActions.appendChild(deleteButton);
                
                contenttr.appendChild(tdTitle);
                contenttr.appendChild(tdResistDate);
                contenttr.appendChild(tdActions); // 수정 및 삭제 버튼을 포함한 셀 추가
                reviewtbody.appendChild(contenttr);
            });
            
            displayPagination(data.totalPages, page); // 페이지네이션 표시
        });
    }
    function loadPosts(page) {
    	
        fetch(`/post/mypostlist?page=${page}&pagePer=${itemsPerPage}`, {
            method: 'POST'
        })
        .then((resp) => resp.json())
        .then((data) => {
            tbody.innerHTML = ""; // 기존 게시물 내용 초기화
            
	    	 const maxTitleLength = 12; // 예시로 20자로 설정
            
            data.items.forEach((element) => {
                let contenttr = document.createElement("tr");
                let tdTitle = document.createElement("td");
                let tdResistDate = document.createElement("td");
                let tdActions = document.createElement("td"); // 수정 및 삭제 버튼을 포함할 셀
                
                tdTitle.innerText = element.title.length > maxTitleLength ? element.title.substring(0, maxTitleLength) + '...' : element.title;
                tdResistDate.innerText = `${element.resistdate}`;
                
                // 클릭 이벤트 추가하여 상세 페이지로 이동
                contenttr.addEventListener("click", () => {
                    window.location.href = `/post/detail?post_Id=${element.post_Id}`;
                });
                
                // 수정 버튼 생성
                let editButton = document.createElement("button");
                editButton.textContent = "수정";
                editButton.classList.add("btn", "btn-primary", "btn-small", "mx-1");
                editButton.addEventListener("click", () => {
                    // 수정 기능 수행
                    console.log(`수정 버튼 클릭 - 게시물 ID: ${element.post_Id}`);
                });
                
                // 삭제 버튼 생성
                let deleteButton = document.createElement("button");
                deleteButton.textContent = "삭제";
                deleteButton.classList.add("btn", "btn-danger", "btn-small", "mx-1");
                deleteButton.addEventListener("click", () => {
                    // 삭제 기능 수행
                    console.log(`삭제 버튼 클릭 - 게시물 ID: ${element.post_Id}`);
                });
                
                // 버튼을 셀에 추가
                tdActions.appendChild(editButton);
                tdActions.appendChild(deleteButton);
                
                contenttr.appendChild(tdTitle);
                contenttr.appendChild(tdResistDate);
                contenttr.appendChild(tdActions); // 수정 및 삭제 버튼을 포함한 셀 추가
                tbody.appendChild(contenttr);
            });
            
            displayPagination(data.totalPages, page); // 페이지네이션 표시
        });
    }

    function displayPagination(totalPages, currentPage) {
        let pagination = document.getElementById("pagination"); // 페이지네이션 요소
        pagination.innerHTML = ""; // 페이지네이션 초기화
        
        // 첫 페이지로 이동하는 버튼 추가
        let firstPage = createPaginationItem("First", "&lt;&lt;");
        pagination.appendChild(firstPage);
        
        // 이전 페이지 버튼 추가
        let previous = createPaginationItem("Previous", "&laquo;");
        pagination.appendChild(previous);
        
        // 페이지 번호 버튼 추가
        let startPage;
        let endPage;
        
        // 페이지 번호가 5개 이하인 경우
        if (totalPages <= 5) {
            startPage = 1;
            endPage = totalPages;
        } else { // 페이지 번호가 5개를 초과하는 경우
            if (currentPage <= 3) { // 현재 페이지가 3 이하인 경우
                startPage = 1;
                endPage = 5;
            } else if (currentPage >= totalPages - 2) { // 현재 페이지가 마지막에서 2페이지 이하인 경우
                startPage = totalPages - 4;
                endPage = totalPages;
            } else { // 현재 페이지가 중간인 경우
                startPage = currentPage - 2;
                endPage = currentPage + 2;
            }
        }
        
        for (let i = startPage; i <= endPage; i++) {
            let pagelist = createPaginationItem(i);
            pagination.appendChild(pagelist);
        }
        
        // 다음 페이지 버튼 추가
        let next = createPaginationItem("Next", "&raquo;");
        pagination.appendChild(next);
        
        // 마지막 페이지로 이동하는 버튼 추가
        let lastPage = createPaginationItem("Last", "&gt;&gt;");
        pagination.appendChild(lastPage);
        
        // 현재 페이지 버튼 활성화
        let activePageButton = pagination.querySelector(`[data-page="${currentPage}"]`);
        if (activePageButton) {
            activePageButton.classList.add("active");
        }
        
        // 첫 페이지 버튼 클릭 이벤트 설정
        firstPage.addEventListener("click", () => {
            loadPosts(1); // 첫 페이지의 데이터 로드
        });

        // 이전 페이지 버튼 클릭 이벤트 설정
        previous.addEventListener("click", () => {
            if (currentPage > 1) {
                loadPosts(currentPage - 1); // 이전 페이지의 데이터 로드
            }
        });

        // 다음 페이지 버튼 클릭 이벤트 설정
        next.addEventListener("click", () => {
            if (currentPage < totalPages) {
                loadPosts(currentPage + 1); // 다음 페이지의 데이터 로드
            }
        });
        
        // 마지막 페이지 버튼 클릭 이벤트 설정
        lastPage.addEventListener("click", () => {
            loadPosts(totalPages); // 마지막 페이지의 데이터 로드
        });
    }


    // 페이지네이션 아이템을 생성하는 함수
    function createPaginationItem(label, innerHTML) {
        let listItem = document.createElement("li");
        listItem.classList.add("page-item");
        
        let link = document.createElement("a");
        link.classList.add("page-link");
        link.href = "#"; // 기본적으로 페이지 번호는 현재 페이지로 이동하는 주소를 가집니다.
        link.innerText = label;
        link.setAttribute("data-page", label); // 페이지 번호를 버튼에 데이터 속성으로 추가합니다.
        
        if (label === "Previous" || label === "Next" || label === "First" || label === "Last") {
            link.setAttribute("aria-label", label);
            link.innerHTML = innerHTML || label;
        } else {
            link.addEventListener("click", () => {
                if (label === "First" || label === "Last") {
                    return; // "First"나 "Last" 버튼 클릭 시 페이지 요청을 보내지 않습니다.
                }
                loadPosts(label); // 해당 페이지의 데이터 로드
                
                // 활성화된 버튼 표시
                let pageButtons = pagination.querySelectorAll(".page-link");
                pageButtons.forEach(button => {
                    button.classList.remove("active");
                });
                link.classList.add("active");
            });
        }
        
        listItem.appendChild(link);
        
        return listItem;
    }
</script>
</html>
