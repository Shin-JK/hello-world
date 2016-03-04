<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>전단리스트</title>
<link rel="stylesheet" href="<spring:message code='root'/>/css/jquery-ui-1.10.0.custom.css">
<link rel="stylesheet" href="<spring:message code='root'/>/css/bootstrap.min.css">
<link rel="stylesheet" href="<spring:message code='root'/>/css/bootstrap-table.min.css">
<link rel="stylesheet" href="<spring:message code='root'/>/css/mega-bootstrap-layout.css">
<script src="<spring:message code='root'/>/js/jquery-1.11.3.min.js"></script>
<script src="<spring:message code='root'/>/js/jquery-ui-1.9.2.custom.min.js"></script>
<script src="<spring:message code='root'/>/js/bootstrap.min.js"></script>
<script src="<spring:message code='root'/>/js/bootstrap-table.min.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	
	$("#btnWrite").click(function(){
		window.location="<spring:message code='root'/>/pamphlet/pamphletwrite.do";
	});
	
	$("#btnSearch").click(function(){
		$("#searchForm").attr("action", "<spring:message code='root'/>/pamphlet/pamphletlist.do");
		$("#searchForm").submit();
	});
	
	$("#pagesize").change(function(){
		$("#btnSearch").trigger("click");
	});
	
	$("#key").change(function(){
		if($("#key option:selected").val() =="reg_date"){
			$("#keyword").datepicker();
			$("#keyword").parent().css("z-index", 1000);
			$("#keyword").datepicker("option", "dateFormat", "yy-mm-dd");
		}else{
			$("#keyword").datepicker("destroy");
		}
	});
	
	if("<c:out value="${key}"/>" == "reg_date"){
		$("#keyword").datepicker();
		$("#keyword").parent().css("z-index", 1000);
		$("#keyword").datepicker("option", "dateFormat", "yy-mm-dd");
		$("#keyword").datepicker("setDate", "${keyword}");
	}
		 
	$("#listtable").bootstrapTable({
	    onClickRow: function (row) {
	    	$("#idx").val(row[0]);
	    	$("#searchForm").attr("action", "<spring:message code='root'/>/pamphlet/pamphletview.do");
			$("#searchForm").submit();
	    }
	});
});

function goPage(pageno){
	$("#selectedpage").attr("value", pageno);
	$("#btnSearch").trigger("click");
}
</script>
</head>
<body>
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
			<h3 class="col-xs-2">전단 리스트</h3>
			<div class="col-xs-9"></div>
		</div>
		<form class="form-horizontal form-inline" method="post" id="searchForm">
		<input id="selectedpage" name="selectedpage" type="hidden" value="${page.pageNo}">
		<input id="totalcount" name="totalcount" type="hidden" value="${page.totalCount}">
		<input id="idx" name="idx" type="hidden">
		<div class="row">
			<div class="col-xs-2"></div>			
			<label class="col-xs-1" for="pagesize">출력개수</label>
			<div class="col-xs-2 form-group text-left" >
				<select class="form-control input-sm" id="pagesize" name="pagesize">
					<option value="10" <c:if test="${page.pageSize == 10}"> selected</c:if>>10</option>
					<option value="15" <c:if test="${page.pageSize == 15}"> selected</c:if>>15</option>
					<option value="20" <c:if test="${page.pageSize == 20}"> selected</c:if>>20</option>
					<option value="30" <c:if test="${page.pageSize == 30}"> selected</c:if>>30</option>
				</select>
			</div>
			<div class="col-xs-2 text-right">
				<select class="form-control input-sm" id="key" name="key">
					<option value="all" <c:if test="${key == 'all'}'"> selected</c:if>>전체</option>
					<option value="title" <c:if test="${key == 'title'}"> selected</c:if>>타이틀</option>
					<option value="reg_date" <c:if test="${key == 'reg_date'}"> selected</c:if>>전단일자</option>
					<option value="store" <c:if test="${key == 'store'}"> selected</c:if>>점포</option>
					<option value="tag" <c:if test="${key == 'tag'}"> selected</c:if>>태그</option>
				</select>
			</div>
			<div class="col-xs-2">
				<div class="input-group" id="keyworddiv">
				   <input class="form-control input-sm" id="keyword" name="keyword" type="text" value="${keyword}">
				   <span class="input-group-btn"><button id="btnSearch" type="button" class="btn btn-sm btn-primary ">조회</button></span>
				</div>
			</div>
			<div class="col-xs-1 text-right"><button id="btnWrite" type="button" class="btn btn-sm btn-primary" >신규</button></div>
			<div class="col-xs-2"></div>
		</div>
		</form>
		<div class="row">&nbsp;</div>
		<div class="row">
			<div class="col-xs-1"></div>
			<div class="col-xs-10">
				<table id="listtable" class="table table-bordered table-striped table-hover">
					<thead>
						<tr>
							<th class="col-xs-1 text-center">등록번호</th>
							<th class="col-xs-5 text-center">전단 타이틀</th>
							<th class="col-xs-2 text-center">점포</th>
							<th class="col-xs-2 text-center">전단 일자</th>
						</tr>
					</thead>
					<c:choose>
			            <c:when test="${fn:length(list) > 0}">
			                <c:forEach items="${list}" var="rows" varStatus="loopcnt">
			                    <tr>
			                        <td class="text-center tablerow">${rows.idx}</td>
			                        <td class="text-left tablerow"><c:choose><c:when test="${fn:length(rows.title) > 25}"><c:out value="${fn:substring(rows.title,0,20)}"/>...</c:when>
           								  <c:otherwise><c:out value="${rows.title}"/></c:otherwise></c:choose>
           							</td>
			                        <td class="text-center tablerow">${rows.store_name}</td>
			                        <td class="text-center tablerow">${rows.reg_date}</td>
			                    </tr>
			                </c:forEach>
			            </c:when>
			            <c:otherwise>
			                <tr>
			                    <td></td>
			                    <td>조회된 결과가 없습니다.</td>
			                    <td></td>
			                    <td></td>
			                </tr>
			            </c:otherwise>
			        </c:choose>
				</table>			
			</div>
			<div class="col-xs-1"></div>
		</div>
		<div class="row">
			<div class="col-xs-1"></div>
			<div class="col-xs-10 text-center">
				 <jsp:include page="../common/paging.jsp" flush="true">
				    <jsp:param name="firstPageNo" value="${page.firstPageNo}" />
				    <jsp:param name="prevPageNo" value="${page.prevPageNo}" />
				    <jsp:param name="startPageNo" value="${page.startPageNo}" />
				    <jsp:param name="pageNo" value="${page.pageNo}" />
				    <jsp:param name="endPageNo" value="${page.endPageNo}" />
				    <jsp:param name="nextPageNo" value="${page.nextPageNo}" />
				    <jsp:param name="finalPageNo" value="${page.finalPageNo}" />
				</jsp:include>
			</div>
			<div class="col-xs-1"></div>
		</div>
	</div>
</body>
</html>