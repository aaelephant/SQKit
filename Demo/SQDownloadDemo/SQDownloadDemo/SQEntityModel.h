//
//  SQEntityModel.h
//  SQDownloadDemo
//
//  Created by qbshen on 2017/1/19.
//  Copyright © 2017年 qbshen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQDownload.h"

typedef NS_ENUM(NSInteger, SQDownloadStatus) {
    SQDownloadStatusUNKnow = 1<<0,
    SQDownloadStatusReady = 1<<1,
    SQDownloadStatusPause = 1<<2,
    SQDownloadStatusDownloading = 1<<3,
    SQDownloadStatusDown = 1<<4,
    SQDownloadStatusFail = 1<<5,
};

@interface SQEntityModel : NSObject

@property (nonatomic) NSString * uuid;
@property (nonatomic) NSString * downloadUrl;
@property (nonatomic) NSString * descr;
@property (nonatomic) NSString * pathToFile;
@property (nonatomic) float progress;
@property (nonatomic) SQDownloadStatus status;

@property (nonatomic) BOOL restart;
@property (nonatomic) SQDownload* downloader;

@property (nonatomic) UILabel * progressL;

+ (NSString*)pathToDL:(SQEntityModel *)model;
@end
