package com.megamart.pamphlet.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.megamart.common.dao.CommonDAO;
import com.megamart.pamphlet.entity.PamphletEntity;

@Repository("pamphletDao")
public class PamphletDao extends CommonDAO {

	public int insertPamphlet(PamphletEntity pamphletentity){
		return (int)insert("pamphlet.insertPamphlet", pamphletentity);
	}
	
	public int updatePamphlet(PamphletEntity pamphletentity){
		return (int)insert("pamphlet.updatePamphlet", pamphletentity);
	}
	
	public int deletePamphlet(int idx){
		return (int)delete("pamphlet.deletePamphlet", idx);
	}
	
	public int selectNewId(){
		return (int)selectOne("pamphlet.selectNewId");
	}
	
	public int selectPamphletTotalCnt(Map<String, Object> map){
		return (int)selectOne("pamphlet.selectPamphletTotalCnt", map);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectPamphletList(Map<String, Object> map){
		return (List<Map<String, Object>>)selectList("pamphlet.selectPamphletList", map);
	}
	
	public int selectPamphletTotalCntbyTag(Map<String, Object> map){
		return (int)selectOne("pamphlet.selectPamphletTotalCntbyTag", map);
	}
	
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectPamphletListbyTag(Map<String, Object> map){
		return (List<Map<String, Object>>)selectList("pamphlet.selectPamphletListbyTag", map);
	}
	
	public PamphletEntity selectPamphletDetail(int idx){
		return (PamphletEntity)selectOne("pamphlet.selectPamphletDetail", idx);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectAllStore(){
		return (List<Map<String, Object>>)selectList("common.store.selectAllStore", null);
	}
}
