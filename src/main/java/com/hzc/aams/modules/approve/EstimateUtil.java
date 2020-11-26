package com.hzc.aams.modules.approve;

import com.hzc.aams.modules.act.utils.ActUtils;
import com.hzc.aams.modules.sys.entity.User;
import com.hzc.aams.modules.sys.utils.UserUtils;

/**
 * Created by fy on 2017/10/22.
 */
public class EstimateUtil {

    public static String getProcessName() {
        String processName;
        User user = UserUtils.getUser();
        String roleNames = user.getRoleEnNames();
        if (roleNames.contains("p") || roleNames.contains("b")) { // 员工、部门长
            processName = ActUtils.PD_ESTIMATE_APPROVE[0];
        } else { // 分管领导、管理员
            processName = ActUtils.PD_ESTIMATE_APPROVE[1];
        }
        return processName;
    }


    public static String getFolderName() {
        String folder;
        User user = UserUtils.getUser();
        String roleNames = user.getRoleEnNames();
        if (roleNames.contains("p") || roleNames.contains("b")) { // 员工、部门长
            folder = "person_dept";
        } else { // 分管领导、管理员
            folder = "lead_boss";
        }
        return folder;
    }


}
