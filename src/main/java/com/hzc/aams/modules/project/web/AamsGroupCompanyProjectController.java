/**
 * Copyright &copy; 2016-2017 HZC All rights reserved.
 */
package com.hzc.aams.modules.project.web;

import com.hzc.aams.common.config.Global;
import com.hzc.aams.common.persistence.Page;
import com.hzc.aams.common.utils.StringUtils;
import com.hzc.aams.common.web.BaseController;
import com.hzc.aams.modules.project.entity.AamsProject;
import com.hzc.aams.modules.project.entity.AamsProjectUser;
import com.hzc.aams.modules.project.service.AamsProjectService;
import com.hzc.aams.modules.sys.entity.Role;
import com.hzc.aams.modules.sys.service.GodService;
import com.hzc.aams.modules.sys.utils.DictUtils;
import com.hzc.aams.modules.sys.utils.UserUtils;
import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.lang.reflect.InvocationTargetException;
import java.util.List;

/**
 * 督办项目Controller
 *
 * @author 尹彬
 * @version 2017-07-05
 */
@Controller
@RequestMapping(value = "${adminPath}/project/group")
public class AamsGroupCompanyProjectController extends BaseController {

    @Autowired
    private AamsProjectService aamsProjectService;

    @Autowired
    private GodService godService;

    @ModelAttribute
    public AamsProject get(@RequestParam(required = false) String id) {
        AamsProject entity = null;
        if (StringUtils.isNotBlank(id)) {
            entity = aamsProjectService.get(id);
        }
        if (entity == null) {
            entity = new AamsProject();
        }
        return entity;
    }

    @RequiresPermissions({"project:group:view"})
    @RequestMapping(value = {"list", ""})
    public String list(AamsProject aamsProject, HttpServletRequest request, HttpServletResponse response, Model model) {
//        搜索表单，设置默认下拉框选中
        if (StringUtils.isBlank(aamsProject.getType())) {
            aamsProject.setType(DictUtils.getDictValue("集团督办", "project_type", "1"));
        }
        if (StringUtils.isBlank(aamsProject.getLevel())) {
            aamsProject.setLevel(DictUtils.getDictValue("全部", "project_level", "-1"));
        }

        setSessionStatus(aamsProject, request);

        Page<AamsProject> page = aamsProjectService.findPage(new Page<AamsProject>(request, response), aamsProject);
        model.addAttribute("page", page);
        model.addAttribute("aamsProject", aamsProject);
        return "modules/project/group/list";
    }

    @RequiresPermissions("project:group:view")
    @RequestMapping(value = "form")
    public String form(AamsProject aamsProject, Model model) {
//       添加督办项目界面，设置默认下拉框选中
        if (StringUtils.isBlank(aamsProject.getType())) {
            aamsProject.setType(DictUtils.getDictValue("集团督办", "project_type", "1"));
        }
        if (StringUtils.isBlank(aamsProject.getLevel())) {
            aamsProject.setLevel(DictUtils.getDictValue("继续督办", "project_level", "2"));
        }
        if (StringUtils.isBlank(aamsProject.getStatus())) {
            aamsProject.setStatus(DictUtils.getDictValue("进行中", "project_types", "3"));
        }
//        如果当前登录用户角色是部门长或分管领导，则状态默认是未审批，
//        boolean isBmzOrFgld =   isBmzOrFgld();
//        if (isBmzOrFgld) {
//            aamsProject.setStatus(DictUtils.getDictValue("未审批", "project_types", "4"));
//            model.addAttribute("project_types_readonly", true);
//        } else {
//            model.addAttribute("project_types_readonly", false);
//        }
        model.addAttribute("aamsProject", aamsProject);
        model.addAttribute("isForEdit", true);
        return "modules/project/group/form";
    }

    /**
     * 登录用户角色是部门长或分管领导
     *
     * @return
     */
    private boolean isBmzOrFgld() {
        boolean is = false;
        List<Role> roleList = UserUtils.getUser().getRoleList();
        for (Role role : roleList) {
            String enname = role.getEnname();
            if (StringUtils.equals(enname, "b") || StringUtils.equals(enname, "f")) {
                is = true;
                break;
            }
        }
        return is;
    }

    @RequiresPermissions("project:group:view")
    @RequestMapping(value = "view")
    public String view(AamsProject aamsProject, Model model) {
        model.addAttribute("aamsProject", aamsProject);
        model.addAttribute("isForEdit", false);
        return "modules/project/group/view";
    }

    @RequiresPermissions(value = {"project:group:save", "project:group:submit"}, logical = Logical.OR)
    @RequestMapping(value = "save")
    public String save(AamsProject aamsProject, Model model, RedirectAttributes redirectAttributes) {
        if (!beanValidator(model, aamsProject)) {
            return form(aamsProject, model);
        }
        List<AamsProjectUser> aamsProjectUserList = aamsProject.getAamsProjectUserList();
        if (aamsProjectUserList.size() == 0) {
            addMessage(model, "项目负责人必选！");
            return form(aamsProject, model);
        }
        if (StringUtils.isBlank(aamsProject.getId())) { //inesrt ，生成序列号
            aamsProject.setNum(godService.genSeq());
        }
        aamsProjectService.save(aamsProject);
        addMessage(redirectAttributes, "保存督办项目成功");
        return "redirect:" + Global.getAdminPath() + "/project/group/?repage";
    }

    @RequiresPermissions("project:group:delete")
    @RequestMapping(value = "delete")
    public String delete(AamsProject aamsProject, RedirectAttributes redirectAttributes) {
        aamsProjectService.delete(aamsProject);
        addMessage(redirectAttributes, "删除督办项目成功");
        return "redirect:" + Global.getAdminPath() + "/project/group/?repage";
    }

    @RequiresPermissions("project:group:order")
    @RequestMapping(value = "saveOrderNum")
    @ResponseBody
    public boolean saveOrderNum(@RequestBody List<AamsProject> aamsProjectList) throws InvocationTargetException, IllegalAccessException {
        return aamsProjectService.saveOrderNum(aamsProjectList);
    }
}