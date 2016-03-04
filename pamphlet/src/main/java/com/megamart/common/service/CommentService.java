package com.megamart.common.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import com.megamart.common.dao.CommentDao;
import com.megamart.common.entity.CommentEntity;

@Service("commentService")
public class CommentService {
	Logger log = Logger.getLogger(this.getClass());
	
	@Resource(name="commentDao")
	private CommentDao commentdao;
	
	public int selectCommentCount(String category_flag, int category_idx){
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("category_flag", category_flag);
		map.put("category_idx", category_idx);		
		return commentdao.selectCommentCount(map);
	}
	
	public List<Map<String, Object>> selectCommentList(String category_flag, int category_idx){
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("category_flag", category_flag);
		map.put("category_idx", category_idx);		
		return commentdao.selectCommentList(map);
	}
	
	public String checkCommentPassword(String password, int idx){
		String tmppwd = commentdao.selectPassword(idx);
		String Msg = null;
		if(password.equals(tmppwd)){
			Msg = "SUCCESS";
		}else{
			Msg = "Invalid Password";
		}		
		//log.debug(Msg + "/" + tmppwd + " / " + password);
		return Msg;
	}
	
	public String saveComment(String comment_irud, CommentEntity commententity){
		try {
			int newidx = 0;
			
			switch (comment_irud) {
			case "NEW":
				newidx = commentdao.selectNewId();
				commententity.setIdx(newidx);
				commententity.setParent_idx(newidx);
				commententity.setDepth(1);
				commentdao.insertComment(commententity);
				break;
			case "REPLY":
				newidx = commentdao.selectNewId();
				commententity.setIdx(newidx);
				commententity.setDepth(2);
				commentdao.insertComment(commententity);
				break;
			case "UPDATE":
				commentdao.updateComment(commententity);
				break;
			case "DELETE":
				commentdao.deleteComment(commententity.getIdx());
				break;
			}
			return "SUCCESS";
		} catch (Exception e) {
			log.error("Comment 저장 오류 :" + e.getMessage());
			return "ERROR : " + e.getMessage();
		}
	}
	
	public Map<String, Object> selectCommentUser(String empno){
		return commentdao.selectCommentUser(empno);
	}
}
