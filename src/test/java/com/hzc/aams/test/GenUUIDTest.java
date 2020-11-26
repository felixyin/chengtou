package com.hzc.aams.test;

import com.hzc.aams.common.utils.IdGen;

/**
 * Created by fy on 2017/11/10.
 */
public class GenUUIDTest {
    public static void main(String[] args) {
        for (int i = 0; i < 32; i++) {
            String uuid = IdGen.uuid();
            System.out.println(uuid);
        }
    }
}
