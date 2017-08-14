//
//  HeadDateView.m
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/7/11.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "HeadDateView.h"

@interface HeadDateView ()
//topView控件
@property (nonatomic, strong)  UIButton *lastButton;
@property (nonatomic, strong)  UIButton *nextButton;
@property (nonatomic, strong)  UILabel *dateLable;
@end

@implementation HeadDateView



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark - Life Circle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kColorMain;
        
        [self dateLable];
        [self lastButton];
        [self nextButton];
        
        [self.dateLable setText:[NSString stringWithFormat:@"%ld-%.2ld-%.2ld",(long)[self year:self.centerDate],(long)[self month:self.centerDate],(long)[self day:self.centerDate]]];
        
    }
    return self;
}

#pragma mark - Method
- (void)lastButtonClick {
    self.centerDate = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:self.centerDate];//前一天
    [self.dateLable setText:[NSString stringWithFormat:@"%ld-%.2ld-%.2ld",(long)[self year:self.centerDate],(long)[self month:self.centerDate],(long)[self day:self.centerDate]]];
    if (self.lastClick) {
        self.lastClick(self.centerDate);
    }
}

- (void)nextButtonClick {
    self.centerDate = [NSDate dateWithTimeInterval:24*60*60 sinceDate:self.centerDate];//后一天
    [self.dateLable setText:[NSString stringWithFormat:@"%ld-%.2ld-%.2ld",(long)[self year:self.centerDate],(long)[self month:self.centerDate],(long)[self day:self.centerDate]]];
    if (self.nextClick) {
        self.nextClick(self.centerDate);
    }
}

- (NSInteger)month:(NSDate *)date
{
    return [self getDateComponentsFromDate:date].month;
}

- (NSInteger)year:(NSDate *)date
{
    return [self getDateComponentsFromDate:date].year;
}

- (NSInteger)day:(NSDate *)date {
    return [self getDateComponentsFromDate:date].day;
}

//- (NSDate *)lastMonthDate:(NSDate *)date
//{
//    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
//    NSInteger currentMonth = [self month:date];
//    if(currentMonth == 1)
//    {
//        dateComponents.year = -1;
//        dateComponents.month = +11;
//    }
//    else
//        dateComponents.month = -1;
//    
//    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:NSCalendarWrapComponents];
//    return newDate;
//}
//- (NSDate*)nextMonth:(NSDate *)date
//{
//    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
//    NSInteger currentMonth = [self month:date];
//    if(currentMonth == 12)
//    {
//        dateComponents.year = +1;
//        dateComponents.month = -11;
//    }
//    else
//        dateComponents.month = +1;
//    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:NSCalendarWrapComponents];
//    return newDate;
//}

- (NSDateComponents *)getDateComponentsFromDate:(NSDate *)date
{
    NSDateComponents *component = [[NSCalendar currentCalendar] components:
                                   (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return component;
}
#pragma mark - Lazy Load
- (NSDate *)centerDate {
    if (!_centerDate) {
        _centerDate = [NSDate date];
    }
    return _centerDate;
}

- (UILabel *)dateLable {
    if (!_dateLable) {
        _dateLable = [UILabel new];
        [self addSubview:_dateLable];
        [_dateLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(160, self.height));
        }];
        _dateLable.textColor = kColorWhite;
        _dateLable.textAlignment = NSTextAlignmentCenter;
    }
    return _dateLable;
}

- (UIButton *)lastButton {
    if (!_lastButton) {
        _lastButton = [UIButton new];
        [self addSubview:self.lastButton];
        [_lastButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.size.mas_equalTo(CGSizeMake(100, self.height));
            make.centerY.mas_equalTo(0);
        }];
        _lastButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_lastButton setTitle:@"上一天" forState:UIControlStateNormal];
        [_lastButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_lastButton addTarget:self action:@selector(lastButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _lastButton;
}

- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [UIButton new];
        [self addSubview:self.nextButton];
        [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.size.mas_equalTo(CGSizeMake(100, self.height));
            make.centerY.mas_equalTo(0);
        }];
        _nextButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_nextButton setTitle:@"下一天" forState:UIControlStateNormal];
        [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _nextButton;
}

@end
