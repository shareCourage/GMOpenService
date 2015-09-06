//
//  PHFenceModifyMapController.m
//  New_Simplify
//
//  Created by Kowloon on 15/9/2.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "PHFenceModifyMapController.h"
#import "PHFenceMapView.h"
#import "PHFenceMap.h"
#import "PHFenceOtherArgumentController.h"

@interface PHFenceModifyMapController ()< PHFenceMapViewDelegate >

@property (weak, nonatomic) IBOutlet UIView *CircleDisplayView;
@property (weak, nonatomic) IBOutlet UISlider *circleSlider;
@property (weak, nonatomic) IBOutlet UILabel *circleRadiusL;
- (IBAction)circleSliderAction:(UISlider *)sender;

@property (weak, nonatomic) IBOutlet PHFenceMapView *fenceMapView;

@property (nonatomic, strong) PHFenceMap *fenceMapModel;

@property(nonatomic, strong)id radiusKVO;
@property(nonatomic, strong)id coordinateKVO;

@end

@implementation PHFenceModifyMapController
- (PHFenceMap *)fenceMapModel
{
    if (_fenceMapModel == nil) {
        _fenceMapModel = [PHFenceMap fenceMap];
        if ([self.fenceInfo.shape isEqualToString:@"1"]) {//圆形
            NSArray *array = [NSArray seprateString:self.fenceInfo.area characterSet:@","];
            NSString *lat = [array firstObject];
            NSString *lng = array[1];
            NSString *radiusStr = [array lastObject];
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([lat doubleValue], [lng doubleValue]);
            double radius = [radiusStr doubleValue];
            _fenceMapModel.radius = radius;
            _fenceMapModel.coordinate = coordinate;
        }
        else if ([self.fenceInfo.shape isEqualToString:@"2"]) {//多边形
            NSArray *array = [NSArray seprateString:self.fenceInfo.area characterSet:@";"];
            _fenceMapModel.coords = [array copy];
        }
        _fenceMapModel.enable = [self.fenceInfo.enable boolValue];

    }
    
    return _fenceMapModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.fenceInfo.name.length != 0 ? self.fenceInfo.name : self.fenceInfo.fenceid;
    self.fenceMapView.delegate = self;
    
    self.radiusKVO = [PHKeyValueObserver observeObject:self.fenceMapModel keyPath:@"radius" target:self selector:@selector(radiusFromFenceMapKVO)];
    self.coordinateKVO = [PHKeyValueObserver observeObject:self.fenceMapModel keyPath:@"coordinate" target:self selector:@selector(coordinateFromFenceMapKVO)];
    self.fenceMapView.fenceMap = self.fenceMapModel;

    [self barButtonItemImplementation];
    [self circleDisplayViewImplementation];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.fenceMapView baiduMapViewWillAppear];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.fenceMapView baiduMapViewWillDisappear];
}

- (void)circleDisplayViewImplementation {
    self.CircleDisplayView.backgroundColor = [UIColor clearColor];
    
    NSString *radius = [[NSArray seprateString:self.fenceInfo.area characterSet:@","] lastObject];
    self.circleRadiusL.text = [NSString stringWithFormat:@"半径:%@米", radius];
    self.circleSlider.minimumValue = 200.f;
    self.circleSlider.maximumValue = 10000.f;
    self.circleSlider.value = [radius floatValue];
    if ([self.fenceInfo.shape isEqualToString:@"2"]) {
        self.CircleDisplayView.hidden = YES;
    }
}

/**
 *  导航栏UIBarButtonItem的放置
 */
- (void)barButtonItemImplementation
{
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(doneClick)];
    UIBarButtonItem *modifyItem = [[UIBarButtonItem alloc] initWithTitle:@"其它" style:UIBarButtonItemStylePlain target:self action:@selector(otherArgumentClick)];
    self.navigationItem.rightBarButtonItems = @[modifyItem, doneItem];
}

- (void)doneClick
{

}
- (void)otherArgumentClick
{
    PHFenceOtherArgumentController *otherArgu = [[PHFenceOtherArgumentController alloc] init];
    otherArgu.fenceInfo = self.fenceInfo;
    [self.navigationController pushViewController:otherArgu animated:YES];
}
- (IBAction)circleSliderAction:(UISlider *)sender {
    double value = sender.value;
    self.fenceMapModel.radius = value;
    self.circleRadiusL.text = [NSString stringWithFormat:@"半径:%.f米", value];
}

- (void)radiusFromFenceMapKVO
{
    self.fenceMapView.fenceMap = self.fenceMapModel;
}
- (void)coordinateFromFenceMapKVO
{
    self.fenceMapView.fenceMap = self.fenceMapModel;
}

#pragma mark - PHFenceMapViewDelegate
- (void)fenceMapViewRegionDidChanged:(PHFenceMapView *)fenceMapView
{
    PHLog(@"fenceMapViewRegionDidChanged");
}

- (void)fenceMapView:(PHFenceMapView *)fenceMapView onLongClick:(CLLocationCoordinate2D)coordinate
{
    PHLog(@"coordinate:lat->%.6f, lng->%.6f, time->%@",coordinate.latitude, coordinate.longitude,PH_CurrentTime);
    self.fenceMapModel.coordinate = coordinate;
}

@end




