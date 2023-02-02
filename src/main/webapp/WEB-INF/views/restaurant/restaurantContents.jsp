<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<link rel="stylesheet" href="<c:url value="/resources/css/restaurant/restaurantList.css"/>">
<jsp:include page="../template/font.jsp"></jsp:include>

<div id="restaurant_list_ajax">
    <div class="place_list">
        <div class="place info">

            <c:set var="i" value="0"/>
            <c:set var="j" value="3"/>

            <table>
                <c:choose>
                    <c:when test="${selectResList != null && fn:length(selectResList) > 0 }">
                        <c:forEach items="${selectResList}" var="selectResList">
                            <c:if test="{i%j == 0}">
                                <tr>
                            </c:if>

                            <td align="center" onclick="location.href='restaurantDetail?resNo=${selectResList.resNo}'" style="cursor:pointer;">
                                <img src="<c:out value="${selectResList.resImgUrl}" />" width="300px" height="250px">
                                <c:out value="${selectResList.state}"/><br>
                                <c:out value="${selectResList.resName}"/> <br>
                            </td>
                            <c:if test="${i%j == j-1}">
                                </tr>
                            </c:if>
                            <c:set var="i" value="${i+1}"/>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td>맛집이 존재하지 않습니다.</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </table>
            <div id="paging">
                <ul class="pagination">
                    <c:choose>
                        <c:when test="${ pi.currentPage eq 1 }">
                            <li class="page-item disabled">Previous</li>
                        </c:when>
                        <c:otherwise>
                            <li class="page-item" onclick="retrieveRestaurants(${pi.currentPage - 1})">Previous</li>
                        </c:otherwise>
                    </c:choose>

                    <c:forEach var="item" begin="${pi.startPage }" end="${pi.endPage }">
                        <li class="page-item" onclick="retrieveRestaurants(${item})">${item }</li>
                    </c:forEach>

                    <c:choose>
                        <c:when test="${ pi.currentPage eq pi.maxPage }">
                            <li class="page-item disabled"><a class="page-link" href="#">Next</a></li>
                        </c:when>
                        <c:otherwise>
                            <li class="page-item" onclick="retrieveRestaurants(${pi.currentPage + 1})">Next</li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </div>


</div>

<script>
    function retrieveRestaurants(current_page) {
        const checkHashtag = [];
        $('input:checkbox[name=chk_hashtag]:checked').each(function() {
            checkHashtag.push(this.value);
        });

        $.ajax({
            url: '${pageContext.request.contextPath}/restaurants',
            method: 'GET',
            data: {
                cpage: current_page,
                state: $('#select_state option:checked').val(),
                hashtag: checkHashtag.join(',')
            },
            success(data) {
                const html = jQuery('<div>').html(data);
                const contents = html.find('div#restaurant_list_ajax').html()
                $('.place_body').html(contents)
            }
        })
    }
</script>