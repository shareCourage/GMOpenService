//
//  AppDelegate.h
//  New_Simplify
//
//  Created by Kowloon on 15/7/7.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic, strong)GMHistoryManager *hisM;//用这个来控制从服务器实时获取历史数据信息

/**
 *  把服务器近两个月时间的数据全部加载到本地
 */
- (void)loadHistoryDataToLocal;

@end

