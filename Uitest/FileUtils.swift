//
//  FileUtils.swift
//  Uitest
//
//  Created by brzhang on 15/6/27.
//  Copyright (c) 2015年 brzhang. All rights reserved.
//

import Foundation

class FileUtils{
    
    /// 获取当前app目录
    class func getCurrentUserPath()->String{
        var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first as! String
        return path
    }

}
