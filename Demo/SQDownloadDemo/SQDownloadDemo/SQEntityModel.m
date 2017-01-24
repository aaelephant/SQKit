//
//  SQEntityModel.m
//  SQDownloadDemo
//
//  Created by qbshen on 2017/1/19.
//  Copyright © 2017年 qbshen. All rights reserved.
//

#import "SQEntityModel.h"

#define SQLibraryCache ([NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject])

#define SQVideoCachFloder (@"/videoCach/")

#define SQCocoaHttpServerRoot ([SQLibraryCache stringByAppendingString:SQVideoCachFloder])

@implementation SQEntityModel

+ (NSString*)pathToDL:(SQEntityModel *)model
{
    if (model.uuid.length == 0) {
        return nil;
    }
    NSString * path = [NSString pathWithComponents:@[SQCocoaHttpServerRoot,model.uuid]];
//    NSString * fileName = [[[[model.downloadUrl componentsSeparatedByString:@"?"] firstObject] componentsSeparatedByString:@"/"] lastObject];
    model.pathToFile = [NSString stringWithFormat:@"%@", path];

    return path;
}

-(NSString *)pathToFile
{
    if (self.uuid.length == 0) {
        NSAssert(YES, @"uuid is nil");
        return nil;
    }
    NSString * path = [NSString pathWithComponents:@[SQCocoaHttpServerRoot,[self.uuid stringByAppendingPathComponent:@"/result/"]]];
    return path;
}
@end
