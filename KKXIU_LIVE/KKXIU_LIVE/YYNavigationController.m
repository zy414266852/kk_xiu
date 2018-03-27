//
//  KWNavigationController.m
//  KuangWanTV
//
//  Created by 张洋 on 15/11/19.
//  Copyright © 2015年 张洋. All rights reserved.
//

#import "YYNavigationController.h"
#import "UIColor+Extension.h"

@interface YYNavigationController ()

@end

@implementation YYNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.translucent = NO;
    
    
    UILabel *backLabel = [[UILabel alloc]init];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"000000" alpha:0.24].CGColor, (__bridge id)[UIColor colorWithHexString:@"000000" alpha:0].CGColor];
    gradientLayer.locations = @[@0 ,@1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    gradientLayer.frame = CGRectMake(0, 44 , kScreenW, 4);
    [backLabel.layer addSublayer:gradientLayer];
    backLabel.frame = CGRectMake(0, 0, kScreenW, 4);
    [self.navigationBar addSubview:backLabel];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断是否为根据控制器，如果不是跟控制器酒把tabBar隐藏并添加返回按钮
    if (self.viewControllers.count) {
        // 隐藏TabBar
        viewController.hidesBottomBarWhenPushed = YES;
        // 添加返回按钮
        UIButton *nagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        nagBtn.frame = CGRectMake(0, 0, 40, 40);
        nagBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 15);
        [nagBtn setImage:[UIImage imageNamed:@"phonelogin_图层-2"] forState:UIControlStateNormal];
        [nagBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:nagBtn];
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)backAction {
    [self popViewControllerAnimated:YES];
}

-(BOOL)shouldAutorotate
{
    return [self.viewControllers.lastObject shouldAutorotate];
    
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    
    return [self.viewControllers.lastObject supportedInterfaceOrientations];
    
}



-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation

{
    
    return [self.viewControllers.lastObject preferredInterfaceOrientationForPresentation];
    
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
