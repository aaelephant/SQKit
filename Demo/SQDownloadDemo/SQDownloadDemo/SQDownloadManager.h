//
//  SQDownloadManager.h
//  SQDownloadDemo
//
//  Created by qbshen on 2017/1/20.
//  Copyright © 2017年 qbshen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQDownload.h"

/**
 When a download fails because of an HTTP error, the HTTP status code is transmitted as an `NSNumber` via the provided `NSError` parameter of the corresponding block or delegate method. Access to `error.userInfos[TCBlobDownloadErrorHTTPStatusKey]`
 
 @see -download:didStopWithError:
 
 @since 1.5.0
 */

/**
 TCBlobDownload specific errors
 
 @since 2.1.0
 */

extern NSString * const kSQDownloadSessionIdentifier ;

extern NSString * const kSQDownloadErrorDomain ;
extern NSString * const kSQDownloadErrorDescriptionKey ;
extern NSString * const kSQDownloadErrorHTTPStatusKey ;
extern NSString * const kSQDownloadErrorFailingURLKey ;


/**
 The possible error codes for a `TCBlobDownloader` operation. When an error block or the corresponding delegate method are called, an `NSError` instance is passed as parameter. If the domain of this `NSError` is TCBlobDownload's, the `code` parameter will be set to one of these values.
 
 @since 1.5.0
 */
typedef NS_ENUM(NSUInteger, SQDownloadError) {
    /** `NSURLConnection` was unable to handle the provided request. */
    SQDownloadErrorInvalidURL = 0,
    /** The connection encountered an HTTP error. Please refer to `TCHTTPStatusCode` documentation for further details on how to handle such errors. */
    SQDownloadErrorHTTPError,
    /** The device has not enough free disk space to download the file. */
    SQDownloadErrorNotEnoughFreeDiskSpace
};

@interface SQDownloadManager : NSObject
+ (instancetype)sharedInstance;

-(void)setBackCompletionHandler:(void (^)())backCompletionHandler;
- (void)setMaxConcurrentDownloads:(NSInteger)maxConcurrent;
-(SQDownload*)downloadFileAtURL:(NSURL*)url toDirectory:(NSURL*)directory withName:(NSString*)name andDelegate:(id<SQDownloadDelegate>)delegate;
-(SQDownload*)downloadFileAtURL:(NSURL*)url toDirectory:(NSURL*)directory withName:(NSString*)name progression:(ProgressionHandlerType)progressionHandler completion:(CompletionHandlerType)completionHandler isReStart:(BOOL)restart;

-(SQDownload*)downloadFileWithResumeData:(NSData*)resumeData toDirectory:(NSURL*)directory withName:(NSString*)name andDelegate:(id<SQDownloadDelegate>)delegate;

-(NSArray<SQDownload*>*)currentDownloadsFilteredByState:(NSURLSessionTaskState)state;

-(void)suspendDownload:(SQDownload*)download;
-(void)cancelDownload:(SQDownload*)download WithResumeData:( void (^ _Nullable )(NSData * _Nullable resumeData))completionHandler;
-(void)resumeDownload:(SQDownload* _Nullable)download;
- (void)cancelAllDownloadsAndRemoveFiles:(BOOL)remove;
- (void)cancelDownload:(SQDownload*)download andRemoveFile:(BOOL)remove;
@end
