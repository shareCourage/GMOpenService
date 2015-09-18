//
//  UIColor+PHCategory.m
//  New_Simplify
//
//  Created by Kowloon on 15/9/17.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "UIColor+PHCategory.h"

@implementation UIColor (PHCategory)

+ (UIColor*)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue {
    
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaValue];
}

@end
