//
//  CcUserModel.m
//  KuangWanTV
//
//  Created by 张洋 on 15/12/2.
//  Copyright © 2015年 张洋. All rights reserved.
//

#import "CcUserModel.h"
#import <CommonCrypto/CommonCryptor.h>
@implementation CcUserModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
/**
 * PS:用自己的属性，代替字典里的
 */
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"info_id" : @"id"};
}
+ (CcUserModel *)defaultClient{
    static CcUserModel *userModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userModel = [[self alloc]init];
    });
    [userModel setUserModelInfo];
    return userModel;
}
// telephoneNum



- (void)saveAllInfo{
    [[NSUserDefaults standardUserDefaults] setValue:self.uid forKey:@"uid"];
    [[NSUserDefaults standardUserDefaults] setValue:self.token forKey:@"token"];
    [[NSUserDefaults standardUserDefaults] setValue:self.phonetype forKey:@"phonetype"];
    [[NSUserDefaults standardUserDefaults] setValue:self.imei forKey:@"imei"];
    [[NSUserDefaults standardUserDefaults] setValue:self.jwd forKey:@"jwd"];
    [[NSUserDefaults standardUserDefaults] setValue:self.province forKey:@"province"];
    [[NSUserDefaults standardUserDefaults] setValue:self.city forKey:@"city"];
    [[NSUserDefaults standardUserDefaults] setValue:self.area forKey:@"area"];
     [[NSUserDefaults standardUserDefaults] setValue:self.os forKey:@"os"];
    [[NSUserDefaults standardUserDefaults] setValue:self.ver forKey:@"ver"];
    [[NSUserDefaults standardUserDefaults] setValue:self.encry forKey:@"encry"];
    [[NSUserDefaults standardUserDefaults] setValue:self.age forKey:@"age"];
    [[NSUserDefaults standardUserDefaults] setValue:self.birthday forKey:@"birthday"];
    [[NSUserDefaults standardUserDefaults] setValue:self.cover forKey:@"cover"];
    [[NSUserDefaults standardUserDefaults] setValue:self.gender forKey:@"gender"];
    [[NSUserDefaults standardUserDefaults] setValue:self.authstate forKey:@"authstate"];
    [[NSUserDefaults standardUserDefaults] setValue:self.mobile forKey:@"mobile"];
    [[NSUserDefaults standardUserDefaults] setValue:self.nickname forKey:@"nickname"];
    [[NSUserDefaults standardUserDefaults] setValue:self.personsign forKey:@"personsign"];
    [[NSUserDefaults standardUserDefaults] setValue:self.star forKey:@"star"];
    
    
    [[NSUserDefaults standardUserDefaults] setValue:self.timid forKey:@"timid"];
    [[NSUserDefaults standardUserDefaults] setValue:self.timsig forKey:@"timsig"];
    
    [[NSUserDefaults standardUserDefaults] setValue:self.beautyDepth forKey:@"beautyDepth"];
    [[NSUserDefaults standardUserDefaults] setValue:self.whiteningDepth forKey:@"whiteningDepth"];
    [[NSUserDefaults standardUserDefaults] setValue:self.eyeScaleLevel forKey:@"eyeScaleLevel"];
    [[NSUserDefaults standardUserDefaults] setValue:self.faceScaleLevel forKey:@"faceScaleLevel"];
    [[NSUserDefaults standardUserDefaults] setValue:self.avatar forKey:@"avatar"];
    [[NSUserDefaults standardUserDefaults] setValue:self.userlevel forKey:@"userlevel"];
    [[NSUserDefaults standardUserDefaults] setValue:self.iscompere forKey:@"iscompere"];
    [[NSUserDefaults standardUserDefaults] setValue:self.noNight forKey:@"noNight"];
    [[NSUserDefaults standardUserDefaults] setValue:self.gameconflist forKey:@"gameconflist"];
    
    

}

- (void)setUserModelInfo{
    self.uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    self.token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    self.phonetype = [[NSUserDefaults standardUserDefaults] objectForKey:@"phonetype"];
    self.imei = [[NSUserDefaults standardUserDefaults] objectForKey:@"imei"];
    self.jwd = [[NSUserDefaults standardUserDefaults] objectForKey:@"jwd"];
    self.province = [[NSUserDefaults standardUserDefaults] objectForKey:@"province"];
    self.city = [[NSUserDefaults standardUserDefaults] objectForKey:@"city"];
    self.area = [[NSUserDefaults standardUserDefaults] objectForKey:@"area"];
    self.os = [[NSUserDefaults standardUserDefaults] objectForKey:@"os"];
    self.ver = [[NSUserDefaults standardUserDefaults] objectForKey:@"ver"];
    self.encry = [[NSUserDefaults standardUserDefaults] objectForKey:@"encry"];
    self.age = [[NSUserDefaults standardUserDefaults] objectForKey:@"age"];
    self.birthday = [[NSUserDefaults standardUserDefaults] objectForKey:@"birthday"];
    self.cover = [[NSUserDefaults standardUserDefaults] objectForKey:@"cover"];
    self.gender = [[NSUserDefaults standardUserDefaults] objectForKey:@"gender"];
    self.authstate = [[NSUserDefaults standardUserDefaults] objectForKey:@"authstate"];
    self.mobile = [[NSUserDefaults standardUserDefaults] objectForKey:@"mobile"];
    self.nickname = [[NSUserDefaults standardUserDefaults] objectForKey:@"nickname"];
    self.personsign = [[NSUserDefaults standardUserDefaults] objectForKey:@"personsign"];
    self.star = [[NSUserDefaults standardUserDefaults] objectForKey:@"star"];
    
    
    self.timsig = [[NSUserDefaults standardUserDefaults] objectForKey:@"timsig"];
    self.timid = [[NSUserDefaults standardUserDefaults] objectForKey:@"timid"];
    
    self.beautyDepth = [[NSUserDefaults standardUserDefaults] objectForKey:@"beautyDepth"];
    self.whiteningDepth = [[NSUserDefaults standardUserDefaults] objectForKey:@"whiteningDepth"];
    self.eyeScaleLevel = [[NSUserDefaults standardUserDefaults] objectForKey:@"eyeScaleLevel"];
    self.faceScaleLevel = [[NSUserDefaults standardUserDefaults] objectForKey:@"faceScaleLevel"];
    self.avatar = [[NSUserDefaults standardUserDefaults] objectForKey:@"avatar"];
    
    self.userlevel = [[NSUserDefaults standardUserDefaults] objectForKey:@"userlevel"];
    self.iscompere = [[NSUserDefaults standardUserDefaults] objectForKey:@"iscompere"];
    self.noNight = [[NSUserDefaults standardUserDefaults] objectForKey:@"noNight"];
    self.gameconflist = [[NSUserDefaults standardUserDefaults] objectForKey:@"gameconflist"];
    
    
    


}
- (void)removeUserInfo{
    
//    userModel.os = @"ios";
//    userModel.ver = [infoDictionary objectForKey:@"CFBundleVersion"];
//    userModel.encry = @"0";
//    userModel.phonetype = [[UIDevice currentDevice] model];
//    userModel.imei = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//    userModel.jwd = @"";
//    userModel.province = @"北京";
//    userModel.city = @"北京";
//    userModel.area = @"善缘街";
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"uid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"phonetype"];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"imei"];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"jwd"];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"province"];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"city"];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"os"];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ver"];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"encry"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"age"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"birthday"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"cover"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"gender"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"authstate"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mobile"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"nickname"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"personsign"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"star"];
    
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"timsig"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"timid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"noNight"];
    
    
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"beautyDepth"];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"whiteningDepth"];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"eyeScaleLevel"];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"faceScaleLevel"];


}
- (NSDictionary *)httpParaDictSecret:(NSDictionary *)para{
    NSDictionary *dict = @{
                           @"phonetype":self.phonetype,
                           @"imei":self.imei,
                           @"jwd":self.jwd,
                           @"uid":self.uid,
                           @"token":self.token,
                           @"province":self.province,
                           @"city":self.city,
                           @"area":self.area
                           };
    NSString *string = [NSString stringWithFormat:@"phonetype=%@&imei=%@&jwd=%@&uid=%@&token=%@&province=%@&city=%@&area=%@",self.phonetype,self.imei,self.jwd,self.uid,self.token,self.province,self.city,self.area];
    NSArray *allkeys = para.allKeys;
    for (int i = 0; i<allkeys.count; i++) {
        NSString *key = allkeys[i];
        string = [NSString stringWithFormat:@"%@&%@=%@",string,key,para[key]];
    }
    
    NSDictionary *dict2 = @{
                            @"param":[self encryptUseDES:string]
    };
    NSLog(@"dict2 = %@", dict2);
    
    return dict2;
}
- (NSDictionary *)httpParaDictUnSecret{
    NSDictionary *dict = @{
                           @"os":self.os,
                           @"ver":self.ver,
                           @"encry":@"1"
                           };
    
    return dict;
}
-(NSString *)description{
    
    NSString * string = [NSString stringWithFormat:@"<Person: phonetype = %@ imei = %@  jwd = %@  uid = %@  token = %@  province = %@  city = %@  area = %@  os = %@  ver = %@  encry = %@ ",self.phonetype,self.imei,self.jwd,self.uid,self.token,self.province,self.city,self.area,self.os,self.ver,self.encry];
    
    return string;
    
}
-(NSString *) encryptUseDES:(NSString *)plainText {
    NSString *ciphertext = nil;
//    NSData *textData = [NSJSONSerialization dataWithJSONObject:plainText options:NSJSONWritingPrettyPrinted error:nil];
    NSData *textData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [textData length];
    unsigned char buffer[1024 * 5];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [@"09(DJUD*" UTF8String], kCCKeySizeDES,
                                          [@"MFo*(Fji" UTF8String],
                                          [textData bytes], dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        ciphertext = [data base64EncodedStringWithOptions:0];
    }
    return ciphertext;
}



@end
