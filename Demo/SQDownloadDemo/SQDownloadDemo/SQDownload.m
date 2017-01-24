//
//  SQDownloadTask.m
//  SQDownloadDemo
//
//  Created by qbshen on 2017/1/20.
//  Copyright © 2017年 qbshen. All rights reserved.
//


#import "SQDownload.h"


@interface SQDownload ()

@property (nonatomic, copy, readwrite) NSURL *downloadURL;
@property (nonatomic, copy, readwrite) NSString *fileName;

@property (nonatomic) NSURL * directory;

@end
@implementation SQDownload
#pragma mark - Init

-(instancetype _Nullable)initWithTask:(NSURLSessionDownloadTask* _Nullable)downloadTask toDirectory:(NSURL* _Nullable)directory fileName:(NSString* _Nullable)fileName delegate:(id<SQDownloadDelegate> _Nullable)delegate
{
    self = [super init];
    if (self) {
        _downloadTask = downloadTask;
        self.directory = directory;
        self.fileName = fileName;
        _delegate = delegate;
    }
    return self;
}

-(instancetype _Nullable)initWithTask:(NSURLSessionDownloadTask* _Nullable)downloadTask toDirectory:(NSURL* _Nullable)directory fileName:(NSString* _Nullable)fileName progression:(ProgressionHandlerType)progressHandler
                   completion:(CompletionHandlerType)completeHandler
{
    self = [super init];
    if (self) {
        _downloadTask = downloadTask;
        self.directory = directory;
        self.fileName = fileName;
        _progressionHandler = progressHandler;
        _completionHandler = completeHandler;
    }
    return self;
}

-(NSURL *)destinationURL
{
    NSURL *destinationPath = self.directory? :[NSURL fileURLWithPath:NSTemporaryDirectory()];
    
    return [NSURL URLWithString:self.fileName relativeToURL:destinationPath].URLByStandardizingPath;
}


-(void)cancel
{
    _state = SQDownloadStateCancelled;
    [self cancelWithResumeData:nil];
}


-(void)suspend
{
    _state = SQDownloadStatePause;
    [self.downloadTask suspend];
}

-(void)resume
{
    _state = SQDownloadStateDownloading;
    [self.downloadTask resume];
}

-(void)finish
{
    _state = SQDownloadStateDone;
    [self removeCacheDataWhenComplete];
}

-(void)cancelWithResumeData:(void (^ _Nullable)(NSData * _Nullable resumeData))completionHandler{
//    __weak typeof(self) weakSelf = self;
    [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
//        _resumeData = resumeData;
//        [weakSelf writeCacheData:resumeData];
        if (completionHandler) {
            completionHandler(resumeData);
        }
    }];
}

-(BOOL)writeCacheData:(NSData*)resumeData
{
    BOOL result = NO;
    if (resumeData != nil) {
        //文件路径
        NSString *filePath = [self.directory.absoluteString stringByAppendingPathComponent:[@"tmp_" stringByAppendingString:self.fileName]];
        //删除上次中断保存的Data
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:filePath error:nil];
        //重新保存Data
        NSError * filerResumeDataWriteError;
         result = [resumeData writeToFile:filePath options:NSDataWritingWithoutOverwriting error:&filerResumeDataWriteError];
        NSLog(@"resumeData svae : %@ result:%d",filerResumeDataWriteError.userInfo,result);
    }
    return result;
}


-(BOOL)removeCacheDataWhenComplete
{
    BOOL result = NO;
    NSString *filePath = [self.directory.absoluteString stringByAppendingPathComponent:[@"tmp_" stringByAppendingString:self.fileName]];
    //删除上次中断保存的Data
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:filePath error:nil];
    return result;
}

-(BOOL)removeDownloadFile
{
    BOOL result = NO;
    NSString *filePath = [self.directory.absoluteString stringByAppendingPathComponent:[@"" stringByAppendingString:self.fileName]];
    //删除上次中断保存的Data
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:filePath error:nil];
    return result;
}

-(void)dealloc{
    NSLog(@"%@ dealloc called",[self class]);
}
@end

