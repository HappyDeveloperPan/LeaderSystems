//
//  CheckModel.h
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/6/29.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaskModel.h"
#import "LocationModel.h"
#import "LineModel.h"
#import "WorkToolsModel.h"

@interface CheckModel : NSObject
@property (nonatomic, strong) TaskModel *task;
@property (nonatomic, strong) NSArray <LocationModel *> *nowLocationdss;
@property (nonatomic, strong) LineModel *line;
@property (nonatomic, strong) WorkToolsModel *workTools;
@end
