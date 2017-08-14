//
//  DetailTaskViewController.m
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/8/11.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "DetailTaskViewController.h"
#import "DetailTaskTableViewCell.h"

@interface DetailTaskViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *taskArr;
@property (nonatomic, strong) NSArray *lineArr;
@end

@implementation DetailTaskViewController
#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"任务详情";
    self.view.backgroundColor = kColorMajor;
    
    [self.tableView registerClass:[DetailTaskTableViewCell class] forCellReuseIdentifier:@"DetailTaskTableViewCell"];
    
    if (self.staffModel.type_of_work_id == 1) {
        self.taskArr = self.taskModel.nowLocationdsInfos;
        self.lineArr = self.taskModel.theSecurityLineLatlngs;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Method

#pragma mark - UITableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.staffModel.type_of_work_id == 1) {
        return self.lineArr.count;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 15;
//}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"DetailTaskTableViewCell";
    DetailTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[DetailTaskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    //安保
    if (self.staffModel.type_of_work_id == 1) {
        CoordinateModel *lineModel = self.lineArr[indexPath.row];
        PatrolInfoModel *patroModel = nil;
        for (PatrolInfoModel *model in self.taskArr) {
            if (lineModel.the_security_line_latlng_id == model.nowLocationds.the_security_line_latlng_id) {
                patroModel = model;
            }
        }
        [cell settingSecurityData:lineModel.order taskModel:patroModel];
    }
    //保洁
    if (self.staffModel.type_of_work_id == 2) {
        [cell settingCleanData:self.taskModel];
    }
    //摆渡车
    if (self.staffModel.type_of_work_id == 3) {
        [cell settingFerryBusData:self.taskModel];
    }
    //游船
    if (self.staffModel.type_of_work_id == 4) {
        [cell settingBoatData:self.taskModel];
    }
    return cell;
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

- (NSArray *)taskArr {
    if (!_taskArr) {
        _taskArr = [NSArray new];
    }
    return _taskArr;
}

- (NSArray *)lineArr {
    if (!_lineArr) {
        _lineArr = [NSArray new];
    }
    return _lineArr;
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
