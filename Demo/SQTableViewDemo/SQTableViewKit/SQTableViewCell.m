//
//  SQTableViewCell.m
//  SQTableViewKit
//
//  Created by qbshen on 16/6/15.
//  Copyright © 2016年 qbshen. All rights reserved.
//

#import "SQTableViewCell.h"


@interface SQTableViewCell ()
@property SQTableViewBaseInfo * cellInfo;
@end
@implementation SQTableViewCell

-(void)fillData:(SQTableViewBaseInfo *)info
{
    self.cellInfo = info;
    self.textLabel.text = @"hahhaha";
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (selected) {
        self.cellInfo.cellHeight = 100;
        
        [self updateTableView:self.cellInfo animal:UITableViewRowAnimationNone];
    }
}


@end
