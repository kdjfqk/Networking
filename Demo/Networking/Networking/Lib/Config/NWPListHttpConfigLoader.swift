//
//  NWPListHttpConfigLoader.swift
//  ObjectJSON
//
//  Created by ldy on 17/2/28.
//  Copyright © 2017年 BJYN. All rights reserved.
//

import UIKit

class NWPListHttpConfigLoader: NWHttpConfigLoaderProtocol {
    
    var path:String = ""
    
    var config:NWHttpConfig = NWHttpConfig()
    
    init(configFilePath:String) {
        self.path = configFilePath
    }

    func loadConfig()->NWHttpConfig{
        //读取plist文件，赋值给config
        let result:NWHttpConfig = NWHttpConfig()
        if let configDic =  NSDictionary(contentsOfFile: path) {
            print(configDic.description)
            result.baseUrl = configDic.value(forKey: "baseUrl") as! String
            let reqsDic = configDic.value(forKey: "reqs") as! NSDictionary
            for key in reqsDic.allKeys {
                let reqName = key as! String
                let reqConfig = NWHttpReqConfig()
                let reqDic = reqsDic[key] as! NSDictionary
                reqConfig.method = NWHttpMethod(rawValue:(reqDic.value(forKey: "method") as! String))!
                reqConfig.path = reqDic.value(forKey: "path") as! String
                reqConfig.useBaseUrl = reqDic.value(forKey: "use_baseurl") as! Bool
                reqConfig.params = reqDic.value(forKey: "params") as! [String]
                result.reqs[reqName] = reqConfig
            }
        }
        self.config = result
        return result
    }
}
