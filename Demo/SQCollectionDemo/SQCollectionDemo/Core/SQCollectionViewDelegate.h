//
//  SQCollectionViewDelegate.h
//  SQCollectionDemo
//
//  Created by qbshen on 16/6/14.
//  Copyright © 2016年 qbshen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SQCollectionViewBaseInfo : NSObject
@property NSString * cellNibName;
@property NSString * cellClassName;
@property NSInteger cellIndex;
@property (copy) void(^gotoNextBlock)(id);

@end

@interface SQCollectionViewHeadViewInfo : SQCollectionViewBaseInfo

@end
@interface SQCollectionViewFootViewInfo : SQCollectionViewBaseInfo

@end

@interface SQCollectionViewSectionInfo : NSObject
@property SQCollectionViewHeadViewInfo * headViewInfo;
@property SQCollectionViewFootViewInfo * footViewInfo;
@property NSMutableArray * cellDataArray;
@property BOOL isOpen;

@end

@interface SQCollectionViewBaseCell : UICollectionViewCell
-(void)fillData:(SQCollectionViewBaseInfo*)info;
@end

@interface SQCollectionViewDelegate : NSObject<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
-(void)loadData:(NSDictionary *(^)()) loadDataBlock;
@end
