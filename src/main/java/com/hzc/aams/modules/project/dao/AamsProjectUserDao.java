/**
 * Copyright &copy; 2016-2017 HZC All rights reserved.
 */
package com.hzc.aams.modules.project.dao;

import com.hzc.aams.common.persistence.CrudDao;
import com.hzc.aams.common.persistence.annotation.MyBatisDao;
import com.hzc.aams.modules.project.entity.AamsProjectUser;

/**
 * 督办项目DAO接口
 * @author 尹彬
 * @version 2017-07-05
 */
@MyBatisDao
public interface AamsProjectUserDao extends CrudDao<AamsProjectUser> {
	
}