<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<% pageContext.setAttribute("LF", "\n"); %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>상품 상세</title>
<link rel="stylesheet" href="<spring:message code='root'/>/css/jquery-ui-1.10.0.custom.css">
<link rel="stylesheet" href="<spring:message code='root'/>/css/bootstrap.min.css">
<script src="<spring:message code='root'/>/js/jquery-1.11.3.min.js"></script>
<script src="<spring:message code='root'/>/js/jquery-ui-1.9.2.custom.min.js"></script>
<script src="<spring:message code='root'/>/js/bootstrap.min.js"></script>
<style type="text/css">
.comments {
	background:#eeeeee;
	font-size: 0.9em;
}
</style>
<script type="text/javascript">
$(document).ready(function(){
	var empno = "<c:out value="${sessionScope.empno}"/>";
	if(empno == null || empno.length == 0){
		top.moveLogin();
		return false;
	}
	
	$(".img-thumbnail").each(function(){
		$(this).css("cursor", "pointer");
		$(this).click(function(){
			var murl = $(this).attr("tips");
			top.showPopup(murl);
		});
	});
		
	reloadComment("PD", "${products.idx}");
});

function testencode(url){
	console.log("받은 값 :" + url);
	console.log("decodeURI : " + decodeURI(url));
	console.log("decodeURIComponent : " + decodeURIComponent(url));
	console.log("encodeURI : " + encodeURI(url));
	console.log("encodeURIComponent : " + encodeURIComponent(url));
	//top.showPopup(url);
}
</script>
</head>
<body>
	
	<div class="container">
		<div class="row">&nbsp;</div>
			<div class=" row">
				<label class="col-sm-2 control-label text-right" for="product_name">상품명</label>
				<div class="col-sm-8">
					<p id="product_name"><c:out value="${products.product_name}"/></p>
				</div>
				<div class="col-sm-2"></div>
			</div>
			<div class=" row">
				<label class="col-sm-2 control-label text-right" for="category">주제분류</label>
				<div class="col-sm-8">
						<p id="category"><c:out value="${products.category_desc}"/></p>
				</div>
				<div class="col-sm-2"></div>
			</div>
			<div class=" row">
				<label class="col-sm-2 control-label text-right" for="tags">태그</label>
				<div class="col-sm-8">
					<p id="tags">
						<c:out value="${products.tag}"/>
			        </p>
				</div>
				<div class="col-sm-2"></div>
			</div>
			<div class=" row">
				<label class="col-sm-2 control-label text-right" for="copy">Copy</label>
				<div class="col-sm-8">
					<p id="copy"><c:out value="${fn:replace(products.copy, LF, '<br>')}" escapeXml="false"/></p>
				</div>
				<div class="col-sm-2"></div>
			</div>
			<div class=" row">
				<label class="col-sm-2 control-label text-right" for="story_telling">스토리텔링</label>
				<div class="col-sm-8">
					<p id="story_telling">
						<c:out value="${fn:replace(products.story_telling, LF, '<br>')}" escapeXml="false"/>
			        </p>
				</div>
				<div class="col-sm-2"></div>
			</div>
			<div class=" row">
				<label class="col-sm-2 control-label text-right" for="selling_point">셀링포인트</label>
				<div class="col-sm-8">
					<p id="selling_point">
						<c:out value="${fn:replace(products.selling_point, LF, '<br>')}" escapeXml="false"/>
			        </p>
				</div>
				<div class="col-sm-2"></div>
			</div>
			<div id="imagefileSection">
				<c:choose>
		            <c:when test="${fn:length(imagefile) > 0}">
		                <c:forEach items="${imagefile}" var="file" varStatus="loopcnt">
		                	<c:if test="${loopcnt.index eq 0 }">
			                	<div class=" row">
			                		<label class="col-sm-2 control-label text-right" for="size">이미지</label>
			                </c:if>
		                	<c:if test="${loopcnt.index > 0 && loopcnt.index%3 eq 0}">
		                		<div class=" row">
		                			<div class="col-sm-2">&nbsp;</div>
		                	</c:if>
		                			<div class="col-sm-3 text-center"><img src="<c:out value="${file.thumbsurl}"/>" class="img-thumbnail" onError="this.onerror=null;this.src='<spring:message code='root'/>/images/wait_preview.jpg'" tips="<c:out value="${file.thumbmurl}"/>"><h6><a href="<c:out value="${file.url}"/>" target="_blank"><c:out value="${file.file_name}"/></a></h6></div>
		                			<%-- <div class="col-sm-3 text-center"><a href="javascript:testencode('<c:out value="${file.thumbmurl}"/>')"/><img src="<c:out value="${file.thumbsurl}"/>" class="img-thumbnail" onError="this.onerror=null;this.src='<spring:message code='root'/>/images/wait_preview.jpg'"></a><h6><a href="<c:out value="${file.url}"/>" target="_blank"><c:out value="${file.file_name}"/></a></h6></div> --%>
		                	<c:if test="${loopcnt.index%3 eq 2 }">
		                			<div class="col-sm-1"></div>
		                		</div>
		                	</c:if>
		                </c:forEach>
		                <c:choose>
		                	<c:when test="${fn:length(imagefile) % 3 > 0}">
			                	<c:forEach var="i" begin="${fn:length(imagefile) % 3}" end="3" step="1">
			                		<c:if test="${i eq 1 }"><div class="col-sm-3"></div></c:if>
			                		<c:if test="${i eq 2}">
			                			<div class="col-sm-3"></div>
			                			<div class="col-sm-1"></div>
			                		</div>
			                		</c:if>					                		
			                	</c:forEach>
		                	</c:when>
		                </c:choose>
		            </c:when>
		            <c:otherwise>
		            	<div class=" row">
			            	<label class="col-sm-2 control-label text-right" for="size">이미지</label>
							<div class="col-sm-10">첨부된 이미지 없음</div>
						</div>
					</c:otherwise>
		        </c:choose>
				
			</div>
			<div class=" row">&nbsp;</div>
			<div class=" row">
				<label class="col-sm-2 control-label text-right" for="usage">사용여부</label>
				<div class="col-sm-8">
					<label class="radio-inline"><input type="radio" name="usage" value="Y" <c:if test="${products.usage_flag == 'Y'}">checked</c:if> disabled>사용</label>
					<label class="radio-inline"><input type="radio" name="usage" value="N" <c:if test="${products.usage_flag == 'N'}">checked</c:if> disabled>미사용</label>
				</div>
				<div class="col-sm-2"></div>
			</div>
			<div class="row">
				<div class="col-xs-12" style="overflow: hidden;"><h1><img src="<spring:message code="root"/>/images/line.gif"></h1></div>
			</div>
			<div class=" row">&nbsp;</div>
			<div class=" row">
				<label class="col-sm-2 control-label text-right" for="tags">댓글</label>
				<div class="col-sm-10 comments">
				<jsp:include page="../common/comments.jsp" flush="true">
					<jsp:param name="category_idx" value="${products.idx}" />
					<jsp:param name="category_flag" value="PD"/>
				</jsp:include>
				</div>
			</div>
	</div>
</body>
</html>