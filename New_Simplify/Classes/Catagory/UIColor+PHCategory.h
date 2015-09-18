//
//  UIColor+PHCategory.h
//  New_Simplify
//
//  Created by Kowloon on 15/9/17.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (PHCategory)

/**
 *  16进制转换成相应的颜色
 *
 */
+ (UIColor*)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;
@end
