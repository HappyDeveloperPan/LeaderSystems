//
//  OnlineStaffCollectionViewCell.h
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/7/13.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StaffOnLineModel.h"

@interface OnlineStaffCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UILabel *workTypeLb;
@property (nonatomic, strong) UILabel *phoneLb;
@property (nonatomic, strong) UILabel *distanceLb;
@property (nonatomic, strong) UIImageView *selectImg;

- (void)showCellData:(StaffOnLineModel *)model;

@end
