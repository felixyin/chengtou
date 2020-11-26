/**
 * Copyright &copy; 2012-2013 <a href="httparamMap://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hzc.aams.modules.sys.service;

import com.hzc.aams.common.persistence.Page;
import com.hzc.aams.common.service.CrudService;
import com.hzc.aams.common.utils.DateUtils;
import com.hzc.aams.modules.sys.dao.LogDao;
import com.hzc.aams.modules.sys.entity.Log;
import org.springframework.transaction.annotation.Transactional;

/**
 * 日志Service
 * @author ThinkGem
 * @version 2014-05-16
 */
@org.springframework.stereotype.Service
@Transactional(readOnly = true)
public class Service extends CrudService<LogDao, Log> {

	public Page<Log> findPage(Page<Log> page, Log log) {
		
		// 设置默认时间范围，默认当前月
		if (log.getBeginDate() == null){
			log.setBeginDate(DateUtils.setDays(DateUtils.parseDate(DateUtils.getDate()), 1));
		}
		if (log.getEndDate() == null){
			log.setEndDate(DateUtils.addMonths(log.getBeginDate(), 1));
		}
		
		return super.findPage(page, log);
		
	}
	
}
