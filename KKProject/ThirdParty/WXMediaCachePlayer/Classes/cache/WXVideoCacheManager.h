//
//  WXVideoCacheManager.h
//  -
//
//  Created by zk on 2021/8/17.
//

#import <Foundation/Foundation.h>
#import "WXVideoCacheWorker.h"

NS_ASSUME_NONNULL_BEGIN

/*
 缓存管理
 */
@interface WXVideoCacheManager : NSObject

+ (instancetype)shareInstance;

+ (void)cleanCache;

+ (NSString *)getCacheDirectory;

+ (BOOL)supportPreloadVideoForUrl:(NSString *)url;

- (WXVideoCacheWorker *)cacheWorkForUrl:(NSString *)url;

- (void)addPreloadTaskWithUrl:(NSString *)url;

- (void)removePreloadTaskWithUrl:(NSString *)url;

//删除所有缓存
- (void)removeAllCache;

//取消正在进行的任务
- (void)cancelAllPreloadTask;

// 文件夹大小(字节)
- (unsigned long long)cacheSize;

//是否添加过预缓存任务
- (BOOL)hasPreloadUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
