package com.megamart.common.controller;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.megamart.common.entity.PageEntity;
import com.megamart.common.service.LoginService;
import com.megamart.common.service.SearchService;

@Controller
public class SearchController {
	@Resource(name = "searchService")
	private SearchService service;
	
	@RequestMapping(value = "/common/searchlist.do")
	public ModelAndView searchList(HttpServletRequest request,
			HttpServletResponse response){
		//ModelAndView mv = new ModelAndView("/common/searchlist");
		ModelAndView mv = new ModelAndView("tiles.common.searchlist"); //jsp 파일에서 tiles layout으로 view 변경.
		String keyword = null;
		if (request.getParameter("keyword") != null && request.getParameter("keyword").length() != 0){
			keyword = request.getParameter("keyword");
		}
		
		List<Map<String, Object>> list = service.selectPDCategoryList(keyword);
		mv.addObject("tablist", list);
		mv.addObject("keyword", keyword);
		
		return mv;
	}
		
	@RequestMapping(value = "/common/searchmovepage.do")
	public ModelAndView searchpamphlet(HttpServletRequest request,
			HttpServletResponse response){
		ModelAndView mv  = new ModelAndView();
		mv.setViewName("jsonView");
		
		String tabid = null;
		String type = null;
		String keyword = null;
		int selectedpage = 1; 
		
		int pagesize = 8;
		int limitfrom = 0;
		int totalcount = 0;
		
		List<Map<String, Object>> list = null;
		
		if (request.getParameter("tabid") != null && request.getParameter("tabid").length() != 0){
			tabid = request.getParameter("tabid");
		}
		
		if (request.getParameter("type") != null && request.getParameter("type").length() != 0){
			type = request.getParameter("type");
			pagesize = type.equals("IMAGE") ? 8 : 5; 
		}
		
		if (request.getParameter("selectedpage") != null && request.getParameter("selectedpage").length() != 0){
			selectedpage = Integer.parseInt(request.getParameter("selectedpage"));
			limitfrom = (selectedpage - 1) * pagesize;
		}
		
		if (request.getParameter("keyword") != null && request.getParameter("keyword").length() != 0){
			keyword = request.getParameter("keyword");
		}
		
		//service에서 Data를 가져온다.
		if(tabid.equals("PP")){
			if (type.equals("IMAGE")){
				totalcount = service.selectpamphletImageTotCnt(keyword);
				list = service.selectpamphletImageList(keyword, limitfrom, pagesize);
			}else{
				totalcount = service.selectpamphletTitleTotCnt(keyword);
				list = service.selectpamphletTitleList(keyword, limitfrom, pagesize);
			}
		}else{
			if (type.equals("IMAGE")){
				totalcount = service.selectproductsImageTotCnt(keyword, tabid);
				list = service.selectproductsImageList(keyword, tabid, limitfrom, pagesize);
			}else{
				totalcount = service.selectproductsSellingTotCnt(keyword, tabid);
				list = service.selectproductsSellingList(keyword, tabid, limitfrom, pagesize);
			}
		}
		
		PageEntity page = new PageEntity();
		page.setPageNo(selectedpage);
		page.setPageSize(pagesize);
		page.setTotalCount(totalcount);
		page.makePaging();
		
		mv.addObject("page",page);
		mv.addObject("list", list);
		mv.addObject("tabid", tabid);
		mv.addObject("type", type);
		return mv;
	}
}
