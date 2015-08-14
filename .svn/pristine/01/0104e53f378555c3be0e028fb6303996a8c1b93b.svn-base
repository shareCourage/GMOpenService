//
//  PHMeMapView.m
//  SimplifiedApp
//
//  Created by Kowloon on 15/4/30.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "PHMeMapView.h"
#import "PHDeviceInfo.h"
@interface PHMeMapView ()<BMKLocationServiceDelegate, UIAlertViewDelegate>
@property(nonatomic, strong)BMKLocationService *location;//定位服务
@property(nonatomic, strong)BMKUserLocation *userLocation;//当前定位到的位置
@property(nonatomic, weak)UIButton *mapTypeBtn;//地图样式
@property(nonatomic, weak)UIButton *trafficBtn;//是否展示地图交通情况
@property(nonatomic, weak)UIButton *locationOrCarBtn;//用来切换地图的中心点
@property(nonatomic, assign, getter = isMapTypeStandard)BOOL mapTypeStandard;//默认使用标准地图

@end

@implementation PHMeMapView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self bmkMapLocationServiceInstantiation];//先开启定位服务
        [self addMaptypeAndTrafficAndLocationButton];
    }
    return self;
}
//保证xib实例化能创建BMKMapView
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addMaptypeAndTrafficAndLocationButton];
        [self bmkMapLocationServiceInstantiation];//先开启定位服务
    }
    return self;
}
//在自身添加子控件Maptype,Traffic,Location
- (void)addMaptypeAndTrafficAndLocationButton
{
    UIButton *mapType  = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *traffic  = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *locationOrCar  = [UIButton buttonWithType:UIButtonTypeCustom];
    mapType.imageView.contentMode = UIViewContentModeScaleAspectFit;
    traffic.imageView.contentMode = UIViewContentModeScaleAspectFit;
    locationOrCar.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [mapType setBackgroundImage:[UIImage imageNamed:PH_ImageName_MapTypeBtn] forState:UIControlStateNormal];
    [traffic setBackgroundImage:[UIImage imageNamed:PH_ImageName_TrafficBtn] forState:UIControlStateNormal];
    [locationOrCar setImage:[UIImage imageNamed:PH_ImageName_LocationBtn] forState:UIControlStateNormal];
    [locationOrCar setImage:[UIImage imageNamed:PH_ImageName_CarBtn] forState:UIControlStateSelected];
    
    [mapType addTarget:self action:@selector(mapTypeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [traffic addTarget:self action:@selector(trafficBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [locationOrCar addTarget:self action:@selector(locationOrCarBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:mapType];
//    [self addSubview:traffic];
    [self addSubview:locationOrCar];
    self.mapTypeBtn = mapType;
    self.trafficBtn = traffic;
    self.locationOrCarBtn = locationOrCar;
}
//bmkMapLocationService的实例化和基本的设置
- (void)bmkMapLocationServiceInstantiation
{
    BMKLocationService *location = [[BMKLocationService alloc] init];
    location.delegate = self;
    //设置定位精确度，默认：kCLLocationAccuracyBest
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    //指定最小距离更新(米)，默认：kCLDistanceFilterNone
    [BMKLocationService setLocationDistanceFilter:100.f];
    [location startUserLocationService];//开始自己位置的定位
    self.location = location;
}
- (void)mapTypeBtnClick{
    self.mapTypeStandard = !self.isMapTypeStandard;
    self.bmkMapView.mapType = self.mapTypeStandard ? BMKMapTypeStandard : BMKMapTypeSatellite;
}
- (void)trafficBtnClick{
    self.bmkMapView.trafficEnabled = !self.bmkMapView.isTrafficEnabled;
}
- (void)locationOrCarBtnClick{
    self.locationOrCarBtn.selected = !self.locationOrCarBtn.selected;
    CLLocationCoordinate2D coorOfDevice = CLLocationCoordinate2DMake([self.device.lat doubleValue], [self.device.lng doubleValue]);
    CLLocationCoordinate2D coor = self.locationOrCarBtn.selected ? self.userLocation.location.coordinate : (coorOfDevice.latitude == 0 ? self.userLocation.location.coordinate : coorOfDevice);//后面的CLLocationCoordinate2D也要根据当前coorOfDevice是否有值来确定
    [self.bmkMapView setCenterCoordinate:coor animated:YES];
    self.bmkMapView.zoomLevel = self.currentZoomLevel == 0 ? 13 : self.currentZoomLevel;
    
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    [self setMaptypeAndTrafficAndLocationFrameUsingAutoLayout];
}
//使用autoLayout设置Maptype,Traffic,Location的frame
- (void)setMaptypeAndTrafficAndLocationFrameUsingAutoLayout
{
    PH_WS(ws);
    CGFloat padding = 10.0f;
    CGFloat heightBtn = 40.0f;
    CGFloat widthBtn = heightBtn;
    [self.mapTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(heightBtn));//高度
        make.width.mas_equalTo(@(widthBtn));//宽度
        make.right.equalTo(ws.mas_right).with.offset(-padding);//离父控件右边10
        make.top.equalTo(ws.mas_top).with.offset(2 * padding);//离父控件顶部20
    }];
    
    CGFloat trafficOffset = 2 * padding + heightBtn + padding;
#if 0
    [self.trafficBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(heightBtn));//高度
        make.width.mas_equalTo(@(widthBtn));//宽度
        make.right.equalTo(ws.mas_right).with.offset(-padding);//离父控件右边10
        make.top.equalTo(ws.mas_top).with.offset(trafficOffset);//离父控件2 * padding + heightBtn + padding
    }];
#endif
//    CGFloat locationOrCarOffset = 2 * padding + 2 * heightBtn + 2 * padding;
    [self.locationOrCarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(heightBtn));//高度
        make.width.mas_equalTo(@(widthBtn));//宽度
        make.right.equalTo(ws.mas_right).with.offset(-padding);//离父控件右边10
        make.top.equalTo(ws.mas_top).with.offset(trafficOffset);//离父控件底部20
    }];
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        self.bmkMapView.mapType = BMKMapTypeSatellite;
    }
}

#pragma mark - BMKLocationServiceDelegate
/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    self.userLocation = userLocation;
    [self.bmkMapView updateLocationData:userLocation];
}

@end














