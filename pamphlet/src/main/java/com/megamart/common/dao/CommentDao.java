package com.megamart.common.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.megamart.common.entity.CommentEntity;

@Repository("commentDao")
public class CommentDao extends CommonDAO {

	public int selectNewId(){
		return (int)selectOne("common.comment.selectNewId");
	}
	
	public String selectPassword(int idx){
		return (String)selectOne("common.comment.selectCommentPassword", idx);
	}
	
	public int selectCommentCount(Map<String, Object> map){
		return (int)selectOne("common.comment.selectCommentCount", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectCommentList(Map<String, Object> map){
		return (List<Map<String, Object>>)selectList("common.comment.selectCommentList", map);
	}
	
	public int insertComment(CommentEntity commententity){
		return (int)insert("common.comment.insertComment", commententity);
	}
	
	public int updateComment(CommentEntity commententity){
		return (int)insert("common.comment.updateComment", commententity);
	}
	
	public int deleteComment(int idx){
		return (int)delete("common.comment.deleteComment", idx);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectCommentUser(String empno){
		return (Map<String, Object>)selectOne("common.comment.selectCommentuser", empno);
	}
}
