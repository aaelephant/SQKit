//
//  TableViewController.m
//  SQTableViewKit
//
//  Created by qbshen on 16/6/15.
//  Copyright © 2016年 qbshen. All rights reserved.
//

#import "TableViewController.h"
#import "SQTableViewDelegate.h"

@interface TableViewController ()

@property SQTableViewDelegate * mDelegate;
@property NSMutableDictionary * originDic;
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestInfo];
}

-(void)requestInfo
{
    if (!self.originDic) {
        self.originDic = [[NSMutableDictionary alloc]init];
    }
    self.mDelegate = [SQTableViewDelegate new];
    self.mDelegate.canEdit = YES;
    self.tableView.delegate = self.mDelegate;
    self.tableView.dataSource = self.mDelegate;
    [self.originDic setValue:[self getDefaultSectionInfo] forKey:@"0"];
    [self.mDelegate loadData:^NSDictionary *{
        return self.originDic;
    }];
    [self.tableView reloadData];
}


-(SQTableViewSectionInfo*)getDefaultSectionInfo
{
    SQTableViewSectionInfo * sectionInfo = [[SQTableViewSectionInfo alloc]init];
    NSMutableArray * cellInfoArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < 10; i++) {
        
        SQTableViewBaseCellInfo *cellInfo = [[SQTableViewBaseCellInfo alloc]init];
        cellInfo.cellClassName = @"SQTableViewCell";
        cellInfo.cellHeight = 60;
        cellInfo.gotoNextBlock=^(id args){
            NSLog(@"@@");
        };
        [cellInfoArray addObject:cellInfo];
    }
    sectionInfo.cellDataArray = cellInfoArray;
    return sectionInfo;
}

@end
