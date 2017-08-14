//
//  OnlineStaffViewController.h
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/7/13.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OnlineStaffDelegate <NSObject>

- (void)showSelectStaff:(NSArray *)staffs;

@end

@interface OnlineStaffViewController : UIViewController
@property (nonatomic, assign) NSInteger emergency_calling_id;
@property (nonatomic, assign) int nowLocationdId;
@property (nonatomic, weak) id<OnlineStaffDelegate> delegate;
@end
