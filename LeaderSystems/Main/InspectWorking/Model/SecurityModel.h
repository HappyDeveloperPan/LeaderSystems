//
//  SecurityModel.h
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/6/16.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoordinateModel.h"

@interface SecurityModel : NSObject
@property (nonatomic, strong) NSArray <CoordinateModel *>*the_security_line;
@property (nonatomic, assign) NSInteger the_security_line_id;
@property (nonatomic, copy) NSString *the_security_line_name;
@end
