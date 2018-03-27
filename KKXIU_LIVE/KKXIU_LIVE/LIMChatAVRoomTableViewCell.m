//
//  LIMChatAVRoomTableViewCell.m
//  KKXIU_LIVE
//
//  Created by 张洋 on 2017/8/31.
//  Copyright © 2017年 张洋. All rights reserved.
//

#import "LIMChatAVRoomTableViewCell.h"
#import <UIImageView+WebCache.h>


#define kCellW kScreenW *0.66
@interface LIMChatAVRoomTableViewCell()
@property (nonatomic, strong) UILabel *senLabel;




@property (nonatomic, strong) UILabel  *cityLabel;
@property (nonatomic, strong) UILabel  *nameLabel;
@property (nonatomic, strong) UILabel  *describeLabel;
@property (nonatomic, strong) UIImageView *gradeIcon;

@end

@implementation LIMChatAVRoomTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        [self createDetailView];
        
    }
    return self;
}
- (void)createDetailView{
    UILabel *label = [[UILabel alloc]init];
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor clearColor];
    label.text =@"";
//    NSString *string = @"xxx：啊上课绝对是你的喀什地区哦 i 我激动 i 钱我就跑去挖掘潜力可没钱了；，啊什么的，。啊什么的了晴空万里；开";
//    
//    NSMutableAttributedString * aAttributedString = [[NSMutableAttributedString alloc] initWithString:string];
//    //富文本样式
//    [aAttributedString addAttribute:NSForegroundColorAttributeName  //文字颜色
//                                           value:[UIColor redColor]
//                                        range:NSMakeRange(0, 4)];
//    
//    [aAttributedString addAttribute:NSFontAttributeName             //文字字体
//                                           value:[UIFont systemFontOfSize:14]
//                                           range:NSMakeRange(0, 4)];
//    
//    
//    //富文本样式
//    [aAttributedString addAttribute:NSForegroundColorAttributeName  //文字颜色
//                              value:[UIColor orangeColor]
//                              range:NSMakeRange(4, string.length -4)];
//    
//    [aAttributedString addAttribute:NSFontAttributeName             //文字字体
//                              value:[UIFont systemFontOfSize:14]
//                              range:NSMakeRange(4, string.length -4)];
//    // 段落样式
//    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.firstLineHeadIndent = 38;
//    [aAttributedString addAttribute:NSParagraphStyleAttributeName
//                                   value:paragraphStyle
//                                   range:NSMakeRange(0, string.length)];
//    
//    label.attributedText = aAttributedString;

    [self.contentView addSubview:label];
    self.senLabel = label;
//    CGFloat buttonH = [string boundingRectWithSize:CGSizeMake(kCellW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;

//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView).offset(2);
//        make.left.equalTo(self.contentView).offset(0 *kiphone6);
//        make.size.mas_equalTo(CGSizeMake(kCellW, buttonH));
//        
//    }];
    UIImageView *gradeImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"live_0"]];
    [self.contentView addSubview:gradeImageV];
    [gradeImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(2);
        make.left.equalTo(self.contentView).offset(0 *kiphone6);
        make.size.mas_equalTo(CGSizeMake(34.5, 15.5));
    }];
    self.gradeIcon = gradeImageV;
}
- (void)setCellInfo:(LIMChatModel *)chatModel{
    NSLog(@"level = %@",chatModel.isUp);
    if (chatModel.level.length == 0) {
        chatModel.level = @"0";
    }
    if ([chatModel.isUp isEqualToString:@"1"]) {
        self.gradeIcon.image  = [UIImage imageNamed:[NSString stringWithFormat:@"upicon_%@",chatModel.level]];
    }else{
        self.gradeIcon.image  = [UIImage imageNamed:[NSString stringWithFormat:@"live_%@",chatModel.level]];
    }
    
    
    UIColor *nameColor = [UIColor whiteColor];
    if ([chatModel.isUp isEqualToString:@"1"]) {
        switch ([chatModel.level integerValue]) {
            case 1:
                nameColor = [UIColor colorWithHexString:@"d8790a"];
                break;
            case 2:
                nameColor = [UIColor colorWithHexString:@"62fff1"];
                break;
            case 3:
                nameColor = [UIColor colorWithHexString:@"f9c102"];
                break;
            case 4:
                nameColor = [UIColor colorWithHexString:@"fffd6e"];
                break;
            case 5:
                nameColor = [UIColor colorWithHexString:@"f92828"];
                break;
            case 6:
                nameColor = [UIColor colorWithHexString:@"ffc610"];
                break;
            default:
                break;
        }
    }else{
        switch ([chatModel.level integerValue]) {
            case 0:
                nameColor = [UIColor colorWithHexString:@"59a8ef"];
                break;
            case 1:
                nameColor = [UIColor colorWithHexString:@"c66f0d"];
                break;
            case 2:
                nameColor = [UIColor colorWithHexString:@"ffffff"];
                break;
            case 3:
                nameColor = [UIColor colorWithHexString:@"f9c102"];
                break;
            case 4:
                nameColor = [UIColor colorWithHexString:@"4abcb2"];
                break;
            case 5:
                nameColor = [UIColor colorWithHexString:@"bebb49"];
                break;
            case 6:
                nameColor = [UIColor colorWithHexString:@"e42727"];
                break;
            case 7:
                nameColor = [UIColor colorWithHexString:@"fffd6e"];
                break;
            case 8:
                nameColor = [UIColor colorWithHexString:@"ffc610"];
                break;
            default:
                break;
        }

    }
    UIColor *textColor = [UIColor whiteColor];
    if ([chatModel.type isEqualToString:@"1"]) {
        
    }else{
        textColor = [UIColor colorWithHexString:@"ffba00"];
    }

    
    NSMutableAttributedString * aAttributedString = [[NSMutableAttributedString alloc] initWithString:chatModel.sentence];
    // 名字
    [aAttributedString addAttribute:NSForegroundColorAttributeName  //文字颜色
                              value:nameColor
                              range:NSMakeRange(0, chatModel.nameLength)];
    
    [aAttributedString addAttribute:NSFontAttributeName             //文字字体
                              value:[UIFont systemFontOfSize:14]
                              range:NSMakeRange(0, chatModel.nameLength)];
    
    
    // 聊天内容
    [aAttributedString addAttribute:NSForegroundColorAttributeName  //文字颜色
                              value:textColor
                              range:NSMakeRange(chatModel.nameLength, chatModel.sentence.length -chatModel.nameLength)];
    
    [aAttributedString addAttribute:NSFontAttributeName             //文字字体
                              value:[UIFont systemFontOfSize:14]
                              range:NSMakeRange(chatModel.nameLength, chatModel.sentence.length -chatModel.nameLength)];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.firstLineHeadIndent = 38;
    [aAttributedString addAttribute:NSParagraphStyleAttributeName
                              value:paragraphStyle
                              range:NSMakeRange(0, chatModel.sentence.length)];
    
    self.senLabel.attributedText = aAttributedString;
    self.senLabel.frame = CGRectMake(0, 2, kCellW, chatModel.labelH);
//    [self.senLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView).offset(2);
//        make.left.equalTo(self.contentView).offset(0 *kiphone6);
//        make.size.mas_equalTo(CGSizeMake(kCellW, chatModel.labelH));
//    
//    }];
    
    

    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
