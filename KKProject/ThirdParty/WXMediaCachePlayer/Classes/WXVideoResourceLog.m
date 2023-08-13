//
//  WXVideoResourceLog.m
//  WXMediaCachePlayer
//
//  Created by zk on 2021/8/31.
//

#import "WXVideoResourceLog.h"

void(^willLog)(NSString *log);

@implementation WXVideoResourceLog

+ (void)setLogHandler:(void(^)(NSString *log))handler {
    willLog = handler;
}

+ (void)log:(NSString *)log {
    
    if (willLog) {
        willLog(log);
    }
    
}

@end
