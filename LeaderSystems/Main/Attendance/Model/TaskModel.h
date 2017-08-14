//
//  TaskModel.h
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/6/29.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskModel : NSObject
//安保
@property (nonatomic, assign) NSInteger security_patrol_record_id;
@property (nonatomic, assign) NSInteger staff_id;
@property (nonatomic, assign) NSInteger the_security_line_id;
@property (nonatomic, copy) NSString *security_patrol_start_time;
@property (nonatomic, copy) NSString *security_patrol_over_time;
//保洁
@property (nonatomic, copy) NSString *report;
@property (nonatomic, copy) NSString *cleaning_the_start_time;
@property (nonatomic, copy) NSString *cleaning_the_end_time;
@property (nonatomic, strong) NSArray *pictures;
@property (nonatomic, assign) NSInteger cleaning_records_id;
@property (nonatomic, assign) NSInteger cleaning_area_id;
@property (nonatomic, assign) double lat;
@property (nonatomic, assign) double lng;
//摆渡车
@property (nonatomic, assign) NSInteger choose_shuttle_buses_id;
@property (nonatomic, assign) NSInteger ferry_push_line_id;
@property (nonatomic, assign) NSInteger ferry_push_record_id;
@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, copy) NSString *receipt_time;

//游船
@property (nonatomic, assign) NSInteger disembarkation_number;
@property (nonatomic, assign) NSInteger boarding_number;
@property (nonatomic, assign) NSInteger the_boat_circulation_records_id;
@property (nonatomic, assign) NSInteger choose_pleasure_boat_id;
@property (nonatomic, copy) NSString *hitting_time;
@property (nonatomic, copy) NSString *departure_time;

@end
