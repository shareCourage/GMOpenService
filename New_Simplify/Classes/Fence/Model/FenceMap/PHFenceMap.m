//
//  PHFenceMap.m
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/9.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "PHFenceMap.h"

@implementation PHFenceMap

- (instancetype)init {
    self = [super init];
    if (self) {
        self.radius = 200.f;
    }
    return self;
}

+ (instancetype)fenceMap
{
    return [[self alloc] init];
}

@end
