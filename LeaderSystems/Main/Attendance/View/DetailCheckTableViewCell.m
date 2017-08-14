//
//  DetailCheckTableViewCell.m
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/6/29.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "DetailCheckTableViewCell.h"
#import "LookPhoto.h"

#define imgWidth 80//高宽相等
#define imgLeft (kMainScreenWidth - imgWidth*3 - 10 - 20)/6

@implementation DetailCheckTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGBColor(241, 241, 241);
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(0);
    }];
    
    self.reportLb.numberOfLines = 0;
}

- (void)setSecurityContentWithModel:(LocationModel *)locationModel {
    self.linePointLb.text = [NSString stringWithFormat:@"巡逻点: %ld", (long)locationModel.coordinateScope.order];
    self.startTimeLb.text = [NSString stringWithFormat:@"开始时间: %@", locationModel.entryTime];
    self.endTimeLb.text = [NSString stringWithFormat:@"结束时间: %@", locationModel.outTime];
    self.reportLb.text = [NSString stringWithFormat:@"报告: %@", locationModel.report];
    self.startNumberHeight.constant = 0;
    self.endNumberHeight.constant = 0;
    
    [self imageViewWithImg:locationModel.pictures];
}

- (void)setCleanContentWithModel:(CheckModel *)checkModel {
    self.lineNameLb.text = [NSString stringWithFormat:@"打扫区域: %@", checkModel.line.cleaning_area_name];
    self.linePointHeight.constant = 0;
    self.startTimeLb.text = [NSString stringWithFormat:@"开始时间: %@", checkModel.task.cleaning_the_start_time];
    self.endTimeLb.text = [NSString stringWithFormat:@"结束时间: %@", checkModel.task.cleaning_the_end_time];
    self.reportLb.text = [NSString stringWithFormat:@"报告: %@", checkModel.task.report];
    self.startNumberHeight.constant = 0;
    self.endNumberHeight.constant = 0;
    [self imageViewWithImg:checkModel.task.pictures];
}

- (void)setFerrybusContentWithModel:(CheckModel *)checkModel {
    self.lineNameLb.text = [NSString stringWithFormat:@"摆渡车编号:: %@", checkModel.workTools.ferry_push];
    self.linePointLb.text = [NSString stringWithFormat:@"路线: %@", checkModel.line.ferry_push_line_name];
    self.startTimeLb.text = [NSString stringWithFormat:@"开始时间: %@", checkModel.task.start_time];
    self.endTimeLb.text = [NSString stringWithFormat:@"结束时间: %@", checkModel.task.receipt_time];
    self.startNumberHeight.constant = 0;
    self.endNumberHeight.constant = 0;
    
    [self imageViewWithImg:checkModel.task.pictures];
}

- (void)setBoatContentWithModel:(CheckModel *)checkModel {
    self.lineNameLb.text = [NSString stringWithFormat:@"游船编号: %@", checkModel.workTools.pleasure_boat];
    self.linePointLb.text = [NSString stringWithFormat:@"路线: %@", checkModel.line.cruise_line_name];
    self.startTimeLb.text = [NSString stringWithFormat:@"开船时间: %@", checkModel.task.departure_time];
    self.endTimeLb.text = [NSString stringWithFormat:@"停船时间: %@", checkModel.task.hitting_time];
    self.startNumberLb.text = [NSString stringWithFormat:@"上船人数: %ld", (long)checkModel.task.boarding_number];
    self.endNumberLb.text = [NSString stringWithFormat:@"下船人数: %ld", (long)checkModel.task.disembarkation_number];
    
    [self imageViewWithImg:checkModel.task.pictures];
}

//发表的图片
-(void)imageViewWithImg:(NSArray *)imgArr{
    if (imgArr.count > 0) {
        self.imageBg.hidden = NO;
        for (int i=0;i<imgArr.count;i++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(imgLeft + (imgWidth + 2*imgLeft)*i, 10, imgWidth, imgWidth)];
            [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.yituinfo.cn/Patrolling%@",imgArr[i]]] placeholder:[UIImage imageNamed:@"default"]];
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.userInteractionEnabled = YES;
            imageView.tag = i;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPic:)]];
                        
            [self.imageBg addSubview:imageView];
            self.imgViewHeight.constant = 100;
        }
    }else {
        self.imageBg.hidden = YES;
        self.imgViewHeight.constant = 0;
    }
}

- (void)showPic:(UITapGestureRecognizer *)tap{
    UIImageView *imageView = (UIImageView *)tap.view;
    [LookPhoto scanBigImageWithImageView:imageView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
