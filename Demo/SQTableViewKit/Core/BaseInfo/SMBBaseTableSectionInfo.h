//
//  DTPBaseTableDelegateInfo.h
//  DTPocket
//
//  Created by sqb on 15/3/11.
//  Copyright (c) 2015年 sqp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMBBaseTableHeadViewInfo.h"
#import "SMBBaseTableFootViewInfo.h"

@interface SMBBaseTableSectionInfo : NSObject
@property SMBBaseTableHeadViewInfo * headViewInfo;
@property SMBBaseTableFootViewInfo * footViewInfo;
@property NSMutableArray * cellDataArray;
@property BOOL isOpen;
@end
