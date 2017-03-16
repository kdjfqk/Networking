//
//  TSReq.swift
//  ObjectJSON
//
//  Created by ldy on 17/3/14.
//  Copyright © 2017年 BJYN. All rights reserved.
//

import UIKit
import ObjectMapper

class BookSearchReq: NSObject {
    
    class func sendReq(keyword:String,complete:@escaping (_ succ:Bool, _ result:[Book]?, _ error:Error?)->Void) throws -> NWRequest{
        //调用NWReqFactory创建UrlRequest
        let req = try NWUrlReqFactory.createReq(reqName:"book_search", paramsValue:[keyword])
        //发送请求
        let httpReq = NWRequest()
        httpReq.doRequest(req, success: { (resp:BookSearchResp) in
            //获取图书列表并通过回调返给上层
            if let books = resp.books {
                complete(true,books,nil)
            }else{
                complete(false,nil,NSError(domain: "Networking", code: -1, userInfo: [NSLocalizedDescriptionKey:"未获取到图书信息"]))
            }
        }) { (err:Error) in
            complete(false,nil,err)
        }
        return httpReq
    }
}
