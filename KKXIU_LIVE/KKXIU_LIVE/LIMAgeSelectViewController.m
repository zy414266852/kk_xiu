//
//  LIMAgeSelectViewController.m
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/9/8.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import "LIMAgeSelectViewController.h"

@interface LIMAgeSelectViewController ()
@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, strong) NSString *ageStr;
@property (nonatomic, strong) NSString *starStr;
@property (nonatomic, strong) NSString *timeStr;



@property (nonatomic, strong) UILabel *ageLabel;
@property (nonatomic, strong) UILabel *starLabel;

@end

@implementation LIMAgeSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
//    
//    [self.view setOpaque:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];

    
    _datePicker = [[UIDatePicker alloc]init];
    _datePicker.backgroundColor = [UIColor whiteColor];
    //挑选显示日期的模式
    _datePicker.datePickerMode = UIDatePickerModeDate;
    //设置语言：中文
    _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    //添加事件
    [_datePicker addTarget:self action:@selector(changeValue)forControlEvents:UIControlEventValueChanged];
 
    [self.view addSubview:_datePicker];
    
    [_datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(0);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(kScreenW);
        make.height.mas_equalTo(198);
    }];
    
    //    NSDate *date = [NSDate date];
    NSString *lastTime = self.lastTime;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:lastTime];//上次设置的日期
    // 2.3 将转换后的日期设置给日期选择控件
    [_datePicker setDate:date];

    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:0];//设置最大时间为：当前时间推后十年
    NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    [comps setYear:-100];//设置最小时间为：当前时间前推十年
    NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    
    [_datePicker setMaximumDate:maxDate];
    [_datePicker setMinimumDate:minDate];
    
    UIView *infoView = [[UIView alloc]init];
    infoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:infoView];
    [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_datePicker.mas_top).offset(0);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(kScreenW);
        make.height.mas_equalTo(117);
    }];
    
    for (int i = 0; i <3; i++) {
        UILabel *line = [[UILabel alloc]init];
        line.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
        [infoView addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(infoView).offset(39 *i +39);
            make.left.equalTo(infoView);
            make.width.equalTo(infoView);
            make.height.mas_equalTo(1);
        }];
    }
    
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = [UIColor colorWithHexString:@"a6a6a6"];
    titleLabel.text = @"滚动时间，系统自动计算年龄，星座";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:14];
    [infoView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(infoView).offset(12.5);
        make.left.equalTo(infoView);
        make.width.equalTo(infoView);
        make.height.mas_equalTo(14);
    }];
    
    UILabel *ageTextLabel = [[UILabel alloc]init];
    ageTextLabel.textColor = [UIColor colorWithHexString:@"000000"];
    ageTextLabel.text = @"年龄";
    ageTextLabel.textAlignment = NSTextAlignmentLeft;
    ageTextLabel.font = [UIFont systemFontOfSize:16];
    [infoView addSubview:ageTextLabel];
    [ageTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(infoView).offset(39 +11.5);
        make.left.equalTo(infoView).offset(13.5);
        make.width.equalTo(@40);
        make.height.mas_equalTo(16);
    }];
    
    UILabel *ageLabel = [[UILabel alloc]init];
    ageLabel.textColor = [UIColor colorWithHexString:@"a6a6a6"];
    ageLabel.text = @"未知";
    ageLabel.textAlignment = NSTextAlignmentRight;
    ageLabel.font = [UIFont systemFontOfSize:16];
    [infoView addSubview:ageLabel];
    [ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ageTextLabel).offset(0);
        make.right.equalTo(infoView).offset(-13.5);
        make.width.equalTo(@150);
        make.height.mas_equalTo(16);
    }];
    
    
    UILabel *starTextLabel = [[UILabel alloc]init];
    starTextLabel.textColor = [UIColor colorWithHexString:@"000000"];
    starTextLabel.text = @"星座";
    starTextLabel.textAlignment = NSTextAlignmentLeft;
    starTextLabel.font = [UIFont systemFontOfSize:16];
    [infoView addSubview:starTextLabel];
    
    [starTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(infoView).offset(39*2 +11.5);
        make.left.equalTo(ageTextLabel).offset(0);
        make.width.equalTo(@40);
        make.height.mas_equalTo(16);
    }];
    
    UILabel *starLabel = [[UILabel alloc]init];
    starLabel.textColor = [UIColor colorWithHexString:@"a6a6a6"];
    starLabel.text = @"未知";
    starLabel.textAlignment = NSTextAlignmentRight;
    starLabel.font = [UIFont systemFontOfSize:16];
    [infoView addSubview:starLabel];
    
    [starLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(starTextLabel).offset(0);
        make.right.equalTo(ageLabel).offset(0);
        make.width.equalTo(@150);
        make.height.mas_equalTo(16);
    }];

    
    self.ageLabel = ageLabel;
    self.starLabel = starLabel;

    // Do any additional setup after loading the view.
}
- (void)changeValue{
    
    
    
    //获取挑选的日期
    NSDate *date =_datePicker.date;
    
    NSDateFormatter *dateForm = [[NSDateFormatter alloc]init];
    //设定转换格式
    dateForm.dateFormat =@"yyyy-MM-dd";
    //由当前获取的NSDate数据，转换为日期字符串，显示在私有成员变量_textField上
     NSLog(@"%@",[dateForm stringFromDate:date]);
   
    
    // 出生日期转换 年月日
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    int  brithDateDay   = (int)[components1 day];
    int  brithDateMonth = (int)[components1 month];
    
    
    
    
    self.ageStr = [NSString stringWithFormat:@"%ld",[self ageWithDateOfBirth:date]];
    self.starStr = [self getConstellationWithMonth:brithDateMonth day:brithDateDay];
    self.timeStr = [dateForm stringFromDate:date];
    
    if ([self.ageStr integerValue] <0) {
         self.ageLabel.text = [NSString stringWithFormat:@"火星年纪：%@岁",self.ageStr];
    }else{
        self.ageLabel.text = [NSString stringWithFormat:@"%@岁",self.ageStr];
    }
    self.starLabel.text = self.starStr;
    
}
- (void)viewWillDisappear:(BOOL)animated{
    if(self.ageStr.length>0&&self.starStr.length>0&&self.timeStr>0){
    NSDictionary *dict = @{@"age":self.ageStr,@"star":self.starStr,@"time":self.timeStr};
    self.backInfo(dict);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)tapAction {
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
}

- (NSString *)getConstellationWithMonth:(int)m_ day:(int)d_
{
    NSString * astroString = @"摩羯座水瓶座双鱼座白羊座金牛座双子座巨蟹座狮子座处女座天秤座天蝎座射手座摩羯座";
    NSString * astroFormat = @"102123444543";
    NSString * result;
    
    result = [NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(m_*3-(d_ < [[astroFormat substringWithRange:NSMakeRange((m_-1), 1)] intValue] - (-19))*3, 3)]];
    
    return result;
}


- (NSInteger)ageWithDateOfBirth:(NSDate *)date;
{
    // 出生日期转换 年月日
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    NSInteger brithDateYear  = [components1 year];
    NSInteger brithDateDay   = [components1 day];
    NSInteger brithDateMonth = [components1 month];
    
    // 获取系统当前 年月日
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    NSInteger currentDateYear  = [components2 year];
    NSInteger currentDateDay   = [components2 day];
    NSInteger currentDateMonth = [components2 month];
    
    // 计算年龄
    NSInteger iAge = currentDateYear - brithDateYear - 1;
    if ((currentDateMonth > brithDateMonth) || (currentDateMonth == brithDateMonth && currentDateDay >= brithDateDay)) {
        iAge++;
    }
    
    return iAge;
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
