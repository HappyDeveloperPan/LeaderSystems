//
//  ReportModel.h
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/8/9.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReportModel : NSObject
/***************安保*******************/
@property (nonatomic, assign) int staff_id;
@property (nonatomic, assign) int the_security_line_id; //安保路线id
@property (nonatomic, copy) NSString *security_patrol_start_time; //任务开始时间
@property (nonatomic, assign) int security_patrol_record_state_id; //安保任务状态id
@property (nonatomic, copy) NSString *security_patrol_record_state_name; //安保任务状态
@property (nonatomic, copy) NSString *security_patrol_over_time; //巡逻完成时间
@property (nonatomic, assign) int accomplish_security_patrol_record_state_id; //完成状态id
@property (nonatomic, copy) NSString *accomplish_security_patrol_record_state_name; //安保巡逻完成状态

//提交异常
@property (nonatomic, copy) NSString *report; //报告
@property (nonatomic, assign) int the_security_line_latlng_id;
@property (nonatomic, assign) int nowLocationdId_state_id;
@property (nonatomic, assign) int nowLocationdId;
@property (nonatomic, copy) NSString *completion_time; //完成时间
@property (nonatomic, assign) int security_patrol_record_id;
@property (nonatomic, assign) float lat;
@property (nonatomic, assign) float lng;

//处理异常
@property (nonatomic, assign) int leader_account_id;
@property (nonatomic, copy) NSString *dispose_result; //处理报告
@property (nonatomic, copy) NSString *dispose_time; //处理时间

//完成处理
@property (nonatomic, copy) NSString *conclusion; //完成处理结果
@property (nonatomic, copy) NSString *accomplish_time; //完成处理时间

/***************保洁*******************/
@property (nonatomic, assign) int cleaning_records_id; //保洁任务id
@property (nonatomic, assign) int cleaning_area_id;  //保洁范围id
@property (nonatomic, copy) NSString *cleaning_the_start_time; //开始打扫时间
@property (nonatomic, assign) int cleaning_records_state_id; // 宝洁任务状态状态id
@property (nonatomic, copy) NSString *cleaning_records_state_name; //保洁任务状态名称
@property (nonatomic, copy) NSString *cleaning_the_end_time; //结束打扫时间
@property (nonatomic, assign) int accomplish_cleaning_records_state_id; //完成状态id
@property (nonatomic, copy) NSString *accomplish_cleaning_records_state_name; //完成状态名称

/***************摆渡车*****************/
@property (nonatomic, assign) int choose_shuttle_buses_id; //摆渡车管理id
@property (nonatomic, assign) int ferry_push_line_id; //摆渡车路线id
@property (nonatomic, assign) int ferry_push_record_id; //摆渡车任务id
@property (nonatomic, copy) NSString *start_time; //任务开始时间
@property (nonatomic, assign) int ferry_push_record_state_id; //摆渡车任务状态id
@property (nonatomic, copy) NSString *ferry_push_record_state_name; //摆渡车任务状态名称
@property (nonatomic, copy) NSString *ferry_push; //摆渡车名称
@property (nonatomic, assign) int ferry_push_id; //摆渡车id
@property (nonatomic, assign) int ferry_push_state_id; //摆渡车状态id
@property (nonatomic, copy) NSString *ferry_push_state; //摆渡车状态
@property (nonatomic, copy) NSString *receipt_time; //完成任务时间

/***************游船*****************/
@property (nonatomic, assign) int cruise_line_id; //游船路线id
@property (nonatomic, assign) int the_boat_circulation_records_id; //游船任务id
@property (nonatomic, copy) NSString *departure_time; //出发时间
@property (nonatomic, assign) int the_boat_circulation_records_state_id; //任务状态id
@property (nonatomic, copy) NSString *the_boat_circulation_records_state_name; //游船任务状态
@property (nonatomic, assign) int choose_pleasure_boat_id; //选择游船id
@property (nonatomic, assign) int boarding_number; //上船人数
@property (nonatomic, assign) int pleasure_boat_id; //游船id
@property (nonatomic, copy) NSString *pleasure_boat; //游船名称
@property (nonatomic, assign) int pleasure_boat_state_id; //游船状态id
@property (nonatomic, copy) NSString *pleasure_boat_state; //游船状态名称
@property (nonatomic, assign) int disembarkation_number; //停船人数
@property (nonatomic, copy) NSString *hitting_time; //停船时间


@end
