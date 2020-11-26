/**
 * Copyright &copy; 2016-2017 HZC All rights reserved.
 */
package com.hzc.aams.common.utils;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.apache.commons.lang3.time.DateFormatUtils;

/**
 * 日期工具类, 继承org.apache.commons.lang.time.DateUtils类
 *
 * @author ThinkGem
 * @version 2014-4-15
 */
public class DateUtils extends org.apache.commons.lang3.time.DateUtils {

    private static String[] parsePatterns = {
            "yyyy-MM-dd", "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm", "yyyy-MM",
            "yyyy/MM/dd", "yyyy/MM/dd HH:mm:ss", "yyyy/MM/dd HH:mm", "yyyy/MM",
            "yyyy.MM.dd", "yyyy.MM.dd HH:mm:ss", "yyyy.MM.dd HH:mm", "yyyy.MM"};

    /**
     * 得到当前日期字符串 格式（yyyy-MM-dd）
     */
    public static String getDate() {
        return getDate("yyyy-MM-dd");
    }

    /**
     * 得到当前日期字符串 格式（yyyy-MM-dd） pattern可以为："yyyy-MM-dd" "HH:mm:ss" "E"
     */
    public static String getDate(String pattern) {
        return DateFormatUtils.format(new Date(), pattern);
    }

    /**
     * 得到日期字符串 默认格式（yyyy-MM-dd） pattern可以为："yyyy-MM-dd" "HH:mm:ss" "E"
     */
    public static String formatDate(Date date, Object... pattern) {
        String formatDate = null;
        if (pattern != null && pattern.length > 0) {
            formatDate = DateFormatUtils.format(date, pattern[0].toString());
        } else {
            formatDate = DateFormatUtils.format(date, "yyyy-MM-dd");
        }
        return formatDate;
    }

    /**
     * 得到日期时间字符串，转换格式（yyyy-MM-dd HH:mm:ss）
     */
    public static String formatDateTime(Date date) {
        return formatDate(date, "yyyy-MM-dd HH:mm:ss");
    }

    /**
     * 得到当前时间字符串 格式（HH:mm:ss）
     */
    public static String getTime() {
        return formatDate(new Date(), "HH:mm:ss");
    }

    /**
     * 得到当前日期和时间字符串 格式（yyyy-MM-dd HH:mm:ss）
     */
    public static String getDateTime() {
        return formatDate(new Date(), "yyyy-MM-dd HH:mm:ss");
    }

    /**
     * 得到当前年份字符串 格式（yyyy）
     */
    public static String getYear() {
        return formatDate(new Date(), "yyyy");
    }

    /**
     * 得到当前月份字符串 格式（MM）
     */
    public static String getMonth() {
        return formatDate(new Date(), "MM");
    }

    /**
     * 得到当天字符串 格式（dd）
     */
    public static String getDay() {
        return formatDate(new Date(), "dd");
    }

    /**
     * 得到当前星期字符串 格式（E）星期几
     */
    public static String getWeek() {
        return formatDate(new Date(), "E");
    }

    /**
     * 日期型字符串转化为日期 格式
     * { "yyyy-MM-dd", "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm",
     * "yyyy/MM/dd", "yyyy/MM/dd HH:mm:ss", "yyyy/MM/dd HH:mm",
     * "yyyy.MM.dd", "yyyy.MM.dd HH:mm:ss", "yyyy.MM.dd HH:mm" }
     */
    public static Date parseDate(Object str) {
        if (str == null) {
            return null;
        }
        try {
            return parseDate(str.toString(), parsePatterns);
        } catch (ParseException e) {
            return null;
        }
    }

    /**
     * 获取过去的天数
     *
     * @param date
     * @return
     */
    public static long pastDays(Date date) {
        long t = new Date().getTime() - date.getTime();
        return t / (24 * 60 * 60 * 1000);
    }

    /**
     * 获取过去的小时
     *
     * @param date
     * @return
     */
    public static long pastHour(Date date) {
        long t = new Date().getTime() - date.getTime();
        return t / (60 * 60 * 1000);
    }

    /**
     * 获取过去的分钟
     *
     * @param date
     * @return
     */
    public static long pastMinutes(Date date) {
        long t = new Date().getTime() - date.getTime();
        return t / (60 * 1000);
    }

    /**
     * 转换为时间（天,时:分:秒.毫秒）
     *
     * @param timeMillis
     * @return
     */
    public static String formatDateTime(long timeMillis) {
        long day = timeMillis / (24 * 60 * 60 * 1000);
        long hour = (timeMillis / (60 * 60 * 1000) - day * 24);
        long min = ((timeMillis / (60 * 1000)) - day * 24 * 60 - hour * 60);
        long s = (timeMillis / 1000 - day * 24 * 60 * 60 - hour * 60 * 60 - min * 60);
        long sss = (timeMillis - day * 24 * 60 * 60 * 1000 - hour * 60 * 60 * 1000 - min * 60 * 1000 - s * 1000);
        return (day > 0 ? day + "," : "") + hour + ":" + min + ":" + s + "." + sss;
    }

    /**
     * 获取两个日期之间的天数
     *
     * @param before
     * @param after
     * @return
     */
    public static double getDistanceOfTwoDate(Date before, Date after) {
        long beforeTime = before.getTime();
        long afterTime = after.getTime();
        return (afterTime - beforeTime) / (1000 * 60 * 60 * 24);
    }


    /**
     * 获取某个月的每天和星期几的字符
     *
     * @param year
     * @param month
     * @return
     */
    public static List<String> getDayWeek(int year, int month) {
        int days = getDays(year, month);//getDays方法详细请往下看
        //days+1:day是总天数，输入月份的总天数只是这个月之前的天数，
        //加上1变为这个月开始的第一天
        int week = days % 7 == 0 ? 1 : days % 7 + 1;//开始的第一天是星期几

        //1~12月的个月天数
        int monthDay = getMonthDays(year, month);

        int len = week;
        List<String> dayList = new ArrayList<String>();
        String[] weekDays = {"日", "一", "二", "三", "四", "五", "六"};
        for (int i = 1; i <= monthDay; i++) {
            if (len == weekDays.length) len = 0;
            String s = i + " ";
            if (i < 10) s = s + "&nbsp;&nbsp;";
            dayList.add(s + weekDays[len++]);
        }
        return dayList;
    }

    public static int getMonthDays(int year, int month) {
        int monthDay;
        switch (month) {
            case 2:
                if (year % 4 == 0 && year % 100 != 0 || year % 400 == 0) {
                    monthDay = 29;
                } else {
                    monthDay = 28;
                }
                break;

            case 4:
            case 6:
            case 9:
            case 11:
                monthDay = 30;
                break;

            default:
                monthDay = 31;
                break;
        }
        return monthDay;
    }

    /*
        计算当年当月的距1900年1.1的总天数
    */
    public static int getDays(int year, int month) {
        //判断这年是闰年或者平年,得到年的总天数
        int day1 = 0, day2 = 0;

        for (int i = 1900; i < year; i++) {
            if (i % 4 == 0 && i % 100 != 0 || i % 400 == 0) {
                day1 += 366;
            } else {
                day1 += 365;
            }
        }

        //得到月的总天数
        for (int i = 1; i < month; i++) {
            switch (i) {
                case 2:
                    if (year % 4 == 0 && year % 100 != 0 || year % 400 == 0) {
                        day2 += 29;
                    } else {
                        day2 += 28;
                    }
                    break;

                case 4:
                case 6:
                case 9:
                case 11:
                    day2 += 30;
                    break;

                default:
                    day2 += 31;
                    break;
            }
        }

        return day1 + day2;

    }

    public static int getMonthDays() {
        Calendar c = Calendar.getInstance();
        return DateUtils.getMonthDays(c.get(Calendar.YEAR), c.get(Calendar.MONTH) + 1);
    }

    public static List<String> getDayWeek() {
        Calendar c = Calendar.getInstance();
        return DateUtils.getDayWeek(c.get(Calendar.YEAR), c.get(Calendar.MONTH) + 1);
    }

    /**
     * @param args
     * @throws ParseException
     */
    public static void main(String[] args) throws ParseException {
//		System.out.println(formatDate(parseDate("2010/3/6")));
//		System.out.println(getDate("yyyy年MM月dd日 E"));
//		long time = new Date().getTime()-parseDate("2012-11-19").getTime();
//		System.out.println(time/(24*60*60*1000));
        Calendar c = Calendar.getInstance();
        int year = c.get(Calendar.YEAR);
        System.out.println("\n当前年：" + year);

        int mouth = c.get(Calendar.MONTH);
        System.out.println("\n当前月：" + mouth);

        int monthDays = DateUtils.getMonthDays(year, mouth);
        System.out.println("\n某月中有几天：" + monthDays);
        System.out.println("\n每天和星期：");
        List<String> dayWeek = DateUtils.getDayWeek(year, mouth);
        for (String s : dayWeek) {
            System.out.println(s);
        }

    }
}
