//
//  PHStartAnnotationView.m
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/5.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "PHStartAnnotationView.h"
#import "PHStartAnnotation.h"
@implementation PHStartAnnotationView

+ (instancetype)annotationViewWithMapView:(BMKMapView *)mapView
{
    static NSString *ID = @"start";
    // 从缓存池中取出可以循环利用的大头针view
    PHStartAnnotationView *annoView = (PHStartAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (annoView == nil) {
        annoView = [[PHStartAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:ID];
    }
    return annoView;
}

- (void)setAnnotation:(id<BMKAnnotation>)annotation
{
    [super setAnnotation:annotation];
    PHStartAnnotation *start = annotation;
    self.image = [UIImage imageNamed:start.iconName];
}


@end
