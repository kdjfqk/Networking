//
//  NWHttpConfigManager.swift
//  ObjectJSON
//
//  Created by ldy on 17/2/28.
//  Copyright © 2017年 BJYN. All rights reserved.
//

import UIKit

//http配置加载器协议
protocol NWHttpConfigLoaderProtocol {
    func loadConfig()->NWHttpConfig
}

//http配置管理器
class NWHttpConfigManager: NSObject {
    
    //配置文件路劲
    static var configFilePath:String = ""
    //默认为plist加载器
    static var defaultManager:NWHttpConfigManager = NWHttpConfigManager(loader: NWPListHttpConfigLoader(configFilePath: configFilePath))
    private init(loader:NWHttpConfigLoaderProtocol) {
        configLoader = loader
        config = configLoader.loadConfig()
    }
    
    private var config:NWHttpConfig!
    private var configLoader:NWHttpConfigLoaderProtocol!
    
    func baseUrl()->String{
        return config.baseUrl
    }
    
    func reqConfig(reqName:String)->NWHttpReqConfig?{
        let result = config.reqs.first(where:{$0.key == reqName})
        return result?.value
    }
}
