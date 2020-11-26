/**
 * Copyright &copy; 2016-2017 HZC All rights reserved.
 */
package com.hzc.aams.modules.sys.dao;

import com.hzc.aams.common.persistence.CrudDao;
import com.hzc.aams.common.persistence.annotation.MyBatisDao;
import com.hzc.aams.modules.sys.entity.SysGod;

/**
 * 系统配置类DAO接口
 * @author 尹彬
 * @version 2017-07-12
 */
@MyBatisDao
public interface SysGodDao extends CrudDao<SysGod> {
	
}