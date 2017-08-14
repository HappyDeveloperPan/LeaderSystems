//
//  TaskTableViewCell.h
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/8/10.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailTaskModel.h"

@interface TaskTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *lineLb;
@property (nonatomic, strong) UILabel *completeLb;
@property (nonatomic, strong) UILabel *unusualLb;
@property (nonatomic, strong) UILabel *toolLb;
@property (nonatomic, strong) UILabel *timeLb;
@property (nonatomic, strong) UIView *lineView;

//安保
- (void)settingSecurityData:(DetailTaskModel *)taskModel;
- (void)settingSecurityFrame:(DetailTaskModel *)taskModel;
//保洁
- (void)settingCleanData:(DetailTaskModel *)taskModel;
- (void)settingCleanFrame:(DetailTaskModel *)taskModel;
//摆渡车
- (void)settingFerrybusData:(DetailTaskModel *)taskModel;
- (void)settingFerrybusFrame:(DetailTaskModel *)taskModel;
//游船
- (void)settingBoatData:(DetailTaskModel *)taskModel;
- (void)settingBoatFrame:(DetailTaskModel *)taskModel;
@end
