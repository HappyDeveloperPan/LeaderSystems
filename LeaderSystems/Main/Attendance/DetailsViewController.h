//
//  DetailsViewController.h
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/6/9.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StaffModel.h"

@interface DetailsViewController : UIViewController
@property (nonatomic, assign) NSInteger staffId;
@property (nonatomic, assign) NSInteger type_of_work_id;
@property (nonatomic, strong) StaffModel *staffModel;
@end
