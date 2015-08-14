//
//  PHPlayAnnotation.h
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/5.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI/BMKAnnotation.h>

@interface PHPlayAnnotation : NSObject<BMKAnnotation>
///标注view中心坐标.
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;


@property (nonatomic, strong) NSString *iconName;

+ (instancetype)playAnnotation;
@end
