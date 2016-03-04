<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<div class="commentDiv" id="commentDiv">
	<div class="commentBtn text-right">
		<c:if test="${(param.category_flag eq 'PP' && sessionScope.pamphlet_comment eq 'Y') || (param.category_flag eq 'PD' && sessionScope.products_comment eq 'Y')}">
			<button class="btn btn-xs btn-default" id="newreply" onclick="showreplyDialog('${param.category_flag}', ${param.category_idx}, 0, 0, 'NEW', '', '')">댓글달기</button>
		</c:if>
	</div>
	<div class="commentList">
		<ol id="commentfield">
		</ol>
	</div>	
</div>
<style>
<!--
ol, ul, li {padding:0;}
 .test{list-style-type: none; border-bottom: 1px solid #fff;}
 .commentList li {padding-left:10px;}
 .commentList ul li{list-style-type: none; padding-left: 15px;}
 li div{margin-top: 0.5em;}
 div.commentDiv{padding-top: 0.5em;}
 
.lblpreply, .replyinput { display:block; }
.replyinput { margin-bottom:12px; width:95%; padding: .4em; }
.replyfieldset { padding:0; border:0;}
-->
</style>
<script type="text/javascript">
function displayComment(data){
	var list = data.list;
	var tmpparent_idx = 0;
	var innerHtml = "";
	
	$("#commentfield").empty();
    
	$.each(list, function(){
		var tmpcomment = this["comments"]; //.replace(/"/gi, '&quot;').replace(/'/gi, '&amp;').replace(/</gi, '&lt;').replace(/>/gi, '&gt;');
		if (tmpparent_idx > 0 && tmpparent_idx != this["parent_idx"]){ innerHtml += "</li>"; }
		if (this["depth"] =="1"){
			innerHtml += "<li class='test' id='comment"+this["idx"]+"'>";
			innerHtml += "<div class='comment-contents'>";
			innerHtml += "<span>"+this["created_by"]+"</span>";
			innerHtml += " <span>"+this["created_date"]+"</span>";	
			<c:if test="${(param.category_flag eq 'PP' && sessionScope.pamphlet_comment eq 'Y') || (param.category_flag eq 'PD' && sessionScope.products_comment eq 'Y')}">
			innerHtml += " <button class='btn btn-xs btn-default' onclick='showreplyDialog(\"${param.category_flag}\", ${param.category_idx}, "+this["parent_idx"]+", 0, \"REPLY\", \"\", \"\")'>댓글</button>";
			</c:if>
			if(this["empno"] == "<c:out value="${sessionScope.empno}"/>"){
				innerHtml += " <button class='btn btn-xs btn-default' onclick='showreplyDialog(\"${param.category_flag}\", ${param.category_idx}, "+this["parent_idx"]+", "+this["idx"]+", \"UPDATE\", \""+tmpcomment+"\", \"\")'>수정</button>"
				innerHtml += " <button class='btn btn-xs btn-default' onclick='showPwdCheckDialog(\"${param.category_flag}\", ${param.category_idx}, "+this["parent_idx"]+", "+this["idx"]+", \"DELETE\", \"\")'>삭제</button>"
			}
			innerHtml += "<p>"+tmpcomment+"</p>";
			innerHtml += "</div>";
		}else if (this["depth"] =="2"){
			innerHtml += "<ul>";
			innerHtml += "<li id='comment"+this["idx"]+"'>";
			innerHtml += "<div class='comment-contents'>";
			innerHtml += "<span>"+this["created_by"]+"</span>";
			innerHtml += "<span>"+this["created_date"]+"</span>";
			if(this["empno"] == "<c:out value="${sessionScope.empno}"/>"){
				innerHtml += " <button class='btn btn-xs btn-default' onclick='showreplyDialog(\"${param.category_flag}\", ${param.category_idx}, "+this["parent_idx"]+", "+this["idx"]+", \"UPDATE\", \""+tmpcomment+"\", \"\")'>수정</button>"
				innerHtml += " <button class='btn btn-xs btn-default' onclick='showPwdCheckDialog(\"${param.category_flag}\", ${param.category_idx}, "+this["parent_idx"]+", "+this["idx"]+", \"DELETE\", \"\")'>삭제</button>"
			}
			innerHtml += "<p>"+this["comments"]+"</p>";
			innerHtml += "</div>";
			innerHtml += "</li>";
			innerHtml += "</ul>";
		}
		tmpparent_idx = this["parent_idx"];
	});
	if (tmpparent_idx > 0){ innerHtml += "</li>"; }
	
	$("#commentfield").append(innerHtml);
	
	$(".reply").button({icons: {primary: "ui-icon-plus"},text: false});
	$(".edit").button({icons: {primary: "ui-icon-pencil"},text: false});
	$(".del").button({icons: {primary: "ui-icon-closethick"},text: false});
}

function checklength(o, n){
	
    if ( o.val().length == 0 ) {
        o.addClass( "ui-state-error" );
        return false;
      } else {
        return true;
      }
}

function savecomment(){
	  //$("#password").removeClass("ui-state-error");
	  $("#comment").removeClass("ui-state-error");
	  //if(!checklength($("#password"))) return false;
	  if(!checklength($("#comment"))) return false;
	  
	  $("#editedcomment").val($("#comment").val().replace(/"/gi, '&quot;').replace(/'/gi, '&amp;').replace(/</gi, '&lt;').replace(/>/gi, '&gt;').replace(/\n/g, '<br>').replace(/ /g, '&nbsp;'));
	  
	  //console.log($("#comment").val());
	  //save operation //댓글 refreash까지 해야한다...
	  $.ajax({
        url : "<spring:message code='root'/>/common/commentsave.do",
        type : 'post',
        data : $('#replyform').serialize(),
        success:function(data){
            //댓글 reload
            if(data == 'SUCCESS'){
            	$( "#replydialog" ).dialog('close');
	           	 $("#replydialog").remove();
	           	reloadComment('${param.category_flag}', "<c:out value="${param.category_idx}"/>");
            }else{
            	alert("저장 중 오류가 발생했습니다.");
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

function reloadComment(category_flag, category_idx){
	$.ajax({
        url : "<spring:message code='root'/>/common/commentlist.do",
        type : 'post',
        data : 'category_flag='+category_flag+'&category_idx='+category_idx,
        success:function(data){
        	//data.count =>댓글 갯수
        	//data.list =>댓글
        	displayComment(data);
        },
        error:function(err){
        	//오류 메세지 뿌리고 화면 초기화
        	console.log(err);
        	alert(err);
        }
    });
}



function showreplyDialog(category_flag, category_idx, parent_idx, idx, comment_irud, comment, pwd){
	//세션 체크해서 댓글 못달게 하자.
	if("<c:out value="${sessionScope.empno}"/>" == null){
		var innerHtml =  " <div id='sessionerrordialog' title='로그인정보 확인'>";
		innerHtml += " <pre id='msg'>로그인 정보를 확인할 수 없습니다. <br> 다시 로그인하세요.</pre>";
		innerHtml += " </div>";	
		$("body").append(innerHtml);		
		$( "#sessionerrordialog" ).dialog({
	        autoOpen: true,
	        height: 160,
	        width: 280,
	        modal: true,
	        resizable:false,
	        open: function(){
	        	$buttonPane1 = $(this).next();
	        	$buttonPane1.find('button:first').addClass('btn').addClass('btn-primary').addClass('btn-sm');
	        },
	        buttons: {
	          "닫기": function(){
	        	  $("#sessionerrordialog").dialog("close");
		          $("#sessionerrordialog").remove();
		          window.location = "<spring:message code='root'/>/common/login.do";
		          return false;
	          }
	        },
	        close: function() {
	          $("#sessionerrordialog").dialog("close");
	          $("#sessionerrordialog").remove();
	          window.location = "<spring:message code='root'/>/common/login.do";
	          return false;
	        }
	      });	
	}
	
	comment = comment.replace(/<br>/g, '\n');
	var innerHtml =  " <div id='replydialog' title='댓글입력'>";
	innerHtml += " <form method='post' id='replyform'>";
	innerHtml += " <fieldset class='replyfieldset'>";
	innerHtml += "  <input type='hidden' name='category_flag' id='category_flag' value='"+category_flag+"'>";
	innerHtml += "  <input type='hidden' name='category_idx' id='category_idx' value='"+category_idx+"'>";
	innerHtml += "  <input type='hidden' name='parent_idx' id='parent_idx' value='"+parent_idx+"'>";
	innerHtml += "  <input type='hidden' name='idx' id='idx' value='"+idx+"'>";
	innerHtml += "  <input type='hidden' name='comment_irud' id='comment_irud' value='"+comment_irud+"'>";
	innerHtml += "  <input type='hidden' name='editedcomment' id='editedcomment' >";
	//innerHtml += "  <p><label for='password'>Password</label>&nbsp;&nbsp;&nbsp;<input type='password' name = 'password' id='password' maxlength='10' class='text ui-widget-content ui-corner-all' value='"+pwd+"'></p>";
	innerHtml += "  <label for='comment' class='lblpreply'>Comment</label>";
	innerHtml += "  <textarea name='comment'  id='comment' cols='45' rows='3' class='text ui-widget-content ui-corner-all replyinput'>"+comment+"</textarea>";
	innerHtml += " </fieldset>";
	innerHtml += " </form>";
	innerHtml += " </div>";
	
	$("#commentDiv").append(innerHtml);

	dialog = $( "#replydialog" ).dialog({
        autoOpen: true,
        height: 250,
        width: 400,
        modal: true,
        resizable:false,
        open: function(){
        	$buttonPane1 = $(this).next();
        	$buttonPane1.find('button:first').addClass('btn').addClass('btn-primary').addClass('btn-sm');
        	$buttonPane1.find('button:last').addClass('btn').addClass('btn-primary').addClass('btn-sm');
        },
        buttons: {
          "Save": savecomment,
          Cancel: function() {
            dialog.dialog( "close" );
            $("#replydialog").remove();
          }
        },
        close: function() {
          dialog.dialog("close");
          $("#replydialog").remove();
        }
      });	
}

function showPwdCheckDialog(category_flag, category_idx, parent_idx, idx, comment_irud, comment){
	$.ajax({
        url : "<spring:message code='root'/>/common/commentpwd.do",
        type : 'post',
        data : 'idx='+idx+'&comment_irud='+comment_irud,
        success:function(data){
            if(data == "DELETE_SUCCESS"){
            	reloadComment(category_flag, category_idx)
            }else{
            	alert("댓글 삭제 오류");
            	return false;
            }
        },
        error:function(err){
        	alert("댓글 삭제 오류");
        }
    });
}
</script>