//
//  PHBaiduMapView.m
//  SimplifiedApp
//
//  Created by Kowloon on 15/4/29.
//  Copyright (c) 2015年 Goome. All rights reserved.
//


#import "PHBaiduMapView.h"
#import "PHDeviceInfo.h"
#import "PHAnnotation.h"
#import "GMOpenKit.h"
#import "AppDelegate.h"
@interface PHBaiduMapView ()
@property(nonatomic, weak)UIButton *minusBtn;//缩小地图
@property(nonatomic, weak)UIButton *plusBtn;//放大地图

@end

@implementation PHBaiduMapView

- (void)setDevice:(id<GMDevice>)device
{
    _device = device;
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id anno in self.bmkMapView.annotations) {
            if ([anno isKindOfClass:[PHAnnotation class]]) {
                [self.bmkMapView removeAnnotation:anno];
            }
        }
        [self insertAnnotationWithDevice:device];
    });
}

#pragma mark - init Method
//保证代码实例化能创建BMKMapView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self bmkMapViewInstantiation];
        [self addMinusAndPlusButton];
    }
    return self;
}
//保证xib实例化能创建BMKMapView
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self bmkMapViewInstantiation];
        [self addMinusAndPlusButton];
    }
    return self;
}
- (void)awakeFromNib
{
//    PHLog(@"awakeFromNib");
}


#pragma mark - 添加子控件
//bmkMapView的实例化和基本的设置
- (void)bmkMapViewInstantiation
{
    BMKMapView *mapView = [[BMKMapView alloc] init];
    mapView.showMapScaleBar = YES;
    mapView.zoomLevel = 15.0f;
    mapView.showsUserLocation = NO;
    mapView.mapType = BMKMapTypeStandard;
    mapView.showsUserLocation = YES;
    mapView.showMapScaleBar = YES;
    mapView.userTrackingMode = BMKUserTrackingModeFollow;
    [self addSubview:mapView];
    self.bmkMapView = mapView;
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    if (delegate.locationCoord.latitude != 0 && delegate.locationCoord.longitude != 0 ) {
        [self.bmkMapView setCenterCoordinate:delegate.locationCoord];
    }
}

//在自身添加子控件Minus 和 Plus
- (void)addMinusAndPlusButton
{
    UIButton *minus = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *plus  = [UIButton buttonWithType:UIButtonTypeCustom];
    [minus setBackgroundImage:[UIImage imageNamed:PH_ImageName_MinusBtn] forState:UIControlStateNormal];
    [plus  setBackgroundImage:[UIImage imageNamed:PH_ImageName_PlusBtn] forState:UIControlStateNormal];
    [minus addTarget:self action:@selector(minusBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [plus  addTarget:self action:@selector(plusBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:plus];
    [self addSubview:minus];
    self.minusBtn = minus;
    self.plusBtn = plus;
}


#pragma mark - Button的响应方法
- (void)minusBtnClick{
    [self.bmkMapView zoomOut];
}
- (void)plusBtnClick{
    [self.bmkMapView zoomIn];
}

#pragma mark - 使用autoLayout设定子控件的frame
//self添加子控件的时候，设置frame
- (void)didMoveToSuperview
{
//    PHLog(@"didMoveToSuperview");
    [self setBmkMapViewFrameUsingAutoLayout];
    [self setMinusAndPlusFrameUsingAutoLayout];
}
//使用autoLayout设置BmkMapView的frame
- (void)setBmkMapViewFrameUsingAutoLayout
{
    PH_WS(ws);
    [_bmkMapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws).with.offset(0);
        make.left.equalTo(ws).with.offset(0);
        make.bottom.equalTo(ws).with.offset(0);
        make.right.equalTo(ws).with.offset(0);
    }];
}
//使用autoLayout设置两个Minus 和 Plus的frame
- (void)setMinusAndPlusFrameUsingAutoLayout
{
    PH_WS(ws);
    CGFloat padding = 10.0f;
    CGFloat bottom = 15.0f;
    CGFloat heightBtn = 40.0f;
    CGFloat widthBtn = 35.0f;
    [self.minusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(heightBtn));//高度
        make.width.mas_equalTo(@(widthBtn));//宽度
        make.right.equalTo(ws.mas_right).with.offset(-padding);//离父控件右边10
        make.bottom.equalTo(ws.mas_bottom).with.offset(-bottom);//离父控件底部10
    }];
    
    [self.plusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(ws.minusBtn);
        make.width.equalTo(ws.minusBtn);
        make.right.equalTo(ws.mas_right).with.offset(-padding);
        make.bottom.equalTo(ws.mas_bottom).with.offset(-(bottom + heightBtn));
    }];
}


#pragma mark - PHBaiduMapView->Method
//在地图上插上大头针
- (void)insertAnnotationWithDevice:(id<GMDevice>)device
{
    PHAnnotation *anno = [[PHAnnotation alloc] init];
    anno.title = device.devid;
    CLLocationCoordinate2D coor;
    coor.latitude = [device.lat doubleValue];
    coor.longitude = [device.lng doubleValue];
    anno.coordinate = coor;
    [_bmkMapView addAnnotation:anno];
//    [self.bmkMapView setCenterCoordinate:coor animated:YES];
}
//删除地图上所有的大头针
- (void)removeAllAnnotationOnTheMap
{
    [_bmkMapView removeAnnotations:_bmkMapView.annotations];
}

#pragma mark - 自定义模拟给这个view两个周期WillAppear WillDisappear
- (void)baiduMapViewWillAppear
{
    [_bmkMapView viewWillAppear];
    _bmkMapView.delegate = self;
}
- (void)baiduMapViewWillDisappear
{
    [_bmkMapView viewWillDisappear];
    _bmkMapView.delegate = nil;
    
}

#pragma mark - BMKMapViewDelegate
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    self.currentZoomLevel = self.bmkMapView.zoomLevel;
    
}




@end










