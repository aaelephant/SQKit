//
//  DTPNewGroupDelegate.h
//  DTPocket
//
//  Created by sqb on 15/3/11.
//  Copyright (c) 2015年 sqp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SMBBaseTableInfo,SMBBaseTableCellInfo;
@protocol SMBTableCellOnClickLister;


@interface SMBTableViewDelegate : NSObject<UITableViewDataSource,UITableViewDelegate>

@property UIView * v;
@property (copy) void(^didScrollBlock)();
@property (copy) void(^didEndScrollBlock)();
//+(instancetype)shareInstance;
@property BOOL canEdit;
@property NSMutableArray * sectionTitles;

-(void)loadData:(NSDictionary *(^)()) loadDataBlock;
//-(void)changeToGroup:(BOOL)isGroup;
-(void)changeToResponseDelegate:(UIViewController<SMBTableCellOnClickLister>*)delegate;
-(SMBBaseTableCellInfo*)getCellInfoWithIndexPath:(NSIndexPath *)indexPath;
@end

@protocol SMBTableCellOnClickLister <NSObject>

-(void)onClickRowCell:(SMBBaseTableInfo*)info;

@end