//
//  NWRequest+Download.swift
//  ObjectJSON
//
//  Created by ldy on 17/2/28.
//  Copyright © 2017年 BJYN. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class NWDownloadRequest:NSObject{
    
    var url:String = ""
    var request:DownloadRequest?
    var resumeData:Data?
    var progressBlock:((_ hasWritten:Int64, _ totalToWrite:Int64) -> Void)?
    var succBlock:((_ response:Data?)-> Void)?
    var failureBlock:((_ err:Error?)->Void)?
    var destination:DownloadRequest.DownloadFileDestination?
    
    /// 下载
    ///
    /// - parameter request:  下载请求
    /// - parameter destPath: 下载数据本地存储路径，包含文件名
    /// - parameter progress: 下载进度回调
    /// - parameter success:  下载成功回调
    /// - parameter failure:  下载失败回调
    func doDownload(_ url:String, destPath:String , progress:@escaping (_ hasWritten:Int64, _ totalToWrite:Int64) -> Void, success: @escaping (_ response:Data?)-> Void, failure:@escaping (_ err:Error?)->Void){
        self.url = url
        self.progressBlock = progress
        self.succBlock = success
        self.failureBlock = failure
        //创建本地下载路径
        self.destination = { temporaryURL, response in
            let documentsURL = URL(fileURLWithPath: destPath)
            return (destinationURL: documentsURL, options: [DownloadRequest.DownloadOptions.removePreviousFile, DownloadRequest.DownloadOptions.createIntermediateDirectories])
        }
        //取消之前的下载
        if self.request != nil {
            self.request!.cancel()
            self.request = nil
        }
        //下载
        self.request = Alamofire.download(url,to: destination)
        //下载进度回调
        self.request!.downloadProgress(closure: { (prgs:Progress) in
            progress(prgs.completedUnitCount,prgs.totalUnitCount)
        })
        //下载完成回调
        self.request!.responseData(completionHandler: { (response:DownloadResponse<Data>) in
            if response.result.isSuccess {
                success(response.result.value)
            }else{
                self.resumeData = response.resumeData
                failure(response.result.error)
            }
        })
    }
    
    //暂停下载
    func stop(){
        self.request?.cancel()
    }
    
    //继续下载
    func resume(){
        if self.resumeData == nil || self.destination == nil || self.progressBlock == nil || self.succBlock == nil || self.failureBlock == nil {
            return
        }
        //创建本地下载路径
        self.request = Alamofire.download(resumingWith: self.resumeData!,to: self.destination)
        self.request!.downloadProgress { (progs:Progress) in
            self.progressBlock!(progs.completedUnitCount,progs.totalUnitCount)
        }
        self.request!.responseData(completionHandler: { (response:DownloadResponse<Data>) in
            if response.result.isSuccess {
                //移除resumeData
                self.resumeData = nil
                self.succBlock!(response.result.value)
            }else{
                //记录resumeData
                self.resumeData = response.resumeData
                self.failureBlock!(response.result.error)
            }
        })
    }
}
