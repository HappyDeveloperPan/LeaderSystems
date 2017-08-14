//
//  AttendanceModel.m
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/6/8.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "AttendanceModel.h"

@implementation AttendanceModel
- (NSString *)workType {
    switch (self.type_of_work_id) {
        case 1:
            return @"安保";
            break;
        case 2:
            return @"保洁";
            break;
        case 3:
            return @"摆渡车";
            break;
        case 4:
            return @"游船";
            break;
        default:
            break;
    }
    return @"";
}
@end
