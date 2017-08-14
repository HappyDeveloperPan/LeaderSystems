//
//  InspectWorkingViewController.m
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/6/14.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "InspectWorkingViewController.h"
#import "InspectModel.h"
#import "InspectTableViewCell.h"
#import "WorkingDetailViewController.h"

typedef NS_ENUM(NSUInteger, RefreshMode) {
    RefreshModeFirst,
    RefreshModeMore,
};

@interface InspectWorkingViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *inspectArr;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger page;
@end

@implementation InspectWorkingViewController
#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"视察任务";
    self.view.backgroundColor = kColorBg;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"InspectTableViewCell" bundle:nil] forCellReuseIdentifier:@"InspectTableViewCell"];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getWorkingStaffWithRefreshModel:RefreshModeFirst];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getWorkingStaffWithRefreshModel:RefreshModeMore];
    }];
    
    
    
    
//    [self getWorkingStaff];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Method
- (void)getWorkingStaffWithRefreshModel:(RefreshMode)refreshMode {
    if (refreshMode == RefreshModeFirst) {
        [self.inspectArr removeAllObjects];
        self.page = 1;
    }else {
        self.page += 1;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"account_token"] = [UserManager sharedManager].user.account_token;
    parameters[@"pageCount"] = @10;
    parameters[@"page"] = [NSString stringWithFormat:@"%ld", (long)self.page];
    parameters[@"dataType"] = @"allData";
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:kUrl_GetWorkingStaff parameters:parameters completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                for (id model in jsonData[@"result"][@"onLineStaff"]) {
                    StaffWorkingModel *staffModel = [StaffWorkingModel parse:model];
                    [self.inspectArr addObject:staffModel];
                }
                for (id model in jsonData[@"result"][@"notOnlineStaff"]) {
                    StaffWorkingModel *staffModel = [StaffWorkingModel parse:model];
                    [self.inspectArr addObject:staffModel];
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
    if (self.inspectArr != nil) {
        return self.inspectArr.count;
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"InspectTableViewCell";
    InspectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    StaffWorkingModel *model = self.inspectArr[indexPath.row];
    cell.nameLb.text = [NSString stringWithFormat:@"姓名: %@", model.staff.staff_name];
    cell.phoneLb.text = [NSString stringWithFormat:@"电话: %@", model.staff.staff_phone];
    cell.workTypeLb.text = [NSString stringWithFormat:@"工种: %@", model.staff.type_of_work_name];
    if (model.onLine) {
        NSString *str = @"是否在线: 在线";
        NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attriStr addAttributes:@{NSForegroundColorAttributeName:[UIColor greenColor]} range:[str rangeOfString:@" 在线"]];
        cell.isOnlineLb.attributedText = attriStr;
    }else {
        NSString *str = @"是否在线: 不在线";
        NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attriStr addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:[str rangeOfString:@"不在线"]];
        cell.isOnlineLb.attributedText = attriStr;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    StaffWorkingModel *staffModel = self.inspectArr[indexPath.row];
//    if (model.onLine) {
//        WorkingDetailViewController *pushVc = [WorkingDetailViewController new];
//        pushVc.ioSessionId = model.ioSessionId;
//        pushVc.workType = model.staff.type_of_work_id;
//        [self.navigationController pushViewController:pushVc animated:YES];
//    }else {
//        [kMainWindow showWarning:@"用户不在线"];
//    }
    WorkingDetailViewController *pushVc = [WorkingDetailViewController new];
    pushVc.staffModel = staffModel;
    [self.navigationController pushViewController:pushVc animated:YES];
}
#pragma mark - Lazy Load
- (NSMutableArray *)inspectArr {
    if (!_inspectArr) {
        _inspectArr = [NSMutableArray new];
    }
    return _inspectArr;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
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
