//
//  PHPlaybackView.h
//  SimplifiedApp
//
//  Created by Kowloon on 15/4/30.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "PHBaiduMapView.h"

@interface PHPlaybackView : PHBaiduMapView

@property (nonatomic, strong)NSArray *historys;//用来回放的数组,装PHHistoryLoc对象

@property (nonatomic, assign)float playTime;//控制播放速度的时间

- (void)playBackViewWillAppearWithHistorys:(NSArray *)hitorys;
- (void)playBackViewWillDisappear;


//清除地图的所有轨迹和大头针
- (void)clearAllOfTheMapViewPloylineAndAnnotations;

@end
