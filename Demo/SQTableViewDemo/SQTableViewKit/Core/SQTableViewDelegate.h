//
//  SQTableViewDelegate.h
//  SQTableViewKit
//
//  Created by qbshen on 16/6/15.
//  Copyright © 2016年 qbshen. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SQTableViewBaseInfo : NSObject
@property NSString * cellNibName;
@property NSString * cellClassName;
@property UITableViewCellStyle cellStyle;
@property NSIndexPath *indexPath;
@property (copy) void(^gotoNextBlock)(id);
@property CGFloat cellWidth;
@property CGFloat cellHeight;

@end

@interface SQTableViewHeadViewInfo : SQTableViewBaseInfo

@end
@interface SQTableViewFootViewInfo : SQTableViewBaseInfo

@end

@interface SQTableViewSectionInfo : NSObject
@property SQTableViewHeadViewInfo * headViewInfo;
@property SQTableViewFootViewInfo * footViewInfo;
@property NSMutableArray * cellDataArray;
@property BOOL isOpen;

@end

@interface SQTableViewBaseCellInfo : SQTableViewBaseInfo
@property (copy) BOOL(^willDeleteBlock)(id);
@end
@interface SQTableViewBaseCell : UITableViewCell
-(void)fillData:(SQTableViewBaseInfo*)info;
-(void)updateTableView:(SQTableViewBaseInfo*)info animal:(UITableViewRowAnimation)animal;
@end

@interface SQTableViewDelegate : NSObject<UITableViewDelegate,UITableViewDataSource>
@property (copy) void(^didScrollBlock)();
@property (copy) void(^didEndScrollBlock)();
@property BOOL canEdit;
@property NSMutableArray * sectionTitles;

-(void)loadData:(NSDictionary *(^)()) loadDataBlock;

@end
