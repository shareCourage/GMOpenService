//
//  PHPlayProgressView.m
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/6.
//  Copyright (c) 2015年 Goome. All rights reserved.
//
#define PH_ImageName_historyPlay    @"history_play"
#define PH_ImageName_historyStop    @"history_stop"
#define PH_ImageName_historyToggle  @"history_toggle"

#import "PHPlayProgressView.h"
@interface PHPlayProgressView ()

@property (nonatomic, strong) UILabel *beginLabel;
@property (nonatomic, strong) UILabel *endLabel;

@end

@implementation PHPlayProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:.8];
        
        CGFloat padding = 5;
        CGFloat labelWidth = 40;
        
        CGFloat playBtnW = 30;
        CGFloat playBtnH = 30;
        CGFloat playBtnX = 5;
        CGFloat playBtnY = frame.size.height / 2 - playBtnH / 2;
        CGRect playBtnFrame = CGRectMake(playBtnX, playBtnY, playBtnW, playBtnH);
        _playBtn = [UIButton buttonWithFrame:playBtnFrame
                                      target:self
                                      action:@selector(onPlay)
                                 normalImage:[UIImage imageNamed:PH_ImageName_historyPlay]
                               selectedImage:[UIImage imageNamed:PH_ImageName_historyStop]];
        [self addSubview:_playBtn];
        
        NSString *beginText = @"Start";
        CGFloat beginLabelW = labelWidth;
        CGFloat beginLabelH = 30;
        CGFloat beginLabelX = CGRectGetWidth(_playBtn.frame) + padding;
        CGFloat beginLabelY = frame.size.height / 2 - beginLabelH / 2;
        CGRect beginLabelFrame = CGRectMake(beginLabelX, beginLabelY, beginLabelW, beginLabelH);
        _beginLabel = [UILabel labelWithFrame:beginLabelFrame
                                         text:beginText
                                    textColor:[UIColor whiteColor]
                                textAlignment:NSTextAlignmentCenter
                                         font:[UIFont systemFontOfSize:PHSystemFontSize]];
        [self addSubview:_beginLabel];
        
        
        CGFloat endLabelW = labelWidth;
        CGFloat endLabelH = 30;
        CGFloat endLabelX = frame.size.width - endLabelW - padding;
        CGFloat endLabelY = frame.size.height / 2 - endLabelH / 2;
        CGRect endLabelFrame = CGRectMake(endLabelX, endLabelY, endLabelW, endLabelH);
        _endLabel = [UILabel labelWithFrame:endLabelFrame
                                       text:@"End"
                                  textColor:[UIColor whiteColor]
                              textAlignment:NSTextAlignmentCenter
                                       font:[UIFont systemFontOfSize:PHSystemFontSize]];
        [self addSubview:_endLabel];
        
        CGFloat anotherPadding = 0;
        CGFloat sliderViewW = frame.size.width - CGRectGetMaxX(_beginLabel.frame) - padding * 3 - CGRectGetWidth(_endLabel.frame) + anotherPadding * 2;
        CGFloat sliderViewH = 30;
        CGFloat sliderViewX = CGRectGetMaxX(_beginLabel.frame) + padding - anotherPadding;
        CGFloat sliderViewY = frame.size.height / 2 - sliderViewH / 2;
        CGRect sliderFrame = CGRectMake(sliderViewX, sliderViewY, sliderViewW, sliderViewH);
        _sliderView = [UISlider sliderWithFrame:sliderFrame
                                         target:self
                                         action:@selector(sliderValueChanged:)
                                     thumbImage:PH_ImageName_historyToggle
                                     thumbState:UIControlStateNormal
                                   controlEvent:UIControlEventValueChanged];
        [self addSubview:_sliderView];
    }
    return self;
}
/**
 *  UISlider的响应事件
 *
 *  @param sender UISlider
 */
- (void)sliderValueChanged:(UISlider *)sender
{
    PHLog(@"%.3f",sender.value);
    if ([self.delegate respondsToSelector:@selector(playProgressView:percentage:)]) {
        [self.delegate playProgressView:self percentage:sender.value];
    }
}
/**
 *  播放按钮的响应时事件
 */
-(void)onPlay{
    _playBtn.selected = !_playBtn.isSelected;

    if ([self.delegate respondsToSelector:@selector(playProgressView:playState:)]) {
        [self.delegate playProgressView:self playState:_playBtn.selected];
    }
}


@end




