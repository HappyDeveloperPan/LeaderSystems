//
//  OnlineStaffViewController.m
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/7/13.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "OnlineStaffViewController.h"
#import "OnlineStaffCollectionViewCell.h"
#import "StaffOnLineModel.h"

@interface OnlineStaffViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSMutableDictionary *cellIdentifierDic;
@property (nonatomic, strong) NSMutableArray *staffArr;
//@property (nonatomic, strong) NSMutableArray *selectStaffArr;
@property (nonatomic, strong) NSMutableSet *selectStaffSet;
@end

@implementation OnlineStaffViewController
#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择工作人员";
    self.view.backgroundColor = kColorWhite;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(completeSelect)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    __weak __typeof(self)weakSelf = self;
    [self.collectionView addHeaderRefresh:^{
        [weakSelf getOnlineStaff];
    }];
    
    [self.collectionView.mj_header beginRefreshing];
    
//    [self getOnlineStaff];
//    [self collectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Method
//获取在线用户
- (void)getOnlineStaff {
    NSMutableDictionary *params = [NSMutableDictionary new];
    NSString *url;
    params[@"account_token"] = [UserManager sharedManager].user.account_token;
    //一键求助
    if (self.emergency_calling_id) {
        params[@"emergency_calling_id"] = [NSString stringWithFormat:@"%ld", (long)self.emergency_calling_id];
        url = kUrl_OnlineStaff;
    }
    //巡逻异常
    if (self.nowLocationdId) {
        params[@"nowLocationdId"] = [NSString stringWithFormat:@"%d", self.nowLocationdId];
        url = kUrl_UnusualOnlineStaff;
    }
    
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:url parameters:params completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                [self.staffArr removeAllObjects];
                for (id model in jsonData[@"result"]) {
                    StaffOnLineModel *staffModel = [StaffOnLineModel parse:model];
                    [self.staffArr addObject:staffModel];
                }
                [self.collectionView reloadData];
            }else {
                [self.view showWarning:jsonData[@"cause"]];
            }
        } else {
            [self.view showWarning:error.domain];
        }
        [self.collectionView.mj_header endRefreshing];
    }];
}

//完成选人
- (void)completeSelect {
    [self.navigationController popViewControllerAnimated:YES];
    NSArray * selectStaffArr = [self.selectStaffSet allObjects];
    [self showSelectDate:selectStaffArr];
}
#pragma mark - OnlineStaff Delegate
//- (void)didSelectDate:(NSDate *)date
//{
//    if (_delegate && [_delegate respondsToSelector:@selector(calendar:didSelectDate:)]) {
//        [_delegate calendar:self didSelectDate:date];
//    }
//}

- (void)showSelectDate:(NSArray *)staffs {
    if (_delegate && [_delegate respondsToSelector:@selector(showSelectStaff:)]) {
        [_delegate showSelectStaff:staffs];
    }
}

#pragma mark - UICollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.staffArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = [self.cellIdentifierDic objectForKey:[NSString stringWithFormat:@"%@",indexPath]];
    if (cellIdentifier == nil) {
        cellIdentifier = [NSString stringWithFormat:@"Cell%@",indexPath];
        [self.cellIdentifierDic setValue:cellIdentifier forKey:[NSString stringWithFormat:@"%@", indexPath]];
        // 注册Cell
        [self.collectionView registerClass:[OnlineStaffCollectionViewCell class]  forCellWithReuseIdentifier:cellIdentifier];
        
    }
    OnlineStaffCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    StaffOnLineModel *staffModel = self.staffArr[indexPath.row];
    [cell showCellData:staffModel];
    return cell;
}


/**
 * Cell是否可以选中
 */
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


/**
 * Cell多选时是否支持取消功能
 */
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

/**
 * Cell选中调用该方法
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    OnlineStaffCollectionViewCell *currentSelecteCell = (OnlineStaffCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    StaffOnLineModel *staffModel = self.staffArr[indexPath.row];
//    [self.selectStaffArr setObject:staffModel atIndexedSubscript:indexPath.row];
    [self.selectStaffSet addObject:staffModel.staff];
    [self changeSelectStateWithCell:currentSelecteCell];
}

/**
 * Cell取消选中调用该方法
 */
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //获取当前变化的Cell
    OnlineStaffCollectionViewCell *currentSelecteCell = (OnlineStaffCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    StaffOnLineModel *staffModel = self.staffArr[indexPath.row];
    [self.selectStaffSet removeObject:staffModel.staff];
//    [self.selectStaffArr removeObjectAtIndex:indexPath.row];
    [self changeSelectStateWithCell:currentSelecteCell];
}


/**
 * Cell根据Cell选中状态来改变Cell上Button按钮的状态
 */
- (void) changeSelectStateWithCell: (OnlineStaffCollectionViewCell *) currentSelecteCell{
    
    
    if (currentSelecteCell.selected == YES){
        //NSLog(@"第%ld个Section上第%ld个Cell被选中了",indexPath.section ,indexPath.row);
//        [currentSelecteCell.selectImg setImage:[UIImage imageNamed:@"checkmark"]];
        currentSelecteCell.selectImg.hidden = NO;
        return;
    }
    
    if (currentSelecteCell.selected == NO){
        //NSLog(@"第%ld个Section上第%ld个Cell取消选中",indexPath.section ,indexPath.row);
        currentSelecteCell.selectImg.hidden = YES;
    }
    
}
#pragma mark - Lazy Load
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 64) collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //设置Cell多选
        _collectionView.allowsMultipleSelection = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumLineSpacing = 10;
        _flowLayout.minimumInteritemSpacing = 10;
        _flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _flowLayout.itemSize = CGSizeMake((kMainScreenWidth - 30) / 2, 120);
    }
    return _flowLayout;
}

- (NSMutableDictionary *)cellIdentifierDic {
    if (!_cellIdentifierDic) {
        _cellIdentifierDic = [NSMutableDictionary new];
    }
    return _cellIdentifierDic;
}

- (NSMutableArray *)staffArr {
    if (!_staffArr) {
        _staffArr = [NSMutableArray new];
    }
    return _staffArr;
}

//- (NSMutableArray *)selectStaffArr {
//    if (!_selectStaffArr) {
//        _selectStaffArr = [NSMutableArray new];
//        [_selectStaffArr addObjectsFromArray:self.staffArr];
//    }
//    return _selectStaffArr;
//}

- (NSMutableSet *)selectStaffSet {
    if (!_selectStaffSet) {
        _selectStaffSet = [NSMutableSet new];
    }
    return _selectStaffSet;
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
