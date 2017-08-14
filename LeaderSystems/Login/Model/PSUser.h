//
//  PSUser.h
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/6/7.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LeaderAccount.h"

@interface PSUser : NSObject
@property (nonatomic, copy) NSString *account_token;
@property (nonatomic, strong) LeaderAccount *leaderAccount;

@property (nonatomic, assign) NSInteger _j_msgid;
@property (nonatomic, copy) NSString *type;
@end
