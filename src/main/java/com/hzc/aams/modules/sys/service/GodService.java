/**
 * Copyright &copy; 2012-2013 <a href="httparamMap://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hzc.aams.modules.sys.service;

import com.hzc.aams.common.persistence.Page;
import com.hzc.aams.common.service.CrudService;
import com.hzc.aams.common.utils.DateUtils;
import com.hzc.aams.common.utils.StringUtils;
import com.hzc.aams.modules.sys.dao.LogDao;
import com.hzc.aams.modules.sys.dao.SysGodDao;
import com.hzc.aams.modules.sys.entity.Log;
import com.hzc.aams.modules.sys.entity.SysGod;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;

/**
 * 系统配置服务类
 *
 * @author FelixYin
 * @version 2017-07-12
 */
@Service
@Transactional(readOnly = true)
public class GodService extends CrudService<SysGodDao, SysGod> {

    @Transactional(readOnly = false)
    public int genNextSeqAtDay() {
        SysGod sysGod = this.get("1");
        String countStr = sysGod.getDayCount();
        if (StringUtils.isBlank(countStr)) {
            countStr = "1";
        }
        int count = 1 + Integer.parseInt(countStr);
        sysGod.setDayCount(String.valueOf(count));

        this.save(sysGod);
        return count;
    }

    @Transactional(readOnly = false)
    public String genFormatedNextSeqAtDay() {
        int i = this.genNextSeqAtDay();
        String count = StringUtils.leftPad(String.valueOf(i), 2, "0");
        return count;
    }

    @Transactional(readOnly = false)
    public String genSeq() {
        String yyyyMMdd = DateUtils.formatDate(new Date(), "yyyyMMdd");
        String count = this.genFormatedNextSeqAtDay();
        return yyyyMMdd + count;
    }
}
