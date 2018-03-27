//
//  LIMEditViewController.m
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/8/21.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import "LIMEditViewController.h"
#import "CcUserModel.h"
#import "LIMLoginViewController.h"
#import "YYNavigationController.h"
#import "LIMBingPhoneViewController.h"
#import "LIMAuthViewController.h"
#import "LIMTextViewController.h"

#import "LIMEditTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "PickViewController.h"
#import "LIMAgeSelectViewController.h"
#import "LIMAddCoverViewController.h"


#import "TZImagePickerController.h"

#import "HttpClient.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import <AFNetworking.h>
@interface LIMEditViewController ()
<UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate,TZImagePickerControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSArray *iconList;
@property (nonatomic, strong) UIView *imageV;

@property (nonatomic, strong) UIImage *currentImage;

@property (nonatomic, strong) NSString *currentOperation;

@end

@implementation LIMEditViewController

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH -64) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
//        _tableView.bounces = NO;
        _tableView.indicatorStyle =
        _tableView.rowHeight = kScreenW *77/320.0 +10;
        _tableView.tableHeaderView = [self headerForTableView];
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        //        [_tableView registerClass:[YYPInfomationTableViewCell class] forCellReuseIdentifier:@"YYPInfomationTableViewCell"];
        [_tableView registerClass:[LIMEditTableViewCell class] forCellReuseIdentifier:@"LIMEditTableViewCell"];
        [self.view addSubview:_tableView];
        [self.view sendSubviewToBack:_tableView];
        
    }
    return _tableView;
}
- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"资料编辑";
    self.view.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    

    
    self.dataSource = [[NSMutableArray alloc]initWithArray:@[@[@"昵称",@"ID",@"性别",@"年龄",@"城市",@"个性签名",@"绑定电话",@"实名认证"]]];
    //    self.iconList =@[@[@"18511694068",@"男",@"布依族",@"24"],@[@"黑龙江哈尔滨",@"程序员",@"未婚"],@[@"2016-10-23"]];
    
    
    [self tableView];
    
    
    NSMutableArray *imageList = [[NSMutableArray alloc]initWithCapacity:2];
    for (NSDictionary *dict in self.personalModel.coverlist) {
        [imageList addObject:dict[@"cover"]];
    }
    self.iconList = imageList;
    [self setCoverImage:imageList];
    
    // Do any additional setup after loading the view.
}


#pragma mark -
#pragma mark ------------Tableview Delegate----------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LIMEditTableViewCell *editCell = [tableView cellForRowAtIndexPath:indexPath];
        if (indexPath.row == 0) {
            LIMTextViewController *textVc = [[LIMTextViewController alloc]init];
            textVc.titleStr = @"昵称";
            textVc.valueStr = self.personalModel.nickname;
            textVc.length = 8;
            textVc.personalModel = self.personalModel;
            textVc.backInfo = ^(NSString *backValue){
                LIMEditTableViewCell *cell = (LIMEditTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
                cell.infoLabel.text = backValue;
                self.personalModel.nickname = backValue;
            };
            [self.navigationController pushViewController:textVc animated:YES];
        }else if(indexPath.row == 1){
        }else if(indexPath.row == 2){
            if ([editCell.infoLabel.text isEqualToString:@"未知"]) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请选择您的性别" preferredStyle:UIAlertControllerStyleActionSheet];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *okAction1 = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    editCell.infoLabel.text = @"男";
                    self.personalModel.gender = @"1";
                    [self sureLogin];
                }];
                UIAlertAction *okAction2 = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    editCell.infoLabel.text = @"女";
                    self.personalModel.gender = @"2";
                    [self sureLogin];
                }];
                [alert addAction:okAction1];
                [alert addAction:okAction2];
                [alert addAction:cancelAction];
                [self presentViewController:alert animated:YES completion:nil];
            }else{
                [self showAlertWithMessage:@"性别一旦选择，就不能更改"];
            }
        }else if(indexPath.row == 3){
            
            [self  ageChooseBtnAction];
        }else if(indexPath.row == 4){
            [self adressChooseBtnAction];
        }else if(indexPath.row == 5){
            LIMTextViewController *textVc = [[LIMTextViewController alloc]init];
            textVc.titleStr = @"个性签名";
            textVc.valueStr = self.personalModel.personsign;
            textVc.length = 70;
            textVc.personalModel = self.personalModel;
            textVc.backInfo = ^(NSString *backValue){
                LIMEditTableViewCell *cell = (LIMEditTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
                cell.infoLabel.text = backValue;
                
                self.personalModel.personsign = backValue;
            };
            [self.navigationController pushViewController:textVc animated:YES];
        }else if(indexPath.row == 6)
        {
            if ([self.personalModel.mobile isEqualToString:@""]) {
                [self.navigationController pushViewController:[[LIMBingPhoneViewController alloc]init] animated:YES];
            }
            
        }else if(indexPath.row == 7){
            
            
            if ([self.personalModel.authstate isEqualToString:@"0"]) {
                
                [self.navigationController pushViewController:[[LIMAuthViewController alloc]init] animated:YES];

            }else if ([self.personalModel.authstate isEqualToString:@"1"]){
                [self showAlertWithMessage:editCell.infoLabel.text];

            }
            else if ([self.personalModel.authstate isEqualToString:@"2"]){
                [self showAlertWithMessage:editCell.infoLabel.text];

            }
            
            else if ([self.personalModel.authstate isEqualToString:@"-1"]){
                
                [self.navigationController pushViewController:[[LIMAuthViewController alloc]init] animated:YES];
            }
            else {
                [self showAlertWithMessage:@"未知错误"];
            }

        }
    
    
    
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (UIView *)headerForTableView{
    
    CGFloat headH = kScreenW/4.0 *3 -0.5;
    CGFloat bigImageH = kScreenW/2.0  -1;
    CGFloat smallImageH = kScreenW/4.0 -0.5;
    UIView *headerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, headH)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    
    
    
    UIImageView *bigImage = [[UIImageView alloc]init];
    bigImage.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    bigImage.tag = 100;
    bigImage.userInteractionEnabled = YES;
    [headerView addSubview:bigImage];
    [bigImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(0);
        make.top.equalTo(headerView).offset(0);
        make.width.mas_equalTo(bigImageH);
        make.height.mas_equalTo(bigImageH);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bigImageClick:)];
    [bigImage addGestureRecognizer:tap];
    
    // right image
    for (int i = 0; i <4; i++) {
        NSInteger row = i/2; // 行
        NSInteger lineCount = i%2;  // 列
        
        
        UIImageView *small_Image_right = [[UIImageView alloc]init];
        small_Image_right.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        small_Image_right.tag = 101 +i;
        small_Image_right.userInteractionEnabled = YES;
        [headerView addSubview:small_Image_right];
        [small_Image_right mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerView).offset(kScreenW/2.0 + lineCount *(smallImageH +1));
            make.top.equalTo(headerView).offset(row *(smallImageH +1));
            make.width.mas_equalTo(smallImageH);
            make.height.mas_equalTo(smallImageH -1);
        }];
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(smallImageClick:)];
        [small_Image_right addGestureRecognizer:tap1];

    }
    
    
    
    // bottom image
    for (int i = 0; i <4; i++) {
//        NSInteger row = i/4; // 行
        NSInteger lineCount = i%4;  // 列
        
    
        UIImageView *small_Image_bottom = [[UIImageView alloc]init];
        small_Image_bottom.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        small_Image_bottom.tag = 105 +i;
        small_Image_bottom.userInteractionEnabled = YES;
        [headerView addSubview:small_Image_bottom];
        [small_Image_bottom mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerView).offset(lineCount *(smallImageH +0.67));
            make.top.equalTo(headerView).offset(kScreenW/2.0);
            make.width.mas_equalTo(smallImageH);
            make.height.mas_equalTo(smallImageH);
        }];
        if (i != 3) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(smallImageClick:)];
            [small_Image_bottom addGestureRecognizer:tap];
        }else{
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addImageClick:)];
            [small_Image_bottom addGestureRecognizer:tap];
        }
        
        
        if (i == 3) {
            UIImageView *add_Image_bottom = [[UIImageView alloc]init];
            add_Image_bottom.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
            [headerView addSubview:add_Image_bottom];
            [add_Image_bottom mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(headerView).offset(lineCount *(smallImageH +0.67));
                make.top.equalTo(headerView).offset(kScreenW/2.0);
                make.width.mas_equalTo(smallImageH);
                make.height.mas_equalTo(smallImageH);
            }];
            
            
                UIImageView *add_Image = [[UIImageView alloc]init];
                add_Image.image = [UIImage imageNamed:@"+++"];
                [add_Image sizeToFit];
                [headerView addSubview:add_Image];
                [add_Image mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(add_Image_bottom);
                    make.centerY.equalTo(add_Image_bottom);
                    
                }];
            [headerView sendSubviewToBack:add_Image];
            [headerView sendSubviewToBack:add_Image_bottom];
            
            
            
            small_Image_bottom.backgroundColor = [UIColor clearColor];
        }

        
    }
    self.imageV = headerView;

    
    
    
    return headerView;
}
#pragma mark -
#pragma mark ------------TableView DataSource----------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *section_row = self.dataSource[section];
    return section_row.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40 *kiphone6;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 26 ;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 26)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"系统默认第一张图作为封面，也可以自己编辑";
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.textColor = [UIColor colorWithHexString:@"a6a6a6"];
    [headerView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(18);
        make.centerY.equalTo(headerView).offset(1);
        make.width.mas_equalTo(kScreenW -36);
        make.height.mas_equalTo(12);
    }];
    
    
    return headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LIMEditTableViewCell *homeTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"LIMEditTableViewCell" forIndexPath:indexPath];
    
    homeTableViewCell.nameLabel.text = self.dataSource[indexPath.section][indexPath.row];
    if (indexPath.row == 0) {
        homeTableViewCell.infoLabel.text = self.personalModel.nickname;
    }else if (indexPath.row == 1) {
        homeTableViewCell.infoLabel.text = self.personalModel.uid;
        homeTableViewCell.avatar.hidden = YES;
    }
    else if (indexPath.row == 2) {
        
        if ([self.personalModel.gender isEqualToString:@"1"]) {
            homeTableViewCell.infoLabel.text = @"男";
        }else if ([self.personalModel.gender isEqualToString:@"2"]){
            homeTableViewCell.infoLabel.text = @"女";
        }else{
            homeTableViewCell.infoLabel.text = @"未知";
        }
    }
    else if (indexPath.row == 3) {
        if ([self.personalModel.age isEqualToString:@""]) {
            homeTableViewCell.infoLabel.text = @"未知";
        }else{
            homeTableViewCell.infoLabel.text = [NSString stringWithFormat:@"%@岁 %@",self.personalModel.age,self.personalModel.star];
        }
        
    }
    else if (indexPath.row == 4) {
        if ([self.personalModel.city isEqualToString:@""]) {
            homeTableViewCell.infoLabel.text = @"未知";
        }else{
            homeTableViewCell.infoLabel.text = self.personalModel.city;
        }
    }
    else if (indexPath.row == 5) {
        homeTableViewCell.infoLabel.text = self.personalModel.personsign;
    }
    else if (indexPath.row == 6) {
        if ([self.personalModel.mobile isEqualToString:@""]) {
            homeTableViewCell.infoLabel.text = @"未绑定手机";
        }else{
            homeTableViewCell.infoLabel.text = self.personalModel.mobile;
        }

    }
    else if (indexPath.row == 7) {
        if ([self.personalModel.authstate isEqualToString:@"0"]) {
            homeTableViewCell.infoLabel.text = @"未认证";
        }else if ([self.personalModel.authstate isEqualToString:@"1"]){
            homeTableViewCell.infoLabel.text = @"认证中";
        }
        else if ([self.personalModel.authstate isEqualToString:@"2"]){
            homeTableViewCell.infoLabel.text = @"认证通过";
        }

        else if ([self.personalModel.authstate isEqualToString:@"-1"]){
            homeTableViewCell.infoLabel.text = @"认证不通过";
        }
        else {
            homeTableViewCell.infoLabel.text = @"未获取";
        }

        

    }
    
    //    homeTableViewCell.iconV.image = [UIImage imageNamed:self.iconList[indexPath.row]];
    
    return homeTableViewCell;
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self httpForRefresh];
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

- (void)setCoverImage:(NSArray *)imageList{
    NSLog(@"count count %@",imageList);
    self.iconList = imageList;
    NSInteger count = imageList.count;
    for (int i = 0; i<9; i++) {
        
        if (i <count) {
            UIImageView *imageV = (UIImageView *)[self.imageV viewWithTag:100+i];
            [imageV sd_setImageWithURL:[NSURL URLWithString:imageList[i]]];
            if (i == 8) {
                UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(smallImageClick:)];
                [imageV addGestureRecognizer:tap1];
            }
        }else{
            UIImageView *imageV = (UIImageView *)[self.imageV viewWithTag:100+i];
            imageV.image = nil;
            if (i == 8) {
                UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addImageClick:)];
                [imageV addGestureRecognizer:tap1];
            }
        }
        
    }
}
- (void)adressChooseBtnAction{
    PickViewController *alertVC = [[PickViewController alloc]init];
    alertVC.type = @"城市";
    alertVC.count = 3;
    alertVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:alertVC animated:NO completion:nil];
    alertVC.blocksureBtn = ^(id arr) {
        
        NSString *str = [NSString stringWithFormat:@"%@%@%@",arr[0],arr[1],arr[2]];
        NSLog(@"arr == %@",str);
        NSIndexPath *cityIndex = [NSIndexPath indexPathForRow:4 inSection:0];
        LIMEditTableViewCell *cell = (LIMEditTableViewCell *)[self.tableView cellForRowAtIndexPath:cityIndex];
        cell.infoLabel.text = arr[1];
        self.personalModel.city = arr[1];
        self.personalModel.province = arr[0];
//        [self sureLogin];
        [self changeInfoWithKey:@"city"];
    };
    
}
- (void)ageChooseBtnAction{
    LIMAgeSelectViewController *ageVC = [[LIMAgeSelectViewController alloc]init];
    ageVC.lastTime = self.personalModel.birthday;
    
    ageVC.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    ageVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    ageVC.backInfo = ^(NSDictionary *backValue){
        
        
        NSIndexPath *ageIndex = [NSIndexPath indexPathForRow:3 inSection:0];
        LIMEditTableViewCell *cell = (LIMEditTableViewCell *)[self.tableView cellForRowAtIndexPath:ageIndex];
        
        cell.infoLabel.text = [NSString stringWithFormat:@"%@岁 %@",backValue[@"age"],backValue[@"star"]];
        self.personalModel.age = backValue[@"age"];
        self.personalModel.star = backValue[@"star"];
        self.personalModel.birthday = backValue[@"time"];
//        [self sureLogin];
        [self changeInfoWithKey:@"age"];
    };
    [self presentViewController:ageVC animated:NO completion:^{
        
    }];
}
//弹出alert
-(void)showAlertWithReport{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请选择举报类型" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction1 = [UIAlertAction actionWithTitle:@"广告敲诈" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showAlertWithMessage:@"举报成功"];
    }];
    UIAlertAction *okAction2 = [UIAlertAction actionWithTitle:@"淫秽色情" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showAlertWithMessage:@"举报成功"];
    }];
    UIAlertAction *okAction3 = [UIAlertAction actionWithTitle:@"骚扰谩骂" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showAlertWithMessage:@"举报成功"];
    }];
    
    UIAlertAction *okAction4 = [UIAlertAction actionWithTitle:@"反动政治" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showAlertWithMessage:@"举报成功"];
    }];
    UIAlertAction *okAction5 = [UIAlertAction actionWithTitle:@"其他内容" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showAlertWithMessage:@"举报成功"];
    }];
    
    [alert addAction:okAction1];
    [alert addAction:okAction2];
    [alert addAction:okAction3];
    [alert addAction:okAction4];
    [alert addAction:okAction5];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)bigImageClick:(UITapGestureRecognizer *)tap{
    NSInteger index = tap.view.tag -100;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"选择你要进行的操作" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction1 = [UIAlertAction actionWithTitle:@"替换" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       self.currentOperation = self.iconList[index];
        [self selectPhoto:nil];
    }];
    [alert addAction:okAction1];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)smallImageClick:(UITapGestureRecognizer *)tap{
    NSInteger index = tap.view.tag -100;
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"选择你要进行的操作" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction1 = [UIAlertAction actionWithTitle:@"设为封面" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImageView *imageV = (UIImageView *)[self.imageV viewWithTag:index +100];
        
        [self mReplaceCoverForHttp:self.iconList[index] andImage:imageV.image andIsCover:@"1"];
    }];
    UIAlertAction *okAction2 = [UIAlertAction actionWithTitle:@"替换" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        if (self.currentImage != nil) {
//            [self mReplaceCoverForHttp:self.iconList[index] andImage:self.currentImage andIsCover:@"0"];
//        }
        self.currentOperation = self.iconList[index];
        [self selectPhoto:nil];
        
    }];
    UIAlertAction *okAction3 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self mDelCoverHttp:self.iconList[index]];
    }];
    [alert addAction:okAction1];
    [alert addAction:okAction2];
    [alert addAction:okAction3];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];

}
- (void)addImageClick:(UITapGestureRecognizer *)tap{
    LIMAddCoverViewController *addCover = [[LIMAddCoverViewController alloc]init];
    addCover.length = 9 -self.iconList.count;
    [self.navigationController pushViewController:addCover animated:NO];
}
- (void)sureLogin{
    
    CcUserModel *userModel = [CcUserModel defaultClient];
    if (self.personalModel.birthday == nil) {
        self.personalModel.birthday = @"";
    }
    NSLog(@"%@ - %@ - %@ - %@ - %@ - %@ - %@ - %@",self.personalModel.nickname,self.personalModel.gender,self.personalModel.age,self.personalModel.star,self.personalModel.birthday,self.personalModel.province,self.personalModel.city,self.personalModel.personsign);
    
    NSMutableDictionary *paraDict = [[NSMutableDictionary alloc]initWithDictionary:@{}];
    
    
    [paraDict addEntriesFromDictionary:[userModel httpParaDictSecret:@{@"nickname":self.personalModel.nickname,@"gender":self.personalModel.gender,@"age":self.personalModel.age,@"star":self.personalModel.star,@"birthday":self.personalModel.birthday,@"updateprovince":self.personalModel.province,@"updatecity":self.personalModel.city,@"personsign":self.personalModel.personsign}]];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictUnSecret]];
    [[HttpClient defaultClient] requestWithPath:mSaveUserInfo method:1 parameters:paraDict prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString * rescode = responseObject[@"rescode"];
        if ([rescode isEqualToString:@"1"]) {
            [self showAlertWithMessage:@"修改成功"];
            
        }else{
            NSString * resmsg = responseObject[@"resmsg"];
            NSLog(@"resmsg = %@",resmsg);
            [self showAlertWithMessage:resmsg];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)changeInfoWithKey:(NSString *)key{
    
    CcUserModel *userModel = [CcUserModel defaultClient];
    if (self.personalModel.birthday == nil) {
        self.personalModel.birthday = @"";
    }
    NSLog(@"%@ - %@ - %@ - %@ - %@ - %@ - %@ - %@",self.personalModel.nickname,self.personalModel.gender,self.personalModel.age,self.personalModel.star,self.personalModel.birthday,self.personalModel.province,self.personalModel.city,self.personalModel.personsign);
    NSMutableDictionary *paraDict = [[NSMutableDictionary alloc]initWithDictionary:@{}];
    
    NSDictionary *changeDict;
    if ([key isEqualToString:@"age"]) {
        changeDict = @{
                       @"birthday":self.personalModel.birthday,
                       @"age":self.personalModel.age,
                       @"star":self.personalModel.star
                       };
        NSLog(@"%@",self.personalModel.birthday);
    }else if ([key isEqualToString:@"city"]){
        changeDict = @{@"updateprovince":self.personalModel.province,@"updatecity":self.personalModel.city};
    }
    
    [paraDict addEntriesFromDictionary:[userModel httpParaDictSecret:changeDict]];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictUnSecret]];
    [[HttpClient defaultClient] requestWithPath:mSaveUserInfo method:1 parameters:paraDict prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString * rescode = responseObject[@"rescode"];
        if ([rescode isEqualToString:@"1"]) {
            [self showAlertWithMessage:@"修改成功"];
        }else{
            NSString * resmsg = responseObject[@"resmsg"];
            NSLog(@"resmsg = %@",resmsg);
            [self showAlertWithMessage:resmsg];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)httpForRefresh{
    CcUserModel *userModel = [CcUserModel defaultClient];
    NSMutableDictionary *paraDict = [[NSMutableDictionary alloc]initWithDictionary:@{}];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictSecret:@{}]];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictUnSecret]];    [[HttpClient defaultClient] requestWithPath:mPresonal_Info method:1 parameters:paraDict prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString * rescode = responseObject[@"rescode"];
        if ([rescode isEqualToString:@"1"]) {
            NSDictionary *dict =responseObject[@"result"];
            self.personalModel = [LIMPersonalModel mj_objectWithKeyValues:dict];
            NSMutableArray *coverList = [[NSMutableArray alloc]initWithCapacity:2];
            for (NSDictionary *adDict in self.personalModel.coverlist) {
                [coverList addObject:adDict[@"cover"]];
            }
//            _cycleScrollView2.imageURLStringsGroup  = coverList;
            [self setCoverImage:coverList];
        }else{
            NSString * resmsg = responseObject[@"resmsg"];
            NSLog(@"resmsg = %@",resmsg);
            [self showAlertWithMessage:resmsg];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)mDelCoverHttp:(NSString *)imageUrl{
    CcUserModel *userModel = [CcUserModel defaultClient];
    NSMutableDictionary *paraDict = [[NSMutableDictionary alloc]initWithDictionary:@{}];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictSecret:@{@"coverurl":imageUrl}]];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictUnSecret]];    [[HttpClient defaultClient] requestWithPath:mDelCover method:1 parameters:paraDict prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString * rescode = responseObject[@"rescode"];
        if ([rescode isEqualToString:@"1"]) {
            [self httpForRefresh];
        }else{
            NSString * resmsg = responseObject[@"resmsg"];
            NSLog(@"resmsg = %@",resmsg);
            [self showAlertWithMessage:resmsg];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)mReplaceCoverForHttp:(NSString *)imageUrl andImage:(UIImage *)image andIsCover:(NSString *)isCover{
    CcUserModel *userModel = [CcUserModel defaultClient];
    NSMutableDictionary *paraDict = [[NSMutableDictionary alloc]initWithDictionary:@{}];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictSecret:@{@"coverurl":imageUrl,@"iscover":isCover}]];
    [paraDict addEntriesFromDictionary:[userModel httpParaDictUnSecret]];
    
    
    
    NSLog(@"replace =  %@",isCover);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    [manager POST:mReplaceCover parameters:paraDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        formatter.dateFormat=@"yyyyMMddHHmmss";
        NSString *str=[formatter stringFromDate:[NSDate date]];
        NSString *fileName=[NSString stringWithFormat:@"%@.jpg",str];
        NSData *imageData = UIImageJPEGRepresentation(image, 0.28);
        [formData appendPartWithFileData:imageData name:@"coverfile" fileName:fileName mimeType:@"image/jpeg"];


    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString * rescode = responseObject[@"rescode"];
        if ([rescode isEqualToString:@"1"]) {
//            [self showAlertWithMessage:@"提交成功"];
            [self httpForRefresh];
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

- (void)selectPhoto:(UITapGestureRecognizer *)tapGest{
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    picker.delegate = self;
//    //设置选择后的图片可被编辑
//    //    picker.allowsEditing = YES;
//    [self presentViewController:picker animated:YES completion:nil];
    TZImagePickerController *imagePickController = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
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
    
    UIImage *image = photos[0];
    if ([self.currentOperation isEqualToString:self.iconList[0]]) {
        [self mReplaceCoverForHttp:self.currentOperation andImage:image andIsCover:@"1"];
    }else{
        [self mReplaceCoverForHttp:self.currentOperation andImage:image andIsCover:@"0"];
    }
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
        if ([self.currentOperation isEqualToString:self.iconList[0]]) {
            [self mReplaceCoverForHttp:self.currentOperation andImage:image andIsCover:@"1"];
        }else{
            [self mReplaceCoverForHttp:self.currentOperation andImage:image andIsCover:@"0"];
        }
    }
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    self.currentImage = nil;
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
