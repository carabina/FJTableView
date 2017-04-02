//
//  PageTableViewController.m
//  FJTableView
//
//  Created by Jeff on 2017/4/2.
//  Copyright © 2017年 Jeff. All rights reserved.
//

#import "PageTableViewController.h"
#import "FJTableView.h"
#import "FJTableView+FJRefresh.h"
#import "FeedsCell.h"

@interface PageTableViewController ()

@property (nonatomic, strong) FJTableView *tableView;
@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, assign) NSUInteger allpage;

@end

@implementation PageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [FJTableView FJTableView:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) editStyle:0 seperatorStyle:0 bgColor:[UIColor whiteColor]];
    [self.view addSubview:self.tableView];
    
    // 一维
    // 初始化一些公共参数(背景色、NavBar等)
    self.tableView.fj_editingStyle = FJ_CellEditingStyle_None;
    self.tableView.fj_cellAnimation = UITableViewRowAnimationFade;
    self.tableView.fj_cellDeletionPolicy = FJ_CellDeletion_Policy_Remove;
    self.tableView.fj_cellSeperatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.fj_disableCellReuse = NO;
    self.tableView.fj_view_bgColor = nil;
    self.tableView.fj_tableView_bgColor = nil;
    
    
    // Load Data
    [self loadDataFirstPage];
    
    __weak typeof(self) weakSelf = self;
    // Add Refresh Header / Footer
    id header = [PeapotRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf loadDataFirstPage];
    }];
    
    id footer = [PeapotRefreshBackFooter
                 footerWithHintViewXib:nil
                 hintViewHeight:0
                 refreshingBlock:^{
                     [weakSelf loadData:weakSelf.page + 1 finished:^(NSUInteger page, NSUInteger allpage, BOOL success, NSString *errmsg) {
                         if (success) {
                             weakSelf.page = page;
                             weakSelf.allpage = allpage;
                             
                             if (weakSelf.page == weakSelf.allpage - 1) {
                                 // 最后一页
                                 [weakSelf.tableView footer_endRefreshingWithNoMoreData];
                             }else{
                                 [weakSelf.tableView footer_endRefreshing];
                             }
                             
                         }else{
                             NSLog(@"%@",errmsg);
                         }
                     }];
                 }];
    
    [self.tableView tableView].mj_header = header;
    [self.tableView tableView].mj_footer = footer;
    
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFStringRef runLoopMode = kCFRunLoopCommonModes;
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler
    (kCFAllocatorDefault, kCFRunLoopBeforeWaiting, true, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity _) {
        // TODO here
        NSLog(@"空闲.......");
    });
    CFRunLoopAddObserver(runLoop, observer, runLoopMode);
}

- (void)loadDataFirstPage {
    __weak typeof(self) weakSelf = self;
    [self loadData:0 finished:^(NSUInteger page, NSUInteger allpage, BOOL success, NSString *errmsg) {
        if (success) {
            weakSelf.page = page;
            weakSelf.allpage = allpage;
            [weakSelf.tableView header_endRefreshing];
            [weakSelf.tableView footer_resetState];
            
        }else{
            NSLog(@"%@",errmsg);
        }
    }];
}

- (void)loadData:(NSUInteger)page finished:(void(^)(NSUInteger page, NSUInteger allpage, BOOL success, NSString *errmsg))finished {
    

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        static NSUInteger _simulatedPage    = 0;
        static NSUInteger _simulatedAllpage = 0;
        
        if (page == 0) {
            [[self.tableView dataSource] removeAllObjects];
            
            _simulatedPage = 0;
            _simulatedAllpage = 3;
        }else{
            _simulatedPage += 1;
        }
        
        FeedsCellDataSource *feedsDataSource = [[FeedsCellDataSource alloc] init];
        feedsDataSource.name = [NSString stringWithFormat:@"Page:%d Index 0",(int)page];
        feedsDataSource.cover_url = @"https://cdn.55haitao.com/bbs/data/attachment/deal/2017/02/22/483d1e393338c3de061e747ea3245b31.jpg";
        [self.tableView addDataSource:feedsDataSource];
        
        feedsDataSource = [[FeedsCellDataSource alloc] init];
        feedsDataSource.name = [NSString stringWithFormat:@"Page:%d Index 1",(int)page];
        feedsDataSource.cover_url = @"https://cdn.55haitao.com/bbs/data/attachment/deals/2017/02/22/20170222122636_06426.jpg";
        [self.tableView addDataSource:feedsDataSource];
        
        feedsDataSource = [[FeedsCellDataSource alloc] init];
        feedsDataSource.name = [NSString stringWithFormat:@"Page:%d Index 2",(int)page];
        feedsDataSource.cover_url = @"https://cdn.55haitao.com/bbs/data/attachment/deals/2017/02/22/20170222122601_87880.png";
        [self.tableView addDataSource:feedsDataSource];
        
        feedsDataSource = [[FeedsCellDataSource alloc] init];
        feedsDataSource.name = [NSString stringWithFormat:@"Page:%d Index 3",(int)page];
        feedsDataSource.cover_url = @"https://cdn.55haitao.com/bbs/data/attachment/deals/2017/02/22/20170222124636_84621.jpg";
        [self.tableView addDataSource:feedsDataSource];
        
        feedsDataSource = [[FeedsCellDataSource alloc] init];
        feedsDataSource.name = [NSString stringWithFormat:@"Page:%d Index 4",(int)page];
        feedsDataSource.cover_url = @"https://cdn.55haitao.com/bbs/data/attachment/deals/2017/02/22/20170222124537_36446.jpg";
        [self.tableView addDataSource:feedsDataSource];
        
        feedsDataSource = [[FeedsCellDataSource alloc] init];
        feedsDataSource.name = [NSString stringWithFormat:@"Page:%d Index 5",(int)page];
        feedsDataSource.cover_url = @"https://cdn.55haitao.com/bbs/data/attachment/deals/2017/02/22/20170222122603_86809.png";
        [self.tableView addDataSource:feedsDataSource];
        
        [self.tableView refresh];
        
        finished == nil ? : finished(_simulatedPage, _simulatedAllpage, YES, nil);
    });
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
