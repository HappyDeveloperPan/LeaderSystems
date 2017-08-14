//
//  StaffModel.h
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/6/14.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StaffModel : NSObject
@property (nonatomic, copy) NSString *staff_sex;
@property (nonatomic, assign) NSInteger staff_id;
@property (nonatomic, assign) NSInteger staff_age;
@property (nonatomic, assign) NSInteger type_of_work_id;
@property (nonatomic, copy) NSString *type_of_work_name;
@property (nonatomic, copy) NSString *staff_name;
@property (nonatomic, copy) NSString *staff_phone;
@property (nonatomic, assign) NSInteger registration_code_id;
@property (nonatomic, assign) int nowLocationd_auxiliary_staff;
@property (nonatomic, assign) int nowLocationdId;

- (NSString *)workType;

@end
