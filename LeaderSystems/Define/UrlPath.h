//
//  UrlPath.h
//  LeaderSystem
//
//  Created by 刘艳凯 on 2017/6/1.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#ifndef UrlPath_h
#define UrlPath_h

//线上服务器地址
#define HostAdress @"http://www.yituinfo.cn/Patrolling/interface/leader/"
//本地服务器地址
//#define HostAdress @"http://192.168.100.29/Patrolling/interface/leader/"

//图片地址
#define picUrl @"http://www.yituinfo.cn/Patrolling"
//#define picUrl @"http://192.168.100.29/Patrolling"

//socket通信地址
#define socketAdress @"119.23.251.169"
//本地服务器socket通信地址
//#define socketAdress @"192.168.100.29"
#define socketPort 9000
#define helpSocketPort 9001
//#define helpSocketPoet 8889
//查看错误编码
//#define allErrorAdress @"http://www.yituinfo.cn/Patrolling/error.do"

#define ConvertUrl(relativeUrl) [NSString stringWithFormat:@"%@%@", HostAdress, relativeUrl]

//接口地址
#define kUrl_Register                   ConvertUrl(@"update/leaderRegister.do")                                //用户注册
#define kUrl_Retrieve                   ConvertUrl(@"update/leaderForgotPassword.do")                         //找回密码
#define kUrl_Login                       ConvertUrl(@"query/leaderLogin.do")                                     //用户登录
#define kUrl_QuickLogin                 ConvertUrl(@"query/leaderAutomaticLogin.do")                         //快速登录
#define kUrl_GetAttendanceRecord      ConvertUrl(@"query/queryAttendanceRecord.do")                        //查看考勤
#define kUrl_GetAllStaffTask           ConvertUrl(@"query/leaderQueryStaff.do")                              //获取所有工作人员信息
#define kUrl_AttendanceForMonth       ConvertUrl(@"query/leaderQueryClock.do")                              //获取员工当月签到记录
#define kUrl_GetWorkingStaff           ConvertUrl(@"query/queryStaffTask.do")                                //获取工作的员工列表
#define kUrl_GetStaffInfo               ConvertUrl(@"query/queryStaffTaskInfo.do")                           //获取工作人员工作路线
#define kUrl_HelpInfoList              ConvertUrl(@"query/queryEmergencyCalling.do")                       //一键求助消息列表
#define kUrl_HelpInfoDetail            ConvertUrl(@"query/getEmergencyCalling.do")                          //一键求助详细信息
#define kUrl_UnusualList                ConvertUrl(@"query/queryAllNowLocationds.do")                       //安保异常列表
#define kUrl_UnusualDetail             ConvertUrl(@"query/nlidQueryNowLocationds.do")                     //异常详细信息
#define kUrl_Retroactive                ConvertUrl(@"query/leaderClocFill.do")                                //领导补签
#define kUrl_ClockInfo                   ConvertUrl(@"query/leaderQueryClockInfo.do")                        //获取员工签到详情
#define kUrl_DetailCheckInfo           ConvertUrl(@"query/getStaffTaskInfo.do")                            //获取员工考勤任务详情
#define kUrl_AcceptHelp                  ConvertUrl(@"update/acceptEmergencyCalling.do")                    //处理一键求助
#define kUrl_OnlineStaff                ConvertUrl(@"query/getOnLineStaff.do")                               //获取在线工作人员
#define kUrl_UnusualOnlineStaff        ConvertUrl(@"query/nlidQueryOnLineStaff.do")                        //安保异常在线用户
#define kUrl_CompleteHelp               ConvertUrl(@"update/accomplishEmergencyCalling.do")               //一键求助处理完成
#define kUrl_AcceptUnusual              ConvertUrl(@"update/acceptNowLocationds.do")                       //处理异常信息
#define kUrl_CompleteUnusual           ConvertUrl(@"update/accomplishNowLocationds.do")                  //异常处理完成
#define kUrl_RetroactiveList           ConvertUrl(@"query/queryExamineApproveSignPaging.do")            //申请补签列表
#define kUrl_HandleRetroactive         ConvertUrl(@"update/approveSignApply.do")                           //处理补签信息
#endif /* UrlPath_h */





















