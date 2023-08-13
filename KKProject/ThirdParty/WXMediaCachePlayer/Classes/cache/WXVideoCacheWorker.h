//
//  WXVideoCacheWorker.h
//  -
//
//  Created by zk on 2021/7/22.
//

#import <Foundation/Foundation.h>
#import "WXVideoContentInfo.h"
#import "WXVideoCacheConfig.h"
#import "WXVideoCacheAction.h"

NS_ASSUME_NONNULL_BEGIN

@interface WXVideoCacheWorker : NSObject

@property (nonatomic, strong, readonly) WXVideoCacheConfig *cacheConfig;

- (instancetype)initWithResourceUrl:(NSString *)url;

- (void)setContentInfo:(WXVideoContentInfo *)contentInfo error:(NSError **)error;

- (void)cacheData:(NSData *)data forRange:(NSRange)range error:(NSError **)error;

- (NSData *)cachedDataForRange:(NSRange)range error:(NSError **)error;

- (NSArray<WXVideoCacheAction*>*)dataActionsForRange:(NSRange)range;

- (void)save;

@end

NS_ASSUME_NONNULL_END
