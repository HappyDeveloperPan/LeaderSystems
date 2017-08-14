//
//  LineModel.h
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/6/29.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoordinateModel.h"

@interface LineModel : NSObject
//安保
@property (nonatomic, assign) NSInteger the_security_line_id;
@property (nonatomic, copy) NSString *the_security_line_name;
@property (nonatomic, strong) NSArray <CoordinateModel *>*the_security_line;

//保洁
@property (nonatomic, assign) NSInteger cleaning_area_id;
@property (nonatomic, copy) NSString *cleaning_area_name;
@property (nonatomic, assign) int  cleaning_area_limit_id;
@property (nonatomic, strong) NSArray <CoordinateModel *>*cleaning_area;
//摆渡车
@property (nonatomic, assign) NSInteger ferry_push_line_id;
@property (nonatomic, copy) NSString *ferry_push_line_name;
@property (nonatomic, strong) NSArray <CoordinateModel *>*ferry_push_line;

//游船
@property (nonatomic, copy) NSString *cruise_line_name;
@property (nonatomic, assign) NSInteger cruise_line_id;
@property (nonatomic, strong) NSArray <CoordinateModel *>*cruise_line;
@end
