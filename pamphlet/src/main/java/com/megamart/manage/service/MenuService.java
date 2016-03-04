package com.megamart.manage.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.megamart.manage.dao.MenuDao;
import com.megamart.manage.entity.MenuEntity;

@Service("menuService")
public class MenuService {

	@Resource(name="menuDao")
	MenuDao menudao;
	
	public List<Map<String, Object>> selectMenuList(){
		return menudao.selectmenuList();
	}
	
	public List<Map<String, Object>> selectParentMenuList(){
		return menudao.selectparentmenuList();
	} 
	
	public String saveMenu(String flag, MenuEntity menu){
		try {
			if(flag.equals("NEW")){
				if(menu.getParent_menu_code() == null){
					String newcode = menudao.selectnewtopmenuCode();
					menu.setMenu_code(newcode);
					menu.setParent_menu_code(newcode);
				}else{
					Map<String,Object > map = new HashMap<String, Object>();
					map.put("parent_menu_code", menu.getParent_menu_code());
					menu.setMenu_code(menudao.selectnewsubmenuCode(map));
				}
				menudao.insertMenu(menu);
			}
			
			if(flag.equals("UPDATE")){
				menudao.updateMenu(menu);
			}
			
			return "SUCCESS";
		} catch (Exception e) {
			// TODO: handle exception
			return "ERROR : " + e.getMessage();
		}
		
	}
}
