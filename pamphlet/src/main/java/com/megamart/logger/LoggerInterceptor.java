package com.megamart.logger;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

public class LoggerInterceptor extends HandlerInterceptorAdapter {
	protected Log log = LogFactory.getLog(LoggerInterceptor.class);
	
	

	@Override
	public boolean preHandle(HttpServletRequest request,
			HttpServletResponse response, Object handler) throws Exception {
		// TODO Auto-generated method stub
		if(request.getSession().getAttribute("empno") == null){
			//redirect log-in page
			//request.getSession().setAttribute("name", "홍길동");
			//request.getSession().setAttribute("empno", "0510187");
			if (!request.getRequestURI().equals(request.getContextPath()+"/common/login.do") &&
			    !request.getRequestURI().equals(request.getContextPath()+"/common/loginprocess.do") &&
			    !request.getRequestURI().equals(request.getContextPath()+"/pamphlet/pamphletpopupview.do") &&
			    !request.getRequestURI().equals(request.getContextPath()+"/products/productspopupview.do")){
				response.sendRedirect(request.getContextPath()+"/common/login.do");
				return false;
			}
		}
		if(log.isDebugEnabled()) {
			log.debug("==================== START ====================");
			log.debug(" Request URI \t:  " + request.getRequestURI());
		}
		
		return super.preHandle(request, response, handler);
	}
	
	@Override
	public void postHandle(HttpServletRequest request,
			HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
		// TODO Auto-generated method stub
		
		if(log.isDebugEnabled()) {
			log.debug("==================== END ====================");
		}
		super.postHandle(request, response, handler, modelAndView);
	}

}
