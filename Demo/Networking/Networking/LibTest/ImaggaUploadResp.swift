//
//  ImaggaUploadResp.swift
//  ObjectJSON
//
//  Created by ldy on 17/3/15.
//  Copyright © 2017年 BJYN. All rights reserved.
//

import UIKit
import ObjectMapper

class ImaggaUploadResp: Mappable {
    var status:String = ""
    var uploaded:[ImaggaUploadItem] = []
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        uploaded <- map["uploaded"]
    }
}

class ImaggaUploadItem:Mappable{
    var itemId:String = ""
    var fileName:String = ""
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        itemId <- map["id"]
        fileName <- map["filename"]
    }
}
