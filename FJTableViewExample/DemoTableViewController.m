//
//  DemoTableViewController.m
//  Demo
//
//  Created by Fu Jie on 16/4/21.
//  Copyright © 2016年 Aichen. All rights reserved.
//

#import "DemoTableViewController.h"
#import <Masonry/Masonry.h>
#import "FeedsCell.h"
#import "BannerCell.h"
#import "FeedsHeaderView.h"

typedef enum :NSInteger {
    kCameraMoveDirectionNone,
    kCameraMoveDirectionUp,
    kCameraMoveDirectionDown,
    kCameraMoveDirectionRight,
    kCameraMoveDirectionLeft
} CameraMoveDirection;

@interface DemoTableViewController() <FJTableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) FJTableView *tableView;
@end

@implementation DemoTableViewController

- (void)viewDidLoad {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [super viewDidLoad];
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    self.tableView = [FJTableView FJTableView:CGRectMake(0, 0, size.width, size.height) allowMultiStyle:NO editStyle:0 seperateType:0 bgColor:nil delegate:self];
    [self.view addSubview:self.tableView];
    
    // 初始化一些公共参数(背景色、NavBar等)
    self.tableView.fj_allowMultiTableView = NO;
    self.tableView.fj_allowEditing = NO;
    self.tableView.fj_allowMoveCell = NO;
    self.tableView.fj_editingStyle = FJ_CellEditingStyle_Deletion;
    self.tableView.fj_cellDeletionPolicy = FJ_CellDeletion_Policy_Remove;
    self.tableView.fj_disableCellReuse = NO;
    self.tableView.fj_view_bgColor = nil;
    self.tableView.fj_tableView_bgColor = nil;
    self.tableView.fj_cellAnimation = UITableViewRowAnimationMiddle;
    self.tableView.fj_cellSeperateType = UITableViewCellSeparatorStyleNone;
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
//        // Section 1
//        FJMultiDataSource *multiDataSource = [[FJMultiDataSource alloc] init];
//        multiDataSource.cellDataSources = [[NSMutableArray<FJCellDataSource> alloc] init];
//        // Banner Cell
//        BannerCellDataSource *bannerDataSource = [[BannerCellDataSource alloc] init];
//        [multiDataSource.cellDataSources addObject:bannerDataSource];
//        [self.tableView addDataSource:multiDataSource];
//        
//        // Section 2
//        multiDataSource = [[FJMultiDataSource alloc] init];
//        multiDataSource.cellDataSources = [[NSMutableArray<FJCellDataSource> alloc] init];
//        // Header
//        FeedsHeaderViewDataSource *headerDataSource = [[FeedsHeaderViewDataSource alloc] init];
//        multiDataSource.headerViewDataSource = headerDataSource;
//        
//        for (int i = 0; i < 10; i++) {
//            FeedsCellDataSource *feedDataSource = [[FeedsCellDataSource alloc] init];
//            [multiDataSource.cellDataSources addObject:feedDataSource];
//        }
//        [weakSelf.tableView addDataSource:multiDataSource];
        
        for (int i = 0; i < 10; i++) {
            FeedsCellDataSource *feedDataSource = [[FeedsCellDataSource alloc] init];
            [weakSelf.tableView addDataSource:feedDataSource];
        }
        [weakSelf.tableView refresh];
        
    });
}

#pragma mark - delegate FJTableView
- (void)fj_tableViewCustomAction:(NSInteger)row section:(NSInteger)section cellData:(__kindof id)cellData {
    if ([cellData isKindOfClass:[FeedsCellDataSource class]]) {
        NSLog(@"Cell Clicked");
    }else if ([cellData isKindOfClass:[FeedsHeaderViewDataSource class]]) {
        NSLog(@"Header Clicked");
    }
}

- (void)fj_tableViewDidMultiSelect:(NSInteger)row section:(NSInteger)section cellData:(__kindof FJCellDataSource *)cellData {
    NSLog(@"Multi Clicked");
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
