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
<title>상품등록</title>
<link rel="stylesheet" href="<spring:message code='root'/>/css/bootstrap.min.css">
<link rel="stylesheet" href="<spring:message code='root'/>/css/bootstrap-dialog.min.css">
<link rel="stylesheet" href="<spring:message code='root'/>/css/jquery-ui-1.10.0.custom.css">
<link rel="stylesheet" type="text/css" href="<spring:message code='root'/>/css/fileinput.min.css" media="all" />
<link rel="stylesheet" href="<spring:message code='root'/>/css/mega-bootstrap-layout.css">
<script src="<spring:message code='root'/>/js/jquery-1.11.3.min.js"></script>
<script src="<spring:message code='root'/>/js/fileinput.min.js"></script>
<script src="<spring:message code='root'/>/js/jquery-ui-1.9.2.custom.min.js"></script>
<script src="<spring:message code='root'/>/js/bootstrap.min.js"></script>
<script src="<spring:message code='root'/>/js/bootstrap-dialog.min.js"></script>
<script src="<spring:message code='root'/>/js/aws-sdk-2.1.27.min.js"></script>
<script src="<spring:message code='root'/>/js/mega-common.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	//서버에서 받아온 첨부파일 정보를 함께 할당.
	var imageList = new Array();
	var fileexist = false;
	<c:forEach items="${imagefile}" var="images">
		fileexist = true;
		var tmpMap = new megaMap();
		tmpMap.put("seq", "${images.seq}");
		tmpMap.put("file_name", "${images.file_name}");
		tmpMap.put("url", "${images.url}");
		tmpMap.put("file_size", "${images.file_size}");
		tmpMap.put("s3_file_name", "${images.s3_file_name}");
		imageList.push(tmpMap);
	</c:forEach>
	
	if (fileexist){
		pamvariables.g_currentSizeCnt = mega.changeFileCntProductsForAttachFile($("#fileSection"), pamvariables.g_currentSizeCnt,  ${size}, imageList); //초기 설정.
	} else {
		pamvariables.g_currentSizeCnt = mega.changeFileCntProducts($("#fileSection"), pamvariables.g_currentSizeCnt,  ${size}); //초기 설정.
	}
	$("#filecnt").empty();
	$("#filecnt").append(pamvariables.g_currentSizeCnt);
	
	//태그 Setup '공백을 쉼표로 치환
	$("#tags").keydown(function(key){
		if(key.keyCode == 32){
			var tmpTxt = $("#tags").val().replace(/\s,|\s|,\s/gi, ',').trim();
			$("#tags").val(tmpTxt);			
		}
	}).focusout(function(){
		var tmpTxt = $("#tags").val().replace(/\s,|\s|,\s/gi, ',').trim();
		$("#tags").val(tmpTxt);
	});
		
	//이미지 추가버튼
	$("#addfile").click(function(){
		if(pamvariables.g_currentSizeCnt < 10){
			pamvariables.g_currentSizeCnt = mega.changeFileCntProducts($("#fileSection"), pamvariables.g_currentSizeCnt, pamvariables.g_currentSizeCnt + 1);
		}else{
			alert("첨부 파일은 최대 10개까지 입니다");
		}
		$("#size").val(pamvariables.g_currentSizeCnt);
		$("#filecnt").empty();
		$("#filecnt").append(pamvariables.g_currentSizeCnt);
	});
	
	//이미지 제거버튼
	$("#delfile").click(function(){
		if(pamvariables.g_currentSizeCnt >0){
			pamvariables.g_currentSizeCnt = mega.changeFileCntProducts($("#fileSection"), pamvariables.g_currentSizeCnt, pamvariables.g_currentSizeCnt - 1);
		}else{
			alert("제거할 첨부파일이 없습니다");
		}
		$("#size").val(pamvariables.g_currentSizeCnt);
		$("#filecnt").empty();
		$("#filecnt").append(pamvariables.g_currentSizeCnt);
	});
	
	//복제버튼
	$("#btnCopy").click(function(){
		$("#irud").val("NEW");
		$("#idx").val("0");
		$("#product_name").val("");
		$(this).hide();
	});
	
	//취소버튼
	$("#btnCancel").click(function(){
		window.location = "<spring:message code='root'/>/products/productslist.do";
	});
	
	//저장버튼
	$("#btnSave").click(function(){
		if(!checkRequiredFields()){
			return false;
		}
		
		pamvariables.imgMap = new megaMap();
		pamvariables.tmpImgCnt = 0;
		
		for(var i=1; i <= pamvariables.g_currentSizeCnt; i++){
			if ($("#p"+i+"_image").val() != ""){
				pamvariables.tmpImgCnt += 1;
				var tmpAttachFile1 = new attachFile();
				tmpAttachFile1.setSeqno(i);
				tmpAttachFile1.setFile($("#p"+i+"_image")[0].files[0], "PD");
				pamvariables.imgMap.put(pamvariables.tmpImgCnt, tmpAttachFile1);				
			}
		}
		//모달 다이얼로그 출력
		mega.saveShowDialog(pamvariables.tmpImgCnt);
		
		if (pamvariables.tmpImgCnt > 0){
			var s3 = new AWS.S3();
			
			
			//이미지 파일 S3 저장
			for(var j=1; j<=pamvariables.tmpImgCnt; j++){
				var params2 = {
						Bucket : awssetup.s3bucket,
						Key : pamvariables.imgMap.get(j).getBucketfolder() + "/" + pamvariables.imgMap.get(j).getFilenewname(), //newFileName, 
						ACL : awssetup.s3ACL,
						Body : pamvariables.imgMap.get(j).getFile(),
						ContentType : pamvariables.imgMap.get(j).getFiletype()
					};
				
				s3.putObject(params2, function(err, data) {
					if (err) {
						pamvariables.tmpErrCnt += 1;
						if (pamvariables.tmpImgCnt == pamvariables.tmpErrCnt + pamvariables.tmpSucCnt){
							rollbackAttachedFile();
							mega.saveHideDialog();
							mega.showWarnMsg( "File Upload 실패" ,"첨부파일 업로드시 오류가 발생하였습니다.");
							
							return false;
						}
					} else {
						pamvariables.tmpSucCnt += 1;
						mega.saveRefreshDialog(pamvariables.tmpSucCnt);
						if (pamvariables.tmpImgCnt == pamvariables.tmpErrCnt + pamvariables.tmpSucCnt && pamvariables.tmpErrCnt > 0){
							rollbackAttachedFile();
							mega.saveHideDialog();
							mega.showWarnMsg( "File Upload 실패" ,"첨부파일 업로드시 오류가 발생하였습니다.");
							return false;
						}
						
						if (pamvariables.tmpImgCnt == pamvariables.tmpSucCnt){
							saveData();
						}
					}
				});
			}
		}else{
		//첨부파일이 없을 경우에도 그냥 저장해라.
		saveData();
		}
		
	});
});

function rollbackAttachedFile(){
	var s3 = new AWS.S3();
	for(var j=1; j<=pamvariables.tmpImgCnt; j++){
		var params = {
				  Bucket : awssetup.s3bucket,
				  Key: pamvariables.imgMap.get(j).getBucketfolder() + "/" +pamvariables.imgMap.get(j).getFilenewname() /* required */
				};
		s3.deleteObject(params, function(err, data) {
			console.log(err);
		  null;
		});
	}
}

function saveData(){
	
	for(var j=1; j<=pamvariables.tmpImgCnt; j++){
		//console.log("pamvariables.imgMap.get(j).getFilename() : " + pamvariables.imgMap.get(j).getFilename());
		$("#p"+pamvariables.imgMap.get(j).getSeqno()+"_imagename").attr("value", pamvariables.imgMap.get(j).getFilename());
		$("#p"+pamvariables.imgMap.get(j).getSeqno()+"_imagesize").attr("value", pamvariables.imgMap.get(j).getFilesize());
		$("#p"+pamvariables.imgMap.get(j).getSeqno()+"_imageurl").attr("value", pamvariables.imgMap.get(j).getS3url());
		$("#p"+pamvariables.imgMap.get(j).getSeqno()+"_images3filename").attr("value", pamvariables.imgMap.get(j).getFilenewname());
	}
	
	$.ajax({
        url : "<spring:message code='root'/>/products/productssave.do",
        type : 'post',
        data : $('#productsform').serialize(),
        success:function(data){
            //list 페이지로 넘어가자
            mega.saveHideDialog();
            mega.showInfoMsg("저장성공", "성공적으로 저장하였습니다.", function(){window.location="<spring:message code='root'/>/products/productslist.do";});
        },
        error:function(err){
        	//오류 메세지 뿌리고 화면 초기화
        	console.log(err);
        	rollbackAttachedFile();
        	mega.saveHideDialog();
        	mega.showWarnMsg("저장오류", "저장 시 오류가 발생하였습니다.");
        }
    });
}

function checkRequiredFields(){
	if ($("#product_name").val().trim() ==""){
		mega.showWarnMsg( "입력 항목 확인!" ,"\"상품명\"을 입력하세요");
		$("#product_name").focus();
		return false;
	}	
	if ($("#category1 option:selected").val() =="--"){
		mega.showWarnMsg( "입력 항목 확인!" ,"\"주제분류\"를 선택하세요");
		$("#category1").focus();
		return false;
	}	
	if ($("#tags").val().trim() ==""){
		mega.showWarnMsg( "입력 항목 확인!" ,"\"태그\"를 입력하세요");
		$("#tags").focus();
		return false;
	}	
	if ($("#copy").val().trim() ==""){
		mega.showWarnMsg( "입력 항목 확인!" ,"\"Copy\"를 입력하세요");
		$("#copy").focus();
		return false;
	}
	if ($("#story_telling").val().trim() ==""){
		mega.showWarnMsg( "입력 항목 확인!" ,"\"스토리텔링\"을 입력하세요");
		$("#story_telling").focus();
		return false;
	}
	if ($("#selling_point").val().trim() ==""){
		mega.showWarnMsg( "입력 항목 확인!" ,"\"셀링포인트\"를 입력하세요");
		$("#selling_point").focus();
		return false;
	}
	 
	for(var i=1; i <= pamvariables.g_currentSizeCnt; i++){
		if ($("#p"+i+"_image").val() == "" && $("#p"+i+"_imagename").val() == "") {
			mega.showWarnMsg( "입력 항목 확인!" , i+"번째 이미지 파일 첨부가 누락되었습니다.");
			return false;
		}
	}
	return true;
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
			<h3 class="col-xs-2">상품등록</h3>
			<div class="col-xs-8"></div>
		</div>
		<div class="row">
			<div class="col-xs-4">&nbsp;</div>
			<div class="col-xs-4 text-right"><c:if test="${irud != 'NEW' }"><button id="btnCopy" type="button" class="btn btn-sm btn-primary" >복제</button></c:if></div>
			<div class="col-xs-4"></div>
		</div>
		<div class="row">
			<div class="col-xs-1"></div>
			<div class="col-xs-10" style="overflow: hidden;"><h1><img src="<spring:message code="root"/>/images/line.gif"></h1></div>
			<div class="col-xs-1"></div>			
		</div>
		<form class="form-horizontal" role="form" data-toggle="validator"  method="post" id="productsform">
				<input type="hidden" name="irud" id="irud" value="${irud}">
				<input type="hidden" name="idx" id="idx" value="${idx}">
				<input type="hidden" name="size" id="size" value="${size}">
			<div class=" row form-group">
				<label class="col-xs-2 control-label" for="product_name">상품명</label>
				<div class="col-xs-6">
					<input class="form-control" id="product_name" name="product_name" type="text" value="${product_name}">
				</div>
				<div class="col-xs-4"></div>
			</div>
			<div class=" row form-group">
				<label class="col-xs-2 control-label" for="category1">주제분류</label>
				<div class="col-xs-2">
					<select class="form-control" id="category1" name="category1" >
						<c:forEach items="${category1_list}" var="ctg1" varStatus="loopcnt">
							<option value="${ctg1.category_id}" <c:if test="${category1 == ctg1.category_id }">selected</c:if>>${ctg1.category_name }</option>
		                </c:forEach>
					</select>
				</div>
				<div class="col-xs-8"></div>
			</div>
			<div class=" row form-group">
				<label class="col-xs-2 control-label" for="tags">태그</label>
				<div class="col-xs-4">
					<input class="form-control" id="tags" name="tags" type="text" value="${tag}">
				</div>
				<div class="col-xs-2 text-left"><p class="control-label" style="text-align:left">예) 고등어,남천점</p></div>
				<div class="col-xs-4"></div>
			</div>
			<div class=" row form-group">
				<label class="col-xs-2 control-label" for="copy">Copy</label>
				<div class="col-xs-6">
					<textarea rows="2" cols="72" name="copy" id="copy">${copy}</textarea>
				</div>
				<div class="col-xs-4"></div>
			</div>
			<div class=" row form-group">
				<label class="col-xs-2 control-label" for="story_telling">스토리텔링</label>
				<div class="col-xs-8">
					<textarea rows="4" cols="72" name="story_telling" id="story_telling">${story_telling}</textarea>
				</div>
				<div class="col-xs-4"></div>
			</div>
			<div class=" row form-group">
				<label class="col-xs-2 control-label" for="selling_point">셀링포인트</label>
				<div class="col-xs-6">
					<input class="form-control" id="selling_point" name="selling_point" type="selling_point" value="${selling_point}">
				</div>
				<div class="col-xs-4"></div>
			</div>
			<div class="row">&nbsp;</div>
			<div class=" row form-group">
				<div class="col-xs-2"></div>
				<div class="col-xs-1 text-left"><button id="addfile" type="button" class="btn btn-xs btn-danger glyphicon glyphicon-plus" style="margin-top: 0.5em">첨부추가</button></div>
				<div class="col-xs-1 text-left"><button id="delfile" type="button" class="btn btn-xs btn-danger glyphicon glyphicon-minus"  style="margin-top: 0.5em">첨부삭제</button></div>
				<div class="col-xs-2"><h6>최대 10개 ( <span id="filecnt">0</span>/10 )</h6></div>
				<div class="col-xs-2"></div>
			</div>
			<div id="fileSection">				
			</div>
			<div class=" row form-group">
				<label class="col-xs-2 control-label" for="usagediv">사용여부</label>
				<div class="col-xs-3">
					<div id="usagediv">
					<label class="radio-inline"><input type="radio" name="usage" value="Y"  <c:if test="${usage_flag == 'Y'}">checked</c:if>>사용</label>
					<label class="radio-inline"><input type="radio" name="usage" value="N" <c:if test="${usage_flag == 'N'}">checked</c:if>>미사용</label>
					</div>
				</div>
				<div class="col-xs-7"></div>
			</div>
			<div class="row">
				<div class="col-xs-1"></div>
				<div class="col-xs-10" style="overflow: hidden;"><h1><img src="<spring:message code="root"/>/images/line.gif"></h1></div>
				<div class="col-xs-1"></div>			
			</div>
			<div class=" row form-group">
				<div class="col-xs-5"></div>
				<div class="col-xs-1 text-center">
					<button id="btnSave" type="button" class="btn btn-info" >저장</button>
				</div>
				<div class="col-xs-1 text-center">
					<button id="btnCancel" type="button" class="btn btn-info">취소</button>
				</div>
				<div class="col-xs-5"></div>
			</div>
		</form>
	</div>
</body>
</html>