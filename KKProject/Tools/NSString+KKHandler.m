//
//  NSString+KKHandle.m
//  WebForJS
//
//  Created by zhangke on 2017/7/6.
//  Copyright © 2017年 zhangke. All rights reserved.
//

#import "NSString+KKHandler.h"
#import <CommonCrypto/CommonDigest.h>


static NSString *encodeCharacters = @"`~!@#$%^&*()_+-= []\\{}|;':\",./<>?";

@implementation NSString (KKHandler)

- (NSString *)md5String {
    const char *str = [self UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",r[count]];   //%02X 大写
    }
    return outputString;
}

- (NSString *)encodeURLString {
    NSCharacterSet *characters = [[NSCharacterSet characterSetWithCharactersInString:encodeCharacters] invertedSet];
    NSString *encodedUrl = [self stringByAddingPercentEncodingWithAllowedCharacters:characters];
    if (encodedUrl) {
        return encodedUrl;
    } else {
        return @"";
    }
}
- (NSString*)encodeURLStringWithCFStringEncoding:(CFStringEncoding)encoding {
    NSString *encodedUrl = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes
                                                        (kCFAllocatorDefault,
                                                         (CFStringRef)self,
                                                         NULL,
                                                         (CFStringRef)encodeCharacters,
                                                         //CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), //ASI的写法
                                                         encoding));
    if (encodedUrl) {
        return encodedUrl;
    } else {
        return @"";
    }
}

- (NSString*)decodeURLString {
    NSString *decodeUrl = [self stringByRemovingPercentEncoding];//UTF-8
    if (decodeUrl) {
        return decodeUrl;
    } else {
        return @"";
    }
}
- (NSString*)decodeURLStringWithCFStringEncoding:(CFStringEncoding)encoding {
    NSString *decodeUrl = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding
                                                        (kCFAllocatorDefault,
                                                         (CFStringRef)self,
                                                         CFSTR(""),
                                                         encoding));
    if (decodeUrl) {
        return decodeUrl;
    } else {
        return @"";
    }
}

@end
