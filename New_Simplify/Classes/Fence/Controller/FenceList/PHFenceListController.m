//
//  PHFenceListController.m
//  Demo_Monitor
//
//  Created by Kowloon on 15/4/7.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#define PH_FenceListTitle @"围栏列表"
#define PH_MBProgress_Deleting @"删除中..."
#define PH_MBProgress_SuccessOfDelete @"删除成功..."
#define PH_MBProgress_FailureOfDelete @"删除失败..."

#import "PHFenceListController.h"
#import "PHDevFenceInfo.h"
#import "MJRefresh.h"
#import "PHFenceTableViewCell.h"
#import "PHFenceModifyMapController.h"

@interface PHFenceListController () <UIGestureRecognizerDelegate>

@property(nonatomic, strong)NSString *fenceFilePath;//文件路径
@end

@implementation PHFenceListController
- (void)dealloc
{
    PHLog(@"PHFenceListController.h->dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = PH_FenceListTitle;
    [self barButtonItemImplementation];
    NSString *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    self.fenceFilePath = [documents stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.arc",[PHTool getDeviceIdFromUserDefault]]];
    PH_WS(ws);
    [self.tableView addLegendHeaderWithRefreshingBlock:^{//tableView添加下拉刷新
        [ws displayFenceList];
    }];
    NSMutableArray *mutableArray = [PHTool decoderObjectPath:self.fenceFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.fenceFilePath] && mutableArray.count != 0) {//当满足该文件存在，且文件解析的数据不为空两个条件是，将数据赋值给dataSource
        self.dataSource = mutableArray;
    }
    else{//否则，开启刷新
        [self.tableView.header beginRefreshing];
    }
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.isFenceArgumentChanged) {//只要这个值为YES，则自动开始下拉刷新，不需要用户自己操作
        [self.tableView.header beginRefreshing];
    }
    self.fenceArgumentChanged = NO;//同时，必须至为NO，是否刷新,必须有代理决定
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.tableView.header endRefreshing];
}
/**
 *  导航栏UIBarButtonItem的放置
 */
- (void)barButtonItemImplementation
{
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFence)];
    addItem.tintColor = [UIColor blueColor];
    self.navigationItem.rightBarButtonItem = addItem;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"围栏列表" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
}

//UIBarButtonItem->addFence跳转至PHFenceMapController来添加围栏
- (void)addFence
{
    PHFenceModifyMapController *addMap = [[PHFenceModifyMapController alloc] init];
//    [self.navigationController pushViewController:map animated:YES];

    [self.navigationController pushViewController:addMap animated:YES];
}
/**
 *  网络获取围栏列表的信息,并且将数据存储到数据库当中
 */
- (void)displayFenceList
{
    GMFenceManager *fence = [GMFenceManager manager];
    fence.mapType = GMMapTypeOfBAIDU;
    [fence obtainFenceWithDeviceId:[PHTool getDeviceIdFromUserDefault] successBlockArray:^(NSArray *array) {
        if (array.count != 0) {
            [self.dataSource removeAllObjects];
            self.dataSource = nil;
            self.dataSource = [[NSMutableArray alloc] initWithArray:array];
            if (self.dataSource.count != 0) {
                [PHTool encoderObjectArray:self.dataSource path:self.fenceFilePath] ? PHLog(@"归档成功") : PHLog(@"归档失败");
            }
            [self.tableView.header endRefreshing];
            [self.tableView reloadData];
        }
    } failureBlock:^(NSError *error) {
        if (error) PHLog(@"%@",error);
        [self.tableView.header endRefreshing];
    }];
}



#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PHFenceTableViewCell *cell = [PHFenceTableViewCell cellWithTableView:tableView];
    GMDeviceFence *devFence = self.dataSource[indexPath.row];
    cell.devFence = devFence;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    PHDevFenceInfo *fenceInfo = self.dataSource[indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        /**
         *1、删除数据源
         *2、tableView的删除
         *3、删除服务器上的数据
         *4、如果做了本地数据库保存，同样需要删除
         */
        PH_WS(ws);
        GMFenceManager *fence = [GMFenceManager manager];
        [fence deleteFenceWithFenceId:fenceInfo.fenceid completionBlock:^(BOOL success) {
            if (success) {
                [ws.dataSource removeObjectAtIndex:indexPath.row];//1 删除数据源
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];//2 tableView的删除
                [PHTool encoderObjectArray:ws.dataSource path:ws.fenceFilePath];//4、对数据的重新归档，就相当于删除
                [MBProgressHUD showSuccess:PH_MBProgress_SuccessOfDelete toView:ws.view];
                PHLog(@"delete success");
            }
            else {
                [MBProgressHUD showError:PH_MBProgress_FailureOfDelete toView:ws.view];
            }
            
        } failureBlock:^(NSError *error) {
            if (error) {
                [MBProgressHUD showError:PH_MBProgress_FailureOfDelete toView:ws.view];
                PHLog(@"delete failure");
            }
        }];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GMDeviceFence *fenceInfo = self.dataSource[indexPath.row];
    PHFenceModifyMapController *modify = [[PHFenceModifyMapController alloc] init];
    modify.fenceInfo = fenceInfo;
    [self.navigationController pushViewController:modify animated:YES];

}


@end






