package com.megamart.products.controller;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
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
import org.springframework.web.servlet.ModelAndView;

import com.megamart.common.entity.AttachFileEntity;
import com.megamart.common.entity.PageEntity;
import com.megamart.common.entity.TagEntity;
import com.megamart.common.service.FileService;
import com.megamart.common.service.LoginService;
import com.megamart.common.service.TagService;
import com.megamart.products.entity.ProductsEntity;
import com.megamart.products.service.ProductsService;

@Controller
public class ProductsController {
	Logger log = Logger.getLogger(this.getClass());
	
	@Resource(name = "productsService")
	private ProductsService service;
	
	@Resource(name="fileService")
	private FileService fileservice;
	
	@Resource(name="tagService")
	private TagService tagservice;
	
	@RequestMapping(value = "/products/productslist.do")
	private ModelAndView listProducts(HttpServletRequest request,
			HttpServletResponse response){
		//ModelAndView mv = new ModelAndView("/products/productslist");
		ModelAndView mv = new ModelAndView("tiles.products.list");
		
		String key = "all";
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
		
		int totalcount = service.selectProductsTotalCnt(key, keyword);
		List<Map<String,Object>> list = service.selectProductsList(key, keyword, limitfrom, pagesize);
		
		log.debug("key : " + key);
		PageEntity page = new PageEntity();
		page.setPageNo(selectedpage);
		page.setPageSize(pagesize);
		page.setTotalCount(totalcount);
		page.makePaging();
		mv.addObject("key", key);
		mv.addObject("keyword",  keyword.equals("%") ? "" : keyword);
		mv.addObject("page", page);
        mv.addObject("list", list);
        return mv;
	}
	
	@RequestMapping(value = "/products/productsview.do") //, method = RequestMethod.POST)
	private ModelAndView detailProducts(HttpServletRequest request,
			HttpServletResponse response){
		//ModelAndView mv = new ModelAndView("/products/productsview");
		ModelAndView mv = new ModelAndView("tiles.products.view");
		
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
			mv.addObject("products", service.selectProductsDetail(idx));
			mv.addObject("imagefile", fileservice.selectImageFileList("PD", idx));
			//mv.addObject("pdffile", fileservice.selectPdfFileList("PD", idx));			
		}else{
			mv = this.listProducts(request, response);
		}
		return mv;
	}
	
	@RequestMapping(value = "/products/productspopupview.do")
	private ModelAndView detailPopupProducts(HttpServletRequest request,
			HttpServletResponse response){
		ModelAndView mv = new ModelAndView();
		
		if (request.getParameter("idx") != null && request.getParameter("idx").length() != 0){
			int idx = Integer.parseInt(request.getParameter("idx"));
			mv.setViewName("/products/productspopupview");
			mv.addObject("products", service.selectProductsDetail(idx));
			mv.addObject("imagefile", fileservice.selectImageFileList("PD", idx));
		}
		return mv;
	}
	
	@RequestMapping(value = "/products/productswrite.do")
	private ModelAndView writeProducts(HttpServletRequest request) {
		//ModelAndView mv = new ModelAndView("/products/productswrite");
		ModelAndView mv = new ModelAndView("tiles.products.write");
		
		//수정, 복사
		if (request.getParameter("idx") != null && request.getParameter("idx").length() != 0){
			int idx = Integer.parseInt(request.getParameter("idx"));
			ProductsEntity products = service.selectProductsDetail(idx);
			if (request.getParameter("copyflag") != null && request.getParameter("copyflag").length() != 0 && request.getParameter("copyflag").equals("Y")){
				mv.addObject("idx", 0);
				mv.addObject("product_name", "");
				//products.setIdx(0);
				//products.setProduct_name("");
				mv.addObject("irud", "NEW");
			}else{
				mv.addObject("idx", products.getIdx());
				mv.addObject("product_name", products.getProduct_name());
				mv.addObject("irud", "UPDATE");
			}
			
			mv.addObject("category1", products.getCategory1());
			mv.addObject("category2", products.getCategory2());
			mv.addObject("category3", products.getCategory3());
			mv.addObject("category4", products.getCategory4());
			mv.addObject("tag", products.getTag());
			mv.addObject("copy", products.getCopy());
			mv.addObject("story_telling", products.getStory_telling());
			mv.addObject("selling_point", products.getSelling_point());
			mv.addObject("size", products.getSize());
			mv.addObject("last_update_date", products.getLast_update_date());
			mv.addObject("usage_flag", products.getUsage_flag());
			mv.addObject("imagefile", this.modifiedAttachFileList(fileservice.selectImageFileList("PD", idx), products.getSize()));
			mv.addObject("category1_list", service.selectCategories("00"));
			mv.addObject("category2_list", service.selectCategories(products.getCategory1()));
			mv.addObject("category3_list", service.selectCategories(products.getCategory2()));
			mv.addObject("category4_list", service.selectCategories(products.getCategory3()));
		}else{
			//신규
			//신규일때는 오늘날짜 뿌려준다.
			mv.addObject("irud", "NEW");
			mv.addObject("idx", 0);
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd", Locale.KOREA);
			Date current = new Date();
			mv.addObject("last_update_date", formatter.format(current));
			mv.addObject("size", 2);
			mv.addObject("usage_flag", "Y");
			mv.addObject("category1_list", service.selectCategories("00"));
		}	
		
		return mv;
	}

	@RequestMapping(value = "/products/productssave.do") //, method = RequestMethod.POST)
	private void saveProducts(HttpServletRequest request,
			HttpServletResponse response) {
		String IRUD_flag = request.getParameter("irud").toString();

		String category1 = null;
		String category2 = null;
		String category3 = null;
		String category4 = null;
		
		
		ProductsEntity productsentity = new ProductsEntity();
		productsentity.setIdx(Integer.parseInt(request.getParameter("idx")));
		productsentity.setProduct_name(request.getParameter("product_name").toString());
		
		if (request.getParameter("category1") != null && request.getParameter("category1").length() != 0 && !request.getParameter("category1").toString().equals("--")){
			productsentity.setCategory1(request.getParameter("category1").toString());
		}
		if (request.getParameter("category2") != null && request.getParameter("category2").length() != 0 && !request.getParameter("category2").toString().equals("--")){
			productsentity.setCategory2(request.getParameter("category2").toString());
		}
		if (request.getParameter("category3") != null && request.getParameter("category3").length() != 0 && !request.getParameter("category3").toString().equals("--")){
			productsentity.setCategory3(request.getParameter("category3").toString());
		}
		if (request.getParameter("category4") != null && request.getParameter("category4").length() != 0 && !request.getParameter("category4").toString().equals("--")){
			productsentity.setCategory4(request.getParameter("category4").toString());
		}
		//productsentity.setCategory2(request.getParameter("category2").toString());
		//productsentity.setCategory3(request.getParameter("category3").toString());
		//productsentity.setCategory4(request.getParameter("category4").toString());
		productsentity.setTag(request.getParameter("tags").toString());
		productsentity.setCopy(request.getParameter("copy").toString());
		productsentity.setStory_telling(request.getParameter("story_telling").toString());
		productsentity.setSelling_point(request.getParameter("selling_point").toString());
		productsentity.setSize(Integer.parseInt(request.getParameter("size").toString()));		
		productsentity.setUsage_flag(request.getParameter("usage").toString());

		// String created_by = //세션에서 계정정보 가져다 입력해주자.
		if(request.getSession().getAttribute("empno") != null){
			productsentity.setCreated_by(request.getSession().getAttribute("empno").toString());
			productsentity.setLast_updated_by(request.getSession().getAttribute("empno").toString());
		}else{
			productsentity.setCreated_by(" ");
			productsentity.setLast_updated_by(" ");
		}
		String[] tags = productsentity.getTag().split(",");
		int tmpseq = 0;

		ArrayList<TagEntity> taglist = new ArrayList<TagEntity>();
		for (int i = 0; i < tags.length; i++) {
			if (tags[i].length() != 0 && tags[i] != null) {
				tmpseq += 1;
				TagEntity tmptag = new TagEntity();
				tmptag.setCategory_flag("PD");
				tmptag.setTag(tags[i].trim());
				tmptag.setTag_seq(tmpseq);
				taglist.add(tmptag);
			}
		}

		ArrayList<AttachFileEntity> filelist = new ArrayList<AttachFileEntity>();
		for (int i = 1; i <= productsentity.getSize(); i++) {
			if (request.getParameter("p" + i + "_imagename") != null
					&& request.getParameter("p" + i + "_imagename").length() != 0) {
				log.debug(request.getParameter("p" + i	+ "_imagename"));
				AttachFileEntity tmpfileinfo = new AttachFileEntity();
				tmpfileinfo.setCategory_flag("PD");
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
		}

		int idx = service.saveProducts(IRUD_flag, productsentity, taglist,
				filelist);

		try {
			if (idx > 0) response.getWriter().print("SUCCESS");
			else response.getWriter().print("ERROR");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	@RequestMapping(value = "/products/getcategoryentities.do")
	private ModelAndView getCategoryEntities(HttpServletRequest request,
			HttpServletResponse response){
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");		
		mv.addObject("subcategory", service.selectCategories(request.getParameter("category_group_id").toString()));
		return mv;
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
