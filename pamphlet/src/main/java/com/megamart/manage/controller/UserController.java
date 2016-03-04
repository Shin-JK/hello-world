package com.megamart.manage.controller;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.megamart.manage.entity.UserEntity;
import com.megamart.manage.service.UserService;

@Controller
public class UserController {

	@Resource(name = "userService")
	UserService userservice;
	
	@RequestMapping(value = "/manage/userlist.do")
	private ModelAndView getuserList(HttpServletRequest request,
			HttpServletResponse response){
		
		ModelAndView mv = new ModelAndView();
		mv.addObject("list", userservice.selectUserList());
		mv.setViewName("/manage/userlist");
		return mv;
	}
	
	@RequestMapping(value = "/manage/usersave.do")
	private ModelAndView saveUserInfo(HttpServletRequest request,
			HttpServletResponse response){
		ModelAndView mv = new ModelAndView();
		mv.setViewName("jsonView");
		
		String user_irud = request.getParameter("user_irud");
		UserEntity entity = new UserEntity();
		entity.setEmpno(request.getParameter("empno"));
		entity.setName(request.getParameter("name"));
		entity.setPassword(request.getParameter("newpassword"));
		if(request.getParameter("oldpassword") !=null && request.getParameter("oldpassword").length() > 0){
			entity.setOldpassword(request.getParameter("oldpassword"));
		}
		
		mv.addObject("result", userservice.SaveUser(user_irud, entity));
		return mv;
	}
}
