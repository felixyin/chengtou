package com.hzc.aams.common.utils;

import org.springframework.beans.BeansException;
import org.springframework.beans.factory.BeanInitializationException;
import org.springframework.beans.factory.config.ConfigurableListableBeanFactory;

import java.util.Properties;


public class PropertyConfigurer extends org.springframework.beans.factory.config.PropertyPlaceholderConfigurer {
    private static final String key = "0002000200020002";

    protected void processProperties(ConfigurableListableBeanFactory beanFactory, Properties props)
            throws BeansException {
        try {
            Des des = new Des();

            String type = props.getProperty("jdbc.type");
            if (type != null) {
                props.setProperty("jdbc.type", des.Decrypt(type, des.hex2byte(key)));
            }

            String username = props.getProperty("jdbc.username");
            if (username != null) {
                props.setProperty("jdbc.username", des.Decrypt(username, des.hex2byte(key)));
            }

            String password = props.getProperty("jdbc.password");
            if (password != null) {
                props.setProperty("jdbc.password", des.Decrypt(password, des.hex2byte(key)));
            }

            String url = props.getProperty("jdbc.url");
            if (url != null) {
                props.setProperty("jdbc.url", des.Decrypt(url, des.hex2byte(key)));
            }

            String driverClassName = props.getProperty("jdbc.driver");
            if (driverClassName != null) {
                props.setProperty("jdbc.driver", des.Decrypt(driverClassName, des.hex2byte(key)));
            }

            super.processProperties(beanFactory, props);
        } catch (Exception e) {
            e.printStackTrace();
            throw new BeanInitializationException(e.getMessage());
        }
    }
}
