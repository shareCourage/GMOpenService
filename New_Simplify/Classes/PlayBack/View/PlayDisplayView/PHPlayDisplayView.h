//
//  PHPlayDisplayView.h
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/8.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PHHistoryLoc;

@interface PHPlayDisplayView : UIView

+ (instancetype)playDisplayViewFromXib;

@property (nonatomic, weak) PHHistoryLoc *history;
@property (nonatomic, weak) NSArray *historys;

- (void)clearDisplayRecord;

- (void)setTotalMilesWithIndex:(NSUInteger)index;

@end
