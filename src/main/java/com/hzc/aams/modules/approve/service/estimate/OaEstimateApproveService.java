/**
 * Copyright &copy; 2016-2017 HZC All rights reserved.
 */
package com.hzc.aams.modules.approve.service.estimate;

import java.util.Date;
import java.util.List;
import java.util.Map;

import com.google.common.collect.Maps;
import com.hzc.aams.common.service.ServiceException;
import com.hzc.aams.common.utils.StringUtils;
import com.hzc.aams.modules.act.entity.Act;
import com.hzc.aams.modules.act.service.ActTaskService;
import com.hzc.aams.modules.approve.EstimateUtil;
import com.hzc.aams.modules.project.dao.AamsEstimateDao;
import com.hzc.aams.modules.project.entity.AamsEstimate;
import com.hzc.aams.modules.sys.utils.UserUtils;
import org.activiti.engine.*;
import org.activiti.engine.history.*;
import org.activiti.engine.runtime.ProcessInstance;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hzc.aams.common.persistence.Page;
import com.hzc.aams.common.service.CrudService;
import com.hzc.aams.modules.approve.entity.estimate.OaEstimateApprove;
import com.hzc.aams.modules.approve.dao.estimate.OaEstimateApproveDao;
import org.springframework.ui.Model;

import static com.hzc.aams.modules.approve.EstimateUtil.getProcessName;

/**
 * 评分审批工作流Service
 *
 * @author 尹彬
 * @version 2017-07-10
 */
@Service
@Transactional(readOnly = true)
public class OaEstimateApproveService extends CrudService<OaEstimateApproveDao, OaEstimateApprove> {

    @Autowired
    private OaEstimateApproveDao oaEstimateApproveDao;

    @Autowired
    private AamsEstimateDao aamsEstimateDao;

    @Autowired
    private ActTaskService actTaskService;

    @Autowired
    private RuntimeService runtimeService;
    @Autowired
    protected TaskService taskService;
    @Autowired
    protected HistoryService historyService;
    @Autowired
    protected RepositoryService repositoryService;
    @Autowired
    private IdentityService identityService;

    public OaEstimateApprove get(String id) {
        return super.get(id);
    }

    public List<OaEstimateApprove> findList(OaEstimateApprove oaEstimateApprove) {
        return super.findList(oaEstimateApprove);
    }

    public Page<OaEstimateApprove> findPage(Page<OaEstimateApprove> page, OaEstimateApprove oaEstimateApprove) {
        oaEstimateApprove.getSqlMap().put("dsf", dataScopeFilter(UserUtils.getUser(), "o1", "u4"));
        return super.findPage(page, oaEstimateApprove);
    }

    @Transactional(readOnly = false)
    public void save(OaEstimateApprove oaEstimateApprove) {
        super.save(oaEstimateApprove);
    }


    /**
     * 启动改分审批流程
     *
     * @param variables
     */
    @Transactional(readOnly = false)
    public void save(OaEstimateApprove oaEstimateApprove, Map<String, Object> variables) {
        // 保存业务数据
        oaEstimateApprove.preInsert();
        oaEstimateApproveDao.insert(oaEstimateApprove);

        logger.debug("save entity: {}", oaEstimateApprove);

        // 用来设置启动流程的人员ID，引擎会自动把用户ID保存到activiti:initiator中
        identityService.setAuthenticatedUserId(oaEstimateApprove.getCurrentUser().getLoginName());

        // 启动流程
        String businessKey = oaEstimateApprove.getId().toString();
        variables.put("type", "estimate-approve");
        variables.put("busId", businessKey);
        variables.put("folder", EstimateUtil.getFolderName());

        // 根据不同的用户计算得到不同的流程
        String processName = getProcessName();

        ProcessInstance processInstance = runtimeService.startProcessInstanceByKey(processName, processName + ":" + businessKey, variables);
        oaEstimateApprove.setProcessInstance(processInstance);

        // 更新流程实例ID
        oaEstimateApprove.setProcInsId(processInstance.getId());
        oaEstimateApproveDao.updateProcessInstanceId(oaEstimateApprove);

        logger.debug("start process of {key={}, bkey={}, pid={}, variables={}}", new Object[]{
                processName, businessKey, processInstance.getId(), variables});
    }


    /**
     * 完成工单
     *
     * @param oaEstimateApprove
     */
    @Transactional(readOnly = false)
    public void estimateApproveSave(OaEstimateApprove oaEstimateApprove) {
        // 提交流程任务设置的变量
        Map<String, Object> vars = Maps.newHashMap();

        // 设置意见
        Act act = oaEstimateApprove.getAct();
        act.setComment("... ...");

        // 对不同环节的业务逻辑进行操作
        String taskDefKey = act.getTaskDefKey();
        if (StringUtils.isBlank(taskDefKey)) {
//                 修改环节
        } else if ("start".equals(taskDefKey)) {
            act.setAssigneeName(oaEstimateApprove.getApproveUser().getName());
            act.setComment(oaEstimateApprove.getReason());
        }
        // 审核环节
        else if ("dept_say".equals(taskDefKey)) {
            act.setAssigneeName(oaEstimateApprove.getBumenUser().getName());
            act.setComment(oaEstimateApprove.getBumenSuggest());
        }
        // 审核环节2
        else if ("admin_say".equals(taskDefKey)) {
            act.setAssigneeName(oaEstimateApprove.getAdminUser().getName());

            String adminSuggest = oaEstimateApprove.getAdminSuggest();
            String bossResult = oaEstimateApprove.getBossResult();
            if ("1".equals(bossResult)) {
                // 同意，修改评分立马生效
                AamsEstimate aamsEstimate = aamsEstimateDao.get(oaEstimateApprove.getEstimate().getId());
                aamsEstimate.setFraction(oaEstimateApprove.getFractionApprove());
                aamsEstimateDao.update(aamsEstimate);

                act.setFlag("1"); // 1表示审批通过
                act.setComment(adminSuggest + "，审批结果：通过");
            } else {
                act.setFlag("0"); // 0表示审批未通过
                act.setComment(adminSuggest + "，审批结果：驳回");
            }

//            流程定义文件中会根据pass判断任务的流转，默认通过flag判断任务流转
//            vars.put("pass", act.getFlag());
        }
        // 审核环节3
        else if ("leader_say".equals(taskDefKey)) {
            act.setAssigneeName(oaEstimateApprove.getLeaderUser().getName());
            act.setComment(oaEstimateApprove.getLeaderSuggest());
        }
        // 审核环节4
        else if ("boss_say".equals(taskDefKey)) {
            act.setAssigneeName(oaEstimateApprove.getBossUser().getName());
            act.setComment(oaEstimateApprove.getBossSuggest());
        } else if (oaEstimateApprove.getAct().isFinishTask()) {
//            任务结束时，会显示view界面，不会执行这个方法
        }

        // 保存业务数据
        oaEstimateApprove.preUpdate();
        oaEstimateApproveDao.update(oaEstimateApprove);

//        完成任务
        actTaskService.complete(act.getTaskId(), act.getProcInsId(), act.getComment(), vars);

//		vars.put("var_test", "yes_no_test2");
//		actTaskService.getProcessEngine().getTaskService().addComment(testAudit.getAct().getTaskId(), testAudit.getAct().getProcInsId(), testAudit.getAct().getComment());
//		actTaskService.jumpTask(testAudit.getAct().getProcInsId(), testAudit.getAct().getTaskId(), "audit2", vars);
    }

    @Transactional(readOnly = false)
    public void delete(OaEstimateApprove oaEstimateApprove) {
        super.delete(oaEstimateApprove);
    }


    /**
     * 计算要显示的表单
     *
     * @param oaEstimateApprove
     * @param model
     * @return
     */
    public String getViewNameDisplay(OaEstimateApprove oaEstimateApprove, Model model) {

        String view = "next";
        // 查看审批申请单
        if (org.apache.commons.lang3.StringUtils.isNotBlank(oaEstimateApprove.getId())) {//.getAct().getProcInsId())){

            // 环节编号
            Act act = oaEstimateApprove.getAct();
            String taskDefKey = act.getTaskDefKey();

            model.addAttribute("taskDefKey", taskDefKey);

            if (StringUtils.isBlank(taskDefKey)) {
                view = "view";
//                 修改环节
            } else if ("start".equals(taskDefKey)) {
                view = "submit";
            }
            // 审核环节
            else if ("dept_say".equals(taskDefKey)) {
                view = "next";
                oaEstimateApprove.setBumenTime(new Date());
            }
            // 审核环节2
            else if ("admin_say".equals(taskDefKey)) {
                view = "next";
                oaEstimateApprove.setAdminTime(new Date());
                oaEstimateApprove.setAdminUser(UserUtils.getUser());
            }
            // 审核环节3
            else if ("leader_say".equals(taskDefKey)) {
                view = "next";
                oaEstimateApprove.setLeaderTime(new Date());
            }
            // 审核环节4
            else if ("boss_say".equals(taskDefKey)) {
                view = "next";
                oaEstimateApprove.setBossTime(new Date());
                oaEstimateApprove.setBossUser(UserUtils.getUser());
                oaEstimateApprove.setBossResult("2"); // 不通过
                // 查看工单
            } else if (act.isFinishTask()) {
                view = "view";
            }
        }
        return view;
    }

    /**
     * 根据流程实例id查询流程实例启动时设置的folder变量，并返回
     *
     * @param procInsId
     * @return
     */
    public String getFolderName(String procInsId) throws ServiceException {
        HistoricVariableInstanceQuery hviq = historyService.createHistoricVariableInstanceQuery()
                .processInstanceId(procInsId);
        List<HistoricVariableInstance> list = hviq.list();

        Object folder = null;
        for (HistoricVariableInstance hvi : list) {
            String variableName = hvi.getVariableName();
            // 启动流程时判断用户是普通员工和部门长后，设置的不同视图的目录：folder
            if ("folder".equals(variableName)) {
                folder = hvi.getValue();
            }
        }

        if (folder == null) throw new ServiceException("没有找到流程对应的表单界面");

        return String.valueOf(folder);
    }
}