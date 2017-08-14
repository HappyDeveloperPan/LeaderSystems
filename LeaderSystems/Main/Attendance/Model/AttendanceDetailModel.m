//
//  AttendanceDetailModel.m
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/6/9.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "AttendanceDetailModel.h"

@implementation AttendanceDetailModel
+ (NSDictionary *)objClassInArray {
    return @{@"arrivedDay":[DayModel class]};
}
@end
