//
//  NWNWRequest.swift
//  ObjectJSON
//
//  Created by ldy on 16/9/5.
//  Copyright © 2016年 BJYN. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class NWRequest{
    
    var request:Alamofire.Request?
    
    /// 发送请求，获取Resp对象
    ///
    /// - parameter request: 数据请求
    /// - parameter success: 获取成功回调
    /// - parameter failure: 获取失败回调
    func doRequest<Resp:Mappable>(_ request:URLRequest, success: @escaping (_ response:Resp)-> Void, failure:@escaping (_ err:Error)->Void){
        
        self.request = Alamofire.request(request).responseObject { (response: DataResponse<Resp>) in
            if response.result.isSuccess {
                guard let resp = response.result.value else {
                    failure(NWAlamofireError.respParseFailed)
                    return
                }
                success(resp)
            }else{
                failure(response.result.error!)
            }
        }
    }
    
    
    /// 发送请求，获取Data数据
    ///
    /// - parameter request: 数据请求
    /// - parameter success: 获取成功回调
    /// - parameter failure: 获取失败回调
    func doRequest(_ request:URLRequest, success: @escaping (_ response:Data)-> Void, failure:@escaping (_ err:Error)->Void){
        self.request = Alamofire.request(request).responseData(completionHandler: { (response:DataResponse<Data>) in
            if response.result.isSuccess {
                guard let resp = response.result.value else {
                    failure(NWAlamofireError.respParseFailed)
                    return
                }
                success(resp)
            }else{
                failure(response.result.error!)
            }
        })
    }
    

    
    /// 取消请求
    func cancel(){
        if self.request != nil {
            self.request?.cancel()
        }
    }
}
