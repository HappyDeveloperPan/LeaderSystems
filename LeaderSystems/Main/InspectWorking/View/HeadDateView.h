//
//  HeadDateView.h
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/7/11.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HeaderViewBlock)(NSDate *date);

@interface HeadDateView : UIView
@property (nonatomic, strong) NSDate *centerDate;
@property (nonatomic, copy)  HeaderViewBlock lastClick;
@property (nonatomic, copy)  HeaderViewBlock nextClick;

@end
