//
//  PHFenceMapController.h
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/8.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GMDeviceFence;
@class PHFenceMapController;

@protocol PHFenceMapControllerDelegate <NSObject>

@optional
- (void)fenceMapController:(PHFenceMapController *)controller;

@end

@interface PHFenceMapController : UIViewController

@property(nonatomic, strong)GMDeviceFence *fenceInfo;

@property(nonatomic, assign)id<PHFenceMapControllerDelegate>delegate;

@end
