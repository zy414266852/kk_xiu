//
//  LIMAddCoverViewController.m
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/9/8.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import "LIMAddCoverViewController.h"
#import "LIMAddCoverCollectionViewCell.h"
#import "MJRefresh.h"
#import "CcUserModel.h"
#import "HttpClient.h"
#import  <AFNetworking.h>

#import "TZImagePickerController.h"


@interface LIMAddCoverViewController ()<TZImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation LIMAddCoverViewController
- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"%ld/%ld",self.dataSource.count,self.length];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    
    
    [self.dataSource addObject:[UIImage imageNamed:@"cover+"]];
    
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 1.设置列间距
    layout.minimumInteritemSpacing = 1;
    // 2.设置行间距
    layout.minimumLineSpacing = 1;
    // 3.设置每个item的大小
    layout.itemSize = CGSizeMake(kScreenW/3 -2, kScreenW/3 -2);
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
    
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 2, kScreenW, kScreenH -64) collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
//    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(httpForLiveList)];
    UINib *collectNib = [UINib nibWithNibName:NSStringFromClass([LIMAddCoverCollectionViewCell class]) bundle:[NSBundle mainBundle]];
    [_collectionView registerNib:collectNib forCellWithReuseIdentifier:@"LIMAddCoverCollectionViewCell"];
    //    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"LIMLastLiveCollectionViewCell"];
    [self.view addSubview:_collectionView];

//    
    
    //sure Btn
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.backgroundColor = kColor_Default;
    sureBtn.layer.cornerRadius = 37/2.0;
    sureBtn.clipsToBounds = YES;
    [sureBtn setTitle:@"确认上传" forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [sureBtn addTarget:self action:@selector(sureSubmit) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:sureBtn];
    
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-18.5);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(280);
        make.height.mas_equalTo(37);
    }];
    
    [self selectPhoto:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popView) name:@"noti2" object:nil];
    
    // Do any additional setup after loading the view.
}
- (void)sureSubmit{
//    self.backInfo(@"");
//    [self.navigationController popViewControllerAnimated:YES];
    [SVProgressHUD show];
    for (int i = 0 ; i<self.dataSource.count -1; i++) {
        [self changeInfo:i];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//设置分区数（必须实现）
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//设置每个分区的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSLog(@"count = %ld",self.dataSource.count);
    return self.dataSource.count;
}

//设置返回每个item的属性必须实现）
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LIMAddCoverCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LIMAddCoverCollectionViewCell" forIndexPath:indexPath];
    cell.coverImage.image = self.dataSource[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.dataSource.count -1) {
        
        if (self.dataSource.count > self.length) {
            [self showAlertWithMessage:[NSString stringWithFormat:@"您最多上传%ld张图片",self.length]];
        }else{
            [self  selectPhoto:nil];
        }
    }
    
}


- (void)selectPhoto:(UITapGestureRecognizer *)tapGest{
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    picker.delegate = self;
//    //设置选择后的图片可被编辑
//    //    picker.allowsEditing = YES;
//    [self presentViewController:picker animated:YES completion:nil];
    
    TZImagePickerController *imagePickController = [[TZImagePickerController alloc] initWithMaxImagesCount:self.length delegate:self];
    //是否 在相册中显示拍照按钮
    imagePickController.allowTakePicture = YES;
    //是否可以选择显示原图
    imagePickController.allowPickingOriginalPhoto = NO;
    //是否 在相册中可以选择视频
    imagePickController.allowPickingVideo = NO;
    [self presentViewController:imagePickController animated:YES completion:nil];
    
}

#pragma mark - TZImagePickerController Delegate

//相册选取图片
- (void)imagePickerController:(TZImagePickerController *)picker
       didFinishPickingPhotos:(NSArray<UIImage *> *)photos
                 sourceAssets:(NSArray *)assets
        isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto
{
    NSMutableArray *array = [[NSMutableArray alloc]initWithArray:photos];
    [array addObjectsFromArray:self.dataSource];
    self.dataSource = array;
    [self.collectionView reloadData];
    self.title = [NSString stringWithFormat:@"%ld/%ld",self.dataSource.count -1,self.length];
}
//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"]){
        NSLog(@"成功拿到图片");
        //先把图片转成NSData
        UIImage *image;
        image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//        if (image.size.height >image.size.width) {
//            image = [UIImage imageWithCGImage:image.CGImage scale:1 orientation:UIImageOrientationLeft];
//        }
        [picker dismissViewControllerAnimated:YES completion:nil];
        NSMutableArray *array = [[NSMutableArray alloc]initWithObjects:image, nil];
        [array addObjectsFromArray:self.dataSource];
        self.dataSource = array;
        [self.collectionView reloadData];
        self.title = [NSString stringWithFormat:@"%ld/%ld",self.dataSource.count -1,self.length];
    }
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片   %ld",self.dataSource.count);
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (self.dataSource.count ==  1) {
        [self.navigationController popViewControllerAnimated:NO];
    }

}
- (void)changeInfo:(NSInteger)row{
    //UIImage图片转成Base64字符串：
    
    
    CcUserModel *userModel = [CcUserModel defaultClient];
    NSMutableDictionary *paraDict = [[NSMutableDictionary alloc]initWithDictionary:@{}];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictSecret:@{@"iscover":@"0"}]];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictUnSecret]];
    
    
    dispatch_group_t group = dispatch_group_create();
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    dispatch_group_enter(group);
    [manager POST:mUp_cover parameters:paraDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        for (int i = 0; i < 1; i ++) {
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            formatter.dateFormat=@"yyyyMMddHHmmss";
            NSString *str=[formatter stringFromDate:[NSDate date]];
            NSString *fileName=[NSString stringWithFormat:@"%@.jpg",str];
            UIImage *image = self.dataSource[row];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.28);
            [formData appendPartWithFileData:imageData name:@"coverfile" fileName:fileName mimeType:@"image/jpeg"];
//        }
//        [formData appendPartWithFileData:UIImageJPEGRepresentation(self.dataSource[0],0.5) name:@"coverfile" fileName:@"jhiuhiu.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString * rescode = responseObject[@"rescode"];
        if ([rescode isEqualToString:@"1"]) {
//            [self showAlertWithMessage:@"提交成功"];
//            [self showAlertWithBing];
            
        }else{
            NSString * resmsg = responseObject[@"resmsg"];
            NSLog(@"resmsg = %@",resmsg);
            [self showAlertWithMessage:resmsg];
        }
        dispatch_group_leave(group);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@",error);
        [[[UIAlertView alloc]initWithTitle:@"上传失败" message:@"网络故障，请稍后重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        dispatch_group_leave(group);
    }];
    
    WS(ws);
    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
//        [self showAlertWithMessage:@"队列完成"];
        [SVProgressHUD dismiss];
        dispatch_async(dispatch_get_main_queue(), ^{
            [ws popView];
        });

    });
}

- (void)popView{
    [self.navigationController popViewControllerAnimated:NO];
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
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
