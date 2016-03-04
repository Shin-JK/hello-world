package com.megamart.common.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import com.megamart.common.dao.LoginDao;

@Service("loginService")
public class LoginService {
	Logger log = Logger.getLogger(this.getClass());

	@Resource(name="loginDao")
	private LoginDao logindao;
	
	public Map<String, Object> loginProcess(String empno){
		return logindao.getPassword(empno);
	}
	
	public List<Map<String, Object>> getUsermenu(String empno){
		return logindao.getUsermenu(empno);
	}
}
