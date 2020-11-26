/**
 * Copyright &copy; 2016-2017 HZC All rights reserved.
 */
package com.hzc.aams.modules.project.service;

import com.hzc.aams.common.persistence.Page;
import com.hzc.aams.common.service.CrudService;
import com.hzc.aams.common.utils.StringUtils;
import com.hzc.aams.modules.project.dao.AamsEstimateDao;
import com.hzc.aams.modules.project.dao.AamsProjectDao;
import com.hzc.aams.modules.project.dao.AamsProjectUserDao;
import com.hzc.aams.modules.project.entity.AamsEstimate;
import com.hzc.aams.modules.project.entity.AamsProject;
import com.hzc.aams.modules.project.entity.AamsProjectUser;
import com.hzc.aams.modules.sys.utils.UserUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.lang.reflect.InvocationTargetException;
import java.util.Date;
import java.util.List;

/**
 * 督办项目Service
 *
 * @author 尹彬
 * @version 2017-07-05
 */
@Service
@Transactional(readOnly = true)
public class AamsProjectService extends CrudService<AamsProjectDao, AamsProject> {

    @Autowired
    private AamsEstimateDao aamsEstimateDao;
    @Autowired
    private AamsProjectUserDao aamsProjectUserDao;

    public AamsProject get(String id) {
        AamsProject aamsProject = super.get(id);

//        查询督办项目的负责人
        List<AamsProjectUser> aamsProjectUsers = aamsProjectUserDao.findList(new AamsProjectUser(aamsProject));
        for (AamsProjectUser aamsProjectUser : aamsProjectUsers) {
//            查询每个负责人的评分情况
            aamsProjectUser.setAamsEstimateList(aamsEstimateDao.findList(new AamsEstimate(aamsProjectUser)));
        }

        aamsProject.setAamsProjectUserList(aamsProjectUsers);
        return aamsProject;
    }

    public List<AamsProject> findList(AamsProject aamsProject) {
        return super.findList(aamsProject);
    }

    public Page<AamsProject> findPage(Page<AamsProject> page, AamsProject aamsProject) {
        aamsProject.getSqlMap().put("dsf", dataScopeFilter(UserUtils.getUser(), "o6", "u7"));
        Page<AamsProject> page1 = super.findPage(page, aamsProject);
        // 增加类似excel表格行号
        List<AamsProject> list = page1.getList();
        for (int i = 0; i < list.size(); ) {
            AamsProject project = list.get(i);
            project.setSeq(++i);
        }
        return page1;
    }

    /**
     * 保存主表和子表信息
     * @param aamsProject
     */
    @Transactional(readOnly = false)
    public void save(AamsProject aamsProject) {
        if ("4".equals(aamsProject.getStatus())) { // 已经归档状态，维护办结日期
            aamsProject.setEndTime(new Date());
        }
        super.save(aamsProject);

        for (AamsProjectUser aamsProjectUser : aamsProject.getAamsProjectUserList()) {
            if (aamsProjectUser.getId() == null) {
                continue;
            }
            if (AamsProjectUser.DEL_FLAG_NORMAL.equals(aamsProjectUser.getDelFlag())) {
                if (StringUtils.isBlank(aamsProjectUser.getId())) {
                    aamsProjectUser.setAamsProject(aamsProject);
                    aamsProjectUser.preInsert();
                    aamsProjectUserDao.insert(aamsProjectUser);
                } else {
                    aamsProjectUser.preUpdate();
                    aamsProjectUserDao.update(aamsProjectUser);
                }
            } else {
                for (AamsEstimate aamsEstimate : aamsProjectUser.getAamsEstimateList()) {
                    aamsEstimateDao.delete(aamsEstimate);
                }
                aamsProjectUserDao.delete(aamsProjectUser);
            }
//            保存子表
            saveChild(aamsProjectUser);
        }
    }

    /**
     * 保存“孙子表”
     * @param aamsProjectUser
     */
    public void saveChild(AamsProjectUser aamsProjectUser) {
        for (AamsEstimate aamsEstimate : aamsProjectUser.getAamsEstimateList()) {
            if (aamsEstimate.getId() == null) {
                continue;
            }
            if (AamsEstimate.DEL_FLAG_NORMAL.equals(aamsEstimate.getDelFlag())) {
                if (StringUtils.isBlank(aamsEstimate.getId())) {
                    aamsEstimate.setAamsProjectUser(aamsProjectUser);
                    aamsEstimate.preInsert();
                    aamsEstimateDao.insert(aamsEstimate);
                } else {
                    aamsEstimate.preUpdate();
                    aamsEstimateDao.update(aamsEstimate);
                }
            } else {
                aamsEstimateDao.delete(aamsEstimate);
            }
        }
    }

    @Transactional(readOnly = false)
    public void delete(AamsProject aamsProject) {
//        删除督办项目
        super.delete(aamsProject);
//        删除负责人
        aamsProjectUserDao.delete(new AamsProjectUser(aamsProject));
//        级联删除负责人的评分
        List<AamsProjectUser> aamsProjectUserList = aamsProject.getAamsProjectUserList();
        for (AamsProjectUser aamsProjectUser : aamsProjectUserList) {
            aamsEstimateDao.delete(new AamsEstimate(aamsProjectUser));
        }
    }

    @Transactional(readOnly = false)
    public boolean saveOrderNum(List<AamsProject> aamsProjectList) throws InvocationTargetException, IllegalAccessException {
        for (AamsProject ap1 : aamsProjectList) {
            AamsProject ap2 = this.get(ap1.getId());
            ap2.setOrderNum(ap1.getOrderNum());
            this.save(ap2);
        }
        return true;
    }
}