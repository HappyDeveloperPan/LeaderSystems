//
//  HelpHandleViewController.m
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/7/13.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "HelpHandleViewController.h"
#import "OnlineStaffViewController.h"
#import "MyTextView.h"

@interface HelpHandleViewController ()<OnlineStaffDelegate>
@property (nonatomic, strong) MyTextView *textView;
@property (nonatomic, strong) UILabel *staffLb;
@property (nonatomic, copy) NSString *staffsId;
@end

@implementation HelpHandleViewController
#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"处理求助";
    self.view.backgroundColor = kColorWhite;
    // Do any additional setup after loading the view.
    
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, kMainScreenWidth - 40, 30)];
    titleLb.text = @"请填写处理报告*";
    titleLb.textColor = kColorMajor;
    [self.view addSubview:titleLb];
    
    //处理报告
    self.textView = [[MyTextView alloc] initWithFrame:CGRectMake(20, titleLb.bottom + 10, kMainScreenWidth - 40, kMainScreenHeight * 0.33)];
    self.textView.placeholder = @"处理报告....";
    self.textView.font = [UIFont systemFontOfSize:15];
    self.textView.backgroundColor = kColorBg;
    [self.view addSubview:self.textView];
    
    //派遣人员
    UIButton *onlineStaffBtn = [[UIButton alloc] init];
    [self.view addSubview:onlineStaffBtn];
    [onlineStaffBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textView.mas_bottom).mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    [onlineStaffBtn setTitle:@"派遣人员" forState:UIControlStateNormal];
    [onlineStaffBtn setTitleColor:kColorMain forState:UIControlStateNormal];
    UIView *lineView = [[UIView alloc] init];
    [onlineStaffBtn addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-1);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(80, 1));
    }];
    lineView.backgroundColor = kColorMain;
    [onlineStaffBtn addTarget:self action:@selector(getOnlineStaff) forControlEvents:UIControlEventTouchUpInside];
    
    self.staffLb = [[UILabel alloc] init];
    [self.view addSubview:self.staffLb];
    [self.staffLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(onlineStaffBtn.mas_bottom).mas_equalTo(10);
        make.right.mas_equalTo(-20);
        make.width.mas_equalTo(kMainScreenWidth - 40);
    }];
    self.staffLb.numberOfLines = 0;
    self.staffLb.textColor = kColorMajor;
//    self.staffLb.text = @"撒地方临渴掘井克里斯积分撒酒疯离开家就是讲放辣椒了时间发电量睡懒觉了就是垃圾就是垃圾就事论事解放军老师福建省地方是打飞机";
    
    
    //处理求助
    UIButton *handleBtn = [[UIButton alloc] init];
    [self.view addSubview:handleBtn];
    [handleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-25);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kMainScreenWidth - 100, 40));
    }];
    [handleBtn setTitle:@"处理求助" forState:UIControlStateNormal];
    [handleBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
    [handleBtn setBackgroundColor:kColorMain];
    [handleBtn.layer setCornerRadius:5];
    [handleBtn addTarget:self action:@selector(helpHandle) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Method
//处理求助
- (void)helpHandle {
    NSMutableDictionary *params = [NSMutableDictionary new];
    NSString *url;
    params[@"account_token"] = [UserManager sharedManager].user.account_token;
    if (self.emergency_calling_id) {
        params[@"emergency_calling_id"] = [NSString stringWithFormat:@"%ld", (long)self.emergency_calling_id];
        params[@"result"] = self.textView.text;
        params[@"emergency_calling_dispose_staff"] = self.staffsId;// 求助人员工种id
        url = kUrl_AcceptHelp;
    }
    if (self.nowLocationdId) {
        params[@"nowLocationdId"] =  [NSString stringWithFormat:@"%d", self.nowLocationdId];
        params[@"disposeResult"] = self.textView.text;
        params[@"auxiliary_staffs"] = self.staffsId;
        url = kUrl_AcceptUnusual;
    }
    
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:url parameters:params completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                [kMainWindow showWarning:@"提交处理成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                [self.view showWarning:jsonData[@"cause"]];
            }
        } else {
            [self.view showWarning:error.domain];
        }

    }];
}

//获取在线用户
- (void)getOnlineStaff {
    OnlineStaffViewController *pushVc = [OnlineStaffViewController new];
    if (self.emergency_calling_id) {
        pushVc.emergency_calling_id = self.emergency_calling_id;
    }
    if (self.nowLocationdId) {
        pushVc.nowLocationdId = self.nowLocationdId;
    }
    pushVc.delegate = self;
    [self.navigationController pushViewController:pushVc animated:YES];
}

#pragma mark - OnlineStaff Delegate
- (void)showSelectStaff:(NSArray *)staffs {
    NSMutableArray *staffNameArr = [NSMutableArray new];
    NSMutableArray *staffIdArr = [NSMutableArray new];
    for (id model in staffs) {
        StaffModel *staffModel = model;
        [staffNameArr addObject:staffModel.staff_name];
        [staffIdArr addObject:[NSString stringWithFormat:@"%ld",(long)staffModel.staff_id]];
    }
    NSString *nameStr = [staffNameArr componentsJoinedByString:@","];
    self.staffLb.text = nameStr;
    NSString *staffIdStr = [staffIdArr componentsJoinedByString:@","];
    self.staffsId = staffIdStr;
}
#pragma mark - Lazy Load

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
