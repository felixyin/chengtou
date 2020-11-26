/**
 * Copyright &copy; 2016-2017 HZC All rights reserved.
 */
package com.hzc.aams.modules.estimate.service;

import java.util.List;
import java.util.Map;

import com.hzc.aams.modules.act.utils.ActUtils;
import com.hzc.aams.modules.oa.entity.Leave;
import com.hzc.aams.modules.project.entity.AamsProject;
import com.hzc.aams.modules.sys.utils.UserUtils;
import org.activiti.engine.runtime.ProcessInstance;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hzc.aams.common.persistence.Page;
import com.hzc.aams.common.service.CrudService;
import com.hzc.aams.common.utils.StringUtils;
import com.hzc.aams.modules.estimate.entity.UserEstimateDetail;
import com.hzc.aams.modules.estimate.dao.UserEstimateDetailDao;

/**
 * 评分明细Service
 * @author 尹彬
 * @version 2017-07-08
 */
@Service
@Transactional(readOnly = true)
public class UserEstimateDetailService extends CrudService<UserEstimateDetailDao, UserEstimateDetail> {

	
	public UserEstimateDetail get(String id) {
		UserEstimateDetail userEstimateDetail = super.get(id);
		return userEstimateDetail;
	}
	
	public List<UserEstimateDetail> findList(UserEstimateDetail userEstimateDetail) {
		return super.findList(userEstimateDetail);
	}
	
	public Page<UserEstimateDetail> findPage(Page<UserEstimateDetail> page, UserEstimateDetail userEstimateDetail) {
		userEstimateDetail.getSqlMap().put("dsf", dataScopeFilter(UserUtils.getUser(), "o4", "u2"));
		Page<UserEstimateDetail> page1 = super.findPage(page, userEstimateDetail);
		// 增加类似excel表格行号
		List<UserEstimateDetail> list = page1.getList();
		for (int i = 0; i < list.size(); ) {
			UserEstimateDetail detail= list.get(i);
			detail.setSeq(++i);
		}
		return page1;
	}
	
	@Transactional(readOnly = false)
	public void save(UserEstimateDetail userEstimateDetail) {
		super.save(userEstimateDetail);
	}



	@Transactional(readOnly = false)
	public void delete(UserEstimateDetail userEstimateDetail) {
		super.delete(userEstimateDetail);
	}
	
}