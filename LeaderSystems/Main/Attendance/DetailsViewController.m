//
//  DetailsViewController.m
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/6/9.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "DetailsViewController.h"
#import "LZBCalendar.h"
#import "LZBCalendarAppearStyle.h"
#import "NSDate+Component.h"
#import "AttendanceDetailModel.h"
#import "PunchCardsModel.h"
#import "AddView.h"
#import "PunchCardView.h"
#import "RetroactiveView.h"
#import "DetailCheckViewController.h"

@interface DetailsViewController ()<LZBCalendarDataSource, LZBCalendarDataDelegate>
@property (nonatomic, strong) LZBCalendar *calendar;
@property (nonatomic, strong) LZBCalendarAppearStyle *calendarStyle;
@property (nonatomic, strong) NSMutableArray *attendanceArr;
@property (nonatomic, strong) NSMutableArray *punchCardArr;
@property (nonatomic, strong) AddView *addView;
@property (nonatomic, strong) PunchCardView *punchCardView;
@property (nonatomic, strong) RetroactiveView *retroactiveView;
//@property (nonatomic, strong) StaffModel *staffModel;
@end

typedef NS_ENUM(NSUInteger, retroactiveType) {
    leaveType = 2,
    evectionType = 1,
    fillCheckType = 3,
};

@implementation DetailsViewController
#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"考勤详情";
    self.view.backgroundColor = kColorWhite;
    
    [self calendar];
    NSDate *date = [NSDate date];
    [self getStaffAttendanceDetailWithDate:date];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Method
//获取当月考勤状态
- (void)getStaffAttendanceDetailWithDate:(NSDate *)date {
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"account_token"] = [UserManager sharedManager].user.account_token;
    NSDateFormatter *fomatter = [[NSDateFormatter alloc] init];
    [fomatter setDateFormat:@"yyyy-MM-dd"];
    parameters[@"time"] =[fomatter stringFromDate:date];
    parameters[@"staff_id"] = [NSString stringWithFormat:@"%ld", (long)self.staffId];
    
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:kUrl_AttendanceForMonth parameters:parameters completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                [self.attendanceArr removeAllObjects];
                for (id model in jsonData[@"result"][@"arrivedDay"]) {
                    DayModel *detailModel = [DayModel parse:model];
                    [self.attendanceArr addObject:detailModel];
                }
//                self.staffModel = [StaffModel parse:jsonData[@"result"][@"staff"]];
                [self.calendar.collectionView reloadData];
            }else {
                [self.view showWarning:jsonData[@"cause"]];
            }
        } else {
            [self.view showWarning:error.domain];
        }

    }];
}

//领导补签
- (void)leaderRetroactiveWithType: (retroactiveType)type  andDate:(NSDate *)date{
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"account_token"] = [UserManager sharedManager].user.account_token;
    params[@"staff_id"] = [NSString stringWithFormat:@"%ld", (long)self.staffId];
    params[@"clock_reason_type_id"] = [NSString stringWithFormat:@"%ld", (long)type];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    params[@"clock_time"] = [formatter stringFromDate:date];
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:kUrl_Retroactive parameters:params completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
//                NSDate *date = [NSDate date];
                [self getStaffAttendanceDetailWithDate:date];
                [self.addView close];
            }else {
                [self.view showWarning:jsonData[@"cause"]];
            }
        } else {
            [self.view showWarning:error.domain];
        }

    }];
}

//获取员工打卡信息
- (void)staffClockInfoWithDate: (NSDate *)date {
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"account_token"] = [UserManager sharedManager].user.account_token;
    params[@"staff_id"] = [NSString stringWithFormat:@"%ld", (long)self.staffId];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    params[@"clock_time"] = [formatter stringFromDate:date];
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:kUrl_ClockInfo parameters:params completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                NSMutableArray *punchCardArr = [NSMutableArray new];
                for (id model in jsonData[@"result"]) {
                    PunchCardsModel *punchCardModel = [PunchCardsModel parse:model];
                    [punchCardArr addObject:[NSString stringWithFormat:@"%@%@",punchCardModel.punchCardTypeString, punchCardModel.clock_time]];
                }
                if (punchCardArr.count > 0) {
                    PunchCardView *punchView = [[PunchCardView alloc] initWithFrame:CGRectMake(40, 40, kMainScreenWidth - 50, 320)];
                    [punchView setCloseBtnBlock:^{
                        [self.addView close];
                    }];
                    [punchView setDetailBtnBlock:^{
                        [self.addView close];
                        DetailCheckViewController *pushVc = [DetailCheckViewController new];
                        pushVc.date = date;
                        pushVc.staffModel = self.staffModel;
//                        pushVc.staffId = self.staffId;
//                        pushVc.type_of_work_id = self.type_of_work_id;
                        [self.navigationController pushViewController:pushVc animated:YES];
//                        [self staffDetailInfoWithDate:date];
                    }];
                    [punchView showPunchCardsWithArr:punchCardArr];
                    punchView.center = self.addView.center;
                    [self.addView addSubview:punchView];
                    [self.addView show];
                }
            }else {
                [self.view showWarning:jsonData[@"cause"]];
            }
        } else {
            [self.view showWarning:error.domain];
        }

    }];
}

//查看当天任务详情
- (void)staffDetailInfoWithDate: (NSDate *)date {
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"account_token"] = [UserManager sharedManager].user.account_token;
    params[@"staff_id"] = [NSString stringWithFormat:@"%ld", (long)self.staffId];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    params[@"clock_time"] = [formatter stringFromDate:date];
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:kUrl_DetailCheckInfo parameters:params completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
            }else {
                [self.view showWarning:jsonData[@"cause"]];
            }
        } else {
            [self.view showWarning:error.domain];
        }
        
    }];
}
#pragma mark - LZBCalendar Delegate
- (void)calendar:(LZBCalendar *)calendar didSelectDate:(NSDate *)date
{
//    NSLog(@"当前调用的方法:%s------行号:line-%d ",__func__, __LINE__);
    if (self.attendanceArr.count > 0 && (self.attendanceArr.count >= [date getDateWithDay])) {
        DayModel *detailModel = [self.attendanceArr objectAtIndex:[date getDateWithDay] - 1];
        //状态: 正常,缺勤半天,缺勤一天,迟到,早退,迟到&早退,迟到&漏签(可以补签),缺勤半天&早退(可以补签),缺勤半天&漏签(可以补签),请假,出差,漏签
        if ([detailModel.staffStateSM.msg isEqualToString:@"迟到"] || [detailModel.staffStateSM.msg isEqualToString:@"早退"] || [detailModel.staffStateSM.msg isEqualToString:@"迟到&早退"] || [detailModel.staffStateSM.msg isEqualToString:@"正常"] ||[detailModel.staffStateSM.msg isEqualToString:@"请假"] || [detailModel.staffStateSM.msg isEqualToString:@"出差"]) {
            [self staffClockInfoWithDate:date];
        }else {
            RetroactiveView *retroView = [[RetroactiveView alloc] initWithFrame:CGRectMake(40, 40, kMainScreenWidth - 50, 250)];
            retroView.titleLab.text = [NSString stringWithFormat:@"状态: %@", detailModel.staffStateSM.msg];
            [retroView setCloseBtnBlock:^{
                [self.addView close];
            }];
            [retroView setLeaveBtnBlock:^{
                [self leaderRetroactiveWithType:leaveType andDate:date];
            }];
            [retroView setEvectionBtnBlock:^{
                [self leaderRetroactiveWithType:evectionType andDate:date];
            }];
            retroView.center = self.addView.center;
            [self.addView addSubview:retroView];
            [self.addView show];
        }
    }
//    if ([detailModel.staffStateSM.msg isEqualToString:@"缺勤半天"] || [detailModel.staffStateSM.msg isEqualToString:@"缺勤一天"] || [detailModel.staffStateSM.msg isEqualToString:@"迟到&漏签"] || [detailModel.staffStateSM.msg isEqualToString:@"漏签"] || [detailModel.staffStateSM.msg isEqualToString:@"缺勤半天&早退"] || [detailModel.staffStateSM.msg isEqualToString:@",缺勤半天&漏签"]) {
//        RetroactiveView *retroView = [[RetroactiveView alloc] initWithFrame:CGRectMake(40, 40, kMainScreenWidth - 50, 250)];
//        retroView.titleLab.text = [NSString stringWithFormat:@"状态: %@", detailModel.staffStateSM.msg];
//        [retroView setCloseBtnBlock:^{
//            [self.addView close];
//        }];
//        [retroView setLeaveBtnBlock:^{
//            [self leaderRetroactiveWithType:leaveType andDate:date];
//        }];
//        [retroView setEvectionBtnBlock:^{
//            [self leaderRetroactiveWithType:evectionType andDate:date];
//        }];
//        retroView.center = self.addView.center;
//        [self.addView addSubview:retroView];
//        [self.addView show];
//    }
}

- (void)calendar:(LZBCalendar *)calendar didSelectHeaderView:(NSDate *)date {
//    NSLog(@"%ld, %ld",[[NSDate date] getDateWithMonth], [date getDateWithMonth] );
    [self.attendanceArr removeAllObjects];
    if ([[NSDate date] getDateWithMonth] >= [date getDateWithMonth]) {
        [self getStaffAttendanceDetailWithDate:date];
    }else {
        [self.calendar.collectionView reloadData];
    }
}

#pragma mark - dataSoure
- (NSString *)calendar:(LZBCalendar *)calendar titleForDate:(NSDate *)date
{
    if([[NSDate date] getDateWithMonth] == [date getDateWithMonth] && [[NSDate date] getDateWithDay] -[date getDateWithDay] == 0)
    {
        //返回今天是几号
//        NSLog(@"被减数: %ld",(long)[[NSDate date] getDateWithDay]);
//        NSLog(@"减数: %ld",(long)[date getDateWithDay]);
        return @"今天";
        
    }
        return nil;
}

- (NSString *)calendar:(LZBCalendar *)calendar subtitleForDate:(NSDate *)date
{
//    NSLog(@"%ld, 今天几号: %ld, %ld", self.attendanceArr.count, [[NSDate date] getDateWithDay], [date getDateWithDay]);
    
    if (self.attendanceArr.count > 0 && (self.attendanceArr.count >= [date getDateWithDay])) {
        DayModel *detailModel = [self.attendanceArr objectAtIndex:[date getDateWithDay] - 1];
        return detailModel.staffStateSM.msg;
    }
    return nil;
}

- (UIColor *)calendar:(LZBCalendar *)calendar subtitleColorForDate:(NSDate *)date {
    if (self.attendanceArr.count > 0 && (self.attendanceArr.count >= [date getDateWithDay])) {
        DayModel *detailModel = [self.attendanceArr objectAtIndex:[date getDateWithDay] - 1];
        if ([detailModel.staffStateSM.msg isEqualToString:@"正常"] || [detailModel.staffStateSM.msg isEqualToString:@"请假"] || [detailModel.staffStateSM.msg isEqualToString:@"出差"]) {
            return kColorGreen;
        }else if ([detailModel.staffStateSM.msg isEqualToString:@"缺勤一天"] || [detailModel.staffStateSM.msg isEqualToString:@"缺勤半天"] || [detailModel.staffStateSM.msg isEqualToString:@"缺勤半天&漏签"]) {
            return KcolorRed;
        }else {
            return RGBColor(128, 128, 0);
        }
    }
    return kColorMajor;
}

- (void)calendar:(LZBCalendar *)calendar layoutCallBackHeight:(CGFloat)height
{
    self.calendar.frame = CGRectMake(0, 15, [UIScreen mainScreen].bounds.size.width, height);
}

#pragma mark - Lazy Load
- (LZBCalendarAppearStyle *)calendarStyle {
    if (!_calendarStyle) {
        _calendarStyle = [[LZBCalendarAppearStyle alloc] init];
        _calendarStyle.isNeedCustomHeihgt = YES;
    }
    return _calendarStyle;
}

- (LZBCalendar *)calendar {
    if (!_calendar) {
        _calendar = [[LZBCalendar alloc] initWithStyle:self.calendarStyle];
        _calendar.frame = CGRectMake(0, 15, kMainScreenWidth, 300);
        _calendar.delegate = self;
        _calendar.dataSource = self;
        [self.view addSubview:_calendar];
    }
    return _calendar;
}

- (NSMutableArray *)attendanceArr {
    if (!_attendanceArr) {
        _attendanceArr = [NSMutableArray new];
    }
    return _attendanceArr;
}

- (NSMutableArray *)punchCardArr {
    if (!_punchCardArr) {
        _punchCardArr = [NSMutableArray new];
    }
    return _punchCardArr;
}

- (AddView *)addView {
    if (!_addView) {
        _addView = [[AddView alloc] initWithFrame:kMainWindow.frame];
    }
    return _addView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
