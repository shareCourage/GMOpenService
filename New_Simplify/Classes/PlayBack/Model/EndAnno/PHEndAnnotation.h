//
//  PHEndAnnotation.h
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/5.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI/BMKAnnotation.h>

@interface PHEndAnnotation : NSObject<BMKAnnotation>
{
    NSString *_iconName;
}
/// 要显示的标题
@property (nonatomic, strong) NSString *title;
/// 要显示的副标题
@property (nonatomic, strong) NSString *subtitle;
///标注view中心坐标.
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, strong) NSString *iconName;


+ (instancetype)endAnnotation;

@end
