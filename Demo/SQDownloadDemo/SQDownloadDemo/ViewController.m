//
//  ViewController.m
//  SQDownloadDemo
//
//  Created by qbshen on 2017/1/19.
//  Copyright © 2017年 qbshen. All rights reserved.
//

#import "ViewController.h"
#import "SQMultiDownloadController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic) NSArray* functions;
@property (nonatomic) UITableView* tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
}

-(NSArray *)functions
{
    NSArray* cur = @[
             @"multi download",
             ];
    return cur;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.functions.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = @"";
    cell.detailTextLabel.text = self.functions[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row) {
        case 0:
            [self gotoMultiDownVC];
            break;
            
        default:
            break;
    }
    
}

-(void)gotoMultiDownVC
{
    SQMultiDownloadController * vc = [SQMultiDownloadController new];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
