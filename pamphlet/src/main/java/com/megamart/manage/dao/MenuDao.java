package com.megamart.manage.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.megamart.common.dao.CommonDAO;
import com.megamart.manage.entity.MenuEntity;

@Repository("menuDao")
public class MenuDao extends CommonDAO {

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectmenuList(){
		return (List<Map<String, Object>>)selectList("manage.menu.selectmenuList", null);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectparentmenuList(){
		return (List<Map<String, Object>>)selectList("manage.menu.selectparentmenuList", null);
	}
	
	@SuppressWarnings("unchecked")
	public String selectnewtopmenuCode(){
		return (String) selectOne("manage.menu.selectnewtopmenucode");
	}
	
	@SuppressWarnings("unchecked")
	public String selectnewsubmenuCode(Map<String, Object> map){
		return (String) selectOne("manage.menu.selectnewsubmenucode", map);
	}
	
	public int insertMenu(MenuEntity entity){
		return (int)insert("manage.menu.insertmenu", entity);
	}
	
	public int updateMenu(MenuEntity entity){
		return (int)insert("manage.menu.updatemenu", entity);
	} 
}
