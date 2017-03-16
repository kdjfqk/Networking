//
//  FileUtil.h
//  AFNetworkingDownloadTest
//
//  Created by YNKJMACMINI2 on 15/10/22.
//  Copyright © 2015年 YNKJMACMINI2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileUtil : NSObject

//获取沙盒Documents文件夹路径
+(NSString *)documentsPath;
//创建目录，若父目录不存在则会连同父目录一起创建
+(BOOL)createDirectoryWithPath:(NSString *)directoryPath;
//创建文件，若文件已经存在则返回YES，若不存在则创建文件，创建成功返回YES，创建失败返回NO
+(BOOL)createFileWithPath:(NSString *)filePath;
//文件是否存在
+(BOOL)existFileAtPath:(NSString *)filePath;

@end
