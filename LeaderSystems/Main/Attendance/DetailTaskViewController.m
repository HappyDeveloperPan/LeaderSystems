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
@property (nonatomic, strong) UIView *headView;
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
        self.tableView.tableHeaderView = self.headView;
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

- (UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 100)];
        _headView.backgroundColor = kColorMain;
        _headView.userInteractionEnabled = YES;
        
//        UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(25, (kMainScreenHeight * 0.2 - 100 ) / 2, 80, 80)];
//        headImage.backgroundColor = [UIColor clearColor];
//        headImage.layer.cornerRadius = 40;
//        headImage.clipsToBounds = YES;
//        if ([self.staffModel.staff_sex isEqualToString:@"男"]) {
//            [headImage setImage:[UIImage imageNamed:@"boy"]];
//        }else {
//            [headImage setImage:[UIImage imageNamed:@"girl"]];
//        }
//        [_headView addSubview:headImage];
        
        
        UILabel *lineLb = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kMainScreenWidth - 20, 20)];
        lineLb.text = [NSString stringWithFormat:@"路线: %@",self.taskModel.theSecurityLine.the_security_line_name];
        lineLb.font = [UIFont systemFontOfSize:16];
        lineLb.textColor = [UIColor whiteColor];
        [_headView addSubview:lineLb];
        
        UILabel *startTimeLb = [[UILabel alloc] initWithFrame:CGRectMake(10, lineLb.bottom + 10, kMainScreenWidth - 20, 20)];
        startTimeLb.text = [NSString stringWithFormat:@"开始时间: %@", self.taskModel.securityPatrolRecord.security_patrol_start_time];;
        startTimeLb.font = [UIFont systemFontOfSize:16];
        startTimeLb.textColor = [UIColor whiteColor];
        [_headView addSubview:startTimeLb];
        
        UILabel *endTimeLb = [[UILabel alloc] initWithFrame:CGRectMake(10, startTimeLb.bottom + 10, kMainScreenWidth - 20, 20)];
        if (self.taskModel.accomplishSecurityPatrolRecord.security_patrol_over_time) {
            endTimeLb.text = [NSString stringWithFormat:@"完成时间: %@", self.taskModel.accomplishSecurityPatrolRecord.security_patrol_over_time];
        }else {
            endTimeLb.text = @"完成时间: 无";
        }
        endTimeLb.font = [UIFont systemFontOfSize:16];
        endTimeLb.textColor = [UIColor whiteColor];
        [_headView addSubview:endTimeLb];
    }
    return _headView;
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
