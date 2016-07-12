//
//  DTPBaseTableInfo.h
//  DTPocket
//
//  Created by sqb on 15/3/11.
//  Copyright (c) 2015年 sqp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMBBaseTableSectionInfo.h"

@interface SMBBaseTableInfo : NSObject
@property UITableView * tableView;
@property NSIndexPath * indexPath;
@property NSInteger section;
@property SMBBaseTableSectionInfo * delegateInfo;
@property UIViewController * viewController;



@end
