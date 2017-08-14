//
//  SettingViewController.m
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/6/5.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "SettingViewController.h"
#import "LoginViewController.h"
#import "MineTableViewCell.h"
#import "AboutViewController.h"
#import "RetrieveViewController.h"
//#import "RetroactiveListViewController.h"

@interface SettingViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIButton *logoutBtn;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headView;
@end

#define kMenuArr @[@"修改密码",@"关于逸途"]
#define kImageArr @[@"icon_set",@"icon_Collection"]

@implementation SettingViewController
#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.view.backgroundColor = kColorBg;
    [Common setUpNavBar:self.navigationController.navigationBar];
    
//    [kNotificationCenter addObserver:self selector:@selector(showRedPoint:) name:kReloadUser object:nil];
    
    [self.tableView registerClass:[MineTableViewCell class] forCellReuseIdentifier:@"MineTableViewCell"];
    
    [self headView];
    [self tableView];
    
    [self logoutBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - Method
- (void)logoutBtnClick {
    [[UserManager sharedManager] logout];
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self.navigationController presentViewController:navVC animated:YES completion:nil];
}

- (void)showRedPoint: (NSNotification *)notif{
    [self.tableView reloadData];
}

#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kMenuArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"MineTableViewCell";
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = [[MineTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    [cell setImageView:kImageArr[indexPath.row] andText:kMenuArr[indexPath.row]];
//    if (indexPath.section == 0 && indexPath.row == 0 && [UserManager sharedManager].showRedPoint) {
//        cell.redPoint.hidden = NO;
//    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0 && indexPath.row == 0 ) {
//        RetroactiveListViewController *pushVc = [RetroactiveListViewController new];
//        pushVc.hidesBottomBarWhenPushed = YES;
////        MineTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
////        cell.redPoint.hidden = YES;
//        [UserManager sharedManager].showRedPoint = NO;
//        [Common clearAsynchronousWithKey:kRedPoint];
//        [self.navigationController pushViewController:pushVc animated:YES];
//    }
    if (indexPath.row == 0 ) {
        RetrieveViewController *retrieveVc = [RetrieveViewController new];
        retrieveVc.headTitle = @"修改密码";
        retrieveVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:retrieveVc animated:YES];
    }
    if (indexPath.row ==1) {
        AboutViewController *jumpVc = [[AboutViewController alloc] init];
        jumpVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:jumpVc animated:YES];
    }
}
#pragma mark - Lazy Load
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 112 - 100) style:UITableViewStyleGrouped];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        //不显示系统自带分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight * 0.2)];
        _headView.backgroundColor = kColorMain;
        _headView.userInteractionEnabled = YES;
        
        UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(25, (kMainScreenHeight * 0.2 - 100 ) / 2, 80, 80)];
        headImage.backgroundColor = [UIColor clearColor];
        headImage.layer.cornerRadius = 40;
        headImage.clipsToBounds = YES;
        if ([[UserManager sharedManager].user.leaderAccount.leader_account_sex isEqualToString:@"男"]) {
            [headImage setImage:[UIImage imageNamed:@"boy"]];
        }else {
            [headImage setImage:[UIImage imageNamed:@"girl"]];
        }
        [_headView addSubview:headImage];
        //为图片添加手势控制
        //        [headImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(settingBackgroudImage)]];
//        headImage.userInteractionEnabled = YES;
        
        
        UILabel *userNameLb = [[UILabel alloc] initWithFrame:CGRectMake(headImage.right + 10, 12, kMainScreenWidth * 0.5, 40)];
        userNameLb.text = [NSString stringWithFormat:@"姓名: %@",[UserManager sharedManager].user.leaderAccount.leader_account_name];
        userNameLb.font = [UIFont systemFontOfSize:18];
        userNameLb.textColor = [UIColor whiteColor];
        [_headView addSubview:userNameLb];
        
        UILabel *phoneLb = [[UILabel alloc] initWithFrame:CGRectMake(headImage.right + 10, userNameLb.bottom, kMainScreenWidth * 0.75, 40)];
        phoneLb.text = [NSString stringWithFormat:@"电话: %@", [UserManager sharedManager].user.leaderAccount.leader_account_phone];;
        phoneLb.font = [UIFont systemFontOfSize:15];
        phoneLb.textColor = [UIColor whiteColor];
        [_headView addSubview:phoneLb];
        
//        _workTypeLb = [[UILabel alloc] initWithFrame:CGRectMake(headImage.right + 10, _phoneLb.bottom, 180, 40)];
//        _workTypeLb.text = [NSString stringWithFormat:@"工种: %@", [UserManager sharedManager].user.staff.workType];
//        _workTypeLb.font = [UIFont systemFontOfSize:15];
//        _workTypeLb.textColor = [UIColor whiteColor];
//        [_headView addSubview:_workTypeLb];
        
        _tableView.tableHeaderView = _headView;
    }
    return _headView;
}

- (UIButton *)logoutBtn {
    if (!_logoutBtn) {
        _logoutBtn = [[UIButton alloc] init];
        [self.view addSubview:_logoutBtn];
        [_logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(25);
            make.bottom.mas_equalTo(-25);
            make.width.mas_equalTo(kMainScreenWidth - 50);
            make.height.mas_equalTo(50);
        }];
        _logoutBtn.backgroundColor = RGBColor(25, 182, 158);
        [_logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        _logoutBtn.layer.cornerRadius = 6;
        [_logoutBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
        _logoutBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_logoutBtn addTarget:self action:@selector(logoutBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _logoutBtn;
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
