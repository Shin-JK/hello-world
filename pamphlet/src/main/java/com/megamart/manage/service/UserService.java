package com.megamart.manage.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.megamart.manage.dao.UserDao;
import com.megamart.manage.entity.UserEntity;

@Service("userService")
public class UserService {

	@Resource(name="userDao")
	UserDao userdao;
	
	public List<Map<String, Object>> selectUserList(){
		return userdao.selectuserList();
	}
	
	public Map<String, Object> selectUser(String empno){
		return userdao.selectUser(empno);
	}
	
	public String SaveUser(String flag, UserEntity entity){
		String msg = null;
		try {
			switch (flag) {
			case "NEW":
				userdao.insertUser(entity);
				msg = "SUCCESS";
				break;
			case "UPDATE":
				Map<String, Object> tmpmap = this.selectUser(entity.getEmpno());
				if(!tmpmap.get("password").equals(entity.getOldpassword())){
					msg = "현재 Password가 정확하지 않습니다.";
				}else{
					userdao.updateUser(entity);
					msg = "SUCCESS";
				}
				break;
			case "DELETE":
				userdao.deleteUser(entity.getEmpno());
				msg = "SUCCESS";
				break;
			}
			
			return msg;
		} catch (Exception e) {
			// TODO: handle exception
			return "ERROR : " + e.getMessage();
		}
		
	}
}
