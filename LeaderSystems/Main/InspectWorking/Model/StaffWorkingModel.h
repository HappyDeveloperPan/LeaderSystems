//
//  StaffWorkingModel.h
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/6/15.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StaffModel.h"
#import "LineModel.h"

@interface StaffWorkingModel : NSObject
@property (nonatomic, assign) NSInteger ioSessionId;
@property (nonatomic, strong) StaffModel *staff;
@property (nonatomic, strong) CoordinateModel *latLng;
@property (nonatomic, assign) BOOL onLine;
@property (nonatomic, strong) LineModel *line;
@end
