//
//  RetroactiveDetailViewController.m
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/7/7.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "RetroactiveDetailViewController.h"

@interface RetroactiveDetailViewController ()

@end

#define kLabWidth (kMainScreenWidth - 125)

@implementation RetroactiveDetailViewController
#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"处理申请";
    self.view.backgroundColor = kColorWhite;
    
    UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(25, 25, 80, 80)];
    headImage.backgroundColor = [UIColor clearColor];
    headImage.layer.cornerRadius = 40;
    headImage.clipsToBounds = YES;
    [headImage setImage:[UIImage imageNamed:@"boy"]];
    [self.view addSubview:headImage];
    //为图片添加手势控制
    //        [headImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(settingBackgroudImage)]];
    //        headImage.userInteractionEnabled = YES;
    
    
    UILabel *userNameLb = [[UILabel alloc] initWithFrame:CGRectMake(headImage.right + 10, 15, kLabWidth, 20)];
    userNameLb.text = [NSString stringWithFormat:@"申请人: %@", self.detailModel.examineApprove.staff_name];
    userNameLb.font = [UIFont systemFontOfSize:15];
    userNameLb.textColor = kColorMajor;
    [self.view addSubview:userNameLb];
    
    UILabel *phoneLb = [[UILabel alloc] initWithFrame:CGRectMake(headImage.right + 10, userNameLb.bottom + 5, kLabWidth, 20)];
    phoneLb.text = [NSString stringWithFormat:@"电话: %@", self.detailModel.examineApprove.staff_phone];;
    phoneLb.font = [UIFont systemFontOfSize:15];
    phoneLb.textColor = kColorMajor;
    [self.view addSubview:phoneLb];
    
    UILabel *stateLb = [[UILabel alloc] initWithFrame:CGRectMake(headImage.right + 10, phoneLb.bottom + 5, kLabWidth, 20)];
//    stateLb.text = [NSString stringWithFormat:@"考勤状态: %@", self.detailModel.examineApprove.staff_phone];
    stateLb.font = [UIFont systemFontOfSize:15];
    stateLb.textColor = kColorMajor;
    [self.view addSubview:stateLb];
    
    UILabel *typeLb = [[UILabel alloc] initWithFrame:CGRectMake(headImage.right + 10, stateLb.bottom + 5, kLabWidth, 20)];
    typeLb.text = [NSString stringWithFormat:@"申请类型: %@", self.detailModel.examineApprove.clock_reason_type_name];;
    typeLb.font = [UIFont systemFontOfSize:15];
    typeLb.textColor = kColorMajor;
    [self.view addSubview:typeLb];
    
    UILabel *reasonLb = [[UILabel alloc] init];
    reasonLb.text = [NSString stringWithFormat:@"申请原因: %@", self.detailModel.examineApprove.examine_approve_sign_cause];;
    reasonLb.font = [UIFont systemFontOfSize:15];
    reasonLb.textColor = kColorMajor;
    reasonLb.numberOfLines = 0;
    [self.view addSubview:reasonLb];
    [reasonLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headImage.mas_right).mas_equalTo(10);
        make.top.mas_equalTo(typeLb.mas_bottom).mas_equalTo(5);
        make.width.mas_equalTo(kLabWidth);
    }];
    
    UILabel *timeLb = [[UILabel alloc] init];
//    timeLb.text = [NSString stringWithFormat:@"申请时间: %@", self.detailModel.examineApprove.clock_reason_type_name];;
    timeLb.font = [UIFont systemFontOfSize:15];
    timeLb.textColor = kColorMajor;
    [self.view addSubview:timeLb];
    [timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headImage.mas_right).mas_equalTo(10);
        make.top.mas_equalTo(reasonLb.mas_bottom).mas_equalTo(5);
        make.size.mas_equalTo(CGSizeMake(kLabWidth, 20));
    }];
    
    
    for (int i = 0; i < self.detailModel.examineApproveFillTimes.count; i ++) {
        ExamineApproveFillTimesModel *timeModel = self.detailModel.examineApproveFillTimes[i];
        if (i == 0) {
            stateLb.text = [NSString stringWithFormat:@"考勤状态: %@",timeModel.examine_approve_sign_state];
            timeLb.text = [NSString stringWithFormat:@"申请时间: %@",timeModel.examine_approve_fill_time];
        }else {
            stateLb.text = [NSString stringWithFormat:@"%@,%@",stateLb.text,timeModel.examine_approve_sign_state];
            timeLb.text = [NSString stringWithFormat:@"%@,%@",timeLb.text,timeModel.examine_approve_fill_time];
        }
    }
    
    if ([self.detailModel.examineApprove.examine_approve_type_name isEqualToString:@"待审批"]) {
        UIButton *disagreeBtn = [[UIButton alloc] init];
        [self.view addSubview:disagreeBtn];
        [disagreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(timeLb.mas_bottom).mas_equalTo(10);
            make.size.mas_equalTo(CGSizeMake(100, 35));
            make.centerX.mas_equalTo(-80);
        }];
        disagreeBtn.tag = 10;
        disagreeBtn.layer.cornerRadius = 5;
        disagreeBtn.backgroundColor = KcolorRed;
        [disagreeBtn setTitle:@"不同意" forState:UIControlStateNormal];
        [disagreeBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
        [disagreeBtn addTarget:self action:@selector(handleRetroactive:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *agreeBtn = [[UIButton alloc] init];
        [self.view addSubview:agreeBtn];
        [agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(timeLb.mas_bottom).mas_equalTo(10);
            make.size.mas_equalTo(CGSizeMake(100, 35));
            make.centerX.mas_equalTo(80);
        }];
        agreeBtn.tag = 20;
        agreeBtn.layer.cornerRadius = 5;
        agreeBtn.backgroundColor = kColorMain;
        [agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
        [agreeBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
        [agreeBtn addTarget:self action:@selector(handleRetroactive:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Method
- (void)handleRetroactive:(UIButton *)sender {
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"account_token"] = [UserManager sharedManager].user.account_token;
    params[@"examine_approve_sign_id"] = [NSString stringWithFormat:@"%ld", (long)self.detailModel.examineApprove.examine_approve_sign_id];
    if (sender.tag == 20) {
        params[@"criticize_type_id"] = @1;
    }else {
        params[@"criticize_type_id"] = @2;
    }
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:kUrl_HandleRetroactive parameters:params completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                [kMainWindow showWarning:@"处理完成"];
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                [self.view showWarning:jsonData[@"cause"]];
            }
        } else {
            [self.view showWarning:error.domain];
        }

    }];
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
