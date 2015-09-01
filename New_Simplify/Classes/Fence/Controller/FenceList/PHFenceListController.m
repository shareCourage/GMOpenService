//
//  PHFenceListController.m
//  Demo_Monitor
//
//  Created by Kowloon on 15/4/7.
//  Copyright (c) 2015年 Goome. All rights reserved.
//

#define PH_FenceListTitle @"设备围栏"
#define PH_MBProgress_Deleting @"删除中..."
#define PH_MBProgress_SuccessOfDelete @"删除成功..."
#define PH_MBProgress_FailureOfDelete @"删除失败..."

#import "PHFenceListController.h"
#import "PHDevFenceInfo.h"
#import "PHFenceMapController.h"
#import "MJRefresh.h"

@interface PHFenceListController ()<PHFenceMapControllerDelegate,UIGestureRecognizerDelegate>
{
    BOOL _lanchingPHFenceMapControllerDelegate;//这个参数只用在PHFenceMapControllerDelegate协议方法里面，当该协议被触发时，设置该值为YES
}
@property(nonatomic, strong)NSMutableArray *dataSource;//tableView的数据源
@property(nonatomic, strong)NSString *fenceFilePath;//文件路径
@end

@implementation PHFenceListController
#if 0
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    PHLog(@"%@",touch.view);
    return  ![NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"];
}
- (void)testTap
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}
- (void)tapClick
{
    PHLog(@"tapClick");
}
#endif

- (void)dealloc
{
    PHLog(@"PHFenceListController.h->dealloc");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = PH_FenceListTitle;
    [self barButtonItemImplementation];
    _lanchingPHFenceMapControllerDelegate = NO;
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
    if (_lanchingPHFenceMapControllerDelegate) {//只要这个值为YES，则自动开始下拉刷新，不需要用户自己操作
        [self.tableView.header beginRefreshing];
    }
    _lanchingPHFenceMapControllerDelegate = NO;//同时，必须至为NO，是否刷新,必须有代理决定
}
/**
 *  导航栏UIBarButtonItem的放置
 */
- (void)barButtonItemImplementation
{
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteFence)];
    deleteItem.tintColor = [UIColor blueColor];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFence)];
    addItem.tintColor = [UIColor blueColor];
    self.navigationItem.rightBarButtonItem = addItem;
//    self.navigationItem.rightBarButtonItems = @[deleteItem, addItem];
}
//UIBarButtonItem->deleteFence执行，开启tableView的删除模式
- (void)deleteFence
{
    [self.tableView setEditing:!self.tableView.isEditing animated:YES];
}
//UIBarButtonItem->addFence跳转至PHFenceMapController来添加围栏
- (void)addFence
{
    PHFenceMapController *map = [[PHFenceMapController alloc] init];
    map.title = @"创建围栏";
    map.delegate = self;
    [self.navigationController pushViewController:map animated:YES];
}
/**
 *  网络获取围栏列表的信息,并且将数据存储到数据库当中
 */
- (void)displayFenceList
{
    PH_WS(ws);//相当于 __weak ws = self;防止block导致的循环引用
    GMFenceManager *fence = [GMFenceManager manager];
    fence.mapType = GMMapTypeOfBAIDU;
#if 0
    [fence inquireFenceWithDeviceId:[PHTool getDeviceIdFromUserDefault] successBlock:^(NSDictionary *dict){
        if (dict) {
            [ws.dataSource removeAllObjects];
            ws.dataSource = nil;
            ws.dataSource = [[NSMutableArray alloc] initWithArray:[PHDevFenceInfo createWithDict:dict]];
            if (ws.dataSource.count != 0) {
                if ([PHTool encoderObjectArray:ws.dataSource path:ws.fenceFilePath]) {
                    PHLog(@"归档成功");
                }
                else{
                    PHLog(@"归档失败");
                }
            }
            [ws.tableView.header endRefreshing];
            [ws.tableView reloadData];
        }
    } failureBlock:^(NSError *error) {
        if (error) {
            PHLog(@"%@",error);
        }
        [ws.tableView.header endRefreshing];
    }];
#endif
    [fence inquireFenceWithDeviceId:[PHTool getDeviceIdFromUserDefault] successBlockArray:^(NSArray *array) {
        if (array.count != 0) {
            [ws.dataSource removeAllObjects];
            ws.dataSource = nil;
            ws.dataSource = [[NSMutableArray alloc] initWithArray:array];
            if (ws.dataSource.count != 0) {
                if ([PHTool encoderObjectArray:ws.dataSource path:ws.fenceFilePath]) {
                    PHLog(@"归档成功");
                }
                else{
                    PHLog(@"归档失败");
                }
            }
            [ws.tableView.header endRefreshing];
            [ws.tableView reloadData];
        }
    } failureBlock:^(NSError *error) {
        if (error) {
            PHLog(@"%@",error);
        }
        [ws.tableView.header endRefreshing];
    }];
}



#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"fence";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    GMDeviceFence *devFence = self.dataSource[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@,围栏号:%@",devFence.name.length != 0 ? devFence.name : @"无" ,devFence.fenceid];
    cell.detailTextLabel.text = devFence.area;
#if 0
    PHDevFenceInfo *fenceInfo = self.dataSource[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@,围栏号:%@",fenceInfo.name.length != 0 ? fenceInfo.name : @"无" ,fenceInfo.fenceid];
    cell.detailTextLabel.text = fenceInfo.area;
#endif
    return cell;
}

#if 1
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
#endif

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
#if 1
        [MBProgressHUD showMessage:PH_MBProgress_Deleting toView:self.view];
        PH_WS(ws);
        GMFenceManager *fence = [GMFenceManager manager];
        [fence deleteFenceWithFenceId:fenceInfo.fenceid completionBlock:^(BOOL success) {
            [MBProgressHUD hideHUDForView:ws.view animated:YES];
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
#endif
        
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PHDevFenceInfo *fenceInfo = self.dataSource[indexPath.row];
    PHFenceMapController *map = [[PHFenceMapController alloc] init];
    map.delegate = self;
    map.title = [NSString stringWithFormat:@"%@",fenceInfo.name.length != 0 ? fenceInfo.name : fenceInfo.fenceid];
    map.fenceInfo = fenceInfo;
    [self.navigationController pushViewController:map animated:YES];
}


#pragma mark - PHFenceMapControllerDelegate
- (void)fenceMapController:(PHFenceMapController *)controller
{
    _lanchingPHFenceMapControllerDelegate = YES;
}
@end






