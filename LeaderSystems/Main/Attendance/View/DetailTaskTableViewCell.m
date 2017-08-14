//
//  DetailTaskTableViewCell.m
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/8/11.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "DetailTaskTableViewCell.h"
#import "LookPhoto.h"

@implementation DetailTaskTableViewCell

#define TextFont [UIFont systemFontOfSize:16]
#define Padding 10
#define textHeight 20
#define imgWidth (kMainScreenWidth - 4*Padding)/3//高宽相等


#pragma mark - Life Circle
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
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
}

#pragma mark - Method
//安保
- (void)settingSecurityData:(NSInteger)lineID taskModel:(PatrolInfoModel *)taskModel {
    //路线
    self.siteLb.text = [NSString stringWithFormat:@"巡逻点: %ld", (long)lineID];
    [self.siteLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(Padding);
        make.right.mas_equalTo(-Padding);
        make.height.mas_equalTo(textHeight);
    }];
    //根据是否正常显示相应数据
    if (taskModel == nil) {
        NSString *unusualStr =  @"是否异常: 正常";
        self.unusualLb.attributedText = [Common colorTextWithString:unusualStr andRange:@" 正常" andColor:kColorGreen];
        [self.unusualLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Padding);
            make.right.mas_equalTo(-Padding);
            make.top.mas_equalTo(self.siteLb.mas_bottom).mas_equalTo(Padding);
            make.height.mas_equalTo(textHeight);
            make.bottom.mas_equalTo(-Padding);
        }];
    }else {
        NSString *unusualStr = @"是否异常: 异常";
        self.unusualLb.attributedText = [Common colorTextWithString:unusualStr andRange:@" 异常" andColor:KcolorRed];
        [self.unusualLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Padding);
            make.right.mas_equalTo(-Padding);
            make.top.mas_equalTo(self.siteLb.mas_bottom).mas_equalTo(Padding);
            make.height.mas_equalTo(textHeight);
        }];
        
        //处理进度
        NSString *disposeStr = [NSString stringWithFormat:@"处理进度: %@", taskModel.nowLocationdIdState.nowLocationdId_state_name];
        UIColor *textColor;
        switch (taskModel.nowLocationdIdState.nowLocationdId_state_id) {
            case 1:
            case 5:
                textColor = kColorGreen;
                break;
            case 2:
            case 3:
            case 6:
                textColor = KcolorRed;
                break;
            case 4:
                textColor = kColorYellow;
                break;
            default:
                break;
        }
        self.disposeLb.attributedText = [Common colorTextWithString:disposeStr andRange:taskModel.nowLocationdIdState.nowLocationdId_state_name andColor:textColor];
        [self.disposeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Padding);
            make.right.mas_equalTo(-Padding);
            make.top.mas_equalTo(self.unusualLb.mas_bottom).mas_equalTo(Padding);
            make.height.mas_equalTo(textHeight);
        }];
        
        //报告
        self.reportLb.text = [NSString stringWithFormat:@"报告: %@", taskModel.nowLocationds.report];
        [self.reportLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Padding);
            make.right.mas_equalTo(-Padding);
            make.top.mas_equalTo(self.disposeLb.mas_bottom).mas_equalTo(Padding);
            if (taskModel.nowLocationdPictures.count < 1) {
                make.bottom.mas_equalTo(-Padding);
            }
        }];
        self.reportLb.numberOfLines = 0;
        [self.reportLb sizeToFit];
        
        //图片
        [self imageViewWithImg:taskModel.nowLocationdPictures];
    }
}

//保洁
- (void)settingCleanData:(DetailTaskModel *)taskModel {
    //打扫区域
    self.siteLb.text = [NSString stringWithFormat:@"打扫区域: %@", taskModel.cleaningArea.cleaning_area_name];
    [self.siteLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(Padding);
        make.right.mas_equalTo(-Padding);
        make.height.mas_equalTo(textHeight);
    }];
    //开始时间
    if (taskModel.accomplishCleaningRecords.cleaning_the_end_time) {
        self.startTimeLb.text = [NSString stringWithFormat:@"开始时间: %@", taskModel.cleaningRecords.cleaning_the_start_time];
        [self.startTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Padding);
            make.right.mas_equalTo(-Padding);
            make.top.mas_equalTo(self.siteLb.mas_bottom).mas_equalTo(Padding);
            make.height.mas_equalTo(textHeight);
        }];
        //结束时间
        self.endTimeLb.text = [NSString stringWithFormat:@"完成时间: %@", taskModel.accomplishCleaningRecords.cleaning_the_end_time];
        [self.endTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Padding);
            make.right.mas_equalTo(-Padding);
            make.top.mas_equalTo(self.startTimeLb.mas_bottom).mas_equalTo(Padding);
            make.height.mas_equalTo(textHeight);
        }];
        //打扫报告
        self.reportLb.text = [NSString stringWithFormat:@"报告: %@", taskModel.accomplishCleaningRecords.report];
        [self.reportLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Padding);
            make.right.mas_equalTo(-Padding);
            make.top.mas_equalTo(self.endTimeLb.mas_bottom).mas_equalTo(Padding);
            if (taskModel.accomplishCleaningRecordsPictures.count < 1) {
                make.bottom.mas_equalTo(-Padding);
            }
        }];
        self.reportLb.numberOfLines = 0;
        [self.reportLb sizeToFit];
        //图片
        [self imageViewWithImg:taskModel.accomplishCleaningRecordsPictures];
    }else {
        self.startTimeLb.text = [NSString stringWithFormat:@"开始时间: %@", taskModel.cleaningRecords.cleaning_the_start_time];
        [self.startTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Padding);
            make.right.mas_equalTo(-Padding);
            make.top.mas_equalTo(self.siteLb.mas_bottom).mas_equalTo(Padding);
            make.height.mas_equalTo(textHeight);
            make.bottom.mas_equalTo(-Padding);
        }];
    }
}

//摆渡车
- (void)settingFerryBusData:(DetailTaskModel *)taskModel {
    //路线
    self.siteLb.text = [NSString stringWithFormat:@"路线: %@", taskModel.feeryPushLine.ferry_push_line_name];
    [self.siteLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(Padding);
        make.right.mas_equalTo(-Padding);
        make.height.mas_equalTo(textHeight);
    }];
    //车辆
    self.toolLb.text = [NSString stringWithFormat:@"绑定车辆: %@", taskModel.ferryPush.ferry_push];
    [self.toolLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Padding);
        make.right.mas_equalTo(-Padding);
        make.top.mas_equalTo(self.siteLb.mas_bottom).mas_equalTo(Padding);
        make.height.mas_equalTo(textHeight);
    }];
    //开始时间
    self.startTimeLb.text = [NSString stringWithFormat:@"开始时间: %@", taskModel.ferryPushRecord.start_time];
    [self.startTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Padding);
        make.right.mas_equalTo(-Padding);
        make.top.mas_equalTo(self.toolLb.mas_bottom).mas_equalTo(Padding);
        make.height.mas_equalTo(textHeight);
        if (!taskModel.accomplishFerryPushRecord.receipt_time) {
            make.bottom.mas_equalTo(-Padding);
        }
    }];
    //结束时间
    if (taskModel.accomplishFerryPushRecord.receipt_time) {
        self.endTimeLb.text = [NSString stringWithFormat:@"完成时间: %@", taskModel.accomplishFerryPushRecord.receipt_time];
        [self.endTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Padding);
            make.right.mas_equalTo(-Padding);
            make.top.mas_equalTo(self.startTimeLb.mas_bottom).mas_equalTo(Padding);
            make.height.mas_equalTo(textHeight);
            make.bottom.mas_equalTo(-Padding);
        }];
    }
}

- (void)settingBoatData:(DetailTaskModel *)taskModel {
    //航线
    self.siteLb.text = [NSString stringWithFormat:@"航线: %@", taskModel.cruiseLine.cruise_line_name];
    [self.siteLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(Padding);
        make.right.mas_equalTo(-Padding);
        make.height.mas_equalTo(textHeight);
    }];
    //游船
    self.toolLb.text = [NSString stringWithFormat:@"绑定船只: %@", taskModel.pleasureBoat.pleasure_boat];
    [self.toolLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Padding);
        make.right.mas_equalTo(-Padding);
        make.top.mas_equalTo(self.siteLb.mas_bottom).mas_equalTo(Padding);
        make.height.mas_equalTo(textHeight);
    }];
    //出发时间
    self.startTimeLb.text = [NSString stringWithFormat:@"出发时间: %@", taskModel.theBoatCirculationRecords.departure_time];
    [self.startTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Padding);
        make.right.mas_equalTo(-Padding);
        make.top.mas_equalTo(self.toolLb.mas_bottom).mas_equalTo(Padding);
        make.height.mas_equalTo(textHeight);
    }];
    //上船人数
    self.startNumberLb.text = [NSString stringWithFormat:@"上船人数: %d", taskModel.theBoatCirculationRecords.boarding_number];
    [self.startNumberLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Padding);
        make.right.mas_equalTo(-Padding);
        make.top.mas_equalTo(self.startTimeLb.mas_bottom).mas_equalTo(Padding);
        make.height.mas_equalTo(textHeight);
        if (!taskModel.accomplishTheBoatCirculationRecords.hitting_time) {
            make.bottom.mas_equalTo(-Padding);
        }
    }];
    
    if (taskModel.accomplishTheBoatCirculationRecords.hitting_time) {
        //靠岸时间
        self.endTimeLb.text = [NSString stringWithFormat:@"靠岸时间: %@", taskModel.accomplishTheBoatCirculationRecords.hitting_time];
        [self.endTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Padding);
            make.right.mas_equalTo(-Padding);
            make.top.mas_equalTo(self.startNumberLb.mas_bottom).mas_equalTo(Padding);
            make.height.mas_equalTo(textHeight);
        }];
        //下船人数
        self.endNumberLb.text = [NSString stringWithFormat:@"下船人数: %d", taskModel.accomplishTheBoatCirculationRecords.disembarkation_number];
        [self.endNumberLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Padding);
            make.right.mas_equalTo(-Padding);
            make.top.mas_equalTo(self.endTimeLb.mas_bottom).mas_equalTo(Padding);
            make.height.mas_equalTo(textHeight);
            make.bottom.mas_equalTo(-Padding);
        }];
    }
}

//发表的图片
- (void)imageViewWithImg:(NSArray *)imgArr{
    if (imgArr.count > 0) {
        for (int i=0;i<imgArr.count;i++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            [self.contentView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.reportLb.mas_bottom).mas_equalTo(Padding);
                make.size.mas_equalTo(CGSizeMake(imgWidth, imgWidth));
                make.left.mas_equalTo(Padding + i * (Padding+imgWidth));
                make.bottom.mas_equalTo(-Padding);
            }];
            PicturesModel *picModel = imgArr[i];
            [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",picUrl,picModel.nowLocationd_picture_url]] placeholder:[UIImage imageNamed:@"default"]];
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.userInteractionEnabled = YES;
            imageView.tag = i;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPic:)]];
            
        }
    }
}

- (void)showPic:(UITapGestureRecognizer *)tap{
    UIImageView *imageView = (UIImageView *)tap.view;
    [LookPhoto scanBigImageWithImageView:imageView];
}

#pragma mark - Lazy Load
- (UILabel *)siteLb {
    if (!_siteLb) {
        _siteLb = [[UILabel alloc] init];
        [self.contentView addSubview:_siteLb];
        _siteLb.font = TextFont;
        _siteLb.textColor = kColorMajor;
    }
    return _siteLb;
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

- (UILabel *)disposeLb {
    if (!_disposeLb) {
        _disposeLb = [[UILabel alloc] init];
        [self.contentView addSubview:_disposeLb];
        _disposeLb.font = TextFont;
        _disposeLb.textColor = kColorMajor;
    }
    return _disposeLb;
}

- (UILabel *)reportLb {
    if (!_reportLb) {
        _reportLb = [[UILabel alloc] init];
        [self.contentView addSubview:_reportLb];
        _reportLb.font = TextFont;
        _reportLb.textColor = kColorMajor;
    }
    return _reportLb;
}

- (UILabel *)startTimeLb {
    if (!_startTimeLb) {
        _startTimeLb = [[UILabel alloc] init];
        [self.contentView addSubview:_startTimeLb];
        _startTimeLb.font = TextFont;
        _startTimeLb.textColor = kColorMajor;
    }
    return _startTimeLb;
}

- (UILabel *)endTimeLb {
    if (!_endTimeLb) {
        _endTimeLb = [[UILabel alloc] init];
        [self.contentView addSubview:_endTimeLb];
        _endTimeLb.font = TextFont;
        _endTimeLb.textColor = kColorMajor;
    }
    return _endTimeLb;
}

- (UILabel *)startNumberLb {
    if (!_startNumberLb) {
        _startNumberLb = [[UILabel alloc] init];
        [self.contentView addSubview:_startNumberLb];
        _startNumberLb.font = TextFont;
        _startNumberLb.textColor = kColorMajor;
    }
    return _startNumberLb;
}

- (UILabel *)endNumberLb {
    if (!_endNumberLb) {
        _endNumberLb = [[UILabel alloc] init];
        [self.contentView addSubview:_endNumberLb];
        _endNumberLb.font = TextFont;
        _endNumberLb.textColor = kColorMajor;
    }
    return _endNumberLb;
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








@end
