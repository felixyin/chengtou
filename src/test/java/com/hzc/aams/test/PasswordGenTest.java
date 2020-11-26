package com.hzc.aams.test;

import com.hzc.aams.common.security.Digests;
import com.hzc.aams.common.utils.Encodes;
import com.hzc.aams.modules.sys.service.SystemService;

import static com.hzc.aams.modules.sys.service.SystemService.HASH_INTERATIONS;
import static com.hzc.aams.modules.sys.service.SystemService.SALT_SIZE;

public class PasswordGenTest {
    public static void main(String[] args) {
        String plainPassword = "123456";
        System.out.println(SystemService.entryptPassword((plainPassword)));
    }

}
