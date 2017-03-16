//
//  NWHttpConfig.swift
//  ObjectJSON
//
//  Created by ldy on 17/2/28.
//  Copyright © 2017年 BJYN. All rights reserved.
//

import UIKit

//请求方法
enum NWHttpMethod:String{
    case get = "GET"
    case post = "POST"
}

//配置文档对应的模型
class NWHttpConfig: NSObject {
    var baseUrl:String = ""
    var reqs:[String:NWHttpReqConfig] = [String:NWHttpReqConfig]()
}

//单个接口的配置信息对应的模型
class NWHttpReqConfig:NSObject{
    var path:String = ""
    var method:NWHttpMethod = .get
    var params:[String] = []
    var useBaseUrl:Bool = true
}
