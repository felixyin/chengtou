/**
 * Copyright &copy; 2016-2017 HZC All rights reserved.
 */
package com.hzc.aams.modules.approve.entity.estimate;

import com.hzc.aams.common.persistence.ActEntity;
import com.hzc.aams.common.utils.StringUtils;
import com.hzc.aams.modules.project.entity.AamsEstimate;
import org.activiti.engine.history.HistoricProcessInstance;
import org.activiti.engine.repository.ProcessDefinition;
import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.Task;
import org.hibernate.validator.constraints.Length;
import com.hzc.aams.modules.sys.entity.User;

import java.util.Date;
import java.util.Map;

import com.fasterxml.jackson.annotation.JsonFormat;

import com.hzc.aams.common.persistence.DataEntity;

/**
 * 评分审批工作流Entity
 *
 * @author 尹彬
 * @version 2017-07-10
 */
public class OaEstimateApprove extends ActEntity<OaEstimateApprove> {

    private static final long serialVersionUID = 1L;
    private String procInsId;        // 流程实例编号
    private AamsEstimate estimate; // 评分表外键
    private User approveUser;        // 申请人
    private Integer fractionApprove;        // 申请评分
    private String reason;        // 申请原因
    private User bumenUser;        // 部门长
    private String bumenSuggest;        // 部门长意见
    private Date bumenTime;        // 部门长操作时间
    private User adminUser;        // 管理员
    private String adminSuggest;        // 管理员流转备注
    private Date adminTime;        // 管理员操作时间
    private User leaderUser;        // 分管领导
    private String leaderSuggest;        // 分管领导意见
    private Date leaderTime;        // 分管领导操作时间
    private User bossUser;        // 单位负责人
    private String bossSuggest;        // 单位负责人审批意见
    private Date bossTime;        // 单位负责人审批时间
    private String bossResult;        // 审批结果
    private String status;        // 状态
    private String userId;


    //-- 临时属性 --//
    // 流程任务
    private Task task;
    private Map<String, Object> variables;
    // 运行中的流程实例
    private ProcessInstance processInstance;
    // 历史的流程实例
    private HistoricProcessInstance historicProcessInstance;
    // 流程定义
    private ProcessDefinition processDefinition;


    public OaEstimateApprove() {
        super();
    }

    public OaEstimateApprove(String id) {
        super(id);
    }

    public AamsEstimate getEstimate() {
        return estimate;
    }

    public void setEstimate(AamsEstimate estimate) {
        this.estimate = estimate;
    }

    @Length(min = 0, max = 64, message = "流程实例编号长度必须介于 0 和 64 之间")
    public String getProcInsId() {
        return procInsId;
    }

    public void setProcInsId(String procInsId) {
        this.procInsId = procInsId;
    }

    public User getApproveUser() {
        return approveUser;
    }

    public void setApproveUser(User approveUser) {
        this.approveUser = approveUser;
    }

    @Length(min = 0, max = 11, message = "申请评分长度必须介于 0 和 11 之间")
    public Integer getFractionApprove() {
        return fractionApprove;
    }

    public void setFractionApprove(Integer fractionApprove) {
        this.fractionApprove = fractionApprove;
    }

    @Length(min = 0, max = 500, message = "申请原因长度必须介于 0 和 500 之间")
    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    @Length(min = 0, max = 500, message = "部门长意见长度必须介于 0 和 500 之间")
    public String getBumenSuggest() {
        return bumenSuggest;
    }

    public void setBumenSuggest(String bumenSuggest) {
        this.bumenSuggest = bumenSuggest;
    }

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    public Date getBumenTime() {
        return bumenTime;
    }

    public void setBumenTime(Date bumenTime) {
        this.bumenTime = bumenTime;
    }

    @Length(min = 0, max = 500, message = "管理员流转备注长度必须介于 0 和 500 之间")
    public String getAdminSuggest() {
        return StringUtils.isNotBlank(adminSuggest) ? adminSuggest : "";
    }

    public void setAdminSuggest(String adminSuggest) {
        this.adminSuggest = adminSuggest;
    }

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    public Date getAdminTime() {
        return adminTime;
    }

    public void setAdminTime(Date adminTime) {
        this.adminTime = adminTime;
    }

    @Length(min = 0, max = 500, message = "分管领导意见长度必须介于 0 和 500 之间")
    public String getLeaderSuggest() {
        return leaderSuggest;
    }

    public void setLeaderSuggest(String leaderSuggest) {
        this.leaderSuggest = leaderSuggest;
    }

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    public Date getLeaderTime() {
        return leaderTime;
    }

    public void setLeaderTime(Date leaderTime) {
        this.leaderTime = leaderTime;
    }

    @Length(min = 0, max = 500, message = "单位负责人审批意见长度必须介于 0 和 500 之间")
    public String getBossSuggest() {
        return bossSuggest;
    }

    public void setBossSuggest(String bossSuggest) {
        this.bossSuggest = bossSuggest;
    }

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    public Date getBossTime() {
        return bossTime;
    }

    public void setBossTime(Date bossTime) {
        this.bossTime = bossTime;
    }

    public String getBossResult() {
        return bossResult;
    }

    public void setBossResult(String bossResult) {
        this.bossResult = bossResult;
    }

    @Length(min = 0, max = 1, message = "状态长度必须介于 0 和 1 之间")
    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Task getTask() {
        return task;
    }

    public void setTask(Task task) {
        this.task = task;
    }

    public Map<String, Object> getVariables() {
        return variables;
    }

    public void setVariables(Map<String, Object> variables) {
        this.variables = variables;
    }

    public ProcessInstance getProcessInstance() {
        return processInstance;
    }

    public void setProcessInstance(ProcessInstance processInstance) {
        this.processInstance = processInstance;
    }

    public HistoricProcessInstance getHistoricProcessInstance() {
        return historicProcessInstance;
    }

    public void setHistoricProcessInstance(HistoricProcessInstance historicProcessInstance) {
        this.historicProcessInstance = historicProcessInstance;
    }

    public ProcessDefinition getProcessDefinition() {
        return processDefinition;
    }

    public void setProcessDefinition(ProcessDefinition processDefinition) {
        this.processDefinition = processDefinition;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public User getBumenUser() {
        return bumenUser;
    }

    public void setBumenUser(User bumenUser) {
        this.bumenUser = bumenUser;
    }

    public User getAdminUser() {
        return adminUser;
    }

    public void setAdminUser(User adminUser) {
        this.adminUser = adminUser;
    }

    public User getLeaderUser() {
        return leaderUser;
    }

    public void setLeaderUser(User leaderUser) {
        this.leaderUser = leaderUser;
    }

    public User getBossUser() {
        return bossUser;
    }

    public void setBossUser(User bossUser) {
        this.bossUser = bossUser;
    }
}