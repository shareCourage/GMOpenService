//
//  GMLoginManager.m
//  GMOpenSDK
//
//  Created by Kowloon on 15/6/17.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "GMLoginManager.h"
#import "GMNetworkManager.h"
#import "NSString+PHCategory.h"
#import "GMConstant.h"
#import "GMTool.h"
@implementation GMLoginManager

- (void)loginWithDevid:(NSString *)devid signature:(NSString *)signature successBlock:(GMOptionDict)success failureBlock:(GMOptionError)failure
{
    NSString *appid     = [[NSUserDefaults standardUserDefaults] objectForKey:GM_KeyOfAppid];
    NSString *channelid = [[NSUserDefaults standardUserDefaults] objectForKey:GM_KeyOfChannelid];
    NSString *mapType   = [GMTool mapType:self.mapType];
    if (appid.length == 0 || devid.length == 0) return;
    GMNetworkManager *manager = [GMNetworkManager manager];
    [manager loginWithAppID:appid
                   deviceID:devid
                  signature:signature
                  channelid:channelid
                    mapType:mapType
                  withBlock:success
           withFailureBlock:failure];
}
- (void)loginWithDevid:(NSString *)devid completionBlock:(GMOptionSuccess)success failureBlock:(GMOptionError)failure
{
    [self loginWithDevid:devid signature:nil completionBlock:success failureBlock:failure];
}
- (void)loginWithDevid:(NSString *)devid signature:(NSString *)signature completionBlock:(GMOptionSuccess)success failureBlock:(GMOptionError)failure
{
    if (signature.length == 0) {
        signature = [[NSString stringWithFormat:@"%.f",[NSDate date].timeIntervalSince1970] MD5];
    }
    [self loginWithDevid:devid signature:signature successBlock:^(NSDictionary *dict) {
//        NSLog(@"login->%@",dict);
        NSString *msg = dict[GM_Argument_msg];
        BOOL value = NO;
        msg.length == 0 ? (value = YES) : (value = NO);
        if (success) success(value);
    } failureBlock:failure];
}

- (void)logoutWithDevid:(NSString *)devid completionBlock:(GMOptionSuccess)success failureBlock:(GMOptionError)failure
{
    NSString *appid     = [[NSUserDefaults standardUserDefaults] objectForKey:GM_KeyOfAppid];
    NSString *channelid = [[NSUserDefaults standardUserDefaults] objectForKey:GM_KeyOfChannelid];
    if (appid.length == 0 || devid.length == 0) return;
    GMNetworkManager *manager = [GMNetworkManager manager];
    [manager logoutWithAppID:appid
                    deviceID:devid
                   channelid:channelid
                   withBlock:^(NSDictionary *dict) {
                       NSString *msg = dict[GM_Argument_msg];
                       BOOL value = NO;
                       msg.length == 0 ? (value = YES) : (value = NO);
                       if (success) success(value);
    } withFailureBlock:failure];
}
@end



