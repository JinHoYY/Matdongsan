<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="C" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%@ page language="java" pageEncoding="UTF-8" %>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
    <link rel="stylesheet" href="<c:url value="/resources/css/admin/userList.css"/>">
    <title>Document</title>

</head>
<body>

<%@ include file="../template/header.jsp" %>
<div id="headeer"></div>
<div id="button2">
    <button type="button" class="b1" id="userList" style="color: #585c9c; background: #eaeaed; border: #eaeaed;">회원관리</button>
    <button type="button" class="b2" id="reportList" style="color: white; background: #585c9c; border: white">신고관리</button>
    <button type="button" class="b3" id="moveBrokerList" style="color: #585c9c; background: #eaeaed; border: #eaeaed;">부동산관리</button>
</div>
<br><br><br><br>
<div class="reportTable">
    <table id="tableDiv">
        <thead>
        <tr>
            <th>신고게시판</th>
            <th>신고번호</th>
            <th>피신고회원</th>
            <th>신고회원</th>
            <th>신고 사유</th>
            <th>상세보기</th>
            <th>게시글 상태</th>
            <th>활동 정지</th>
        </tr>
        </thead>
        <tbody id="tableList">
        <c:forEach var="rl" items="${reportList}">
            <tr id="reportData">
                <td>${rl.reportType}</td>
                <td>${rl.reportNo}</td>
                <td>${rl.nickName}</td>
                <td>${rl.nickName2}</td>
                <td>${rl.reportContent}</td>
                <td>
                    <button type="button" class="btn22" onclick="movePage(${rl.FNo},'${rl.reportType}')">상세보기</button>
                </td>
                <c:choose>
                    <c:when test="${rl.QStatus  == 'Y' || rl.FStatus == 'Y'}">
                        <td>
                            <button type="button" class="add-btn" id="btnOn" data-no="${rl.FNo}"
                                    data-type='${rl.reportType}'>처리중
                            </button>
                        </td>
                    </c:when>
                    <c:otherwise>
                        <td>
                            <button type="button" id="btnClose">처리완료</button>
                        </td>
                    </c:otherwise>
                </c:choose>
                <td>
                    <c:set var="now" value="<%=new java.util.Date()%>" />
                    <c:choose>
                        <c:when test="${rl.banPeriod == null || rl.banPeriod.before(now)}">
                            <select id="reportPeriod" name="reportPeriod">
                                <option value="0">정지기간선택</option>
                                <option value="3">3일정지</option>
                                <option value="7">7일정지</option>
                                <option value="-1">영구정지</option>
                            </select>
                            <button onclick="ban(${rl.reporter})">정지</button>
                        </c:when>
                        <c:otherwise>
                            <fmt:formatDate value="${rl.banPeriod}" type="both"
                                            pattern="yyyy년 MM월dd일 HH:mm"/> 까지 정지중
                        </c:otherwise>
                    </c:choose>
                    <div class="banResultArea">

                    </div>
                    <script>
                        function ban(memberNo) {
                            const banPeriod = $('select[name=reportPeriod]').val()
                            if (banPeriod === '0') {
                                return;
                            }
                            $.ajax({
                                url: '${pageContext.request.contextPath}/admin/report/ban',
                                type: 'POST',
                                contentType: "application/json; charset=UTF-8",
                                data: JSON.stringify({
                                    'memberNo': memberNo,
                                    'banPeriod': banPeriod
                                }),
                                success() {
                                    location.reload();
                                }
                            });
                            console.log(banPeriod)
                        }
                    </script>
                </td>

            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>

<%--게시글 삭제 모달--%>
<div class="modal" id="modal">
    <div class="modal_body">
        <div class="m_head">
            <div class="modal_title">게시글을 삭제처리하시겠습니까?</div>
            <div class="close_btn" id="close_btn">X</div>
        </div>
        <div class="m_body">
            <input type="hidden" id="rType" value=""/>
            <input type="hidden" id="fNo" value=""/>
            <button type="button" id="clear" class="btn" onclick="movePage2()">예</button>
            <button type="button" class="btn close_btn" id="close_btn2">아니요</button>
        </div>
    </div>
</div>

<div class="paging">
    <ul class="pagination">
        <c:choose>
            <c:when test="${ pi.currentPage eq 1 }">
                <li class="page-item disabled"><</li>
            </c:when>
            <c:otherwise>
                <li class="page-item" onclick="ReportList(${pi.currentPage - 1})"><</li>
            </c:otherwise>
        </c:choose>

        <c:forEach var="item" begin="${pi.startPage }" end="${pi.endPage }">
            <li class="page-item" onclick="ReportList(${item})">${item }</li>
        </c:forEach>


        <c:choose>
            <c:when test="${ pi.currentPage eq pi.maxPage }">
                <li class="page-item disabled"><a class="page-link" href="#">></a></li>
            </c:when>
            <c:otherwise>
                <li class="page-item" onclick="ReportList(${pi.currentPage + 1})">></li>

            </c:otherwise>
        </c:choose>
    </ul>

</div>


<script>


    $("#userList").click(function () {
        location.href = "${pageContext.request.contextPath}/admin/userList";
    });

    $('#moveBrokerList').click(function () {
        location.href = "${pageContext.request.contextPath}/admin/brokerList";
    })

    function ReportList(current_page) {
        $.ajax({
            url: '${pageContext.request.contextPath}/admin/reportList',
            method: 'GET',
            data: {
                cpage: current_page,
            },
            dataType: 'html',
            success: function (data) {
                $('#tableDiv').empty();

                if ($(data).find("#reportData").length > 0) {
                    $('.reportTable').html($(data).find("#tableDiv"))
                } else {
                    $('.reportTable').html('<p>조회된 회원이 없습니다.</p>');
                }


            }
        })
    }




    function changeSelect() {
        const stop = document.getElementById("stop");
        const value = (stop.options[stop.selectedIndex].value);
        alert(value + " 처리하시겠습니까?");
    }


    /* 모달*/
    $(document).on('click', '.add-btn', function (e) {
        console.log("click event");
        let fNo = $(this).data('no');
        let type = $(this).data('type');
        $("#rType").val(type);
        $("#fNo").val(fNo);
        $('#modal').addClass('show');

    });


    // 모달 닫기
    $(document).on('click', '#close_btn', function (e) {
        console.log("click event");
        $('#modal').removeClass('show');

    });


    function movePage(fNo, reportType) {
        if (reportType === '질문게시판') {
            location.href = '${pageContext.request.contextPath}/board/detail/' + fNo;
        } else {
            location.href = '${pageContext.request.contextPath}/board/freeList/detail/' + fNo;
        }
    }

    function movePage2() {
        let fNo = $("#fNo").val();
        let rType = $("#rType").val();
        if (rType === '질문게시판') {
            location.href = '${pageContext.request.contextPath}/admin/deleteQna/' + fNo;
            swal('삭제 완료!', rType+"이 삭제되었습니다.", 'success')

        } else {
            location.href = '${pageContext.request.contextPath}/admin/deleteFree/' + fNo;
            alert("자유게시판 삭제처리 완료")
        }
    }


</script>
</body>
</html>




