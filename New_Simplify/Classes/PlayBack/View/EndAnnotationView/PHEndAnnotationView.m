//
//  PHEndAnnotationView.m
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/5.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "PHEndAnnotationView.h"
#import "PHEndAnnotation.h"
@implementation PHEndAnnotationView

+ (instancetype)annotationViewWithMapView:(BMKMapView *)mapView
{
    static NSString *ID = @"end";
    PHEndAnnotationView *annoView = (PHEndAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (annoView == nil) {
        annoView = [[PHEndAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:ID];
    }
    return annoView;
}

- (void)setAnnotation:(id<BMKAnnotation>)annotation
{
    [super setAnnotation:annotation];
    PHEndAnnotation *end = (PHEndAnnotation *)annotation;
    UIImage *image = [UIImage imageNamed:end.iconName];
    self.image = image;
}

@end







