//
//  PHPlayAnnotationView.m
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/5.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "PHPlayAnnotationView.h"
#import "PHPlayAnnotation.h"
@implementation PHPlayAnnotationView

+ (instancetype)annotationViewWithMapView:(BMKMapView *)mapView
{
    static NSString *ID = @"playback";
    PHPlayAnnotationView *annoView = (PHPlayAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (annoView == nil) {
        annoView = [[PHPlayAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:ID];
    }
    return annoView;
}

- (void)setAnnotation:(id<BMKAnnotation>)annotation
{
    [super setAnnotation:annotation];
    PHPlayAnnotation *play = (PHPlayAnnotation *)annotation;
    UIImage *image = [UIImage imageNamed:play.iconName];
    self.image = image;
}

@end






