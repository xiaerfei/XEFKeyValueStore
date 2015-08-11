//
//  ViewController.m
//  XEFKeyValueStore
//
//  Created by xiaerfei on 15/8/7.
//  Copyright (c) 2015年 RongYu100. All rights reserved.
//

#import "ViewController.h"
#import "XEFKeyValueStore.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    XEFKeyValueStore *store = [[XEFKeyValueStore alloc] initDBWithName:@"test.db"];
    [store createTableWithName:@"userInfo"];
    [store putObject:@{@"username":@"hahaha",@"age":@"26",@"sex":@"boy"} withId:@"user" intoTable:@"userInfo"];
    NSDictionary *dict = [store getObjectById:@"user" fromTable:@"userInfo"];
    NSLog(@"%@",dict);
    [store putObject:@{@"username":@"lalal",@"age":@"26",@"sex":@"boy"} withId:@"user" intoTable:@"userInfo"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
