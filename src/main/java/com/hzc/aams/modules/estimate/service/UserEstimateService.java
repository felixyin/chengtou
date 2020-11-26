/**
 * Copyright &copy; 2016-2017 HZC All rights reserved.
 */
package com.hzc.aams.modules.estimate.service;

import java.util.List;

import com.hzc.aams.modules.project.entity.AamsEstimate;
import com.hzc.aams.modules.sys.entity.Role;
import com.hzc.aams.modules.sys.entity.User;
import com.hzc.aams.modules.sys.utils.UserUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hzc.aams.common.persistence.Page;
import com.hzc.aams.common.service.CrudService;
import com.hzc.aams.common.utils.StringUtils;
import com.hzc.aams.modules.estimate.entity.UserEstimate;
import com.hzc.aams.modules.estimate.dao.UserEstimateDao;
import com.hzc.aams.modules.estimate.entity.UserEstimateDetail;
import com.hzc.aams.modules.estimate.dao.UserEstimateDetailDao;

/**
 * 人员评分Service
 *
 * @author 尹彬
 * @version 2017-07-08
 */
@Service
@Transactional(readOnly = true)
public class UserEstimateService extends CrudService<UserEstimateDao, UserEstimate> {

    @Autowired
    private UserEstimateDetailDao userEstimateDetailDao;

    @Autowired
    private UserEstimateDao userEstimateDao;

    public UserEstimate get(String id,String year) {
        UserEstimate userEstimate = userEstimateDao.getByIdYear(id,year);
        userEstimate.setUserEstimateDetailList(userEstimateDetailDao.findList(new UserEstimateDetail(userEstimate)));
        return userEstimate;
    }


    public List<UserEstimate> findList(UserEstimate userEstimate) {
        return super.findList(userEstimate);
    }


    public Page<UserEstimate> findPage(Page<UserEstimate> page, UserEstimate userEstimate) {
        userEstimate.getSqlMap().put("dsf", dataScopeFilter(UserUtils.getUser(), "o3", "a"));
        Page<UserEstimate> page1 = super.findPage(page, userEstimate);


        // 增加类似excel表格行号,计算比率评分
        List<UserEstimate> list = page1.getList();

        if (list.size() > 0) {
            Double sumFractionRatio = userEstimateDao.getSumFractionRatio(userEstimate.getYear());
            for (int i = 0; i < list.size(); ) {
                UserEstimate bean = list.get(i);
//            User user = UserUtils.getNoCache(bean.getId());
//            List<Role> roleList = user.getRoleList();
//            Double ratio = 1D;
//            for (Role role : roleList) {
//                String remarks = role.getRemarks();
//                if (org.apache.commons.lang3.StringUtils.isNoneBlank(remarks)) {
//                    Double newRatio = Double.parseDouble(remarks);
//                    if (newRatio > ratio) ratio = newRatio;
//                }
//            }
//            String fractionStr = bean.getFraction();
//            if (org.apache.commons.lang3.StringUtils.isNoneBlank(fractionStr)) {
//                bean.setFractionRatio(String.format("%.2f", (Double) Double.parseDouble(fractionStr) * ratio));
//            }

                bean.setRatio(bean.getFractionRatio() / sumFractionRatio);
                bean.setSeq(++i);
            }
        }
        return page1;
    }

    @Transactional(readOnly = false)
    public void save(UserEstimate userEstimate) {
        super.save(userEstimate);
        for (UserEstimateDetail userEstimateDetail : userEstimate.getUserEstimateDetailList()) {
            if (userEstimateDetail.getId() == null) {
                continue;
            }
            if (UserEstimateDetail.DEL_FLAG_NORMAL.equals(userEstimateDetail.getDelFlag())) {
                if (StringUtils.isBlank(userEstimateDetail.getId())) {
                    userEstimateDetail.setUser(userEstimate);
                    userEstimateDetail.preInsert();
                    userEstimateDetailDao.insert(userEstimateDetail);
                } else {
                    userEstimateDetail.preUpdate();
                    userEstimateDetailDao.update(userEstimateDetail);
                }
            } else {
                userEstimateDetailDao.delete(userEstimateDetail);
            }
        }
    }

    @Transactional(readOnly = false)
    public void delete(UserEstimate userEstimate) {
        super.delete(userEstimate);
        userEstimateDetailDao.delete(new UserEstimateDetail(userEstimate));
    }

}