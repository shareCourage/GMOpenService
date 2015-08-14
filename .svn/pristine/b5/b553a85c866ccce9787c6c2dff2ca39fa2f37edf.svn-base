//
//  UIImage+PHCategory.m
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/18.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "UIImage+PHCategory.h"

@implementation UIImage (PHCategory)
+ (UIImage *)resizedImageWithName:(NSString *)name
{
    UIImage *image = [self imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}
@end
