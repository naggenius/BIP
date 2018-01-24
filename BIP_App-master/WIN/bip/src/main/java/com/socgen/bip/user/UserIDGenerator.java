package com.socgen.bip.user;

import java.util.concurrent.atomic.AtomicInteger;
import org.apache.commons.lang.StringUtils;


public final class UserIDGenerator {  
    private static final AtomicInteger count = new AtomicInteger(1);
    private UserIDGenerator() {}
    
    public static String getNextID() {
        int newValue = count.incrementAndGet();        
        return "A" + StringUtils.leftPad(Integer.toString(newValue),6, "0");
    }
}