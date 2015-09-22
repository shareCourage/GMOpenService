//
//  PHFenceModifyMapController.m
//  New_Simplify
//
//  Created by Kowloon on 15/9/2.
//  Copyright (c) 2015年 Goome. All rights reserved.
//
static CGFloat      const  kDistanceBetweenAandBMaxValue       = 1.5;//两点之间的阈值
static NSUInteger   const  kNumberOfCoordinateMaxValue         = 35;//多边形围栏经纬度点最大的个数

#import "PHFenceModifyMapController.h"
#import "PHFenceMapView.h"
#import "PHFenceMap.h"
#import "PHFenceOtherArgumentController.h"
#import "PHFenceListController.h"
#import "PHDrawFenceView.h"
@interface PHFenceModifyMapController () <PHFenceMapViewDelegate, PHDrawFenceViewDelegate>
{
    BOOL _isCreateFence;
    BOOL _isCircleFence;
}
@property (weak, nonatomic) IBOutlet UIView *CircleDisplayView;
@property (weak, nonatomic) IBOutlet UISlider *circleSlider;
@property (weak, nonatomic) IBOutlet UILabel *circleRadiusL;
- (IBAction)circleSliderAction:(UISlider *)sender;

@property (weak, nonatomic) IBOutlet PHFenceMapView *fenceMapView;
@property (nonatomic, strong) PHFenceMap *fenceMapModel;

@property (weak, nonatomic) IBOutlet PHDrawFenceView *drawFenceView;
@property (nonatomic, strong) NSMutableArray *points;
@property (nonatomic, assign) CGPoint previousPoint;

@property(nonatomic, strong)id radiusKVO;
@property(nonatomic, strong)id coordinateKVO;

@property (nonatomic, strong) UIBarButtonItem *doneItem;
@property (nonatomic, strong) UIBarButtonItem *otherItem;
@property (nonatomic, strong) UIBarButtonItem *editItem;

@property (nonatomic, strong) GMFenceManager *fenceManager;

@end

@implementation PHFenceModifyMapController
- (void)dealloc
{
    free(self.fenceManager.coords);
    PHLog(@"%@->dealloc",NSStringFromClass([self class]));
}
- (GMFenceManager *)fenceManager {
    if (_fenceManager == nil) {
        _fenceManager = [GMFenceManager manager];
        _fenceManager.threshold = 3;
        _fenceManager.getIn = YES;
        _fenceManager.getOut = YES;
        _fenceManager.enable = YES;
        _fenceManager.fenceName = @"新建围栏";
    }
    return _fenceManager;
}
- (NSMutableArray *)points
{
    if (_points == nil) {
        _points = [NSMutableArray array];
    }
    return _points;
}
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
            double radius = [radiusStr doubleValue] == 0 ? 200.f : [radiusStr doubleValue];
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
#if 0
- (void)addTitleButtonView {
    UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    titleBtn.layer.cornerRadius = 5;
    titleBtn.layer.masksToBounds = YES;
    titleBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    titleBtn.frame = CGRectMake(0, 0, 100, 30);
    titleBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleBtn setTitle:@"圆形围栏" forState:UIControlStateNormal];
    [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [titleBtn setBackgroundColor:[[UIColor greenColor] colorWithAlphaComponent:0.3f]];
    [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleBtn;
    self.fenceMapModel.enable = YES;
    self.fenceMapModel.radius = 200;
}

- (void)titleBtnClick:(UIButton *)sender
{
    if (sender.selected) {
        [sender setTitle:@"圆形围栏" forState:UIControlStateNormal];
        self.CircleDisplayView.hidden = NO;
        self.fenceMapModel.coords = nil;
        [self.fenceMapView removeMapViewOverlays];
        self.navigationItem.rightBarButtonItems = @[self.otherItem, self.doneItem];
        _isCircleFence = YES;
    }
    else {
        [sender setTitle:@"多边形围栏" forState:UIControlStateNormal];
        self.CircleDisplayView.hidden = YES;
        [self.fenceMapView removeMapViewOverlays];
        self.navigationItem.rightBarButtonItems = @[self.otherItem, self.editItem, self.doneItem];
        _isCircleFence = NO;
    }
    sender.selected = !sender.isSelected;
}
#endif
- (void)addSegmentController {
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"圆形",@"多边形"]];
    segment.tintColor = [[UIColor grayColor] colorWithAlphaComponent:0.6f];
    segment.selectedSegmentIndex = 0;
    segment.layer.cornerRadius = 15.f;
    segment.layer.masksToBounds = YES;
    segment.layer.borderColor = [UIColor whiteColor].CGColor;
    segment.layer.borderWidth = 2.f;
    [segment addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segment;
}
- (void)segmentClick:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        self.CircleDisplayView.hidden = NO;
        self.fenceMapModel.coords = nil;
        [self.fenceMapView removeMapViewOverlays];
        self.navigationItem.rightBarButtonItems = @[self.otherItem, self.doneItem];
        _isCircleFence = YES;
    } else {
        self.CircleDisplayView.hidden = YES;
        [self.fenceMapView removeMapViewOverlays];
        self.navigationItem.rightBarButtonItems = @[self.otherItem, self.editItem, self.doneItem];
        _isCircleFence = NO;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.fenceInfo) {//如果是修改围栏
        self.title = self.fenceInfo.name.length != 0 ? self.fenceInfo.name : self.fenceInfo.fenceid;
    }
    else {//创建围栏
//        [self addTitleButtonView];
        [self addSegmentController];
        _isCreateFence = YES;
        _isCircleFence = YES;
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(editClick)];
        self.navigationItem.backBarButtonItem = backItem;
    }
    self.fenceMapView.delegate = self;
    self.radiusKVO = [PHKeyValueObserver observeObject:self.fenceMapModel keyPath:@"radius" target:self selector:@selector(radiusFromFenceMapKVO)];
    self.coordinateKVO = [PHKeyValueObserver observeObject:self.fenceMapModel keyPath:@"coordinate" target:self selector:@selector(coordinateFromFenceMapKVO)];
    self.fenceMapView.fenceMap = self.fenceMapModel;
    self.drawFenceView.backgroundColor = [UIColor whiteColor];
    self.drawFenceView.hidden = YES;
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
    self.circleRadiusL.text = [NSString stringWithFormat:@"半径:%@米", radius.length == 0 ? @200 : radius];
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
    doneItem.enabled = NO;
    self.doneItem = doneItem;
    UIBarButtonItem *otherItem = [[UIBarButtonItem alloc] initWithTitle:@"其它" style:UIBarButtonItemStylePlain target:self action:@selector(otherArgumentClick)];
    self.otherItem = otherItem;
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editClick)];
    self.editItem = editItem;

    if ([self.fenceInfo.shape isEqualToString:@"1"] || _isCreateFence) {
        self.navigationItem.rightBarButtonItems = @[otherItem, doneItem];
    }
    else {
        self.navigationItem.rightBarButtonItems = @[otherItem, editItem, doneItem];
    }
    
    
}
- (void)editClick {
    self.drawFenceView.hidden = !self.drawFenceView.hidden;
}
- (void)doneClick
{
    if (_isCreateFence) {//创建围栏
        [self createFence];
        [self rootViewControllerShouldRefresh];
    }
    else {
        NSString *area = nil;
        [self.fenceInfo.shape isEqualToString:@"1"] ? (area = [NSString stringWithFormat:@"%.6f,%.6f,%.f",self.fenceMapModel.coordinate.latitude, self.fenceMapModel.coordinate.longitude, self.fenceMapModel.radius]) : (area = self.fenceMapModel.coords.count >= 3 ? [PHTool stringConnected:self.fenceMapModel.coords connectString:@";"] : nil);
        [self rootViewControllerShouldRefresh];
        [self updateArea:area];
    }
}

- (void)createFence {
    PH_WS(ws);
    PHFenceListController *fenceList = [self.navigationController.viewControllers firstObject];
    if (fenceList.dataSource.count <= 20) {
        if (_isCircleFence) {
            self.fenceManager.coord = self.fenceMapModel.coordinate;
            self.fenceManager.radius = self.fenceMapModel.radius;
            self.fenceManager.shape = GMFenceShapeOfCircle;//默认是圆形，可不写
        }
        else {
            CLLocationCoordinate2D *coords = [PHTool transitToCoords:[self.fenceMapModel.coords copy]];
            self.fenceManager.coords = coords;
            self.fenceManager.coordsCount = (int)self.fenceMapModel.coords.count;
            self.fenceManager.shape = GMFenceShapeOfPolygon;
        }
        NSString *devid = [PHTool getDeviceIdFromUserDefault];
        [self.fenceManager addFenceWithDeviceIds:@[devid] completionBlock:^(BOOL success) {
            if (success) {
                [MBProgressHUD showSuccess:@"创建成功" toView:ws.view];
                PHLog(@"add Fence success");
            }
            else {
                [MBProgressHUD showError:@"创建失败" toView:ws.view];
                PHLog(@"add Fence failure");
            }
        } failureBlock:^(NSError *error) {
            if (error) {
                [MBProgressHUD showError:@"创建失败" toView:ws.view];
                PHLog(@"add Fence failure");
            }
        }];
    }
    else {
        [MBProgressHUD showError:@"围栏超过上限,添加失败" toView:self.view];
    }
    

}
- (void)updateArea:(NSString *)area {
    PH_WS(ws);
    if (area.length == 0) return;
    [GMFenceManager modifyFenceWithFenceId:self.fenceInfo.fenceid area:area mapType:GMMapTypeOfBAIDU completion:^(BOOL success) {
        if (success) {
            [MBProgressHUD showSuccess:@"修改成功" toView:ws.view];
            PHLog(@"modify area Fence success");
            ws.fenceInfo.area = area;
        }
        else {
            [MBProgressHUD showError:@"修改失败" toView:ws.view];
            PHLog(@"modify area Fence failure");
        }
    } failure:^(NSError *error) {
        if (error) {
            [MBProgressHUD showError:@"修改失败" toView:ws.view];
        }
    }];
}

- (void)otherArgumentClick
{
    PHFenceOtherArgumentController *otherArgu = [[PHFenceOtherArgumentController alloc] init];
    if (_isCreateFence) {
        otherArgu.fenceM = self.fenceManager;
    }
    else {
        otherArgu.fenceInfo = self.fenceInfo;
    }
    [self.navigationController pushViewController:otherArgu animated:YES];
}
- (IBAction)circleSliderAction:(UISlider *)sender {
    double value = sender.value;
    self.fenceMapModel.radius = value;
    self.circleRadiusL.text = [NSString stringWithFormat:@"半径:%.f米", value];
    self.doneItem.enabled = YES;
}

- (void)radiusFromFenceMapKVO
{
    self.fenceMapView.fenceMap = self.fenceMapModel;
}
- (void)coordinateFromFenceMapKVO
{
    self.fenceMapView.fenceMap = self.fenceMapModel;
    if (_isCreateFence) {
        self.circleRadiusL.text = [NSString stringWithFormat:@"半径:%.f米", self.fenceMapModel.radius];
    }
}

- (void)rootViewControllerShouldRefresh {
    PHFenceListController *fenceList = [self.navigationController.viewControllers firstObject];
    fenceList.fenceArgumentChanged = YES;
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
    self.doneItem.enabled = YES;
    
    [self uploadCoordinate:coordinate];
}
- (void)uploadCoordinate:(CLLocationCoordinate2D)coord
{
    GMNearbyManager *upload = [GMNearbyManager manager];
    upload.mapType = GMMapTypeOfBAIDU;
    GMDeviceInfo *device = [[GMDeviceInfo alloc] init];
    device.lat = [NSString stringWithFormat:@"%.6f",coord.latitude];
    device.lng = [NSString stringWithFormat:@"%.6f",coord.longitude];
    device.devid = [PHTool getDeviceIdFromUserDefault];
    device.gps_time = PH_CurrentTime;
    
    [upload uploadDeviceInfo:device completionBlock:^(BOOL success) {
        NSString *value = nil;
        success ? (value = @"upload success") : (value = @"upload failure");
        PHLog(@"%@",value);
    } failureBlock:nil];
}

#pragma mark - PHDrawFenceViewDelegate
- (void)drawFenceView:(PHDrawFenceView *)drawFenceView touchesBegan:(CGPoint)point {
    [self.points removeAllObjects];
    [self.points addObject:[NSValue valueWithCGPoint:point]];
    self.previousPoint = point;//记录上一条的坐标
}
- (void)drawFenceView:(PHDrawFenceView *)drawFenceView touchesMoved:(CGPoint)point {
    CGFloat distance = [self distanceBetweenPointA:point pointB:self.previousPoint];
//    PHLog(@"~~~~~~~~%.6f",distance);
    if (distance > kDistanceBetweenAandBMaxValue) {//判断两点之间的距离是否大于这个值,大于说明这个点可以被记下来
        [self.points addObject:[NSValue valueWithCGPoint:point]];
    }
    self.previousPoint = point;

}

- (void)drawFenceView:(PHDrawFenceView *)drawFenceView touchesEnded:(CGPoint)point {
    [self.points addObject:[NSValue valueWithCGPoint:point]];
    [drawFenceView removeShapelayer];
    self.drawFenceView.hidden = YES;
    PHLog(@"begin points count->%ld",(unsigned long)self.points.count);

    if (self.points.count < kNumberOfCoordinateMaxValue) {
        [self mapViewUpdate];
    }
    else {
        CGFloat threshold = kDistanceBetweenAandBMaxValue;
        while (YES) {
            PHLog(@"threshold->%.2f middle points count ->%ld",threshold, (unsigned long)self.points.count);
            threshold = threshold + 0.5f;
            for (NSUInteger i = 0; i < self.points.count - 3; i ++) {
                NSValue *valueA = self.points[i];
                NSValue *valueB = self.points[i + 1];
                CGFloat distance = [self distanceBetweenPointA:[valueA CGPointValue] pointB:[valueB CGPointValue]];
                if (distance < threshold) {
                    [self.points removeObjectAtIndex:i];
                    PHLog(@"delete points -> %ld",(unsigned long)i);
                }
            }
            if (self.points.count < kNumberOfCoordinateMaxValue) break;
        }
         [self mapViewUpdate];
    }
}
- (void)mapViewUpdate {
    PHLog(@"after points count->%ld",(unsigned long)self.points.count);
    [self.points removeLastObject];
    [self.points removeLastObject];
    if (self.points.count >= 3) {
        self.fenceMapModel.coords = nil;
        self.fenceMapModel.coords = [self convertPointToCoordinate:self.points];
        self.fenceMapView.fenceMap = self.fenceMapModel;
        self.doneItem.enabled = YES;
    }
    else {
        [MBProgressHUD showError:@"无效围栏" toView:self.view];
        self.drawFenceView.hidden = NO;
    }
}

#pragma mark - Tool method
- (NSArray *)convertPointToCoordinate:(NSArray *)points {
    NSMutableArray *coords = [NSMutableArray array];
    for (NSValue *value in points) {
        CGPoint point = [value CGPointValue];
        CLLocationCoordinate2D coord = [self.fenceMapView.bmkMapView convertPoint:point toCoordinateFromView:self.drawFenceView];
        NSString *coordStr = [NSString stringWithFormat:@"%.6f,%.6f",coord.latitude, coord.longitude];
        [coords addObject:coordStr];
    }
    return [coords copy];
}
- (CGFloat)distanceBetweenPointA:(CGPoint)pointA pointB:(CGPoint)pointB {
    CGFloat x = fabs(pointA.x - pointB.x);
    CGFloat y = fabs(pointA.y - pointB.y);
    return sqrt(x * x + y * y);
}
@end




