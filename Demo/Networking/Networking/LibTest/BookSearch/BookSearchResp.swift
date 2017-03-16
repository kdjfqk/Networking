//
//  TSResp.swift
//  ObjectJSON
//
//  Created by ldy on 17/3/14.
//  Copyright © 2017年 BJYN. All rights reserved.
//

import UIKit
import ObjectMapper

class BookSearchResp : Mappable{
    
    var count:Int?
    var start:Int?
    var total:Int?
    var books:[Book]?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        count <- map["count"]
        start <- map["start"]
        total <- map["total"]
        books <- map["books"]
    }
}

class Book: Mappable {
    var bookId:String = ""
    var price:String = ""
    var title:String = ""
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        bookId <- map["id"]
        price <- map["price"]
        title <- map["title"]
    }
}
