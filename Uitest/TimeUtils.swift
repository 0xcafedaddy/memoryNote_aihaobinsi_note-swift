//
//  TimeUtils.swift
//  时间工具类
//
//  Created by brzhang on 15/6/26.
//  Copyright (c) 2015年 brzhang. All rights reserved.
//

import Foundation

class TimeUtils {
    
    /// 获取当前时间戳
    class func getCurrentTimeStamp()->Int64{
        var currentTimeStamp =  Int64(NSDate().timeIntervalSince1970)
        return currentTimeStamp
    }
    
    /// 计算给定时间距离当前时间的长度
    class func timeInterval(timestamp:Int64)->String{
        
        var timeIntervalDescribtion=""
        
        var currentTimeStamp =  Int64(NSDate().timeIntervalSince1970)
        var between = (timestamp - currentTimeStamp)
        
        var year = between / (24 * 3600 * 365)
        
        var month = between / (24 * 3600 * 30)
        
        var day = between / (24 * 3600);
        
        var hour = between % (24 * 3600) / 3600;
        
        var minute = between % 3600 / 60;
        
        var second=between % 60;
        
        if(year > 0){
           timeIntervalDescribtion = "\(year)年后"
        }else if(month > 0){
           timeIntervalDescribtion = "\(month)月后"
        }else if(day > 0){
            timeIntervalDescribtion = "\(day)天后"
        }else if(hour > 0 ){
            timeIntervalDescribtion = "\(hour)小时后"
        }else if (minute > 0){
            timeIntervalDescribtion = "\(minute)分后"
        }else if (second > 0){
            timeIntervalDescribtion = "\(second)秒后"
        }else{
            timeIntervalDescribtion = "刚刚"
        }
        return timeIntervalDescribtion
    }
}
