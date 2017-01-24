//
//  DTPBaseTableCellInfo.h
//  DTPocket
//
//  Created by sqb on 15/3/11.
//  Copyright (c) 2015年 sqp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SMBBaseTableCellInfo : NSObject
@property NSString * cellNibName;
@property NSString * cellClassName;
@property UITableViewCellStyle cellStyle;
@property NSInteger cellIndex;
@property NSInteger sectionIndex;
@property id VCDelegate;
@property (copy) void(^gotoNextBlock)(id);
@property (copy) BOOL(^willDeleteBlock)(id);

@property CGFloat cellHeight;
@end
