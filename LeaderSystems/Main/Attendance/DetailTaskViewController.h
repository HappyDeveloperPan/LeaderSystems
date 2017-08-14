//
//  DetailTaskViewController.h
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/8/11.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StaffModel.h"
#import "DetailTaskModel.h"

@interface DetailTaskViewController : UIViewController
@property (nonatomic, strong) StaffModel *staffModel;
@property (nonatomic, strong) DetailTaskModel *taskModel;
@end
