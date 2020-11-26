/**
 * Copyright &copy; 2016-2017 HZC All rights reserved.
 */
package com.hzc.aams.modules.atten.dao;

import com.hzc.aams.common.persistence.CrudDao;
import com.hzc.aams.common.persistence.annotation.MyBatisDao;
import com.hzc.aams.modules.atten.entity.AamsAtten;

/**
 * 考勤管理DAO接口
 * @author 李云涛
 * @version 2017-08-08
 */
@MyBatisDao
public interface AamsAttenDao extends CrudDao<AamsAtten> {
	
}