//
//  LineModel.m
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/6/29.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "LineModel.h"

@implementation LineModel
+ (NSDictionary *)objClassInArray {
    return @{@"the_security_line":[CoordinateModel class], @"cleaning_area":[CoordinateModel class], @"ferry_push_line":[CoordinateModel class], @"cruise_line":[CoordinateModel class]};
}
@end
