/**
 * Copyright &copy; 2016-2017 HZC All rights reserved.
 */
package com.hzc.aams.modules.estimate.entity;

import com.hzc.aams.modules.sys.entity.Office;
import com.hzc.aams.modules.sys.entity.User;

import javax.validation.constraints.NotNull;

import com.hzc.aams.modules.sys.utils.DictUtils;
import org.hibernate.validator.constraints.Length;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import com.hzc.aams.common.persistence.DataEntity;

/**
 * 人员评分Entity
 *
 * @author 尹彬
 * @version 2017-07-08
 */
public class UserEstimateDetail extends DataEntity<UserEstimateDetail> {

    private static final long serialVersionUID = 1L;
    private long seq; //类似excel行号
    private UserEstimate user;        // 用户 父类
    private String companyId;        // 归属公司
    private Office office;        // 归属部门
    private String loginName;        // 登录名
    private String no;        // 工号
    private String name;        // 姓名
    private String email;        // 邮箱
    private String mobile;        // 手机
    private String userType;        // 用户类型
    private String projectId;        // 项目主键
    private String fraction;        // 分数
    private String evolve;        // 进展情况
    private String num;        // 项目编号
    private String level;        // 级别（全部）
    private String items;        // 督办事项
    private String source;        // 来源
    private String jobPlain;        // 工作计划
    private Date willFinishTime;        // 办结时限
    private Date estimateTime;        // 最后评估时间
    private String comments;        // 备注
    private Date endTime;        // 结束日期
    private String status;        // 状态(进行中)
    private String beginFraction;        // 开始 分数
    private String endFraction;        // 结束 分数
    private Date beginUpdateDate;        // 开始 评估时间
    private Date endUpdateDate;        // 结束 评估时间
    private Date beginEndTime;        // 开始 结束日期
    private Date endEndTime;        // 结束 结束日期
    private String userId;

    public UserEstimateDetail() {
        super();
    }

    public UserEstimateDetail(String id) {
        super(id);
    }

    public UserEstimateDetail(UserEstimate user) {
        this.user = user;
    }

    public long getSeq() {
        return seq;
    }

    public void setSeq(long seq) {
        this.seq = seq;
    }

    @NotNull(message = "用户不能为空")
    public UserEstimate getUser() {
        return user;
    }

    public void setUser(UserEstimate user) {
        this.user = user;
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

    @Length(min = 0, max = 64, message = "项目主键长度必须介于 0 和 64 之间")
    public String getProjectId() {
        return projectId;
    }

    public void setProjectId(String projectId) {
        this.projectId = projectId;
    }

    @Length(min = 0, max = 11, message = "分数长度必须介于 0 和 11 之间")
    public String getFraction() {
        return fraction;
    }

    public void setFraction(String fraction) {
        this.fraction = fraction;
    }

    @Length(min = 0, max = 255, message = "进展情况长度必须介于 0 和 255 之间")
    public String getEvolve() {
        return evolve;
    }

    public void setEvolve(String evolve) {
        this.evolve = evolve;
    }

    @Length(min = 0, max = 20, message = "项目编号长度必须介于 0 和 20 之间")
    public String getNum() {
        return num;
    }

    public void setNum(String num) {
        this.num = num;
    }

    @Length(min = 0, max = 500, message = "level长度必须介于 0 和 500 之间")
    public String getLevel() {
        return level;
    }

    public void setLevel(String level) {
        this.level = level;
    }

    @Length(min = 0, max = 500, message = "督办事项长度必须介于 0 和 500 之间")
    public String getItems() {
        return items;
    }

    public void setItems(String items) {
        this.items = items;
    }

    @Length(min = 0, max = 100, message = "来源长度必须介于 0 和 100 之间")
    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    @Length(min = 0, max = 500, message = "工作计划长度必须介于 0 和 500 之间")
    public String getJobPlain() {
        return jobPlain;
    }

    public void setJobPlain(String jobPlain) {
        this.jobPlain = jobPlain;
    }

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    public Date getWillFinishTime() {
        return willFinishTime;
    }

    public void setWillFinishTime(Date willFinishTime) {
        this.willFinishTime = willFinishTime;
    }

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    public Date getEstimateTime() {
        return estimateTime;
    }

    public void setEstimateTime(Date estimateTime) {
        this.estimateTime = estimateTime;
    }

    @Length(min = 0, max = 500, message = "备注长度必须介于 0 和 500 之间")
    public String getComments() {
        return comments;
    }

    public void setComments(String comments) {
        this.comments = comments;
    }

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    public Date getEndTime() {
        return endTime;
    }

    public void setEndTime(Date endTime) {
        this.endTime = endTime;
    }

    @Length(min = 0, max = 1, message = "状态长度必须介于 0 和 1 之间")
    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getBeginFraction() {
        return beginFraction;
    }

    public void setBeginFraction(String beginFraction) {
        this.beginFraction = beginFraction;
    }

    public String getEndFraction() {
        return endFraction;
    }

    public void setEndFraction(String endFraction) {
        this.endFraction = endFraction;
    }

    public Date getBeginUpdateDate() {
        return beginUpdateDate;
    }

    public void setBeginUpdateDate(Date beginUpdateDate) {
        this.beginUpdateDate = beginUpdateDate;
    }

    public Date getEndUpdateDate() {
        return endUpdateDate;
    }

    public void setEndUpdateDate(Date endUpdateDate) {
        this.endUpdateDate = endUpdateDate;
    }

    public Date getBeginEndTime() {
        return beginEndTime;
    }

    public void setBeginEndTime(Date beginEndTime) {
        this.beginEndTime = beginEndTime;
    }

    public Date getEndEndTime() {
        return endEndTime;
    }

    public void setEndEndTime(Date endEndTime) {
        this.endEndTime = endEndTime;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }
}