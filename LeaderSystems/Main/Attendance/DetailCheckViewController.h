//
//  DetailCheckViewController.h
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/6/29.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "AttendanceModel.h"
#import "StaffModel.h"

@interface DetailCheckViewController : UIViewController
//@property (nonatomic, assign) NSInteger type_of_work_id;
@property (nonatomic, copy) NSDate *date;
//@property (nonatomic, assign) NSInteger staffId;
//@property (nonatomic, strong) AttendanceModel *staffModel;
@property (nonatomic, strong) StaffModel *staffModel;
@property (nonatomic, assign) BOOL isShowDate;
@end
