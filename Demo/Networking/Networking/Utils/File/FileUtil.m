//
//  FileUtil.m
//  AFNetworkingDownloadTest
//
//  Created by YNKJMACMINI2 on 15/10/22.
//  Copyright © 2015年 YNKJMACMINI2. All rights reserved.
//

#import "FileUtil.h"
//#import "LYDownloaderService.h"

@implementation FileUtil

//获取Documents目录
+(NSString *)documentsPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

//创建目录
+(BOOL)createDirectoryWithPath:(NSString *)directoryPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //创建目录
    BOOL res=[fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    if (res)
    {
        NSLog(@"目录创建成功：%@",directoryPath);
    }else
    {
        NSLog(@"目录创建失败：%@",directoryPath);
    }
    return res;
}

//创建文件
+(BOOL)createFileWithPath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL res=[fileManager createFileAtPath:filePath contents:nil attributes:nil];
    if (res) {
        NSLog(@"文件创建成功: %@" ,filePath);
    }else
        NSLog(@"文件创建失败: %@" ,filePath);
    return res;
}

//删除文件
+(BOOL)deleteFileWithPath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL res=[fileManager removeItemAtPath:filePath error:nil];
    if (res) {
        NSLog(@"文件删除成功: %@",filePath);
    }else
        NSLog(@"文件删除失败: %@",filePath);
    return res;
}

//文件是否存在
+(BOOL)existFileAtPath:(NSString *)filePath
{
    NSFileManager * fileManager=[NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:filePath];
}

//判断目录是否包含文件
+(BOOL)isEmptyOfDirectory:(NSString *)directoryPath{
    NSArray *tempFileList = [self getAllItemInDirectory:directoryPath];
    if(tempFileList.count>0){
        return NO;
    }
    return YES;
}

//获取目录下所有文件
+(NSArray *)getAllItemInDirectory:(NSString *)directoryPath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *fileList = [[NSArray alloc] initWithArray:[fileManager contentsOfDirectoryAtPath:directoryPath error:nil]];
    return fileList;
}

//清空目录
+(void)clearDirectory:(NSString *)directoryPath{
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:directoryPath];
    for (NSString *fileName in enumerator) {
        [[NSFileManager defaultManager] removeItemAtPath:[directoryPath stringByAppendingPathComponent:fileName] error:nil];
    }
}

@end
