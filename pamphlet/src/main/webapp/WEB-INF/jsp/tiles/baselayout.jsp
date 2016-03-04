<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge"/> 
<meta name="viewport" content="width=device-width, initial-scale=1">
<title><tiles:getAsString name="title"/></title>
</head>
<body>
	<div id="wrap">
		<div id="mnuarea">
			<tiles:insertAttribute name="menu"/>
		</div>
		<div id="contentsarea">
			<tiles:insertAttribute name="contents"/>
		</div>
		<p>&nbsp;</p>
		<%-- 
		<div id="footarea">
			<tiles:insertAttribute name="footer"/>
		</div>
		 --%>
	</div>
</html>