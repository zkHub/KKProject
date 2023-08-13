//
//  WXLiveSizeConfig+resMd5.m
//  -
//
//  Created by zk on 2021/7/26.
//

#import "NSString+resMd5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (resMd5)

- (NSString *)md5String {
    const char* str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}


@end
