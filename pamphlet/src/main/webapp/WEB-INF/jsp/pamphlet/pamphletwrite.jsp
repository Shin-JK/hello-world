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
<title>전단등록</title>
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
	//전단일자 calendar Setup.
	$("#reg_date").datepicker();
	$("#reg_date").parent().css("z-index", 1000);
	$("#reg_date").datepicker("option", "dateFormat", "yy-mm-dd");
	$("#reg_date").datepicker("setDate", "${reg_date}");
	//전단크기 Setup
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
	var pdfList = new Array();
	<c:forEach items="${pdffile}" var="pdfs">
		fileexist = true;
		var tmpMap = new megaMap();
		tmpMap.put("seq", "${pdfs.seq}");
		tmpMap.put("file_name", "${pdfs.file_name}");
		tmpMap.put("url", "${pdfs.url}");
		tmpMap.put("file_size", "${pdfs.file_size}");
		tmpMap.put("s3_file_name", "${pdfs.s3_file_name}");
		pdfList.push(tmpMap);
	</c:forEach>
	
	if (fileexist){
		pamvariables.g_currentSizeCnt = mega.changeFileCntPamphletForAttachFile($("#fileSection"), pamvariables.g_currentSizeCnt,  ${page_count}, imageList, pdfList); //초기 설정.
	} else {
		pamvariables.g_currentSizeCnt = mega.changeFileCntPamphlet($("#fileSection"), pamvariables.g_currentSizeCnt,  ${page_count}); //초기 설정.
	}
	
	$("#page_count").change(function(){
		pamvariables.g_currentSizeCnt = mega.changeFileCntPamphlet($("#fileSection"), pamvariables.g_currentSizeCnt, parseInt($("#page_count option:selected").val()));
	});
	
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
	
	//복제버튼
	$("#btnCopy").click(function(){
		$("#irud").val("NEW");
		$("#idx").val("0");
		$("#title").val("");
		$(this).hide();
	});
	
	//취소버튼
	$("#btnCancel").click(function(){
		window.location = "<spring:message code='root'/>/pamphlet/pamphletlist.do";
	});
	
	//저장버튼
	$("#btnSave").click(function(){
		if(!checkRequiredFields()){
			return false;
		}
		//return false;
		//step1. 첨부파일을 S3로 올린다
		//전체첨부파일 갯수(이미지, pdf 전체)를 변수에 입력해 놓고
		//하단 루프 도는데서 성공하면 임시 변수에 성공카운트를 하나씩 늘리고
		//실패하면 실패 카운트를 하나씩 늘리는 거야.
		// 전체 첨부파일 갯수 = 실패 카운트 + 성공카운트 이니까
		// 성공시든, 실패시든간에 '전체 첨부파일 갯수 = 실패 카운트 + 성공카운트'
		//를 체크해서 같으면서, 실패 카운트가 있으면 롤백하는 함수를 호출하고
		//실패카운트가 0이고 성공카운트 = 전채 첨부파일 갯수 이면 DB에 저장
		pamvariables.imgMap = new megaMap();
		pamvariables.pdfMap = new megaMap();
		
		pamvariables.tmpTotCnt = 0;
		pamvariables.tmpImgCnt = 0;
		pamvariables.tmpPdfCnt = 0;
				
		for(var i=1; i <= pamvariables.g_currentSizeCnt; i++){
			if ($("#p"+i+"_image").val() != ""){
				pamvariables.tmpImgCnt += 1;
				var tmpAttachFile1 = new attachFile();
				tmpAttachFile1.setSeqno(i);
				tmpAttachFile1.setFile($("#p"+i+"_image")[0].files[0], "PP");
				pamvariables.imgMap.put(pamvariables.tmpImgCnt, tmpAttachFile1);				
				
				pamvariables.tmpTotCnt += 1; //전체 첨부파일 갯수 +1
			}
			
			if ($("#p"+i+"_pdf").val() != ""){
				pamvariables.tmpPdfCnt += 1;
				var tmpAttachFile2 = new attachFile();
				tmpAttachFile2.setSeqno(i);
				tmpAttachFile2.setFile($("#p"+i+"_pdf")[0].files[0], "PP");
				pamvariables.pdfMap.put(pamvariables.tmpPdfCnt, tmpAttachFile2);
				
				pamvariables.tmpTotCnt += 1; //전체 첨부파일 갯수 +1
			}
		}
		//모달 다이얼로그 출력
		mega.saveShowDialog(pamvariables.tmpTotCnt);

		if (pamvariables.tmpImgCnt > 0 || pamvariables.tmpPdfCnt > 0){
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
						if (pamvariables.tmpTotCnt == pamvariables.tmpErrCnt + pamvariables.tmpSucCnt){
							rollbackAttachedFile();
							mega.saveHideDialog();
							mega.showWarnMsg( "File Upload 실패" ,"첨부파일 업로드시 오류가 발생하였습니다.");
							
							return false;
						}
					} else {
						pamvariables.tmpSucCnt += 1;
						mega.saveRefreshDialog(pamvariables.tmpSucCnt);
						if (pamvariables.tmpTotCnt == pamvariables.tmpErrCnt + pamvariables.tmpSucCnt && pamvariables.tmpErrCnt > 0){
							rollbackAttachedFile();
							mega.saveHideDialog();
							mega.showWarnMsg( "File Upload 실패" ,"첨부파일 업로드시 오류가 발생하였습니다.");
							return false;
						}
						
						if (pamvariables.tmpTotCnt == pamvariables.tmpSucCnt){
							saveData();
						}
					}
				});
			}
			
			//pdf 파일 S3 저장
			for(var k=1; k<=pamvariables.tmpPdfCnt; k++){
				var params2 = {
						Bucket : awssetup.s3bucket,
						Key : pamvariables.pdfMap.get(k).getBucketfolder() + "/" +pamvariables.pdfMap.get(k).getFilenewname(), //newFileName, 
						ACL : awssetup.s3ACL,
						Body : pamvariables.pdfMap.get(k).getFile(),
						ContentType : pamvariables.pdfMap.get(k).getFiletype()
					};
				
				s3.putObject(params2, function(err, data) {
					if (err) {
						pamvariables.tmpErrCnt += 1;
						if (pamvariables.tmpTotCnt == pamvariables.tmpErrCnt + pamvariables.tmpSucCnt){
							rollbackAttachedFile();
							mega.saveHideDialog();
							mega.showWarnMsg( "File Upload 실패" ,"첨부파일 업로드시 오류가 발생하였습니다.");
							return false;
						}
					} else {
						pamvariables.tmpSucCnt += 1;
						mega.saveRefreshDialog(pamvariables.tmpSucCnt);
						if (pamvariables.tmpTotCnt == pamvariables.tmpErrCnt + pamvariables.tmpSucCnt && pamvariables.tmpErrCnt > 0){
							rollbackAttachedFile();
							mega.saveHideDialog();
							mega.showWarnMsg( "File Upload 실패" ,"첨부파일 업로드시 오류가 발생하였습니다.");
							return false;
						}
						
						if (pamvariables.tmpTotCnt == pamvariables.tmpSucCnt){
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
	for(var k=1; k<=pamvariables.tmpPdfCnt; k++){
		var params = {
				  Key: pamvariables.pdfMap.get(k).getBucketfolder() + "/" +pamvariables.pdfMap.get(k).getFilenewname() /* required */
				};
		s3.deleteObject(params, function(err, data) {
			console.log(err);
		  null;
		});
	}
}

function saveData(){
	for(var j=1; j<=pamvariables.tmpImgCnt; j++){
		$("#p"+pamvariables.imgMap.get(j).getSeqno()+"_imagename").attr("value", pamvariables.imgMap.get(j).getFilename());
		$("#p"+pamvariables.imgMap.get(j).getSeqno()+"_imagesize").attr("value", pamvariables.imgMap.get(j).getFilesize());
		$("#p"+pamvariables.imgMap.get(j).getSeqno()+"_imageurl").attr("value", pamvariables.imgMap.get(j).getS3url());
		$("#p"+pamvariables.imgMap.get(j).getSeqno()+"_images3filename").attr("value", pamvariables.imgMap.get(j).getFilenewname());
	}
	for(var k=1; k<=pamvariables.tmpPdfCnt; k++){
		$("#p"+pamvariables.pdfMap.get(k).getSeqno()+"_pdfname").attr("value", pamvariables.pdfMap.get(k).getFilename());
		$("#p"+pamvariables.pdfMap.get(k).getSeqno()+"_pdfsize").attr("value", pamvariables.pdfMap.get(k).getFilesize());
		$("#p"+pamvariables.pdfMap.get(k).getSeqno()+"_pdfurl").attr("value", pamvariables.pdfMap.get(k).getS3url());
		$("#p"+pamvariables.pdfMap.get(k).getSeqno()+"_pdfs3filename").attr("value", pamvariables.pdfMap.get(k).getFilenewname());
	}
	$.ajax({
        url : "<spring:message code='root'/>/pamphlet/pamphletsave.do",
        type : 'post',
        data : $('#pamphletform').serialize(),
        success:function(data){
            //list 페이지로 넘어가자
            mega.saveHideDialog();
            mega.showInfoMsg("저장성공", "성공적으로 저장하였습니다.", function(){window.location="<spring:message code='root'/>/pamphlet/pamphletlist.do";});
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
	if ($("#title").val().trim() ==""){
		mega.showWarnMsg( "입력 항목 확인!" ,"\"전단 타이틀\"을 입력하세요");
		$("#title").focus();
		return false;
	}
	
	if ($("#reg_date").val().trim() ==""){
		mega.showWarnMsg( "입력 항목 확인!" ,"\"전단 일자\"를 입력하세요");
		$("#title").focus();
		return false;
	}	
	
	if ($("#tags").val().trim() ==""){
		mega.showWarnMsg( "입력 항목 확인!" ,"\"태그\"를 입력하세요");
		$("#tags").focus();
		return false;
	}
	
	for(var i=1; i <= pamvariables.g_currentSizeCnt; i++){
		if ($("#p"+i+"_image").val() == "" && $("#p"+i+"_imagename").val() == "") {
			mega.showWarnMsg( "입력 항목 확인!" , i+"번째 이미지 파일 첨부가 누락되었습니다.");
			return false;
		}
		if ($("#p"+i+"_pdf").val() == "" && $("#p"+i+"_pdfname").val() == "") {
			mega.showWarnMsg( "입력 항목 확인!" , i+"번째 PDF 파일 첨부가 누락되었습니다.");
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
			<h3 class="col-xs-2">전단등록</h3>
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
		<form class="form-horizontal" role="form" data-toggle="validator"  method="post" id="pamphletform">
				<input type="hidden" name="irud" id="irud" value="${irud}">
				<input type="hidden" name="idx" id="idx" value="${idx}">
			<div class=" row form-group">
				<label class="col-xs-2 control-label" for="title">전단 타이틀</label>

				<div class="col-xs-6">
					<input class="form-control" id="title" name="title" type="text" value="${title}">
				</div>
				<div class="col-xs-4"></div>
			</div>
			<div class=" row form-group">
				<label class="col-xs-2 control-label" for="reg_date">전단 일자</label>
				<div class="col-xs-4">
					<div class="input-group">
						<input class="date-picker form-control" id="reg_date" name="reg_date" type="text" value="${reg_date}">
						<label for="reg_date" class="input-group-addon btn">
							<span class="glyphicon glyphicon-calendar"></span>
						</label>
					</div>
				</div>
				<div class="col-xs-7"></div>
			</div>
			<div class=" row form-group">
				<label class="col-xs-2 control-label" for="store">점포</label>
				<div class="col-xs-4">
					<select class="form-control" id="store" name="store" >
						<c:forEach items="${storelist}" var="stores" varStatus="loopcnt">
							<option value="${stores.store_no }" <c:if test="${store == stores.store_no }">selected</c:if>>${stores.store_name }</option>
		                </c:forEach>
					</select>
				</div>
				<div class="col-xs-6"></div>
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
				<label class="col-xs-2 control-label" for="page_size">전단크기</label>
				<div class="col-xs-2">
					<select class="form-control" id="page_size" name="page_size" >
						<option value="2" <c:if test="${page_size ==2}">selected</c:if>>2절</option>
						<option value="4" <c:if test="${page_size ==4}">selected</c:if>>4절</option>
						<option value="8" <c:if test="${page_size ==8}">selected</c:if>>8절</option>
					</select>
				</div>
				<div class="col-xs-2">
					<select class="form-control" id="page_count" name="page_count" >
						<option value="2" <c:if test="${page_count ==2}">selected</c:if>>2P</option>
						<option value="4" <c:if test="${page_count ==4}">selected</c:if>>4P</option>
						<option value="6" <c:if test="${page_count ==6}">selected</c:if>>6P</option>
					</select>
				</div>
				<div class="col-xs-6"></div>
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