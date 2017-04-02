//
//  NSMutableArray+FJTableView.m
//  FJTableView
//
//  Created by Jeff on 2017/4/2.
//  Copyright © 2017年 Jeff. All rights reserved.
//

#import "NSMutableArray+FJTableView.h"
#import "FJCell.h"
#import "FJMultiDataSource.h"

@implementation NSMutableArray (FJTableView)

// 数据源中删除某个数据
- (void)removeDataSource:(id)dataSource {
    
    if ([self count] == 0) {
        return;
    }
    id ds = [self objectAtIndex:0];
    if ([ds isKindOfClass:[FJCellDataSource class]]) {
        
        [self removeObject:dataSource];
        
    }else if ([ds isKindOfClass:[FJMultiDataSource class]]) {
        
        id deletedmds = nil;
        for (FJMultiDataSource *mds in self) {
            if ([mds.cellDataSources containsObject:dataSource]) {
                [mds.cellDataSources removeObject:dataSource];
                if ([mds.cellDataSources count] == 0) {
                    deletedmds = mds;
                }
                break;
            }
        }
        if (deletedmds != nil) {
            [self removeObject:deletedmds];
        }
    }
}



// 数据源中添加数据源
- (void)insertDataSource:(id)dataSource at:(id)aDataSource append:(BOOL)append {
    if ([self count] == 0) {
        return;
    }
    id ds = [self objectAtIndex:0];
    if ([ds isKindOfClass:[FJCellDataSource class]]) {
       
        NSUInteger index = [self indexOfObject:aDataSource];
        if (!append) {
            [self insertObject:dataSource atIndex:index];
        }else{
            [self insertObject:dataSource atIndex:index+1];
        }
        
    }else if ([ds isKindOfClass:[FJMultiDataSource class]]) {
        
        for (FJMultiDataSource *mds in self) {
            if ([mds.cellDataSources containsObject:aDataSource]) {
                
                NSUInteger index = [mds.cellDataSources indexOfObject:aDataSource];
                if (!append) {
                    [mds.cellDataSources insertObject:dataSource atIndex:index];
                }else{
                    [mds.cellDataSources insertObject:dataSource atIndex:index+1];
                }
                
                break;
            }
        }
    }
}

@end
