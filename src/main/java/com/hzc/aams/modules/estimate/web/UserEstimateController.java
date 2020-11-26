/**
 * Copyright &copy; 2016-2017 HZC All rights reserved.
 */
package com.hzc.aams.modules.estimate.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.time.DateFormatUtils;
import org.apache.commons.lang3.time.DateUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.hzc.aams.common.config.Global;
import com.hzc.aams.common.persistence.Page;
import com.hzc.aams.common.web.BaseController;
import com.hzc.aams.common.utils.StringUtils;
import com.hzc.aams.modules.estimate.entity.UserEstimate;
import com.hzc.aams.modules.estimate.service.UserEstimateService;

import java.util.Date;

/**
 * 人员评分Controller
 *
 * @author 尹彬
 * @version 2017-07-08
 */
@Controller
@RequestMapping(value = "${adminPath}/estimate/userEstimate")
public class UserEstimateController extends BaseController {

    @Autowired
    private UserEstimateService userEstimateService;

    @ModelAttribute
    public UserEstimate get(@RequestParam(required = false) String id,@RequestParam(required = false) String year) {
        UserEstimate entity = null;
        if (StringUtils.isNotBlank(id) && StringUtils.isNotBlank(year)) {
            entity = userEstimateService.get(id,year);
        }else if (StringUtils.isNotBlank(id)){
            entity = userEstimateService.get(id);
        }
        if (entity == null) {
            entity = new UserEstimate();
        }
        return entity;
    }

    @RequiresPermissions("estimate:userEstimate:view")
    @RequestMapping(value = {"list", ""})
    public String list(UserEstimate userEstimate, HttpServletRequest request, HttpServletResponse response, Model model) {
        String year = userEstimate.getYear();
        if (org.apache.commons.lang3.StringUtils.isBlank(year)) {
            userEstimate.setYear(DateFormatUtils.format(new Date(), "yyyy"));
        }
        Page<UserEstimate> page = userEstimateService.findPage(new Page<UserEstimate>(request, response), userEstimate);
        model.addAttribute("page", page);
        return "modules/estimate/userEstimateList";
    }

    @RequiresPermissions("estimate:userEstimate:view")
    @RequestMapping(value = "form")
    public String form(UserEstimate userEstimate, Model model) {
        model.addAttribute("userEstimate", userEstimate);
        model.addAttribute("isForEdit", true);
        return "modules/estimate/userEstimateForm";
    }

    @RequiresPermissions("estimate:userEstimate:view")
    @RequestMapping(value = "view")
    public String view(UserEstimate userEstimate, Model model) {
        model.addAttribute("userEstimate", userEstimate);
        model.addAttribute("isForEdit", false);
        return "modules/estimate/userEstimateView";
    }

    @RequiresPermissions("estimate:userEstimate:edit")
    @RequestMapping(value = "save")
    public String save(UserEstimate userEstimate, Model model, RedirectAttributes redirectAttributes) {
        if (!beanValidator(model, userEstimate)) {
            return form(userEstimate, model);
        }
        userEstimateService.save(userEstimate);
        addMessage(redirectAttributes, "保存人员评分成功");
        return "redirect:" + Global.getAdminPath() + "/estimate/userEstimate/?repage";
    }

    @RequiresPermissions("estimate:userEstimate:edit")
    @RequestMapping(value = "delete")
    public String delete(UserEstimate userEstimate, RedirectAttributes redirectAttributes) {
        userEstimateService.delete(userEstimate);
        addMessage(redirectAttributes, "删除人员评分成功");
        return "redirect:" + Global.getAdminPath() + "/estimate/userEstimate/?repage";
    }

}