//
//  AppServerReq.swift
//  Networking
//
//  Created by ldy on 17/4/10.
//  Copyright © 2017年 BJYN. All rights reserved.
//

import UIKit

class AppServerReq: NSObject {
    
    class func sendUserQueryReq(userID:String,complete:@escaping (_ succ:Bool, _ result:User?, _ error:Error?)->Void) throws -> NWRequest{
        //调用NWReqFactory创建UrlRequest
        let req = try NWUrlReqFactory.createReq(reqName:"server_user_search", paramsValue:[userID])
        //发送请求
        let httpReq = NWRequest()
        httpReq.doRequest(req, success: { (resp:AppServerResp<User>) in
            //获取图书列表并通过回调返给上层
            if let user = resp.value {
                complete(true,user,nil)
            }else{
                complete(false,nil,NSError(domain: "Networking", code: -1, userInfo: [NSLocalizedDescriptionKey:"未获取到图书信息"]))
            }
        }) { (err:Error) in
            complete(false,nil,err)
        }
        return httpReq
    }
    
    class func sendChangePwdReq(old:String,new:String,complete:@escaping (_ succ:Bool, _ result:Bool?, _ error:Error?)->Void) throws -> NWRequest{
        //调用NWReqFactory创建UrlRequest
        let req = try NWUrlReqFactory.createReq(reqName:"change_pwd", paramsValue:[old,new])
        //发送请求
        let httpReq = NWRequest()
        httpReq.doRequest(req, success: { (resp:AppServerResp<Bool>) in
            //获取图书列表并通过回调返给上层
            if let succ = resp.value {
                complete(true,succ,nil)
            }else{
                complete(false,nil,NSError(domain: "Networking", code: -1, userInfo: [NSLocalizedDescriptionKey:"未获取到图书信息"]))
            }
        }) { (err:Error) in
            complete(false,nil,err)
        }
        return httpReq
    }
}
