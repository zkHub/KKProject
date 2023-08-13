//
//  WXVideoDownloader.h
//  -
//
//  Created by zk on 2021/7/22.
//

#import <Foundation/Foundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
NS_ASSUME_NONNULL_BEGIN
@class WXVideoDownloader;

@protocol WXVideoDownloaderDelegate <NSObject>

- (void)downloader:(WXVideoDownloader *)downloader didReceiveResponse:(NSURLResponse *)response task:(NSURLSessionDataTask *)task;

- (void)downloader:(WXVideoDownloader *)downloader didReceiveData:(NSData *)data task:(NSURLSessionDataTask *)task;

- (void)downloader:(WXVideoDownloader *)downloader didCompleteWithError:(NSError *)error task:(NSURLSessionTask *)task;

@end

@interface WXVideoDownloader : NSObject

@property (nonatomic, weak) id delegate;

- (NSURLSessionTask *)downLoadURL:(NSURL *)url beginOffset:(long long)offset;
- (NSURLSessionTask *)downLoadURL:(NSURL *)url range:(NSRange)range;

- (void)cancelDownloadingTask;
- (void)invalidate;

@end

NS_ASSUME_NONNULL_END
