//
//  WorkToolsModel.h
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/6/29.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorkToolsModel : NSObject
//摆渡车
@property (nonatomic, assign) NSInteger ferry_push_id;
@property (nonatomic, copy) NSString *ferry_push;
@property (nonatomic, assign) NSInteger ferry_push_state_id;
//游船
@property (nonatomic, assign) NSInteger pleasure_boat_state_id;
@property (nonatomic, copy) NSString *pleasure_boat;
@property (nonatomic, assign) NSInteger pleasure_boat_id;
@end
