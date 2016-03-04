package com.megamart.common.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository("loginDao")
public class LoginDao extends CommonDAO {

	@SuppressWarnings("unchecked")
	public Map<String, Object> getPassword(String empno){
		return (Map<String, Object>)selectOne("common.login.selectpassword", empno);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getUsermenu(String empno){
		return (List<Map<String, Object>>)selectList("common.user.selectusermenu", empno);
	}
}
