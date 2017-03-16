//
//  NWError.swift
//  ObjectJSON
//
//  Created by ldy on 17/2/28.
//  Copyright © 2017年 BJYN. All rights reserved.
//

import Foundation

protocol NWError:Error{
    func toString()->String
}


enum NWLocalError:Int, NWError{
    
    case reqNameUnDefine = 1
    case reqParamsCountError = 2
    case httpReqFailed = 3
    case resumeDataNotFind = 4
    
    func toString()->String{
        switch self {
        case .reqNameUnDefine:
            return "HTTP请求名称未定义"
        case .reqParamsCountError:
            return "HTTP请求参数数量错误"
        case .resumeDataNotFind:
            return "没有找到ResumeData，请使用doDownload下载"
        default:
            return "本地未知错误"
        }
    }
}

enum NWAlamofireError:Int, NWError{
    
    case respParseFailed = 1
    
    func toString()->String{
        switch self {
        case .respParseFailed:
            return "Alamofire解析Response失败"
        default:
            return "Alamofire未知错误"
        }
    }
}
