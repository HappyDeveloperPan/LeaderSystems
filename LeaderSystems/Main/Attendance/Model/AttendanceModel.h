//
//  AttendanceModel.h
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/6/8.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AttendanceModel : NSObject
@property (nonatomic, assign) NSInteger staff_id;
@property (nonatomic, copy) NSString *staff_phone;
@property (nonatomic, copy) NSString *staff_name;
@property (nonatomic, assign) NSInteger type_of_work_id;
@property (nonatomic, copy) NSString *type_of_work_name;
@property (nonatomic, copy) NSString *staff_sex;

- (NSString *)workType;

@end
