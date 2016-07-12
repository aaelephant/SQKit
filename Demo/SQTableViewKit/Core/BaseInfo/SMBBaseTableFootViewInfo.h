//
//  SMBBaseTableFootViewInfo.h
//  SMBTableViewDemo
//
//  Created by sqb on 15/3/18.
//  Copyright (c) 2015年 sqp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SMBBaseTableFootViewInfo : NSObject
@property NSString * cellNibName;
@property NSString * cellClassName;
@property UITableViewCellStyle cellStyle;
@property NSInteger cellIndex;
@property id VCDelegate;
@property (copy) void(^gotoNextBlock)(id);
@end
