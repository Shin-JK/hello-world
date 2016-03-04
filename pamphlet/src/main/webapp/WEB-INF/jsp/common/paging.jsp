<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<ul class="pagination pagination-md">
	<li><a href="javascript:goPage(${param.firstPageNo})">&lt;&lt;</a></li>
	<li><a href="javascript:goPage(${param.prevPageNo})">&lt;</a></li>
	<c:forEach var="i" begin="${param.startPageNo}"	end="${param.endPageNo}" step="1">
		<c:choose>
			<c:when test="${i eq param.pageNo}"> <li class="active"><a href="#">${i}</a></li></c:when>
			<c:otherwise><li><a href="javascript:goPage(${i})">${i}</a></li></c:otherwise>
		</c:choose>
	</c:forEach>
	<li><a href="javascript:goPage(${param.nextPageNo})">&gt;</a></li>
	<li><a href="javascript:goPage(${param.finalPageNo})">&gt;&gt;</a></li>
</ul>