//
//  SQTableViewDelegate.m
//  SQTableViewKit
//
//  Created by qbshen on 16/6/15.
//  Copyright © 2016年 qbshen. All rights reserved.
//

#import "SQTableViewDelegate.h"

@interface SQTableViewDelegate ()
@property NSMutableDictionary *mOriginDic;
@end
@implementation SQTableViewDelegate

#pragma mark loadDataBlock
-(void)loadData:(NSDictionary *(^)()) loadDataBlock
{
    self.mOriginDic = [loadDataBlock() mutableCopy];
}

-(NSString*)kSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"%ld",(long)section];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.mOriginDic.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SQTableViewSectionInfo * sectionInfo = [self.mOriginDic valueForKey:[self kSection:section]];
    return sectionInfo.cellDataArray.count;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SQTableViewSectionInfo * sectionInfo = [self.mOriginDic valueForKey:[self kSection:indexPath.section]];
    SQTableViewBaseCellInfo * cellInfo = sectionInfo.cellDataArray[indexPath.row];
    cellInfo.indexPath = indexPath;
    SQTableViewBaseCell * cell = (SQTableViewBaseCell *)[tableView dequeueReusableCellWithIdentifier:cellInfo.cellNibName? cellInfo.cellNibName:cellInfo.cellClassName];
    if (nil == cell) {
        cell = [self cellForSection:cellInfo tableView:tableView];
    }
    [cell fillData:cellInfo];
    return (UITableViewCell *)cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.didScrollBlock) {
        self.didScrollBlock();
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.didEndScrollBlock) {
        self.didEndScrollBlock();
    }
}

-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sectionTitles;
}

#pragma mark--
#pragma mark cell for section delegate
-(SQTableViewBaseCell*)cellForSection:(SQTableViewBaseInfo *)cellInfo tableView:(UITableView*)tableView
{
    SQTableViewBaseCell* cell ;
    NSString * nibName = cellInfo.cellNibName;
    NSString * className = cellInfo.cellClassName;
    if (nibName) {
        cell = [self loadNibCellWithNibName:nibName tableView:tableView reuseIdentifier:nibName];
    }else
    {
        cell = [[NSClassFromString(className) alloc]initWithStyle:cellInfo.cellStyle reuseIdentifier:className];
    }
    return cell;
}

-(SQTableViewBaseCell*)loadNibCellWithNibName:(NSString*)nibName tableView:(UITableView *)tableView reuseIdentifier:(NSString*)reuseId
{
    UINib * nib = [UINib nibWithNibName:nibName bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:reuseId];
    return (SQTableViewBaseCell*)[tableView dequeueReusableCellWithIdentifier:reuseId];
}

#pragma mark --
#pragma mark View for head
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SQTableViewSectionInfo * sectionInfo = [self.mOriginDic valueForKey:[self kSection:section]];
    SQTableViewHeadViewInfo * viewInfo = sectionInfo.headViewInfo;
    SQTableViewBaseCell * cell = (SQTableViewBaseCell *)[tableView dequeueReusableCellWithIdentifier:viewInfo.cellNibName? viewInfo.cellNibName:viewInfo.cellClassName];
    if (nil == cell) {
        cell = [self cellForSection:viewInfo tableView:tableView];
    }
    [cell fillData:viewInfo];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    SQTableViewSectionInfo * sectionInfo = [self.mOriginDic valueForKey:[self kSection:section]];
    SQTableViewFootViewInfo * viewInfo = sectionInfo.footViewInfo;
    SQTableViewBaseCell * cell = (SQTableViewBaseCell *)[tableView dequeueReusableCellWithIdentifier:viewInfo.cellNibName? viewInfo.cellNibName:viewInfo.cellClassName];
    if (nil == cell) {
        cell = [self cellForSection:viewInfo tableView:tableView];
    }
    [cell fillData:viewInfo];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SQTableViewSectionInfo * sectionInfo = [self.mOriginDic valueForKey:[self kSection:indexPath.section]];
    SQTableViewBaseCellInfo * cellInfo = sectionInfo.cellDataArray[indexPath.row];
    return  cellInfo.cellHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    SQTableViewSectionInfo * sectionInfo = [self.mOriginDic valueForKey:[self kSection:section]];
    SQTableViewHeadViewInfo * viewInfo = sectionInfo.headViewInfo;
    return  viewInfo.cellHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    SQTableViewSectionInfo * sectionInfo = [self.mOriginDic valueForKey:[self kSection:section]];
    SQTableViewFootViewInfo * viewInfo = sectionInfo.footViewInfo;
    return  viewInfo.cellHeight;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UITableViewCellEditingStyleDelete) {
        SQTableViewSectionInfo * sectionInfo = [self.mOriginDic valueForKey:[self kSection:indexPath.section]];
        SQTableViewBaseCellInfo * cellInfo = sectionInfo.cellDataArray[indexPath.row];
        if (cellInfo.willDeleteBlock) {
            cellInfo.willDeleteBlock(cellInfo);
        }
        [sectionInfo.cellDataArray removeObject:cellInfo];
    }
    [tableView reloadData];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.canEdit;
}

@end

@implementation SQTableViewBaseInfo

@end
@implementation SQTableViewHeadViewInfo

@end
@implementation SQTableViewFootViewInfo

@end
@implementation SQTableViewSectionInfo

@end

@implementation SQTableViewBaseCellInfo

@end
@implementation SQTableViewBaseCell

-(void)fillData:(SQTableViewBaseInfo*)info
{
    NSAssert(YES, @"must ovrried in sub class");
}

-(void)updateTableView:(SQTableViewBaseInfo*)info animal:(UITableViewRowAnimation)animal
{
    [(UITableView*)(self.superview.superview) reloadRowsAtIndexPaths:@[info.indexPath] withRowAnimation:animal];
}
@end

