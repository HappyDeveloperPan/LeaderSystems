//
//  AttendanceDetailModel.h
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/6/9.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DayModel.h"
#import "AttendanceModel.h"

@interface AttendanceDetailModel : NSObject
//@property (nonatomic, assign) NSInteger clock_id;
//@property (nonatomic, assign) NSInteger staff_id;
//@property (nonatomic, copy) NSString *clock_time;
@property (nonatomic, strong) NSArray <DayModel *> *arrivedDay;
//@property (nonatomic, strong) NSArray <DayModel *> *nonArrivedDay;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger year;
@property (nonatomic, strong) AttendanceModel *staff;
@end
