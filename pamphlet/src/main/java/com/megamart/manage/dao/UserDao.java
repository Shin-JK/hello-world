package com.megamart.manage.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.megamart.common.dao.CommonDAO;
import com.megamart.manage.entity.UserEntity;

@Repository("userDao")
public class UserDao extends CommonDAO {

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectuserList(){
		return (List<Map<String, Object>>)selectList("manage.user.selectuserList", null);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectUser(String empno){
		return (Map<String, Object>) selectOne("manage.user.selectuser", empno);
	}
	
	public int insertUser(UserEntity entity){
		return (int)insert("manage.user.insertuser", entity);
	}
	
	public int updateUser(UserEntity entity){
		return (int)update("manage.user.updateuser", entity);
	} 
	
	public int deleteUser(String empno){
		return (int)delete("manage.user.deleteuser", empno);
	}
}
