//
//  WXVideoContentInfo.m
//  -
//
//  Created by zk on 2021/7/26.
//

#import "WXVideoContentInfo.h"

static NSString *kContentLengthKey = @"kContentLengthKey";
static NSString *kContentTypeKey = @"kContentTypeKey";
static NSString *kByteRangeAccessSupported = @"kByteRangeAccessSupported";

@implementation WXVideoContentInfo

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:@(self.contentLength) forKey:kContentLengthKey];
    [coder encodeObject:self.contentType forKey:kContentTypeKey];
    [coder encodeObject:@(self.byteRangeAccessSupported) forKey:kByteRangeAccessSupported];
}

- (nullable instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _contentLength = [[coder decodeObjectForKey:kContentLengthKey] longLongValue];
        _contentType = [coder decodeObjectForKey:kContentTypeKey];
        _byteRangeAccessSupported = [[coder decodeObjectForKey:kByteRangeAccessSupported] boolValue];
    }
    return self;
}

@end
