//
//  PSTabBarViewController.m
//  LeaderSystems
//
//  Created by 刘艳凯 on 2017/6/5.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#import "PSTabBarViewController.h"
#import "HomePageViewController.h"
#import "SettingViewController.h"
#import "LoginViewController.h"

@interface PSTabBarViewController ()

@end

@implementation PSTabBarViewController
#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    HomePageViewController *homePageVc = [HomePageViewController new];
    homePageVc.title = @"主页";
    homePageVc.tabBarItem.image = [[UIImage imageNamed:@"homepage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homePageVc.tabBarItem.selectedImage = [[UIImage imageNamed:@"homepage-1"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UINavigationController *homePageNav = [[UINavigationController alloc] initWithRootViewController:homePageVc];
//    [self addChildViewController:homePageNav];
    
    SettingViewController *settingVc = [SettingViewController new];
    settingVc.title = @"设置";
    settingVc.tabBarItem.image = [[UIImage imageNamed:@"personal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    settingVc.tabBarItem.selectedImage = [[UIImage imageNamed:@"personal-1"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UINavigationController *settingNav = [[UINavigationController alloc] initWithRootViewController:settingVc];
//    [self addChildViewController:settingNav];
    
    self.viewControllers = [NSArray arrayWithObjects:homePageNav,settingNav, nil];
    
    [self quickLogin];
    
    [kNotificationCenter addObserver:self selector:@selector(notifPresentLogin:) name:kNotifPresentLogin object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITabBarController Delegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController NS_AVAILABLE_IOS(3_0);
{
    if (![[UserManager sharedManager] isLogin] && [self.viewControllers indexOfObject:viewController] >= 1)
    {
        [self notifPresentLogin:nil];
        return NO;
    }
    
    return YES;
}


//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
//    if (![[UserManager sharedManager] isLogin] && [self.viewControllers indexOfObject:viewController] >= 1)
//    {
//        [self notifPresentLogin:nil];
//    }
//}
#pragma mark - Method
//自动登录
- (void)quickLogin {
    //自动登录获取用户信息
    NSString *userToken = [Common getAsynchronousWithKey:kSaveToken];
    if (userToken) {
        [UserManager QuickLoginWithToken:userToken andSuccess:^(PSUser *user, NSError *error) {
            [UserManager sharedManager].user = user;
            [UserManager sharedManager].user.account_token = userToken;
            //            [[LocationManager sharedManager] startUserLocation];
            //            [kNotificationCenter postNotificationName:kReloadInfo object:nil];
        } andFailure:^(NSError *error) {
//            [self notifPresentLogin:nil];
        }];
    }
}

-(void)notifPresentLogin:(NSNotification *)notif
{
    UINavigationController *selectNavVC = (UINavigationController *)self.selectedViewController;
    if (selectNavVC.presentedViewController) {
        selectNavVC = (UINavigationController *)selectNavVC.presentedViewController;
    }
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
//    [Common setUpNavBar:navVC.navigationBar];
    [selectNavVC presentViewController:navVC animated:YES completion:nil];
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
