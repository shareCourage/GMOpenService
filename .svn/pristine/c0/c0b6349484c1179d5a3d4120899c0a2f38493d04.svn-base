//
//  PHPlayDisplayView.m
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/8.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "PHPlayDisplayView.h"
#import "PHHistoryLoc.h"

@interface PHPlayDisplayView ()
{
    CLLocationDistance _totalDistance;
}
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *speedL;
@property (weak, nonatomic) IBOutlet UILabel *distanceL;
@property (weak, nonatomic) IBOutlet UILabel *directionL;
@property(nonatomic, strong)PHHistoryLoc *previousHistory;
@end

@implementation PHPlayDisplayView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [PHPlayDisplayView playDisplayViewFromXib];
        self.frame = frame;
        _totalDistance = 0;
    }
    return self;
}

+ (instancetype)playDisplayViewFromXib
{
    PHPlayDisplayView *display = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
    display.timeL.font = [UIFont systemFontOfSize:PHSystemFontSize];
    display.speedL.font = [UIFont systemFontOfSize:PHSystemFontSize];
    display.distanceL.font = [UIFont systemFontOfSize:PHSystemFontSize];
    display.directionL.font = [UIFont systemFontOfSize:PHSystemFontSize];
    display.timeL.backgroundColor = [UIColor clearColor];
    display.speedL.backgroundColor = [UIColor clearColor];
    display.distanceL.backgroundColor = [UIColor clearColor];
    display.directionL.backgroundColor = [UIColor clearColor];
    display.backgroundColor = [UIColor colorWithWhite:0 alpha:.8];
    return display;
}


- (void)setHistory:(PHHistoryLoc *)history
{
    _history = history;
    [self setLabelValue:history];
}


#warning 根据具体结果再处理
- (void)setLabelValue:(PHHistoryLoc *)history
{
    self.timeL.text = [PHTool convertTime:history.gps_time withDateFormate:nil];
    self.speedL.text = history.speed;
    self.directionL.text = history.course;
    if (self.previousHistory != nil) {
        self.distanceL.text = [self calculateTotalDistance:history];
    }
    self.previousHistory = history;
}
- (NSString *)calculateTotalDistance:(PHHistoryLoc *)nowH
{
    CLLocationCoordinate2D source = CLLocationCoordinate2DMake([nowH.lat doubleValue], [nowH.lng doubleValue]);
    CLLocationCoordinate2D destination = CLLocationCoordinate2DMake([self.previousHistory.lat doubleValue], [self.previousHistory.lng doubleValue]);
    CLLocationDistance distance = [PHTool calculateLineDistanceWithSourceCoordinate:source andDestinationCoordinate:destination];
    _totalDistance = _totalDistance + distance;
    return [NSString stringWithFormat:@"%.fm",_totalDistance];
}

@end











