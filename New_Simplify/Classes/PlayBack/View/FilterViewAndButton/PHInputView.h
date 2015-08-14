//
//  PHInputView.h
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/20.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PHInputView;

@protocol PHInputViewDelegate <NSObject>

@optional
- (void)inputView:(PHInputView *)inputView valueChanged:(NSDate *)date;
- (void)inputView:(PHInputView *)inputView didSelectedIndex:(NSUInteger)index date:(NSDate *)date;

@end

@interface PHInputView : UIView

@property(nonatomic, assign)id<PHInputViewDelegate>delegate;

@end
