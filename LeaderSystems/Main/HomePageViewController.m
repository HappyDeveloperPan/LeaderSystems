//
//  HomePageViewController.m
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/6/5.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "HomePageViewController.h"
#import "AttendanceViewController.h"
#import "InspectWorkingViewController.h"
#import "PageViewController.h"
#import <MAMapKit/MAMapKit.h>
//#import <AMapLocationKit/AMapLocationKit.h>
//#import <AMapFoundationKit/AMapFoundationKit.h>

@interface HomePageViewController ()<MAMapViewDelegate>
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) MAAnnotationView *userLocationAnnotationView;
@property (nonatomic, strong) MAUserLocationRepresentation *userLocationAnn;
@property (nonatomic, strong) UIButton *gpsBtn, *attendanceBtn, *inspectWorkBtn;
@property (nonatomic, strong) UIBarButtonItem *notifItem;
@property (nonatomic, strong) UILabel *badgeLab;
@end

@implementation HomePageViewController
#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    self.view.backgroundColor = kColorWhite;
    self.navigationItem.rightBarButtonItem = self.notifItem;
    
//    [self mapView];
    [self showMainView];
    
    [kNotificationCenter addObserver:self selector:@selector(showRedBadge) name:kShowRedBadge object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //设置通知角标
//    [Common layoutBadge:self.badgeLab andCount:[UIApplication sharedApplication].applicationIconBadgeNumber];
//    [self showRedBadge];
    if ([UIApplication sharedApplication].applicationIconBadgeNumber > 0) {
        self.badgeLab.hidden = NO;
    }else {
        self.badgeLab.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Method
//根据角标显示消息红点
- (void)showRedBadge {
//    if ([UIApplication sharedApplication].applicationIconBadgeNumber > 0) {
//        self.badgeLab.hidden = NO;
//    }else {
//        self.badgeLab.hidden = YES;
//    }
    self.badgeLab.hidden = NO;
}

//主界面元素
- (void)showMainView {
//    [self gpsBtn];
    [self attendanceBtn];
    [self inspectWorkBtn];
}

//通知中心
- (void)notifCenter {
    if (![[UserManager sharedManager] isLogin]) {
        [kNotificationCenter postNotificationName:kNotifPresentLogin object:nil];
    }
    PageViewController *notiVc = [[PageViewController alloc] init];
    notiVc.hidesBottomBarWhenPushed = YES;
//    notiVc.notiNumber = [UIApplication sharedApplication].applicationIconBadgeNumber;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [JPUSHService resetBadge];
    [self.navigationController pushViewController:notiVc animated:YES];
}

//定位自己
//- (void)gpsAction {
//    if(self.mapView.userLocation.updating && self.mapView.userLocation.location) {
//        [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
//        [self.gpsBtn setSelected:YES];
//        self.mapView.userTrackingMode = MAUserTrackingModeFollow;
//    }
//}

//查看考勤
- (void)Lookattendance {
    if (![[UserManager sharedManager] isLogin]) {
        [kNotificationCenter postNotificationName:kNotifPresentLogin object:nil];
    }
    AttendanceViewController *attendanceVC = [AttendanceViewController new];
    attendanceVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:attendanceVC animated:YES];
}

//视察工作
- (void)inspectWorking {
    if (![[UserManager sharedManager] isLogin]) {
        [kNotificationCenter postNotificationName:kNotifPresentLogin object:nil];
    }
    InspectWorkingViewController *inspectVc = [InspectWorkingViewController new];
    inspectVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:inspectVc animated:YES];
}

#pragma mark - MapView Delegate
//- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
//{
//    MAAnnotationView *view = views[0];
//    
//    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
//    if ([view.annotation isKindOfClass:[MAUserLocation class]])
//    {
//        //        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
//        //        pre.image = [UIImage imageNamed:@"userPoint"];
//        //        pre.lineWidth = 3;
//        //
//        //
//        //        [self.mapView updateUserLocationRepresentation:pre];
//        
//        self.userLocationAnn.lineWidth = 3;
//        [self.mapView updateUserLocationRepresentation:self.userLocationAnn];
//        
//        view.calloutOffset = CGPointMake(0, 0);
//        view.canShowCallout = NO;
//        
//        
//        view.layer.shadowColor = kColorMajor.CGColor;;//shadowColor阴影颜色
//        view.layer.shadowOffset = CGSizeMake(4,4);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
//        view.layer.shadowOpacity = 0.5;//阴影透明度，默认0
//        view.layer.shadowRadius = 2;//阴影半径，默认3
//        view.layer.rasterizationScale = [[UIScreen mainScreen] scale];//光栅化处理
//        self.userLocationAnnotationView = view;
//    }
//}
//
//- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
//{
//    if (!updatingLocation && self.userLocationAnnotationView != nil)
//    {
//        [UIView animateWithDuration:0.1 animations:^{
//            
//            double degree = userLocation.heading.trueHeading;
//            self.userLocationAnnotationView.transform = CGAffineTransformMakeRotation(degree * M_PI / 180.f );
//            
//        }];
//    }
//    
//}

#pragma mark - Lazy Load
//- (MAMapView *)mapView {
//    if (!_mapView) {
//        _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
//        _mapView.delegate = self;
//        _mapView.showsCompass = NO;
//        _mapView.showsScale = NO;
//        //[_mapView setUserTrackingMode:MAUserTrackingModeFollowWithHeading animated:YES];
//        // 开启定位
//        _mapView.userTrackingMode = MAUserTrackingModeFollow;
//        _mapView.showsUserLocation = YES;
//        [_mapView setZoomLevel:16.1 animated:YES];
//        [self.view addSubview:_mapView];
//    }
//    return _mapView;
//}
//
//- (MAUserLocationRepresentation *)userLocationAnn {
//    if (!_userLocationAnn) {
//        _userLocationAnn = [[MAUserLocationRepresentation alloc] init];
//        _userLocationAnn.image = [UIImage imageNamed:@"userPoint"];
//    }
//    return _userLocationAnn;
//}

- (UIBarButtonItem *)notifItem {
    if (!_notifItem) {
        UIButton *button = [Common addBtnWithImage:@"notifications"];
        [button addTarget:self action:@selector(notifCenter) forControlEvents:UIControlEventTouchUpInside];
        _notifItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        _badgeLab = [Common badgeNumLabWithFrame:CGRectMake(18, -2, 10, 10)];
        [button addSubview:_badgeLab];
    }
    return _notifItem;
}

//- (UIButton *)gpsBtn {
//    if (!_gpsBtn) {
//        _gpsBtn = [[UIButton alloc] init];
//        [self.view addSubview:_gpsBtn];
//        
//        [_gpsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.height.mas_equalTo(40);
//            make.left.mas_equalTo(self.view).offset(15);
//            make.bottom.mas_equalTo(self.view).offset(-20);
//        }];
//        
//        _gpsBtn.backgroundColor = [UIColor whiteColor];
//        _gpsBtn.layer.cornerRadius = 20;
//        _gpsBtn.layer.shadowColor = kColorMajor.CGColor;;//shadowColor阴影颜色
//        _gpsBtn.layer.shadowOffset = CGSizeMake(4,4);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
//        _gpsBtn.layer.shadowOpacity = 0.5;//阴影透明度，默认0
//        _gpsBtn.layer.shadowRadius = 2;//阴影半径，默认3
//        
//        [_gpsBtn setImage:[UIImage imageNamed:@"gpsStat1"] forState:UIControlStateNormal];
//        [_gpsBtn addTarget:self action:@selector(gpsAction) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _gpsBtn;
//}

- (UIButton *)attendanceBtn {
    if (!_attendanceBtn) {
//        _attendanceBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 15, 60, 60)];
        _attendanceBtn = [[UIButton alloc] init];
        [self.view addSubview:_attendanceBtn];
        [_attendanceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(kMainScreenHeight * 0.1);
            make.size.mas_equalTo(CGSizeMake(160, 160));
        }];
        _attendanceBtn.backgroundColor = kColorMain;
        _attendanceBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _attendanceBtn.titleLabel.textAlignment = NSTextAlignmentCenter; // if you want to
        [_attendanceBtn setTitle: @"查看\n考勤" forState: UIControlStateNormal];
        
        [_attendanceBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
        _attendanceBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _attendanceBtn.layer.cornerRadius = 5;
        _attendanceBtn.layer.shadowColor = kColorMajor.CGColor;;//shadowColor阴影颜色
        _attendanceBtn.layer.shadowOffset = CGSizeMake(4,4);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        _attendanceBtn.layer.shadowOpacity = 0.5;//阴影透明度，默认0
        _attendanceBtn.layer.shadowRadius = 2;//阴影半径，默认3
        [_attendanceBtn addTarget:self action:@selector(Lookattendance) forControlEvents:UIControlEventTouchUpInside];
    }
    return _attendanceBtn;
}

- (UIButton *)inspectWorkBtn {
    if (!_inspectWorkBtn) {
//        _inspectWorkBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, self.attendanceBtn.bottom + 15, 60, 60)];
        _inspectWorkBtn = [[UIButton alloc] init];
        [self.view addSubview:_inspectWorkBtn];
        [_inspectWorkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(self.attendanceBtn.mas_bottom).mas_equalTo(25);
            make.size.mas_equalTo(CGSizeMake(160, 160));
        }];
        _inspectWorkBtn.backgroundColor = kColorMain;
        _inspectWorkBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _inspectWorkBtn.titleLabel.textAlignment = NSTextAlignmentCenter; // if you want to
        [_inspectWorkBtn setTitle: @"视察\n工作" forState: UIControlStateNormal];
        
        [_inspectWorkBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
        _inspectWorkBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _inspectWorkBtn.layer.cornerRadius = 5;
        _inspectWorkBtn.layer.shadowColor = kColorMajor.CGColor;;//shadowColor阴影颜色
        _inspectWorkBtn.layer.shadowOffset = CGSizeMake(4,4);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        _inspectWorkBtn.layer.shadowOpacity = 0.5;//阴影透明度，默认0
        _inspectWorkBtn.layer.shadowRadius = 2;//阴影半径，默认3
        [_inspectWorkBtn addTarget:self action:@selector(inspectWorking) forControlEvents:UIControlEventTouchUpInside];
    }
    return _inspectWorkBtn;
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
