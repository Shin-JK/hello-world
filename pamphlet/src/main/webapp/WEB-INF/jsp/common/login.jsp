<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>로그인</title>
<link rel="stylesheet" href="<spring:message code='root'/>/css/bootstrap.min.css">
<script src="<spring:message code='root'/>/js/jquery-1.11.3.min.js"></script>
<script src="<spring:message code='root'/>/js/bootstrap.min.js"></script>
<script type="text/javascript">
$(document).ready(function(){	

	$("#empno").keydown(function(key){
		if(key.keyCode == 13){
			$("#pwd").focus();
		}	
	});
	
	$("#pwd").keydown(function(key){
		if(key.keyCode == 13){
			$("#btnlogin").click();
		}	
	});
	
	$("#btnlogin").click(function(){
		if($("#empno").val().length == 0){
			$("#empno").attr("title","사번을 입력하세요");
			$("#empno").tooltip();
			$("#empno").focus();			  
			return false;
		}		
		if($("#pwd").val().length == 0){
			$("#pwd").attr("title","패스워드를 입력하세요");
			$("#pwd").tooltip();
			$("#pwd").focus();			  
			return false;
		}
		
		$.ajax({
	        url : "<spring:message code='root'/>/common/loginprocess.do",
	        type : 'post',
	        data : $('#loginform').serialize(),
	        success:function(data){
	            if (data.result_msg =="SUCCESS"){
	            	window.location = "<spring:message code='root'/>/common/searchlist.do";
	            }else{
	            	$("#"+data.errElem).removeAttr("data-original-title");
	            	$("#"+data.errElem).removeAttr("title");
	            	$("#"+data.errElem).attr("data-original-title", data.result_msg);
	            	$("#"+data.errElem).tooltip();
	            	$("#"+data.errElem).focus();
	            	$("#"+data.errElem).removeAttr("data-original-title");
	            	$("#"+data.errElem).removeAttr("title");
	            }
	        },
	        error:function(err){
	        	//오류 메세지 뿌리고 화면 초기화
	        	console.log(err);
	        	alert(err);
	        }
	    });
		
	});
});
</script>
</head>
<body>
<div class="container">
	<form class="form-horizontal" role="form" data-toggle="validator"  method="post" id="loginform">
		<div class="row" style="height: 12em;"></div>
	    <div class="row form-group">
				<div class="col-md-4"></div>
				<label class="col-md-1 control-label" for="empno">사번</label>
				<div class="col-md-3"><input type="text" class="form-control" name="empno" id="empno" placeholder="사번" ></div>
				<div class="col-md-4"></div>
		</div>
		<div class="row form-group">
				<div class="col-md-4"></div>
				<label class="col-md-1 control-label" for="pwd">패스워드</label>
				<div class="col-md-3"><input type="password" class="form-control" name="pwd" id="pwd" placeholder="패스워드" ></div>
				<div class="col-md-4"></div>
		</div>
		<div class="row form-group">
				<div class="col-md-5"></div>
				<div class="col-md-3"><button id="btnlogin" type="button" class="form-control btn btn-primary" >로그인</button></div>
				<div class="col-md-4"></div>
		</div>
	</form>
</div>

</body>
</html>