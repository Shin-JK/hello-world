package com.megamart.common.controller;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.megamart.common.service.CommentService;
import com.megamart.common.service.LoginService;

@Controller
public class LoginController {

	@Resource(name = "loginService")
	private LoginService loginservice;
	
	@Resource(name = "commentService")
	private CommentService commentservice;
	
	@RequestMapping(value = "/common/login.do")
	private String moveLoginPage(){
		return "/common/login";
	}
	
	@RequestMapping(value = "/common/loginprocess.do", method = RequestMethod.POST)
	private ModelAndView loginProcess(HttpServletRequest request,
			HttpServletResponse response){
		String empno = null;
		String pwd = null;
		
		ModelAndView mv  = new ModelAndView();
		mv.setViewName("jsonView");
		if(request.getParameter("empno") == null || request.getParameter("empno").length() == 0 ||
		   request.getParameter("pwd") == null || request.getParameter("pwd").length() == 0){
			mv.addObject("result_msg", "로그인 정보가 올바르지 않습니다.");
		}else{
			empno = request.getParameter("empno").toString();
			pwd = request.getParameter("pwd").toString();
			
			Map<String, Object> tmpmap = loginservice.loginProcess(empno);
			
			if(tmpmap== null || tmpmap.get("password") == null){
				mv.addObject("result_msg", "사번이 올바르지 않습니다.");
				mv.addObject("errElem", "empno");
			}else{
				if(!tmpmap.get("password").toString().equals(pwd)){
					mv.addObject("result_msg", "패스워드가 올바르지 않습니다.");
					mv.addObject("errElem", "pwd");
				}else{
					mv.addObject("result_msg", "SUCCESS");
					
					request.getSession().setAttribute("name", tmpmap.get("name").toString());
					request.getSession().setAttribute("empno", empno);
					request.getSession().setAttribute("menu", loginservice.getUsermenu(request.getSession().getAttribute("empno").toString()));
					
					Map<String, Object> tmpcmtmap = commentservice.selectCommentUser(empno);
					
					if(tmpcmtmap !=null){
						request.getSession().setAttribute("pamphlet_comment", tmpcmtmap.get("pamphlet_comment_use").toString());
						request.getSession().setAttribute("products_comment", tmpcmtmap.get("products_comment_use").toString());
					}else{
						request.getSession().setAttribute("pamphlet_comment", "N");
						request.getSession().setAttribute("products_comment", "N");
					}					
				}
			}
		}		
		return mv;
	}
	
	@RequestMapping(value = "/common/logout.do")
	private String moveLoginPage(HttpServletRequest request,
			HttpServletResponse response){
		request.getSession().removeAttribute("name");
		request.getSession().removeAttribute("empno");
		request.getSession().removeAttribute("menu");
		return "/common/login";
	}
	
	//tiles test
	@RequestMapping(value = "/common/menu.do")
	private ModelAndView usermenu(HttpServletRequest request,
	HttpServletResponse response){
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/common/menu");
		mv.addObject("menu", loginservice.getUsermenu(request.getSession().getAttribute("empno").toString()));
		return mv;
	}
}
