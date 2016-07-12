//
//  DTPNewGroupCellCretaer.h
//  DTPocket
//
//  Created by sqb on 15/3/11.
//  Copyright (c) 2015年 sqp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SMBBaseTableInfo;

@interface SMBCellCreator : NSObject

+(instancetype)sharedInstance;
-(UITableViewCell *)getTableViewCell:(SMBBaseTableInfo *)createInfo;
-(UIView*)getHeadView:(SMBBaseTableInfo *)createInfo;
-(UIView*)getFootView:(SMBBaseTableInfo *)createInfo;
@end
