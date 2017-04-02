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
#import "NSMutableArray+FJTableView.h"

typedef enum :NSInteger {
    kCameraMoveDirectionNone,
    kCameraMoveDirectionUp,
    kCameraMoveDirectionDown,
    kCameraMoveDirectionRight,
    kCameraMoveDirectionLeft
} CameraMoveDirection;

@interface DemoTableViewController() <UIScrollViewDelegate>

@property (nonatomic, strong) FJTableView *tableView;
@end

@implementation DemoTableViewController

- (void)viewDidLoad {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [super viewDidLoad];
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    self.tableView = [FJTableView FJTableView:CGRectMake(0, 0, size.width, size.height) editStyle:0 seperatorStyle:0 bgColor:nil];
    [self.view addSubview:self.tableView];
    
    // 初始化一些公共参数(背景色、NavBar等)
    self.tableView.fj_editingStyle = FJ_CellEditingStyle_Deletion_Swipe;
    self.tableView.fj_cellDeletionPolicy = FJ_CellDeletion_Policy_Remove;
    self.tableView.fj_disableCellReuse = NO;
    self.tableView.fj_view_bgColor = nil;
    self.tableView.fj_tableView_bgColor = nil;
    self.tableView.fj_cellAnimation = UITableViewRowAnimationFade;
    self.tableView.fj_cellSeperatorStyle = UITableViewCellSeparatorStyleNone;
    
    __block BOOL section;
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
//        section = YES;
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
//        for (int i = 0; i < 3; i++) {
//            FeedsCellDataSource *feedDataSource = [[FeedsCellDataSource alloc] init];
//            feedDataSource.name = [NSString stringWithFormat:@"%d", (int)i+1];
//            [multiDataSource.cellDataSources addObject:feedDataSource];
//        }
//        [weakSelf.tableView addDataSource:multiDataSource];
//        
//        // Section 3
//        multiDataSource = [[FJMultiDataSource alloc] init];
//        multiDataSource.cellDataSources = [[NSMutableArray<FJCellDataSource> alloc] init];
//        // Header
//        headerDataSource = [[FeedsHeaderViewDataSource alloc] init];
//        multiDataSource.headerViewDataSource = headerDataSource;
//        
//        for (int i = 0; i < 3; i++) {
//            FeedsCellDataSource *feedDataSource = [[FeedsCellDataSource alloc] init];
//            feedDataSource.name = [NSString stringWithFormat:@"%d", (int)i+1];
//            [multiDataSource.cellDataSources addObject:feedDataSource];
//        }
//        [weakSelf.tableView addDataSource:multiDataSource];
        
        section = NO; 
        for (int i = 0; i < 10; i++) {
            FeedsCellDataSource *feedDataSource = [[FeedsCellDataSource alloc] init];
            feedDataSource.name = [NSString stringWithFormat:@"%d", (int)i+1];
            [weakSelf.tableView addDataSource:feedDataSource];
        }
        
        [weakSelf.tableView refresh];
        
    });
    
    
    // Block
    [self.tableView setCellActionBlock:^(FJ_CellBlockType type, NSInteger row, NSInteger section, __kindof FJCellDataSource *cellData) {
        
        switch (type) {
            case FJ_CellBlockType_CellTapped:
            {
                NSLog(@"Cell Tapped");
                break;
            }
                
            case FJ_CellBlockType_CellCustomizedTapped:
            {
                if ([cellData isKindOfClass:[FeedsCellDataSource class]]) {
                    NSLog(@"Cell Clicked");
                }else if ([cellData isKindOfClass:[FeedsHeaderViewDataSource class]]) {
                    NSLog(@"Header Clicked");
                }
                break;
            }
                
            case FJ_CellBlockType_CellMultiSelected:
            {
                if (cellData.multiSelected) {
                    NSLog(@"Multi Selected");
                }else {
                    NSLog(@"Multi De-Selected");
                }
                break;
            }
                
            case FJ_CellBlockType_CellDeleted:
            {
                NSLog(@"Deleted");
                break;
            }
                
            case FJ_CellBlockType_CellDeletedWConfirm:
            {
                NSLog(@"Deleted W Confirm");
                
                [[weakSelf.tableView dataSource] removeDataSource:cellData];
                [weakSelf.tableView refresh];
                break;
            }
        
            case FJ_CellBlockType_CellInserted:
            {
                NSLog(@"Inserted");
                static int i = 1;
                FeedsCellDataSource *feedDataSource = [[FeedsCellDataSource alloc] init];
                feedDataSource.name = [NSString stringWithFormat:@"Insert(%d)", (int)i++];
                [[weakSelf.tableView dataSource] insertDataSource:feedDataSource at:cellData append:YES];
                [weakSelf.tableView refresh];
                break;
            }
                
            case FJ_CellBlockType_CellMoved:
            {
                NSLog(@"Moved");
                break;
            }
                
        }
    }];
    
    
    [self.tableView setCellScrollBlock:^(FJ_ScrollBlockType type, UIScrollView *scrollView, CGFloat height, BOOL willDecelerate) {
        NSLog(@"type = %d, height = %f", (int)type, height);
    }];
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
