//
//  DetailCheckTableViewCell.h
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/6/29.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckModel.h"

@interface DetailCheckTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lineNameLb;
@property (weak, nonatomic) IBOutlet UILabel *linePointLb;
@property (weak, nonatomic) IBOutlet UILabel *reportLb;
@property (weak, nonatomic) IBOutlet UIView *imageBg;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLb;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *linePointHeight;
@property (weak, nonatomic) IBOutlet UILabel *startNumberLb;
@property (weak, nonatomic) IBOutlet UILabel *endNumberLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *startNumberHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *endNumberHeight;

- (void)setCleanContentWithModel:(CheckModel *)checkModel;

- (void)setSecurityContentWithModel:(LocationModel *)locationModel;

- (void)setBoatContentWithModel:(CheckModel *)checkModel;

- (void)setFerrybusContentWithModel:(CheckModel *)checkModel;

@end
