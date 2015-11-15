//
//  AttachModel.h
//  BoandaProject
//
//  Created by 曾静 on 14-3-13.
//  Copyright (c) 2014年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AttachModel : NSObject

@property (nonatomic, assign) NSInteger attachID;
@property (nonatomic, strong) NSString *attachName; //附件名称
@property (nonatomic, strong) NSString *attachType; //附件类型
@property (nonatomic, strong) NSString *attachSize; //附件大小
@property (nonatomic, strong) NSString *attachToken; //附件编号
@property (nonatomic, strong) NSString *attachPath; //存放路径
@property (nonatomic, strong) NSString *attachURL; //下载地址
@property (nonatomic, strong) NSString *createUser; //创建人
@property (nonatomic, strong) NSString *createTime; //创建时间


@end
