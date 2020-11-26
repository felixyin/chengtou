/**
 * Copyright &copy; 2016-2017 HZC All rights reserved.
 */
package com.hzc.aams.modules.approve.dao.estimate;

import com.hzc.aams.common.persistence.CrudDao;
import com.hzc.aams.common.persistence.annotation.MyBatisDao;
import com.hzc.aams.modules.approve.entity.estimate.OaEstimateApprove;
import com.hzc.aams.modules.oa.entity.Leave;

/**
 * 评分审批工作流DAO接口
 * @author 尹彬
 * @version 2017-07-10
 */
@MyBatisDao
public interface OaEstimateApproveDao extends CrudDao<OaEstimateApprove> {


    /**
     * 更新流程实例ID
     * @param leave
     * @return
     */
    public int updateProcessInstanceId(OaEstimateApprove oaEstimateApprove);


}