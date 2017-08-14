//
//  DetailTaskModel.h
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/8/9.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StaffModel.h"
#import "PatrolInfoModel.h"
#import "LineModel.h"
#import "CoordinateModel.h"

@interface DetailTaskModel : NSObject
//安保
@property (nonatomic, strong) StaffModel *staff;
@property (nonatomic, strong) NSArray <PatrolInfoModel *>*nowLocationdsInfos; //巡逻集合
@property (nonatomic, strong) LineModel *theSecurityLine; //安保路线
@property (nonatomic, strong) NSArray <CoordinateModel *> *theSecurityLineLatlngs; //安保路线坐标
@property (nonatomic, strong) NSArray <CoordinateModel *> *theSecurityLineLatlngLimits; //安保巡逻规则
@property (nonatomic, strong) ReportModel *securityPatrolRecord; //安保任务基本字段
@property (nonatomic, strong) ReportModel *securityPatrolRecordState; //安保任务状态
@property (nonatomic, strong) ReportModel *accomplishSecurityPatrolRecord; //安保巡逻完成
@property (nonatomic, strong) ReportModel *accomplishSecurityPatrolRecordState; //安保巡逻完成状态

//保洁
@property (nonatomic, strong) ReportModel *cleaningRecords; //保洁任务基本字段
@property (nonatomic, strong) ReportModel *cleaningRecordsState; //保洁任务状态
@property (nonatomic, strong) LineModel *cleaningArea; //保洁区域
@property (nonatomic, strong) NSArray <CoordinateModel *>*cleaningAreaLatlngs; //保洁区域坐标点
@property (nonatomic, strong) CoordinateModel *cleaningAreaLimit; //打扫规则
@property (nonatomic, strong) ReportModel *accomplishCleaningRecords; //保洁完成任务字段
@property (nonatomic, strong) ReportModel *accomplishCleaningRecordsState; //保洁完成任务状态字段
@property (nonatomic, strong) NSArray <PicturesModel*> *accomplishCleaningRecordsPictures; //任务上传图片

//摆渡车
@property (nonatomic, strong) ReportModel *ferryPushRecord; //摆渡车任务基本字段
@property (nonatomic, strong) ReportModel *ferryPushRecordState; //摆渡车任务状态
@property (nonatomic, strong) ReportModel *ferryPush; //摆渡车
@property (nonatomic, strong) ReportModel *ferryPushState; //摆渡车状态
@property (nonatomic, strong) LineModel *feeryPushLine; //摆渡车路线
@property (nonatomic, strong) NSArray <CoordinateModel *> *ferryPushLineLatlngs; //摆渡车坐标点
@property (nonatomic, strong) ReportModel *chooseShuttleBuses; //摆渡车绑定记录
@property (nonatomic, strong) ReportModel *accomplishFerryPushRecord; //完成任务记录

//游船
@property (nonatomic, strong) ReportModel *theBoatCirculationRecords; //游船基本字段
@property (nonatomic, strong) ReportModel *theBoatCirculationRecordsState; //游船任务状态
@property (nonatomic, strong) LineModel *cruiseLine; //游船路线
@property (nonatomic, strong) NSArray <CoordinateModel *> *cruiseLineLatlngs; //游船路线坐标
@property (nonatomic, strong) ReportModel *choosePleasureBoat; //绑定游船字段
@property (nonatomic, strong) ReportModel *pleasureBoat; //游船
@property (nonatomic, strong) ReportModel *pleasureBoatState; //游船状态
@property (nonatomic, strong) ReportModel *accomplishTheBoatCirculationRecords; //游船任务完成
@end
