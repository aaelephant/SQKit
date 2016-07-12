//
//  SQCollectionViewDelegate.m
//  SQCollectionDemo
//
//  Created by qbshen on 16/6/14.
//  Copyright © 2016年 qbshen. All rights reserved.
//

#import "SQCollectionViewDelegate.h"


@interface SQCollectionViewDelegate ()
@property NSMutableDictionary *mOriginDic;

@end
@implementation SQCollectionViewDelegate

#pragma mark loadDataBlock
-(void)loadData:(NSDictionary *(^)()) loadDataBlock
{
    self.mOriginDic = [loadDataBlock() mutableCopy];
}

-(NSString*)kSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"%ld",(long)section];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.mOriginDic.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    SQCollectionViewSectionInfo * sectionInfo = [self.mOriginDic valueForKey:[self kSection:section]];
    return sectionInfo.cellDataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SQCollectionViewSectionInfo * sectionInfo = [self.mOriginDic valueForKey:[self kSection:indexPath.section]];
    SQCollectionViewBaseInfo * cellInfo = sectionInfo.cellDataArray[indexPath.row];
    SQCollectionViewBaseCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellInfo.cellNibName? cellInfo.cellNibName:cellInfo.cellClassName forIndexPath:indexPath];
    [cell fillData:cellInfo];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SQCollectionViewSectionInfo * sectionInfo = [self.mOriginDic valueForKey:[self kSection:indexPath.section]];
    SQCollectionViewBaseInfo * cellInfo = sectionInfo.cellDataArray[indexPath.row];
    if (cellInfo.gotoNextBlock) {
        cellInfo.gotoNextBlock(cellInfo);
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 100);
}



@end

@implementation SQCollectionViewBaseInfo

@end
@implementation SQCollectionViewHeadViewInfo

@end
@implementation SQCollectionViewFootViewInfo

@end
@implementation SQCollectionViewSectionInfo

@end
@implementation SQCollectionViewBaseCell

-(void)fillData:(SQCollectionViewBaseInfo*)info
{
    NSAssert(YES, @"must ovrried in sub class");
}

@end
