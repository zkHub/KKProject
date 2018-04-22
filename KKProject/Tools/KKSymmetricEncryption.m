//
//  KKSymmetricEncryption.m
//  KKProject
//
//  Created by 张柯 on 2018/2/28.
//  Copyright © 2018年 zhangke. All rights reserved.
//

#import "KKSymmetricEncryption.h"
#import <CommonCrypto/CommonCryptor.h>
@implementation KKSymmetricEncryption



//- (NSString*)encryptString:(NSString*)inString key:(NSString*)keyString initVector:(NSString*)ivString {
//    
//    //设置偏移量
//    NSAssert(ivString.length < 8, @"偏移量最少：8字节长度");
//    const char *iv = NULL;
//    if (ivString.length > 0) {
//        iv = [ivString UTF8String];
//    }
//    
//    //设置待加密文本
//    NSData *inData = [inString dataUsingEncoding:NSUTF8StringEncoding];
//    
//    //
//    
//    
//    //在C语言里面,一般上一个参数传指针!下一个参数大部分都是这个指针所指向数据的长度!!
//    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
//                                          kCCAlgorithmDES,
//                                          kCCOptionPKCS7Padding,
//                                          [keyString UTF8String],
//                                          kCCKeySizeDES,
//                                          iv,
//                                          [inData bytes],
//                                          [inData length],
//                                          <#void *dataOut#>,
//                                          <#size_t dataOutAvailable#>,
//                                          <#size_t *dataOutMoved#>)
//}




@end
