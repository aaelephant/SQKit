//
//  SQDownloadOperation.h
//  SQDownloadDemo
//
//  Created by qbshen on 2017/1/22.
//  Copyright © 2017年 qbshen. All rights reserved.
//

#import "SQDownload.h"

@interface SQDownloadOperation : NSOperation
-(instancetype _Nullable)initWithDownload:(SQDownload* _Nullable)download;
-(void)cancelWithResumeData:( void (^ _Nullable )(NSData * _Nullable resumeData))completionHandler;
-(void)suspend;
@end
