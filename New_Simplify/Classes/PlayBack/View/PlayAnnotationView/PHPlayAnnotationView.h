//
//  PHPlayAnnotationView.h
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/5.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import <BaiduMapAPI/BMapKit.h>

@interface PHPlayAnnotationView : BMKAnnotationView

+ (instancetype)annotationViewWithMapView:(BMKMapView *)mapView;

@end
