//
//  InfoListModel.h
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/6/20.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailInfoModel.h"
#import "NowLocationdIdStateModel.h"
#import "NowLocationdsModel.h"
#import "StaffModel.h"

@interface InfoListModel : NSObject
//一键求助
@property (nonatomic, assign) NSInteger ioSessionId;
@property (nonatomic, strong) DetailInfoModel *emergencyCallingInfo;
@property (nonatomic, assign) BOOL isOnLine;
//安保异常
@property (nonatomic, strong) NowLocationdIdStateModel *nowLocationdIdState;
@property (nonatomic, strong) NowLocationdsModel *nowLocationds;
@property (nonatomic, strong) StaffModel *staff;
@end
