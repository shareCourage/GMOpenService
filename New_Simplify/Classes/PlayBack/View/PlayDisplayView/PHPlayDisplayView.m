//
//  PHPlayDisplayView.m
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/8.
//  Copyright (c) 2015年 Goome. All rights reserved.
//case 0:

#define PH_DirectionOfNorth     @"北"
#define PH_DirectionOfEast      @"东"
#define PH_DirectionOfWest      @"西"
#define PH_DirectionOfSouth     @"南"
#define PH_DirectionOfNorthEast @"东北"
#define PH_DirectionOfSouthEast @"东南"
#define PH_DirectionOfSouthWest @"西南"
#define PH_DirectionOfNorthWest @"西北"

#define PH_PlayDisplayView_FontMaxSize 12.f
#define PH_PlayDisplayView_FontMinSize 10.f

#import "PHPlayDisplayView.h"
#import "PHHistoryLoc.h"
#import <BaiduMapAPI/BMapKit.h>

@interface PHPlayDisplayView ()

@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *distanceL;
@property (weak, nonatomic) IBOutlet UILabel *speedL;
@property (weak, nonatomic) IBOutlet UILabel *directionL;

@property (nonatomic, strong) NSMutableArray *totalDistances;
@end

@implementation PHPlayDisplayView
- (NSMutableArray *)totalDistances {
    if (!_totalDistances) {
        _totalDistances = [NSMutableArray array];
        [_totalDistances addObject:@0];//第一个元素放置0
    }
    return _totalDistances;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [PHPlayDisplayView playDisplayViewFromXib];
        self.frame = frame;
    }
    return self;
}

+ (instancetype)playDisplayViewFromXib
{
    PHPlayDisplayView *display = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
    CGFloat fontSize = 0.f;
    PH_WidthOfScreen > 320 ? (fontSize = PH_PlayDisplayView_FontMaxSize) : (fontSize = PH_PlayDisplayView_FontMinSize);
    display.timeL.font = [UIFont systemFontOfSize:fontSize];
    display.speedL.font = [UIFont systemFontOfSize:fontSize];
    display.distanceL.font = [UIFont systemFontOfSize:PH_PlayDisplayView_FontMinSize];
    display.directionL.font = [UIFont systemFontOfSize:fontSize];
    display.timeL.text = @"时间";
    display.speedL.text = @"速度";
    display.distanceL.text = @"行程";
    display.directionL.text = @"方向";
    display.timeL.backgroundColor = [UIColor clearColor];
    display.speedL.backgroundColor = [UIColor clearColor];
    display.distanceL.backgroundColor = [UIColor clearColor];
    display.directionL.backgroundColor = [UIColor clearColor];
    display.backgroundColor = [UIColor colorWithWhite:0 alpha:.8];
    return display;
}
- (void)setTotalMilesWithIndex:(NSUInteger)index {
    NSNumber *distance = [self.totalDistances objectAtIndex:index];
    self.distanceL.text = [self meterTransformToKiloMeter:[distance doubleValue]];
}
- (void)setHistorys:(NSArray *)historys {
    _historys = historys;
    [self.totalDistances removeAllObjects];
    self.totalDistances = nil;
    [historys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSNumber *lastDistance = [self.totalDistances lastObject];
        if (idx > 0) {
            PHHistoryLoc *previousHis = historys[idx - 1];
            PHHistoryLoc *nowHis = historys[idx];
            CLLocationDistance distance = [self distanceFromHisA:previousHis hisB:nowHis];
            [self.totalDistances addObject:@([lastDistance floatValue] + distance)];
        }
    }];
#if 0
    for (NSNumber *obj in self.totalDistances) {
        PHLog(@"~~~~~~~~~~%@",obj);
    }
#endif
}

- (void)setHistory:(PHHistoryLoc *)history
{
    _history = history;
    [self setLabelValue:history];
}


- (void)clearDisplayRecord {
    self.timeL.text = nil;
    self.speedL.text = nil;
    self.distanceL.text = nil;
    self.directionL.text = nil;
}

- (void)setLabelValue:(PHHistoryLoc *)history
{
    self.timeL.text = [PHTool convertTime:history.gps_time withDateFormate:@"yyyy-MM-dd HH:mm:ss"];
    self.speedL.text = [NSString stringWithFormat:@"速度:%@",[self meterTransformToKiloMeterPerHour:[history.speed doubleValue]]];
    self.directionL.text = [NSString stringWithFormat:@"方向:%@",[self directionWithCourse:[history.course integerValue]]];
}


- (NSString *)meterTransformToKiloMeter:(CGFloat)meter {
    if (meter <  1000 && meter > 0) {
        return [NSString stringWithFormat:@"总里程:%.fm",meter];
    }
    else {
        return [NSString stringWithFormat:@"总里程:%.2fKM",meter / 1000];
    }
    return nil;
}


- (NSString *)meterTransformToKiloMeterPerHour:(CGFloat)meter {
    if (meter < 1000 && meter >= 0) {
        return [NSString stringWithFormat:@"%.fm/s",meter];
    }
    else {
        return [NSString stringWithFormat:@"%.fKM/h",(meter / 1000) * 3600];
    }
    return nil;
}


- (CLLocationDistance)distanceFromHisA:(PHHistoryLoc *)hisA hisB:(PHHistoryLoc *)hisB {
    if (hisA && hisB) {
        CLLocationCoordinate2D source = CLLocationCoordinate2DMake([hisA.lat doubleValue], [hisA.lng doubleValue]);
        CLLocationCoordinate2D destination = CLLocationCoordinate2DMake([hisB.lat doubleValue], [hisB.lng doubleValue]);
        return [self distanceFromCoordA:source toCoordB:destination];
    }
    return 0.f;
}

- (CLLocationDistance)distanceFromCoordA:(CLLocationCoordinate2D)coordA toCoordB:(CLLocationCoordinate2D)coordB
{
    BMKMapPoint pointA = BMKMapPointForCoordinate(coordA);
    BMKMapPoint pointB = BMKMapPointForCoordinate(coordB);
    CLLocationDistance distance= BMKMetersBetweenMapPoints(pointA, pointB);
    return distance;
}
- (NSString *)directionWithCourse:(NSInteger)course{
    NSInteger direction = course / 45;
    NSString *dir;
    switch (direction) {
        case 0:
            dir = PH_DirectionOfNorth;
            break;
        case 1:
            dir = PH_DirectionOfNorthWest;
            break;
        case 2:
            dir = PH_DirectionOfEast;
            break;
        case 3:
            dir = PH_DirectionOfSouthEast;
            break;
        case 4:
            dir = PH_DirectionOfSouth;
            break;
        case 5:
            dir = PH_DirectionOfSouthWest;
            break;
        case 6:
            dir = PH_DirectionOfWest;
            break;
        case 7:
            dir = PH_DirectionOfNorthWest;
            break;
        default:
            dir = PH_DirectionOfNorth;
            break;
    }
    return dir;
}

@end











