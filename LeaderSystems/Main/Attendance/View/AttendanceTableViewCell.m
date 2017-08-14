//
//  AttendanceTableViewCell.m
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/6/8.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "AttendanceTableViewCell.h"

@implementation AttendanceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGBColor(241, 241, 241);
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(0);
    }];
    
    self.phoneLb.textColor = kColorMajor;
    self.workTypeLb.textColor = kColorMajor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
