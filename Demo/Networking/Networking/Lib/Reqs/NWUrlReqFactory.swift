//
//  NWUrlReqFactory.swift
//  ObjectJSON
//
//  Created by ldy on 17/2/28.
//  Copyright © 2017年 BJYN. All rights reserved.
//

import UIKit
import Alamofire

class NWUrlReqFactory: NSObject {
    
    /// 创建URLRequest
    ///
    /// - parameter reqName:     接口名称，必须与plist中的接口名一致
    /// - parameter paramsValue: 参数，参数顺序必须与plist中的参数列表顺序一致，适用于配置中的参数均传，或者只传前n个 的情况
    /// - parameter header:      头配置信息，默认值为nil
    ///
    /// - throws: 异常
    ///
    /// - returns: URLRequest
    class func createReq(reqName:String,paramsValue:[Any],header:[String:String]? = nil) throws -> URLRequest{
        var req = try self.create(reqName: reqName)
        self.setHeader(header: header, req: &req)
        //设置参数
        let configMager = NWHttpConfigManager.defaultManager
        guard let reqConfig = configMager.reqConfig(reqName: reqName) else { throw  NWLocalError.reqNameUnDefine}
        if reqConfig.params.count < paramsValue.count {
            throw NWLocalError.reqParamsCountError
        }
        var reqParams:[String:Any] = [String:Any]()
        for i in 0..<paramsValue.count {
            reqParams[reqConfig.params[i]] = paramsValue[i]
        }
        return try URLEncoding.methodDependent.encode(req, with: reqParams)
    }
    
    /// 创建URLRequest
    ///
    /// - parameter reqName: 接口名称，必须与plist中的接口名一致
    /// - parameter params:  参数，参数顺序可以自定义，适用于 不能按照配置中的参数列表顺序传参数的情况
    /// - parameter header:  头配置信息，可以传nil
    ///
    /// - throws: 异常
    ///
    /// - returns: URLRequest
    class func createReq(reqName:String,params:[String:Any],header:[String:String]? = nil) throws -> URLRequest{
        var req = try self.create(reqName: reqName)
        self.setHeader(header: header, req: &req)
        return try URLEncoding.methodDependent.encode(req, with: params)
    }
    
    /// 创建上传URLRequest
    ///
    /// - parameter reqName: 接口名称，必须与plist中的接口名一致
    /// - parameter header:  头配置信息，默认值为nil
    ///
    /// - throws: 异常
    ///
    /// - returns: URLRequest
    class func createUploadReq(reqName:String,header:[String:String]? = nil) throws -> URLRequest{
        var req = try self.create(reqName: reqName)
        self.setHeader(header: header, req: &req)
        return req
    }
    
    //MARK:- private
    private class func create(reqName:String) throws ->URLRequest{
        let configMager = NWHttpConfigManager.defaultManager
        guard let reqConfig = configMager.reqConfig(reqName: reqName) else { throw  NWLocalError.reqNameUnDefine}
        let url = URL(string: configMager.baseUrl())!
        var mutableURLRequest:URLRequest!
        if reqConfig.useBaseUrl {
            mutableURLRequest = URLRequest(url: url.appendingPathComponent(reqConfig.path))
        }else{
            mutableURLRequest = URLRequest(url: URL(string: reqConfig.path)!)
        }
        mutableURLRequest.httpMethod = reqConfig.method.rawValue
        return mutableURLRequest
    }
    
    private class func setHeader(header:[String:String]?, req:inout URLRequest){
        if header != nil {
            header!.enumerated().forEach({ (offset: Int, element: (key: String, value: String)) in
                req.setValue(element.value, forHTTPHeaderField: element.key)
            })
        }
    }
}
