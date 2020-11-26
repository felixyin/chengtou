/**
 * Copyright &copy; 2016-2017 HZC All rights reserved.
 */
package com.hzc.aams.modules.sys.entity;

import org.hibernate.validator.constraints.Length;

import com.hzc.aams.common.persistence.DataEntity;

/**
 * 系统配置类Entity
 * @author 尹彬
 * @version 2017-07-12
 */
public class SysGod extends DataEntity<SysGod> {
	
	private static final long serialVersionUID = 1L;
	private String dayCount;		// 一天内的数量
	
	public SysGod() {
		super();
	}

	public SysGod(String id){
		super(id);
	}

	@Length(min=0, max=11, message="一天内的数量长度必须介于 0 和 11 之间")
	public String getDayCount() {
		return dayCount;
	}

	public void setDayCount(String dayCount) {
		this.dayCount = dayCount;
	}
	
}