//
//  NSString+KKHandle.h
//  WebForJS
//
//  Created by zhangke on 2017/7/6.
//  Copyright © 2017年 zhangke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (KKHandler)

- (NSString*)transformToPinyin;
- (NSString*)MD5String;
- (NSString*)SHA1String;

/**
 gbk与utf8编码字母与字符编码结果一样，中文会不一样  gbk可以解utf8，但中文会乱码，utf8解gbk失败
 */
- (NSString*)encodeURLString;
- (NSString*)encodeURLStringWithCFStringEncoding:(CFStringEncoding)encoding;

- (NSString*)decodeURLString;
- (NSString*)decodeURLStringWithCFStringEncoding:(CFStringEncoding)encoding;


/**
 判断字符串中是否包含emoji

 @return BooL值
 */
- (BOOL)stringContainsEmoji;

@end
