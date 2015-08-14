//
//  PHFenceMapTitleView.h
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/8.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PHFenceMap;
@class PHFenceMapTitleView;

@protocol PHFenceMapTitleViewDelegate <NSObject>

- (void)fenceMapTitleView:(PHFenceMapTitleView *)fenceMapTitleView switchValueChanged:(BOOL)isOn;

@end


@interface PHFenceMapTitleView : UIView

@property(nonatomic, assign)id<PHFenceMapTitleViewDelegate>delegate;
@property(nonatomic, strong)PHFenceMap *fenceMap;
@property (weak, nonatomic) IBOutlet UISwitch *mySwitch;

+ (instancetype)fenceMapTitleViewFromXib;
- (void)fenceMapTitleViewWillAppear;
- (void)fenceMapTitleViewWillDisappear;

@end
