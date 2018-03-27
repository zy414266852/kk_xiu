//
//  LIMAuthViewController.m
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/9/6.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import "LIMAuthViewController.h"
#import "CcUserModel.h"
#import "HttpClient.h"
#import "LIMFollowModel.h"
#import <MJExtension.h>
#import "UIBarButtonItem+Helper.h"
#import "LIMAuthTableViewCell.h"
#import "LIMPayListViewController.h"
#import  <AFNetworking.h>
#import "LIMTextViewController.h"

@interface LIMAuthViewController ()<UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *infoArr;
@property (nonatomic, strong) UIImage *chooseImage;


@property (nonatomic, strong) UIView *photoView;
@property (nonatomic, assign) NSInteger currentSelect;
//@property (nonatomic, strong) NSMutableArray *infodataSource;

@end

@implementation LIMAuthViewController


- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"实名认证";
    self.infoArr = @[@"姓名",@"身份证",@"开户行名称",@"银行账号"];
    [self.dataSource addObjectsFromArray:@[@"姓名",@"请输入18位身份证号",@"工商银行",@"请输入银行卡号"]];
    [self creteTableView];
    //    [self tableFootView];
    // Do any additional setup after loading the view.
}
- (void)creteTableView{
    UITableView* tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW,kScreenH -64) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = kScreenW *77/320.0 +10;
    tableView.bounces = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.tableHeaderView = [self tableHeader];
    tableView.tableFooterView = [self tableFootView];
    [tableView registerClass:[LIMAuthTableViewCell class] forCellReuseIdentifier:@"LIMAuthTableViewCell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}
#pragma -tableview DELEGETE
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [self payMoney:indexPath.row];
    if(indexPath.row == 0){
        LIMTextViewController *textVc = [[LIMTextViewController alloc]init];
        textVc.titleStr = self.infoArr[indexPath.row];
        textVc.valueStr = @"";
        textVc.length = 70;
        textVc.backInfo = ^(NSString *backValue){
            LIMAuthTableViewCell *hotLiveCell  = (LIMAuthTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            hotLiveCell.infoLabel.text = backValue;
        };
        [self.navigationController pushViewController:textVc animated:YES];
    }else if(indexPath.row == 1){
        LIMTextViewController *textVc = [[LIMTextViewController alloc]init];
        textVc.titleStr = self.infoArr[indexPath.row];
        textVc.valueStr = @"";
        textVc.length = 70;
        textVc.backInfo = ^(NSString *backValue){
            LIMAuthTableViewCell *hotLiveCell  = (LIMAuthTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            hotLiveCell.infoLabel.text = backValue;
        };
        [self.navigationController pushViewController:textVc animated:YES];
    }
    else if(indexPath.row == 2){
        LIMTextViewController *textVc = [[LIMTextViewController alloc]init];
        textVc.titleStr = self.infoArr[indexPath.row];
        textVc.valueStr = @"";
        textVc.length = 70;
        textVc.backInfo = ^(NSString *backValue){
            LIMAuthTableViewCell *hotLiveCell  = (LIMAuthTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            hotLiveCell.infoLabel.text = backValue;
        };
        [self.navigationController pushViewController:textVc animated:YES];
    }
    else if(indexPath.row == 3){
        LIMTextViewController *textVc = [[LIMTextViewController alloc]init];
        textVc.titleStr = self.infoArr[indexPath.row];
        textVc.valueStr = @"";
        textVc.length = 70;
        textVc.backInfo = ^(NSString *backValue){
            LIMAuthTableViewCell *hotLiveCell  = (LIMAuthTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            hotLiveCell.infoLabel.text = backValue;
        };
        [self.navigationController pushViewController:textVc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
#pragma - tableview DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.infoArr.count;
}
- (UIView *)tableHeader{
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
    headerView.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1];
    [self.view addSubview:headerView];
    
    
    UILabel *promptLabel = [[UILabel alloc]init];
    promptLabel.text = @"为保证您的合法权益，请提交真实有效的身份信息";
    promptLabel.font = [UIFont systemFontOfSize:12];
    promptLabel.textColor = [UIColor colorWithHexString:@"ffbd0c"];
    [headerView addSubview:promptLabel];
    CGFloat labelW = [promptLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 12) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:promptLabel.font} context:nil].size.width;
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView).offset(0);
        make.left.equalTo(headerView).offset(18);
        make.width.mas_equalTo(labelW +10);
        make.height.mas_equalTo(12);
    }];
    return headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LIMAuthTableViewCell *hotLiveCell = [tableView dequeueReusableCellWithIdentifier:@"LIMAuthTableViewCell" forIndexPath:indexPath];
    hotLiveCell.nameLabel.text = self.infoArr[indexPath.row];
    hotLiveCell.infoLabel.text = self.dataSource[indexPath.row];
    ;
    return hotLiveCell;
}
- (UIView *)tableFootView{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 403)];
    
    //sure Btn
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.backgroundColor = kColor_Default;
    sureBtn.layer.cornerRadius = 37/2.0;
    sureBtn.clipsToBounds = YES;
    [sureBtn setTitle:@"提  交" forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [sureBtn addTarget:self action:@selector(changeInfo) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footView addSubview:sureBtn];
    
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(footView).offset(-18.5);
        make.centerX.equalTo(footView);
        make.width.mas_equalTo(280);
        make.height.mas_equalTo(37);
    }];
    UIView *photoView = [[UIView alloc]init];
    photoView.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
    [footView addSubview:photoView];
    [photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footView).offset(0);
        make.centerX.equalTo(footView);
        make.width.mas_equalTo(kScreenW);
        make.height.mas_equalTo(270.5);
    }];
    self.photoView = photoView;
    
    NSArray *promptArr  = @[@"1.身份证正面照",@"2.身份证反面照",@"3.手持身份半身照"];
    for (int i = 0; i<3; i++) {
        int row = i/2;  // 行
        int line = i%2; //
        
        
        
        UIView *photoPartView = [[UIView alloc]init];
        //        photoPartView.backgroundColor = [UIColor randomColor];
        [photoView addSubview:photoPartView];
        [photoPartView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(photoView).offset(135 *row);
            make.left.equalTo(photoView).offset(kScreenW/2.0 *line);
            make.width.mas_equalTo(kScreenW/2.0);
            make.height.mas_equalTo(135);
        }];
        
        UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectPhoto:)];
        
        photoPartView.tag = 200 +i;
        [photoPartView addGestureRecognizer:tapGest];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = promptArr[i];
        titleLabel.textColor = [UIColor colorWithHexString:@"c7c7c7"];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:11];
        [photoPartView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(photoPartView).offset(10);
            make.left.equalTo(photoPartView).offset(0);
            make.width.mas_equalTo(kScreenW/2.0);
            make.height.mas_equalTo(11);
        }];
        
        UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"addphoto"]];
//        [imageV sizeToFit];
//        imageV.layer.cornerRadius = 15;
//        imageV.clipsToBounds = YES;
        imageV.tag = 100;
        [photoPartView addSubview:imageV];
        
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(5.5);
            make.centerX.equalTo(photoPartView).offset(0);
            make.width.mas_equalTo(348/2.0);
            make.height.mas_equalTo(207/2.0);
        }];
        
        
    }
    
    // 高度
    UILabel *promptText = [[UILabel alloc]init];
    promptText.text = @"1.客服QQ: 414266852";
    promptText.font = [UIFont systemFontOfSize:12];
    promptText.textColor = [UIColor colorWithHexString:@"7b7b7b"];
    promptText.textAlignment = NSTextAlignmentLeft;
    [footView addSubview:promptText];
    [promptText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footView).offset(12);
        make.top.equalTo(photoView.mas_bottom).offset(8.5);
        make.size.mas_equalTo(CGSizeMake(kScreenW, 12));
    }];
    
    
    UILabel *prompt2Text = [[UILabel alloc]init];
    prompt2Text.text = @"2.如果您在过程中遇到问题，请及时联系官方客服。";
    prompt2Text.font = [UIFont systemFontOfSize:12];
    prompt2Text.textColor = [UIColor colorWithHexString:@"7b7b7b"];
    prompt2Text.textAlignment = NSTextAlignmentLeft;
    [footView addSubview:prompt2Text];
    [prompt2Text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(promptText.mas_left).offset(0);
        make.top.equalTo(promptText.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(kScreenW, 12));
    }];
    
    UILabel *prompt3Text = [[UILabel alloc]init];
    prompt3Text.text = @"3.温馨提示:请提交真实有效的身份信息！";
    prompt3Text.font = [UIFont systemFontOfSize:12];
    prompt3Text.textColor = [UIColor colorWithHexString:@"7b7b7b"];
    prompt3Text.textAlignment = NSTextAlignmentLeft;
    [footView addSubview:prompt3Text];
    [prompt3Text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(promptText.mas_left).offset(0);
        make.top.equalTo(prompt2Text.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(kScreenW, 12));
    }];
    
    
    return footView;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
- (void)pushToRecard{
    [self.navigationController pushViewController:[[LIMPayListViewController alloc]init] animated:YES];
}
- (void)payMoney:(NSInteger)row{
    
}
- (void)sureLogin{
    
}


- (void)selectPhoto:(UITapGestureRecognizer *)tapGest{
    self.currentSelect = tapGest.view.tag -200;
    NSLog(@"上传第几张 %ld",self.currentSelect);
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
//    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
    
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
//        
//        NSData *data;
//        if (UIImagePNGRepresentation(image) == nil){
//            data = UIImageJPEGRepresentation(image, 1.0);
//        }else{
//            data = UIImagePNGRepresentation(image);
//        }
        
//        //图片保存的路径
//        //这里将图片放在沙盒的documents文件夹中
//        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//        
//        //文件管理器
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        
//        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
//        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
//        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
//        
//        //得到选择后沙盒中图片的完整路径
//        _filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        /****图片本地持久化*******/
        
        
        
        //        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        //        NSString *myfilePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"picture.png"]];
        //        // 保存文件的名称
        //        [UIImagePNGRepresentation(self.chooseImage)writeToFile: myfilePath  atomically:YES];
        //        NSUserDefaults *userDef= [NSUserDefaults standardUserDefaults];
        //        [userDef setObject:myfilePath forKey:kImageFilePath];
        
        //创建一个选择后图片的小图标放在下方
        //类似微薄选择图后的效果
        
        
        
        UIView *photoPartView = (UIView *)[self.photoView viewWithTag:self.currentSelect +200];
        UIImageView *imageV = (UIImageView *)[photoPartView viewWithTag:100];
        imageV.image = [image  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
    }
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)changeInfo{
    //UIImage图片转成Base64字符串：
    
    NSLog(@"开始上传");
    NSMutableArray *imageArr = [[NSMutableArray alloc]initWithCapacity:2];
    for (int i = 0; i<3; i++) {
        UIView *photoPartView = (UIView *)[self.photoView viewWithTag:i +200];
        UIImageView *imageV = (UIImageView *)[photoPartView viewWithTag:100];        
        UIImage *sizeImage = imageV.image;
        CGFloat imageH = sizeImage.size.height/sizeImage.size.width * 100;
        sizeImage = [self compressOriginalImage:sizeImage toSize:CGSizeMake(100, imageH)
                     ];
        [imageArr addObject:sizeImage];
    }
    
    CcUserModel *userModel = [CcUserModel defaultClient];
    
    
    NSMutableDictionary *paraDict = [[NSMutableDictionary alloc]initWithDictionary:@{}];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictSecret:@{@"realname":[self returnCellInfo:0],@"cid":[self returnCellInfo:1],@"openbank":[self returnCellInfo:2],@"bankaccount":[self returnCellInfo:3]}]];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictUnSecret]];

    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    [manager POST:mAuth parameters:paraDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(imageArr[0],0.5) name:@"cardphoto1" fileName:@"cardphoto1.jpg" mimeType:@"image/jpeg"];
        [formData appendPartWithFileData:UIImageJPEGRepresentation(imageArr[1],0.5) name:@"cardphoto2" fileName:@"cardphoto1.jpg" mimeType:@"image/jpeg"];
        [formData appendPartWithFileData:UIImageJPEGRepresentation(imageArr[2],0.5) name:@"cardphoto3" fileName:@"cardphoto1.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString * rescode = responseObject[@"rescode"];
        if ([rescode isEqualToString:@"1"]) {
//            [self showAlertWithMessage:@"提交成功"];
            [self showAlertWithBing];
        }else{
            NSString * resmsg = responseObject[@"resmsg"];
            NSLog(@"resmsg = %@",resmsg);
            [self showAlertWithMessage:resmsg];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@",error);
        [[[UIAlertView alloc]initWithTitle:@"上传失败" message:@"网络故障，请稍后重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }];
}
-(UIImage *)compressOriginalImage:(UIImage *)image toSize:(CGSize)size{
    UIImage * resultImage = image;
    UIGraphicsBeginImageContext(size);
    [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIGraphicsEndImageContext();
    return image;
}
- (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size{
    NSData * data = UIImageJPEGRepresentation(image, 1.0);
    CGFloat dataKBytes = data.length/1000.0;
    CGFloat maxQuality = 0.9f;
    CGFloat lastData = dataKBytes;
    while (dataKBytes > size && maxQuality > 0.01f) {
        maxQuality = maxQuality - 0.01f;
        data = UIImageJPEGRepresentation(image, maxQuality);
        dataKBytes = data.length / 1000.0;
        if (lastData == dataKBytes) {
            break;
        }else{
            lastData = dataKBytes;
        }
    }
    return data;
}
- (NSString *)returnCellInfo:(NSInteger)row{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    LIMAuthTableViewCell *hotLiveCell  = (LIMAuthTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    return hotLiveCell.infoLabel.text;
}

//弹出alert
-(void)showAlertWithBing{
    //    [self offThisView];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"提交成功，等待审核😊" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
 
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

