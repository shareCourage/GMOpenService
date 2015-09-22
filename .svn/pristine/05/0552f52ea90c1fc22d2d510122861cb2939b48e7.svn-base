//
//  PHFenceMapView.h
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/8.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "PHBaiduMapView.h"
@class PHFenceMap;
@class PHFenceMapView;
@protocol PHFenceMapViewDelegate <NSObject>

@optional
- (void)fenceMapViewRegionDidChanged:(PHFenceMapView *)fenceMapView;
- (void)fenceMapView:(PHFenceMapView *)fenceMapView onLongClick:(CLLocationCoordinate2D)coordinate;

@end

@interface PHFenceMapView : PHBaiduMapView

@property(nonatomic, assign)id<PHFenceMapViewDelegate>delegate;

@property(nonatomic, strong)PHFenceMap *fenceMap;


/**
 *  计算屏幕两段实际距离
 *
 *  @return double
 */
- (CLLocationDistance)distanceFromCoordA:(CLLocationCoordinate2D)coordA toCoordB:(CLLocationCoordinate2D)coordB
;

/**
 *  移除地图上所有的标记
 */
- (void)removeMapViewOverlays;

@end







