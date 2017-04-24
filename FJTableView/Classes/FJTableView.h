//
//  FJTableView.h
//  haitao
//
//  Created by Jeff on 15/7/22.
//  Copyright (c) 2015年 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FJTableViewDef.h"
#import "FJMultiDataSource.h"

@interface FJTableView : UIView

/*******************************
 *     FJTableView Data定义    *
 *******************************/
/**
 * [Optional] 
 * Cell编辑式样
 * 默认是FJ_CellEditingStyle_None
 */
@property (nonatomic, assign) FJ_CellEditingStyle fj_editingStyle;

/**
 * [Optional] 
 * Cell的分割属性
 * 默认UITableViewCellSeparatorStyleNone
 */
@property (nonatomic, assign) UITableViewCellSeparatorStyle fj_cellSeperatorStyle;

/**
 * [Optional]
 * Cell插入、删除等刷新的动画
 * 默认UITableViewRowAnimationFade
 */
@property (nonatomic, assign) UITableViewRowAnimation fj_cellAnimation;

/**
 * [Optional] 
 * 背景颜色 - View
 * 默认nil
 */
@property (nonatomic, strong) UIColor *fj_view_bgColor;

/**
 * [Optional] 
 * 背景颜色 - TableView
 * 默认nil
 */
@property (nonatomic, strong) UIColor *fj_tableView_bgColor;

/**
 * [Optional] 
 * 是否禁止复用Cell
 * 默认NO
 */
@property (nonatomic, assign) BOOL fj_disableCellReuse;

/**
 * [Optional] 
 * Cell删除策略
 * 默认是FJ_CellDeletion_Policy_Hidden
 */
@property (nonatomic, assign) FJ_CellDeletion_Policy fj_cellDeletionPolicy;

/*************************
 *   生成 - Table/Data   *
 *************************/
// 生成FJTableView（默认）
+ (FJTableView*)defaultFJTableView;

// 生成FJTableView（自定义）
+ (FJTableView*)FJTableView:(CGRect)frame editStyle:(FJ_CellEditingStyle)editStyle seperatorStyle:(UITableViewCellSeparatorStyle)seperatorStyle bgColor:(UIColor*)bgColor;

// 获取TableView
- (UITableView *)tableView;

// 获取数据源
- (NSMutableArray *)dataSource;

// 设置数据源
- (void)setDataSource:(NSMutableArray *)dataSource;

// 添加数据
- (void)addDataSource:(id)cellDataSource;

// 重新刷新数据源
- (void)refresh;


/*************************
 *  回调 - Delegate/Block *
 *************************/
// 设置点击事件的Block
- (void)setCellActionBlock:(CellActionBlock)cellActionBlock;

// 设置滚动事件的Block
- (void)setCellScrollBlock:(CellScrollBlock)cellScrollBlock;

// 设置Indexes数组，return list of section titles to display in section index view (e.g. "ABCD...Z#")
- (void)setIndexesBlock:(IndexesBlock)indexesBlock;

// 设置点击Index返回Section位置，tell table which section corresponds to section title/index (e.g. "B",1))
- (void)setIndexBlock:(IndexBlock)indexBlock;


/*************************
 *  Operation - 伸缩、滚动 *
 *************************/
// 延伸Cell
- (void)extend:(__kindof FJCellDataSource*)cellData;

// 收缩Cell
- (void)collapse:(__kindof FJCellDataSource*)cellData;

// 自动伸缩Cell
- (void)autoExtendAndCollapse:(__kindof FJCellDataSource*)cellData;

// 滚动到某个indexPath
- (void)scrollToIndexPath:(NSIndexPath*)indexPath position:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated;

// 滚动到某个FJCellDataSource
- (void)scrollToCellDataSource:(__kindof FJCellDataSource*)cellDataSource position:(UITableViewScrollPosition)position animated:(BOOL)animated;

// 滚动到第一个CellDataSource的类型
- (void)scrollToTheFirstCellClass:(Class)dataSourceClass position:(UITableViewScrollPosition)position animated:(BOOL)animated;


/******************************
 *           内部方法          *
 ******************************/
// 根据DataSource获得Cell
- (id)cellForDataSource:(__kindof FJCellDataSource*)cellDataSource;

@end
