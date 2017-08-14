//
//  PunchCardsModel.m
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/6/12.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "PunchCardsModel.h"

@implementation PunchCardsModel
- (NSString *)punchCardTypeString {
    if ([self.clock_type_name isEqualToString:@"CLOCK_IN"]) {
        return @"上班打卡: ";
    }
    if ([self.clock_type_name isEqualToString:@"CLOCK_OUT"]) {
        return @"下班打卡: ";
    }
    if ([self.clock_type_name isEqualToString:@"CLOCK_FILL"]) {
        return @"补签时间: ";
    }
    return @"";
}
@end
