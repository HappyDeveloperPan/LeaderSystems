//
//  DetailTaskModel.m
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/8/9.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "DetailTaskModel.h"

@implementation DetailTaskModel
+ (NSDictionary *)objClassInArray {
    return @{@"nowLocationdsInfos":[PatrolInfoModel class], @"theSecurityLineLatlngs":[CoordinateModel class], @"cleaningAreaLatlngs":[CoordinateModel class], @"accomplishCleaningRecordsPictures":[PicturesModel class], @"ferryPushLineLatlngs":[CoordinateModel class], @"cruiseLineLatlngs":[CoordinateModel class]};
}
@end
