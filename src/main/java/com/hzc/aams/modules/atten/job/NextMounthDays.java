package com.hzc.aams.modules.atten.job;

import com.hzc.aams.common.utils.DateUtils;
import com.hzc.aams.modules.atten.entity.AamsAtten;
import com.hzc.aams.modules.atten.service.AamsAttenService;
import com.hzc.aams.modules.sys.dao.UserDao;
import com.hzc.aams.modules.sys.entity.User;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.text.ParseException;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.function.Predicate;

import static java.util.Calendar.MONTH;
import static java.util.Calendar.YEAR;

/**
 * @Autor 李xx
 * <p>
 * 定时任务：生成一下月的用户考勤数据，在当前月的29号晚上11点
 */
@Service
@Lazy(false)
public class NextMounthDays {

    @Autowired
    private UserDao userDao;

    @Autowired
    private AamsAttenService aamsAttenService;

    /**
     * oron: 每月的晚上11点执行次方法
     */
    @Scheduled(cron = "0 30 23 29 * ?")
    public void genData() throws ParseException {
//      查询所有用户
        List<User> allUser = userDao.findAllUser();
        allUser.removeIf(new Predicate<User>() { // 生成考勤数据时需要排除admin、felixyin账号
            public boolean test(User user) {
                String loginName = user.getLoginName();
                return "admin".equalsIgnoreCase(loginName) || "felixyin".equalsIgnoreCase(loginName);
            }
        });

//      计算下一月份的年份和月份
        Calendar c = Calendar.getInstance();
//        if (StringUtils.isNoneBlank(date)) {
//            c.setTime(org.apache.commons.lang3.time.DateUtils.parseDate(date, "yyyy-MM"));
//        }
        int year = c.get(YEAR);
        int month = c.get(MONTH) + 1;
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
            aamsAtten.setCreateDate(new Date());
            aamsAtten.setDelFlag("0");

            aamsAttenService.save(aamsAtten);
        }
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
            List<AamsAtten> list = aamsAttenService.findList(aamsAtten);
            if (null == list || list.isEmpty()) {
                aamsAtten.setCreateDate(new Date());
                aamsAtten.setDelFlag("0");
                aamsAttenService.save(aamsAtten);
            }
        }
    }

}
