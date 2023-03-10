<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>restaurantEnroll</title>
    <%@ include file="../template/header.jsp" %>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="<c:url value="/resources/css/admin/restaurantEnroll.css"/>">
    <link rel="stylesheet"href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.9.1/font/bootstrap-icons.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <!-- 페이징 부트 스트랩 -->

</head>
<body>
<form action="${pageContext.request.contextPath}/admin/resInsert" method="post" enctype="multipart/form-data" name="restaurantEnroll">
    <div class="body">
        <div id="content">
            <div id="contentHead"></div>
            <div class="resDiv">
                <i class="fa-solid fa-store"></i>
                <span class="font">맛집이름 : </span>
                <input type="text" class="textInput" name="resName" required placeholder="맛집이름을 입력해주세요">
            </div>
            <div class="resDiv">
                <i class="fa-solid fa-location-dot"></i>
                <span class="font">지역 : </span>
                <select id="space2"  class="textInput" name="state">
                    <option value="" >지역을 선택해주세요</option>
                    <c:forEach items="${stateList}" var="state">
                        <option value="${state}">${state}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="resDiv">
                <i class="fa-solid fa-map-location-dot"></i>
                <span class="font">주소 : </span>
                <input type="text" id="space" class="textInput"name="address" required placeholder="주소를 입력해주세요">
            </div>
            <div class="resDiv">
                <i class="fa-solid fa-phone"></i>
                <span class="font">전화번호 : </span>
                <input type="text" class="textInput"name="resPhone" required placeholder="전화번호를 입력해주세요">
            </div>
            <div class="resDiv">
                <i class="fa-solid fa-utensils"></i>
                <span class="font">주요메뉴 : </span>
                <input type="text" class="textInput" name="resFood" required placeholder="메뉴를 입력해주세요">
            </div>
        </div>
        <div class="placeHashtag">
            <c:forEach items="${hashtagList}" var="hashtag" varStatus="i">
                <input type="checkbox" class="btn-check" id="btn-check-outlined${i.count}" name="hashtagId" autocomplete="off" value="${hashtag.hashtagId}">
                <label class="btn btn-outline-secondary" for="btn-check-outlined${i.count}">${hashtag.hashtag}</label>
            </c:forEach>
        </div>
        <br><br>
        <div class="resImg">
            <span class="font"><i class="bi bi-camera"></i></span>
            <input class="form-control form-control-sm" id="formFileSm" name="file" type="file" onchange="readURL(this);" required>
            <br><br>
            <div id="previewHead">
                <img id="preview"/>
            </div>

        </div>
        <br><br>
        <div class="btn_box">
            <button class="bbtn" type="reset" onclick="location.href='${pageContext.request.contextPath}/selectResList'">취소</button>
            <input  class="bbtn" type="submit" onclick="return gopage();" value="등록" />
        </div>
    </div>
</form>
<script>
    $('input:checkbox[name=hashtagId]').click(function(){

        let cntEPT = $('input:checkbox[name=hashtagId]:checked').length;
        if(cntEPT>2){
            Swal.fire({
                icon: 'warning',
                title: '해시태그는 최대 2개까지 선택 가능합니다.'
            });
            $(this).prop('checked', false);
        }
    });

    function readURL(input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();
            reader.onload = function(e) {
                document.getElementById('preview').src = e.target.result;
            };
            reader.readAsDataURL(input.files[0]);
        } else {
            document.getElementById('preview').src = "";
        }

        if (input.files && input.files[0].size > (10 * 1024 * 1024)) {
            Swal.fire({
                icon: 'warning',
                title: '파일 크기는 10mb 를 넘길 수 없습니다.'
            });
            input.value = null;
        }
    }


    function gopage(){
        let cntEPT = $('input:checkbox[name=hashtagId]:checked').length;
        if(cntEPT===2){
            return true;
        }else{
            Swal.fire({
                icon: 'warning',
                title: '해쉬태그를 적어도 2개 입력해야합니다.'
            });
            return false;
        }
    }

</script>
</body>
</html>