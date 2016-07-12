//
//  DTPNewGroupDelegate.m
//  DTPocket
//
//  Created by sqb on 15/3/11.
//  Copyright (c) 2015年 sqp. All rights reserved.
//

#import "SMBTableViewDelegate.h"
#import "SMBBaseTableInfoHead.h"
#import "SMBCellCreator.h"

@interface SMBTableViewDelegate ()
@property BOOL isGroup;
@property id<SMBTableCellOnClickLister> onClickCellLister;
@property NSMutableDictionary * sectionDataDic;
@end

@interface SMBTableViewDelegate ()
@property UIViewController<SMBTableCellOnClickLister>* VCDelegate;

@end
@implementation SMBTableViewDelegate


-(void)changeToGroup:(BOOL)isGroup
{
    self.isGroup = isGroup;
}

-(void)changeToResponseDelegate:(UIViewController<SMBTableCellOnClickLister>*)delegate
{
    self.VCDelegate = delegate;
}



-(void)updateInfoDic:(NSDictionary*)infoDic
{
    self.sectionDataDic = [infoDic copy];
}

-(NSString*)kSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"%ld",(long)section];
}

#pragma mark view init for cell
-(UITableViewCell*)cellForTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMBBaseTableInfo * info =[self createSquareInfo:tableView indexPath:indexPath VCDelegate:self.VCDelegate];
    UITableViewCell* cell = [[SMBCellCreator sharedInstance] getTableViewCell:info];
    [cell addSubview:self.v];
    return cell;
}

#pragma mark --
#pragma mark View for head
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SMBBaseTableInfo * info = [self createSquareInfo:tableView section:section VCDelegate:self.VCDelegate];
    UIView * headView = [[SMBCellCreator sharedInstance] getHeadView:info];
    return headView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    SMBBaseTableInfo * info = [self createSquareInfo:tableView section:section VCDelegate:self.VCDelegate];
    UIView * footView = [[SMBCellCreator sharedInstance] getFootView:info];
    return footView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMBBaseTableInfo * info =[self createSquareInfo:tableView indexPath:indexPath VCDelegate:self.VCDelegate];
    UITableViewCell* cell = [[SMBCellCreator sharedInstance] getTableViewCell:info];
    SMBBaseTableCellInfo * cellInfo = [self getCellInfoWithIndexPath:indexPath];
    return  cellInfo.cellHeight == 0? cell.frame.size.height:cellInfo.cellHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    {
        SMBBaseTableInfo * info = [self createSquareInfo:tableView section:section VCDelegate:self.VCDelegate];
        UIView * headView = [[SMBCellCreator sharedInstance] getHeadView:info];
        return headView.frame.size.height;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    {
        SMBBaseTableInfo * info = [self createSquareInfo:tableView section:section VCDelegate:self.VCDelegate];
        UIView * footView = [[SMBCellCreator sharedInstance] getFootView:info];
        return footView.frame.size.height;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
    SMBBaseTableInfo * info =[self createSquareInfo:tableView indexPath:indexPath VCDelegate:self.VCDelegate];
    NSAssert(self.onClickCellLister != nil, @"onClickCellLister must not nil");
    if ([self.onClickCellLister respondsToSelector:@selector(onClickRowCell:)]) {
        NSLog(@"onClickRowCell");
        [self.onClickCellLister onClickRowCell:info];
    }else
    {
        NSAssert(self.onClickCellLister != nil, @"onClickCellLister must implement onClickRowCell: selector");
    }
}

#pragma mark --
#pragma mark create squareInfo
-(SMBBaseTableInfo*)createSquareInfo:(UITableView *)tableView indexPath:(NSIndexPath*)indexPath  VCDelegate:(id)VCDelegate
{
    SMBBaseTableInfo * info = [[SMBBaseTableInfo alloc]init];
    info.tableView = tableView;
    info.indexPath = indexPath;
    info.delegateInfo = [self.sectionDataDic valueForKey:[self kSection:indexPath.section]];
    info.viewController = self.VCDelegate;
    return info;
}

-(SMBBaseTableInfo*)createSquareInfo:(UITableView *)tableView section:(NSInteger )section  VCDelegate:(id)VCDelegate
{
    SMBBaseTableInfo * info = [[SMBBaseTableInfo alloc]init];
    info.tableView = tableView;
    info.section = section;
    info.delegateInfo = [self.sectionDataDic valueForKey:[self kSection:section]];
    info.viewController = self.VCDelegate;
    return info;
}
/***************************************/

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = [self.sectionDataDic count];
    return count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SMBBaseTableSectionInfo * rootInfo = [self.sectionDataDic valueForKey:[self kSection:section]];
    if (!rootInfo.isOpen) {
        return rootInfo.cellDataArray.count;
    }else
    {
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = nil;
    cell = [self cellForTableView:tableView cellForRowAtIndexPath:indexPath];
    return cell;
}


-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UITableViewCellEditingStyleDelete) {
        SMBBaseTableSectionInfo * rootInfo = [self.sectionDataDic valueForKey:[self kSection:indexPath.section]];
        SMBBaseTableCellInfo* cellInfo = rootInfo.cellDataArray[indexPath.row];
        if (cellInfo.willDeleteBlock) {
            if( cellInfo.willDeleteBlock(cellInfo))
                [rootInfo.cellDataArray removeObjectAtIndex:indexPath.row];
        }
    }
    [tableView reloadData];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.canEdit;
}
/***************************************/
-(SMBBaseTableCellInfo*)getCellInfoWithIndexPath:(NSIndexPath *)indexPath
{
    SMBBaseTableSectionInfo * sectionInfo = [self.sectionDataDic valueForKey:[self kSection:indexPath.section]];
    return [sectionInfo.cellDataArray objectAtIndex:indexPath.row];
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

//固定头部视图

@end



