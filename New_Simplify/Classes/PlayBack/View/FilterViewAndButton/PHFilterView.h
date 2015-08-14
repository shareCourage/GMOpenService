//
//  PHFilterView.h
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/19.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PHFilterView;

typedef enum{
    PHFilterViewStatuOfCancel = 100,
    PHFilterViewStatuOfSure
}PHFilterViewStatus;

@protocol PHFilterViewDelegate <NSObject>

@optional
- (void)filterView:(PHFilterView *)filterView didSelectButtonFrom:(NSUInteger)from to:(NSUInteger)to;
- (void)filterView:(PHFilterView *)filterView didSelectStatu:(PHFilterViewStatus)status withStartTime:(NSTimeInterval)start endTime:(NSTimeInterval)end;

@end
@interface PHFilterView : UIView

@property(nonatomic, assign)id<PHFilterViewDelegate>delegate;

@property(nonatomic, strong)NSArray *buttonTitles;//内部按钮的title
@property(nonatomic, strong)NSString *title;//该view的title
@property(nonatomic, assign, getter = isDisplayTextField)BOOL displayTextField;//是否展示textField
@end







