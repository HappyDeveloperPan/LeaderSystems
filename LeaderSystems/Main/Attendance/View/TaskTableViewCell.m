//
//  TaskTableViewCell.m
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/8/10.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "TaskTableViewCell.h"

@implementation TaskTableViewCell

#define TextFont [UIFont systemFontOfSize:16]
#define Padding 10
#define Height 20

#pragma mark - Life Circle
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = RGBColor(241, 241, 241);
        [self.contentView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(-16);
            make.height.mas_equalTo(1);
            make.bottom.mas_equalTo(0);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Method
/************安保*************/
- (void)settingSecurityData:(DetailTaskModel *)taskModel {
    self.lineLb.text = [NSString stringWithFormat:@"巡逻路线: %@", taskModel.theSecurityLine.the_security_line_name];
    NSString *textStr = [NSString stringWithFormat:@"任务状态: %@",taskModel.securityPatrolRecordState.security_patrol_record_state_name];
    if (taskModel.securityPatrolRecordState.security_patrol_record_state_id == 2) {
        self.completeLb.attributedText = [Common colorTextWithString:textStr andRange:taskModel.securityPatrolRecordState.security_patrol_record_state_name andColor:kColorGreen];
    }else {
        self.completeLb.attributedText = [Common colorTextWithString:textStr andRange:taskModel.securityPatrolRecordState.security_patrol_record_state_name andColor:KcolorRed];
    }
    
    if (taskModel.nowLocationdsInfos.count > 0) {
        NSString *textStr = @"是否异常: 异常";
        self.unusualLb.attributedText = [Common colorTextWithString:textStr andRange:@" 异常" andColor:KcolorRed];
    }else {
        NSString *textStr = @"是否异常: 正常";
        self.unusualLb.attributedText = [Common colorTextWithString:textStr andRange:@" 正常" andColor:kColorGreen];
    }
    self.timeLb.text = taskModel.securityPatrolRecord.security_patrol_start_time;
}

- (void)settingSecurityFrame:(DetailTaskModel *)taskModel {
    
    [self.lineLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(Padding);
        make.right.mas_equalTo(-Padding);
        make.height.mas_equalTo(Height);
    }];
    
    [self.completeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Padding);
        make.right.mas_equalTo(-Padding);
        make.top.mas_equalTo(self.lineLb.mas_bottom).mas_equalTo(Padding);
        make.height.mas_equalTo(Height);
    }];
    
    [self.unusualLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Padding);
        make.right.mas_equalTo(-Padding);
        make.top.mas_equalTo(self.completeLb.mas_bottom).mas_equalTo(Padding);
        make.height.mas_equalTo(Height);
    }];
    
    [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Padding);
        make.right.mas_equalTo(-Padding);
        make.top.mas_equalTo(self.unusualLb.mas_bottom).mas_equalTo(5);
        make.height.mas_equalTo(Height);
        make.bottom.mas_equalTo(-5);
    }];
}

/**************保洁***************/
- (void)settingCleanData:(DetailTaskModel *)taskModel {
    self.lineLb.text = [NSString stringWithFormat:@"打扫区域: %@", taskModel.cleaningArea.cleaning_area_name];
    NSString *textStr = [NSString stringWithFormat:@"任务状态: %@",taskModel.cleaningRecordsState.cleaning_records_state_name];
    if (taskModel.cleaningRecordsState.cleaning_records_state_id == 2) {
        self.completeLb.attributedText = [Common colorTextWithString:textStr andRange:taskModel.cleaningRecordsState.cleaning_records_state_name andColor:kColorGreen];
    }else {
        self.completeLb.attributedText = [Common colorTextWithString:textStr andRange:taskModel.cleaningRecordsState.cleaning_records_state_name andColor:KcolorRed];
    }
    self.timeLb.text = taskModel.cleaningRecords.cleaning_the_start_time;
}

- (void)settingCleanFrame:(DetailTaskModel *)taskModel {
    [self.lineLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(Padding);
        make.right.mas_equalTo(-Padding);
        make.height.mas_equalTo(Height);
    }];
    
    [self.completeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Padding);
        make.right.mas_equalTo(-Padding);
        make.top.mas_equalTo(self.lineLb.mas_bottom).mas_equalTo(Padding);
        make.height.mas_equalTo(Height);
    }];
    
    
    [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Padding);
        make.right.mas_equalTo(-Padding);
        make.top.mas_equalTo(self.completeLb.mas_bottom).mas_equalTo(5);
        make.height.mas_equalTo(Height);
        make.bottom.mas_equalTo(-5);
    }];
}

/*************摆渡车**************/
- (void)settingFerrybusData:(DetailTaskModel *)taskModel {
    self.lineLb.text = [NSString stringWithFormat:@"路线: %@", taskModel.feeryPushLine.ferry_push_line_name];
    self.toolLb.text = [NSString stringWithFormat:@"使用车辆: %@", taskModel.ferryPush.ferry_push];
    NSString *textStr = [NSString stringWithFormat:@"任务状态: %@",taskModel.ferryPushRecordState.ferry_push_record_state_name];
    if (taskModel.ferryPushRecordState.ferry_push_record_state_id == 2) {
        self.completeLb.attributedText = [Common colorTextWithString:textStr andRange:taskModel.ferryPushRecordState.ferry_push_record_state_name andColor:kColorGreen];
    }else {
        self.completeLb.attributedText = [Common colorTextWithString:textStr andRange:taskModel.ferryPushRecordState.ferry_push_record_state_name andColor:KcolorRed];
    }
    self.timeLb.text = taskModel.ferryPushRecord.start_time;
}

- (void)settingFerrybusFrame:(DetailTaskModel *)taskModel {
    [self.lineLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(Padding);
        make.right.mas_equalTo(-Padding);
        make.height.mas_equalTo(Height);
    }];
    
    [self.toolLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Padding);
        make.right.mas_equalTo(-Padding);
        make.top.mas_equalTo(self.lineLb.mas_bottom).mas_equalTo(Padding);
        make.height.mas_equalTo(Height);
    }];
    
    [self.completeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Padding);
        make.right.mas_equalTo(-Padding);
        make.top.mas_equalTo(self.toolLb.mas_bottom).mas_equalTo(Padding);
        make.height.mas_equalTo(Height);
    }];
    
    [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Padding);
        make.right.mas_equalTo(-Padding);
        make.top.mas_equalTo(self.completeLb.mas_bottom).mas_equalTo(5);
        make.height.mas_equalTo(Height);
        make.bottom.mas_equalTo(-5);
    }];
}

/**************游船****************/
- (void)settingBoatData:(DetailTaskModel *)taskModel {
    self.lineLb.text = [NSString stringWithFormat:@"航线: %@", taskModel.cruiseLine.cruise_line_name];
    self.toolLb.text = [NSString stringWithFormat:@"使用船只: %@", taskModel.pleasureBoat.pleasure_boat];
    NSString *textStr = [NSString stringWithFormat:@"任务状态: %@",taskModel.theBoatCirculationRecordsState.the_boat_circulation_records_state_name];
    if (taskModel.theBoatCirculationRecordsState.the_boat_circulation_records_state_id == 2) {
        self.completeLb.attributedText = [Common colorTextWithString:textStr andRange:taskModel.theBoatCirculationRecordsState.the_boat_circulation_records_state_name andColor:kColorGreen];
    }else {
        self.completeLb.attributedText = [Common colorTextWithString:textStr andRange:taskModel.theBoatCirculationRecordsState.the_boat_circulation_records_state_name andColor:KcolorRed];
    }
    self.timeLb.text = taskModel.theBoatCirculationRecords.departure_time;
}

- (void)settingBoatFrame:(DetailTaskModel *)taskModel {
    [self.lineLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(Padding);
        make.right.mas_equalTo(-Padding);
        make.height.mas_equalTo(Height);
    }];
    
    [self.toolLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Padding);
        make.right.mas_equalTo(-Padding);
        make.top.mas_equalTo(self.lineLb.mas_bottom).mas_equalTo(Padding);
        make.height.mas_equalTo(Height);
    }];
    
    [self.completeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Padding);
        make.right.mas_equalTo(-Padding);
        make.top.mas_equalTo(self.toolLb.mas_bottom).mas_equalTo(Padding);
        make.height.mas_equalTo(Height);
    }];
    
    [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Padding);
        make.right.mas_equalTo(-Padding);
        make.top.mas_equalTo(self.completeLb.mas_bottom).mas_equalTo(5);
        make.height.mas_equalTo(Height);
        make.bottom.mas_equalTo(-5);
    }];
}

#pragma mark - Lazy Load
- (UILabel *)lineLb {
    if (!_lineLb) {
        _lineLb = [[UILabel alloc] init];
        [self.contentView addSubview:_lineLb];
        _lineLb.font = TextFont;
        _lineLb.textColor = kColorMajor;
    }
    return _lineLb;
}

- (UILabel *)completeLb {
    if (!_completeLb) {
        _completeLb = [[UILabel alloc] init];
        [self.contentView addSubview:_completeLb];
        _completeLb.font = TextFont;
        _completeLb.textColor = kColorMajor;
    }
    return _completeLb;
}

- (UILabel *)unusualLb {
    if (!_unusualLb) {
        _unusualLb = [[UILabel alloc] init];
        [self.contentView addSubview:_unusualLb];
        _unusualLb.font = TextFont;
        _unusualLb.textColor = kColorMajor;
    }
    return _unusualLb;
}

- (UILabel *)toolLb {
    if (!_toolLb) {
        _toolLb = [[UILabel alloc] init];
        [self.contentView addSubview:_toolLb];
        _toolLb.font = TextFont;
        _toolLb.textColor = kColorMajor;
    }
    return _toolLb;
}

- (UILabel *)timeLb {
    if (!_timeLb) {
        _timeLb = [[UILabel alloc] init];
        [self.contentView addSubview:_timeLb];
        _timeLb.font = [UIFont systemFontOfSize:14];
        _timeLb.textColor = kColorMajor;
        _timeLb.textAlignment = NSTextAlignmentRight;
    }
    return _timeLb;
}

@end
