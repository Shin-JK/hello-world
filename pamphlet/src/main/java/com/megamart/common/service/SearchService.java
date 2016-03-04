package com.megamart.common.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;

import com.megamart.common.aws.AwsMethods;
import com.megamart.common.dao.SearchDao;
import com.megamart.common.entity.PageEntity;

@Service("searchService")
public class SearchService {

	@Resource(name="searchDao")
	private SearchDao searchdao;
	
	//검색화면 tab 설정을 위해 상품 주제 분류를 가져옴.
	public List<Map<String, Object>> selectPDCategoryList(String keyword){
		
		//전단은 임의로 추가!!!
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("flag", "PP");
		map.put("name", "전단");
		
		PageEntity imagepage = new PageEntity();
		imagepage.setPageNo(1);
		imagepage.setPageSize(8);
		imagepage.setTotalCount(this.selectpamphletImageTotCnt(keyword));
		imagepage.makePaging();
		
		map.put("imagepage", imagepage);
		map.put("imagelist", this.selectpamphletImageList(keyword, 0, 8));
		
		//PageEntity sellingpage = new PageEntity();
		//sellingpage.setPageNo(1);
		//sellingpage.setPageSize(5);
		//sellingpage.setTotalCount(this.selectpamphletTitleTotCnt(keyword));
		//sellingpage.makePaging();
		
		//map.put("sellingpage", sellingpage);
		//map.put("sellinglist", this.selectpamphletTitleList(keyword, 0, 5));
		
		//상품 주제 분류별로 검색
		List<Map<String, Object>> list = searchdao.selectPDCategoryList();
		for(int i=0; i< list.size(); i++){
			String tmpflag = list.get(i).get("flag").toString();
			
			PageEntity tmpImagePage = new PageEntity();
			tmpImagePage.setPageNo(1);
			tmpImagePage.setPageSize(8);
			tmpImagePage.setTotalCount(this.selectproductsImageTotCnt(keyword, tmpflag));
			tmpImagePage.makePaging();
			
			list.get(i).put("imagepage", tmpImagePage);
			list.get(i).put("imagelist", this.selectproductsImageList(keyword, tmpflag, 0, 8));
			
			PageEntity tmpSellingpage = new PageEntity();
			tmpSellingpage.setPageNo(1);
			tmpSellingpage.setPageSize(5);
			tmpSellingpage.setTotalCount(this.selectproductsSellingTotCnt(keyword, tmpflag));
			tmpSellingpage.makePaging();
			
			list.get(i).put("sellingpage", tmpSellingpage);
			list.get(i).put("sellinglist", this.selectproductsSellingList(keyword, tmpflag, 0, 5));
		}
		
		list.add(0, map);
		return list;
	}
	
	//전단 이미지 총 갯수
	public int selectpamphletImageTotCnt(String keyword){
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("keyword", keyword);
		
		return searchdao.selectpamphletImageTotCnt(map);
	}
	
	//전단 이미지 리스트
	public List<Map<String, Object>> selectpamphletImageList(String keyword, int limitFrom, int countperpage){
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("keyword", keyword);
		map.put("limitFrom", limitFrom);
		map.put("countperpage", countperpage);
		
		List<Map<String, Object>> tmplist = searchdao.selectpamphletImageList(map);
		for(int i=0; i<tmplist.size(); i++){
			if(tmplist.get(i).get("s3_file_name") != null){
				tmplist.get(i).put("url", AwsMethods.getPreSignedURL("PP", tmplist.get(i).get("s3_file_name").toString()));
				tmplist.get(i).put("thumbmurl", AwsMethods.getPreSignedThumbMURL("PP", tmplist.get(i).get("s3_file_name").toString()));
				tmplist.get(i).put("thumbsurl", AwsMethods.getPreSignedThumbSURL("PP", tmplist.get(i).get("s3_file_name").toString()));
			}
		}
		return tmplist;
	}
	
	//전단 셀링포인트 총 갯수 테스트용
	public int selectpamphletTitleTotCnt(String keyword){
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("keyword", keyword);		
		return searchdao.selectpamphletTitleTotCnt(map);
	}
	
	//전단 셀링포인트 리스트 테스트용
	public List<Map<String, Object>> selectpamphletTitleList(String keyword, int limitFrom, int countperpage){
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("keyword", keyword);
		map.put("limitFrom", limitFrom);
		map.put("countperpage", countperpage);
		
		List<Map<String, Object>> tmplist = searchdao.selectpamphletTitleList(map);
		for(int i=0; i<tmplist.size(); i++){
			tmplist.get(i).put("url", AwsMethods.getPreSignedURL("PP", tmplist.get(i).get("s3_file_name").toString()));
		}
		return tmplist;
	}
	
	public int selectproductsImageTotCnt(String keyword, String category){
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("keyword", keyword);
		map.put("category", category);
		
		return searchdao.selectproductsImageTotCnt(map);
	}
	
	public List<Map<String, Object>> selectproductsImageList(String keyword, String category, int limitFrom, int countperpage){
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("keyword", keyword);
		map.put("category", category);
		map.put("limitFrom", limitFrom);
		map.put("countperpage", countperpage);
		
		List<Map<String, Object>> tmplist = searchdao.selectproductsImageList(map);
		for(int i=0; i<tmplist.size(); i++){
			if(tmplist.get(i).get("s3_file_name") != null){
				tmplist.get(i).put("url", AwsMethods.getPreSignedURL("PD", tmplist.get(i).get("s3_file_name").toString()));
				tmplist.get(i).put("thumbmurl", AwsMethods.getPreSignedThumbMURL("PD", tmplist.get(i).get("s3_file_name").toString()));
				tmplist.get(i).put("thumbsurl", AwsMethods.getPreSignedThumbSURL("PD", tmplist.get(i).get("s3_file_name").toString()));
			}
		}
		
		return tmplist;
	}
	
	public int selectproductsSellingTotCnt(String keyword, String category){
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("keyword", keyword);
		map.put("category", category);
		
		return searchdao.selectproductsSellingTotCnt(map);
	}
	
	public List<Map<String, Object>> selectproductsSellingList(String keyword, String category, int limitFrom, int countperpage){
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("keyword", keyword);
		map.put("category", category);
		map.put("limitFrom", limitFrom);
		map.put("countperpage", countperpage);
		
		return searchdao.selectproductsSellingList(map);
	}
	
}
