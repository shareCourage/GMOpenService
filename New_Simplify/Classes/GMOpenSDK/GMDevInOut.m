//
//  GMDevInOut.m
//  New_Simplify
//
//  Created by Kowloon on 15/7/20.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "GMDevInOut.h"
#import <objc/runtime.h>

@implementation GMDevInOut

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        unsigned int outCount, i;
        Ivar *ivars = class_copyIvarList([self class], &outCount);
        for (i = 0; i < outCount; i++) {
            Ivar property = ivars[i];
            NSString *keyName = [NSString stringWithCString:ivar_getName(property) encoding:NSUTF8StringEncoding];
            id value = [aDecoder decodeObjectForKey:keyName];
            [self setValue:value forKey:keyName];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    unsigned int outCount, i;
    Ivar *ivars = class_copyIvarList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        Ivar property = ivars[i];
        NSString *keyName = [NSString stringWithCString:ivar_getName(property) encoding:NSUTF8StringEncoding];
        id value = [self valueForKey:keyName];
        [aCoder encodeObject:value forKey:keyName];
    }
}
@end
