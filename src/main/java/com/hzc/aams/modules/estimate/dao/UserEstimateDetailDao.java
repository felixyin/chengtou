/**
 * Copyright &copy; 2016-2017 HZC All rights reserved.
 */
package com.hzc.aams.modules.estimate.dao;

import com.hzc.aams.common.persistence.CrudDao;
import com.hzc.aams.common.persistence.annotation.MyBatisDao;
import com.hzc.aams.modules.estimate.entity.UserEstimateDetail;

/**
 * 人员评分DAO接口
 * @author 尹彬
 * @version 2017-07-08
 */
@MyBatisDao
public interface UserEstimateDetailDao extends CrudDao<UserEstimateDetail> {
	
}