//
//  WorkingDetailViewController.h
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/6/15.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StaffWorkingModel.h"

@interface WorkingDetailViewController : UIViewController
@property (nonatomic, assign) BOOL isOnline;
@property (nonatomic, strong) StaffWorkingModel *staffModel;
@end
