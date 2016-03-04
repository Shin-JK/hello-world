package com.megamart.manage.entity;

public class MenuEntity {
	String menu_code;
	String parent_menu_code;
	String menu_name;
	String menu_path;
	String usage_flag;
	
	public MenuEntity() {
	}

	public String getMenu_code() {
		return menu_code;
	}

	public void setMenu_code(String menu_code) {
		this.menu_code = menu_code;
	}

	public String getParent_menu_code() {
		return parent_menu_code;
	}

	public void setParent_menu_code(String parent_menu_code) {
		this.parent_menu_code = parent_menu_code;
	}

	public String getMenu_name() {
		return menu_name;
	}

	public void setMenu_name(String menu_name) {
		this.menu_name = menu_name;
	}

	public String getMenu_path() {
		return menu_path;
	}

	public void setMenu_path(String menu_path) {
		this.menu_path = menu_path;
	}

	public String getUsage_flag() {
		return usage_flag;
	}

	public void setUsage_flag(String usage_flag) {
		this.usage_flag = usage_flag;
	}
	
	
}
