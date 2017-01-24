//
//  SQDownloadOperation.m
//  SQDownloadDemo
//
//  Created by qbshen on 2017/1/22.
//  Copyright © 2017年 qbshen. All rights reserved.
//

#import "SQDownloadOperation.h"

//状态枚举
typedef NS_ENUM(NSInteger, ConcurrentOperationState) {
    ConcurrentOperationReadyState = 1,
    ConcurrentOperationExecutingState,
    ConcurrentOperationFinishedState
};

@interface SQDownloadOperation ()

@property (nonatomic, assign, readwrite) ConcurrentOperationState state;
@property (nonatomic, assign, getter=isOperationStarted) BOOL operationStarted;

@property (nonatomic) SQDownload * download;

@end
@implementation SQDownloadOperation

-(instancetype)initWithDownload:(SQDownload*)download
{
    self = [super init];
    if (self) {
        self.download = download;
    }
    return self;
}

-(void)cancelWithResumeData:( void (^ _Nullable )(NSData * _Nullable resumeData))completionHandler
{
    [self.download cancelWithResumeData:completionHandler];
    [self cancel];
}

-(void)suspend
{
    [self.download suspend];
    [self cancel];
}

-(void)cancel
{
    if (self.state == ConcurrentOperationExecutingState) {
        //kvo：结束
        [self willChangeValueForKey:@"isFinished"];
        self.state = ConcurrentOperationFinishedState;
        [self didChangeValueForKey:@"isFinished"];
        
        NSLog(@"finished :%@",self);
    }
}

-(void)start
{
    if (!self.isFinished) {
        [self.download resume];
        //kvo：正在执行
        [self willChangeValueForKey:@"isExecuting"];
        self.state = ConcurrentOperationExecutingState;
        [self didChangeValueForKey:@"isExecuting"];
        NSLog(@"start :%@",self);
    }
}

- (BOOL)isReady {
    self.state = ConcurrentOperationReadyState;
    return self.state == ConcurrentOperationReadyState;
}
- (BOOL)isExecuting{
    return self.state == ConcurrentOperationExecutingState;
}
- (BOOL)isFinished{
    return self.state == ConcurrentOperationFinishedState;
}

-(void)dealloc{
    NSLog(@"dealloc called");
}
@end
