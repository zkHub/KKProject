//
//  WXVideoDownloader.m
//  -
//
//  Created by zk on 2021/7/22.
//

#import "WXVideoDownloader.h"

@interface WXVideoDownloader () <NSURLSessionDelegate,NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionTask *task;
//@property (nonatomic, strong) NSOperationQueue *serialQueue;

@end

@implementation WXVideoDownloader

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.serialQueue = [[NSOperationQueue alloc] init];
//        self.serialQueue.maxConcurrentOperationCount = 1;
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//        config.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
//        config.networkServiceType = NSURLNetworkServiceTypeVideo;
        self.session = [NSURLSession sessionWithConfiguration:config
                                                     delegate:self  //sessionDelegate会强引用
                                                delegateQueue:nil];
    }
    return self;
}

/*
 Range 有几种不同的方式来限定范围：

 500-900：指定开始到结束这一段的长度，记住 Range 是从 0 计数 的，所以这个是要求服务器从 501 字节开始传，一直到 901 字节结束。这个一般用来特别大的文件分片传输，比如视频。
 
 500-：从 501 bytes 之后开始传，一直传到最后。这个就比较适合用于断点续传，客户端已经下载了 500 字节的内容，麻烦把后面的传过来
 
 -500：这个需要注意啦，如果范围没有指定开始位置，就是要服务器端传递倒数 500 字节的内容。而不是从 0 开始的 500 字节。。
 
 500-900, 1000-2000：也可以同时指定多个范围的内容，这种情况不是很常见
 */

- (NSURLSessionTask *)downLoadURL:(NSURL *)url range:(NSRange)range {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    
    long long offset = range.location;
    long long endOffset = range.location + range.length - 1;
    NSString *httpRange = [NSString stringWithFormat:@"bytes=%lld-%lld",offset,endOffset];
    [request setValue:httpRange forHTTPHeaderField:@"Range"];
    NSURLSessionTask *task = [self.session dataTaskWithRequest:request];
//    [task resume];
    
    self.task = task;
    
    return task;
}

- (NSURLSessionTask *)downLoadURL:(NSURL *)url beginOffset:(long long)offset {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    
    NSString *httpRange = [NSString stringWithFormat:@"bytes=%lld-",offset];
    [request setValue:httpRange forHTTPHeaderField:@"Range"];
    NSURLSessionTask *task = [self.session dataTaskWithRequest:request];
//    [task resume];
    
    self.task = task;
    
    return task;
}

- (void)cancelDownloadingTask {
//    [self.serialQueue cancelAllOperations];
    
    if (_task && _task.state != NSURLSessionTaskStateCompleted) {
        [self.task cancel];
    }
}

- (void)invalidate {
    if (_session) {
        [self.session invalidateAndCancel];
    }
}

#pragma mark - sessionDelegate

//开始接受数据
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    
    NSString *mimeType = response.MIMEType;
    
    if ([mimeType rangeOfString:@"video/"].location == NSNotFound &&
        [mimeType rangeOfString:@"audio/"].location == NSNotFound &&
        [mimeType rangeOfString:@"application"].location == NSNotFound) {
        completionHandler(NSURLSessionResponseCancel);
    } else {
        if ([self.delegate respondsToSelector:@selector(downloader:didReceiveResponse:task:)]) {
            [self.delegate downloader:self didReceiveResponse:response task:dataTask];
        }
        
        
        completionHandler(NSURLSessionResponseAllow);
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    
    if ([self.delegate respondsToSelector:@selector(downloader:didReceiveData:task:)]) {
        [self.delegate downloader:self didReceiveData:data task:dataTask];
    }
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(downloader:didCompleteWithError:task:)]) {
        [self.delegate downloader:self didCompleteWithError:error task:task];
    }
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    NSURLCredential *card = [[NSURLCredential alloc] initWithTrust:challenge.protectionSpace.serverTrust];
    completionHandler(NSURLSessionAuthChallengeUseCredential,card);
}

@end
