//
//  WXVideoCacheConfig.h
//  -
//
//  Created by zk on 2021/7/27.
//

#import <Foundation/Foundation.h>
#import "WXVideoContentInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface WXVideoCacheConfig : NSObject <NSCoding>

@property (atomic, strong) WXVideoContentInfo *contentInfo;
@property (nonatomic, strong, readonly) NSString *filePath;

+ (instancetype)configurationForFilePath:(NSString *)filePath;

- (void)save;

- (void)addCacheFragment:(NSRange)fragment;

- (NSArray<NSValue*> *)allFragments;

@end

NS_ASSUME_NONNULL_END
