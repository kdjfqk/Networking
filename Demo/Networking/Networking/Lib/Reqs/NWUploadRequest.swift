//
//  NWRequest+Upload.swift
//  ObjectJSON
//
//  Created by ldy on 17/2/28.
//  Copyright © 2017年 BJYN. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class NWUploadRequest{
    
    var request:UploadRequest?
    
    /// 上传数据，接收Resp对象
    ///
    /// - parameter request:     上传请求
    /// - parameter multDataDic: 构造上传数据的回调
    /// - parameter progress:    上传进度回调
    /// - parameter success:     上传成功回调
    /// - parameter failure:     上传失败回调
    func doUploadResp<Resp:Mappable>(_ request:URLRequest,
                  multDataBlock:@escaping ()->([(data: Data, name: String, fileName: String?, mimeType: String?)]),
                  progress:@escaping (_ hasWritten:Int64, _ totalToWrite:Int64) -> Void,
                  success: @escaping (_ response:Resp)-> Void,
                  failure:@escaping (_ err:Error)->Void){
        
        self.doUpload(request, multDataBlock: multDataBlock, progress: progress, responseBlock: { 
            //设置上传结束回调
            self.request?.responseObject(completionHandler: { (response:DataResponse<Resp>) in
                if response.result.isSuccess {
                    success(response.result.value!)
                }else{
                    failure(response.result.error!)
                }
            })
        }, failure: failure)
    }
    
    /// 上传数据，接收Data对象
    ///
    /// - parameter request:     上传请求
    /// - parameter multDataDic: 构造上传数据的回调
    /// - parameter progress:    上传进度回调
    /// - parameter success:     上传成功回调
    /// - parameter failure:     上传失败回调
    func doUploadData(_ request:URLRequest,
                  multDataBlock:@escaping ()->([(data: Data, name: String, fileName: String?, mimeType: String?)]),
                  progress:@escaping (_ hasWritten:Int64, _ totalToWrite:Int64) -> Void,
                  success: @escaping (_ response:Data)-> Void,
                  failure:@escaping (_ err:Error)->Void){
        self.doUpload(request, multDataBlock: multDataBlock, progress: progress, responseBlock: { 
            //设置上传结束回调
            self.request?.responseData(completionHandler: { (response:DataResponse<Data>) in
                if response.result.isSuccess {
                    success(response.result.value!)
                }else{
                    failure(response.result.error!)
                }
            })
        }, failure: failure)
    }
    
    //取消上传
    func cancel(){
        self.request?.cancel()
    }
    
    private func doUpload(_ request:URLRequest,
                          multDataBlock:@escaping ()->([(data: Data, name: String, fileName: String?, mimeType: String?)]),
                          progress:@escaping (_ hasWritten:Int64, _ totalToWrite:Int64) -> Void,
                          responseBlock:@escaping ()->Void,
                          failure:@escaping (_ err:Error)->Void){
        Alamofire.upload(multipartFormData: { (multiData:MultipartFormData) in
            //构建multipartFormData
            let paramArray = multDataBlock()
            paramArray.enumerated().forEach({ (offset: Int, element: (data: Data, name: String, fileName: String?, mimeType: String?)) in
                if element.fileName == nil || element.mimeType == nil {
                    multiData.append(element.data, withName: element.name)
                }else{
                    multiData.append(element.data, withName: element.name, fileName: element.fileName!, mimeType: element.mimeType!)
                }
            })
        }, with: request) { (result:SessionManager.MultipartFormDataEncodingResult) in
            switch result {
            case .success(let uploadReq, _, _):  //发送上传请求成功
                self.request = uploadReq
                
                print(request.httpBody)
                print(request.allHTTPHeaderFields)
                
                //设置上传进度回调
                uploadReq.uploadProgress(closure: { (prgs:Progress) in
                    progress(prgs.completedUnitCount,prgs.totalUnitCount)
                })
                //设置上传结束回调
                responseBlock()
                break
            case .failure(let error): //发送上传请求失败
                failure(error)
            }
        }
    }
}
