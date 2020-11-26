/**
 * Copyright &copy; 2016-2017 HZC All rights reserved.
 */
package com.hzc.aams.modules.approve.web.estimate;

import com.google.common.collect.Maps;
import com.hzc.aams.common.config.Global;
import com.hzc.aams.common.persistence.Page;
import com.hzc.aams.common.utils.StringUtils;
import com.hzc.aams.common.web.BaseController;
import com.hzc.aams.modules.approve.entity.estimate.OaEstimateApprove;
import com.hzc.aams.modules.approve.service.estimate.OaEstimateApproveService;
import com.hzc.aams.modules.project.entity.AamsEstimate;
import com.hzc.aams.modules.project.service.AamsEstimateService;
import com.hzc.aams.modules.sys.entity.Role;
import com.hzc.aams.modules.sys.entity.User;
import com.hzc.aams.modules.sys.utils.UserUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Date;
import java.util.Map;

/**
 * 评分审批工作流Controller
 *
 * @author 尹彬
 * @version 2017-07-10
 */
@Controller
@RequestMapping(value = "${adminPath}/approve/estimate/personDept")
public class OaEstimatePersonDeptApproveController extends BaseController {

    @Autowired
    private OaEstimateApproveService oaEstimateApproveService;

    @Autowired
    private AamsEstimateService aamsEstimateService;

    @ModelAttribute
    public OaEstimateApprove get(@RequestParam(required = false) String id) {
        OaEstimateApprove entity = null;
        if (StringUtils.isNotBlank(id)) {
            entity = oaEstimateApproveService.get(id);
        }
        if (entity == null) {
            entity = new OaEstimateApprove();
        }
        return entity;
    }

    /**
     * 跳转审批界面
     *
     * @param oaEstimateApprove
     * @param model
     * @return
     */
    @RequiresPermissions("approve:estimate:oaEstimateApprove:approve")
    @RequestMapping(value = "preApprove")
    public String preApprove(OaEstimateApprove oaEstimateApprove, Model model) {
        model.addAttribute("oaEstimateApprove", oaEstimateApprove);
        model.addAttribute("isForEdit", true);

        // 角色拼接，页面片段以此判断是否显示
        StringBuilder roleStr = new StringBuilder();
        for (Role role : UserUtils.getRoleList()) roleStr.append(role.getEnname()).append(",");
        model.addAttribute("roleStr", roleStr.toString());

        AamsEstimate aamsEstimate = aamsEstimateService.get(oaEstimateApprove.getEstimate().getId());
        oaEstimateApprove.setEstimate(aamsEstimate);

        User user = UserUtils.getUser();
        oaEstimateApprove.setApproveUser(user);

        return "modules/approve/estimate/oaEstimateApproveSubmit";
    }

    @RequiresPermissions("approve:estimate:oaEstimateApprove:approve")
    @RequestMapping(value = "approve")
    public String approve(OaEstimateApprove oaEstimateApprove, Model model, RedirectAttributes redirectAttributes) {
        model.addAttribute("oaEstimateApprove", oaEstimateApprove);
        model.addAttribute("isForEdit", true);
//
//        List<Role> roleList = UserUtils.getRoleList();
//        for (Role role : roleList) {
//            String enname = role.getEnname();
//            if (enname.equals("p")) {//普通用户
//                String fractionApprove = oaEstimateApprove.getFractionApprove();
//                String reason = oaEstimateApprove.getReason();
//                User bumenUser = oaEstimateApprove.getBumenUser();
//
//            }
//
//        }

//        if ("1".equals(e.getStatus())){
//            addMessage(redirectAttributes, "已发布，不能操作！");
//            return "redirect:" + adminPath + "/oa/oaNotify/form?id="+oaNotify.getId();
//        }
        try {
            Map<String, Object> variables = Maps.newHashMap();
            oaEstimateApproveService.save(oaEstimateApprove, variables);
            addMessage(redirectAttributes, "流程已启动，流程ID：" + oaEstimateApprove.getProcInsId());
        } catch (Exception e) {
            logger.error("启动请假流程失败：", e);
            addMessage(redirectAttributes, "系统内部错误！");
        }
        return "redirect:" + adminPath + "/approve/estimate/oaEstimateApprove/form?id=" + oaEstimateApprove.getId();
    }


    @RequiresPermissions("approve:estimate:oaEstimateApprove:view")
    @RequestMapping(value = {"list", ""})
    public String list(OaEstimateApprove oaEstimateApprove, HttpServletRequest request, HttpServletResponse response, Model model) {
        Page<OaEstimateApprove> page = oaEstimateApproveService.findPage(new Page<OaEstimateApprove>(request, response), oaEstimateApprove);
        model.addAttribute("page", page);
        return "modules/approve/estimate/oaEstimateApproveList";
    }

    @RequiresPermissions("approve:estimate:oaEstimateApprove:view")
    @RequestMapping(value = "form")
    public String form(OaEstimateApprove oaEstimateApprove, Model model) {
        model.addAttribute("oaEstimateApprove", oaEstimateApprove);
        model.addAttribute("isForEdit", true);

        // 角色拼接，页面片段以此判断是否显示
        StringBuilder roleStr = new StringBuilder();
        for (Role role : UserUtils.getRoleList()) roleStr.append(role.getEnname()).append(",");
        model.addAttribute("roleStr", roleStr.toString());

        String view = "oaEstimateApproveNext";
        // 查看审批申请单
        if (org.apache.commons.lang3.StringUtils.isNotBlank(oaEstimateApprove.getId())) {//.getAct().getProcInsId())){

            // 环节编号
            String taskDefKey = oaEstimateApprove.getAct().getTaskDefKey();
            model.addAttribute("taskDefKey", taskDefKey);

            if (StringUtils.isBlank(taskDefKey)) {
                view = "oaEstimateApproveView";
//                 修改环节
            } else if ("start".equals(taskDefKey)) {
                view = "oaEstimateApproveSubmit";
            }
            // 审核环节
            else if ("dept_say".equals(taskDefKey)) {
                view = "oaEstimateApproveNext";
                oaEstimateApprove.setBumenTime(new Date());
//				String formKey = "/oa/testAudit";
//				return "redirect:" + ActUtils.getFormUrl(formKey, testAudit.getAct());
            }
            // 审核环节2
            else if ("admin_say".equals(taskDefKey)) {
                view = "oaEstimateApproveNext";
                oaEstimateApprove.setAdminTime(new Date());
                oaEstimateApprove.setAdminUser(UserUtils.getUser());
            }
            // 审核环节3
            else if ("leader_say".equals(taskDefKey)) {
                view = "oaEstimateApproveNext";
                oaEstimateApprove.setLeaderTime(new Date());
            }
            // 审核环节4
            else if ("boss_say".equals(taskDefKey)) {
                view = "oaEstimateApproveNext";
                oaEstimateApprove.setBossTime(new Date());
                oaEstimateApprove.setBossUser(UserUtils.getUser());
                oaEstimateApprove.setBossResult("2"); // 不通过
                // 查看工单
            } else if (oaEstimateApprove.getAct().isFinishTask()) {
                view = "oaEstimateApproveView";
            }
        }
        return "modules/approve/estimate/" + view;
    }

    @RequiresPermissions("approve:estimate:oaEstimateApprove:view")
    @RequestMapping(value = "view")
    public String view(OaEstimateApprove oaEstimateApprove, Model model) {
        model.addAttribute("oaEstimateApprove", oaEstimateApprove);
        model.addAttribute("isForEdit", false);
        return "modules/approve/estimate/oaEstimateApproveView";
    }

    @RequiresPermissions("approve:estimate:oaEstimateApprove:edit")
    @RequestMapping(value = "save")
    public String save(OaEstimateApprove oaEstimateApprove, Model model, RedirectAttributes redirectAttributes) {
        if (!beanValidator(model, oaEstimateApprove)) {
            return form(oaEstimateApprove, model);
        }
        oaEstimateApproveService.save(oaEstimateApprove);
        addMessage(redirectAttributes, "保存评分审批成功");
        return "redirect:" + Global.getAdminPath() + "/approve/estimate/oaEstimateApprove/?repage";
    }

    /**
     * 工单执行（完成任务）
     *
     * @param oaEstimateApprove
     * @param model
     * @return
     */
    @RequiresPermissions("approve:estimate:oaEstimateApprove:edit")
    @RequestMapping(value = "saveSuggestions")
    public String saveSuggestions(OaEstimateApprove oaEstimateApprove, Model model) {
//        if (org.apache.commons.lang3.StringUtils.isBlank(oaEstimateApprove.getAct().getFlag())
//                || org.apache.commons.lang3.StringUtils.isBlank(oaEstimateApprove.getAct().getComment())){
//            addMessage(model, "请填写审核意见。");
//            return form(oaEstimateApprove, model);
//        }
        oaEstimateApproveService.estimateApproveSave(oaEstimateApprove);
        return "redirect:" + adminPath + "/act/task/todo/";
    }

    @RequiresPermissions("approve:estimate:oaEstimateApprove:edit")
    @RequestMapping(value = "delete")
    public String delete(OaEstimateApprove oaEstimateApprove, RedirectAttributes redirectAttributes) {
        oaEstimateApproveService.delete(oaEstimateApprove);
        addMessage(redirectAttributes, "删除评分审批成功");
        return "redirect:" + Global.getAdminPath() + "/approve/estimate/oaEstimateApprove/?repage";
    }

}