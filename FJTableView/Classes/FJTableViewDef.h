//
//  FJTableViewDef.h
//  baijie
//
//  Created by Fu Jie on 16/1/25.
//  Copyright © 2016年 Jeff. All rights reserved.
//

#ifndef FJTableViewDef_h
#define FJTableViewDef_h

/*****************
 *  Common Part  *
 *****************/

#define NOT_FOUND_INDEX (-1)

typedef NS_ENUM(NSInteger, FJ_CellEditingStyle)
{
    FJ_CellEditingStyle_None,                        // 无编辑
    FJ_CellEditingStyle_Deletion_Explicit,           // 显式删除
    FJ_CellEditingStyle_Deletion_Swipe,              // 滑动删除
    FJ_CellEditingStyle_Deletion_ExplicitWConfirm,   // 显式删除(确认是否删除)
    FJ_CellEditingStyle_Deletion_SwipeWConfirm,      // 滑动删除(确认是否删除)
    FJ_CellEditingStyle_Insert,                      // 插入
    FJ_CellEditingStyle_MultiSelection,              // 多选
    FJ_CellEditingStyle_Move                         // 移动
};

typedef NS_ENUM(NSInteger,FJ_CellDeletion_Policy)
{
    FJ_CellDeletion_Policy_Remove,   // (默认)删除数据源， removed from tbDataSource
    FJ_CellDeletion_Policy_Hidden,   // 隐藏，disableVisible = YES
};

typedef NS_ENUM(NSInteger,FJ_CellTapEffect)
{
    FJ_CellTapEffect_None,          // cell没有选中效果
    FJ_CellTapEffect_Customized     // cell的选中效果是自定义的
};

typedef void(^FJTableViewRefreshBlock)(void);

/********************
 *  Addtional Part  *
 ********************/

typedef NS_ENUM(NSInteger,FJ_CellBlockType)
{
    // Tap
    FJ_CellBlockType_CellTapped,            // Cell被触击
    FJ_CellBlockType_CellCustomizedTapped,  // Cell上的控件被触击
    FJ_CellBlockType_CellDeleted,           // Cell被删除（滑动删除、显式删除）
    FJ_CellBlockType_CellDeletedWConfirm,   // Cell被删除（滑动删除、显式删除前确认）
    FJ_CellBlockType_CellInserted,          // Cell被添加（添加的内容需要自己添加）
    FJ_CellBlockType_CellMultiSelected,     // Cell被多选（或取消多选）
    FJ_CellBlockType_CellMoved,             // Cell被移动
};

typedef NS_ENUM(NSInteger, FJ_ScrollBlockType) {
    // Scroll
    FJ_ScrollBlockType_Scroll,
    FJ_ScrollBlockType_Scroll_RefreshingView_Up_Height,
    FJ_ScrollBlockType_Scroll_LoadingView_Down_Height,
    FJ_ScrollBlockType_Scroll_Moving_Up_Height,
    FJ_ScrollBlockType_Scroll_Moving_Down_Height,
    FJ_ScrollBlockType_Scroll_Drag_Will_Begin,
    FJ_ScrollBlockType_Scroll_Drag_Did_End,
    FJ_ScrollBlockType_Scroll_Decelerating_Will_Begin,
    FJ_ScrollBlockType_Scroll_Decelerating_Did_End,
};

@class FJCellDataSource;

//#pragma mark - Deprecated
//@protocol FJTableViewDelegate<NSObject>
//
//@optional
//#pragma mark - Cell Action (代理)
//// cell的点击事件
//- (void)fj_tableViewDidSelect:(NSInteger)row section:(NSInteger)section cellData:(__kindof FJCellDataSource*)cellData DEPRECATED_MSG_ATTRIBUTE("Use the CellActionBlock.");
//// cell 和 header view 的自定义响应事件
//- (void)fj_tableViewCustomAction:(NSInteger)row section:(NSInteger)section cellData:(__kindof id)cellData DEPRECATED_MSG_ATTRIBUTE("Use the CellActionBlock.");
//// cell的复选事件
//- (void)fj_tableViewDidMultiSelect:(NSInteger)row section:(NSInteger)section cellData:(__kindof FJCellDataSource*)cellData DEPRECATED_MSG_ATTRIBUTE("Use the CellActionBlock.");
//// cell的删除事件
//- (void)fj_tableViewDidDeleteRow:(NSInteger)row section:(NSInteger)section cellData:(__kindof FJCellDataSource*)cellData DEPRECATED_MSG_ATTRIBUTE("Use the CellActionBlock.");
//// cell的插入事件
//- (void)fj_tableViewDidInsertRow:(NSInteger)row section:(NSInteger)section cellData:(__kindof FJCellDataSource*)cellData DEPRECATED_MSG_ATTRIBUTE("Use the CellActionBlock.");
//
//#pragma mark - ScrollView Action (代理)
//// 重写滚动事件（完全交付子类完成自定义的处理方式）
//- (void)fj_scrollViewDidScroll:(UIScrollView *)scrollView DEPRECATED_MSG_ATTRIBUTE("Use the CellScrollBlock.");
//// 重写往上滚动具体距离(进入Refreshing的状态)
//- (void)fj_scrollViewRefreshingHeader:(UIScrollView *)scrollView height:(CGFloat)height DEPRECATED_MSG_ATTRIBUTE("Use the CellScrollBlock.");
//// 重写往下滚动具体距离（进入LoadingMore的状态）
//- (void)fj_scrollViewLoadingMore:(UIScrollView *)scrollView height:(CGFloat)height DEPRECATED_MSG_ATTRIBUTE("Use the CellScrollBlock.");
//// 重写往上滚动(正常范围内，两个临界值之间的非重新加载和加载更多区域)
//- (void)fj_scrollView:(UIScrollView *)scrollView up:(CGFloat)height DEPRECATED_MSG_ATTRIBUTE("Use the CellScrollBlock.");
//// 重写往下滚动(正常范围内，两个临界值之间的非重新加载和加载更多区域)
//- (void)fj_scrollView:(UIScrollView *)scrollView down:(CGFloat)height DEPRECATED_MSG_ATTRIBUTE("Use the CellScrollBlock.");
//// 重写拖拽事件（开始拖拽）
//- (void)fj_scrollViewWillBeginDragging:(UIScrollView *)scrollView DEPRECATED_MSG_ATTRIBUTE("Use the CellScrollBlock.");
//// 重写拖拽事件（结束拖拽）
//- (void)fj_scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate DEPRECATED_MSG_ATTRIBUTE("Use the CellScrollBlock.");
//// 重写开始减速事件
//- (void)fj_scrollViewWillBeginDecelerating:(UIScrollView *)scrollView DEPRECATED_MSG_ATTRIBUTE("Use the CellScrollBlock.");
//// 重写结束减速事件
//- (void)fj_scrollViewDidEndDecelerating:(UIScrollView *)scrollView DEPRECATED_MSG_ATTRIBUTE("Use the CellScrollBlock.");
//
//@end

typedef void (^CellActionBlock)(FJ_CellBlockType type, NSInteger row, NSInteger section, __kindof FJCellDataSource* cellData);
typedef void (^CellScrollBlock)(FJ_ScrollBlockType type, UIScrollView *scrollView, CGFloat height, BOOL willDecelerate);

#endif /* FJTableViewDef_h */
