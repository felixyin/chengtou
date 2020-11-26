/**
 * Copyright &copy; 2016-2017 HZC All rights reserved.
 */
package com.hzc.aams.modules.sys.dao;

import com.hzc.aams.common.persistence.TreeDao;
import com.hzc.aams.common.persistence.annotation.MyBatisDao;
import com.hzc.aams.modules.sys.entity.Office;

/**
 * 机构DAO接口
 * @author ThinkGem
 * @version 2014-05-16
 */
@MyBatisDao
public interface OfficeDao extends TreeDao<Office> {
	
}
