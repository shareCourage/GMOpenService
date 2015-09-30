//
//  PHPlayBackController.m
//  SimplifiedApp
//
//  Created by Kowloon on 15/4/30.
//  Copyright (c) 2015年 Goome. All rights reserved.
//
#define PH_ImageName_speed @"playBack_speed"
#define PH_ImageName_time  @"playBack_time"
#define PHImage_NaviArrowUp [UIImage imageNamed:@"navigationbar_arrow_up"]
#define PHImage_NaviArrowDown [UIImage imageNamed:@"navigationbar_arrow_down"]

#import "PHPlayBackController.h"
#import "PHPlaybackView.h"
#import "PHDeviceInfo.h"
#import "PHHistoryLoc.h"
#import "PHTitleButton.h"
#import "PHFilterView.h"
#import "AppDelegate.h"
@interface PHPlayBackController ()<PHFilterViewDelegate, MBProgressHUDDelegate, UIAlertViewDelegate>
{
    BOOL _isPlayBack;
}
@property (weak, nonatomic) IBOutlet PHPlaybackView *playBackMapView;
@property(nonatomic, strong)MBProgressHUD *myHud;
@property(nonatomic, strong)PHFilterView *filterView;

@property(nonatomic, strong)GMHistoryManager *hisM;//用这个来控制从服务器实时获取历史数据信息

@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;

@end

@implementation PHPlayBackController
- (void)dealloc
{
    PHLog(@"%@ ---->dealloc",NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    self.hisM = delegate.hisM;
    _isPlayBack = NO;
    [self addNavigationBarTitleItem];
    [self addNavigationRightItem];
    [self fileViewImplementation];
    
}

- (void)viewControllerDidEnterBackground {
    [super viewControllerDidEnterBackground];
    [self viewWillDisappear:YES];
}
- (void)viewControllerDidBecomeActive {
    [super viewControllerDidBecomeActive];
    [self viewWillAppear:YES];
}

- (void)addNavigationRightItem
{
    UIBarButtonItem *clearItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(clearItemClick)];
    clearItem.tintColor = [UIColor blueColor];
    self.navigationItem.rightBarButtonItem = clearItem;
}
- (void)clearItemClick
{
    _isPlayBack = NO;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"将清除所有的数据，并停止回放轨迹" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert show];
}
- (void)fileViewImplementation
{
    CGFloat filterX = 0;
    CGFloat filterY = PH_HeightOfNavigationBar;
    CGFloat filterW = PH_WidthOfScreen;
    CGFloat filterH = PH_HeightOfScreen - PH_HeightOfNavigationBar;
    CGRect filterF = CGRectMake(filterX, filterY, filterW, filterH);
    self.filterView = [[PHFilterView alloc] initWithFrame:filterF];
    self.filterView.delegate = self;
    [self.view addSubview:self.filterView];
    
}
- (void)addNavigationBarTitleItem
{
    // 中间按钮
    PHTitleButton *titleButton = [PHTitleButton titleButton];
    // 图标
    [titleButton setImage:PHImage_NaviArrowUp forState:UIControlStateNormal];
    // 文字
    [titleButton setTitle:@"设备回放" forState:UIControlStateNormal];
    // 位置和尺寸
    titleButton.frame = CGRectMake(0, 0, 100, 40);
    [titleButton addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleButton;
}
- (void)titleBtnClick:(PHTitleButton *)sender
{
    sender.selected = !sender.selected;
    if (!sender.selected) {
        [sender setImage:PHImage_NaviArrowUp forState:UIControlStateNormal];
    }
    else {
        [sender setImage:PHImage_NaviArrowDown forState:UIControlStateNormal];
    }
    self.filterView.hidden = !self.filterView.hidden;
    if (self.filterView.hidden) {
        [self.view endEditing:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSArray *historys = nil;
    if (_isPlayBack) {
        historys = [self.hisM selectHistoryInfosWithDevice:[[PHHistoryLoc alloc] init] fromTime:self.startTime toTime:self.endTime orderBy:GMOrderByASC];
    }
    [self.playBackMapView playBackViewWillAppearWithHistorys:historys];    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.playBackMapView playBackViewWillDisappear];
}

#if 1
- (void)loadWithBegin:(NSTimeInterval)begin end:(NSTimeInterval)end
{
    PHLog(@"%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]);

    _isPlayBack = YES;
    if (end > [NSDate date].timeIntervalSince1970) {
        end = [NSDate date].timeIntervalSince1970;
    }
    self.playBackMapView.playTime = 1.0f;
    [self hudShowOnTheFenceMapView:@"搜索中..."];
    self.hisM.startTime = [NSString stringWithFormat:@"%.f",begin];
    self.hisM.endTime = [NSString stringWithFormat:@"%.f",end];
    self.startTime = self.hisM.startTime;
    self.endTime = self.hisM.endTime;
    NSArray *historys = [self.hisM selectHistoryInfosWithDevice:[[PHHistoryLoc alloc] init] fromTime:self.hisM.startTime toTime:self.hisM.endTime orderBy:GMOrderByASC];
    [self beginPlayWithResults:historys];
}
- (void)beginPlayWithResults:(NSArray *)results
{
    if (results.count == 0) {
        self.myHud.labelText = @"没有发现轨迹";
        [self.myHud hide:YES afterDelay:0.6f];
    }
    else {
        self.myHud.labelText = @"轨迹...";
        [self.myHud hide:YES afterDelay:0.6f];
    }
    [self.playBackMapView clearAllOfTheMapViewPloylineAndAnnotations];
    self.playBackMapView.historys = results;

    PHLog(@"___+++___%ld个",(unsigned long)results.count);
}
#endif


- (void)hudShowOnTheFenceMapView:(NSString *)text
{
    self.myHud = [MBProgressHUD showHUDAddedTo:self.playBackMapView animated:YES];
    self.myHud.delegate = self;
    self.myHud.labelText = text;
}

#pragma mark - PHFilterViewDelegate
- (void)filterView:(PHFilterView *)filterView didSelectButtonFrom:(NSUInteger)from to:(NSUInteger)to
{
    PHLog(@"from %ld, to %ld",(unsigned long)from,(unsigned long)to);
}
- (void)filterView:(PHFilterView *)filterView didSelectStatu:(PHFilterViewStatus)status withStartTime:(NSTimeInterval)start endTime:(NSTimeInterval)end
{
    if (start > end && status == PHFilterViewStatuOfSure) {
        [MBProgressHUD showError:@"开始时间必须小于结束时间"];
        filterView.hidden = YES;
        return;
    }
    switch (status) {
        case PHFilterViewStatuOfCancel:
            filterView.hidden = YES;
            break;
        case PHFilterViewStatuOfSure:
            filterView.hidden = YES;
            [self loadWithBegin:start end:end];
            break;
        default:
            break;
    }
}
#pragma mark - MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [self.myHud removeFromSuperview];
    self.myHud = nil;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
//        [self.hisM deleteHistoryInfo];
        [self.playBackMapView clearAllOfTheMapViewPloylineAndAnnotations];
    }
}

@end










