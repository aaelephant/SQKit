//
//  SQDownloadManager.m
//  SQDownloadDemo
//
//  Created by qbshen on 2017/1/20.
//  Copyright © 2017年 qbshen. All rights reserved.
//

#import "SQDownloadManager.h"
#import "SQDownloadOperation.h"

#define IS_IOS10ORLATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10)

NSString * const kSQDownloadSessionIdentifier = @"tcblobdownloadmanager_downloads";

NSString * const kSQDownloadErrorDomain = @"com.tcblobdownloadswift.error";
NSString * const kSQDownloadErrorDescriptionKey = @"TCBlobDownloadErrorDescriptionKey";
NSString * const kSQDownloadErrorHTTPStatusKey = @"TCBlobDownloadErrorHTTPStatusKey";
NSString * const kSQDownloadErrorFailingURLKey = @"TCBlobDownloadFailingURLKey";



@interface SessionDelegate : NSObject

@end

@interface SessionDelegate ()<NSURLSessionDownloadDelegate>

@property (nonatomic) NSMutableDictionary* downloads;

@property (nonatomic) NSMutableDictionary* resumeDatas;

@property (nonatomic) NSRange acceptableStatusCodes;

@property (nonatomic, copy) void(^backCompletionHandler)();

@end

@interface SQDownloadManager ()

@property (nonatomic) SessionDelegate * delegate;

@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) NSOperationQueue *delegeteQueue;

@property (strong, nonatomic) NSMutableDictionary *completionHandlerDictionary;

@property (strong, nonatomic) NSURLSessionDownloadTask *downloadTask;
@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSData *resumeData;

@property (nonatomic) BOOL startImmediatly;
@end
@implementation SQDownloadManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.startImmediatly = YES;
        NSString *identifier = @"com.qbshen.SQDownloadDemo.BackgroundSession";
        NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:identifier];
        configuration.HTTPMaximumConnectionsPerHost = 1;//ios 默认4个
        [self initWithConfig:configuration];
    }
    return self;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static id sharedManager = nil;
    dispatch_once(&onceToken, ^{
        sharedManager = [[[self class] alloc] init];

    });
    return sharedManager;
}

-(void)setBackCompletionHandler:(void (^)())backCompletionHandler
{
    self.delegate.backCompletionHandler = backCompletionHandler;
}

-(void)initWithConfig:(NSURLSessionConfiguration*)sessionConfiguration
{
    self.delegate = [SessionDelegate new];
    self.operationQueue = [NSOperationQueue new];
    [self.operationQueue setName:@"SQDownloadManager_SharedInstance_Queue"];
    self.operationQueue.maxConcurrentOperationCount = 1;
    
    self.delegeteQueue = [NSOperationQueue new];
    [self.delegeteQueue setName:@"SQDownloadManager_session_delegete_Queue"];
    self.delegeteQueue.maxConcurrentOperationCount = 1;
    
    self.session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self.delegate delegateQueue:self.delegeteQueue];
    self.session.sessionDescription = @"SQDownloadManager session";
    
}

- (void)setMaxConcurrentDownloads:(NSInteger)maxConcurrent
{
    [self.operationQueue setMaxConcurrentOperationCount:maxConcurrent];
    [self.delegeteQueue setMaxConcurrentOperationCount:maxConcurrent];
}


-(SQDownload*)dowloadWithDownload:(SQDownload*)download
{
    self.delegate.downloads[@(download.downloadTask.taskIdentifier)] = download;
    if (self.startImmediatly) {
        [download.downloadTask resume];
    }

//    SQDownloadOperation * downloadOperation = [[SQDownloadOperation alloc] initWithDownload:download];
//    downloadOperation.name = [NSString stringWithFormat:@"%ld",download.downloadTask.taskIdentifier];
//    [self.operationQueue addOperation:downloadOperation];
    return download;
}

-(SQDownload*)downloadFileAtURL:(NSURL*)url toDirectory:(NSURL*)directory withName:(NSString*)name andDelegate:(id<SQDownloadDelegate>)delegate
{
    NSURLSessionDownloadTask * downloadTask = nil;
//    NSData * resumeData = [self checkLocalResumdatatoDirectory:directory withName:name];
    NSData * resumeData = [self checkResumDataWithKey:url toDirectory:directory withName:name];
    if (resumeData) {
//        if (IS_IOS10ORLATER) {
//            downloadTask = [self.session downloadTaskWithCorrectResumeData:self.resumeData];
//        } else {
            downloadTask = [self.session downloadTaskWithResumeData:resumeData];
//        }
    }else{
        downloadTask = [self.session downloadTaskWithURL:url];
    }
    SQDownload * download = [[SQDownload alloc] initWithTask:downloadTask toDirectory:directory fileName:name delegate:delegate];
    return [self dowloadWithDownload:download];
}

-(NSData*)checkResumDataWithKey:(NSURL*)url toDirectory:(NSURL*)directory withName:(NSString*)name
{
    NSData * resumeData = self.delegate.resumeDatas[url.absoluteString];
    if (resumeData) {
        resumeData = self.delegate.resumeDatas[url.absoluteString];
    }else{
    //获取已下载的Data
        //文件路径
        NSString *filePath = [directory.absoluteString stringByAppendingPathComponent:[@"tmp_" stringByAppendingString:name]];
        resumeData = [NSData dataWithContentsOfFile:filePath];
        //更新任务 DownloadTask每次进行断点续传的时候,会根据data文件中的”路径Key”去寻找下载文件,然后校验后再根据”Range”属性去进行断点续传。
    }
    return resumeData;
}

-(SQDownload*)downloadFileAtURL:(NSURL*)url toDirectory:(NSURL*)directory withName:(NSString*)name progression:(ProgressionHandlerType)progressionHandler completion:(CompletionHandlerType)completionHandler  isReStart:(BOOL)restart
{
    NSURLSessionDownloadTask * downloadTask = nil;
    if (restart) {
        downloadTask = [self.session downloadTaskWithURL:url];
    }else{

    NSData * resumeData = [self checkResumDataWithKey:url toDirectory:directory withName:name];
    if (resumeData) {
//        if (IS_IOS10ORLATER) {
//            downloadTask = [self.session downloadTaskWithCorrectResumeData:self.resumeData];
//        } else {
            downloadTask = [self.session downloadTaskWithResumeData:resumeData];
//        }
    }else{
        downloadTask = [self.session downloadTaskWithURL:url];
    }}
    SQDownload * download = [[SQDownload alloc] initWithTask:downloadTask toDirectory:directory fileName:name progression:progressionHandler completion:completionHandler];
    
    return [self dowloadWithDownload:download];
}

-(SQDownload*)downloadFileWithResumeData:(NSData*)resumeData toDirectory:(NSURL*)directory withName:(NSString*)name andDelegate:(id<SQDownloadDelegate>)delegate
{
    NSURLSessionDownloadTask * downloadTask = [self.session downloadTaskWithResumeData:resumeData];
    SQDownload * download = [[SQDownload alloc] initWithTask:downloadTask toDirectory:directory fileName:name delegate:delegate];
    
    return [self dowloadWithDownload:download];
}

-(NSArray<SQDownload*>*)currentDownloadsFilteredByState:(NSURLSessionTaskState)state{
    NSMutableArray* downloads = [NSMutableArray new];
    for (SQDownload* download in self.delegate.downloads) {
        if (download.downloadTask.state == state) {
            [downloads addObject:download];
        }
    }
    
    return downloads;
}

-(void)cancelDownload:(SQDownload*)download WithResumeData:( void (^ _Nullable )(NSData * _Nullable resumeData))completionHandler
{
    [download cancelWithResumeData:completionHandler];
//    for (SQDownloadOperation *downloadOperation in [self.operationQueue operations]) {
//        if ([downloadOperation.name integerValue] == download.downloadTask.taskIdentifier) {
//            [downloadOperation cancelWithResumeData:completionHandler];
//        }
//    }
}

-(void)suspendDownload:(SQDownload*)download
{
    for (SQDownloadOperation *downloadOperation in [self.operationQueue operations]) {
        if ([downloadOperation.name integerValue] == download.downloadTask.taskIdentifier) {
            [downloadOperation suspend];
        }
    }
}


-(void)cancelOperationWith:(NSUInteger)taskID
{
    for (SQDownloadOperation *downloadOperation in [self.operationQueue operations]) {
        if ([downloadOperation.name integerValue] == taskID) {
            [downloadOperation cancel];
        }
    }
}

-(void)resumeDownload:(SQDownload*)download
{
    SQDownloadOperation * downloadOperation = [[SQDownloadOperation alloc] initWithDownload:download];
    downloadOperation.name = [NSString stringWithFormat:@"%ld",download.downloadTask.taskIdentifier];
    [self.operationQueue addOperation:downloadOperation];
}

- (void)cancelAllDownloadsAndRemoveFiles:(BOOL)remove
{
    if (remove) {
        [self cancelAllDownloadsAndRemoveFiles];
    }else{
        [self cancelWithResumeData:nil];
    }
}

-(void)cancelAllDownloadsAndRemoveFiles
{
    for (SQDownload * download in self.delegate.downloads) {
        [download cancel];
        
    }
}

-(void)cancelWithResumeData:(void (^ _Nullable)(NSData * _Nullable resumeData))completionHandler{
    for (SQDownload * download in [self.delegate.downloads allValues]) {
        if (download && download.downloadTask) {
            if (download.downloadTask.state == NSURLSessionTaskStateRunning) {
                [download cancelWithResumeData:completionHandler];
            }
        }
    }
}

- (void)cancelDownload:(SQDownload*)download andRemoveFile:(BOOL)remove
{
    [download cancel];
    [download removeDownloadFile];
}
@end




@implementation SessionDelegate


-(instancetype)init
{
    self = [super init];
    if (self) {
        self.downloads = [NSMutableDictionary new];
        self.resumeDatas = [NSMutableDictionary new];
    }
    
    return self;
}

-(BOOL)validateResponse:(NSHTTPURLResponse*)response
{
    return NO;
}


- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    NSString * str = [NSString stringWithFormat:@"Resume at offset: %lld total expected: %lld",fileOffset,expectedTotalBytes];
    NSLog(@"%@", str);
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    SQDownload * download = self.downloads[@(downloadTask.taskIdentifier)];
//    [download writeCacheData:downloadTask.];
    
    CGFloat progress = totalBytesExpectedToWrite == NSURLSessionTransferSizeUnknown? -1:(CGFloat)(totalBytesWritten)/(totalBytesExpectedToWrite);//
    download.progress = progress;
    if (bytesWritten == totalBytesWritten) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([download.delegate respondsToSelector:@selector(download:didProgress:totalBytesWritten:totalBytesExpectedToWrite:)]) {
            [download.delegate download:download didProgress:progress totalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
        }else{
            if (download.progressionHandler) {
                download.progressionHandler(progress, totalBytesWritten, totalBytesExpectedToWrite);
            }
        }
        return ;
    });
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    SQDownload* download = self.downloads[@(downloadTask.taskIdentifier)];
    if (!download) {
        return;
    }
    NSError* fileError;
    NSURL * resultingURL;
    NSURL * destinationURL = download.destinationURL;
    if ([[NSFileManager defaultManager] replaceItemAtURL:destinationURL withItemAtURL:location backupItemName:nil options:0 resultingItemURL:&resultingURL error:&fileError]) {
        download.resultingURL = resultingURL;
        [download finish];
    }else{
        download.error = fileError;
    }
//    [[SQDownloadManager sharedInstance] cancelOperationWith:downloadTask.taskIdentifier];
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)sessionError
{
    SQDownload * download = self.downloads[@(task.taskIdentifier)];
    NSError * error = sessionError ? :download.error;
    if (error) {
        // check if resume data are available
        if ([error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData]) {
            NSData *resumeData = [error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData];
            //通过之前保存的resumeData，获取断点的NSURLSessionTask，调用resume恢复下载
            self.resumeDatas[error.userInfo[NSErrorFailingURLStringKey]] = resumeData;
            [[SQDownloadManager sharedInstance] cancelOperationWith:task.taskIdentifier];
        }else{
            if (error.code == -999) {
                return;
            }else if (error.code == 2){
                
            }
            [self completeRefresh:download didFinishWithError:error atLocation:download.resultingURL task:task];
        }
        
    }else{
        [self completeRefresh:download didFinishWithError:error atLocation:download.resultingURL task:task];
    }
}

-(void)completeRefresh:(SQDownload* _Nullable)download didFinishWithError:(NSError* _Nullable)error atLocation:(NSURL* _Nullable)location task:(NSURLSessionTask *)task
{
    if (!download) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([download.delegate respondsToSelector:@selector(download:didFinishWithError:atLocation:)]) {
            [download.delegate download:download didFinishWithError:error atLocation:download.resultingURL];
        }else{
            download.completionHandler(error, download.resultingURL);
        }
        [[SQDownloadManager sharedInstance] cancelOperationWith:task.taskIdentifier];
        [self.downloads removeObjectForKey:@(task.taskIdentifier)];
        return ;
    });

}

-(void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
    if (self.backCompletionHandler) {
        self.backCompletionHandler();   
    }
}


-(NSDictionary*)parseResumeDataToDic:(NSData*)resumeData
{
    if (!resumeData) {
        return nil;
    }
    NSError * error = nil;
    NSPropertyListFormat plistFormat = NSPropertyListXMLFormat_v1_0;
    NSDictionary* dic = [NSPropertyListSerialization propertyListWithData:resumeData options:0 format:&plistFormat error:&error];
    //    NSLog(@"dic:%@",dic);
    NSString * appCaches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString * tmpFileName = [dic valueForKey:@"NSURLSessionResumeInfoTempFileName"];
    NSString * downloadTmpDir = @"/com.apple.nsurlsessiond/Downloads/com.snailvr.glasswork/";
    
    NSString * filePath = [[appCaches stringByAppendingString:downloadTmpDir] stringByAppendingString:tmpFileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSLog(@"tmpFile exists:%@",tmpFileName);
        return dic;
    }
    NSError * filerResumeDataWriteError;
    BOOL result = [resumeData writeToFile:filePath options:NSDataWritingAtomic error:&filerResumeDataWriteError];
    NSLog(@"rewriteTmp:%@ result:%d",error,result);
    return dic;
}
@end

