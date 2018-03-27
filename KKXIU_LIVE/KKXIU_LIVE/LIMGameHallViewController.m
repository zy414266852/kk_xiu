//
//  LIMGameHallViewController.m
//  KKXIU_LIVE
//
//  Created by 张洋 on 2018/1/9.
//  Copyright © 2018年 张洋. All rights reserved.
//

#import "LIMGameHallViewController.h"
#import "LIMLastLiveCollectionViewCell.h"
#import "HttpClient.h"
#import "MJRefresh.h"
#import "LIMLiveListModel.h"
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
#import "LIMLiveViewController.h"
#import "LIMWebGameViewController.h"

#import "LIMGameHomeModel.h"
#import "MJRefresh.h"


@interface LIMGameHallViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation LIMGameHallViewController
- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 1.设置列间距
    layout.minimumInteritemSpacing = 2;
    // 2.设置行间距
    layout.minimumLineSpacing = 2;
    // 3.设置每个item的大小
    layout.itemSize = CGSizeMake(kScreenW/2 -1, kScreenW/2 -1);
    //    // 4.设置Item的估计大小,用于动态设置item的大小，结合自动布局（self-sizing-cell）
    //    layout.estimatedItemSize = CGSizeMake(320, 60);
    // 5.设置布局方向
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //    // 6.设置头视图尺寸大小
    //    layout.headerReferenceSize = CGSizeMake(50, 50);
    //    // 7.设置尾视图尺寸大小
    //    layout.footerReferenceSize = CGSizeMake(50, 50);
    // 8.设置分区(组)的EdgeInset（四边距）
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //    layout.headerReferenceSize = CGSizeMake(0, 0);
    //    layout.footerReferenceSize = CGSizeMake(0, 0);
    
    //    // 9.10.设置分区的头视图和尾视图是否始终固定在屏幕上边和下边
    //    layout.sectionFootersPinToVisibleBounds = YES;
    //    layout.sectionHeadersPinToVisibleBounds = YES;
    
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH -64 -49) collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(httpForLiveList)];
    UINib *collectNib = [UINib nibWithNibName:NSStringFromClass([LIMLastLiveCollectionViewCell class]) bundle:[NSBundle mainBundle]];
    [_collectionView registerNib:collectNib forCellWithReuseIdentifier:@"LIMLastLiveCollectionViewCell"];
    //    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"LIMLastLiveCollectionViewCell"];
    [self.view addSubview:_collectionView];
    
    [self httpForLiveList];
    // Do any additional setup after loading the view.
}
-  (void)setCollectFlow{
    
}
//设置分区数（必须实现）
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//设置每个分区的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSLog(@"count = %ld",self.dataSource.count);
    return self.dataSource.count;
//    return 1;
}

//设置返回每个item的属性必须实现）
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LIMGameHomeModel *model = self.dataSource[indexPath.row];
    LIMLastLiveCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LIMLastLiveCollectionViewCell" forIndexPath:indexPath];
    //    @property (weak, nonatomic) IBOutlet UIImageView *backImage;
    //    @property (weak, nonatomic) IBOutlet UILabel *nameLabel;
    //    @property (weak, nonatomic) IBOutlet UILabel *minuteLabel;
    [cell.backImage sd_setImageWithURL:[NSURL URLWithString:model.gameimg]];
    cell.nameLabel.text = model.gamename;
    cell.minuteLabel.text = model.gameusercount;
//    cell.backgroundColor = [UIColor redColor];
//    cell.backImage.image = [UIImage imageNamed:@"AppIcon"];
//    cell.nameLabel.text = @"大话西游";
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)httpForLiveList{
    //    if (self.dataSource.count >0) {
    //        [self.dataSource removeAllObjects];
    //        [self.collectionView.mj_header beginRefreshing];
    //    }
    [self.dataSource removeAllObjects];
    WS(ws);
    
    // 首页直播列表
    //    NSDictionary *paraDict = @{
    //                               mAllPara,
    //                               @"pageindex":@"1",
    //                               @"pagesize":@"20"
    //                               };
    
    CcUserModel *userModel = [CcUserModel defaultClient];
    NSMutableDictionary *paraDict = [[NSMutableDictionary alloc]initWithDictionary:@{
                                                                                     
                                                                                     }];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictSecret:@{
                                                                       }]];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictUnSecret]];
    
    
    
    [[HttpClient defaultClient] requestWithPath:mGame_Home method:1 parameters:paraDict prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.collectionView.mj_header endRefreshing];
        [self.dataSource removeAllObjects];
//        NSLog(@"%@",responseObject);
        
        NSString * rescode = responseObject[@"rescode"];
        if ([rescode isEqualToString:@"1"]) {
            NSArray *liveList = responseObject[@"result"][@"list"];
            for (NSDictionary *dict in liveList) {
                LIMGameHomeModel *liveModel = [LIMGameHomeModel mj_objectWithKeyValues:dict];
                [self.dataSource addObject:liveModel];
            }
            [self.collectionView reloadData];
        }else{
            NSString * resmsg = responseObject[@"resmsg"];
            NSLog(@"resmsg = %@",resmsg);
            [self showAlertWithMessage:resmsg];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    LIMLiveViewController *liveVC = [[LIMLiveViewController alloc]init];
//
    LIMGameHomeModel *liveModel = self.dataSource[indexPath.row];
//    liveVC.liveuid = liveModel.uid;
//    liveVC.roomid  = liveModel.roomid;
//    liveVC.coverUrl = liveModel.cover;
//    [self presentViewController:liveVC animated:YES completion:^{
//
//    }];
    
    LIMWebGameViewController *webGameVC = [[LIMWebGameViewController alloc] init];
    webGameVC.gameid = liveModel.gameid;
    webGameVC.gameurl = liveModel.gameurl;
    webGameVC.serverinfo = liveModel.serverinfo;
    webGameVC.screen = liveModel.screen;
    [self.navigationController pushViewController:webGameVC animated:YES];
}
//弹出alert
-(void)showAlertWithMessage:(NSString*)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    //            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    //            [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)httpForRefresh{
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

