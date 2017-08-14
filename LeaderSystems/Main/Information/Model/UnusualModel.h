//
//  UnusualModel.h
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/8/1.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NowLocationdsModel.h"
#import "NowLocationdIdStateModel.h"
#import "AuxiliaryStaffsModel.h"
#import "PicturesModel.h"
#import "StaffOnLineModel.h"
#import "NowLocationdDisposeModel.h"
#import "NowLocationdAccomplishModel.h"
#import "LeaderModel.h"

@interface UnusualModel : NSObject
@property (nonatomic, strong) NowLocationdsModel *nowLocationds;
@property (nonatomic, strong) NowLocationdIdStateModel *nowLocationdIdState;
@property (nonatomic, strong) NSArray <AuxiliaryStaffsModel *> *auxiliaryStaffs;
@property (nonatomic, strong) NSArray <PicturesModel *> *nowLocationdPictures;
@property (nonatomic, strong) StaffOnLineModel *staffOnline;
@property (nonatomic, strong) NowLocationdDisposeModel *nowLocationdDispose;
@property (nonatomic, strong) NowLocationdAccomplishModel *nowLocationdAccomplish;
@property (nonatomic, strong) LeaderModel *leaderAccount;
@end
