<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>전단 상세</title>
<link rel="stylesheet" href="<spring:message code='root'/>/css/jquery-ui-1.10.0.custom.css">
<link rel="stylesheet" href="<spring:message code='root'/>/css/bootstrap.min.css">
<link rel="stylesheet" href="<spring:message code='root'/>/css/mega-bootstrap-layout.css">
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
	
	$("#btnList").click(function(){
		$("#tmpParamForm").attr("action", "<spring:message code='root'/>/pamphlet/pamphletlist.do");
		$("#tmpParamForm").submit();
	});
	
	$("#btnEdit").click(function(){
		$("#tmpParamForm").attr("action", "<spring:message code='root'/>/pamphlet/pamphletwrite.do");
		$("#tmpParamForm").submit();
	});
	
	$("#btnCopy").click(function(){
		$("#copyflag").val("Y");
		$("#btnEdit").trigger("click");
	});
		
	$(".img-thumbnail").each(function(){
		$(this).css("cursor", "pointer");
		$(this).click(function(){
			var murl = $(this).attr("tips");
			popupImage(murl);
		});
	});
	
	reloadComment("PP", "${pamphlet.idx}");
	
});

var popupImage = function(imageurl){
	$("body").append('<div id="imagedialog"><img class="tooltip-image" src="'+imageurl+'" onError="this.onerror=null;this.src=\'/pamphlet/images/wait_preview.jpg\';"></div>');
	$("#imagedialog").dialog({
		autoOpen: true,
		height: 'auto',
		width: 'auto',
		modal: true,
		resizable: false,
		open: function(){
        	$buttonPane1 = $(this).next();
        	$buttonPane1.find('button:first').addClass('btn').addClass('btn-primary').addClass('btn-sm');
        },
		buttons: {
	          "닫기": function(){
	        	  $("#imagedialog").dialog("close");
		          $("#imagedialog").remove();
	          }
	        },
	        close: function() {
	        	$("#imagedialog").dialog("close");
		        $("#imagedialog").remove();
	        }
	});
}
</script>
</head>
<body>
	<form id="tmpParamForm" method="post">
		<input type="hidden" name="key" value="${key}">
		<input type="hidden" name="keyword" value="${keyword}">
		<input type="hidden" name="selectedpage" value="${page.pageNo}">
		<input type="hidden" name="pagesize" value="${page.pageSize}">
		<input type="hidden" name="totalcount" value="${page.totalCount}">
		<input type="hidden" name="idx" id="idx" value="${pamphlet.idx}">
		<input type="hidden" name="copyflag" id="copyflag" value="N">
	</form>
	<div class="container">
		<%-- <div class="row">
			<div class="col-xs-10">
				<c:set var="menu" value="${menu}" scope="request" />
				<jsp:include page="../common/menu.jsp" flush="true"></jsp:include>
			</div>
			<div class="col-xs-2"></div>
		</div> --%>
		<div class="row">
			<div class="col-xs-2"></div>
			<h3 class="col-xs-2">전단상세</h3>
			<div class="col-xs-8"></div>
		</div>
		<div class="row">
			<div class="col-xs-10 text-right">
				<button id="btnList" type="button" class="btn btn-sm btn-primary" >목록</button>&nbsp;<button id="btnEdit" type="button" class="btn btn-sm btn-primary" >수정</button>&nbsp;<button id="btnCopy" type="button" class="btn btn-sm btn-primary" >복사</button>
			</div>
			<div class="col-xs-2"></div>
		</div>
		<div class="row">
			<div class="col-xs-1"></div>
			<div class="col-xs-10" style="overflow: hidden;"><h1><img src="<spring:message code="root"/>/images/line.gif"></h1></div>
			<div class="col-xs-1"></div>			
		</div>
		<div class=" row">
			<label class="col-xs-2 control-label text-right" for="title">전단 타이틀</label>
			<div class="col-xs-8">
				<p id="title"><c:out value="${pamphlet.title}"/></p>
			</div>
			<div class="col-xs-2"></div>
		</div>
		<div class=" row">
			<label class="col-xs-2 control-label text-right" for="reg_date">전단 일자</label>
			<div class="col-xs-8">
				<p id="reg_date"><c:out value="${pamphlet.reg_date}"/></p>
			</div>
			<div class="col-xs-2"></div>
		</div>
		<div class=" row">
			<label class="col-xs-2 control-label text-right" for="store">점포</label>
			<div class="col-xs-8">
				<p id="store"><c:out value="${pamphlet.store_name}"/></p>
			</div>
			<div class="col-xs-2"></div>
		</div>
		<div class=" row">
			<label class="col-xs-2 control-label text-right" for="tags">태그</label>
			<div class="col-xs-8">
				<p id="tags">
					<c:out value="${pamphlet.tag}"/>
		        </p>
			</div>
			<div class="col-xs-2"></div>
		</div>
		<div class=" row">
			<label class="col-xs-2 control-label text-right" for="page_size">전단크기</label>
			<div class="col-xs-2 text-left">
				<p id="page_size"><c:out value="${pamphlet.page_size}"/>절&nbsp;<c:out value="${pamphlet.page_count}"/>P</p>
			</div>
			<div class="col-xs-8"></div>
		</div>
		<div id="imagefileSection">
			<c:choose>
		           <c:when test="${fn:length(imagefile) > 0}">
		               <c:forEach items="${imagefile}" var="file" varStatus="loopcnt">
		               	<c:if test="${loopcnt.index eq 0 }">
		                	<div class=" row">
		                		<label class="col-xs-2 control-label text-right" for="size">이미지</label>
		                </c:if>
		               	<c:if test="${loopcnt.index > 0 && loopcnt.index%3 eq 0}">
		               		<div class=" row">
		               			<div class="col-xs-2">&nbsp;</div>
		               	</c:if>
		               			<div class="col-xs-3 text-center"><img src="<c:out value="${file.thumbsurl}"/>" class="img-thumbnail"  onError="this.onerror=null;this.src='<spring:message code='root'/>/images/wait_preview.jpg'" tips="<c:out value="${file.thumbmurl}"/>"><h6><a href="<c:out value="${file.url}"/>" target="_blank"><c:out value="${loopcnt.count}"></c:out>면이미지</a></h6></div>
		               			<%-- <div class="col-xs-3 text-center"><a href="javascript:popupImage('<c:out value="${file.thumbmurl}"/>')"><img src="<c:out value="${file.thumbsurl}"/>" class="img-thumbnail"  onError="this.onerror=null;this.src='<spring:message code='root'/>/images/wait_preview.jpg'"></a><h6><a href="<c:out value="${file.url}"/>" target="_blank"><c:out value="${loopcnt.count}"></c:out>면이미지</a></h6></div> --%>
		               	<c:if test="${loopcnt.index%3 eq 2 }">
		               			<div class="col-xs-1"></div>
		               		</div>
		               	</c:if>
		               </c:forEach>
		               <c:choose>
		               	<c:when test="${fn:length(imagefile) % 3 > 0}">
		                	<c:forEach var="i" begin="${fn:length(imagefile) % 3}" end="3" step="1">
		                		<c:if test="${i eq 1 }"><div class="col-xs-3"></div></c:if>
		                		<c:if test="${i eq 2}">
		                			<div class="col-xs-3"></div>
		                			<div class="col-xs-1"></div>
		                		</div>
		                		</c:if>	
		                	</c:forEach>
		               	</c:when>
		               </c:choose>
		           </c:when>
		           <c:otherwise>
		           	<div class=" row">
		            	<label class="col-xs-2 control-label text-right" for="size">이미지</label>
						<div class="col-xs-10">첨부된 이미지 없음</div>
					</div>
				</c:otherwise>
		       </c:choose>				
		</div>
		<div class=" row">&nbsp;</div>
		<div id="pdffileSection">
			<div class=" row">
				<label class="col-xs-2 control-label text-right" for="size">PDF</label>
				<div class="col-xs-8">
					<c:choose>
			            <c:when test="${fn:length(pdffile) > 0}">
			                <c:forEach items="${pdffile}" var="file" varStatus="loopcnt"><p><a href="<c:out value="${file.url}"/>" target="_blank"><c:out value="${file.file_name}"/></a></p></c:forEach>
			            </c:when>
			            <c:otherwise>첨부된 Pdf 문서 없음</c:otherwise>
			        </c:choose>
				</div>
				<div class="col-xs-2"></div>
			</div>
		</div>
		<div class=" row">
			<label class="col-xs-2 control-label text-right" for="usage">사용여부</label>
			<div class="col-xs-8">
				<label class="radio-inline"><input type="radio" name="usage" value="Y" <c:if test="${pamphlet.usage_flag == 'Y'}">checked</c:if> disabled>사용</label>
				<label class="radio-inline"><input type="radio" name="usage" value="N" <c:if test="${pamphlet.usage_flag == 'N'}">checked</c:if> disabled>미사용</label>
			</div>
			<div class="col-xs-2"></div>
		</div>
		<div class="row">
			<div class="col-xs-1"></div>
			<div class="col-xs-10" style="overflow: hidden;"><h1><img src="<spring:message code="root"/>/images/line.gif"></h1></div>
			<div class="col-xs-1"></div>			
		</div>
		<div class=" row">&nbsp;</div>
		<div class=" row">
			<label class="col-xs-2 control-label text-right" for="tags">댓글</label>
			<div class="col-xs-8 comments">
			<!-- 여기에 댓글을 입력해야 하는데...... 어케하나...... -->
			<jsp:include page="../common/comments.jsp" flush="true">
				<jsp:param name="category_idx" value="${pamphlet.idx}" />
				<jsp:param name="category_flag" value="PP"/>
			</jsp:include>
			</div>
			<div class="col-xs-2"></div>
		</div>
		<div class="row">&nbsp;</div>
	</div>
</body>
</html>