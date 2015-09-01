//
//  PHMeMapView.h
//  SimplifiedApp
//
//  Created by Kowloon on 15/4/30.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "PHBaiduMapView.h"

@interface PHMeMapView : PHBaiduMapView

@property (nonatomic, assign, getter = isLocationModel, readonly) BOOL locationModel;

@property (nonatomic, strong)UIColor *polylineColor;

@property (nonatomic, assign)CGFloat polylineWidth;
/**
 *  MapView添加Overlay
 */
- (void)configurePolylineWithStartDevice:(id<GMDevice>)start end:(id<GMDevice>)end;

- (void)removeAllOfPolyline;

@end
