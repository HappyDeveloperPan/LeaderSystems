//
//  CoordinateModel.h
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/6/29.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoordinateModel : NSObject
@property (nonatomic, assign) NSInteger order;
@property (nonatomic, assign) double lat;
@property (nonatomic, assign) double lng;
//安保
@property (nonatomic, assign) int the_security_line_id;
@property (nonatomic, assign) int the_security_line_latlng_id;
@property (nonatomic, assign) int the_security_line_latlng_limit_id; //规则id
@property (nonatomic, assign) int beg_the_security_line_latlng_id; //起始坐标id
@property (nonatomic, assign) int end_the_security_line_latlng_id; //结束坐标id
@property (nonatomic, assign) double limit_time; //停留时间

//保洁
@property (nonatomic, assign) int cleaning_area_latlng_id; // 坐标点id
@property (nonatomic, assign) int cleaning_area_id; //区域id
@property (nonatomic, assign) double least_clean_time; //最小打扫时间
@property (nonatomic, assign) double biggest_clean_time; //最大打扫时间
@property (nonatomic, assign) int cleaning_area_limit_id; //规则id

//摆渡车
@property (nonatomic, assign) int ferry_push_line_latlng_id; //坐标点id
@property (nonatomic, assign) int ferry_push_line_id; //路线id

//游船
@property (nonatomic, assign) int cruise_line_latlng_id;
@property (nonatomic, assign) int cruise_line_id;
@end
