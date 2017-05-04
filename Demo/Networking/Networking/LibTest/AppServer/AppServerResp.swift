//
//  AppServerResp.swift
//  Networking
//
//  Created by ldy on 17/4/10.
//  Copyright © 2017年 BJYN. All rights reserved.
//

import UIKit
import ObjectMapper

class AppServerResp<T>: Mappable {
    var success:Bool?
    var errCode:Int?
    var errMsg:String?
    var value:T?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        success <- map["success"]
        errCode <- map["errCode"]
        errMsg <- map["errMsg"]
        value <- map["value"]
    }
}

class User: Mappable {
    var userId:String?
    var username:String?
    var age:Int?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        userId <- map["userId"]
        username <- map["username"]
        age <- map["age"]
    }
}
