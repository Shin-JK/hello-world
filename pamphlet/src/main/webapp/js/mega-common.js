var pamvariables = {
	imgMap : null,
	pdfMap : null,	
	g_currentSizeCnt : 0,
	tmpImgCnt :0,
	tmpPdfCnt : 0,
	tmpTotCnt : 0,
	tmpErrCnt : 0,
	tmpSucCnt : 0
};

var awssetup = {
	s3region : 'ap-northeast-1',
	s3bucket : 'mega.contents.db', //'megadev01',
	s3bucketpamphlet : 'pamphlet',
	s3bucketproduct : 'product',
	s3ACL : 'private', //'public-read',  //'private'
	s3accessKeyId : 'AKIAJBADIM27IWW4AXCQ',
	s3secretAccessKey : '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',
	init : function() {
		AWS.config.region = this.s3region;
		AWS.config.accessKeyId = this.s3accessKeyId;
		AWS.config.secretAccessKey = this.s3secretAccessKey;
	},
	s3url : function(filename,category) {
		if(category=="PP") return "https://s3-" + this.s3region + ".amazonaws.com/" + this.s3bucket + "/" + this.s3bucketpamphlet + "/" + filename;
		else return "https://s3-" + this.s3region + ".amazonaws.com/" + this.s3bucket + "/" + this.s3bucketproduct + "/" + filename;
	},
	s3Construct : function() {
		return new AWS.S3({
			params : {
				Bucket : this.s3bucket
			}
		});
	}
};

awssetup.init();

var imgfileoprn = {
	checkImageFileExt : function(fileName) {
		var fileNArray = fileName.split('.');
		var extname = (this.getFileExtention(fileName)).toLowerCase();

		if (extname != "jpg" && extname != "png" && extname != "gif"
				&& extname != "bmp") {
			return false;
		}
		return true;
	},

	getFileExtention : function(fileName) {
		var fileNArray = fileName.split('.');
		return fileNArray[fileNArray.length - 1];
	},

	getTimeStamp : function() {
		return Math.floor(new Date().getTime() / 1000);
	},

	changeFileName : function(fileName) {
		var newFileName = fileName; // encodeURI(encodeURIComponent(fileName));
		// //fileName
		var extname = this.getFileExtention(fileName);
		return newFileName.slice(0, newFileName.indexOf("." + extname)) +"_" 
				+ this.getTimeStamp() + "." + extname;
	}
};

var browser = (function() {
	var s = navigator.userAgent.toLowerCase();
	var match = /(webkit)[ \/](\w.]+)/.exec(s)
			|| /(opera)(?:.*version)?[ \/](\w.]+)/.exec(s)
			|| /(msie) ([\w.]+)/.exec(s)
			|| /(mozilla)(?:.*? rv:([\w.]+))?/.exec(s) || [];
	return {
		name : match[1] || "",
		version : match[2] || "0"
	};
}());

var mega = {
	showWarnMsg : function(title, contents, callback){
		BootstrapDialog.alert({
			 title : title,
			 message : contents,
			 type: BootstrapDialog.TYPE_DANGER,
			 callback : callback
		 });
	},
	
	showInfoMsg : function(title, contents, callback){
		BootstrapDialog.alert({
			 title : title,
			 message : contents,
			 type: BootstrapDialog.TYPE_INFO,
			 callback : callback
		 });
	},
	
	changeFileCntPamphlet : function(parent, oldcnt, newcnt){
		if (oldcnt > newcnt){
			for(var i=oldcnt; i > newcnt; i--){
				if(browser.name == "msie"){
					$("#p"+i+"_image").replaceWith($("#p"+i+"_image").val().clone(true));
					$("#p"+i+"_pdf").replaceWith($("#p"+i+"_pdf").val().clone(true));
				}else{
					$("#p"+i+"_image").val("");
					$("#p"+i+"_pdf").val("")
				}				
				
				$("#p"+i).remove();
			}			
		}else if (oldcnt < newcnt){
			for(var i=oldcnt+1; i <= newcnt; i++ ){
				var innerHtml = "<div id='p"+ i +"'>";
				innerHtml +=" <div class='row form-group'>";
				innerHtml +=" <label class='col-xs-2 control-label' for='p"+ i +"_image'>"+ i +"면 이미지</label>";
				innerHtml +=" <div class='col-xs-6'>";
				innerHtml +="	<input class='file' id='p"+ i +"_image' name='p"+ i +"_image' type='file' data-preview-file-type='text' accept='.jpg, .jpeg, .gif, .png, .bmp'  />";
				innerHtml +="	<input type='hidden' name='p"+ i +"_imageurl' id='p"+ i +"_imageurl' />";
				innerHtml +="	<input type='hidden' name='p"+ i +"_imagename' id='p"+ i +"_imagename' />";
				innerHtml +="	<input type='hidden' name='p"+ i +"_imagesize' id='p"+ i +"_imagesize' />";
				innerHtml +="	<input type='hidden' name='p"+ i +"_images3filename' id='p"+ i +"_images3filename' />";
				innerHtml +=" </div>";
				innerHtml +=" <div class='col-xs-4'></div>";
				innerHtml +=" </div>";
				innerHtml +=" <div class='row form-group'>";
				innerHtml +=" <label class='col-xs-2 control-label' for='p"+ i +"_pdf'>"+ i +"면 PDF</label>";
				innerHtml +=" <div class='col-xs-6'>";
				innerHtml +=" <input class='file' id='p"+ i +"_pdf' name='p"+ i +"_pdf' type='file' data-preview-file-type='text' accept='.pdf' />";
				innerHtml +="	<input type='hidden' name='p"+ i +"_pdfurl' id='p"+ i +"_pdfurl' />";
				innerHtml +="	<input type='hidden' name='p"+ i +"_pdfname' id='p"+ i +"_pdfname'/>";
				innerHtml +="	<input type='hidden' name='p"+ i +"_pdfsize' id='p"+ i +"_pdfsize' />";
				innerHtml +="	<input type='hidden' name='p"+ i +"_pdfs3filename' id='p"+ i +"_pdfs3filename' />";
				innerHtml +=" </div>";
				innerHtml +=" <div class='col-xs-4'></div>";
				innerHtml +=" </div>";
				innerHtml +=" </div>"; 
				
				parent.append(innerHtml);
				$("#p"+ i +"_image").fileinput();				
				$("#p"+ i +"_pdf").fileinput();
			}
		}
		return newcnt;
	},
	
	/*
	//clear 버튼 필요시 사용
	changeFileCntPamphlet : function(parent, oldcnt, newcnt){
		if (oldcnt > newcnt){
			for(var i=oldcnt; i > newcnt; i--){
				if(browser.name == "msie"){
					$("#p"+i+"_image").replaceWith($("#p"+i+"_image").val().clone(true));
					$("#p"+i+"_pdf").replaceWith($("#p"+i+"_pdf").val().clone(true));
				}else{
					$("#p"+i+"_image").val("");
					$("#p"+i+"_pdf").val("")
				}				
				
				$("#p"+i).remove();
			}			
		}else if (oldcnt < newcnt){
			for(var i=oldcnt+1; i <= newcnt; i++ ){
				var innerHtml = "<div id='p"+ i +"'>";
				innerHtml +=" <div class='row form-group'>";
				innerHtml +=" <label class='col-xs-2 control-label' for='p"+ i +"_image'>"+ i +"면 이미지</label>";
				innerHtml +=" <div class='col-xs-6'>";
				innerHtml +="	<input class='file' id='p"+ i +"_image' name='p"+ i +"_image' type='file' data-preview-file-type='text' accept='.jpg, .jpeg, .gif, .png, .bmp'  />";
				innerHtml +="	<input type='hidden' name='p"+ i +"_imageurl' id='p"+ i +"_imageurl' />";
				innerHtml +="	<input type='hidden' name='p"+ i +"_imagename' id='p"+ i +"_imagename' />";
				innerHtml +="	<input type='hidden' name='p"+ i +"_imagesize' id='p"+ i +"_imagesize' />";
				innerHtml +="	<input type='hidden' name='p"+ i +"_images3filename' id='p"+ i +"_images3filename' />";
				innerHtml +=" </div>";
				innerHtml +=" <div class='col-xs-1 text-left'><button id='p"+ i +"_imagedelbtn' type='button' class='btn btn-xs btn-danger glyphicon glyphicon-minus' seq='"+i+"'></div>";
				innerHtml +=" <div class='col-xs-3'></div>";
				innerHtml +=" </div>";
				innerHtml +=" <div class='row form-group'>";
				innerHtml +=" <label class='col-xs-2 control-label' for='p"+ i +"_pdf'>"+ i +"면 PDF</label>";
				innerHtml +=" <div class='col-xs-6'>";
				innerHtml +=" <input class='file' id='p"+ i +"_pdf' name='p"+ i +"_pdf' type='file' data-preview-file-type='text' accept='.pdf' />";
				innerHtml +="	<input type='hidden' name='p"+ i +"_pdfurl' id='p"+ i +"_pdfurl' />";
				innerHtml +="	<input type='hidden' name='p"+ i +"_pdfname' id='p"+ i +"_pdfname'/>";
				innerHtml +="	<input type='hidden' name='p"+ i +"_pdfsize' id='p"+ i +"_pdfsize' />";
				innerHtml +="	<input type='hidden' name='p"+ i +"_pdfs3filename' id='p"+ i +"_pdfs3filename' />";
				innerHtml +=" </div>";
				innerHtml +=" <div class='col-xs-1 text-left'><button id='p"+ i +"_pdfdelbtn' type='button' class='btn btn-xs btn-danger glyphicon glyphicon-minus' seq='"+i+"'></div>";
				innerHtml +=" <div class='col-xs-3'></div>";
				innerHtml +=" </div>";
				innerHtml +=" </div>"; 
				
				parent.append(innerHtml);
				$("#p"+ i +"_image").fileinput();
				$("#p"+ i +"_imagedelbtn").click(function(){
					$("#p"+ $(this).attr('seq') +"_image").fileinput('clear');
					$("#p"+ $(this).attr('seq') +"_imageurl").val('');
					$("#p"+ $(this).attr('seq') +"_imagename").val('');
					$("#p"+ $(this).attr('seq') +"_imagesize").val('');
					$("#p"+ $(this).attr('seq') +"_images3filename").val('');
					$(this).hide();
				});
				$("#p"+ i +"_image").on('fileloaded', function(event, file, previewId, index, reader) {
					$("#"+ event.target.id +"delbtn").show();
			    });
				$("#p"+ i +"_imagedelbtn").hide();
				
				$("#p"+ i +"_pdf").fileinput();
				$("#p"+ i +"_pdfdelbtn").click(function(){
					$("#p"+ $(this).attr('seq') +"_pdf").fileinput('clear');
					$("#p"+ $(this).attr('seq') +"_pdfurl").val('');
					$("#p"+ $(this).attr('seq') +"_pdfname").val('');
					$("#p"+ $(this).attr('seq') +"_pdfsize").val('');
					$("#p"+ $(this).attr('seq') +"_pdfs3filename").val('');
					$(this).hide();
				});
				$("#p"+ i +"_pdf").on('fileloaded', function(event, file, previewId, index, reader) {
					$("#"+ event.target.id +"delbtn").show();
			    });
				$("#p"+ i +"_pdfdelbtn").hide();
			}
		}
		return newcnt;
	},
	*/
	
	//최초 조회 시 첨부파일 있을 경우는 이 함수를 태운다.	
	changeFileCntPamphletForAttachFile : function(parent, oldcnt, newcnt, imageList, pdfList){
		if (oldcnt > newcnt){
			for(var i=oldcnt; i > newcnt; i--){
				if(browser.name == "msie"){
					$("#p"+i+"_image").replaceWith($("#p"+i+"_image").val().clone(true));
					$("#p"+i+"_pdf").replaceWith($("#p"+i+"_pdf").val().clone(true));
				}else{
					$("#p"+i+"_image").val("");
					$("#p"+i+"_pdf").val("")
				}				
				
				$("#p"+i).remove();
			}			
		}else if (oldcnt < newcnt){
			for(var i=oldcnt+1; i <= newcnt; i++ ){
				var innerHtml = "<div id='p"+ i +"'>";
				innerHtml +=" <div class='row form-group'>";
				innerHtml +=" <label class='col-xs-2 control-label' for='p"+ i +"_image'>"+ i +"면 이미지</label>";
				innerHtml +=" <div class='col-xs-6'>";
				innerHtml +="	<input class='file' id='p"+ i +"_image' name='p"+ i +"_image' type='file' data-preview-file-type='text' accept='.jpg, .jpeg, .gif, .png, .bmp' />";
				innerHtml +="	<input type='hidden' name='p"+ i +"_imageurl' id='p"+ i +"_imageurl' value='"+imageList[i-1].get('url')+"'/>";
				innerHtml +="	<input type='hidden' name='p"+ i +"_imagename' id='p"+ i +"_imagename' value='"+imageList[i-1].get('file_name')+"'/>";
				innerHtml +="	<input type='hidden' name='p"+ i +"_imagesize' id='p"+ i +"_imagesize' value='"+imageList[i-1].get('file_size')+"'/>";
				innerHtml +="	<input type='hidden' name='p"+ i +"_images3filename' id='p"+ i +"_images3filename' value='"+imageList[i-1].get('s3_file_name')+"'/>";
				innerHtml +=" </div>";				
				innerHtml +=" <div class='col-xs-4'></div>";
				innerHtml +=" </div>";
				innerHtml +=" <div class='row form-group'>";
				innerHtml +=" <label class='col-xs-2 control-label' for='p"+ i +"_pdf'>"+ i +"면 PDF</label>";
				innerHtml +=" <div class='col-xs-6'>";
				innerHtml +="   <input class='file' id='p"+ i +"_pdf' name='p"+ i +"_pdf' type='file' data-preview-file-type='text' accept='.pdf' />";
				innerHtml +="	<input type='hidden' name='p"+ i +"_pdfurl' id='p"+ i +"_pdfurl' value='"+pdfList[i-1].get('url')+"' />";
				innerHtml +="	<input type='hidden' name='p"+ i +"_pdfname' id='p"+ i +"_pdfname' value='"+pdfList[i-1].get('file_name')+"'/>";
				innerHtml +="	<input type='hidden' name='p"+ i +"_pdfsize' id='p"+ i +"_pdfsize' value='"+pdfList[i-1].get('file_size')+"' />";
				innerHtml +="	<input type='hidden' name='p"+ i +"_pdfs3filename' id='p"+ i +"_pdfs3filename' value='"+pdfList[i-1].get('s3_file_name')+"'/>";
				innerHtml +=" </div>";
				innerHtml +=" <div class='col-xs-4'></div>";
				innerHtml +=" </div>";
				innerHtml +=" </div>"; 
				
				parent.append(innerHtml);
				$("#p"+ i +"_image").fileinput({initialCaption:imageList[i-1].get('file_name')});				
				$("#p"+ i +"_pdf").fileinput({initialCaption:pdfList[i-1].get('file_name')});
			}
		}
		return newcnt;
	},
	
	/*
	 * clear버튼 필요시 사용
	//최초 조회 시 첨부파일 있을 경우는 이 함수를 태운다.	
	changeFileCntPamphletForAttachFile : function(parent, oldcnt, newcnt, imageList, pdfList){
		if (oldcnt > newcnt){
			for(var i=oldcnt; i > newcnt; i--){
				if(browser.name == "msie"){
					$("#p"+i+"_image").replaceWith($("#p"+i+"_image").val().clone(true));
					$("#p"+i+"_pdf").replaceWith($("#p"+i+"_pdf").val().clone(true));
				}else{
					$("#p"+i+"_image").val("");
					$("#p"+i+"_pdf").val("")
				}				
				
				$("#p"+i).remove();
			}			
		}else if (oldcnt < newcnt){
			for(var i=oldcnt+1; i <= newcnt; i++ ){
				var innerHtml = "<div id='p"+ i +"'>";
				innerHtml +=" <div class='row form-group'>";
				innerHtml +=" <label class='col-xs-2 control-label' for='p"+ i +"_image'>"+ i +"면 이미지</label>";
				innerHtml +=" <div class='col-xs-6'>";
				innerHtml +="	<input class='file' id='p"+ i +"_image' name='p"+ i +"_image' type='file' data-preview-file-type='text' accept='.jpg, .jpeg, .gif, .png, .bmp' />";
				innerHtml +="	<input type='hidden' name='p"+ i +"_imageurl' id='p"+ i +"_imageurl' value='"+imageList[i-1].get('url')+"'/>";
				innerHtml +="	<input type='hidden' name='p"+ i +"_imagename' id='p"+ i +"_imagename' value='"+imageList[i-1].get('file_name')+"'/>";
				innerHtml +="	<input type='hidden' name='p"+ i +"_imagesize' id='p"+ i +"_imagesize' value='"+imageList[i-1].get('file_size')+"'/>";
				innerHtml +="	<input type='hidden' name='p"+ i +"_images3filename' id='p"+ i +"_images3filename' value='"+imageList[i-1].get('s3_file_name')+"'/>";
				innerHtml +=" </div>";				
				innerHtml +=" <div class='col-xs-1'><button id='p"+ i +"_imagedelbtn' type='button' class='btn btn-xs btn-danger glyphicon glyphicon-minus' seq='"+i+"'></div>";
				innerHtml +=" <div class='col-xs-3'></div>";
				innerHtml +=" </div>";
				innerHtml +=" <div class='row form-group'>";
				innerHtml +=" <label class='col-xs-2 control-label' for='p"+ i +"_pdf'>"+ i +"면 PDF</label>";
				innerHtml +=" <div class='col-xs-6'>";
				innerHtml +="   <input class='file' id='p"+ i +"_pdf' name='p"+ i +"_pdf' type='file' data-preview-file-type='text' accept='.pdf' />";
				innerHtml +="	<input type='hidden' name='p"+ i +"_pdfurl' id='p"+ i +"_pdfurl' value='"+pdfList[i-1].get('url')+"' />";
				innerHtml +="	<input type='hidden' name='p"+ i +"_pdfname' id='p"+ i +"_pdfname' value='"+pdfList[i-1].get('file_name')+"'/>";
				innerHtml +="	<input type='hidden' name='p"+ i +"_pdfsize' id='p"+ i +"_pdfsize' value='"+pdfList[i-1].get('file_size')+"' />";
				innerHtml +="	<input type='hidden' name='p"+ i +"_pdfs3filename' id='p"+ i +"_pdfs3filename' value='"+pdfList[i-1].get('s3_file_name')+"'/>";
				innerHtml +=" </div>";
				innerHtml +=" <div class='col-xs-1 text-left'><button id='p"+ i +"_pdfdelbtn' type='button' class='btn btn-xs btn-danger glyphicon glyphicon-minus'  seq='"+i+"'></button></div>";
				innerHtml +=" <div class='col-xs-3'></div>";
				innerHtml +=" </div>";
				innerHtml +=" </div>"; 
				
				parent.append(innerHtml);
				$("#p"+ i +"_image").fileinput({initialCaption:imageList[i-1].get('file_name')});
				$("#p"+ i +"_imagedelbtn").click(function(){
					$("#p"+ $(this).attr('seq') +"_image").fileinput('clear');
					$("#p"+ $(this).attr('seq') +"_imageurl").val('');
					$("#p"+ $(this).attr('seq') +"_imagename").val('');
					$("#p"+ $(this).attr('seq') +"_imagesize").val('');
					$("#p"+ $(this).attr('seq') +"_images3filename").val('');
					//왠지 $(this).attr('seq') 대신 i 를 하면 될거 같은데, 안된다..
					//callback method라 그런건지 loop 다 돈후의 값이 i에 박힌다..
					$(this).hide();
				});
				$("#p"+ i +"_image").on('fileloaded', function(event, file, previewId, index, reader) {
					$("#"+ event.target.id +"delbtn").show();
			    });
				if(imageList[i-1].get('file_name') == "") $("#p"+ i +"_imagedelbtn").hide();
				
				$("#p"+ i +"_pdf").fileinput({initialCaption:pdfList[i-1].get('file_name')});
				$("#p"+ i +"_pdfdelbtn").click(function(){
					$("#p"+ $(this).attr('seq') +"_pdf").fileinput('clear');
					$("#p"+ $(this).attr('seq') +"_pdfurl").val('');
					$("#p"+ $(this).attr('seq') +"_pdfname").val('');
					$("#p"+ $(this).attr('seq') +"_pdfsize").val('');
					$("#p"+ $(this).attr('seq') +"_pdfs3filename").val('');
					$(this).hide();
				});
				$("#p"+ i +"_pdf").on('fileloaded', function(event, file, previewId, index, reader) {
					$("#"+ event.target.id +"delbtn").show();
			    });
				if(pdfList[i-1].get('file_name') == "") $("#p"+ i +"_pdfdelbtn").hide();
			}
		}
		return newcnt;
	},
	*/
	
	changeFileCntProducts : function(parent, oldcnt, newcnt){
		if (oldcnt > newcnt){
			for(var i=oldcnt; i > newcnt; i--){
				if(browser.name == "msie"){
					$("#p"+i+"_image").replaceWith($("#p"+i+"_image").val().clone(true));
				}else{
					$("#p"+i+"_image").val("");
				}				
				
				$("#p"+i).remove();
			}			
		}else if (oldcnt < newcnt){
			for(var i=oldcnt+1; i <= newcnt; i++ ){
				var innerHtml = "<div id='p"+ i +"'>";
				innerHtml +=" <div class='row form-group'>";
				if(i==1){
					innerHtml +=" <label class='col-xs-2 control-label' for='p"+ i +"_image'>이미지</label>";
				}else{
					innerHtml +=" <div class='col-xs-2'></div>";
				}
				innerHtml +=" <div class='col-xs-6'>";
				innerHtml +="	<input class='file' id='p"+ i +"_image' name='p"+ i +"_image' type='file' data-preview-file-type='text' accept='.jpg, .jpeg, .gif, .png, .bmp' />";
				innerHtml +="	<input type='hidden' name='p"+ i +"_imageurl' id='p"+ i +"_imageurl' />";
				innerHtml +="	<input type='hidden' name='p"+ i +"_imagename' id='p"+ i +"_imagename' />";
				innerHtml +="	<input type='hidden' name='p"+ i +"_imagesize' id='p"+ i +"_imagesize' />";
				innerHtml +="	<input type='hidden' name='p"+ i +"_images3filename' id='p"+ i +"_images3filename' />";
				innerHtml +=" </div>";
				innerHtml +=" <div class='col-xs-4'></div>";
				innerHtml +=" </div>";
				innerHtml +=" </div>"; 
				
				parent.append(innerHtml);
				$("#p"+ i +"_image").fileinput();
			}
		}
		return newcnt;
	},
	/*
	//clear버튼 필요시 사용
	changeFileCntProducts : function(parent, oldcnt, newcnt){
		if (oldcnt > newcnt){
			for(var i=oldcnt; i > newcnt; i--){
				if(browser.name == "msie"){
					$("#p"+i+"_image").replaceWith($("#p"+i+"_image").val().clone(true));
				}else{
					$("#p"+i+"_image").val("");
				}				
				
				$("#p"+i).remove();
			}			
		}else if (oldcnt < newcnt){
			for(var i=oldcnt+1; i <= newcnt; i++ ){
				var innerHtml = "<div id='p"+ i +"'>";
				innerHtml +=" <div class='row form-group'>";
				if(i==1){
					innerHtml +=" <label class='col-xs-2 control-label' for='p"+ i +"_image'>이미지</label>";
				}else{
					innerHtml +=" <div class='col-xs-2'></div>";
				}
				innerHtml +=" <div class='col-xs-6'>";
				innerHtml +="	<input class='file' id='p"+ i +"_image' name='p"+ i +"_image' type='file' data-preview-file-type='text' accept='.jpg, .jpeg, .gif, .png, .bmp' />";
				innerHtml +="	<input type='hidden' name='p"+ i +"_imageurl' id='p"+ i +"_imageurl' />";
				innerHtml +="	<input type='hidden' name='p"+ i +"_imagename' id='p"+ i +"_imagename' />";
				innerHtml +="	<input type='hidden' name='p"+ i +"_imagesize' id='p"+ i +"_imagesize' />";
				innerHtml +="	<input type='hidden' name='p"+ i +"_images3filename' id='p"+ i +"_images3filename' />";
				innerHtml +=" </div>";
				innerHtml +=" <div class='col-xs-1 text-left'><button id='p"+ i +"_imagedelbtn' type='button' class='btn btn-xs btn-danger glyphicon glyphicon-minus' seq='"+i+"'></div>";
				innerHtml +=" <div class='col-xs-3'></div>";
				innerHtml +=" </div>";
				innerHtml +=" </div>"; 
				
				parent.append(innerHtml);
				$("#p"+ i +"_image").fileinput();
				$("#p"+ i +"_imagedelbtn").click(function(){
					$("#p"+ $(this).attr('seq') +"_image").fileinput('clear');
					$("#p"+ $(this).attr('seq') +"_imageurl").val('');
					$("#p"+ $(this).attr('seq') +"_imagename").val('');
					$("#p"+ $(this).attr('seq') +"_imagesize").val('');
					$("#p"+ $(this).attr('seq') +"_images3filename").val('');
					$(this).hide();
				});
				$("#p"+ i +"_image").on('fileloaded', function(event, file, previewId, index, reader) {
					$("#"+ event.target.id +"delbtn").show();
			    });
				$("#p"+ i +"_imagedelbtn").hide();
			}
		}
		return newcnt;
	},
	*/
	
	//최초 조회 시 첨부파일 있을 경우는 이 함수를 태운다.	
	changeFileCntProductsForAttachFile : function(parent, oldcnt, newcnt, imageList){
		if (oldcnt > newcnt){
			for(var i=oldcnt; i > newcnt; i--){
				if(browser.name == "msie"){
					$("#p"+i+"_image").replaceWith($("#p"+i+"_image").val().clone(true));
				}else{
					$("#p"+i+"_image").val("");
				}				
				
				$("#p"+i).remove();
			}			
		}else if (oldcnt < newcnt){
			for(var i=oldcnt+1; i <= newcnt; i++ ){
				var innerHtml = "<div id='p"+ i +"'>";
				innerHtml +=" <div class='row form-group'>";
				if(i==1){
					innerHtml +=" <label class='col-xs-2 control-label' for='p"+ i +"_image'>이미지</label>";
				}else{
					innerHtml +=" <div class='col-xs-2'></div>";
				}
				innerHtml +=" <div class='col-xs-6'>";
				innerHtml +="	<input class='file' id='p"+ i +"_image' name='p"+ i +"_image' type='file' data-preview-file-type='text' accept='.jpg, .jpeg, .gif, .png, .bmp' />";
				innerHtml +="	<input type='hidden' name='p"+ i +"_imageurl' id='p"+ i +"_imageurl' value='"+imageList[i-1].get('url')+"'/>";
				innerHtml +="	<input type='hidden' name='p"+ i +"_imagename' id='p"+ i +"_imagename' value='"+imageList[i-1].get('file_name')+"'/>";
				innerHtml +="	<input type='hidden' name='p"+ i +"_imagesize' id='p"+ i +"_imagesize' value='"+imageList[i-1].get('file_size')+"'/>";
				innerHtml +="	<input type='hidden' name='p"+ i +"_images3filename' id='p"+ i +"_images3filename' value='"+imageList[i-1].get('s3_file_name')+"'/>";
				innerHtml +=" </div>";				
				innerHtml +=" <div class='col-xs-4'></div>";
				innerHtml +=" </div>";
				innerHtml +=" </div>"; 
				
				parent.append(innerHtml);
				$("#p"+ i +"_image").fileinput({initialCaption:imageList[i-1].get('file_name')});
			}
		}
		return newcnt;
	},
	/*
	 * clear버튼(-) 필요시 사용
	//최초 조회 시 첨부파일 있을 경우는 이 함수를 태운다.	
	changeFileCntProductsForAttachFile : function(parent, oldcnt, newcnt, imageList){
		if (oldcnt > newcnt){
			for(var i=oldcnt; i > newcnt; i--){
				if(browser.name == "msie"){
					$("#p"+i+"_image").replaceWith($("#p"+i+"_image").val().clone(true));
				}else{
					$("#p"+i+"_image").val("");
				}				
				
				$("#p"+i).remove();
			}			
		}else if (oldcnt < newcnt){
			for(var i=oldcnt+1; i <= newcnt; i++ ){
				var innerHtml = "<div id='p"+ i +"'>";
				innerHtml +=" <div class='row form-group'>";
				if(i==1){
					innerHtml +=" <label class='col-xs-2 control-label' for='p"+ i +"_image'>이미지</label>";
				}else{
					innerHtml +=" <div class='col-xs-2'></div>";
				}
				innerHtml +=" <div class='col-xs-6'>";
				innerHtml +="	<input class='file' id='p"+ i +"_image' name='p"+ i +"_image' type='file' data-preview-file-type='text' accept='.jpg, .jpeg, .gif, .png, .bmp' />";
				innerHtml +="	<input type='hidden' name='p"+ i +"_imageurl' id='p"+ i +"_imageurl' value='"+imageList[i-1].get('url')+"'/>";
				innerHtml +="	<input type='hidden' name='p"+ i +"_imagename' id='p"+ i +"_imagename' value='"+imageList[i-1].get('file_name')+"'/>";
				innerHtml +="	<input type='hidden' name='p"+ i +"_imagesize' id='p"+ i +"_imagesize' value='"+imageList[i-1].get('file_size')+"'/>";
				innerHtml +="	<input type='hidden' name='p"+ i +"_images3filename' id='p"+ i +"_images3filename' value='"+imageList[i-1].get('s3_file_name')+"'/>";
				innerHtml +=" </div>";				
				innerHtml +=" <div class='col-xs-1'><button id='p"+ i +"_imagedelbtn' type='button' class='btn btn-xs btn-danger glyphicon glyphicon-minus' seq='"+i+"'></div>";
				innerHtml +=" <div class='col-xs-3'></div>";
				innerHtml +=" </div>";
				innerHtml +=" </div>"; 
				
				parent.append(innerHtml);
				$("#p"+ i +"_image").fileinput({initialCaption:imageList[i-1].get('file_name')});
				$("#p"+ i +"_imagedelbtn").click(function(){
					$("#p"+ $(this).attr('seq') +"_image").fileinput('clear');
					$("#p"+ $(this).attr('seq') +"_imageurl").val('');
					$("#p"+ $(this).attr('seq') +"_imagename").val('');
					$("#p"+ $(this).attr('seq') +"_imagesize").val('');
					$("#p"+ $(this).attr('seq') +"_images3filename").val('');
					//왠지 $(this).attr('seq') 대신 i 를 하면 될거 같은데, 안된다..
					//callback method라 그런건지 loop 다 돈후의 값이 i에 박힌다..
					$(this).hide();
				});
				$("#p"+ i +"_image").on('fileloaded', function(event, file, previewId, index, reader) {
					$("#"+ event.target.id +"delbtn").show();
			    });
				if(imageList[i-1].get('file_name') == "") $("#p"+ i +"_imagedelbtn").hide();
			}
		}
		return newcnt;
	},
	*/
	//save dialog
	saveTotalcnt : 0,
	saveCompletecnt : 0,
	saveRefreshDialog : function(cnt){
		this.saveCompletecnt = cnt;
		var value = this.saveCompletecnt == 0 ? 0 : parseInt((this.saveCompletecnt / (this.saveTotalcnt + 1)) * 100);
		console.log(cnt +" : "+ value);
		$("#saveprogress").css("width", value+"%").attr("aria-valuenow", value);
		if (this.saveTotalcnt  > this.saveCompletecnt) {
			$("#saveprogress").html(value+"%");
			$("#modal-cmpcnt").html(this.saveCompletecnt +"/" + this.saveTotalcnt);
		}else{
			$("#saveprogress").html(value+"%");
			$("#modal-msg").html("서버 정보 저장 중...")
		}
	},
	
	saveHideDialog : function(){
		if ( $("#saveModal").length > 0 ) $("#saveModal").remove();
	},
	
	saveShowDialog : function(totcnt){
		this.saveHideDialog();
		this.saveTotalcnt = totcnt;
		
		var innerHtml = " <div class='modal fade' id='saveModal' role='dialog'>";
		innerHtml +="  <div class='modal-dialog'>";
		innerHtml +="   <div class='modal-content'>";
		innerHtml +="    <div class='modal-body'>";
		innerHtml +="     <p id='modal-msg'> 파일업로드 <strong id='modal-cmpcnt'>"+this.saveCompletecnt+"/"+this.saveTotalcnt+"</strong> 전송 중...</p>";
		innerHtml +="     <div class='progress'>";
		innerHtml +="      <div id='saveprogress' class='progress-bar progress-bar-striped active' role='progressbar'";
		innerHtml +="        aria-valuenow='0' aria-valuemin='0' aria-valuemax='100' style='width:0%'>";
		innerHtml +="      0%";
		innerHtml +="      </div>";
		innerHtml +="     </div>";
		innerHtml +="    </div>";
		innerHtml +="   </div>";
		innerHtml +="  </div>";
		innerHtml +=" </div>";			
		
		$("body").append(innerHtml);
		$("#saveModal").modal();
	}
};

//첨부파일 Entity
var attachFile = function(){
	this.seqno = 0;
	this.file = null;
	this.filename = null;
	this.filetype = null;
	this.filesize = 0;
	this.filenewname = null;
	this.s3url = null;
	this.filecategory = null; //전단인지 상품인지에 따라 버킷이 달라져.
	this.applyflag = "N"; //N:신규입력, E:오류
	this.bucketfolder = null;
}
attachFile.prototype = {
	getSeqno: function(){return this.seqno;},
	setSeqno: function(no){this.seqno = no;},
	
	getFile: function() {return this.file;},
	setFile: function(f, ctg){		
		this.file = f;
		this.filename = this.file.name;
		this.filetype = this.file.type;
		this.filesize = this.file.size;
		this.filenewname = imgfileoprn.changeFileName(this.filename);
		this.filecategory = ctg;
		if (ctg =="PP") this.bucketfolder = awssetup.s3bucketpamphlet;
		else this.bucketfolder = awssetup.s3bucketproduct;
		this.s3url = awssetup.s3url(this.filenewname, this.filecategory);
	},
	
	getFilename: function(){return this.filename;},
	getFiletype: function(){return this.filetype;},
	getFilesize: function(){return this.filesize;},
	
	getFilenewname: function(){return this.filenewname;},
	setFilenewname: function(newname){this.filenewname = newname;},
	
	getS3url: function(){return this.s3url;},
	setS3url: function(url){this.s3url = url;},
	
	getApplyflag: function(){return this.applyflag;},
	setApplyflag: function(flag){this.applyflag = flag;},
	
	getBucketfolder: function(){return this.bucketfolder;},
	setBucketfolder: function(folder){this.bucketfolder = folder;}
}

//출처 http://blog.jqdom.com/?p=737 
/* HashMap 객체 생성 */
var megaMap = function(){
    this.map = new Object();
}
 
megaMap.prototype = {
    /* key, value 값으로 구성된 데이터를 추가 */
    put: function (key, value) {
        this.map[key] = value;
    },
    /* 지정한 key값의 value값 반환 */
    get: function (key) {
        return this.map[key];
    },
    /* 구성된 key 값 존재여부 반환 */
    containsKey: function (key) {
        return key in this.map;
    },
    /* 구성된 value 값 존재여부 반환 */
    containsValue: function (value) {
        for (var prop in this.map) {
            if (this.map[prop] == value) {
                return true;
            }
        }
        return false;
    },
    /* 구성된 데이터 초기화 */
    clear: function () {
        for (var prop in this.map) {
            delete this.map[prop];
        }
    },
    /*  key에 해당하는 데이터 삭제 */
    remove: function (key) {
        delete this.map[key];
    },
    /* 배열로 key 반환 */
    keys: function () {
        var arKey = new Array();
        for (var prop in this.map) {
            arKey.push(prop);
        }
        return arKey;
    },
    /* 배열로 value 반환 */
    values: function () {
        var arVal = new Array();
        for (var prop in this.map) {
            arVal.push(this.map[prop]);
        }
        return arVal;
    },
    /* Map에 구성된 개수 반환 */
    size: function () {
        var count = 0;
        for (var prop in this.map) {
            count++;
        }
        return count;
    }
}

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
