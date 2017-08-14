//
//  DetailTaskTableViewCell.h
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/8/11.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailTaskModel.h"

@interface DetailTaskTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *siteLb;      //地点
@property (nonatomic, strong) UILabel *unusualLb;  //是否异常
@property (nonatomic, strong) UILabel *disposeLb; //处理进度
@property (nonatomic, strong) UILabel *reportLb; //报告
@property (nonatomic, strong) UILabel *toolLb; //工具
@property (nonatomic, strong) UILabel *startTimeLb; //开始时间
@property (nonatomic, strong) UILabel *endTimeLb; //结束时间
@property (nonatomic, strong) UILabel *startNumberLb; //开船人数
@property (nonatomic, strong) UILabel *endNumberLb; //下船人数
@property (nonatomic, strong) UIView *lineView;

//安保
- (void)settingSecurityData:(NSInteger)lineID taskModel:(PatrolInfoModel *)taskModel;
//保洁
- (void)settingCleanData:(DetailTaskModel *)taskModel;
//摆渡车
- (void)settingFerryBusData:(DetailTaskModel *)taskModel;
//游船
- (void)settingBoatData:(DetailTaskModel *)taskModel;
@end
