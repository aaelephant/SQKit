//
//  ViewController.m
//  SQCollectionDemo
//
//  Created by qbshen on 16/6/13.
//  Copyright © 2016年 qbshen. All rights reserved.
//

#import "ViewController.h"
#import "SQCollectionController.h"
#import "SQCollectionDemo-Swift.h"

@interface ViewController ()
- (IBAction)onClick:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClick:(id)sender {
    SQCollectionController * vc = [[SQCollectionController alloc]initWithCollectionViewLayout:[UICollectionViewFlowLayout new]];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
