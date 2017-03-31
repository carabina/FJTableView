//
//  FJMultiDataSource.h
//  Demo
//
//  Created by Fu Jie on 16/4/14.
//  Copyright © 2016年 Jeff. All rights reserved.
//

#import "FJHeaderView.h"
#import "FJCell.h"

@interface FJMultiDataSource : NSObject

@property (nonatomic, strong) __kindof FJHeaderViewDataSource  *headerViewDataSource;           /* Header View的DataSource */
@property (nonatomic, strong) NSMutableArray<FJCellDataSource> *cellDataSources;                /* Cell的DataSource数组 */

@end

@protocol FJMultiDataSource <NSObject>

@end
