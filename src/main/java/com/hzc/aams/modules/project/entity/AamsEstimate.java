/**
 * Copyright &copy; 2016-2017 HZC All rights reserved.
 */
package com.hzc.aams.modules.project.entity;

import com.hzc.aams.modules.approve.entity.estimate.OaEstimateApprove;
import org.hibernate.validator.constraints.Length;
import java.util.Date;

import com.hzc.aams.common.persistence.DataEntity;
import org.hibernate.validator.constraints.NotBlank;

/**
 * 督办项目Entity
 * @author 尹彬
 * @version 2017-07-05
 */
public class AamsEstimate extends DataEntity<AamsEstimate> {
	
	private static final long serialVersionUID = 1L;
	private AamsProjectUser aamsProjectUser;		// 项目外建 父类


	/**
	 * 一次评分，只能对应一个改分申请，只有此次申请流程审批结束后，才可以再申请此评分
	 */
	private OaEstimateApprove oaEstimateApprove; // 对应的流程实例
	private Integer fraction = 0;		// 分数
	private String evolve;		// 进展情况
	private Date beginUpdateDate;		// 开始 更新时间
	private Date endUpdateDate;		// 结束 更新时间

	public AamsEstimate() {
		super();
	}

	public AamsEstimate(String id){
		super(id);
	}

	public AamsEstimate(AamsProjectUser aamsProjectUser){
	    super();
	    this.aamsProjectUser = aamsProjectUser;
	}

	@Length(min=0, max=64, message="项目外建长度必须介于 0 和 64 之间")
	public AamsProjectUser getAamsProjectUser() {
		return aamsProjectUser;
	}

	public void setAamsProjectUser(AamsProjectUser aamsProjectUser) {
		this.aamsProjectUser = aamsProjectUser;
	}

	public OaEstimateApprove getOaEstimateApprove() {
		return oaEstimateApprove;
	}

	public void setOaEstimateApprove(OaEstimateApprove oaEstimateApprove) {
		this.oaEstimateApprove = oaEstimateApprove;
	}

	@NotBlank
	@Length(min=0, max=11, message="分数长度必须介于 0 和 11 之间")
	public Integer getFraction() {
		return fraction;
	}

	public void setFraction(Integer fraction) {
		this.fraction = fraction;
	}
	
	@Length(min=0, max=255, message="进展情况长度必须介于 0 和 255 之间")
	public String getEvolve() {
		return evolve;
	}

	public void setEvolve(String evolve) {
		this.evolve = evolve;
	}
	
	public Date getBeginUpdateDate() {
		return beginUpdateDate;
	}

	public void setBeginUpdateDate(Date beginUpdateDate) {
		this.beginUpdateDate = beginUpdateDate;
	}
	
	public Date getEndUpdateDate() {
		return endUpdateDate;
	}

	public void setEndUpdateDate(Date endUpdateDate) {
		this.endUpdateDate = endUpdateDate;
	}

}