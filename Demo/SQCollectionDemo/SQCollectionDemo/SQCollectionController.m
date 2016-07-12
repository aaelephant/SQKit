//
//  SQCollectionController.m
//  SQCollectionDemo
//
//  Created by qbshen on 16/6/13.
//  Copyright © 2016年 qbshen. All rights reserved.
//

#import "SQCollectionController.h"
#import "SQCollectionVCell.h"

@interface SQCollectionController ()
@property SQCollectionViewDelegate * mDelegate;
@property NSMutableDictionary * mOriginDic;
@end

@implementation SQCollectionController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDelegate];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.delegate = self.mDelegate;
    self.collectionView.dataSource = self.mDelegate;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:[SQCollectionVCell description] bundle:nil] forCellWithReuseIdentifier:[SQCollectionVCell description]];
    [self requestInfo];
}

-(void)initDelegate
{
    if (!self.mDelegate) {
        self.mDelegate = [SQCollectionViewDelegate new];
    }
}

-(void)requestInfo
{
    if (!self.mOriginDic) {
        self.mOriginDic = [NSMutableDictionary new];
    }
    [self.mOriginDic setValue:[self getDefaultSectionInfo] forKey:@"0"];
    [self.mDelegate loadData:^NSDictionary *{
        return self.mOriginDic;
    }];
    [self.collectionView reloadData];
}

-(SQCollectionViewSectionInfo*)getDefaultSectionInfo
{
    SQCollectionViewSectionInfo * sectionInfo = [SQCollectionViewSectionInfo new];
    
    NSMutableArray * cellInfos = [NSMutableArray new];
    SQCollectionVCellInfo * cellInfo = [SQCollectionVCellInfo new];
    cellInfo.cellNibName = [SQCollectionVCell description];
    cellInfo.gotoNextBlock = ^(SQCollectionViewBaseInfo* args){
        NSLog(@"kkk");
    };
    [cellInfos addObject:cellInfo];
    sectionInfo.cellDataArray = cellInfos;
    return sectionInfo;
}
@end
