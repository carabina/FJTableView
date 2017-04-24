//
//  IndexesTableViewController.m
//  FJTableView
//
//  Created by Jeff on 2017/4/24.
//  Copyright © 2017年 Jeff. All rights reserved.
//

#import "IndexesTableViewController.h"
#import "IndexesHeaderView.h"
#import "IndexesCell.h"
#import "FJTableView.h"
#import <Toast/UIView+Toast.h>

@interface IndexesTableViewController ()

@property (nonatomic, strong) FJTableView *tableView;
@property (nonatomic, strong) NSMutableArray *indexes;

@end

@implementation IndexesTableViewController

- (NSMutableArray *)indexes {
    if (_indexes == nil) {
        _indexes = [NSMutableArray array];
        for (int i = 'A'; i < 'A'+26; i++) {
            [_indexes addObject:[NSString stringWithFormat:@"%c", i]];
        }
    }
    return _indexes;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
    
    self.view.backgroundColor = [UIColor whiteColor];
    FJTableView *tableView = [FJTableView FJTableView:self.view.bounds editStyle:0 seperatorStyle:0 bgColor:nil];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    
    
    [tableView setCellActionBlock:^(FJ_CellBlockType type, NSInteger row, NSInteger section, __kindof FJCellDataSource *cellData) {
        
    }];
    
    
    tableView.tableView.sectionIndexColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0];
    tableView.tableView.sectionIndexBackgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    tableView.tableView.sectionIndexTrackingBackgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    [tableView setIndexesBlock:^NSArray *(FJTableView *tableView) {
        return weakSelf.indexes;
    }];
    
    [tableView setIndexBlock:^NSUInteger(NSString *title, NSUInteger index, FJTableView *tableView) {
        
        // create a new style
        CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
        
        // this is just one of many style options
        style.messageColor = [UIColor whiteColor];
        style.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.8];
        style.cornerRadius = 0.0;
        
        // present the toast with the new style
        [self.view makeToast:[NSString stringWithFormat:@"  %@  ",title]
                    duration:1.0
                    position:CSToastPositionCenter
                       style:style];
         [CSToastManager setSharedStyle:style];
        
        // toggle "tap to dismiss" functionality
        [CSToastManager setTapToDismissEnabled:YES];
        
        // toggle queueing behavior
        [CSToastManager setQueueEnabled:NO];
        
        return index;
    }];
    
    [self renderUI];
    
}

- (void)renderUI {
    for (NSString * index in self.indexes) {
        FJMultiDataSource *mds = [[FJMultiDataSource alloc] init];
        mds.cellDataSources = (NSMutableArray<FJCellDataSource> *)[NSMutableArray array];
        
        IndexesHeaderViewDataSource *hds = [[IndexesHeaderViewDataSource alloc] init];
        hds.index = index;
        mds.headerViewDataSource = hds;
        
        for (int i = 0; i < 10; i++) {
            IndexesCellDataSource *ds = [[IndexesCellDataSource alloc] init];
            ds.name = [NSString stringWithFormat:@"%@ %d",index, i+1];
            [mds.cellDataSources addObject:ds];
        }
        
        [self.tableView addDataSource:mds];
    }
    
    [self.tableView refresh];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
