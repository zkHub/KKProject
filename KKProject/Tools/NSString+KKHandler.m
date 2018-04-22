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

- (NSString *)transformToPinyin {
    
    NSMutableString *mutableString = [NSMutableString stringWithString:self];
    
    //不支持多音字，需要手动处理
    if (mutableString.length > 0){
        if ([mutableString containsString:@"翟"]) {
            mutableString = [mutableString stringByReplacingOccurrencesOfString:@"翟" withString:@"zhai"].mutableCopy;
        }
    }

    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    NSString *pinyinString = (NSMutableString *)[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    return pinyinString;
}


- (NSString *)MD5String {
    
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

- (NSString *)SHA1String {
    
    const char *str = [self UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(str, (CC_LONG)strlen(str), r);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_SHA1_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",r[count]];   //%02X 大写
    }
    return outputString;

}



- (NSString *)encodeURLString {
    
    NSCharacterSet *characters = [[NSCharacterSet characterSetWithCharactersInString:encodeCharacters] invertedSet];
    NSString *encodedUrl = [self stringByAddingPercentEncodingWithAllowedCharacters:characters];//UTF-8
    if (encodedUrl) {
        return encodedUrl;
    } else {
        return @"";
    }
}
- (NSString *)encodeURLStringWithCFStringEncoding:(CFStringEncoding)encoding {
    
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

- (NSString *)decodeURLString {
    
    NSString *decodeUrl = [self stringByRemovingPercentEncoding];//UTF-8
    if (decodeUrl) {
        return decodeUrl;
    } else {
        return @"";
    }
}
- (NSString *)decodeURLStringWithCFStringEncoding:(CFStringEncoding)encoding {
    
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



- (BOOL)stringContainsEmoji {
    __block BOOL returnValue = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        NSLog(@"%hu", hs);
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                //新添加emoji的话需要扩大范围
                if (0x1d000 <= uc && uc <= 0x1ffff){
                    returnValue = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            //新添加emoji的话需要更改
            if (ls == 0x20e3 || ls == 0xfe0f || ls == 0xd83c) {
                returnValue = YES;
            }
        } else {
            if (0x2100 <= hs && hs <= 0x27ff) {
                returnValue = YES;
            } else if (0x2B05 <= hs && hs <=0x2b07) {
                returnValue = YES;
            } else if (0x2934 <= hs && hs <=0x2935) {
                returnValue = YES;
            } else if (0x3297 <= hs && hs <=0x3299) {
                returnValue = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                returnValue = YES;
            }
        }
        
    }];
    return returnValue;
}


@end
