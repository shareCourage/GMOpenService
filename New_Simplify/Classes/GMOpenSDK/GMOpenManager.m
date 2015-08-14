//
//  GMOpenManager.m
//  GMOpenSDK
//
//  Created by Kowloon on 15/6/16.
//  Copyright (c) 2015年 Goome. All rights reserved.
//
#import "GMConstant.h"
#import "GMOpenManager.h"

@interface GMOpenManager ()<NSURLConnectionDataDelegate>

@property(nonatomic, assign)id<GMOpenManagerDelegate>delegate;
@property(nonatomic, copy)GMOpenManagerBlock managerBlock;

@end

@implementation GMOpenManager

- (BOOL)validateWithKey:(NSString *)appidKey delegate:(id<GMOpenManagerDelegate>)delegate
{
    if (!appidKey) return NO;
    [[NSUserDefaults standardUserDefaults] setObject:appidKey forKey:GM_KeyOfAppid];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (delegate) self.delegate = delegate;
    NSString *urlStr = [GM_UniqueId_URL stringByAppendingString:appidKey];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    return YES;
}

- (BOOL)validateWithKey:(NSString *)appidKey completionBlock:(GMOpenManagerBlock)block
{
    if (block) self.managerBlock = block;
    return [self validateWithKey:appidKey delegate:nil];
}


#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSString *str = dict[GM_Argument_msg];
    if (str.length > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:GM_KeyOfAppid];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if ([self.delegate respondsToSelector:@selector(openManager:getPermissionState:)]) {
            [self.delegate openManager:self getPermissionState:GMOpenPermissionStatusOfFailure];
        }
        if (self.managerBlock) self.managerBlock(GMOpenPermissionStatusOfFailure);
    }
    else if (str.length == 0){
        if ([self.delegate respondsToSelector:@selector(openManager:getPermissionState:)]) {
            [self.delegate openManager:self getPermissionState:GMOpenPermissionStatusOfSuccess];
        }
        if (self.managerBlock) self.managerBlock(GMOpenPermissionStatusOfSuccess);
    }
}



@end


















