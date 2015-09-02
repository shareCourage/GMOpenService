//
//  PHFenceModifyMapController.m
//  New_Simplify
//
//  Created by Kowloon on 15/9/2.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "PHFenceModifyMapController.h"
#import "PHFenceMapView.h"

@interface PHFenceModifyMapController ()

@property (weak, nonatomic) IBOutlet UIView *CircleDisplayView;
@property (weak, nonatomic) IBOutlet UISlider *circleSlider;
@property (weak, nonatomic) IBOutlet UILabel *circleRadiusL;
- (IBAction)circleSliderAction:(UISlider *)sender;


@property (weak, nonatomic) IBOutlet PHFenceMapView *fenceMapView;

@end

@implementation PHFenceModifyMapController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.fenceInfo.name;
    [self barButtonItemImplementation];
    
    [self circleDisplayViewImplementation];
}
- (void)circleDisplayViewImplementation {
    self.CircleDisplayView.backgroundColor = [UIColor clearColor];
    self.circleRadiusL.text = [NSString stringWithFormat:@"半径:%@米",[[NSArray seprateString:self.fenceInfo.area characterSet:@","] lastObject]];
    self.circleSlider.maximumValue = 10000;
    if ([self.fenceInfo.shape isEqualToString:@"2"]) {
        self.CircleDisplayView.hidden = YES;
    }
}

/**
 *  导航栏UIBarButtonItem的放置
 */
- (void)barButtonItemImplementation
{
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(doneClick)];
    UIBarButtonItem *modifyItem = [[UIBarButtonItem alloc] initWithTitle:@"其它参数" style:UIBarButtonItemStylePlain target:self action:@selector(modifyClick)];
    self.navigationItem.rightBarButtonItems = @[modifyItem, doneItem];
}
- (void)doneClick
{

}
- (void)modifyClick
{
    
}
- (IBAction)circleSliderAction:(UISlider *)sender {
    
}
@end




