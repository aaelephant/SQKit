//
//  SQDownloadTask.h
//  SQDownloadDemo
//
//  Created by qbshen on 2017/1/20.
//  Copyright © 2017年 qbshen. All rights reserved.
//

#import <Foundation/Foundation.h>



/**
 The current state of the download.
 
 @since 1.5.2
 */
typedef NS_ENUM(NSUInteger, SQDownloadState) {
    SQDownloadStateReady = 0,
    
    SQDownloadStatePause,
    
    SQDownloadStateDownloading,
    /** The download has been completed successfully. */
    SQDownloadStateDone,
    /** The download has been cancelled manually. */
    SQDownloadStateCancelled,
    /** The download failed, probably because of an error. It is possible to access the error in the appropriate delegate method or block property. */
    SQDownloadStateFailed
};

typedef void(^ProgressionHandlerType)(float  progress, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite);
typedef void(^CompletionHandlerType)(NSError* _Nullable error, NSURL* _Nullable location);

@protocol SQDownloadDelegate;

@interface SQDownload : NSObject

@property (nonatomic) float progress;
@property (nonatomic, readonly) SQDownloadState state;

@property (nonatomic, readonly) NSURLSessionDownloadTask * _Nullable downloadTask;
@property (nonatomic, readonly) NSData * _Nullable resumeData;
// Blocks
@property (nonatomic, copy, readonly) id<SQDownloadDelegate> _Nullable delegate;
@property (nonatomic, copy, readonly) ProgressionHandlerType _Nullable progressionHandler;
@property (nonatomic, copy, readonly) CompletionHandlerType _Nullable completionHandler;
@property (nonatomic, copy, readonly) NSURL * _Nullable destinationURL;
@property (nonatomic, copy) NSURL * _Nullable resultingURL;
@property (nonatomic, copy) NSError* _Nullable error;

-(instancetype _Nullable)initWithTask:(NSURLSessionDownloadTask* _Nullable)downloadTask toDirectory:(NSURL* _Nullable)directory fileName:(NSString* _Nullable)fileName delegate:(id<SQDownloadDelegate> _Nullable)delegate;


-(instancetype _Nullable)initWithTask:(NSURLSessionDownloadTask* _Nullable)downloadTask toDirectory:(NSURL* _Nullable)directory fileName:(NSString* _Nullable)fileName progression:(ProgressionHandlerType _Nullable)progressHandler
                 completion:(CompletionHandlerType _Nullable)completeHandler;

/**
 Cancel a download. The download cannot be resumed after calling this method.
 
 :see: `NSURLSessionDownloadTask -cancel`
 */
-(void)cancel;

/**
 Suspend a download. The download can be resumed after calling this method.
 
 :see: `TCBlobDownload -resume`
 :see: `NSURLSessionDownloadTask -suspend`
 */
-(void)suspend;

/**
 Resume a previously suspended download. Can also start a download if not already downloading.
 
 :see: `NSURLSessionDownloadTask -resume`
 */

-(void)resume;
/**
 Cancel a download and produce resume data. If stored, this data can allow resuming the download at its previous state.
 
 :see: `TCBlobDownloadManager -downloadFileWithResumeData`
 :see: `NSURLSessionDownloadTask -cancelByProducingResumeData`
 
 :param: completionHandler A completion handler that is called when the download has been successfully canceled. If the download is resumable, the completion handler is provided with a resumeData object.
 */

-(void)finish;

-(void)cancelWithResumeData:( void (^ _Nullable )(NSData * _Nullable resumeData))completionHandler;
-(BOOL)removeDownloadFile;
@end

@protocol SQDownloadDelegate <NSObject>

/**
 Periodically informs the delegate that a chunk of data has been received (similar to `NSURLSession -URLSession:dataTask:didReceiveData:`).
 
 :see: `NSURLSession -URLSession:dataTask:didReceiveData:`
 
 :param: download The download that received a chunk of data.
 :param: progress The current progress of the download, between 0 and 1. 0 means nothing was received and 1 means the download is completed.
 :param: totalBytesWritten The total number of bytes the download has currently written to the disk.
 :param: totalBytesExpectedToWrite The total number of bytes the download will write to the disk once completed.
 */

-(void)download:( SQDownload* _Nullable )download didProgress:(float)progress totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite;

/**
 Informs the delegate that the download was completed (similar to `NSURLSession -URLSession:task:didCompleteWithError:`).
 
 :see: `NSURLSession -URLSession:task:didCompleteWithError:`
 
 :param: download The download that received a chunk of data.
 :param: error An eventual error. If `nil`, consider the download as being successful.
 :param: location The location where the downloaded file can be found.
 */

-(void)download:(SQDownload* _Nullable)download didFinishWithError:(NSError* _Nullable)error atLocation:(NSURL* _Nullable)location;

@end
