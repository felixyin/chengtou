/**
 * Copyright &copy; 2016-2017 HZC All rights reserved.
 */
package com.hzc.aams.modules.sys.security;

import com.hzc.aams.common.utils.StringUtils;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.IncorrectCredentialsException;
import org.apache.shiro.authc.UnknownAccountException;
import org.apache.shiro.web.util.WebUtils;
import org.springframework.stereotype.Service;

import javax.servlet.ServletContext;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

/**
 * 表单验证（包含验证码）过滤类
 *
 * @author ThinkGem
 * @version 2014-5-19
 */
@Service
public class FormAuthenticationFilter extends org.apache.shiro.web.filter.authc.FormAuthenticationFilter {


    public static final String DEFAULT_CAPTCHA_PARAM = "validateCode";
    public static final String DEFAULT_MOBILE_PARAM = "mobileLogin";
    public static final String DEFAULT_MESSAGE_PARAM = "message";
    public static boolean DEFAULT_CAN_ACCESS = true;

    private String captchaParam = DEFAULT_CAPTCHA_PARAM;
    private String mobileLoginParam = DEFAULT_MOBILE_PARAM;
    private String messageParam = DEFAULT_MESSAGE_PARAM;

    protected AuthenticationToken createToken(ServletRequest request, ServletResponse response) {
        String username = getUsername(request);
        String password = getPassword(request);
        if (password == null) {
            password = "";
        }
        boolean rememberMe = isRememberMe(request);
        String host = StringUtils.getRemoteAddr((HttpServletRequest) request);
        String captcha = getCaptcha(request);
        boolean mobile = isMobileLogin(request);
        return new UsernamePasswordToken(username, password.toCharArray(), rememberMe, host, captcha, mobile);
    }

    /**
     * 获取登录用户名
     */
    protected String getUsername(ServletRequest request, ServletResponse response) {
        String username = super.getUsername(request);
        if (StringUtils.isBlank(username)) {
            username = StringUtils.toString(request.getAttribute(getUsernameParam()), StringUtils.EMPTY);
        }
        return username;
    }

    /**
     * 获取登录密码
     */
    @Override
    protected String getPassword(ServletRequest request) {
        String password = super.getPassword(request);
        if (StringUtils.isBlank(password)) {
            password = StringUtils.toString(request.getAttribute(getPasswordParam()), StringUtils.EMPTY);
        }
        return password;
    }

    /**
     * 获取记住我
     */
    @Override
    protected boolean isRememberMe(ServletRequest request) {
        String isRememberMe = WebUtils.getCleanParam(request, getRememberMeParam());
        if (StringUtils.isBlank(isRememberMe)) {
            isRememberMe = StringUtils.toString(request.getAttribute(getRememberMeParam()), StringUtils.EMPTY);
        }
        return StringUtils.toBoolean(isRememberMe);
    }

    public String getCaptchaParam() {
        return captchaParam;
    }

    protected String getCaptcha(ServletRequest request) {
        return WebUtils.getCleanParam(request, getCaptchaParam());
    }

    public String getMobileLoginParam() {
        return mobileLoginParam;
    }

    protected boolean isMobileLogin(ServletRequest request) {
        return WebUtils.isTrue(request, getMobileLoginParam());
    }

    public String getMessageParam() {
        return messageParam;
    }

    /**
     * 登录成功之后跳转URL
     */
    public String getSuccessUrl() {
        return super.getSuccessUrl();
    }


    /**
     * admin 账号短信验证码验证
     *
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    @Override
    protected boolean onAccessDenied(ServletRequest request, ServletResponse response) throws Exception {
        // 在这里进行验证码的校验


        // 仅仅验证admin用户
        String username = getUsername(request);
        if ("admin".equalsIgnoreCase(username)) {
//            todo 关闭验证码
//            String smsCode = WebUtils.getCleanParam(request, "smsCode");
//            System.out.println(smsCode);
//            ServletContext servletContext = ((HttpServletRequest) request).getSession().getServletContext();
//            Object adminSmsCodeObj = servletContext.getAttribute("adminSmsCode");
//            if (null != adminSmsCodeObj) {
//                String adminSmsCode = String.valueOf(adminSmsCodeObj);
//                if (!adminSmsCode.equalsIgnoreCase(smsCode)) {
//                    // 短信验证码验证未通过，直接提示错误消息
//                    String message = "短信验证码不匹配, 请重试.";
//                    request.setAttribute("message", message);
//                    return true;
//                } else {
                  /*  if (!DEFAULT_CAN_ACCESS){
                        String message = "系统出现未知问题, 请重试.";
                        request.setAttribute("message", message);
                        return true;
                    }*/
                    // 短信验证码验证通过，删除servletContent中的验证码
//                    servletContext.removeAttribute("adminSmsCode");
//                }
//            } else {
//                String message = "管理员账号须经领导短信验证码授权, 请重试.";
//                request.setAttribute("message", message);
//                return true;
//            }
        }
        return super.onAccessDenied(request, response);
    }

    @Override
    protected void issueSuccessRedirect(ServletRequest request,
                                        ServletResponse response) throws Exception {
//		Principal p = UserUtils.getPrincipal();
//		if (p != null && !p.isMobileLogin()){
        WebUtils.issueRedirect(request, response, getSuccessUrl(), null, true);
//		}else{
//			super.issueSuccessRedirect(request, response);
//		}
    }

    /**
     * 登录失败调用事件
     */
    @Override
    protected boolean onLoginFailure(AuthenticationToken token,
                                     AuthenticationException e, ServletRequest request, ServletResponse response) {
        String className = e.getClass().getName(), message = "";
        if (IncorrectCredentialsException.class.getName().equals(className)
                || UnknownAccountException.class.getName().equals(className)) {
            message = "用户或密码错误, 请重试..";
        } else if (e.getMessage() != null && StringUtils.startsWith(e.getMessage(), "msg:")) {
            message = StringUtils.replace(e.getMessage(), "msg:", "");
        } else {
            message = "系统出现点问题，请稍后再试！";
            e.printStackTrace(); // 输出到控制台
        }
        request.setAttribute(getFailureKeyAttribute(), className);
        request.setAttribute(getMessageParam(), message);
        return true;
    }

}