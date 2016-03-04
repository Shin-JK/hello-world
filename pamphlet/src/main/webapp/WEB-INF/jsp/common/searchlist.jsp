<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge"/> 
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>메가마트</title>
<link rel="stylesheet" href="<spring:message code='root'/>/css/jquery-ui-1.10.0.custom.css">
<link rel="stylesheet" href="<spring:message code='root'/>/css/bootstrap.min.css">
<link rel="stylesheet" href="<spring:message code='root'/>/css/mega-common.css">
<script src="<spring:message code='root'/>/js/jquery-1.11.3.min.js"></script>
<script src="<spring:message code='root'/>/js/jquery-ui-1.9.2.custom.min.js"></script>
<script src="<spring:message code='root'/>/js/bootstrap.min.js"></script>

<script type="text/javascript">
$(document).ready(function(){	
	$("#btnSearch").click(function(){
		$("#searchForm").removeAttr("target");
		$("#searchForm").attr("action", "<spring:message code='root'/>/common/searchlist.do");
		$("#searchForm").submit();
	});
		 
	 //Tab 처리
	 $(".tab-pane").each(function(){
		if($(this).attr("id") != 'PP')	 $(this).hide();
	 });
	 
	 $(".tab_menu li").each(function(){
		$(this).click(function(){
			$(".tab_menu li").each(function(){ 
				$(this).removeClass("on");
				$("#"+$(this).attr("tabid")).hide();
			});
			$(this).attr("class", "on");
			$("#"+$(this).attr("tabid")).show();
		}); 
	 });
	 
});

function moveLogin(){
	window.location = "<spring:message code='root'/>/common/login.do";
}
function showPopup(imageurl){
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

function popupDialog(tabid, idx){
	//tabid가 PP(전단일 경우와 그렇지 않을 경우를 분리해야 함)
	$("body").append("<div id='popupDialogdiv' title='상세보기'><iframe id ='popupiFrame' name='popupiFrame' width='100%' height='100%' marginWidth='0' marginHeight='0' frameBorder='0' scrolling='auto' /></div>");
	
	$("#popupDialogdiv").dialog({
        autoOpen: true,
        height: 600,
        width: 820,
        modal: true,
        resizable: false,
        open: function(){
        	if(tabid=="PP"){
        		$("#popupiFrame").attr("src", "<spring:message code='root'/>/pamphlet/pamphletpopupview.do?idx="+idx);
        	}else{
        		//상품 상세화면 추가
        		$("#popupiFrame").attr("src", "<spring:message code='root'/>/products/productspopupview.do?idx="+idx);
        	}
        	$buttonPane = $(this).next();
            $buttonPane.find('button:first').addClass('btn').addClass('btn-primary').addClass('btn-sm');
        },
        buttons: {
          "닫기": function(){
        	  $("iframe").attr("src", "#");
        	  $( "#popupDialogdiv" ).dialog("close");
        	  $("#popupDialogdiv").remove();
        	  //$("#popupform").remove();
          }
        },
        close: function() {
        	$("iframe").attr("src", "#");
      	  $( "#popupDialogdiv" ).dialog("close");
      	  $("#popupDialogdiv").remove();
        }
      });	
}

function goPage(tabid, type, selectedpage){
	$("#tabid").val(tabid);
	$("#type").val(type);
	$("#selectedpage").val(selectedpage);
	
	$.ajax({
        url : "<spring:message code='root'/>/common/searchmovepage.do",
        type : 'post',
        data : $('#searchForm').serialize(),
        success:function(data){
            refreshScreen(data);
        },
        error:function(err){
        	//오류 메세지 뿌리고 화면 초기화
        	console.log(err);
        	alert(err);
        }
    });
}

function refreshScreen(data){
	var list = data.list;
	var page = data.page;
	var tabid = data.tabid;
	var type = data.type;
	var innerHtml = '';
	var pagerHtml = '';
	var listlength = list.length;
	var tmploopcnt = 0;
	
	var startpageno = parseInt(page["startPageNo"]);
	var endpageno = parseInt(page["endPageNo"]);
	var pageno = parseInt(page["pageNo"]);
	//$( "div."":first" )
	
	if(type == "IMAGE"){
		
		//Image 영역 새로그리기
		$("#"+tabid+"-screen").empty();
		if (listlength == 0){
			innerHtml='<table><tr><td>검색된 이미지가 없습니다.</td></tr></table>\n';
		}else{
			innerHtml += '<table>';
			$.each(list, function(){
				//var tmpfilename = this["file_name"].replace(/"/gi, '&quot;').replace(/'/gi, '&amp;').replace(/</gi, '&lt;').replace(/>/gi, '&gt;').replace(/\n/g, '<br>').replace(/ /g, '&nbsp;');
				//var tmpTitle = this["title"].length > 10 ? this["title"].substring(0, 8).replace(/"/gi, '&quot;').replace(/'/gi, '&amp;').replace(/</gi, '&lt;').replace(/>/gi, '&gt;').replace(/\n/g, '<br>').replace(/ /g, '&nbsp;') +'...' : this["title"].replace(/"/gi, '&quot;').replace(/'/gi, '&amp;').replace(/</gi, '&lt;').replace(/>/gi, '&gt;').replace(/\n/g, '<br>').replace(/ /g, '&nbsp;');
				//var tmpTitle2= this["title"].length > 20 ? this["title"].substring(0, 18).replace(/"/gi, '&quot;').replace(/'/gi, '&amp;').replace(/</gi, '&lt;').replace(/>/gi, '&gt;').replace(/\n/g, '<br>').replace(/ /g, '&nbsp;') +'...' : this["title"].replace(/"/gi, '&quot;').replace(/'/gi, '&amp;').replace(/</gi, '&lt;').replace(/>/gi, '&gt;').replace(/\n/g, '<br>').replace(/ /g, '&nbsp;'); 
				if(tmploopcnt%4 == 0){
					innerHtml += '<tr>\n';
				}
				
				innerHtml += ' <td>\n' +
								' <a href="javascript:popupDialog(\''+tabid+'\', '+this["category_idx"]+')"><img class="img-thumbnail" src="'+this["thumbsurl"]+'" onError="this.onerror=null;this.src=\'<spring:message code="root"/>/images/wait_preview.jpg\';"></a>' +
								' </td>\n';
								
				if(tmploopcnt%4 == 3){
					innerHtml += '</tr>\n';
				}				
				tmploopcnt += 1;
			});
			if(listlength%4 > 0){
				for(i=listlength%4; i < 4; i++){
					innerHtml += '<td>&nbsp;</td>\n';
					if(i==3) innerHtml += '</tr>\n';
				}
			}
			innerHtml += '</table>';
		}		
		$("#"+tabid+"-screen").append(innerHtml);		
		
		//Image 페이지 새로그리기
		$("div."+tabid+"-imagepager").empty();
		pagerHtml += '<div class="col-md-12 text-center">\n' +
						'	<ul class="pagination pagination-xs">\n' +
						'	<li><a href="javascript:goPage(\''+tabid+'\', \'IMAGE\', '+page["firstPageNo"]+')">&lt;&lt;</a></li>\n' +
						'	<li><a href="javascript:goPage(\''+tabid+'\', \'IMAGE\', '+page["prevPageNo"]+')">&lt;</a></li>\n';
		for(j=startpageno; j<=endpageno; j++){
			if (j==pageno)	pagerHtml +='	<li class="active"><a href="#">'+j+'</a></li>\n';
			else pagerHtml +='	<li><a href="javascript:goPage(\''+tabid+'\', \'IMAGE\', '+j+')">'+j+'</a></li>\n';
		}
		pagerHtml += '	<li><a href="javascript:goPage(\''+tabid+'\', \'IMAGE\', '+page["nextPageNo"]+')">&gt;</a></li>\n' +
						'	<li><a href="javascript:goPage(\''+tabid+'\', \'IMAGE\', '+page["finalPageNo"]+')">&gt;&gt;</a></li>\n' +
						'    </ul>\n' +
					    '</div>\n';
		$("div."+tabid+"-imagepager").append(pagerHtml);
	}else{
		
		//Selling 영역 새로그리기		
		$("#"+tabid+"-con ul").empty();
		
		if (listlength == 0){
			innerHtml='<li>검색된 셀링포인트가 없습니다</li>\n';
		}else{
			$.each(list, function(){
				
				var tmpTitle = this["title"].length > 25 ? this["title"].substring(0, 23).replace(/"/gi, '&quot;').replace(/'/gi, '&amp;').replace(/</gi, '&lt;').replace(/>/gi, '&gt;').replace(/\n/g, '<br>').replace(/ /g, '&nbsp;') +'...' : this["title"].replace(/"/gi, '&quot;').replace(/'/gi, '&amp;').replace(/</gi, '&lt;').replace(/>/gi, '&gt;').replace(/\n/g, '<br>').replace(/ /g, '&nbsp;');
				var tmpText = this["text"].length > 40 ? this["text"].substring(0, 38).replace(/"/gi, '&quot;').replace(/'/gi, '&amp;').replace(/</gi, '&lt;').replace(/>/gi, '&gt;').replace(/\n/g, '<br>').replace(/ /g, '&nbsp;') +'...' : this["text"].replace(/"/gi, '&quot;').replace(/'/gi, '&amp;').replace(/</gi, '&lt;').replace(/>/gi, '&gt;').replace(/\n/g, '<br>').replace(/ /g, '&nbsp;');
				
				innerHtml += ' <li>\n' +
								' <span class="txt">\n' +
								' <span class="tit">\n' +
						        ' <a href="javascript:popupDialog(\''+tabid+'\', '+this["idx"]+')">'+tmpTitle+' <strong class="tit_s">'+this["created_date"]+'</strong></a>\n' +
						        ' </span>\n' +
					            ' <span>\n' +
				                ' <a href="javascript:popupDialog(\''+tabid+'\', '+this["idx"]+')">'+tmpText+'</a>\n' +
				                ' </span>\n' +
				                ' </span>\n' +
				                ' </li>';
			});
		}
		$("#"+tabid+"-con ul").append(innerHtml);
		
		//Selling 페이지 새로그리기
		$("div."+tabid+"-sellingpager").empty();
		pagerHtml += '<div class="col-md-12 text-center">\n' +
						'	<ul class="pagination pagination-xs">\n' +
						'	<li><a href="javascript:goPage(\''+tabid+'\', \'SELLING\', '+page["firstPageNo"]+')">&lt;&lt;</a></li>\n' +
						'	<li><a href="javascript:goPage(\''+tabid+'\', \'SELLING\', '+page["prevPageNo"]+')">&lt;</a></li>\n';
		for(j=startpageno; j<=endpageno; j++){
			if (j==pageno)	pagerHtml +='	<li class="active"><a href="#">'+j+'</a></li>\n';
			else pagerHtml +='	<li><a href="javascript:goPage(\''+tabid+'\', \'SELLING\', '+j+')">'+j+'</a></li>\n';
		}
		pagerHtml += '	<li><a href="javascript:goPage(\''+tabid+'\', \'SELLING\', '+page["nextPageNo"]+')">&gt;</a></li>\n' +
						'	<li><a href="javascript:goPage(\''+tabid+'\', \'SELLING\', '+page["finalPageNo"]+')">&gt;&gt;</a></li>\n' +
						'    </ul>\n' +
					    '</div>\n';
		$("div."+tabid+"-sellingpager").append(pagerHtml);
	}
}
</script>
</head>
<body>
	<!-- <div id="wrap"> -->
		<%-- <div id="mnuarea">
			<c:set var="menu" value="${menu}" scope="request" />
			<jsp:include page="../common/menu.jsp" flush="true"></jsp:include>
		</div> --%>
		<div id="header">
			 <div class="sch_box">
				<h1 class="total"><img src="<spring:message code="root"/>/images/logo_mega.gif"></h1>
				<form class="form-horizontal" method="post" id="searchForm">
					<input type="hidden" id="tabid" name="tabid" >
					<input type="hidden" id="type" name="type" >
					<input type="hidden" id="selectedpage" name="selectedpage" >
					<input type="hidden" id="idx" name="idx">
					<div class="sch_bdr">
						<input id="keyword" type="text" title="검색어를 입력해주세요" name="keyword" value="${keyword}" class="txt">
						<input id="btnSearch" type="image" alt="검색" src="<spring:message code="root"/>/images/bt_search.gif" class="searchbtn"/>
					</div>
				<!-- //sch_bdr -->
				 </form>
			 </div>
	    </div>
	    <div id="container">
	    	<div class="tab_menu">
	        	<ul>
	        		<c:choose>
			            <c:when test="${fn:length(tablist) > 0}">
			                <c:forEach items="${tablist}" var="tab1" varStatus="loopcnt">
								<li class="tabheader<c:if test="${loopcnt.index == 0}"> on</c:if>" tabid="${tab1.flag}">
									<div class="menu01 #${tab1.flag}" ><span class="txt"><c:out value="${tab1.name}"/></span></div>
								</li>			                
			                </c:forEach>
			            </c:when>
			        </c:choose>
				 </ul>
	        </div>
	        <c:choose>
	            <c:when test="${fn:length(tablist) > 0}">
	                <c:forEach items="${tablist}" var="tabs" varStatus="loopcnt1">
				        <div class="tab-pane<c:if test="${loopcnt1.index == 0}"> active</c:if>" id="${tabs.flag}">
							<h1 class="h1 nosub">이미지
							<img src="<spring:message code="root"/>/images/line.gif"></h1>
					        <div class="screen" id="${tabs.flag}-screen">
					        	<table>
					        	<c:choose>
						            <c:when test="${fn:length(tabs.imagelist) > 0}">
						                <c:forEach items="${tabs.imagelist}" var="imglist" varStatus="imgloop">
						                	<c:if test="${imgloop.index%4 == 0 }">
						                		<tr>
						                	</c:if>
						                	<td>
						                		<a href="javascript:popupDialog('${tabs.flag}', ${imglist.category_idx})">
						                			<img class="img-thumbnail" src="<c:out value="${imglist.thumbsurl}"/>" onError="this.onerror=null;this.src='<spring:message code='root'/>/images/wait_preview.jpg'">
						                		</a>
						                	</td>
											<c:if test="${imgloop.index % 4 == 3 }">
						                		</tr>
						                	</c:if>
						                </c:forEach>
						             	<c:choose>
			                				<c:when test="${fn:length(tabs.imagelist) % 4 > 0}">
				                				<c:forEach var="i" begin="${fn:length(tabs.imagelist) % 4}" end="3" step="1">
				                					<td>&nbsp;</td>
				                					<c:if test="${i ==3 }">
				                						</tr>
				                					</c:if>
				                				</c:forEach>
			                				</c:when>
			               		 		</c:choose>
			             			</c:when>
			             			<c:otherwise>
			             				<tr><td>검색된 이미지가 없습니다.</td></tr>
			             			</c:otherwise>
			        			</c:choose>
			        			</table>
					        </div>
					        <div class="row tab-inner ${tabs.flag}-imagepager">
								<div class="col-md-12 text-center">
									<ul class="pagination pagination-sm">
										<li><a href="javascript:goPage('${tabs.flag}', 'IMAGE', ${tabs.imagepage.firstPageNo})">&lt;&lt;</a></li>
										<li><a href="javascript:goPage('${tabs.flag}', 'IMAGE', ${tabs.imagepage.prevPageNo})">&lt;</a></li>
										<c:forEach var="i" begin="${tabs.imagepage.startPageNo}"	end="${tabs.imagepage.endPageNo}" step="1">
											<c:choose>
												<c:when test="${i eq tabs.imagepage.pageNo}"> <li class="active"><a href="#">${i}</a></li></c:when>
												<c:otherwise><li><a href="javascript:goPage('${tabs.flag}', 'IMAGE', ${i})">${i}</a></li></c:otherwise>
											</c:choose>
										</c:forEach>
										<li><a href="javascript:goPage('${tabs.flag}', 'IMAGE', ${tabs.imagepage.nextPageNo})">&gt;</a></li>
										<li><a href="javascript:goPage('${tabs.flag}', 'IMAGE', ${tabs.imagepage.finalPageNo})">&gt;&gt;</a></li>
									</ul>
								</div>
							</div>
							<c:choose>			 	
			 					<c:when test="${tabs.flag ne 'PP'}">
							         <h1 class="h1 dot">셀링포인트<img src="<spring:message code="root"/>/images/line.gif"></h1></h1>
							         <div class="con" id="${tabs.flag}-con">
							         	<ul>
							         	<c:choose>
								            <c:when test="${fn:length(tabs.sellinglist) > 0}">
								                <c:forEach items="${tabs.sellinglist}" var="sellinglist" varStatus="sellingloop">
							        				<li>
														<span class="txt">
														<span class="tit">
															<a href="javascript:popupDialog('${tabs.flag}',${sellinglist.idx})">
																<c:choose>
																	<c:when test="${fn:length(sellinglist.title) > 25}"><c:out value="${fn:substring(sellinglist.title,0,23)}"/>...</c:when>
   								  									<c:otherwise><c:out value="${sellinglist.title}"/></c:otherwise>
   								  								</c:choose>
   								  								<strong class="tit_s">${sellinglist.created_date}</strong>	
   								  							</a>
   								  						</span>   								  						
														<span>
															<a href="javascript:popupDialog('${tabs.flag}',${sellinglist.idx})">
																<c:choose>
																	<c:when test="${fn:length(sellinglist.text) > 40}"><c:out value="${fn:substring(sellinglist.text,0,38)}"/>...</c:when>
				           								  			<c:otherwise><c:out value="${sellinglist.text}"/></c:otherwise>
				           								  		</c:choose>
				           								  	</a>
				           								</span>
														</span>
									             	</li>
												</c:forEach>
											</c:when>
											<c:otherwise><li>검색된 셀링포인트가 없습니다</li></c:otherwise>
										</c:choose>
										</ul>
							        </div>
							        <div class="row tab-inner  ${tabs.flag}-sellingpager">
										<div class="col-md-12 text-center">
											<ul class="pagination pagination-sm">
												<li><a href="javascript:goPage('${tabs.flag}', 'SELLING', ${tabs.sellingpage.firstPageNo})">&lt;&lt;</a></li>
												<li><a href="javascript:goPage('${tabs.flag}', 'SELLING', ${tabs.sellingpage.prevPageNo})">&lt;</a></li>
												<c:forEach var="i" begin="${tabs.sellingpage.startPageNo}"	end="${tabs.sellingpage.endPageNo}" step="1">
													<c:choose>
														<c:when test="${i eq tabs.sellingpage.pageNo}"> <li class="active"><a href="#">${i}</a></li></c:when>
														<c:otherwise><li><a href="javascript:goPage('${tabs.flag}', 'SELLING', ${i})">${i}</a></li></c:otherwise>
													</c:choose>
												</c:forEach>
												<li><a href="javascript:goPage('${tabs.flag}', 'SELLING', ${tabs.sellingpage.nextPageNo})">&gt;</a></li>
												<li><a href="javascript:goPage('${tabs.flag}', 'SELLING', ${tabs.sellingpage.finalPageNo})">&gt;&gt;</a></li>
											</ul>
										</div>
									</div>
					        </c:when>
					     </c:choose>					        
				        </div>
				       </c:forEach>
				    </c:when>
				 </c:choose>
	    </div>
	<!-- </div> -->
</html>