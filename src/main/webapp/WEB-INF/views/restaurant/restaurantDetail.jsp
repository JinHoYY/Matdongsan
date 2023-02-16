<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>동네맛집상세보기</title>
    <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
    <link rel="stylesheet" href="<c:url value="/resources/css/restaurant/restaurantDetail.css"/>">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://kit.fontawesome.com/2e05403237.js" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-kenU1KFdBIe4zVF0s0G1M5b4hcpxyD9F7jL+jjXkk+Q2h455rYXK/7HAuoJl+0I4" crossorigin="anonymous"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
    <jsp:include page="../template/font.jsp"/>
</head>
<body>
<%@ include file ="../template/header.jsp" %>
<div id="content">
    <div class="detail_head">

        <%--관리자 모드--%>
        <div class="detail_head_admin">
            <c:if test="${ loginUser.grade eq 'ADMIN'}">
                <button onclick="location.href='admin/resModify?resNo=${restaurantDetail.resNo}'">수정하기</button>
                <button onclick="location.href='admin/resDelete?resNo=${restaurantDetail.resNo}'">삭제하기</button>
            </c:if>
        </div>

        <div class="head name">
            <span>${restaurantDetail.resName}</span>
        </div>
        <div class="head star">
            <i class="fa-solid fa-star"></i>
            <span id="star_rating"></span>
        </div>
        <div class="head">
            <span id="hashtag_by_admin" class="tag">
                <c:forEach items="${resHashtagByAdmin}" var="hashtag">
                    <input type="checkbox" class="btn-check" id="btn-check-outlined" autocomplete="off" disabled>
                    <label class="btn btn-outline-secondary" for="btn-check-outlined">${hashtag}</label>
                </c:forEach>
            </span>
            <span id="hashtag_by_review" class="tag">
                <c:forEach items="${resHashtagByReview}" var="hashtag">
                    <input type="checkbox" class="btn-check" id="btn-check-outlined" autocomplete="off" disabled>
                    <label class="btn btn-outline-secondary" for="btn-check-outlined">${hashtag}</label>
                </c:forEach>
            </span>
        </div>
    </div>
    <div class="detail_main">
        <div class="main img">
            <img src="${restaurantDetail.resImgUrl}">
        </div>
        <div class="main info_list">
            <div class="info menu">
                <i class="fa-solid fa-utensils"></i>
                <span class="detail">주메뉴</span>
                <span>${restaurantDetail.resFood}</span>
            </div>
            <div class="info address">
                <i class="fa-solid fa-map-location-dot"></i>
                <span class="detail">주소</span>
                <span>${restaurantDetail.address}</span>
            </div>
            <div class="info number">
                <i class="fa-solid fa-phone"></i>
                <span class="detail">전화번호</span>
                <span>${restaurantDetail.resPhone}</span>
            </div>
            <div class="info time">
                <i class="fa-regular fa-clock"></i>
                <span class="detail">영업시간</span>
                <span>${restaurantDetail.resTime}</span>
            </div>
            <div class="info way">
                <i class="fa-solid fa-train-subway"></i>
                <span class="detail">오시는 길</span>
                <span>${restaurantDetail.transport}</span>
            </div>
            <div class="info web">
                <i class="fa-solid fa-globe"></i>
                <span class="detail">홈페이지</span>
                <span><a href="${restaurantDetail.website}">${restaurantDetail.website}</a></span>
            </div>
        </div>
    </div>
    <%--    *****************************************리뷰*********************************************--%>
    <div class="detail review">
        <div class="review_btn_box">
            <span>리뷰</span><span id="rCount"></span>
            <c:if test="${not empty loginUser}">
                <button id="review_btn" data-bs-toggle="modal" data-bs-target="#exampleModal"><i class="fa-solid fa-pencil"></i>리뷰작성</button>
            </c:if>
        </div>
        <div class="review content">
            <table id="reviewArea">
                <tbody>
                </tbody>
            </table>
        </div>
    </div>
</div>
<%--리뷰모달--%>
<div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <span>가게명</span>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <span>별점</span>
                <div id="review_star">
                    <input type="radio" name="reviewStar" value="5" id="rate1"><label
                        for="rate1">★</label>
                    <input type="radio" name="reviewStar" value="4" id="rate2"><label
                        for="rate2">★</label>
                    <input type="radio" name="reviewStar" value="3" id="rate3"><label
                        for="rate3">★</label>
                    <input type="radio" name="reviewStar" value="2" id="rate4"><label
                        for="rate4">★</label>
                    <input type="radio" name="reviewStar" value="1" id="rate5"><label
                        for="rate5">★</label>
                </div>
                <div id="review_hashtag">
                    <c:forEach items="${hashtagList}" var="hashtag" varStatus="i">
                        <input type="checkbox" class="btn-check" id="btn-check-outlined${i.count}" name="chk_hashtag"
                               autocomplete="off" value="${hashtag.hashtag}">
                        <label class="btn btn-outline-secondary" for="btn-check-outlined${i.count}">${hashtag.hashtag}</label>
                    </c:forEach>
                </div>

                <div id="review_text">
                    <textarea type="text" id="reviewContent" placeholder="리뷰를 남겨주세요"></textarea>
                </div>

                <div class="review_img">
                    <input class="form-control form-control-sm" id="formFileSm" type="file" multiple>
                </div>
                <div class="modal-footer">
                    <button id="review_insert" onclick="insertReview()" data-bs-dismiss="modal">등록하기</button>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    window.onload = function () {

        document.querySelector('#review_insert').addEventListener('click', offClick);
        document.querySelector('.btn-close').addEventListener("click", offClick);

        selectReviewList();
    };

    // 리뷰 조회
    function selectReviewList() {
        $.ajax({
            url: '${pageContext.request.contextPath}/restaurant/selectReview',
            type: 'GET',
            data: {
                resNo: ${restaurantDetail.resNo}
            },
            dataType: "json",
            success: function (data) {
                console.log(data);
                let str = "";
                for (let i of data['reviewList']) {
                    console.log(i)
                    let hashtagList = '';
                    for (let hashtag of i.hashtags) {
                        hashtagList += '<label class="btn btn-outline-secondary" for="btn-check-outlined">' + hashtag + '</label>';
                    }
                    let imgList = '';
                    for (let img of i.changeNames) {
                        imgList += '<img src="' + img + '" />'
                    }

                    str += '<div>'
                        + '<div><br><hr></div>'
                        + '<div class="review_header">'
                        + '<div class="review_user_img"> <img src=\"' + i.profileImage + '\"/> </div>'
                        + '<div class="review_user_name">' + i.memberName + '</div>'
                        + '<div class="review_star_rating">' + ((i.starRating === 5 ? "★★★★★" : i.starRating === 4 ? "★★★★" : i.starRating === 3 ? "★★★" : i.starRating === 2 ? "★★" : i.starRating === 1 ? "★" : "")) + '</div>'
                        + '<div class="review_date">' + i.createDate.substring(0, 16) + '</div>'
                        + (('1' === '${loginUser.memberNo}' ? "<button onclick='deleteReview(this);'>x</button>" : ""))
                        + '<div>' + "<input type='hidden' name='revNo' value=" + i.revNo + ">" + '</div>'
                        + '</div>'
                        + '<div class="review_content">' + i.reviewContent + '</div>'
                        + '<div class="review_img_list">' + imgList + '</div>'
                        + '<div>' + hashtagList + '</div>'
                        + '</div>';
                }
                $("#reviewArea tbody").html(str);
                $("#rCount").html(data['reviewList'].length);

                let star_rating;
                if (data['reviewList'].length === 0) {
                    star_rating = '별점을 남겨주세요!'
                } else {
                    star_rating = Math.round(data['reviewList'].map(obj => obj['starRating'])
                        .reduce((accumulator, current) => accumulator + current, 0) * 10 / data['reviewList'].length) / 10
                    star_rating += ' / 5'
                }
                $('#star_rating').html(star_rating)

                let hashtagByReview = '';
                for (let hashtag of data['hashtagList']) {
                    hashtagByReview += '<input type="checkbox" class="btn-check" id="btn-check-outlined" autocomplete="off" disabled>';
                    hashtagByReview += '<label class="btn btn-outline-secondary" for="btn-check-outlined">' + hashtag + '</label>';
                }
                $('#hashtag_by_review').html(hashtagByReview);
            },
            error: function () {
                console.log("리뷰조회 ajax통신 실패");
            }
        });
    }

    // 리뷰 등록
    function insertReview() {
        const score = $('input:radio[name=reviewStar]:checked').val();
        const hashtags = [];
        $('input:checkbox[name=chk_hashtag]:checked').each(function () {
            hashtags.push(this.value);
        });
        const contents = $('#reviewContent').val()
        const files = $('#formFileSm')[0].files

        if(score === undefined) {
            swal("별점을 입력해주세요!","","warning")
            return;
        }
        if(hashtags.length === 0){
            swal("해쉬태그를 입력해주세요!","","warning")
            return;
        }
        if(contents === "") {
            swal("리뷰를 입력해주세요!","","warning")
            return;
        }
        if(files.length === 0) {
            swal("사진을 첨부해주세요!","","warning")
            return;
        }

        const formData = new FormData();
        formData.set("resNo", ${restaurantDetail.resNo});
        formData.set("score", score);
        formData.set("hashtags", hashtags.join(","));
        formData.set("contents", contents);
        for (let i = 0; i < files.length; ++i) {
            formData.append("files", files[i])
        }

        $.ajax({
            url: '${pageContext.request.contextPath}/restaurant/insertReview',
            type: 'POST',
            data: formData,
            contentType: false,
            processData: false,
            success: () => {
                selectReviewList();
                offClick();
            },
            error: function () {
                offClick();
                console.log("리뷰 등록 실패");
            }
        });
    }

    $('input:checkbox[name=chk_hashtag]').click(function () {
        let cntEPT = $('input:checkbox[name=chk_hashtag]:checked').length;
        if (cntEPT > 3) {
            swal("해시태그는 최대 3개 까지만 선택가능합니다.","","warning")
            $(this).prop('checked', false);
        }
    });


    function offClick() {

        $("#reviewContent").val("");
        $("#formFileSm").val("");
        $('input:radio[name=reviewStar]').each(function () {
            $(this).prop('checked', false);
        });
        $('input:checkbox[name=chk_hashtag]').each(function () {
            $(this).prop('checked', false);
        });
    }


    // 관리자 - 리뷰삭제
    function deleteReview(button) {
        let revNo = $(button).parent().parent().find("[name='revNo']").val();
        $.ajax({
            url: "${pageContext.request.contextPath}/restaurant/review/" + revNo,
            type: "delete",
            success: function (result) {
                swal("리뷰 삭제 성공","","success")
                selectReviewList();
            },
            error: function () {
                swal("리뷰 삭제 실패","","error")
            }
        });
    }
</script>


</body>
</html>



