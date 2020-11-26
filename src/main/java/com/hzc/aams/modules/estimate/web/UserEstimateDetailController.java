/**
 * Copyright &copy; 2016-2017 HZC All rights reserved.
 */
package com.hzc.aams.modules.estimate.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.common.collect.Maps;
import com.hzc.aams.modules.approve.entity.estimate.OaEstimateApprove;
import com.hzc.aams.modules.approve.service.estimate.OaEstimateApproveService;
import com.hzc.aams.modules.oa.entity.Leave;
import com.hzc.aams.modules.oa.service.LeaveService;
import com.hzc.aams.modules.sys.utils.DictUtils;
import com.hzc.aams.modules.sys.utils.UserUtils;
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
import com.hzc.aams.modules.estimate.entity.UserEstimateDetail;
import com.hzc.aams.modules.estimate.service.UserEstimateDetailService;

import java.util.Map;

/**
 * 评分明细Controller
 *
 * @author 尹彬
 * @version 2017-07-08
 */
@Controller
@RequestMapping(value = "${adminPath}/estimate/userEstimateDetail")
public class UserEstimateDetailController extends BaseController {

    @Autowired
    private UserEstimateDetailService userEstimateDetailService;

    @Autowired
    private OaEstimateApproveService oaEstimateApproveService;

    @ModelAttribute
    public UserEstimateDetail get(@RequestParam(required = false) String id, @RequestParam(required = false) String userId) {
        UserEstimateDetail entity = null;
        if (StringUtils.isNotBlank(id)) {
            UserEstimateDetail queryBean = new UserEstimateDetail();
            queryBean.setUserId(userId);
            queryBean.setId(id);
            entity = userEstimateDetailService.get(queryBean);
        }
        if (entity == null) {
            entity = new UserEstimateDetail();
        }
        return entity;
    }

    @RequiresPermissions("estimate:userEstimateDetail:view")
    @RequestMapping(value = {"list", ""})
    public String list(UserEstimateDetail userEstimateDetail, HttpServletRequest request, HttpServletResponse response, Model model) {
        //        搜索表单，设置默认下拉框选中
        if (StringUtils.isBlank(userEstimateDetail.getLevel())) {
            userEstimateDetail.setLevel(DictUtils.getDictValue("全部", "project_level", "-1"));
        }
        if (StringUtils.isBlank(userEstimateDetail.getStatus())) {
            userEstimateDetail.setStatus(DictUtils.getDictValue("进行中", "project_types", "1"));
        }
        Page<UserEstimateDetail> page = userEstimateDetailService.findPage(new Page<UserEstimateDetail>(request, response), userEstimateDetail);
        model.addAttribute("page", page);
        return "modules/estimate/userEstimateDetailList";
    }


    @RequiresPermissions("estimate:userEstimateDetail:view")
    @RequestMapping(value = "form")
    public String form(UserEstimateDetail userEstimateDetail, Model model) {
        model.addAttribute("userEstimateDetail", userEstimateDetail);
        model.addAttribute("isForEdit", true);
        return "modules/estimate/userEstimateDetailForm";
    }

    @RequiresPermissions("estimate:userEstimateDetail:view")
    @RequestMapping(value = "view")
    public String view(UserEstimateDetail userEstimateDetail, Model model) {
        model.addAttribute("userEstimateDetail", userEstimateDetail);
        model.addAttribute("isForEdit", false);
        return "modules/estimate/userEstimateDetailView";
    }

    @RequiresPermissions("estimate:userEstimateDetail:edit")
    @RequestMapping(value = "save")
    public String save(UserEstimateDetail userEstimateDetail, Model model, RedirectAttributes redirectAttributes) {
        if (!beanValidator(model, userEstimateDetail)) {
            return form(userEstimateDetail, model);
        }
        userEstimateDetailService.save(userEstimateDetail);
        addMessage(redirectAttributes, "保存评分明细成功");
        return "redirect:" + Global.getAdminPath() + "/estimate/userEstimateDetail/?repage";
    }

    @RequiresPermissions("estimate:userEstimateDetail:edit")
    @RequestMapping(value = "delete")
    public String delete(UserEstimateDetail userEstimateDetail, RedirectAttributes redirectAttributes) {
        userEstimateDetailService.delete(userEstimateDetail);
        addMessage(redirectAttributes, "删除评分明细成功");
        return "redirect:" + Global.getAdminPath() + "/estimate/userEstimateDetail/?repage";
    }

}