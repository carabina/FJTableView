//
//  NSMutableArray+FJTableView.h
//  FJTableView
//
//  Created by Jeff on 2017/4/2.
//  Copyright © 2017年 Jeff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (FJTableView)

// 数据源中删除某个数据
- (void)removeDataSource:(id)dataSource;

// 数据源中添加数据源
- (void)insertDataSource:(id)dataSource at:(id)aDataSource append:(BOOL)append;

@end
