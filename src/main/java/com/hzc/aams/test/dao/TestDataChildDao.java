/**
 * Copyright &copy; 2016-2017 HZC All rights reserved.
 */
package com.hzc.aams.test.dao;

import com.hzc.aams.common.persistence.CrudDao;
import com.hzc.aams.common.persistence.annotation.MyBatisDao;
import com.hzc.aams.test.entity.TestDataChild;

/**
 * 主子表生成DAO接口
 * @author ThinkGem
 * @version 2015-04-06
 */
@MyBatisDao
public interface TestDataChildDao extends CrudDao<TestDataChild> {
	
}