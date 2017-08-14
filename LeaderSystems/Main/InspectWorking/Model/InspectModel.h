//
//  InspectModel.h
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/6/14.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StaffWorkingModel.h"

@interface InspectModel : NSObject
@property (nonatomic, strong) NSArray<StaffWorkingModel *> *onLineStaff;
@property (nonatomic, strong) NSArray<StaffWorkingModel *> *notOnlineStaff;
@end
