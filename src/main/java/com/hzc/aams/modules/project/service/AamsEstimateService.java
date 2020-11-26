/**
 * Copyright &copy; 2016-2017 HZC All rights reserved.
 */
package com.hzc.aams.modules.project.service;

import com.hzc.aams.common.persistence.Page;
import com.hzc.aams.common.service.CrudService;
import com.hzc.aams.modules.project.dao.AamsEstimateDao;
import com.hzc.aams.modules.project.entity.AamsEstimate;
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
 * @version 2017-07-14
 */
@Service
@Transactional(readOnly = true)
public class AamsEstimateService extends CrudService<AamsEstimateDao, AamsEstimate> {

    @Autowired
    private AamsEstimateDao aamsEstimateDao;

    public AamsEstimate get(String id) {
        return super.get(id);
    }

    public List<AamsEstimate> findList(AamsEstimate aamsEstimate) {
        return super.findList(aamsEstimate);
    }

    public Page<AamsEstimate> findPage(Page<AamsEstimate> page, AamsEstimate aamsEstimate) {
        aamsEstimate.getSqlMap().put("dsf", dataScopeFilter(UserUtils.getUser(), "o6", "u7"));
        Page<AamsEstimate> page1 = super.findPage(page, aamsEstimate);
        // 增加类似excel表格行号
        List<AamsEstimate> list = page1.getList();
        for (int i = 0; i < list.size(); ) {
            AamsEstimate bean = list.get(i);
            bean.setSeq(++i);
        }
        return page1;
    }

    @Transactional(readOnly = false)
    public void save(AamsEstimate aamsEstimate) {
        super.save(aamsEstimate);
    }

    @Transactional(readOnly = false)
    public void delete(AamsEstimate aamsEstimate) {
        super.delete(aamsEstimate);
    }

}