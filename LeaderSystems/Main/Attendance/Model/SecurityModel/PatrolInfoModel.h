//
//  PatrolInfoModel.h
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/8/9.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PicturesModel.h"
#import "NowLocationdIdStateModel.h"
#import "ReportModel.h"
#import "StaffModel.h"

@interface PatrolInfoModel : NSObject
@property (nonatomic, strong) NSArray <PicturesModel *> *nowLocationdPictures; //照片集合
@property (nonatomic, strong) NowLocationdIdStateModel *nowLocationdIdState; //巡逻状态
@property (nonatomic, strong) ReportModel *nowLocationds; //巡逻报告
@property (nonatomic, strong) NSArray <StaffModel *> *nowLocationdAuxiliaryStaffs;
@property (nonatomic, strong) ReportModel *nowLocationdDispose; //处理异常
@property (nonatomic, strong) ReportModel *nowLocationdAccomplish; //完成处理
@end
