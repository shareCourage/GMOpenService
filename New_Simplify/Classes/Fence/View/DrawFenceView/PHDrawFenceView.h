//
//  PHDrawFenceView.h
//  New_Simplify
//
//  Created by Kowloon on 15/9/7.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PHDrawFenceView;

@protocol PHDrawFenceViewDelegate <NSObject>

@optional
- (void)drawFenceView:(PHDrawFenceView *)drawFenceView touchesBegan:(CGPoint)point;
- (void)drawFenceView:(PHDrawFenceView *)drawFenceView touchesMoved:(CGPoint)point;
- (void)drawFenceView:(PHDrawFenceView *)drawFenceView touchesEnded:(CGPoint)point;

@end


@interface PHDrawFenceView : UIView

@property (nonatomic, weak) IBOutlet id<PHDrawFenceViewDelegate> delegate;

- (void)removeShapelayer;

@end
