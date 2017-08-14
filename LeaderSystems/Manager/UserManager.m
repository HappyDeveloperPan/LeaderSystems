//
//  UserManager.m
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/6/7.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "UserManager.h"

@implementation UserManager
static UserManager *manager;


+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        manager = [super allocWithZone:zone];
    });
    return manager;
}

+ (UserManager *)sharedManager {
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (id)copyWithZone:(NSZone *)zone {
    return manager;
}


- (BOOL)isLogin {
    return self.user.account_token?YES:NO;
}

+ (void)loginWithPhone:(NSString *)phone andPass:(NSString *)pass andSuccess:(void (^)(PSUser *, NSError *))successHandler andFailure:(FailureHandler)failureHandler {
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"leader_account_phone"] = phone;
    parameters[@"leader_account_password"] = pass;
    parameters[@"regid"] = [Common getAsynchronousWithKey:kJPushRegisterId];
    
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:kUrl_Login parameters:parameters completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData && [jsonData[@"resultnumber"] intValue] == 200) {
            if (successHandler) {
                
                if (![Common getAsynchronousWithKey:kRunVersion]) {
                    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                    [Common setAsynchronous:version WithKey:kRunVersion];
                }
                [Common setAsynchronous:jsonData[@"result"][@"account_token"] WithKey:kSaveToken];
                successHandler([PSUser parse:jsonData[@"result"]], error);
            }
        }else{
            if (!error) {
                error = [NSError errorWithDomain:jsonData[@"cause"] code:[jsonData[@"resultnumber"] intValue] userInfo:nil];
            }
            if (failureHandler) {
                failureHandler(error);
            }
        }
    }];
}

+ (void)QuickLoginWithToken:(NSString *)token andSuccess:(void (^)(id , NSError *))successHandler andFailure:(FailureHandler)failureHandler {
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"account_token"] = token;
    [RXApiServiceEngine requestWithType:RequestMethodTypePost url:kUrl_QuickLogin parameters:parameters completionHanlder:^(id jsonData, NSError *error) {
        if (jsonData && [jsonData[@"resultnumber"] intValue] == 200) {
            if (successHandler) {
                successHandler([PSUser parse:jsonData[@"result"]], error);
            }
        }else{
            if (!error) {
                error = [NSError errorWithDomain:jsonData[@"cause"] code:[jsonData[@"resultnumber"] intValue] userInfo:nil];
                if ([jsonData[@"resultnumber"] intValue] != 200) {
                    [kNotificationCenter postNotificationName:kNotifPresentLogin object:nil];
                    [[UserManager sharedManager] logout];
                    return ;
                }
            }
            if (failureHandler) {
                failureHandler(error);
            }
        }
        
    }];
}

-(void)logout {
    [UserManager sharedManager].user = nil;
//    [[SocketManager sharedSocket] disconnectedSocket];
    [Common clearAsynchronousWithKey:kSavedUser];
    [Common clearAsynchronousWithKey:kSaveToken];
}

#pragma mark - Lazy Load
- (instancetype)init {
    if (self = [super init]) {
        _user = [[PSUser alloc] init];
    }
    return self;
}
@end
