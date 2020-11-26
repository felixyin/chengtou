/**
 * Copyright &copy; 2016-2017 HZC All rights reserved.
 */
package com.hzc.aams.modules.atten.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.hzc.aams.common.utils.DateUtils;
import com.hzc.aams.modules.atten.job.NextMounthDays;
import com.hzc.aams.modules.sys.utils.DictUtils;
import com.hzc.aams.modules.sys.utils.UserUtils;
import org.apache.commons.lang3.math.NumberUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.hzc.aams.common.config.Global;
import com.hzc.aams.common.persistence.Page;
import com.hzc.aams.common.web.BaseController;
import com.hzc.aams.common.utils.StringUtils;
import com.hzc.aams.modules.atten.entity.AamsAtten;
import com.hzc.aams.modules.atten.service.AamsAttenService;

import java.lang.reflect.Field;
import java.text.ParseException;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static java.util.Calendar.MONTH;
import static java.util.Calendar.YEAR;
import static oracle.net.aso.C01.k;

/**
 * 考勤管理Controller
 *
 * @author 李云涛
 * @version 2017-08-08
 */
@Controller
@RequestMapping(value = "${adminPath}/atten/aamsAtten")
public class AamsAttenController extends BaseController {

    @Autowired
    private AamsAttenService aamsAttenService;

    @Autowired
    private NextMounthDays nextMounthDays;

    @ModelAttribute
    public AamsAtten get(@RequestParam(required = false) String id) {
        AamsAtten entity = null;
        if (StringUtils.isNotBlank(id)) {
            entity = aamsAttenService.get(id);
        }
        if (entity == null) {
            entity = new AamsAtten();
        }
        return entity;
    }

    @RequiresPermissions("atten:aamsAtten:view")
    @RequestMapping(value = {"list", ""})
    public String list(AamsAtten aamsAtten, HttpServletRequest request, HttpServletResponse response, Model model) {
        String userId = request.getParameter("userId");
        String year1 = request.getParameter("year");
        if (StringUtils.isNotBlank(userId)) aamsAtten.setUser(UserUtils.get(userId));
        if (StringUtils.isNotBlank(year1)) aamsAtten.setYear(Integer.parseInt(year1));

        Integer year = aamsAtten.getYear();
        Integer month = aamsAtten.getMonth();

        Calendar c = Calendar.getInstance();
        if (null == year) year = c.get(Calendar.YEAR);
        if (null == month) month = c.get(Calendar.MONTH) + 1;
        aamsAtten.setYear(year);
        aamsAtten.setMonth(month);
//        if (month >= 12) {
//            ++year;
//            month = 1;
//        } else {
//            ++month;
//        }

        List<AamsAtten> list = aamsAttenService.findList(aamsAtten);
        model.addAttribute("list", list);

        List<String> dayWeek = DateUtils.getDayWeek(year, month);
        model.addAttribute("dayWeek", dayWeek);
        model.addAttribute("dayCount", dayWeek.size());


        return "modules/atten/aamsAttenList";
    }

    /**
     * TODO 需要删除
     *
     * @param aamsAtten
     * @param model
     * @return
     */
    @RequiresPermissions("atten:aamsAtten:view")
    @RequestMapping(value = "genData")
    public
    @ResponseBody
    Map genData(AamsAtten aamsAtten, HttpServletRequest request, Model model) throws ParseException {
        String date = request.getParameter("date");
        nextMounthDays.genData(date);
        Map map = new HashMap();
        map.put("isSuccess", true);
        return map;
    }

    @RequiresPermissions("atten:aamsAtten:edit")
    @RequestMapping(value = "quanQin")
    public
    @ResponseBody
    Map quanQin(AamsAtten aamsAtten, Model model) throws NoSuchFieldException, IllegalAccessException {
        int sumScore = 0;
        Class<? extends AamsAtten> aClass = aamsAtten.getClass();
        for (int i = 1; i <= 31; i++) {
            Field declaredField = aClass.getDeclaredField("day" + i);
            declaredField.setAccessible(true);
            String dayValue = (String) declaredField.get(aamsAtten);
            if (null != dayValue) {
                String scoreStr = DictUtils.getDictValue(dayValue, "atten_leave_type", "");
                if (StringUtils.isNotBlank(scoreStr)) {
                    sumScore += Integer.parseInt(scoreStr);
                }
            }
        }
        System.out.println(sumScore);
        aamsAtten.setScore(sumScore);
        aamsAttenService.save(aamsAtten);
        Map map = new HashMap();
        map.put("isOk", true);
        map.put("currentScore", aamsAtten.getScore());
        return map;
    }

    @RequiresPermissions("atten:aamsAtten:edit")
    @RequestMapping(value = "updateScore")
    public
    @ResponseBody
    Map updateScore(AamsAtten aamsAtten, Model model) throws NoSuchFieldException, IllegalAccessException {
//        String column = aamsAtten.getColumn();
//        Class<? extends AamsAtten> aClass = aamsAtten.getClass();
//        Field declaredField = aClass.getDeclaredField(column);
//        declaredField.setAccessible(true);
//        declaredField.setInt(aamsAtten, aamsAtten.getCurrentScore());
        int sumScore = 0;
        Class<? extends AamsAtten> aClass = aamsAtten.getClass();
        for (int i = 1; i <= 31; i++) {
            Field declaredField = aClass.getDeclaredField("day" + i);
            declaredField.setAccessible(true);
            String dayValue = (String) declaredField.get(aamsAtten);
            if (null != dayValue) {
                String scoreStr = DictUtils.getDictValue(dayValue, "atten_leave_type", "");
                if (StringUtils.isNotBlank(scoreStr)) {
                    sumScore += Integer.parseInt(scoreStr);
                }
            }
        }
        System.out.println(sumScore);
        aamsAtten.setScore(sumScore);

        aamsAttenService.save(aamsAtten);
        Map map = new HashMap();
        map.put("isSuccess", true);
        map.put("currentScore", aamsAtten.getScore());
        return map;
    }


    @RequiresPermissions("atten:aamsAtten:view")
    @RequestMapping(value = "form")
    public String form(AamsAtten aamsAtten, Model model) {
        model.addAttribute("aamsAtten", aamsAtten);
        model.addAttribute("isForEdit", true);
        return "modules/atten/aamsAttenForm";
    }

    @RequiresPermissions("atten:aamsAtten:view")
    @RequestMapping(value = "view")
    public String view(AamsAtten aamsAtten, Model model) {
        model.addAttribute("aamsAtten", aamsAtten);
        model.addAttribute("isForEdit", false);
        return "modules/atten/aamsAttenView";
    }

    @RequiresPermissions("atten:aamsAtten:edit")
    @RequestMapping(value = "save")
    public String save(AamsAtten aamsAtten, Model model, RedirectAttributes redirectAttributes) {
        if (!beanValidator(model, aamsAtten)) {
            return form(aamsAtten, model);
        }
        aamsAttenService.save(aamsAtten);
        addMessage(redirectAttributes, "保存考勤成功");
        return "redirect:" + Global.getAdminPath() + "/atten/aamsAtten/?repage";
    }

    @RequiresPermissions("atten:aamsAtten:edit")
    @RequestMapping(value = "delete")
    public String delete(AamsAtten aamsAtten, RedirectAttributes redirectAttributes) {
        aamsAttenService.delete(aamsAtten);
        addMessage(redirectAttributes, "删除考勤成功");
        return "redirect:" + Global.getAdminPath() + "/atten/aamsAtten/?repage";
    }


    @RequiresPermissions("atten:aamsAtten:view")
    @RequestMapping(value = {"genKaoQin"})
    public String genKaoQin(HttpServletRequest request, HttpServletResponse response, Model model) {
        try {
            aamsAttenService.genKaoQin();
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return "redirect:" + Global.getAdminPath() + "/atten/aamsAtten/list";
    }

}