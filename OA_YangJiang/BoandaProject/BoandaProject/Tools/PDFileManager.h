//
//  PDFileManager.h
//  文件管理（文件(夹)的创建、删除、移动）
//
//  Created by 曾静 on 13-9-11.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDFileManager : NSObject

@property (nonatomic, strong) NSFileManager *fileManager;
@property (nonatomic, copy) NSString *basePath;
@property (nonatomic, copy) NSString *defaultFolderPath;

- (id)init;

+ (PDFileManager *)shared;

/**
 *  文件是否在指定路径存在
 *
 *  @param filePath 文件位置
 *
 *  @return 是否存在，YES存在，NO不存在
 */
- (BOOL)fileExistsAtPath:(NSString *)filePath;

/**
 *  文件夹是否在指定路径存在
 *
 *  @param filePath 文件夹位置
 *
 *  @return 是否存在，YES存在，NO不存在
 */
- (BOOL)directoryExistsAtPath:(NSString *)filePath;

/**
 *  从指定起始位置拷贝文件到目的位置
 *
 *  @param fromPath 要拷贝的文件的路径
 *  @param toPath   需要拷贝到的目的路径
 */
- (void)copyItemFromPath:(NSString *)fromPath toPath:(NSString *)toPath;

/**
 *  删除指定位置的文件
 *
 *  @param filePath 文件路径
 */
- (void)removeFileAtPath:(NSString *)filePath;

/**
 *  创建文件夹
 *
 *  @param filePath 文件夹路径
 *
 *  @return 1创建成功
 */
- (int)createDirectoryAtPath:(NSString *)filePath;

/**
 *  删除文件夹，如有有子文件或文件夹递归删除
 *
 *  @param filePath 文件夹路径
 */
- (void)removeDirectoryAtPath:(NSString *)filePath;

/**
 *  指定路径下的文件列表
 *
 *  @param filePath 文件夹路径
 *
 *  @return 返回文件列表
 */
- (NSArray *)fileListAtPath:(NSString *)filePath;

/**
 *  指定目录下面的文件夹列表
 *
 *  @param filePath 文件路径
 *
 *  @return 返回文件夹列表
 */
- (NSArray *)directoryListAtPath:(NSString *)filePath;

/**
 *  计算文件夹的大小
 *
 *  @param folderPath 文件路径
 *
 *  @return 文件夹大小,如需获取MB /(1024.0*1024.0)
 */
- (long long)folderSizeAtPath:(NSString*)folderPath;

/**
 *  计算文件的大小
 *
 *  @param filePath 文件路径
 *
 *  @return 文件大小
 */
- (long long)fileSizeAtPath:(NSString*)filePath;

@end
