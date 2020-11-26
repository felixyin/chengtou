/**
 * Copyright &copy; 2016-2017 HZC All rights reserved.
 */
package com.hzc.aams.modules.atten.entity;

import com.hzc.aams.modules.sys.entity.User;

import com.hzc.aams.common.persistence.DataEntity;

/**
 * 考勤管理Entity
 * @author 李云涛
 * @version 2017-08-08
 */
public class AamsAtten extends DataEntity<AamsAtten> {
	
	private static final long serialVersionUID = 1L;
	private User user;		// 用户编码
	private Integer year;		// 年
	private Integer month;		// 月份
	private Integer days;		// 天数
	private String day1;		// 分数
	private String day2;		// 分数
	private String day3;		// 分数
	private String day4;		// 分数
	private String day5;		// 分数
	private String day6;		// 分数
	private String day7;		// 分数
	private String day8;		// 分数
	private String day9;		// 分数
	private String day10;		// 分数
	private String day11;		// 分数
	private String day12;		// 分数
	private String day13;		// 分数
	private String day14;		// 分数
	private String day15;		// 分数
	private String day16;		// 分数
	private String day17;		// 分数
	private String day18;		// 分数
	private String day19;		// 分数
	private String day20;		// 分数
	private String day21;		// 分数
	private String day22;		// 分数
	private String day23;		// 分数
	private String day24;		// 分数
	private String day25;		// 分数
	private String day26;		// 分数
	private String day27;		// 分数
	private String day28;		// 分数
	private String day29;		// 分数
	private String day30;		// 分数
	private String day31;		// 分数
	private Integer workDays;		// 工作天数
	private Integer realDays;		// 实际出勤天数
	private Integer queqinDays;		// 缺勤天数
	private Integer score;		// 扣分

	private String column; // 更新的列
	private Integer currentScore; // 本次扣分

	public AamsAtten() {
		super();
	}

	public AamsAtten(String id){
		super(id);
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public Integer getYear() {
		return year;
	}

	public void setYear(Integer year) {
		this.year = year;
	}

	public Integer getMonth() {
		return month;
	}

	public void setMonth(Integer month) {
		this.month = month;
	}

	public Integer getDays() {
		return days;
	}

	public void setDays(Integer days) {
		this.days = days;
	}

	public String getDay1() {
		return day1;
	}

	public void setDay1(String day1) {
		this.day1 = day1;
	}

	public String getDay2() {
		return day2;
	}

	public void setDay2(String day2) {
		this.day2 = day2;
	}

	public String getDay3() {
		return day3;
	}

	public void setDay3(String day3) {
		this.day3 = day3;
	}

	public String getDay4() {
		return day4;
	}

	public void setDay4(String day4) {
		this.day4 = day4;
	}

	public String getDay5() {
		return day5;
	}

	public void setDay5(String day5) {
		this.day5 = day5;
	}

	public String getDay6() {
		return day6;
	}

	public void setDay6(String day6) {
		this.day6 = day6;
	}

	public String getDay7() {
		return day7;
	}

	public void setDay7(String day7) {
		this.day7 = day7;
	}

	public String getDay8() {
		return day8;
	}

	public void setDay8(String day8) {
		this.day8 = day8;
	}

	public String getDay9() {
		return day9;
	}

	public void setDay9(String day9) {
		this.day9 = day9;
	}

	public String getDay10() {
		return day10;
	}

	public void setDay10(String day10) {
		this.day10 = day10;
	}

	public String getDay11() {
		return day11;
	}

	public void setDay11(String day11) {
		this.day11 = day11;
	}

	public String getDay12() {
		return day12;
	}

	public void setDay12(String day12) {
		this.day12 = day12;
	}

	public String getDay13() {
		return day13;
	}

	public void setDay13(String day13) {
		this.day13 = day13;
	}

	public String getDay14() {
		return day14;
	}

	public void setDay14(String day14) {
		this.day14 = day14;
	}

	public String getDay15() {
		return day15;
	}

	public void setDay15(String day15) {
		this.day15 = day15;
	}

	public String getDay16() {
		return day16;
	}

	public void setDay16(String day16) {
		this.day16 = day16;
	}

	public String getDay17() {
		return day17;
	}

	public void setDay17(String day17) {
		this.day17 = day17;
	}

	public String getDay18() {
		return day18;
	}

	public void setDay18(String day18) {
		this.day18 = day18;
	}

	public String getDay19() {
		return day19;
	}

	public void setDay19(String day19) {
		this.day19 = day19;
	}

	public String getDay20() {
		return day20;
	}

	public void setDay20(String day20) {
		this.day20 = day20;
	}

	public String getDay21() {
		return day21;
	}

	public void setDay21(String day21) {
		this.day21 = day21;
	}

	public String getDay22() {
		return day22;
	}

	public void setDay22(String day22) {
		this.day22 = day22;
	}

	public String getDay23() {
		return day23;
	}

	public void setDay23(String day23) {
		this.day23 = day23;
	}

	public String getDay24() {
		return day24;
	}

	public void setDay24(String day24) {
		this.day24 = day24;
	}

	public String getDay25() {
		return day25;
	}

	public void setDay25(String day25) {
		this.day25 = day25;
	}

	public String getDay26() {
		return day26;
	}

	public void setDay26(String day26) {
		this.day26 = day26;
	}

	public String getDay27() {
		return day27;
	}

	public void setDay27(String day27) {
		this.day27 = day27;
	}

	public String getDay28() {
		return day28;
	}

	public void setDay28(String day28) {
		this.day28 = day28;
	}

	public String getDay29() {
		return day29;
	}

	public void setDay29(String day29) {
		this.day29 = day29;
	}

	public String getDay30() {
		return day30;
	}

	public void setDay30(String day30) {
		this.day30 = day30;
	}

	public String getDay31() {
		return day31;
	}

	public void setDay31(String day31) {
		this.day31 = day31;
	}

	public Integer getWorkDays() {
		return workDays;
	}

	public void setWorkDays(Integer workDays) {
		this.workDays = workDays;
	}

	public Integer getRealDays() {
		return realDays;
	}

	public void setRealDays(Integer realDays) {
		this.realDays = realDays;
	}

	public Integer getQueqinDays() {
		return queqinDays;
	}

	public void setQueqinDays(Integer queqinDays) {
		this.queqinDays = queqinDays;
	}

	public Integer getScore() {
		return score;
	}

	public void setScore(Integer score) {
		this.score = score;
	}

	public String getColumn() {
		return column;
	}

	public void setColumn(String column) {
		this.column = column;
	}

	public Integer getCurrentScore() {
		return currentScore;
	}

	public void setCurrentScore(Integer currentScore) {
		this.currentScore = currentScore;
	}
}