//
//  PHFenceMapTitleView.m
//  SimplifiedApp
//
//  Created by Kowloon on 15/5/8.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#import "PHFenceMapTitleView.h"
#import "PHFenceMap.h"
#import <BaiduMapAPI/BMapKit.h>

@interface PHFenceMapTitleView ()<BMKGeoCodeSearchDelegate>

@property (weak, nonatomic) IBOutlet UILabel *areaL;
@property (weak, nonatomic) IBOutlet UILabel *radiusL;

@property(nonatomic, strong)BMKGeoCodeSearch *geoCodeSearch;
@end

@implementation PHFenceMapTitleView
- (BMKGeoCodeSearch *)geoCodeSearch
{
    if (_geoCodeSearch == nil) {
        _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    }
    return _geoCodeSearch;
}
- (void)fenceMapTitleViewWillAppear
{
    self.geoCodeSearch.delegate = self;
}
- (void)fenceMapTitleViewWillDisappear
{
    self.geoCodeSearch.delegate = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [PHFenceMapTitleView fenceMapTitleViewFromXib];
        self.frame = frame;
    }
    return self;
}

+ (instancetype)fenceMapTitleViewFromXib
{
    PHFenceMapTitleView *mapTitle = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
    return mapTitle;
}

- (IBAction)switchValueChanged:(UISwitch *)sender {
    if ([self.delegate respondsToSelector:@selector(fenceMapTitleView:switchValueChanged:)]) {
        [self.delegate fenceMapTitleView:self switchValueChanged:self.mySwitch.isOn];
    }
}

- (void)setFenceMap:(PHFenceMap *)fenceMap
{
    _fenceMap = fenceMap;
    self.radiusL.text = [NSString stringWithFormat:@"围栏半径:%.f米",fenceMap.radius];
    self.mySwitch.on = fenceMap.enable;
    BMKReverseGeoCodeOption *option = [[BMKReverseGeoCodeOption alloc] init];
    option.reverseGeoPoint = fenceMap.coordinate;
    [self.geoCodeSearch reverseGeoCode:option];
}

#pragma mark - BMKGeoCodeSearchDelegate

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    self.areaL.text = result.address;
}

@end








