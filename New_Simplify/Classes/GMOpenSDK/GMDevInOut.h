//
//  GMDevInOut.h
//  New_Simplify
//
//  Created by Kowloon on 15/7/20.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GMDevInOut : NSObject<NSCoding>

@property(nonatomic, copy)NSString *devid;
@property(nonatomic, copy)NSString *dev_in;
@property(nonatomic, copy)NSString *dev_out;

@end
