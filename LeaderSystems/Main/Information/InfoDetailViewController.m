//
//  InfoDetailViewController.m
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/6/19.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "InfoDetailViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <GCDAsyncSocket.h>
#import "RadialCircleAnnotationView.h"
#import "HelpModel.h"
#import "UnusualModel.h"
#import "HelpHandleViewController.h"
#import "HandleResultViewController.h"
#import "CustomAnnotation.h"
#import "StaffAnnotationView.h"

@interface InfoDetailViewController ()<MAMapViewDelegate, GCDAsyncSocketDelegate>
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) MAPointAnnotation *annotation;
@property (nonatomic, strong) DetailInfoModel *detailModel;
@property (nonatomic, strong) HelpModel *helpModel;
@property (nonatomic, strong) UnusualModel *unusualModel;
@property (nonatomic, strong) UIButton *handleBtn, *resultBtn;
@property (nonatomic, strong) GCDAsyncSocket *asyncSocket;
@property (nonatomic, strong) NSTimer *sendMessageTimer;    //心跳定时器
@property (nonatomic, strong) NSTimer *reconnectTimer;      //重连定时器
@property (nonatomic, assign) NSInteger reconnectionCount;  // 建连失败重连次数
@property (nonatomic, strong) MAPointAnnotation *redAnnotation;
@end

@implementation InfoDetailViewController
#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorBg;
    [self mapView];
    
//    [self detailInfomation];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self detailInfomation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.emergency_calling_id) {
        [self disconnectedSocket];
    }
}

#pragma mark - Method
//获取详细信息
- (void)detailInfomation {
    NSMutableDictionary *params = [NSMutableDictionary new];
    NSString *url;
    params[@"account_token"] = [UserManager sharedManager].user.account_token;
    if (self.emergency_calling_id) {
        params[@"emergency_calling_id"] = [NSString stringWithFormat:@"%ld",(long)self.emergency_calling_id];
        url = kUrl_HelpInfoDetail;
    }else{
        params[@"nowLocationdId"] = [NSString stringWithFormat:@"%ld",(long)self.nowLocationdId];
        url = kUrl_UnusualDetail;
    }
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:url parameters:params completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                //一键求助
                if (self.emergency_calling_id) {
                    //1.未处理 2.正在处理 3.处理完成 4.撤销 5.已过期
                    self.helpModel = [HelpModel parse:jsonData[@"result"]];
                    if (self.helpModel.emergencyCallingType.emergency_calling_type_id == 1) {
                        [self handleBtn];
                    }
                    if (self.helpModel.emergencyCallingType.emergency_calling_type_id == 2 || self.helpModel.emergencyCallingType.emergency_calling_type_id == 3){
                        [self resultBtn];
                    }
                    //正在处理就连接一键求助tcp
                    if (self.helpModel.emergencyCallingType.emergency_calling_type_id == 2) {
                        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.helpModel.emergencyCalling.lat, self.helpModel.emergencyCalling.lng);
                        self.redAnnotation = [MAPointAnnotation new];
                        self.redAnnotation.coordinate = coordinate;
                        [self connectServer];
                    }else{
                        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.helpModel.emergencyCalling.lat, self.helpModel.emergencyCalling.lng);
                        [self.mapView removeAnnotations:self.mapView.annotations];
                        [self showUserPoint:coordinate];
                    }
                }else {
                    //景点异常
                    self.unusualModel = [UnusualModel parse:jsonData[@"result"]];
                    //3.未处理 4.正在处理 5.已处理 6.已过期
                    if (self.unusualModel.nowLocationdIdState.nowLocationdId_state_id == 3) {
                        [self handleBtn];
                    }
                    if (self.unusualModel.nowLocationdIdState.nowLocationdId_state_id == 4 || self.unusualModel.nowLocationdIdState.nowLocationdId_state_id == 5) {
                        [self resultBtn];
                    }
                    
//                    [self.mapView addAnnotation:annotation];
//                    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(self.unusualModel.nowLocationds.lat, self.unusualModel.nowLocationds.lng) animated:YES];
                    /****************/
                    [self.mapView removeAnnotations:self.mapView.annotations];
                    NSMutableArray *annotationArr = [NSMutableArray new];
                    if (self.unusualModel.auxiliaryStaffs.count > 0 && self.unusualModel.nowLocationdIdState.nowLocationdId_state_id == 4) {
                        
                        for (StaffOnLineModel *staffModel in self.unusualModel.auxiliaryStaffs) {
                            if (staffModel.onLine) {
                                CustomAnnotation *annotation = [CustomAnnotation new];
                                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(staffModel.latLng.lat, staffModel.latLng.lng);
                                annotation.coordinate = coordinate;
                                annotation.staffModel = staffModel;
                                [annotationArr addObject:annotation];
                            }
                        }
                    }
                    MAPointAnnotation *annotation = [MAPointAnnotation new];
                    annotation.coordinate = CLLocationCoordinate2DMake(self.unusualModel.nowLocationds.lat, self.unusualModel.nowLocationds.lng);
                    [annotationArr addObject:annotation];
                    [self.mapView addAnnotations:annotationArr];
                    [self.mapView showAnnotations:annotationArr edgePadding:UIEdgeInsetsMake(200, 200, 200, 200) animated:YES];
                    /*******************/
                }
            }else {
                [self.view showWarning:jsonData[@"cause"]];
            }
        } else {
            [self.view showWarning:error.domain];
        }

    }];
}

//处理求助
- (void)helpHandle {
    HelpHandleViewController *pushVc = [HelpHandleViewController new];
    if (self.emergency_calling_id) {
        pushVc.emergency_calling_id = self.helpModel.emergencyCalling.emergency_calling_id;
    }
    if (self.nowLocationdId) {
        pushVc.nowLocationdId = self.unusualModel.nowLocationds.nowLocationdId;
    }
//    pushVc.emergency_calling_id = self.helpModel.emergencyCalling.emergency_calling_id;
    [self.navigationController pushViewController:pushVc animated:YES];
}

//处理结果
- (void)resultHandle {
    HandleResultViewController *pushVc = [HandleResultViewController new];
    if (self.emergency_calling_id) {
        pushVc.infoType = HelpInfo;
        pushVc.helpModel = self.helpModel;
    }
    if (self.nowLocationdId) {
        pushVc.infoType = UnusualInfo;
        pushVc.unusualModel = self.unusualModel;
    }
//    pushVc.helpModel = self.helpModel;
    [self.navigationController pushViewController:pushVc animated:YES];
}

//显示坐标点
- (void)showUserPoint:(CLLocationCoordinate2D)coordinate {
    MAPointAnnotation *annotation = [MAPointAnnotation new];
    annotation.coordinate = coordinate;
    [self.mapView addAnnotation:annotation];
    [self.mapView setCenterCoordinate:coordinate animated:YES];
}
#pragma mark - tcp连接
//连接tcp
- (void)connectServer {
    NSError *error;
    [self.asyncSocket connectToHost:socketAdress onPort:helpSocketPort withTimeout:10 error:&error];
    if (error) {
        NSLog(@"连接失败:%@", error);
    } else {
        NSLog(@"连接成功");
    }
}

//给服务端发送数据
- (void)sendMessageWithData {
    if (self.sendMessageTimer) {
        [self.sendMessageTimer invalidate];
        self.sendMessageTimer = nil;
    }
    self.sendMessageTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(sendMessageWithData) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.sendMessageTimer forMode:NSRunLoopCommonModes];
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"accountToken"] = [UserManager sharedManager].user.account_token;
    parameters[@"staff_id"] = [NSString stringWithFormat:@"%ld",(long)self.helpModel.emergencyCalling.staff_id];
    NSData *data = [Common dictionnaryObjectToString:parameters];
    [self.asyncSocket writeData:data withTimeout:-1 tag:200];
}

//正常断开tcp连接
- (void)disconnectedSocket {
    self.reconnectionCount = -1;
    [self.asyncSocket disconnect];
}

//断线重连
- (void)socketDidDisconect {
    if (self.reconnectionCount >= 0 && self.reconnectionCount <= 3) {
        NSTimeInterval time = pow(2, self.reconnectionCount);
        if (!self.reconnectTimer) {
            self.reconnectTimer = [NSTimer scheduledTimerWithTimeInterval:time
                                                                   target:self
                                                                 selector:@selector(connectServer)
                                                                 userInfo:nil
                                                                  repeats:NO];
            [[NSRunLoop mainRunLoop] addTimer:self.reconnectTimer forMode:NSRunLoopCommonModes];
        }
        self.reconnectionCount++;
    } else {
        [self.reconnectTimer invalidate];
        self.reconnectTimer = nil;
        self.reconnectionCount = 0;
    }
}

//处理tcp返回数据
- (void)analyticSocketReturnData:(NSData *)data {
    dispatch_async_on_main_queue(^{
        id  jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        //业务逻辑, 解析数据
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                [self.mapView removeAnnotations:self.mapView.annotations];
                HelpModel *helpModel = [HelpModel parse:jsonData[@"result"]];
                NSMutableArray *annotationArr = [NSMutableArray new];
                for (StaffOnLineModel *staffModel in helpModel.helpStaffs) {
                    if (staffModel.onLine) {
                        CustomAnnotation *annotation = [CustomAnnotation new];
                        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(staffModel.latLng.lat, staffModel.latLng.lng);
                        annotation.coordinate = coordinate;
                        annotation.staffModel = staffModel;
                        [annotationArr addObject:annotation];
                    }
                }
                if (self.redAnnotation) {
                    [annotationArr addObject:self.redAnnotation];
                }
                
                [self.mapView addAnnotations:annotationArr];
                [self.mapView showAnnotations:annotationArr edgePadding:UIEdgeInsetsMake(200, 200, 200, 200) animated:YES];
                //                    [self.mapView setCenterCoordinate:coordinate animated:YES];
            }else {
                [self.view showWarning:jsonData[@"cause"]];
            }
        }
    });
}
#pragma mark - MapView Delegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[CustomAnnotation class]]) {
        CustomAnnotation *customAnnotation = (CustomAnnotation*)annotation;
        static NSString *staffReuseIdentifier = @"staffReuseIdentifier";
        StaffAnnotationView *annotationView = (StaffAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:staffReuseIdentifier];
        if (annotationView == nil) {
            annotationView = [[StaffAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:staffReuseIdentifier];
            annotationView.canShowCallout = NO;
            annotationView.calloutOffset = CGPointMake(0, -5);
            annotationView.staffModel = customAnnotation.staffModel;
            annotationView.image = [UIImage imageNamed:@"Personnel"];
        }
        return annotationView;
    }
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIdentifier = @"pointReuseIdentifier";
        RadialCircleAnnotationView *annotationView = (RadialCircleAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIdentifier];
        if (annotationView == nil)
        {
            annotationView = [[RadialCircleAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIdentifier];
            annotationView.canShowCallout = NO;
            annotationView.calloutOffset = CGPointMake(0, -5);
            //设置弹出框数据
            //一键求助
            if (self.emergency_calling_id) {
                annotationView.helpModel = self.helpModel;
            }
            //异常处理
            else{
                annotationView.unusualModel = self.unusualModel;
            }
            
            //脉冲圈个数
            annotationView.pulseCount = 4;
            //单个脉冲圈动画时长
            annotationView.animationDuration = 7.0;
            //单个脉冲圈起始直径
            annotationView.baseDiameter = 4.0;
            //单个脉冲圈缩放比例
            annotationView.scale = 30.0;
            //单个脉冲圈fillColor
            annotationView.fillColor = KcolorRed;
            //单个脉冲圈strokeColor
            annotationView.strokeColor = KcolorRed;
            //标注点内圈原点颜色
            annotationView.fixedLayer.backgroundColor = kColorMain.CGColor;
            
            //更改设置后重新开始动画
            [annotationView startPulseAnimation];
        }
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    /* Adjust the map center in order to show the callout view completely. */
    if ([view isKindOfClass:[RadialCircleAnnotationView class]]) {
        RadialCircleAnnotationView *cusView = (RadialCircleAnnotationView *)view;
        CGRect frame = [cusView convertRect:cusView.calloutView.frame toView:self.mapView];
        
        frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(-8, -8, -8, -8));
        
        if (!CGRectContainsRect(self.mapView.frame, frame))
        {
            /* Calculate the offset to make the callout view show up. */
            CGSize offset = [Common offsetToContainRect:frame inRect:self.mapView.frame];
            
            CGPoint theCenter = self.mapView.center;
            theCenter = CGPointMake(theCenter.x - offset.width, theCenter.y - offset.height);
            
            CLLocationCoordinate2D coordinate = [self.mapView convertPoint:theCenter toCoordinateFromView:self.mapView];
            
            [self.mapView setCenterCoordinate:coordinate animated:YES];
        }
        
    }
}

#pragma mark - GCDAsyncSocket Delegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    NSLog(@"成功连接到服务器");
    self.reconnectionCount = 0;
    [self sendMessageWithData];
    [self.asyncSocket readDataWithTimeout:-1 tag:200];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    [self.sendMessageTimer invalidate];
    self.sendMessageTimer = nil;
    if (err) {
        NSLog(@"连接失败DidDisconnect %@", err);
        //断线重连
        [self socketDidDisconect];
    } else {
        NSLog(@"正常断开连接");
    }
}

//读取消息
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    if (data != nil) {
        id  jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", [jsonData class]);
        NSLog(@"%@",result);
        NSLog(@"%@", [NSDate date]);
        [self analyticSocketReturnData:data];
    }
    [self.asyncSocket readDataWithTimeout:-1 tag:200];
}

#pragma mark - Lazy Load
- (MAMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
        _mapView.delegate = self;
        _mapView.showsCompass = NO;
        _mapView.showsScale = NO;
        [_mapView setZoomLevel:16.1 animated:YES];
        [self.view addSubview:_mapView];
    }
    return _mapView;
}

- (UIButton *)handleBtn {
    if (!_handleBtn) {
        _handleBtn = [[UIButton alloc] init];
        [self.view addSubview:_handleBtn];
        [_handleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.size.mas_equalTo(CGSizeMake(80, 80));
        }];
        _handleBtn.backgroundColor = kColorMain;
        _handleBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _handleBtn.titleLabel.textAlignment = NSTextAlignmentCenter; // if you want to
        [_handleBtn setTitle: @"处理\n求助" forState: UIControlStateNormal];
        [_handleBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
        _handleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _handleBtn.layer.cornerRadius = 40;
        _handleBtn.layer.shadowColor = kColorMajor.CGColor;;//shadowColor阴影颜色
        _handleBtn.layer.shadowOffset = CGSizeMake(4,4);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        _handleBtn.layer.shadowOpacity = 0.5;//阴影透明度，默认0
        _handleBtn.layer.shadowRadius = 2;//阴影半径，默认3
        [_handleBtn addTarget:self action:@selector(helpHandle) forControlEvents:UIControlEventTouchUpInside];
    }
    return _handleBtn;
}

- (UIButton *)resultBtn {
    if (!_resultBtn) {
        _resultBtn = [[UIButton alloc] init];
        [self.view addSubview:_resultBtn];
        [_resultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.size.mas_equalTo(CGSizeMake(80, 80));
        }];
        _resultBtn.backgroundColor = kColorMain;
        _resultBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _resultBtn.titleLabel.textAlignment = NSTextAlignmentCenter; // if you want to
        [_resultBtn setTitle: @"处理\n结果" forState: UIControlStateNormal];
        [_resultBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
        _resultBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _resultBtn.layer.cornerRadius = 40;
        _resultBtn.layer.shadowColor = kColorMajor.CGColor;;//shadowColor阴影颜色
        _resultBtn.layer.shadowOffset = CGSizeMake(4,4);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        _resultBtn.layer.shadowOpacity = 0.5;//阴影透明度，默认0
        _resultBtn.layer.shadowRadius = 2;//阴影半径，默认3
        [_resultBtn addTarget:self action:@selector(resultHandle) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resultBtn;
}

- (DetailInfoModel *)detailModel {
    if (!_detailModel) {
        _detailModel = [DetailInfoModel new];
        
    }
    return _detailModel;
}

- (HelpModel *)helpModel {
    if (!_helpModel) {
        _helpModel = [HelpModel new];
    }
    return _helpModel;
}

- (UnusualModel *)unusualModel {
    if (!_unusualModel) {
        _unusualModel = [UnusualModel new];
    }
    return _unusualModel;
}

- (GCDAsyncSocket *)asyncSocket {
    if (!_asyncSocket) {
        _asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return _asyncSocket;
}

- (MAPointAnnotation *)annotation {
    if (!_annotation) {
        _annotation = [[MAPointAnnotation alloc] init];
    }
    return _annotation;
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
