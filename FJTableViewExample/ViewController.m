//
//  ViewController.m
//  FJTableView
//
//  Created by Jeff on 2017/3/31.
//  Copyright © 2017年 Jeff. All rights reserved.
//

#import "ViewController.h"
#import "DemoTableViewController.h"
#import "PageTableViewController.h"

@interface ViewController ()

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

- (IBAction)tapDemo:(id)sender {
    DemoTableViewController *demoVC = [[DemoTableViewController alloc] init];
    [self.navigationController pushViewController:demoVC animated:YES];
}

- (IBAction)tapPage:(id)sender {
    PageTableViewController *pageVC = [[PageTableViewController alloc] init];
    [self.navigationController pushViewController:pageVC animated:YES];
}


@end
