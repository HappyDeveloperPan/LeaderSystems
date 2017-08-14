//
//  LocationModel.h
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/6/29.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoordinateModel.h"

@interface LocationModel : NSObject
@property (nonatomic, assign) BOOL state;
@property (nonatomic, copy) NSString *entryTime;
@property (nonatomic, copy) NSString *outTime;
@property (nonatomic, assign) NSInteger staff_id;
@property (nonatomic, strong) CoordinateModel *coordinateScope;
@property (nonatomic, strong) NSArray *pictures;
@property (nonatomic, assign) NSInteger nowLocationdId;
@property (nonatomic, copy) NSString *staff_name;
@property (nonatomic, copy) NSString *report;
@property (nonatomic, assign) double lat;
@property (nonatomic, assign) double lng;
@property (nonatomic, copy) NSString *staff_phone;

@end
