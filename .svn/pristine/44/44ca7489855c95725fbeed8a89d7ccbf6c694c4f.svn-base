//
//  PHMeMapView.m
//  SimplifiedApp
//
//  Created by Kowloon on 15/4/30.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "PHMeMapView.h"
#import "PHDeviceInfo.h"
#import "PHAnnotation.h"
@interface PHMeMapView ()<BMKLocationServiceDelegate, UIAlertViewDelegate>
@property(nonatomic, strong)BMKLocationService *locationService;//定位服务
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
    [locationOrCar addTarget:self action:@selector(locationOrCarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:mapType];
//    [self addSubview:traffic];
    [self addSubview:locationOrCar];
    
    mapType.layer.cornerRadius = 10;
    locationOrCar.layer.cornerRadius = 10;
    mapType.layer.masksToBounds = YES;
    locationOrCar.layer.masksToBounds = YES;
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
    self.locationService = location;
}
- (void)mapTypeBtnClick{
    self.mapTypeStandard = !self.isMapTypeStandard;
    self.bmkMapView.mapType = self.mapTypeStandard ? BMKMapTypeStandard : BMKMapTypeSatellite;
}
- (void)trafficBtnClick{
    self.bmkMapView.trafficEnabled = !self.bmkMapView.isTrafficEnabled;
}
- (void)locationOrCarBtnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    CLLocationCoordinate2D coorOfDevice = CLLocationCoordinate2DMake([self.device.lat doubleValue], [self.device.lng doubleValue]);
    CLLocationCoordinate2D coorUserLocation = self.userLocation.location.coordinate;
    
    if (sender.selected) {
        if (self.userLocation.location) {//如果定位到了坐标点，则使用定位到的坐标；反之，没有定位到，则用设备的坐标
            [self.bmkMapView setCenterCoordinate:coorUserLocation animated:YES];
            _locationModel = YES;//在这个情况下才是定位模式，地图一直刷新定位的点
        }
        else {
            [self.bmkMapView setCenterCoordinate:coorOfDevice animated:YES];
            sender.selected = NO;//为了不让button的图片发生改变
            _locationModel = NO;
        }
    }
    else {
        [self.bmkMapView setCenterCoordinate:coorOfDevice animated:YES];
        _locationModel = NO;
    }
    self.bmkMapView.zoomLevel = self.currentZoomLevel == 0 ? 13 : self.currentZoomLevel;

}

- (void)insertAnnotationWithDevice:(id<GMDevice>)device
{
    [super insertAnnotationWithDevice:device];
    if (!self.isLocationModel) {
        CLLocationCoordinate2D coord;
        coord.latitude = [device.lat doubleValue];
        coord.longitude = [device.lng doubleValue];
        [self.bmkMapView setCenterCoordinate:coord animated:YES];
    }
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
- (void)removeAllOfPolyline
{
    [self.bmkMapView removeOverlays:self.bmkMapView.overlays];
}
/**
 *  MapView添加Overlay
 */
- (void)configurePolylineWithStartDevice:(id<GMDevice>)start end:(id<GMDevice>)end
{
    CLLocationCoordinate2D startCoord = [self coordinateFromDevice:start];
    CLLocationCoordinate2D endCoord = [self coordinateFromDevice:end];
    if (startCoord.latitude == endCoord.latitude && startCoord.longitude == endCoord.longitude) return;
    BMKMapPoint *mapPoints = malloc(sizeof(BMKMapPoint) * 2);
    mapPoints[0] = BMKMapPointForCoordinate(startCoord);
    mapPoints[1] = BMKMapPointForCoordinate(endCoord);
    BMKPolyline *polyline = [BMKPolyline polylineWithPoints:mapPoints count:2];
    free(mapPoints);//使用C在堆里面分配的一段内存，记得要释放
    [self.bmkMapView addOverlay:polyline];
}

- (CLLocationCoordinate2D)coordinateFromDevice:(id<GMDevice>)device
{
    double lat = [device.lat doubleValue];
    double lng = [device.lng doubleValue];
    return CLLocationCoordinate2DMake(lat, lng);
}

#pragma mark - BMKMapViewDelegate
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView *polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor = self.polylineColor ? self.polylineColor : [UIColor redColor];
        polylineView.lineWidth = self.polylineWidth == 0 ? 5.0 : self.polylineWidth;
        return polylineView;
    } else {
        return nil;
    }
}
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[PHAnnotation class]]) {
        static NSString *ID = @"meLocation";
        // 从缓存池中取出可以循环利用的大头针view
        BMKAnnotationView *annoView = [mapView dequeueReusableAnnotationViewWithIdentifier:ID];
        if (annoView == nil) {
            annoView = [[BMKAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:ID];
        }
        annoView.image = [UIImage imageNamed:@"history_car"];
        annoView.canShowCallout = YES;
        return annoView;
    }
    return nil;
}
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view {
    PHLog(@"%@",view.annotation);
}
@end














