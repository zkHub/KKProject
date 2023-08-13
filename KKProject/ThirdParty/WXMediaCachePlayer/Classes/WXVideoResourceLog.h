//
//  WXVideoResourceLog.h
//  WXMediaCachePlayer
//
//  Created by zk on 2021/8/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXVideoResourceLog : NSObject

+ (void)setLogHandler:(void(^)(NSString *log))handler;

+ (void)log:(NSString *)log;

@end

NS_ASSUME_NONNULL_END
