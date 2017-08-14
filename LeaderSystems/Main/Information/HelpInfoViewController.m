//
//  HelpInfoViewController.m
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/6/19.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "HelpInfoViewController.h"
#import "NotiInfoTableViewCell.h"
//#import "HelpInfoListModel.h"
#import "InfoListModel.h"
#import "InfoDetailViewController.h"

@interface HelpInfoViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *notiArr;
@property (nonatomic, assign) NSInteger page;
@end
typedef NS_ENUM(NSUInteger, RefreshMode) {
    RefreshModeFirst,
    RefreshModeMore,
};

typedef NS_ENUM(NSUInteger, HandleMode) {
    HelpHandleMode = 1,
    EndHelpHandleMode = 2,
    UnusualHandleMode = 3,
    EndUnusualHandleMode = 4,
};

@implementation HelpInfoViewController

#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"求助详情";
    self.view.backgroundColor = kColorBg;
    [self.tableView registerNib:[UINib nibWithNibName:@"NotiInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"NotiInfoTableViewCell"];
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getNotiContentWithRefreshMode:RefreshModeFirst];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getNotiContentWithRefreshMode:RefreshModeMore];
    }];
    
//    [self startLoading];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self startLoading];
}
#pragma mark - Method
- (void)startLoading {
    [self.tableView.mj_header beginRefreshing];
}

/*  获取通知内容 */
- (void)getNotiContentWithRefreshMode:(RefreshMode)refreshMode {
    if (refreshMode == RefreshModeFirst) {
        [self.notiArr removeAllObjects];
        self.page = 1;
    }else {
        self.page += 1;
    }
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"account_token"] = [UserManager sharedManager].user.account_token;
    params[@"pageCount"] = @10;
    params[@"page"] = [NSString stringWithFormat:@"%ld", (long)self.page];
    NSString *url;
    if (self.infoType == HelpInfo) {
        url = kUrl_HelpInfoList;
    }
    if (self.infoType == UnusualInfo) {
        url = kUrl_UnusualList;
    }
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:url parameters:params completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                if (self.infoType == HelpInfo) {
                    for (id model in jsonData[@"result"]) {
                        InfoListModel *infoListModel = [InfoListModel parse:model];
                        [self.notiArr addObject:infoListModel];
                    }
                }else {
                    for (id model in jsonData[@"result"]) {
                        InfoListModel *detailInfoModel = [InfoListModel parse:model];
                        [self.notiArr addObject:detailInfoModel];
                    }
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

//处理通知信息
- (void)infoHandleWith: (HandleMode)mode andModel:(DetailInfoModel *)model{
    NSMutableDictionary *params = [NSMutableDictionary new];
    NSString *url;
    switch (mode) {
        case HelpHandleMode:
            params[@"account_token"] = [UserManager sharedManager].user.account_token;
            params[@"emergency_calling_id"] = [NSString stringWithFormat:@"%ld", (long)model.emergency_calling_id];
            params[@"result"] = @"正在处理"; //后期可以填写处理报告
            url = kUrl_AcceptHelp;
            break;
        case EndHelpHandleMode:
            params[@"account_token"] = [UserManager sharedManager].user.account_token;
            params[@"emergency_calling_id"] = [NSString stringWithFormat:@"%ld", (long)model.emergency_calling_id];
            url = kUrl_CompleteHelp;
            break;
        case UnusualHandleMode:
            params[@"account_token"] = [UserManager sharedManager].user.account_token;
            params[@"nowLocationdId"] = [NSString stringWithFormat:@"%ld", (long)model.nowLocationdId];
            params[@"disposeResult"] = @"正在处理";
            url = kUrl_AcceptUnusual;
            break;
        case EndUnusualHandleMode:
            params[@"account_token"] = [UserManager sharedManager].user.account_token;
            params[@"nowLocationdId"] = [NSString stringWithFormat:@"%ld", (long)model.nowLocationdId];
            url = kUrl_CompleteUnusual;
            break;
        default:
            break;
    }
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:url parameters:params completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                [self getNotiContentWithRefreshMode:RefreshModeFirst];
            }else {
                [self.view showWarning:jsonData[@"cause"]];
            }
        } else {
            [self.view showWarning:error.domain];
        }

    }];
}

#pragma mark - UITableView Delegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.notiArr != nil) {
        return self.notiArr.count;
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 160;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"NotiInfoTableViewCell";
    NotiInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (self.infoType == HelpInfo) {
        InfoListModel *listModel = self.notiArr[indexPath.row];
        DetailInfoModel *model = listModel.emergencyCallingInfo;
        [cell setHelpCellData:model];
        [cell setHandleBtnBlock:^{
            if (!model.isHandle && !model.isComplete) {
                [self infoHandleWith:HelpHandleMode andModel:model];
            }
            if (model.isHandle && !model.isComplete) {
                [self infoHandleWith:EndHelpHandleMode andModel:model];
            }
        }];
    }else {
        InfoListModel *model = self.notiArr[indexPath.row];
        [cell setUnusualCellData:model];
//        cell.nameLb.text = [NSString stringWithFormat:@"姓名: %@", model.staff_name];
//        cell.phoneLb.text = [NSString stringWithFormat:@"电话: %@", model.staff_phone];
//        cell.timeLb.text = model.entryTime;
//        [cell handleUnusualStateWithModel:model];
//        [cell setHandleBtnBlock:^{
//            if (!model.isDispose && !model.isComplete) {
//                [self infoHandleWith:UnusualHandleMode andModel:model];
//            }
//            if (model.isDispose && !model.isComplete) {
//                [self infoHandleWith:EndUnusualHandleMode andModel:model];
//            }
//        }];
//        if (model.isComplete) {
//            NSString *str = @"状态: 处理完成";
//            NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:str];
//            [attriStr addAttributes:@{NSForegroundColorAttributeName:[UIColor greenColor]} range:[str rangeOfString:@"处理完成"]];
//            cell.isCompleteLb.attributedText = attriStr;
//        }else {
//            if (model.isDispose) {
//                NSString *str = @"状态: 正在处理";
//                NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:str];
//                [attriStr addAttributes:@{NSForegroundColorAttributeName:RGBColor(248, 200, 3)} range:[str rangeOfString:@"正在处理"]];
//                cell.isCompleteLb.attributedText = attriStr;
//            }else {
//                NSString *str = @"状态: 未处理";
//                NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:str];
//                [attriStr addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:[str rangeOfString:@"未处理"]];
//                cell.isCompleteLb.attributedText = attriStr;
//            }
//        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    InfoDetailViewController *pushVc = [InfoDetailViewController new];
    if (self.infoType == HelpInfo) {
        InfoListModel *listModel = self.notiArr[indexPath.row];
        DetailInfoModel *model = listModel.emergencyCallingInfo;
        pushVc.emergency_calling_id = model.emergency_calling_id;
        pushVc.emergency_calling_type_id = model.emergency_calling_type_id;
    }else {
        InfoListModel *model = self.notiArr[indexPath.row];
        pushVc.nowLocationdId = model.nowLocationds.nowLocationdId;
    }
    [self.navigationController pushViewController:pushVc animated:YES];
}

#pragma mark - Lazy Load
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 64 - 40) style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        //不显示系统自带分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSMutableArray *)notiArr {
    if (!_notiArr) {
        _notiArr = [NSMutableArray new];
    }
    return _notiArr;
}

@end
