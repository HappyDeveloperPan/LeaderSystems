//
//  WorkingDetailViewController.m
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/6/15.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "WorkingDetailViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <GCDAsyncSocket.h>
#import "RadialCircleAnnotationView.h"
#import "DetailCheckViewController.h"

@interface WorkingDetailViewController ()<MAMapViewDelegate, GCDAsyncSocketDelegate>
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) NSMutableArray *lineArr;
@property (nonatomic, strong) MAMultiPolyline *polyLine;
@property (nonatomic, assign) CLLocationCoordinate2D *runningCoords;
@property (nonatomic, strong) MAPolygon *polygon;
@property (nonatomic, strong) GCDAsyncSocket *asyncSocket;
@property (nonatomic, strong) NSTimer *sendMessageTimer;    //心跳定时器
@property (nonatomic, strong) NSTimer *reconnectTimer;      //重连定时器
@property (nonatomic, assign) NSInteger reconnectionCount;  // 建连失败重连次数
@property (nonatomic, strong) MAPointAnnotation *annotation;
@property (nonatomic, strong) UIButton *checkBtn;
@property (nonatomic, strong) StaffWorkingModel *staffWorkModel;
@end

@implementation WorkingDetailViewController
#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"任务详情";
    self.view.backgroundColor = kColorMajor;
    
    [self mapView];
    [self checkBtn];
    if (self.staffModel.onLine) {
        [self connectServer];
    }
    [self getStaffLine];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self disconnectedSocket];
}


#pragma mark - Method

//获取路线数据
- (void)getStaffLine {
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"staff_id"] = [NSString stringWithFormat:@"%ld",(long)self.staffModel.staff.staff_id];
    parameters[@"account_token"] = [UserManager sharedManager].user.account_token;
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:kUrl_GetStaffInfo parameters:parameters completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData[@"resultnumber"] intValue] == 200) {
                self.staffWorkModel = [StaffWorkingModel parse:jsonData[@"result"]];
                [self showLine];
                if (!self.staffWorkModel.line) {
                    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(self.staffWorkModel.latLng.lat, self.staffWorkModel.latLng.lng);
                    self.annotation.coordinate = coor;
                    self.annotation.title = @"正在任务中^_^";
                    
                    [self.mapView addAnnotation:self.annotation];
                    [self.mapView setCenterCoordinate:coor animated:YES];
                }
            }else {
                [self.view showWarning:jsonData[@"cause"]];
            }
        } else {
            [self.view showWarning:error.domain];
        }

    }];
}
//显示路线
- (void)showLine {
    switch (self.staffWorkModel.staff.type_of_work_id) {
        case 1:
            for (CoordinateModel *lineModel in self.staffWorkModel.line.the_security_line) {
                [self.lineArr addObject:lineModel];
            }
            break;
        case 2:
            for (CoordinateModel *lineModel in self.staffWorkModel.line.cleaning_area) {
                [self.lineArr addObject:lineModel];
            }
            break;
        case 3:
            for (CoordinateModel *lineModel in self.staffWorkModel.line.ferry_push_line) {
                [self.lineArr addObject:lineModel];
            }
            break;
        case 4:
            for (CoordinateModel *lineModel in self.staffWorkModel.line.cruise_line) {
                [self.lineArr addObject:lineModel];
            }
            break;
        default:
            break;
    }
    if (self.lineArr.count > 0) {
        NSMutableArray * indexes = [NSMutableArray array];
        NSInteger count = 0;
        count = self.lineArr.count;
        self.runningCoords = (CLLocationCoordinate2D *)malloc(count * sizeof(CLLocationCoordinate2D));
        
        for (int i = 0; i < count; i++)
        {
            @autoreleasepool
            {
                CoordinateModel *coor = self.lineArr[i];
                self.runningCoords[i].latitude = coor.lat;
                self.runningCoords[i].longitude = coor.lng;
                
                [indexes addObject:@(i)];
            }
        }
        if (self.staffModel.staff.type_of_work_id == 2) {
            //显示范围
            self.polygon = [MAPolygon polygonWithCoordinates:self.runningCoords count:count];
            [self.mapView addOverlay:self.polygon];
        }else {
            //显示路线
            self.polyLine = [MAMultiPolyline polylineWithCoordinates:self.runningCoords count:count drawStyleIndexes:indexes];
            [self.mapView addOverlay:self.polyLine];
        }
        [self.mapView setCenterCoordinate:*(self.runningCoords) animated:YES];
    }
}

//查看员工任务考勤
- (void)staffTaskCheck {
    DetailCheckViewController *pushVc = [DetailCheckViewController new];
    pushVc.isShowDate = YES;
    pushVc.date = [NSDate date];
    pushVc.staffModel = self.staffModel.staff;
    [self.navigationController showViewController:pushVc sender:nil];
}
#pragma mark - tcp连接
//连接tcp
- (void)connectServer {
    NSError *error;
    [self.asyncSocket connectToHost:socketAdress onPort:socketPort withTimeout:10 error:&error];
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
    parameters[@"ioSessionId"] = [NSString stringWithFormat:@"%ld",(long)self.staffModel.ioSessionId];
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
        CoordinateModel *coorModel = [CoordinateModel parse:jsonData[@"result"][@"latLng"]];
        CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(coorModel.lat, coorModel.lng);
        self.annotation.coordinate = coor;
        self.annotation.title = @"正在任务中^_^";
        
        [self.mapView addAnnotation:self.annotation];
        [self.mapView setCenterCoordinate:coor animated:YES];
    });
}

#pragma mark - MapView Delegate
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay {
    if (overlay == self.polyLine)
    {
        MAMultiColoredPolylineRenderer * polylineRenderer = [[MAMultiColoredPolylineRenderer alloc] initWithMultiPolyline:overlay];
        
        polylineRenderer.lineWidth = 8.f;
        //        polylineRenderer.strokeColors = _speedColors;
        polylineRenderer.gradient = YES;
        
        return polylineRenderer;
    }
    if ([overlay isKindOfClass:[MAPolygon class]])
    {
        MAPolygonRenderer *polygonRenderer = [[MAPolygonRenderer alloc] initWithPolygon:overlay];
        polygonRenderer.lineWidth   = 4.f;
        polygonRenderer.strokeColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:1];
        polygonRenderer.fillColor   = [UIColor redColor];
        
        return polygonRenderer;
    }
    return nil;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIdentifier = @"pointReuseIdentifier";
        RadialCircleAnnotationView *annotationView = (RadialCircleAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIdentifier];
        if (annotationView == nil)
        {
            annotationView = [[RadialCircleAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIdentifier];
            annotationView.canShowCallout = YES;
            
            //脉冲圈个数
            annotationView.pulseCount = 3;
            //单个脉冲圈动画时长
            annotationView.animationDuration = 8.0;
            //单个脉冲圈起始直径
            annotationView.baseDiameter = 4.0;
            //单个脉冲圈缩放比例
            annotationView.scale = 30.0;
            //单个脉冲圈fillColor
            annotationView.fillColor = kColorMain;
            //单个脉冲圈strokeColor
            annotationView.strokeColor = kColorMain;
            //标注点内圈原点颜色
            annotationView.fixedLayer.backgroundColor = kColorMain.CGColor;
            
            //更改设置后重新开始动画
            [annotationView startPulseAnimation];
        }
        return annotationView;
    }
    
    return nil;
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
//        NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
//        [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss:SSS"];
//        NSString *date =  [formatter stringFromDate:[NSDate date]];
//        NSString *timeLocal = [[NSString alloc] initWithFormat:@"%@", date];
//        NSLog(@"%@", timeLocal);
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
        //[_mapView setUserTrackingMode:MAUserTrackingModeFollowWithHeading animated:YES];
        // 开启定位
//        _mapView.userTrackingMode = MAUserTrackingModeFollow;
//        _mapView.showsUserLocation = YES;
        [_mapView setZoomLevel:16.1 animated:YES];
        [self.view addSubview:_mapView];
    }
    return _mapView;
}

- (NSMutableArray *)lineArr {
    if (!_lineArr) {
        _lineArr = [NSMutableArray new];
    }
    return _lineArr;
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

- (StaffWorkingModel *)staffWorkModel {
    if (!_staffWorkModel) {
        _staffWorkModel = [[StaffWorkingModel alloc] init];
    }
    return _staffWorkModel;
}

- (UIButton *)checkBtn {
    if (!_checkBtn ) {
        _checkBtn = [[UIButton alloc] init];
        [self.view addSubview:_checkBtn];
        [_checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.size.mas_equalTo(CGSizeMake(80, 80));
        }];
        _checkBtn.backgroundColor = kColorMain;
        _checkBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _checkBtn.titleLabel.textAlignment = NSTextAlignmentCenter; // if you want to
        [_checkBtn setTitle: @"查看\n任务" forState: UIControlStateNormal];
        [_checkBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
        _checkBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _checkBtn.layer.cornerRadius = 40;
        _checkBtn.layer.shadowColor = kColorMajor.CGColor;;//shadowColor阴影颜色
        _checkBtn.layer.shadowOffset = CGSizeMake(4,4);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        _checkBtn.layer.shadowOpacity = 0.5;//阴影透明度，默认0
        _checkBtn.layer.shadowRadius = 2;//阴影半径，默认3
        [_checkBtn addTarget:self action:@selector(staffTaskCheck) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkBtn;
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
