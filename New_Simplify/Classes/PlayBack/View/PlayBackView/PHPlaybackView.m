//
//  PHPlaybackView.m
//  SimplifiedApp
//
//  Created by Kowloon on 15/4/30.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#define PH_ImageName_history_end   @"history_end"
#define PH_ImageName_history_begin @"history_begin"
#define PH_ImageName_history_car   @"history_car"
#define PHBubbleTag 100

#import "PHPlaybackView.h"
#import "PHStartAnnotation.h"
#import "PHStartAnnotationView.h"
#import "PHEndAnnotation.h"
#import "PHEndAnnotationView.h"
#import "PHPlayAnnotation.h"
#import "PHPlayAnnotationView.h"
#import "PHPlayProgressView.h"
#import "PHPlayDisplayView.h"
#import "PHHistoryLoc.h"
#import "DWBubbleMenuButton.h"

typedef NS_ENUM(NSUInteger, PHPlayBackSpeed) {
    PHPlayBackSpeedOfSlowPlus = PHBubbleTag,//定义回放的时间，慢+
    PHPlayBackSpeedOfSlowNormal,//慢
    PHPlayBackSpeedOfSlowMinus,//慢-
    PHPlayBackSpeedOfFastMinus,//快-
    PHPlayBackSpeedOfFastNormal,//快
    PHPlayBackSpeedOfFastPlus,//快+
};

@interface PHPlaybackView ()<PHPlayProgressViewDelegate>
{
    NSUInteger _playIndex;
    BOOL _playProgressViewState;//将PHPlayProgressView传过来的状态值存储起来
}
@property(nonatomic, strong)PHPlayAnnotation *playAnno;
@property(nonatomic, strong)PHPlayAnnotation *previousAnno;//记录地图上插过的playAnno大头针
@property(nonatomic, weak)PHPlayProgressView *progressView;
@property(nonatomic, weak)PHPlayDisplayView *displayView;

@end

@implementation PHPlaybackView
- (void)playBackViewWillAppearWithHistorys:(NSArray *)hitorys
{
    [self baiduMapViewWillAppear];
    _historys = hitorys;
    _playProgressViewState = NO;
}
- (void)playBackViewWillDisappear
{
    [self baiduMapViewWillDisappear];
    _historys = nil;
    _playProgressViewState = YES;
    self.progressView.playBtn.selected = NO;
}
- (void)clearAllOfTheMapViewPloylineAndAnnotations
{
    _historys = nil;
    _playProgressViewState = NO;
    self.progressView.playBtn.selected = NO;
    _playIndex = 0;
    self.progressView.sliderView.value = 0;
    [self.displayView clearDisplayRecord];
    [self.bmkMapView removeOverlays:self.bmkMapView.overlays];
    [self.bmkMapView removeAnnotations:self.bmkMapView.annotations];
}


/**
 *  使用懒加载方法，加载playAnno
 */
- (PHPlayAnnotation *)playAnno
{
    if (_playAnno == nil) {
        _playAnno = [PHPlayAnnotation playAnnotation];
        _playAnno.iconName = PH_ImageName_history_car;
    }
    return _playAnno;
}



/**
 *  重写historys的setter函数
 */
- (void)setHistorys:(NSArray *)historys
{
    _historys = historys;
    if (historys.count > 0) {
        self.progressView.playBtn.selected = YES;
        [self configurePolyline:historys];
        [self addAnnotationForStartAndEndPoint:historys];
        /**
         *  这两代码实际上一般情况下只需要执行[self lanuchPlaybackFunction]这个就可以，只是为了解决在播放历史记录的时候，又重新添加新的播放的bug
         */
        _playProgressViewState = YES;//这里设置这个的目的是为了，让runloop之前已经在运行的lanuchPlaybackFunction函数，能够执行到return语句。
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_playTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _playProgressViewState = NO;
            [self lanuchPlaybackFunction];
        });//加上这个延时，是为了正在runloop上运行的lanuchPlaybackFunction能够充分执行完成，然后再来重新调用lanuchPlaybackFunction函数
        self.displayView.historys = historys;//将这个数组给PHDisplayView，为了提前算好每个空隙的总里程
    }
}

/**
 *  启动回放功能
 */
- (void)lanuchPlaybackFunction
{
    PHLog(@"lanuchPlaybackFunction->%ld",(unsigned long)self.bmkMapView.annotations.count);
    if (_historys == nil) return;
    if (_playIndex >= _historys.count || _playProgressViewState) {
        if (_playIndex >= _historys.count) {
            self.progressView.playBtn.selected = NO;
            self.progressView.sliderView.value = 0;
            _playIndex = 0;
        }
        return;
    }
    float percentage = (float)_playIndex / _historys.count;
    self.progressView.sliderView.value = percentage;
    [self addAnnotationOfPlayAnno];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_playTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self lanuchPlaybackFunction];
        _playIndex ++;
    });
}

- (void)addAnnotationOfPlayAnno
{
    PHHistoryLoc *his = _historys[_playIndex];
    self.displayView.history = his;
    [self.displayView setTotalMilesWithIndex:_playIndex];//用这个特殊方式来显示总里程
    CLLocationDegrees lat = [his.lat doubleValue];
    CLLocationDegrees lng = [his.lng doubleValue];
    self.playAnno.coordinate = CLLocationCoordinate2DMake(lat, lng);
    [self.bmkMapView removeAnnotation:self.previousAnno];
    [self.bmkMapView addAnnotation:self.playAnno];
    self.previousAnno = self.playAnno;
    [self.bmkMapView setCenterCoordinate:self.playAnno.coordinate animated:YES];
}
/**
 *  给起始和结束点添加大头针
 */
- (void)addAnnotationForStartAndEndPoint:(NSArray *)points
{
    PHHistoryLoc *startHis = [points firstObject];
    PHHistoryLoc *endHis = [points lastObject];
    NSMutableArray *annotations = [NSMutableArray array];
    PHStartAnnotation *startAnno = [PHStartAnnotation startAnnotation];
    PHEndAnnotation *endAnno = [PHEndAnnotation endAnnotation];
    startAnno.coordinate = CLLocationCoordinate2DMake([startHis.lat doubleValue], [startHis.lng doubleValue]);
    endAnno.coordinate = CLLocationCoordinate2DMake([endHis.lat doubleValue], [endHis.lng doubleValue]);
    startAnno.iconName = PH_ImageName_history_begin;
    endAnno.iconName = PH_ImageName_history_end;
    [annotations addObject:endAnno];
    [annotations addObject:startAnno];
    [self.bmkMapView addAnnotations:annotations];
    [self.bmkMapView setCenterCoordinate:startAnno.coordinate animated:YES];
}

#pragma mark - configurePolyline
/**
 *  MapView添加Overlay
 */
- (void)configurePolyline:(NSArray *)points
{
    [self.bmkMapView removeOverlays:self.bmkMapView.overlays];
    NSUInteger pointCount = points.count;
    if (pointCount == 0) return;
    BMKMapPoint *mapPoints = malloc(sizeof(BMKMapPoint) * pointCount);
    [points enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PHHistoryLoc *his = (PHHistoryLoc *)obj;
        double lat = [his.lat doubleValue];
        double lng = [his.lng doubleValue];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat,lng);
        mapPoints[idx] = BMKMapPointForCoordinate(coordinate);
    }];
    BMKPolyline *polyline = [BMKPolyline polylineWithPoints:mapPoints count:pointCount];
    free(mapPoints);//使用C在堆里面分配的一段内存，记得要释放
    [self.bmkMapView addOverlay:polyline];
}

#pragma mark - BMKMapViewDelegate
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView *polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor = [UIColor greenColor];
        polylineView.lineWidth = 5.0;
        return polylineView;
    } else {
        return nil;
    }
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[PHStartAnnotation class]]) {
        PHStartAnnotationView *startView = [PHStartAnnotationView annotationViewWithMapView:mapView];
        startView.annotation = annotation;
        return startView;
    }
    else if ([annotation isKindOfClass:[PHEndAnnotation class]]){
        PHEndAnnotationView *endView = [PHEndAnnotationView annotationViewWithMapView:mapView];
        endView.annotation = annotation;
        return endView;
    }
    else if ([annotation isKindOfClass:[PHPlayAnnotation class]]){
        PHPlayAnnotationView *playView = [PHPlayAnnotationView annotationViewWithMapView:mapView];
        playView.annotation = annotation;
        return playView;
    }
    return nil;
}

#pragma mark - PHPlayProgressViewDelegate
- (void)playProgressView:(PHPlayProgressView *)progressView percentage:(double)percentage
{
    if (_historys.count > 0) {
        NSUInteger value = percentage * _historys.count;
        if (value == _historys.count) {
            value = _historys.count - 1;
        }
        _playIndex = value;
        progressView.playBtn.selected = NO;
        _playProgressViewState = YES;
        [self addAnnotationOfPlayAnno];
    }
}
- (void)playProgressView:(PHPlayProgressView *)progressView playState:(BOOL)state
{
    _playProgressViewState = !state;
    if (state) {
        [self lanuchPlaybackFunction];
    }
}


- (void)dealloc
{
    PHLog(@"PHPlaybackView->dealloc");
}
- (void)bubbleViewImplementation
{
    CGFloat lableX = 0;
    CGFloat lableY = 0;
    CGFloat lableW = 40;
    CGFloat lableH = lableW;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(lableX, lableY, lableW, lableH)];
    label.text = @"Tap";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15.f];
    label.layer.cornerRadius = label.frame.size.height / 2.f;
    label.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.5f];
    label.clipsToBounds = YES;
    CGFloat bubbleX = 10.f;
    CGFloat bubbleY = PH_HeightOfScreen - 49 - 80 - lableH;
    CGFloat bubbleW = label.frame.size.width;
    CGFloat bubbleH = label.frame.size.height;
    CGRect  bubbleF = CGRectMake(bubbleX, bubbleY, bubbleW, bubbleH);
    DWBubbleMenuButton *downMenuButton = [[DWBubbleMenuButton alloc] initWithFrame:bubbleF expansionDirection:DirectionUp];
    downMenuButton.buttonSpacing = 10.f;
    downMenuButton.homeButtonView = label;
    [downMenuButton addButtons:[self createDemoButtonArray]];
    [self addSubview:downMenuButton];
}
- (NSArray *)createDemoButtonArray {
    NSMutableArray *buttonsMutable = [[NSMutableArray alloc] init];
    int i = 0;
    for (NSString *title in @[@"慢+", @"慢", @"慢-", @"快-", @"快", @"快+"]) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
        button.frame = CGRectMake(0.f, 0.f, 30.f, 30.f);
        button.layer.cornerRadius = button.frame.size.height / 2.f;
        [button setBackgroundColor:PH_RGBAColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255), 0.7f)];
        button.clipsToBounds = YES;
        button.tag = PHBubbleTag + i;
        i++;
        [button addTarget:self action:@selector(speedResponse:) forControlEvents:UIControlEventTouchUpInside];
        [buttonsMutable addObject:button];
    }
    return [buttonsMutable copy];
}
- (void)speedResponse:(UIButton *)sender {
    switch (sender.tag) {
        case PHPlayBackSpeedOfSlowPlus:
            _playTime = 2.0f;
            break;
        case PHPlayBackSpeedOfSlowNormal:
            _playTime = 1.5f;
            break;
        case PHPlayBackSpeedOfSlowMinus:
            _playTime = 1.0f;
            break;
        case PHPlayBackSpeedOfFastMinus:
            _playTime = 0.8f;
            break;
        case PHPlayBackSpeedOfFastNormal:
            _playTime = 0.6f;
            break;
        case PHPlayBackSpeedOfFastPlus:
            _playTime = 0.3f;
            break;
        default:
            break;
    }
}

//实例化PHPlayProgressView和PHPlayDisplayView
- (void)addProgressViewAndDisplayViewFunc
{
    PHPlayProgressView *progress = [[PHPlayProgressView alloc] initWithFrame:CGRectMake(0, 0, PH_WidthOfScreen, 30)];
    progress.delegate = self;
    [self addSubview:progress];
    self.progressView = progress;
    
    PHPlayDisplayView *display = [PHPlayDisplayView playDisplayViewFromXib];
    display.frame = CGRectMake(0, CGRectGetMaxY(progress.frame), PH_WidthOfScreen, 20);
    [self addSubview:display];
    self.displayView = display;
}

- (void)awakeFromNib
{
    [self addProgressViewAndDisplayViewFunc];
    [self bubbleViewImplementation];
}
@end










