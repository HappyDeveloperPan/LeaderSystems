//
//  DetailCheckViewController.m
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/6/29.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "DetailCheckViewController.h"
#import "CheckModel.h"
#import "DetailCheckTableViewCell.h"
#import "HeadDateView.h"
#import "DetailTaskModel.h"
#import "TaskTableViewCell.h"
#import "DetailTaskViewController.h"

@interface DetailCheckViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CheckModel *checkModel;
@property (nonatomic, strong) NSMutableArray *checkArr;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) HeadDateView *headDateView;
@property (nonatomic, assign) CGFloat top;
@end



@implementation DetailCheckViewController
#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"当天任务";
    self.view.backgroundColor = kColorWhite;
    [Common setUpNavBar:self.navigationController.navigationBar];
    
    if (self.isShowDate) {
        [self.view addSubview:self.headDateView];
        self.top = self.headDateView.height + 20;
    }else {
        self.top = 0;
    }
    
    
//    [self.tableView registerNib:[UINib nibWithNibName:@"DetailCheckTableViewCell" bundle:nil] forCellReuseIdentifier:@"DetailCheckTableViewCell"];
    
    [self.tableView registerClass:[TaskTableViewCell class] forCellReuseIdentifier:@"TaskTableViewCell"];
    
    [self headView];
    [self tableView];
    
    [self staffDetailInfoWithDate:self.date];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Method
//查看当天任务详情
- (void)staffDetailInfoWithDate: (NSDate *)date {
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"account_token"] = [UserManager sharedManager].user.account_token;
    params[@"staff_id"] = [NSString stringWithFormat:@"%ld", (long)self.staffModel.staff_id];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    params[@"clock_time"] = [formatter stringFromDate:date];
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:kUrl_DetailCheckInfo parameters:params completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                [self.checkArr removeAllObjects];
                for (id model in jsonData[@"result"]) {
//                    CheckModel *checkModel = [CheckModel parse:model];
                    DetailTaskModel *checkModel = [DetailTaskModel parse:model];
                    [self.checkArr addObject:checkModel];
                }
                [self.tableView reloadData];
            }else {
                [self.view showWarning:jsonData[@"cause"]];
            }
        } else {
            [self.view showWarning:error.domain];
        }
        
    }];
}
#pragma mark - UItableView Delegate
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    if (self.staffModel.type_of_work_id == 1) {
//        return self.checkArr.count;
//    }
//    return 1;
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (self.staffModel.type_of_work_id == 1) {
//        CheckModel *checkModel = self.checkArr[section];
//        return checkModel.nowLocationdss.count;
//    }
    return self.checkArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    NSInteger width = kWidth - 75;
//    MyModel *model = self.dataArray[indexPath.row];
//    NSString *contentText = model.trends;
//    NSInteger H = 55;
//    //    计算文字高度
//    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
//    CGSize size = [contentText boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
//    //    计算图片高度
//    NSInteger imgH;
//    if (model.contentImgs.length == 0) {
//        imgH = 15;
//    }else{
//        NSInteger imgcount = [model.contentImgs componentsSeparatedByString:@","].count;
//        imgH = (kSpace+imgWidth)*(imgcount/4+1);
//    }
//    //    计算评论高度
//    NSDictionary *sttribute = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
//    CGSize reviewSize = [model.reviewStr boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:sttribute context:nil].size;
//    return H + size.height + imgH + reviewSize.height;
    return UITableViewAutomaticDimension;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return UITableViewAutomaticDimension;
//}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"TaskTableViewCell";
    TaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[TaskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    DetailTaskModel *taskModel = self.checkArr[indexPath.row];
    //安保
    if (self.staffModel.type_of_work_id == 1) {
        [cell settingSecurityData:taskModel];
        [cell settingSecurityFrame:taskModel];
    }
    //保洁
    if (self.staffModel.type_of_work_id == 2) {
        [cell settingCleanData:taskModel];
        [cell settingCleanFrame:taskModel];
    }
    //摆渡车
    if (self.staffModel.type_of_work_id == 3) {
        [cell settingFerrybusData:taskModel];
        [cell settingFerrybusFrame:taskModel];
    }
    //游船
    if (self.staffModel.type_of_work_id == 4) {
        [cell settingBoatData:taskModel];
        [cell settingBoatFrame:taskModel];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailTaskModel *taskModel = self.checkArr[indexPath.row];
//    if (self.staffModel.type_of_work_id == 1) {
//        DetailTaskViewController *pushVc = [DetailTaskViewController new];
//        pushVc.staffModel = self.staffModel;
//        pushVc.taskModel = taskModel;
//        [self.navigationController pushViewController:pushVc animated:YES];
//    }
    DetailTaskViewController *pushVc = [DetailTaskViewController new];
    pushVc.staffModel = self.staffModel;
    pushVc.taskModel = taskModel;
    [self.navigationController pushViewController:pushVc animated:YES];
}
#pragma mark - Lazy Load
- (HeadDateView *)headDateView {
    if (!_headDateView) {
        _headDateView = [[HeadDateView alloc] initWithFrame:CGRectMake(0, 10, kMainScreenWidth, 40)];
        __weak typeof(self) weakSelf = self;
        [_headDateView setLastClick:^(NSDate *date){
            [weakSelf staffDetailInfoWithDate:date];
        }];
        [_headDateView setNextClick:^(NSDate *date){
            [weakSelf staffDetailInfoWithDate:date];
        }];
    }
    return _headDateView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        if (self.isShowDate) {
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.top, kMainScreenWidth, kMainScreenHeight - 64 - self.top) style:UITableViewStyleGrouped];
        }else{
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 64) style:UITableViewStyleGrouped];
        }
        
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
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight * 0.2)];
        _headView.backgroundColor = kColorMain;
        _headView.userInteractionEnabled = YES;
        
        UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(25, (kMainScreenHeight * 0.2 - 100 ) / 2, 80, 80)];
        headImage.backgroundColor = [UIColor clearColor];
        headImage.layer.cornerRadius = 40;
        headImage.clipsToBounds = YES;
        if ([self.staffModel.staff_sex isEqualToString:@"男"]) {
            [headImage setImage:[UIImage imageNamed:@"boy"]];
        }else {
            [headImage setImage:[UIImage imageNamed:@"girl"]];
        }
        [_headView addSubview:headImage];
        //为图片添加手势控制
        //        [headImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(settingBackgroudImage)]];
        //        headImage.userInteractionEnabled = YES;
        
        
        UILabel *userNameLb = [[UILabel alloc] initWithFrame:CGRectMake(headImage.right + 10, 5, kMainScreenWidth * 0.5, 40)];
        userNameLb.text = [NSString stringWithFormat:@"姓名: %@",self.staffModel.staff_name];
        userNameLb.font = [UIFont systemFontOfSize:18];
        userNameLb.textColor = [UIColor whiteColor];
        [_headView addSubview:userNameLb];
        
        UILabel *phoneLb = [[UILabel alloc] initWithFrame:CGRectMake(headImage.right + 10, userNameLb.bottom, kMainScreenWidth * 0.75, 40)];
        phoneLb.text = [NSString stringWithFormat:@"电话: %@", self.staffModel.staff_phone];;
        phoneLb.font = [UIFont systemFontOfSize:15];
        phoneLb.textColor = [UIColor whiteColor];
        [_headView addSubview:phoneLb];
        
        UILabel *workTypeLb = [[UILabel alloc] initWithFrame:CGRectMake(headImage.right + 10, phoneLb.bottom, 180, 40)];
        workTypeLb.text = [NSString stringWithFormat:@"工种: %@", self.staffModel.type_of_work_name];
        workTypeLb.font = [UIFont systemFontOfSize:15];
        workTypeLb.textColor = [UIColor whiteColor];
        [_headView addSubview:workTypeLb];
        
        _tableView.tableHeaderView = _headView;
    }
    return _headView;
}

- (CheckModel *)checkModel {
    if (!_checkModel) {
        _checkModel = [CheckModel new];
    }
    return _checkModel;
}

- (NSMutableArray *)checkArr {
    if (!_checkArr) {
        _checkArr = [NSMutableArray new];
    }
    return _checkArr;
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
