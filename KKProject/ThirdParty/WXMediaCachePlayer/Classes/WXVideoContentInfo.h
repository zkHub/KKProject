//
//  WXVideoContentInfo.h
//  -
//
//  Created by zk on 2021/7/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXVideoContentInfo : NSObject <NSCoding>

@property (nonatomic, copy) NSString *contentType; //资源类型
@property (nonatomic, assign) BOOL byteRangeAccessSupported;
@property (nonatomic, assign) unsigned long long contentLength; //资源总大小

@end

NS_ASSUME_NONNULL_END
