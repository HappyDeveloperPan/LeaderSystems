//
//  PatrolInfoModel.m
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/8/9.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "PatrolInfoModel.h"

@implementation PatrolInfoModel
+ (NSDictionary *)objClassInArray {
    return @{@"nowLocationdPictures":[PicturesModel class], @"nowLocationdAuxiliaryStaffs":[StaffModel class]};
}
@end
