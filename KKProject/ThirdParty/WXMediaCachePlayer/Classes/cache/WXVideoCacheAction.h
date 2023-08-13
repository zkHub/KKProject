//
//  WXVideoCacheAction.h
//  -
//
//  Created by zk on 2021/8/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, WXCacheActionType) {
    WXCacheActionTypeUnknown,
    WXCacheActionTypeLocal,
    WXCacheActionTypeRemote,
};

@interface WXVideoCacheAction : NSObject

- (instancetype)initWithActionType:(WXCacheActionType)type range:(NSRange)range;

@property (nonatomic, assign) WXCacheActionType type;
@property (nonatomic, assign) NSRange range;

@end

NS_ASSUME_NONNULL_END
