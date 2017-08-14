//
//  DetailInfoModel.h
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/6/20.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoordinateModel.h"

@interface DetailInfoModel : NSObject
@property (nonatomic, assign) NSInteger staff_id;
@property (nonatomic, copy) NSString *staff_name;
@property (nonatomic, copy) NSString *staff_phone;
@property (nonatomic, copy) NSString *origin;
@property (nonatomic, copy) NSString *result;
@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, copy) NSString *over_time;
@property (nonatomic, assign) NSInteger emergency_calling_id;//一键求助id
@property (nonatomic, assign) NSInteger backstage_login_id;//后台处理用户id
@property (nonatomic, assign) BOOL isComplete; //是否处理成
@property (nonatomic, assign) BOOL isHandle;  //后台用户是否处理
@property (nonatomic, assign) NSInteger emergency_calling_type_id;
@property (nonatomic, copy) NSString *emergency_calling_type;


@property (nonatomic, copy) NSString *entryTime;
@property (nonatomic, copy) NSString *outTime;
@property (nonatomic, strong) CoordinateModel *coordinateScope;
@property (nonatomic, assign) float lat;
@property (nonatomic, assign) float lng;
@property (nonatomic, copy) NSString *report;
@property (nonatomic, assign) BOOL state;
@property (nonatomic, assign) NSInteger nowLocationdId;
@property (nonatomic, copy) NSString *one_picture; //第一张图片
@property (nonatomic, copy) NSString *two_picture;
@property (nonatomic, copy) NSString *three_picture;
@property (nonatomic, strong) NSArray *pictures;
@property (nonatomic, assign) BOOL isDispose; //是否处理
@property (nonatomic, copy) NSString *disposeResult; //处理结果

@end
