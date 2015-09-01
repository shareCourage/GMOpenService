//
//  PHBaiduMapView.h
//  SimplifiedApp
//
//  Created by Kowloon on 15/4/29.
//  Copyright (c) 2015年 Goome. All rights reserved.
//
#define PH_ImageName_MinusBtn    @"map_minus"
#define PH_ImageName_PlusBtn     @"map_plus"
#define PH_ImageName_CarBtn      @"home_car_highlighted"
#define PH_ImageName_LocationBtn @"home_current_highlighted"
#define PH_ImageName_MapTypeBtn  @"home_map_highlighted"
#define PH_ImageName_TrafficBtn  @"signal_lamp_open"

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>
#import <Masonry/Masonry.h>


@interface PHBaiduMapView : UIView <BMKMapViewDelegate>

@property(nonatomic, weak)BMKMapView *bmkMapView;//地图
@property(nonatomic, assign)float currentZoomLevel;//地图当前的zoomlevel

@property(nonatomic, strong)id<GMDevice>device;


/**
 *  baiduMapView模拟的WillAppear周期，为BMKMapView的周期做准备
 */
- (void)baiduMapViewWillAppear;
/**
 *  baiduMapView模拟的WillDisappear周期，为BMKMapView的周期做准备
 */
- (void)baiduMapViewWillDisappear;

- (void)insertAnnotationWithDevice:(id<GMDevice>)device;

@end





