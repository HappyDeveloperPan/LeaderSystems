//
//  AttendanceViewController.m
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/6/8.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "AttendanceViewController.h"
#import "StaffModel.h"
#import "AttendanceTableViewCell.h"
#import "DetailsViewController.h"

typedef NS_ENUM(NSUInteger, RefreshMode) {
    RefreshModeFirst,
    RefreshModeMore,
};

@interface AttendanceViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) StaffModel *staffModel;
@property (nonatomic, strong) NSMutableArray *attendanceArr;
@property (nonatomic, assign) NSInteger page;
@end

@implementation AttendanceViewController
#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"员工考勤";
    self.view.backgroundColor = kColorBg;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"AttendanceTableViewCell" bundle:nil] forCellReuseIdentifier:@"AttendanceTableViewCell"];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getStaffAttendanceWithRefreshMode:RefreshModeFirst];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getStaffAttendanceWithRefreshMode:RefreshModeMore];
    }];
    
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Method
- (void)getStaffAttendanceWithRefreshMode:(RefreshMode)refreshMode {
    
    if (refreshMode == RefreshModeFirst) {
        [self.attendanceArr removeAllObjects];
        self.page = 1;
    }else {
        self.page += 1;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"account_token"] = [UserManager sharedManager].user.account_token;
    parameters[@"pageCount"] = @15;
    parameters[@"page"] = [NSString stringWithFormat:@"%ld", (long)self.page];
    
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:kUrl_GetAllStaffTask parameters:parameters completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                for (id model in jsonData[@"result"][@"staffs"]) {
                    StaffModel *staffModel = [StaffModel parse:model];
                    [self.attendanceArr addObject:staffModel];
                }
                [self.tableView reloadData];
            }else {
                [self.view showWarning:jsonData[@"cause"]];
            }
        } else {
            [self.view showWarning:error.domain];
        }
        if (refreshMode == RefreshModeFirst) {
            [self.tableView.mj_header endRefreshing];
        }else {
            [self.tableView.mj_footer endRefreshing];
        }
        
    }];
}
#pragma mark - UITableView Delegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.attendanceArr != nil) {
        return self.attendanceArr.count;
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return UITableViewAutomaticDimension;
    return 80;
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 120;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"AttendanceTableViewCell";
    AttendanceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    StaffModel *model = self.attendanceArr[indexPath.row];
    cell.nameLb.text = [NSString stringWithFormat:@"姓名: %@", model.staff_name];
    cell.phoneLb.text = [NSString stringWithFormat:@"电话: %@", model.staff_phone];
    cell.workTypeLb.text = [NSString stringWithFormat:@"工种: %@", model.type_of_work_name];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    StaffModel *model = self.attendanceArr[indexPath.row];
    DetailsViewController *detailsVC = [DetailsViewController new];
    detailsVC.staffId = model.staff_id;
    detailsVC.type_of_work_id = model.type_of_work_id;
    detailsVC.staffModel = model;
    [self.navigationController pushViewController:detailsVC animated:YES];
}

#pragma mark - Lazy Load
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 64) style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        //不显示系统自带分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

//- (AttendanceModel *)attendanceModel {
//    if (!_attendanceModel) {
//        _attendanceModel = [AttendanceModel new];
//    }
//    return _attendanceModel;
//}

- (NSMutableArray *)attendanceArr {
    if (!_attendanceArr) {
        _attendanceArr = [NSMutableArray new];
    }
    return _attendanceArr;
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
