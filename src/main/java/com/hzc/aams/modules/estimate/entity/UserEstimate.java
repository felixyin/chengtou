/**
 * Copyright &copy; 2016-2017 HZC All rights reserved.
 */
package com.hzc.aams.modules.estimate.entity;

import org.hibernate.validator.constraints.Length;
import com.hzc.aams.modules.sys.entity.Office;

import javax.validation.constraints.NotNull;
import java.util.List;

import com.google.common.collect.Lists;

import com.hzc.aams.common.persistence.DataEntity;

/**
 * 人员评分Entity
 *
 * @author 尹彬
 * @version 2017-07-08
 */
public class UserEstimate extends DataEntity<UserEstimate> {

    private static final long serialVersionUID = 1L;
    private String companyId;        // 归属公司
    private Office office;        // 归属部门
    private String loginName;        // 登录名
    private String no;        // 工号
    private String name;        // 姓名
    private String email;        // 邮箱
    private String mobile;        // 手机
    private String userType;        // 用户类型
    private String year;        // 年度
    private Double fraction;        // 项目评分
    private Double attenFraction;    // 考勤扣分
    private Double zongFraction; // 总评分：项目平分-考勤扣分
    private Double fractionRatio;    // 比率后评分
    private Double ratio; // 年度内个人评分占年度总评分的比例
    private List<UserEstimateDetail> userEstimateDetailList = Lists.newArrayList();        // 子表列表

    public UserEstimate() {
        super();
    }

    public UserEstimate(String id) {
        super(id);
    }

    @Length(min = 1, max = 64, message = "归属公司长度必须介于 1 和 64 之间")
    public String getCompanyId() {
        return companyId;
    }

    public void setCompanyId(String companyId) {
        this.companyId = companyId;
    }

    @NotNull(message = "归属部门不能为空")
    public Office getOffice() {
        return office;
    }

    public void setOffice(Office office) {
        this.office = office;
    }

    @Length(min = 1, max = 100, message = "登录名长度必须介于 1 和 100 之间")
    public String getLoginName() {
        return loginName;
    }

    public void setLoginName(String loginName) {
        this.loginName = loginName;
    }

    @Length(min = 0, max = 100, message = "工号长度必须介于 0 和 100 之间")
    public String getNo() {
        return no;
    }

    public void setNo(String no) {
        this.no = no;
    }

    @Length(min = 1, max = 100, message = "姓名长度必须介于 1 和 100 之间")
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Length(min = 0, max = 200, message = "邮箱长度必须介于 0 和 200 之间")
    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    @Length(min = 0, max = 200, message = "手机长度必须介于 0 和 200 之间")
    public String getMobile() {
        return mobile;
    }

    public void setMobile(String mobile) {
        this.mobile = mobile;
    }

    @Length(min = 0, max = 1, message = "用户类型长度必须介于 0 和 1 之间")
    public String getUserType() {
        return userType;
    }

    public void setUserType(String userType) {
        this.userType = userType;
    }

    public String getYear() {
        return year;
    }

    public void setYear(String year) {
        this.year = year;
    }

    public Double getAttenFraction() {
        return attenFraction;
    }

    public void setAttenFraction(Double attenFraction) {
        this.attenFraction = attenFraction;
    }

    public Double getZongFraction() {
        return zongFraction;
    }

    public void setZongFraction(Double zongFraction) {
        this.zongFraction = zongFraction;
    }

    public List<UserEstimateDetail> getUserEstimateDetailList() {
        return userEstimateDetailList;
    }

    public void setUserEstimateDetailList(List<UserEstimateDetail> userEstimateDetailList) {
        this.userEstimateDetailList = userEstimateDetailList;
    }

    public Double getFraction() {
        return fraction;
    }

    public void setFraction(Double fraction) {
        this.fraction = fraction;
    }

    public Double getFractionRatio() {
        return fractionRatio;
    }

    public void setFractionRatio(Double fractionRatio) {
        this.fractionRatio = fractionRatio;
    }

    public Double getRatio() {
        return ratio;
    }

    public void setRatio(Double ratio) {
        this.ratio = ratio;
    }
}