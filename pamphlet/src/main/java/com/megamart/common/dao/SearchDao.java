package com.megamart.common.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository("searchDao")
public class SearchDao  extends CommonDAO{
	
	/*상품 주제 분류 리스트*/
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectPDCategoryList(){
		return (List<Map<String, Object>>)selectList("common.searchlist.selectPDCategoryList", null);
	}

	/**
	 * 전단 이미지, 타이틀(테스트용)조회
	 * 
	 */
	public int selectpamphletImageTotCnt(Map<String, Object> map){
		return (int)selectOne("common.searchlist.selectPamphletImageTotcnt", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectpamphletImageList(Map<String, Object> map){
		return (List<Map<String, Object>>)selectList("common.searchlist.selectPamphletImage", map);
	}
	
	public int selectpamphletTitleTotCnt(Map<String, Object> map){
		return (int)selectOne("common.searchlist.selectPamphletTitleTotcnt", map);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectpamphletTitleList(Map<String, Object> map){
		return (List<Map<String, Object>>)selectList("common.searchlist.selectPamphletTitle", map);
	}
	/** 전단 이미지, 타이틀 조회 끝**/
	
	/* 상품 이미지, 셀링 포인트 검색*/
	public int selectproductsImageTotCnt(Map<String, Object> map){
		return (int)selectOne("common.searchlist.selectProductsImageTotCnt", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectproductsImageList(Map<String, Object> map){
		return (List<Map<String, Object>>)selectList("common.searchlist.selectProductsImageList", map);
	}
	
	public int selectproductsSellingTotCnt(Map<String, Object> map){
		return (int)selectOne("common.searchlist.selectProductsSellingTotCnt", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectproductsSellingList(Map<String, Object> map){
		return (List<Map<String, Object>>)selectList("common.searchlist.selectProductsSellingList", map);
	}
}
