//
//  OnlineStaffCollectionViewCell.m
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/7/13.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "OnlineStaffCollectionViewCell.h"


#define kLeft 10
#define kTop  10
#define kHeight 20

@implementation OnlineStaffCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kColorMain;
        self.layer.cornerRadius = 5;
        
        //姓名
        _nameLb = [[UILabel alloc] initWithFrame:CGRectMake(kLeft, kTop, self.width - kLeft * 2, kHeight)];
        _nameLb.textColor = kColorWhite;
        _nameLb.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_nameLb];
        
        //工种
        _workTypeLb = [[UILabel alloc] initWithFrame:CGRectMake(kLeft, _nameLb.bottom + 5, self.width - kLeft * 2, kHeight)];
        _workTypeLb.textColor = kColorWhite;
        _workTypeLb.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_workTypeLb];
        
        //电话
        _phoneLb = [[UILabel alloc] initWithFrame:CGRectMake(kLeft, _workTypeLb.bottom + 5, self.width - kLeft * 2, kHeight)];
        _phoneLb.textColor = kColorWhite;
        _phoneLb.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_phoneLb];
        
        //距离
        _distanceLb = [[UILabel alloc] initWithFrame:CGRectMake(kLeft, _phoneLb.bottom + 5, self.width - kLeft * 2, kHeight)];
        _distanceLb.textColor = kColorWhite;
        _distanceLb.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_distanceLb];
        
        //选择图片
        _selectImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.width - 20, 0, 20, 20)];
        [_selectImg setImage:[UIImage imageNamed:@"checkmark"]];
        _selectImg.hidden = YES;
        [self.contentView addSubview:_selectImg];
    }
    return self;
}

- (void)showCellData:(StaffOnLineModel *)model {
    self.nameLb.text = [NSString stringWithFormat:@"姓名: %@", model.staff.staff_name];
    self.workTypeLb.text = [NSString stringWithFormat:@"工种: %@", model.staff.workType];
    self.phoneLb.text = [NSString stringWithFormat:@"电话: %@", model.staff.staff_phone];
    self.distanceLb.text = [NSString stringWithFormat:@"距离: %.2f米", model.distance];
}

@end
