<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
</head>
<style>
/* ���̾�α� ��Ÿ�� */
.dialog-overlay {
	display: none; /* �ʱ⿡�� ���� */
	position: fixed; /* ���� ��ġ */
	z-index: 1; /* �ٸ� ��� ���� ǥ�� */
	left: 0;
	top: 0;
	width: 100%; /* ��ü �ʺ� */
	height: 100%; /* ��ü ���� */
	overflow: auto; /* ��ũ�� ���� */
	background-color: rgba(0, 0, 0, 0.4); /* ������ ��� */
}

/* ���̾�α� ������ ��Ÿ�� */
.dialog-content {
	background-color: #fefefe;
	margin: 15% auto; /* ���̾�αװ� �߾ӿ� ��ġ�ϵ��� */
	padding: 20px;
	border: 1px solid #888;
	width: 80%; /* ������ �ʺ� */
}

/* ���̾�α� �ݱ� ��ư ��Ÿ�� */
.dialog-close {
	color: #aaa;
	float: right;
	font-size: 28px;
	font-weight: bold;
}

.dialog-close:hover, .dialog-close:focus {
	color: black;
	text-decoration: none;
	cursor: pointer;
}
</style>
<body>
	<!-- ��ư Ŭ�� �� ���̾�α� ���� -->
	<button onclick="openDialog()">���̾�α� ����</button>

	<!-- ���̾�α� -->
	<div id="dialogOverlay" class="dialog-overlay">
		<!-- ���̾�α� ������ -->
		<div class="dialog-content">
			<!-- ���̾�α� �ݱ� ��ư -->
			<span class="dialog-close" onclick="closeDialog()">&times;</span>
			<!-- ���̾�α� ���� -->
			<p>���̾�α� â �����Դϴ�. ���⿡ ������ ������ �߰��ϼ���.</p>
		</div>
	</div>


</body>
<script>
	// ���̾�α� ���� �Լ�
	function openDialog() {
		document.getElementById("dialogOverlay").style.display = "block";
	}

	// ���̾�α� �ݱ� �Լ�
	function closeDialog() {
		document.getElementById("dialogOverlay").style.display = "none";
	}

	// ���̾�α� �ٱ��� Ŭ���ϸ� �ݱ�
	window.onclick = function(event) {
		var dialog = document.getElementById("dialogOverlay");
		if (event.target == dialog) {
			dialog.style.display = "none";
		}
	}
	
</script>
</html>
