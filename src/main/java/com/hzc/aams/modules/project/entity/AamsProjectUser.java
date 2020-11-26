/**
 * Copyright &copy; 2016-2017 HZC All rights reserved.
 */
package com.hzc.aams.modules.project.entity;

import com.google.common.collect.Lists;
import org.hibernate.validator.constraints.Length;
import com.hzc.aams.modules.sys.entity.User;
import javax.validation.constraints.NotNull;

import com.hzc.aams.common.persistence.DataEntity;

import java.util.List;

/**
 * 督办项目Entity
 * @author 尹彬
 * @version 2017-07-05
 */
public class AamsProjectUser extends DataEntity<AamsProjectUser> {
	
	private static final long serialVersionUID = 1L;
	private AamsProject aamsProject;		// 督办项目 父类
	private User user;		// 项目负责人
	private List<AamsEstimate> aamsEstimateList  = Lists.newArrayList(); // 人员的评分
	
	public AamsProjectUser() {
		super();
	}

	public AamsProjectUser(String id){
		super(id);
	}

	public AamsProjectUser(AamsProject aamsProject){
		this.aamsProject = aamsProject;
	}

	@Length(min=1, max=64, message="督办项目长度必须介于 1 和 64 之间")
	public AamsProject getAamsProject() {
		return aamsProject;
	}

	public void setAamsProject(AamsProject aamsProject) {
		this.aamsProject = aamsProject;
	}
	
	@NotNull(message="项目负责人不能为空")
	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public List<AamsEstimate> getAamsEstimateList() {
		return aamsEstimateList;
	}

	public void setAamsEstimateList(List<AamsEstimate> aamsEstimateList) {
		this.aamsEstimateList = aamsEstimateList;
	}
}