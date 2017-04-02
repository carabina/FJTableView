//
//  FJTableView+FJRefresh.m
//  FJDemo
//
//  Created by Jeff on 2017/4/1.
//  Copyright © 2017年 Jeff. All rights reserved.
//

#import "FJTableView+FJRefresh.h"

@implementation FJTableView (FJRefresh)

// 结束header的加载
- (void)header_endRefreshing {
    [(PeapotRefreshHeader*)self.tableView.mj_header endRefreshing];
}

// 结束footer最后一页的加载（有HintView）
- (void)footer_endRefreshingWithNoMoreData {
    
    if ([[self tableView].mj_footer isKindOfClass:[PeapotRefreshBackFooter class]]) {
        [(PeapotRefreshBackFooter*)self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else if ([[self tableView].mj_footer isKindOfClass:[PeapotRefreshAutoFooter class]]) {
        [(PeapotRefreshAutoFooter*)self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

// 结束footer最后一页的加载（无HintView）
- (void)footer_endRefreshingWithNoMoreDataNoHint {
    if ([[self tableView].mj_footer isKindOfClass:[PeapotRefreshBackFooter class]]) {
        [(PeapotRefreshBackFooter*)self.tableView.mj_footer endRefreshingWithNoMoreDataNoHint];
    }else if ([[self tableView].mj_footer isKindOfClass:[PeapotRefreshAutoFooter class]]) {
        [(PeapotRefreshAutoFooter*)self.tableView.mj_footer endRefreshingWithNoMoreDataNoHint];
    }
    
}

// 结束footer加载
- (void)footer_endRefreshing {
    
    if ([[self tableView].mj_footer isKindOfClass:[PeapotRefreshBackFooter class]]) {
        [(PeapotRefreshBackFooter*)self.tableView.mj_footer endRefreshing];
    }else if ([[self tableView].mj_footer isKindOfClass:[PeapotRefreshAutoFooter class]]) {
        [(PeapotRefreshAutoFooter*)self.tableView.mj_footer endRefreshing];
    }
    
}

// 重置footer状态
- (void)footer_resetState {
    
    if ([[self tableView].mj_footer isKindOfClass:[PeapotRefreshBackFooter class]]) {
        [(PeapotRefreshBackFooter*)self.tableView.mj_footer resetFooterState];
    }else if ([[self tableView].mj_footer isKindOfClass:[PeapotRefreshAutoFooter class]]) {
        [(PeapotRefreshAutoFooter*)self.tableView.mj_footer resetFooterState];
    }
    
}

@end
