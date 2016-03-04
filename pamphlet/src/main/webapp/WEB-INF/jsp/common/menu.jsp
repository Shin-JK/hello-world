<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<link rel="stylesheet" href="<spring:message code='root'/>/css/mega-common.css">
<style>
<!--
.navbar-xs { min-height:28px !important; height: 28px; font-family: "나눔고딕",NanumGothic,"맑은 고딕",dotum,verdana; font-size: 13px;}
.navbar-xs .navbar-brand { padding: 0px 12px;font-size: 16px;line-height: 28px; }
.navbar-xs .navbar-nav > li > a {  padding-top: 0px; padding-bottom: 0px; line-height: 28px; font-size: 13px;}
.dropdown-menu { font-size: 13px;}
.lblpwd, .pwdinput { display:block; }
.pwdinput { margin-bottom:12px; width:95%; padding: .4em; }
.pwdfieldset { padding:0; border:0;}
-->
</style>
<c:set var="existsub" value="N"/>
<nav class="navbar navbar-default navbar-xs ">
	<div class="collapse navbar-collapse">
		<div class="collapse navbar-collapse">
			<ul class="nav navbar-nav">				
				<c:forEach items="${sessionScope.menu}" var="menus" varStatus="loopcnt">
					<c:if test="${menus.menu_group eq menus.menu_code && loopcnt.index > 0 && existsub eq 'Y'}">
						</ul></li><c:set var="existsub" value="N"/>
					</c:if>
					<c:choose>
						<c:when test="${menus.menu_group eq menus.menu_code && menus.has_child eq 'Y'}">
							<c:set var="existsub" value="Y"/>
							<li class="dropdown">
							<a href='<spring:message code='root'/><c:out value="${menus.menu_path}"/>' class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false"><c:out value="${menus.menu_name}"/><span class="caret"></span></a>
							<ul class="dropdown-menu" role="menu">
						</c:when>
						<c:when test="${menus.menu_group eq menus.menu_code && menus.has_child eq 'N'}">
							<li><a href="<spring:message code='root'/><c:out value="${menus.menu_path}"/>"><c:out value="${menus.menu_name}"/></a></li>
						</c:when>
					</c:choose>
					<c:if test="${menus.menu_group ne menus.menu_code}">
						<li><a href='<spring:message code='root'/><c:out value="${menus.menu_path}"/>' ><c:out value="${menus.menu_name}"/></a></li>
					</c:if>
					<c:if test="${fn:length(menu) eq loopcnt.index + 1 && existsub eq 'Y'}">
							</ul>
						</li>
					</c:if>
				</c:forEach>
			</ul>
			<ul class="nav navbar-nav navbar-right">
				<c:choose>
					<c:when test="${sessionScope.name != '' || sessionScope.name ne null}">
						<li class="dropdown">
							<a href='#' class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false"><c:out value="${sessionScope.name}"/><span class="caret"></span></a>
							<ul class="dropdown-menu" role="menu">
								<li><a href="javascript:popupchagepwd()">비밀번호변경</a></li>
							</ul>
						</li>
					</c:when>
				</c:choose>
				<li><a href="<spring:message code='root'/>/common/logout.do">로그아웃</a></li>
			</ul>
		</div>
	</div>
</nav>
<div id="popuppwd"></div>
<script type="text/javascript">
function popupchagepwd(){	
	var innerHtml =  " <div id='changepwddialog' title='암호변경'>";
	innerHtml += " <form method='post' id='pwdform'>";
	innerHtml += " <fieldset class='pwdfieldset'>";
	innerHtml += "  <input type='hidden' name='user_irud' id='user_irud' value='UPDATE'>";
	innerHtml += "  <input type='hidden' name='empno' id='empno' value='<c:out value="${sessionScope.empno}"/>'>";
	innerHtml += "  <input type='hidden' name='name' id='name' value='<c:out value="${sessionScope.name}"/>'>";
	innerHtml += "  <label for='oldpassword' class='lblpwd'>현재암호</label>";
	innerHtml += "  <input type='password' name = 'oldpassword' id='oldpassword' maxlength='10' class='text ui-widget-content  ui-corner-all pwdinput'>";
	innerHtml += "  <label for='newpassword' class='lblpwd'>새 암호</label>";
	innerHtml += "  <input type='password' name = 'newpassword' id='newpassword' maxlength='10' class='text ui-widget-content  ui-corner-all pwdinput'>";
	innerHtml += "  <label for='checknewpwd' class='lblpwd'>암호확인</label>";
	innerHtml += "  <input type='password' name = 'checknewpwd' id='checknewpwd' maxlength='10' class='text ui-widget-content  ui-corner-all pwdinput'>";
	innerHtml += " </fieldset>";
	innerHtml += " </form>";
	innerHtml += " </div>";
	
	$("#popuppwd").append(innerHtml);
	$( "#changepwddialog" ).dialog({
        autoOpen: true,
        height: 330,
        width: 280,
        modal: true,
        resizable:false,
        open: function(){
        	$buttonPane1 = $(this).next();
        	$buttonPane1.find('button:first').removeAttr('class').addClass('btn').addClass('btn-primary').addClass('btn-sm');
        	$buttonPane1.find('button:last').removeAttr('class').addClass('btn').addClass('btn-primary').addClass('btn-sm');
        },
        buttons: {
          "Save": savepwd,
          Cancel: function() {
        	  $( "#changepwddialog" ).dialog( "close" );
        	  $( "#changepwddialog" ).remove();
          }
        },
        close: function() {
        	$( "#changepwddialog" ).dialog("close");
        	$( "#changepwddialog" ).remove();
        }
      });
}

function savepwd(){
	if($("#oldpassword").val().length == 0){
		  $("#oldpassword").tooltip({title:"현재 암호를 입력하세요"});
		  $("#oldpassword").focus();
		  return false;
	  }
	
	if($("#newpassword").val().length == 0){
		  $("#newpassword").tooltip({title:"새 암호를 입력하세요"});
		  $("#newpassword").focus();
		  return false;
	  }
	
	if($("#checknewpwd").val().length == 0){
		$("#checknewpwd").tooltip({title:"확인 암호를 입력하세요"});
		$("#checknewpwd").focus();
		return false;
	  }
	
	if($("#newpassword").val() != $("#checknewpwd").val()){
		$("#checknewpwd").tooltip({title:"새 암호와 확인 암호가 다릅니다"});
		$("#checknewpwd").focus();
		return false;
	  }
	  	  
	  $.ajax({
      url : "<spring:message code='root'/>/manage/usersave.do",
      type : 'post',
      data : $('#pwdform').serialize(),
      success:function(data){
          if(data.result == 'SUCCESS'){
        	  $('#changepwddialog').modal('hide');
      		$('#changepwddialog').remove();
	        alert("암호 변경을 완료했습니다");   	
          }else{
          	alert();
          	$("#oldpassword").attr("title",data.result);
  		    $("#oldpassword").tooltip();
  		    $("#oldpassword").focus();
          	return false;
          }
      },
      error:function(err){
      	//오류 메세지 뿌리고 화면 초기화
      	console.log(err);
      	alert(err);
      }
  });
}
</script>
