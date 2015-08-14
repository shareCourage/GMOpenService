//
//  PHPlayProgressView.h
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/6.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PHPlayProgressView;

@protocol PHPlayProgressViewDelegate <NSObject>

@optional
- (void)playProgressView:(PHPlayProgressView *)progressView playState:(BOOL)state;
- (void)playProgressView:(PHPlayProgressView *)progressView percentage:(double)percentage;

@end

@interface PHPlayProgressView : UIView

@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UISlider *sliderView;

@property (nonatomic,assign) id<PHPlayProgressViewDelegate> delegate;

@end
