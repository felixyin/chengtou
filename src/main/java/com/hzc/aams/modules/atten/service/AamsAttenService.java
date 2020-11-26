/**
 * Copyright &copy; 2016-2017 HZC All rights reserved.
 */
package com.hzc.aams.modules.atten.service;

import com.hzc.aams.common.persistence.Page;
import com.hzc.aams.common.service.CrudService;
import com.hzc.aams.common.utils.DateUtils;
import com.hzc.aams.modules.atten.dao.AamsAttenDao;
import com.hzc.aams.modules.atten.entity.AamsAtten;
import com.hzc.aams.modules.sys.dao.UserDao;
import com.hzc.aams.modules.sys.entity.User;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.function.Predicate;

import static java.util.Calendar.MONTH;
import static java.util.Calendar.YEAR;

/**
 * 考勤管理Service
 *
 * @author 李云涛
 * @version 2017-08-08
 */
@Service
@Transactional(readOnly = true)
public class AamsAttenService extends CrudService<AamsAttenDao, AamsAtten> {
    @Autowired
    private UserDao userDao;

    public AamsAtten get(String id) {
        return super.get(id);
    }

    public List<AamsAtten> findList(AamsAtten aamsAtten) {
//		aamsAtten.getSqlMap().put("dsf", dataScopeFilter(UserUtils.getUser(), "o6", "u2"));

        List<AamsAtten> list = super.findList(aamsAtten);
        // 增加类似excel表格行号
        for (int i = 0; i < list.size(); ) {
            AamsAtten atten = list.get(i);
            atten.setSeq(++i);
        }
        return list;
    }

    public Page<AamsAtten> findPage(Page<AamsAtten> page, AamsAtten aamsAtten) {
        Page<AamsAtten> page1 = super.findPage(page, aamsAtten);
        // 增加类似excel表格行号
        List<AamsAtten> list = page1.getList();
        for (int i = 0; i < list.size(); ) {
            AamsAtten atten = list.get(i);
            atten.setSeq(++i);
        }
        return page1;
    }

    @Transactional(readOnly = false)
    public void save(AamsAtten aamsAtten) {
        super.save(aamsAtten);
    }

    @Transactional(readOnly = false)
    public void delete(AamsAtten aamsAtten) {
        super.delete(aamsAtten);
    }

    @Transactional(readOnly = false)
    public void genKaoQin() throws ParseException {
//      查询所有用户
        List<User> allUser = userDao.findAllUser();
        allUser.removeIf(new Predicate<User>() { // 生成考勤数据时需要排除admin、felixyin账号
            public boolean test(User user) {
                String loginName = user.getLoginName();
                return "admin".equalsIgnoreCase(loginName) || "felixyin".equalsIgnoreCase(loginName);
            }
        });

        List<String> monthBetween = getMonthBetween("2016-01-01", "2019-12-04");
        for (String s : monthBetween) {
            genData(s);
        }
    }

    private static List<String> getMonthBetween(String minDate, String maxDate) throws ParseException {
        ArrayList<String> result = new ArrayList<String>();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");//格式化为年月

        Calendar min = Calendar.getInstance();
        Calendar max = Calendar.getInstance();

        min.setTime(sdf.parse(minDate));
        min.set(min.get(Calendar.YEAR), min.get(Calendar.MONTH), 1);

        max.setTime(sdf.parse(maxDate));
        max.set(max.get(Calendar.YEAR), max.get(Calendar.MONTH), 2);

        Calendar curr = min;
        while (curr.before(max)) {
            result.add(sdf.format(curr.getTime()));
            curr.add(Calendar.MONTH, 1);
        }

        return result;
    }

    public void genData(String date) throws ParseException {
//      查询所有用户
        List<User> allUser = userDao.findAllUser();

//      计算下一月份的年份和月份
        Calendar c = Calendar.getInstance();
        if (StringUtils.isNoneBlank(date)) {
            c.setTime(org.apache.commons.lang3.time.DateUtils.parseDate(date, "yyyy-MM"));
        }
        int year = c.get(YEAR);
        int month = c.get(MONTH);
        if (month >= 12) {
            ++year;
            month = 1;
        } else {
            ++month;
        }

//      计算某月的天数(下一月)
        int monthDays = DateUtils.getMonthDays(year, month);

//      批量插入所有用户的考勤数据（初始化用户考勤数据）
        for (User user : allUser) {
            AamsAtten aamsAtten = new AamsAtten();
            aamsAtten.setUser(user);
            aamsAtten.setYear(year);
            aamsAtten.setMonth(month);
            aamsAtten.setDays(monthDays);
            List<AamsAtten> list = this.findList(aamsAtten);
            if (null == list || list.isEmpty()) {
                aamsAtten.setCreateDate(new Date());
                aamsAtten.setDelFlag("0");
                this.save(aamsAtten);
            } else {
                System.out.println("已经存在考勤数据：" + user.getName() + ", " + year + "-" + month);
            }
        }
    }
}