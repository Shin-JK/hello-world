package com.megamart.pamphlet.controller;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.megamart.common.entity.AttachFileEntity;
import com.megamart.common.entity.PageEntity;
import com.megamart.common.entity.TagEntity;
import com.megamart.common.service.FileService;
import com.megamart.common.service.LoginService;
import com.megamart.common.service.TagService;
import com.megamart.pamphlet.entity.PamphletEntity;
import com.megamart.pamphlet.service.PamphletService;

@Controller
public class PamphletController {
	Logger log = Logger.getLogger(this.getClass());

	@Resource(name = "pamphletService")
	private PamphletService service;
	
	@Resource(name="fileService")
	private FileService fileservice;
	
	@Resource(name="tagService")
	private TagService tagservice;
	
	@RequestMapping(value = "/pamphlet/pamphletlist.do")
	private ModelAndView listPamphlet(HttpServletRequest request,
			HttpServletResponse response){
		//ModelAndView mv = new ModelAndView("/pamphlet/pamphletlist");
		ModelAndView mv = new ModelAndView("tiles.pamphlet.list");
		
		String key = "title";
		String keyword = "%";
		int selectedpage = 1;
		int limitfrom = 0;
		int pagesize = 10;
		
		if (request.getParameter("key") != null && request.getParameter("key").length() != 0){
			key = request.getParameter("key");
		}
		
		if (request.getParameter("keyword") != null && request.getParameter("keyword").length() != 0){
			keyword = request.getParameter("keyword");
		}
		
		if (request.getParameter("pagesize") != null && request.getParameter("pagesize").length() != 0){
			pagesize = Integer.parseInt(request.getParameter("pagesize"));
		}
		
		if (request.getParameter("selectedpage") != null && request.getParameter("selectedpage").length() != 0){
			selectedpage = Integer.parseInt(request.getParameter("selectedpage"));
			limitfrom = (selectedpage - 1) * pagesize;
		}		
		
		int totalcount = service.selectPamphletTotalCnt(key, keyword);
		List<Map<String,Object>> list = service.selectPamphletList(key, keyword, limitfrom, pagesize);
		
		
		PageEntity page = new PageEntity();
		page.setPageNo(selectedpage);
		page.setPageSize(pagesize);
		page.setTotalCount(totalcount);
		page.makePaging();
		mv.addObject("key", key);
		mv.addObject("keyword", keyword.equals("%") ? "" : keyword);
		mv.addObject("page", page);
        mv.addObject("list", list);
        return mv;
	}
	
	@RequestMapping(value = "/pamphlet/pamphletview.do") //, method = RequestMethod.POST)
	private ModelAndView detailPamphlet(HttpServletRequest request,
			HttpServletResponse response){
		//ModelAndView mv = new ModelAndView("/pamphlet/pamphletview");
		ModelAndView mv = new ModelAndView("tiles.pamphlet.view");
		
		if (request.getParameter("idx") != null && request.getParameter("idx").length() != 0){
			int idx = Integer.parseInt(request.getParameter("idx"));
			PageEntity page = new PageEntity();
			page.setPageNo(Integer.parseInt(request.getParameter("selectedpage")));
			page.setPageSize(Integer.parseInt(request.getParameter("pagesize")));
			page.setTotalCount(Integer.parseInt(request.getParameter("totalcount")));
			page.makePaging();
			
			mv.addObject("page", page);
			mv.addObject("key", request.getParameter("key"));
			mv.addObject("keyword", request.getParameter("keyword"));
			mv.addObject("pamphlet", service.selectPamphletDetail(idx));
			//mv.addObject("tag", tagservice.selectTagList("PP", idx));
			mv.addObject("imagefile", fileservice.selectImageFileList("PP", idx));
			mv.addObject("pdffile", fileservice.selectPdfFileList("PP", idx));			
		}else{
			mv = this.listPamphlet(request, response);
		}
		return mv;
	}
	
	@RequestMapping(value = "/pamphlet/pamphletpopupview.do")
	private ModelAndView detailPopupPamphlet(HttpServletRequest request,
			HttpServletResponse response){
		ModelAndView mv = new ModelAndView();
		
		if (request.getParameter("idx") != null && request.getParameter("idx").length() != 0){
			int idx = Integer.parseInt(request.getParameter("idx"));
			mv.setViewName("/pamphlet/pamphletpopupview");
			mv.addObject("pamphlet", service.selectPamphletDetail(idx));
			mv.addObject("imagefile", fileservice.selectImageFileList("PP", idx));
			mv.addObject("pdffile", fileservice.selectPdfFileList("PP", idx));			
		}
		return mv;
	}
	
	@RequestMapping(value = "/pamphlet/pamphletwrite.do")
	private ModelAndView writePamphlet(HttpServletRequest request) {
		//ModelAndView mv = new ModelAndView("/pamphlet/pamphletwrite");
		ModelAndView mv = new ModelAndView("tiles.pamphlet.write");
		
		//수정, 복사
		if (request.getParameter("idx") != null && request.getParameter("idx").length() != 0){
			int idx = Integer.parseInt(request.getParameter("idx"));
			PamphletEntity pamphlet = service.selectPamphletDetail(idx);
			if (request.getParameter("copyflag") != null && request.getParameter("copyflag").length() != 0 && request.getParameter("copyflag").equals("Y")){
				mv.addObject("idx", 0);
				mv.addObject("title", "");
				//pamphlet.setIdx(0);
				//pamphlet.setTitle("");
				mv.addObject("irud", "NEW");
			}else{
				mv.addObject("idx", pamphlet.getIdx());
				mv.addObject("title", pamphlet.getTitle());
				mv.addObject("irud", "UPDATE");
			}
			
			mv.addObject("store", pamphlet.getStore());
			mv.addObject("reg_date", pamphlet.getReg_date());
			mv.addObject("tag", pamphlet.getTag());
			mv.addObject("page_size", pamphlet.getPage_size());
			mv.addObject("page_count", pamphlet.getPage_count());
			mv.addObject("usage_flag", pamphlet.getUsage_flag());
			
			mv.addObject("imagefile", this.modifiedAttachFileList(fileservice.selectImageFileList("PP", idx), Integer.parseInt(pamphlet.getPage_count())));
			mv.addObject("pdffile", this.modifiedAttachFileList(fileservice.selectPdfFileList("PP", idx), Integer.parseInt(pamphlet.getPage_count())));
		}else{
			//신규
			//신규일때는 오늘날짜 뿌려준다.
			mv.addObject("irud", "NEW");
			mv.addObject("idx", 0);
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd", Locale.KOREA);
			Date current = new Date();
			mv.addObject("reg_date", formatter.format(current));
			mv.addObject("page_size", 2);
			mv.addObject("page_count", 2);
			mv.addObject("usage_flag", "Y");
		}	
		mv.addObject("storelist", service.selectAllStore());
		return mv;
	}

	@RequestMapping(value = "/pamphlet/pamphletsave.do") //, method = RequestMethod.POST)
	private void savePamphlet(HttpServletRequest request,
			HttpServletResponse response) {
		String IRUD_flag = request.getParameter("irud").toString();

		PamphletEntity pamphletentity = new PamphletEntity();
		pamphletentity.setIdx(Integer.parseInt(request.getParameter("idx")));
		pamphletentity.setTitle(request.getParameter("title").toString());
		pamphletentity.setReg_date(request.getParameter("reg_date").toString());
		pamphletentity.setStore(request.getParameter("store").toString());
		pamphletentity.setPage_size(request.getParameter("page_size").toString());
		pamphletentity.setPage_count(request.getParameter("page_count").toString());
		pamphletentity.setTag(request.getParameter("tags").toString());
		pamphletentity.setUsage_flag(request.getParameter("usage").toString());

		// String created_by = //세션에서 계정정보 가져다 입력해주자.
		if(request.getSession().getAttribute("empno") != null){
			pamphletentity.setCreated_by(request.getSession().getAttribute("empno").toString());
			pamphletentity.setLast_updated_by(request.getSession().getAttribute("empno").toString());
		}else{
			pamphletentity.setCreated_by(" ");
			pamphletentity.setLast_updated_by(" ");
		}
		String[] tags = pamphletentity.getTag().split(",");
		int tmpseq = 0;

		ArrayList<TagEntity> taglist = new ArrayList<TagEntity>();
		for (int i = 0; i < tags.length; i++) {
			if (tags[i].length() != 0 && tags[i] != null) {
				tmpseq += 1;
				TagEntity tmptag = new TagEntity();
				tmptag.setCategory_flag("PP");
				tmptag.setTag(tags[i].trim());
				tmptag.setTag_seq(tmpseq);
				taglist.add(tmptag);
			}
		}

		ArrayList<AttachFileEntity> filelist = new ArrayList<AttachFileEntity>();
		for (int i = 1; i <= Integer.parseInt(pamphletentity.getPage_count()); i++) {
			if (request.getParameter("p" + i + "_imagename") != null
					&& request.getParameter("p" + i + "_imagename").length() != 0) {
				AttachFileEntity tmpfileinfo = new AttachFileEntity();
				tmpfileinfo.setCategory_flag("PP");
				tmpfileinfo.setSeq(i);
				tmpfileinfo.setFile_name(request.getParameter("p" + i
						+ "_imagename"));
				tmpfileinfo.setFile_size(request.getParameter("p" + i
						+ "_imagesize"));
				tmpfileinfo.setUrl(request.getParameter("p" + i + "_imageurl"));
				tmpfileinfo.setS3_file_name(request.getParameter("p" + i + "_images3filename"));
				tmpfileinfo.setFile_type("IMAGE");

				filelist.add(tmpfileinfo);
			}

			if (request.getParameter("p" + i + "_pdfname") != null
					&& request.getParameter("p" + i + "_pdfname").length() != 0) {
				AttachFileEntity tmpfileinfo = new AttachFileEntity();
				tmpfileinfo.setCategory_flag("PP");
				tmpfileinfo.setSeq(i);
				tmpfileinfo.setFile_name(request.getParameter("p" + i
						+ "_pdfname"));
				tmpfileinfo.setFile_size(request.getParameter("p" + i
						+ "_pdfsize"));
				tmpfileinfo.setUrl(request.getParameter("p" + i + "_pdfurl"));
				tmpfileinfo.setS3_file_name(request.getParameter("p" + i + "_pdfs3filename"));
				tmpfileinfo.setFile_type("PDF");

				filelist.add(tmpfileinfo);
			}
		}

		int idx = service.savePamphlet(IRUD_flag, pamphletentity, taglist,
				filelist);

		try {
			if (idx > 0) response.getWriter().print("SUCCESS");
			else response.getWriter().print("ERROR");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	private List<Map<String, Object>> modifiedAttachFileList(List<Map<String, Object>> list, int requiredsize){
		List<Map<String, Object>> newList = new ArrayList<Map<String,Object>>();
		
		int tmpindex = 0;
		for(int i=0; i<list.size(); i++){
			int seq = Integer.parseInt(list.get(i).get("seq").toString());
			
			if(seq > i + 1){
				for(; tmpindex < seq - 1; tmpindex++){
					Map<String, Object> tmpmap = new HashMap<String, Object>();
					tmpmap.put("seq", tmpindex+1);
					tmpmap.put("file_name", "");
					tmpmap.put("file_size", 0);
					tmpmap.put("url", "#");
					tmpmap.put("file_type", "");
					tmpmap.put("s3_file_name", "");
					newList.add(tmpindex, tmpmap); 
				}					
				newList.add(tmpindex, list.get(i));
				tmpindex += 1;
			}else{
				newList.add(i, list.get(i));
				tmpindex += 1;
			}
		}
		
		for(; tmpindex <requiredsize; tmpindex++){
			Map<String, Object> tmpmap = new HashMap<String, Object>();
			tmpmap.put("seq", tmpindex+1);
			tmpmap.put("file_name", "");
			tmpmap.put("file_size", 0);
			tmpmap.put("url", "#");
			tmpmap.put("file_type", "");
			tmpmap.put("s3_file_name", "");
			newList.add(tmpindex, tmpmap);
		}			
		
		return newList;
	}
}
