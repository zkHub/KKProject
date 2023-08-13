//
//  WXVideoCacheAction.m
//  -
//
//  Created by zk on 2021/8/2.
//

#import "WXVideoCacheAction.h"

@implementation WXVideoCacheAction

- (instancetype)initWithActionType:(WXCacheActionType)type range:(NSRange)range {
    self = [super init];
    if (self) {
        _type = type;
        _range = range;
    }
    return self;
}

@end
