//
//  PunchCardsModel.h
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/6/12.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PunchCardsModel : NSObject
@property (nonatomic, copy) NSString *clock_type_name; //打卡类型
@property (nonatomic, copy) NSString *clock_time; //打卡时间
@property (nonatomic, assign) NSInteger staff_id;
@property (nonatomic, assign) NSInteger clock_type_id;
@property (nonatomic, assign) NSInteger clock_id;
@property (nonatomic, assign) NSInteger timeDifference;

- (NSString *)punchCardTypeString;
@end
