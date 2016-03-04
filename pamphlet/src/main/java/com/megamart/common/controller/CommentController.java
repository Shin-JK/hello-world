package com.megamart.common.controller;

import java.io.IOException;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.megamart.common.entity.CommentEntity;
import com.megamart.common.service.CommentService;

@Controller
public class CommentController {

	@Resource(name = "commentService")
	private CommentService commentservice;
	
	@RequestMapping(value = "/common/commentpwd.do")
	private void checkCommentPassword(HttpServletRequest request,
			HttpServletResponse response){
		String Msg = "SUCCESS"; //commentservice.checkCommentPassword(request.getParameter("password").toString(), Integer.parseInt(request.getParameter("idx")));
		if (Msg.equals("SUCCESS") && request.getParameter("comment_irud").equals("DELETE")){
			CommentEntity entity = new CommentEntity();
			entity.setIdx(Integer.parseInt(request.getParameter("idx")));
			
			String val = commentservice.saveComment(request.getParameter("comment_irud"), entity);
			if(val.equals("SUCCESS")) {
				Msg = "DELETE_SUCCESS";
			}else{
				Msg = "댓글 삭제 중 오류 발생";
			}
		}
		
		try {
			response.getWriter().print(Msg);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	@RequestMapping(value = "/common/commentlist.do")
	private ModelAndView listCommet(HttpServletRequest request,
			HttpServletResponse response){
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		//mv.addObject("count", commentservice.selectCommentCount(request.getParameter("category_flag"), Integer.parseInt(request.getParameter("category_idx"))));
		mv.addObject("list", commentservice.selectCommentList(request.getParameter("category_flag"), Integer.parseInt(request.getParameter("category_idx"))));
		return mv;
	}
	
	@RequestMapping(value = "/common/commentsave.do", method=RequestMethod.POST)
	private void saveComment(HttpServletRequest request,
			HttpServletResponse response){
		String comment_irud = request.getParameter("comment_irud");
		int category_idx = Integer.parseInt(request.getParameter("category_idx"));
		String category_flag = request.getParameter("category_flag");
		String password = request.getParameter("password");
		String comments = request.getParameter("editedcomment");
		int idx = Integer.parseInt(request.getParameter("idx"));
		int parent_idx = Integer.parseInt(request.getParameter("parent_idx"));
		int depth = idx == parent_idx ? 1 : 2;
		
		CommentEntity entity = new CommentEntity();
		entity.setCategory_flag(category_flag);
		entity.setCategory_idx(category_idx);
		entity.setPassword(password);
		entity.setComments(comments);
		entity.setIdx(idx);
		entity.setParent_idx(parent_idx);
		entity.setDepth(depth);
		
		// String created_by = //세션에서 계정정보 가져다 입력해주자.
		if(request.getSession().getAttribute("empno") != null){
			entity.setCreated_by(request.getSession().getAttribute("empno").toString());
		}else{
			entity.setCreated_by(" ");
		}
		
		String Msg = commentservice.saveComment(comment_irud, entity);
		
		try {
			response.getWriter().print(Msg);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
