package com.hzc.aams.test;

import com.hzc.aams.common.utils.DateUtils;
import com.hzc.aams.modules.sys.utils.UserUtils;

import java.util.*;


class CalenderTest {

    public static void main(String[] args) {
        int monthDays = DateUtils.getMonthDays();
        System.out.println("\n当前月中有几天：" + monthDays);
        System.out.println("\n每天和星期：");

        List<String> dayWeek = DateUtils.getDayWeek();
        for (String s : dayWeek) {
            System.out.println(s);
        }

    }
}
