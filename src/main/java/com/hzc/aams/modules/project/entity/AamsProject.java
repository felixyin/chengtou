/**
 * Copyright &copy; 2016-2017 HZC All rights reserved.
 */
package com.hzc.aams.modules.project.entity;

import com.hzc.aams.common.utils.StringUtils;
import com.hzc.aams.modules.sys.utils.DictUtils;
import com.hzc.aams.modules.sys.utils.UserUtils;
import org.hibernate.validator.constraints.Length;
import com.hzc.aams.modules.sys.entity.Office;

import javax.validation.constraints.NotNull;
import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.util.List;

import com.google.common.collect.Lists;

import com.hzc.aams.common.persistence.DataEntity;

/**
 * 督办项目Entity
 *
 * @author 尹彬
 * @version 2017-07-05
 */
public class AamsProject extends DataEntity<AamsProject> {

    private static final long serialVersionUID = 1L;
    private String type; //督办类型
    private String num;        // 编号
    private String level;        // 级别（继续督办）
    private String items;        // 督办事项
    private String source;        // 来源
    private Office office;        // 责任部门
    private String userNames; // 用户逗号分隔
    private String jobPlain;        // 工作计划
    private Date willFinishTime;        // 办结时限
    private String evolve;        // 进展情况
    private String estimate;        // 评分总计
    private Date estimateTime;        // 评分时间
    private String comments;        // 备注
    private Date endTime;        // 结束日期
    private String files;        // 附件
    private String orderNum;        // 列表排序
    private String status;        // 状态(进行中)
    private Date beginWillFinishTime;        // 开始 办结时限
    private Date endWillFinishTime;        // 结束 办结时限
    private Date beginEstimateTime;        // 开始 评分时间
    private Date endEstimateTime;        // 结束 评分时间
    private Date beginEndTime;        // 开始 结束日期
    private Date endEndTime;        // 结束 结束日期
    private Date beginUpdateDate;        // 开始 更新时间
    private Date endUpdateDate;        // 结束 更新时间
    private List<AamsProjectUser> aamsProjectUserList = Lists.newArrayList();        // 子表列表

    public AamsProject() {
        super();
    }

    public AamsProject(String id) {
        super(id);
    }

    @Length(min = 0, max = 1, message = "类型长度必须介于 0 和 1 之间")
    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    @Length(min = 1, max = 20, message = "编号长度必须介于 1 和 20 之间")
    public String getNum() {
        return num;
    }

    public void setNum(String num) {
        this.num = num;
    }

    @Length(min = 0, max = 1, message = "级别长度必须介于 0 和 1 之间")
    public String getLevel() {
        return level;
    }

    public void setLevel(String level) {
        this.level = level;
    }

    @Length(min = 1, max = 5000, message = "督办事项长度必须介于 1 和 5000 之间")
    public String getItems() {
        return items;
    }

    public void setItems(String items) {
        this.items = items;
    }

    @Length(min = 1, max = 100, message = "来源长度必须介于 1 和 100 之间")
    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    @NotNull(message = "责任部门不能为空")
    public Office getOffice() {
        return office;
    }

    public void setOffice(Office office) {
        this.office = office;
    }

    public String getUserNames() {
        return userNames;
    }

    public void setUserNames(String userNames) {
        this.userNames = userNames;
    }

    @Length(min = 1, max = 5000, message = "工作计划长度必须介于 1 和 5000 之间")
    public String getJobPlain() {
        return jobPlain;
    }

    public void setJobPlain(String jobPlain) {
        this.jobPlain = jobPlain;
    }

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @NotNull(message = "办结时限不能为空")
    public Date getWillFinishTime() {
        return willFinishTime;
    }

    public void setWillFinishTime(Date willFinishTime) {
        this.willFinishTime = willFinishTime;
    }

    @Length(min = 1, max = 500, message = "进展情况长度必须介于 1 和 500 之间")
    public String getEvolve() {
        return evolve;
    }

    public void setEvolve(String evolve) {
        this.evolve = evolve;
    }

    @Length(min = 0, max = 255, message = "评分总计长度必须介于 0 和 255 之间")
    public String getEstimate() {
        return estimate;
    }

    public void setEstimate(String estimate) {
        this.estimate = estimate;
    }

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    public Date getEstimateTime() {
        return estimateTime;
    }

    public void setEstimateTime(Date estimateTime) {
        this.estimateTime = estimateTime;
    }

    @Length(min = 0, max = 2000, message = "备注长度必须介于 0 和 2000 之间")
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

    @Length(min = 0, max = 500, message = "附件长度必须介于 0 和 500 之间")
    public String getFiles() {
        return files;
    }

    public void setFiles(String files) {
        this.files = files;
    }

    @Length(min = 0, max = 11, message = "列表排序长度必须介于 0 和 11 之间")
    public String getOrderNum() {
        return orderNum;
    }

    public void setOrderNum(String orderNum) {
        this.orderNum = orderNum;
    }

    @Length(min = 0, max = 1, message = "状态长度必须介于 0 和 1 之间")
    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getBeginWillFinishTime() {
        return beginWillFinishTime;
    }

    public void setBeginWillFinishTime(Date beginWillFinishTime) {
        this.beginWillFinishTime = beginWillFinishTime;
    }

    public Date getEndWillFinishTime() {
        return endWillFinishTime;
    }

    public void setEndWillFinishTime(Date endWillFinishTime) {
        this.endWillFinishTime = endWillFinishTime;
    }

    public Date getBeginEstimateTime() {
        return beginEstimateTime;
    }

    public void setBeginEstimateTime(Date beginEstimateTime) {
        this.beginEstimateTime = beginEstimateTime;
    }

    public Date getEndEstimateTime() {
        return endEstimateTime;
    }

    public void setEndEstimateTime(Date endEstimateTime) {
        this.endEstimateTime = endEstimateTime;
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

    public List<AamsProjectUser> getAamsProjectUserList() {
        return aamsProjectUserList;
    }

    public void setAamsProjectUserList(List<AamsProjectUser> aamsProjectUserList) {
        this.aamsProjectUserList = aamsProjectUserList;
    }


}